import 'package:flutter/material.dart';
import '../../../core/layout/centered_body.dart';
import '../../../core/widgets/brasa_scaffold.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrasaScaffold(
      title: "Bio",
      body: CenteredBody(
        child: Column(
          children: const [
            SizedBox(height: 40),
            Text(
              "Bio editor coming soon...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}