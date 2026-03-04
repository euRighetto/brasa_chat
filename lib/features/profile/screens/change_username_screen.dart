import 'package:flutter/material.dart';
import '../../../core/layout/centered_body.dart';
import '../../../core/widgets/brasa_scaffold.dart';
import '../../../services/auth_service.dart';

class ChangeUsernameScreen extends StatefulWidget {
  const ChangeUsernameScreen({super.key});

  @override
  State<ChangeUsernameScreen> createState() =>
      _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState
    extends State<ChangeUsernameScreen> {
  final TextEditingController controller =
      TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> updateUsername() async {
    final result =
        await AuthService.updateUsername(controller.text);

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username updated")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrasaScaffold(
      title: "Username",
      body: SingleChildScrollView(
        child: CenteredBody(
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "New username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateUsername,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}