import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/toy_pop_theme.dart';

class SunburstPainter extends CustomPainter {
  final double angle;
  final int rayCount;
  final Color rayColor;

  SunburstPainter({
    required this.angle,
    this.rayCount = 12,
    this.rayColor = const Color(0xFFFFD84D),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    final paint = Paint()
      ..color = rayColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final step = (2 * math.pi) / (rayCount * 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    for (int i = 0; i < rayCount; i++) {
      final startAngle = i * step * 2;
      final sweepAngle = step;

      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(radius * math.cos(startAngle), radius * math.sin(startAngle))
        ..lineTo(
          radius * math.cos(startAngle + sweepAngle),
          radius * math.sin(startAngle + sweepAngle),
        )
        ..close();

      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SunburstPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.rayColor != rayColor;
}

class ConfettiParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final Color shadowColor;
  final double rotation;
  final bool isPill;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.shadowColor,
    required this.rotation,
    this.isPill = false,
  });
}

class ConfettiOverlayWidget extends StatelessWidget {
  final double animationProgress;

  const ConfettiOverlayWidget({super.key, required this.animationProgress});

  static final List<ConfettiParticle> particles = [
    ConfettiParticle(
      x: 0.12,
      y: 0.22,
      size: 14,
      color: const Color(0xFFFF4B72),
      shadowColor: const Color(0xFFC22248),
      rotation: 0.78,
      isPill: true,
    ),
    ConfettiParticle(
      x: 0.88,
      y: 0.28,
      size: 16,
      color: const Color(0xFF00C1FD),
      shadowColor: const Color(0xFF008FB8),
      rotation: -0.21,
    ),
    ConfettiParticle(
      x: 0.15,
      y: 0.68,
      size: 15,
      color: const Color(0xFFF5B800),
      shadowColor: const Color(0xFFAA7E00),
      rotation: 0.0,
    ),
    ConfettiParticle(
      x: 0.85,
      y: 0.72,
      size: 14,
      color: const Color(0xFFA359FF),
      shadowColor: const Color(0xFF6F34BD),
      rotation: 0.42,
      isPill: true,
    ),
    ConfettiParticle(
      x: 0.5,
      y: 0.15,
      size: 12,
      color: ToyPopTheme.mint,
      shadowColor: ToyPopTheme.mintDark,
      rotation: 0.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          ...particles.map((p) {
            final yOffset =
                math.sin((animationProgress * 2 * math.pi) + (p.x * 10)) * 6.0;
            return Align(
              alignment: FractionalOffset(p.x, p.y),
              child: Transform.translate(
                offset: Offset(0, yOffset),
                child: Transform.rotate(
                  angle: p.rotation,
                  child: Container(
                    width: p.isPill ? p.size * 1.6 : p.size,
                    height: p.size,
                    decoration: BoxDecoration(
                      color: p.color,
                      borderRadius: BorderRadius.circular(p.isPill ? 999 : 4),
                      boxShadow: [
                        BoxShadow(
                          color: p.shadowColor,
                          offset: const Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          _buildBouncingEmoji(0.12, 0.10, '🎉', 28, animationProgress, 0.0),
          _buildBouncingEmoji(0.85, 0.14, '⭐', 26, animationProgress, 0.3),
          _buildBouncingEmoji(0.10, 0.82, '🍬', 26, animationProgress, 0.5),
          _buildBouncingEmoji(0.88, 0.84, '🎈', 30, animationProgress, 0.2),
        ],
      ),
    );
  }

  Widget _buildBouncingEmoji(
    double x,
    double y,
    String emoji,
    double fontSize,
    double progress,
    double phase,
  ) {
    final bounce =
        math.sin((progress * 2 * math.pi) + (phase * 2 * math.pi)) * 8.0;
    return Align(
      alignment: FractionalOffset(x, y),
      child: Transform.translate(
        offset: Offset(0, bounce),
        child: Text(emoji, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
