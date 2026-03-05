import 'package:flutter/material.dart';
import 'cached_avatar.dart';

/// Reusable avatar that appends ?v=photoVersion to the URL for cache busting.
class Avatar extends StatelessWidget {
  final String? photoUrl;
  final int photoVersion;
  final double radius;

  const Avatar({
    super.key,
    this.photoUrl,
    this.photoVersion = 0,
    this.radius = 45,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = photoUrl != null ? '$photoUrl?v=$photoVersion' : null;
    return CachedAvatar(
      imageUrl: imageUrl,
      radius: radius,
    );
  }
}
