import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ThemeBackgroundWidget extends StatefulWidget {

  final Widget child;
  
  const ThemeBackgroundWidget({
    required this.child,
    Key? key
  }) : super(key: key);

  @override
  State<ThemeBackgroundWidget> createState() => _ThemeBackgroundWidgetState();
}

class _ThemeBackgroundWidgetState extends State<ThemeBackgroundWidget> with SingleTickerProviderStateMixin {

  late final Animation<double> animation;
  late final AnimationController controller;
  final Tween<double> _rotationTween =  Tween(begin: -pi, end: pi);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(value: animation.value),
      child: widget.child,
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double value;
  _BackgroundPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFD6E6FD),
        Color(0xFFA6B6E0),
        Color(0xFF788CB4),
        Color(0xFF475B84),
        Color(0xFF1B3157),
      ]
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    _drawWave(canvas, value +2, size, white);
    // _drawWave(canvas, value2, Size(size.width, size.height + 50), white);
    _drawWave(canvas, value, size, white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawWave(Canvas canvas, double value, Size size, Paint paint) {
    final path = Path();
    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.8 + 0.2 * y1);
    final controlPointY = size.height * (0.8 + 0.2 * y2);
    final endPointY = size.height * (0.8 + 0.2 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
}
