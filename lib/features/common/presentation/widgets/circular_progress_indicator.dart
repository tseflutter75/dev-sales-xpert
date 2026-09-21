import 'package:flutter/material.dart';

import 'dart:math';

class CustomCircularProgressIndicator extends StatefulWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  State<CustomCircularProgressIndicator> createState() =>
      _TimerIconProgressState();
}

class _TimerIconProgressState extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // It will keep turning all the time (like the hands of a clock).
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(40, 40), // default size small
          painter: _TimerPainter(_controller.value),
        );
      },
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double animationValue;
  _TimerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color =  Color(0xFF9161FF) 
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ১. বাইরের বৃত্ত (ঘড়ির ফ্রেম)
    canvas.drawCircle(center, radius, paint);

    // ২. ঘড়ির ছোট কাঁটা (Fixed)
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - (radius * 0.5)),
      paint,
    );

    // 3. Clock hands (animated/rotating)
    double angle = animationValue * 2 * pi;
    canvas.drawLine(
      center,
      Offset(
        center.dx + (radius * 0.7) * cos(angle - pi / 2),
        center.dy + (radius * 0.7) * sin(angle - pi / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}















