import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/layout/centered_layout.dart';
import '../../../services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? verifyTimer;
  Timer? countdownTimer;

  int countdown = 60;

  @override
  void initState() {
    super.initState();

    // 🔹 Verifica a cada 3s se foi confirmado
    verifyTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        await AuthService.reloadUser();
      },
    );

    // 🔹 Inicia contagem regressiva
    startCountdown();
  }

  void startCountdown() {
    countdown = 60;

    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (countdown == 0) {
          timer.cancel();
        } else {
          setState(() => countdown--);
        }
      },
    );
  }

  Future<void> resendEmail() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    await user.sendEmailVerification();

    startCountdown();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Verification email resent"),
      ),
    );
  }

  @override
  void dispose() {
    verifyTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService.currentUser?.email ?? "";

    return CenteredLayout(
      title: "Verify Email",
      showBackButton: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mark_email_unread, size: 80),
          const SizedBox(height: 20),

          const Text(
            "Verify your email",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Check spam folder",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "Verification link sent to:\n$email",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),
          const CircularProgressIndicator(),
          const SizedBox(height: 30),

          // 🔥 RESEND BUTTON
          ElevatedButton(
            onPressed: countdown == 0 ? resendEmail : null,
            child: Text(
              countdown == 0
                  ? "Resend Email"
                  : "Resend in $countdown s",
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Change Email
          TextButton(
            onPressed: () async {
              // Opcional: pequeno delay para suavizar transição
              await Future.delayed(const Duration(milliseconds: 150));
              await AuthService.logout();
            },
            child: const Text("Change Email"),
          ),
        ],
      ),
    );
  }
}