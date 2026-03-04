class AppUser {
  final String uid;
  final String email;
  final String username;
  final String? photoUrl;
  final String? bio;
  final int photoVersion;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    this.bio,
  });

  factory AppUser.fromFirestore(
      Map<String, dynamic> data,
      String uid,
  ) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      photoVersion: data['photoVersion'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'bio': bio,
    };
  }
}