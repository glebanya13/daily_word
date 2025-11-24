import 'dart:math' as math;
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final Color? color;
  final double? size;

  const LoadingWidget({
    super.key,
    this.color,
    this.size,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8),
        weight: 0.5,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF8B0000);
    final size = widget.size ?? 60.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CustomPaint(
            size: Size(size, size),
            painter: _CrossPainter(
              color: color,
              rotation: _rotationAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class _CrossPainter extends CustomPainter {
  final Color color;
  final double rotation;

  _CrossPainter({
    required this.color,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Внешний круг с градиентом (нимб/свет)
    final circleGradient = RadialGradient(
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.05),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final circlePaint = Paint()
      ..shader = circleGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, circlePaint);

    // Лучи света (вращающиеся)
    final raysPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0 + rotation * 360.0) * math.pi / 180.0;
      final startX = center.dx + (radius * 0.6) * math.cos(angle);
      final startY = center.dy + (radius * 0.6) * math.sin(angle);
      final endX = center.dx + (radius * 0.85) * math.cos(angle);
      final endY = center.dy + (radius * 0.85) * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        raysPaint,
      );
    }

    // Крест
    final crossWidth = radius * 0.15;
    final crossLength = radius * 0.5;

    // Вертикальная часть креста
    final verticalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        color.withOpacity(0.8),
      ],
    );

    final verticalPaint = Paint()
      ..shader = verticalGradient.createShader(
        Rect.fromCenter(
          center: center,
          width: crossWidth,
          height: crossLength * 2,
        ),
      )
      ..style = PaintingStyle.fill;

    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: crossWidth,
        height: crossLength * 2,
      ),
      const Radius.circular(2),
    );

    canvas.drawRRect(verticalRect, verticalPaint);

    // Горизонтальная часть креста
    final horizontalGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        color,
        color.withOpacity(0.8),
      ],
    );

    final horizontalPaint = Paint()
      ..shader = horizontalGradient.createShader(
        Rect.fromCenter(
          center: center,
          width: crossLength * 2,
          height: crossWidth,
        ),
      )
      ..style = PaintingStyle.fill;

    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: crossLength * 2,
        height: crossWidth,
      ),
      const Radius.circular(2),
    );

    canvas.drawRRect(horizontalRect, horizontalPaint);

    // Центральная точка
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, crossWidth * 0.5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _CrossPainter ||
        oldDelegate.rotation != rotation ||
        oldDelegate.color != color;
  }
}
