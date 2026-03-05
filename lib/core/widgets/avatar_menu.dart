import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/app_user.dart';
import 'avatar.dart';

class AvatarMenu extends StatefulWidget {
  const AvatarMenu({super.key});

  @override
  State<AvatarMenu> createState() => _AvatarMenuState();
}

class _AvatarMenuState extends State<AvatarMenu> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _avatarKey = GlobalKey();

  void toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlay() {

    final renderBox =
        _avatarKey.currentContext!.findRenderObject() as RenderBox;

    final avatarPosition = renderBox.localToGlobal(Offset.zero);
    final avatarSize = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return GestureDetector(
          onTap: toggleMenu,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [

              Positioned(
                top: avatarPosition.dy + avatarSize.height + 10,
                left: (screenWidth / 2) - 95,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 190,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 25,
                          spreadRadius: -5,
                          offset: Offset(0, 10),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        _menuItem("Profile", () {
                          toggleMenu();
                          Navigator.pushNamed(context, "/profile");
                        }),

                        _divider(),

                        _menuItem("Settings", () {
                          toggleMenu();
                          Navigator.pushNamed(context, "/settings");
                        }),

                        _divider(),

                        _menuItem("Logout", () {
                          toggleMenu();
                          AuthService.signOut();
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.7,
      color: Colors.grey.withOpacity(0.25),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: AuthService.getCurrentAppUser(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final user = snapshot.data!;

        return GestureDetector(
          key: _avatarKey,
          onTap: toggleMenu,
          child: Avatar(
            photoUrl: user.photoUrl,
            photoVersion: user.photoVersion,
            radius: 28,
          ),
        );
      },
    );
  }
}