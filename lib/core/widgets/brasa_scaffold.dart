import 'package:flutter/material.dart';
import 'brasa_header.dart';

class BrasaScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const BrasaScaffold({
    super.key,
    this.title,
    required this.body,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          Stack(
            children: [
                BrasaHeader(title: title),

                // 🔙 Back button
                if (showBackButton && Navigator.canPop(context))
                    Positioned(
                        top: 50,
                        left: 10,
                        child: IconButton(
                        icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        ),
                    ),
                ],
            ),
          Expanded(child: body),
        ],
      ),
    );
  }
}