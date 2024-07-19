import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArcPainter extends CustomPainter {
  final LatLng center;
  final double innerRadius;
  final double outerRadius;

  ArcPainter(this.center, this.innerRadius, this.outerRadius);

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double x = size.width / 2;
    double y = size.height / 2;

    Path pathBottom = Path();
    pathBottom.arcTo(
      Rect.fromCircle(center: Offset(x, y), radius: outerRadius),
      pi / 2,
      pi,
      false,
    );
    pathBottom.arcTo(
      Rect.fromCircle(center: Offset(x, y), radius: innerRadius),
      pi / 2 + pi,
      -pi,
      false,
    );
    pathBottom.close();
    canvas.drawPath(pathBottom, paint);
    canvas.drawPath(pathBottom, borderPaint);
  }
}
