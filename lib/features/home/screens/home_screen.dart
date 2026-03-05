import 'package:flutter/material.dart';
import '../../../core/widgets/brasa_scaffold.dart';
import '../../../core/widgets/avatar.dart';
import '../../../services/auth_service.dart';
import '../../../models/app_user.dart';
import '../../profile/screens/profile_screen.dart';
import '../../settings/screens/settings_screen.dart';
import 'dashboard_screen.dart';
import 'calendar_screen.dart';
import 'notifications_screen.dart';
import 'contacts_screen.dart';
import '../../../core/widgets/brasa_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    CalendarScreen(),
    NotificationsScreen(),
    ContactsScreen(),
  ];

  String getTitle() {
    switch (currentIndex) {
      case 0:
        return "Dashboard";
      case 1:
        return "Calendar";
      case 2:
        return "Notifications";
      case 3:
        return "Contacts";
      default:
        return "";
    }
  }

  List<Widget> getActions() {
    if (currentIndex == 1 || currentIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // ação do +
          },
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BrasaScaffold(
      title: getTitle(),
      showBackButton: false,
      drawer: _buildDrawer(context),

      bottomNavigationBar: BrasaNavbar(
        index: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
      ),

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<AppUser?>(
        future: AuthService.getCurrentAppUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found"));
          }

          final user = snapshot.data!;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF046A38),
                      Color(0xFF2E8B57),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Avatar(
                      photoUrl: user.photoUrl,
                      photoVersion: user.photoVersion,
                      radius: 45,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  await AuthService.signOut();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}