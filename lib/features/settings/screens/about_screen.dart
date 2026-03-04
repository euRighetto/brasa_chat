import 'package:flutter/material.dart';
import '../../../core/layout/centered_body.dart';
import '../../../core/widgets/brasa_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrasaScaffold(
      title: "About",
      body: SingleChildScrollView(
        child: CenteredBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 30),
              Text(
                "About Brasa App",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Brasa is a platform designed to connect members, share events, and strengthen our community.",
              ),
              SizedBox(height: 20),
              Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}