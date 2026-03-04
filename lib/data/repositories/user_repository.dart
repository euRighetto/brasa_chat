import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../../models/app_user.dart';

class UserRepository {
  UserRepository(this._db);

  final FirebaseFirestore _db;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) {
    return _db.collection(FirestorePaths.users).doc(uid).get();
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await getUserDoc(uid);
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc.data()!, uid);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUsernameMapping(String normalizedUsername) {
    return _db.collection(FirestorePaths.usernames).doc(normalizedUsername).get();
  }

  Future<void> createUserAndUsernameMapping({
    required String uid,
    required String username,
    required String email,
  }) async {
    // Transaction keeps username unique under race conditions.
    await _db.runTransaction((tx) async {
      final uRef = _db.collection(FirestorePaths.usernames).doc(username);
      final uSnap = await tx.get(uRef);
      if (uSnap.exists) {
        throw StateError('Username already taken');
      }

      final userRef = _db.collection(FirestorePaths.users).doc(uid);
      tx.set(userRef, {
        'username': username,
        'email': email,
        'photoUrl': null,
        'bio': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.set(uRef, {
        'uid': uid,
        'email': email,
      });
    });
  }

  Future<void> updateUsername({
    required String uid,
    required String currentUsername,
    required String nextUsername,
    required String emailFallback,
  }) async {
    await _db.runTransaction((tx) async {
      final nextRef = _db.collection(FirestorePaths.usernames).doc(nextUsername);
      final nextSnap = await tx.get(nextRef);
      if (nextSnap.exists) {
        throw StateError('Username already taken');
      }

      // Create new mapping
      tx.set(nextRef, {
        'uid': uid,
        'email': emailFallback,
      });

      // Update users doc
      final userRef = _db.collection(FirestorePaths.users).doc(uid);
      tx.update(userRef, {
        'username': nextUsername,
      });

      // Remove old mapping
      if (currentUsername.isNotEmpty) {
        final currRef = _db.collection(FirestorePaths.usernames).doc(currentUsername);
        tx.delete(currRef);
      }
    });
  }
}
