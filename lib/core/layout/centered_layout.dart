import 'package:flutter/material.dart';
import 'centered_body.dart';

class CenteredLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showBackButton;
  final double maxWidth;

  const CenteredLayout({
    super.key,
    required this.child,
    this.title,
    this.showBackButton = false,
    this.maxWidth = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
            )
          : null,
      body: CenteredBody(
        maxWidth: maxWidth,
        child: child,
      ),
    );
  }
}