import 'package:flutter/material.dart';
import '../../../core/layout/centered_body.dart';
import '../../../core/widgets/app_list_item.dart';
import '../../../core/widgets/app_section_card.dart';
import '../../../core/widgets/brasa_scaffold.dart';
import '../../../services/auth_service.dart';
import '../../../models/app_user.dart';
import 'change_username_screen.dart';
import 'bio_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> pickImage() async {

    final file = await ImagePickerHelper.pickFromGallery();

    if (file == null) return;

    final url = await StorageService.uploadProfileImage(file);

    await AuthService.updatePhotoUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return BrasaScaffold(
      title: "Profile",
      body: FutureBuilder<AppUser?>(
        future: AuthService.getCurrentAppUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: CenteredBody(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  CachedAvatar(
                    imageUrl: "${user.photoUrl}?v=${user.photoVersion}",
                    radius: 45,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  AppSectionCard(
                    children: [
                      AppListItem(
                        icon: Icons.edit,
                        title: "Edit Username",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ChangeUsernameScreen(),
                            ),
                          );
                        },
                      ),
                      AppListItem(
                        icon: Icons.camera_alt,
                        title: "Edit Profile Picture",
                        onTap: pickImage,
                      ),
                      AppListItem(
                        icon: Icons.short_text,
                        title: "Edit Bio",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BioScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}