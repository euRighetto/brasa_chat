class Validators {
  static String normalizeUsername(String input) => input.trim().toLowerCase();

  static void validateUsername(String username) {
    final u = normalizeUsername(username);
    if (u.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (u.length < 3) {
      throw ArgumentError('Username must be at least 3 characters');
    }
    // Keep it permissive to avoid UI changes; only trim/lowercase.
  }

  static void validateEmail(String email) {
    final e = email.trim();
    if (e.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    if (!e.contains('@')) {
      throw ArgumentError('Invalid email');
    }
  }

  static void validatePassword(String password) {
    if (password.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (password.length < 6) {
      throw ArgumentError('Minimum 6 characters');
    }
  }
}
