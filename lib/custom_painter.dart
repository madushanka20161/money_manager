import 'package:flutter/material.dart';

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBackground = Paint()
      // ..color = Color(0xFF3E93EA)
      ..color = Color.fromARGB(255, 18, 73, 128)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBackground);

    final paint2 = Paint()
      ..color = Color(0xFF242C3B)
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(0, size.height * 0.95)
      ..close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}