import 'package:flutter/material.dart';
import 'avatar_menu.dart';

class BrasaHeader extends StatelessWidget {
  final String? title;

  const BrasaHeader({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 140;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [

            /// Fundo verde
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF046A38),
                    Color(0xFF2E8B57),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// Shapes da logo
            CustomPaint(
              size: const Size(double.infinity, height),
              painter: _BrasaShapesPainter(),
            ),

            /// Avatar menu
            Align(
              alignment: const Alignment(0, -0.1),
              child: const AvatarMenu(),
            ),

            /// Título opcional
            if (title != null)
              Align(
                alignment: const Alignment(0, 0.80),
                child: SafeArea(
                  bottom: false,
                  child: Text(
                    title!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          letterSpacing: 0.3,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BrasaShapesPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    /// Amarelo
    final yellow = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.fill;

    final triangle = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.5, size.height * -0.20)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(triangle, yellow);

    /// Azul
    final blue = Paint()
      ..color = const Color(0xFF1F5FBF)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.5, size.height * 1.05);
    final radius = size.width * 0.30;

    canvas.drawCircle(center, radius, blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}