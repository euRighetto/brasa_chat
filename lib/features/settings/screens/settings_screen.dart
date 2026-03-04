import 'package:flutter/material.dart';
import '../../../core/layout/centered_body.dart';
import '../../../core/widgets/app_list_item.dart';
import '../../../core/widgets/app_section_card.dart';
import '../../../core/widgets/brasa_scaffold.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrasaScaffold(
      title: "Settings",
      body: CenteredBody(
        child: Column(
          children: [
            const SizedBox(height: 30),
            AppSectionCard(
              children: [
                AppListItem(
                  icon: Icons.info,
                  title: "About",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen(),
                      ),
                    );
                  },
                ),
                AppListItem(
                  icon: Icons.privacy_tip,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                AppListItem(
                  icon: Icons.description,
                  title: "Terms of Service",
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}