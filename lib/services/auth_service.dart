import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/errors/app_exception.dart';
import '../core/utils/validators.dart';
import '../models/app_user.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';

/// Facade used by the UI.
///
/// Keep this API stable so screens don't break, while internally using
/// repositories + better validation/error mapping.
class AuthService {
  static final _authRepo = AuthRepository(FirebaseAuth.instance);
  static final _userRepo = UserRepository(FirebaseFirestore.instance);

  static Stream<User?> get authChanges => _authRepo.userChanges();
  static User? get currentUser => _authRepo.currentUser;

  /// Accepts either email or username.
  static Future<void> login(String emailOrUsername, String password) async {
    try {
      Validators.validatePassword(password);

      final input = emailOrUsername.trim();
      if (input.isEmpty) {
        throw AppException('Enter email or username');
      }

      String email = input;

      // If it doesn't look like an email, treat as username.
      if (!input.contains('@')) {
        final u = Validators.normalizeUsername(input);
        final mapping = await _userRepo.getUsernameMapping(u);
        if (!mapping.exists) {
          throw AppException('User not found');
        }
        final data = mapping.data()!;
        email = (data['email'] as String? ?? '').trim();
        if (email.isEmpty) {
          throw AppException('User mapping is invalid');
        }
      }

      Validators.validateEmail(email);
      await _authRepo.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      throw AppException(_friendlyAuthError(e), code: e.code, cause: e);
    } on ArgumentError catch (e) {
      throw AppException(e.message.toString(), cause: e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Login failed', cause: e);
    }
  }

  /// Registers user and reserves username.
  ///
  /// UI currently calls this with positional parameters.
  static Future<void> register(String username, String email, String password) async {
    try {
      Validators.validateUsername(username);
      Validators.validateEmail(email);
      Validators.validatePassword(password);

      final u = Validators.normalizeUsername(username);
      final e = email.trim();

      final cred = await _authRepo.createUser(e, password);
      final user = cred.user;
      if (user == null) {
        throw AppException('Failed to create user');
      }

      // Save minimal profile.
      await user.updateDisplayName(u);
      await user.sendEmailVerification();

      // Firestore: user doc + username mapping (transaction).
      await _userRepo.createUserAndUsernameMapping(uid: user.uid, username: u, email: e);
    } on StateError catch (e) {
      // Username taken (transaction)
      throw AppException(e.message ?? 'Username already taken', cause: e);
    } on FirebaseAuthException catch (e) {
      throw AppException(_friendlyAuthError(e), code: e.code, cause: e);
    } on ArgumentError catch (e) {
      throw AppException(e.message.toString(), cause: e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Register failed', cause: e);
    }
  }

  /// Backwards-compatible alias.
  static Future<void> logout() => signOut();

  static Future<void> signOut() async {
    try {
      await _authRepo.signOut();
    } catch (e) {
      throw AppException('Logout failed', cause: e);
    }
  }

  /// Backwards-compatible alias.
  static Future<void> reloadUser() => _authRepo.reloadCurrentUser();

  static Future<void> resetPassword(String email) async {
    try {
      Validators.validateEmail(email);
      await _authRepo.sendPasswordResetEmail(email.trim());
    } on FirebaseAuthException catch (e) {
      throw AppException(_friendlyAuthError(e), code: e.code, cause: e);
    } on ArgumentError catch (e) {
      throw AppException(e.message.toString(), cause: e);
    } catch (e) {
      throw AppException('Failed to send reset email', cause: e);
    }
  }

  /// Returns null on success (for compatibility with older UI), or a message.
  static Future<String?> updateUsername(String newUsername) async {
    final user = currentUser;
    if (user == null) return 'User not logged in';

    try {
      Validators.validateUsername(newUsername);
      final next = Validators.normalizeUsername(newUsername);

      // Source of truth: Firestore user doc
      final userDoc = await _userRepo.getUserDoc(user.uid);
      if (!userDoc.exists) return 'User not found';

      final data = userDoc.data()!;
      final current = Validators.normalizeUsername((data['username'] ?? '').toString());

      if (next == current) return null;

      await _userRepo.updateUsername(
        uid: user.uid,
        currentUsername: current,
        nextUsername: next,
        emailFallback: (data['email'] ?? user.email ?? '').toString().trim(),
      );

      await user.updateDisplayName(next);
      return null;
    } on StateError catch (e) {
      return e.message ?? 'Username already taken';
    } on ArgumentError catch (e) {
      return e.message.toString();
    } catch (_) {
      return 'Failed to update username';
    }
  }

  static Future<AppUser?> getCurrentAppUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      return await _userRepo.getUser(user.uid);
    } catch (_) {
      return null;
    }
  }

  static String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email';
      case 'user-disabled':
        return 'User disabled';
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Weak password';
      case 'too-many-requests':
        return 'Too many attempts, try later';
      default:
        return 'Authentication error';
    }
  }

  static Future<void> updatePhotoUrl(String url) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      final currentVersion = snapshot.data()?['photoVersion'] ?? 0;

      transaction.update(userRef, {
        'photoUrl': url,
        'photoVersion': currentVersion + 1,
      });
    });
  }

}
