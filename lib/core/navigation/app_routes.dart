import 'package:flutter/material.dart';

import '../../features/auth/auth_gate.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const AuthGate(),
        profile: (context) => const ProfileScreen(),
        settings: (context) => const SettingsScreen(),
      };
}
