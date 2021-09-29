import 'package:flutter/material.dart';

class CloudPainter extends CustomPainter {
  final double animationPercent;

  CloudPainter(this.animationPercent);
  @override
  void paint(Canvas canvas, Size size) {
    _drawCloudOutline(canvas, size);
    _drawLines(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawCloudOutline(Canvas canvas, Size size) {
    final path = Path()..moveTo(size.width * 0.5, size.height);

    path.lineTo(size.width * 0.85, size.height);

    path.cubicTo(
      size.width,
      size.height,
      size.width * 1.05,
      size.height * 0.41,
      size.width * 0.77,
      size.height * 0.41,
    );

    path.cubicTo(
      size.width * 0.77,
      0,
      size.width * 0.22,
      0,
      size.width * 0.22,
      size.height * 0.41,
    );

    path.cubicTo(
      0,
      size.height * 0.41,
      0,
      size.height,
      size.width * 0.15,
      size.height,
    );

    path.close();

    Path animatedPath = createAnimatedPath(path, (animationPercent / 0.5).clamp(0, 1));

    canvas.drawPath(
      animatedPath,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  void _drawLines(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final transformedAnimationValue = (animationPercent - 0.5) / 0.5;
    _drawLine1(canvas, size, linePaint, transformedAnimationValue);
    _drawLine2(canvas, size, linePaint, transformedAnimationValue);
    _drawLine3(canvas, size, linePaint, transformedAnimationValue);
    _drawLine4(canvas, size, linePaint, transformedAnimationValue);
    _drawLine5(canvas, size, linePaint, transformedAnimationValue);
  }

  void _drawLine1(Canvas canvas, Size size, Paint linePaint, double transformedValue) {
    final path = Path()..moveTo(size.width * 0.27, size.height);

    Offset lineEnd = Offset(size.width * 0.27, size.height * 0.62);

    path.lineTo(lineEnd.dx, lineEnd.dy);

    path.addOval(Rect.fromCircle(center: lineEnd, radius: linePaint.strokeWidth * 0.5));

    Path animatedPath = createAnimatedPath(path, transformedValue);

    canvas.drawPath(animatedPath, linePaint);
  }

  void _drawLine2(Canvas canvas, Size size, Paint linePaint, double transformedValue) {
    Path path = Path()..moveTo(size.width * 0.34, size.height);

    path.lineTo(size.width * 0.34, size.height * 0.48);
    path.lineTo(size.width * 0.44, size.height * 0.48);

    final lastPointCenter = Offset(size.width * 0.44, size.height * 0.25);
    path.lineTo(lastPointCenter.dx, lastPointCenter.dy);
    path.addOval(Rect.fromCircle(center: lastPointCenter, radius: linePaint.strokeWidth * 0.5));

    Path animatedPath = createAnimatedPath(path, transformedValue);

    canvas.drawPath(animatedPath, linePaint);
  }

  void _drawLine3(Canvas canvas, Size size, Paint linePaint, double transformedValue) {
    Path path = Path()..moveTo(size.width * 0.41, size.height);

    Offset lastPoint = Offset(size.width * 0.41, size.height * 0.71);

    path.lineTo(lastPoint.dx, lastPoint.dy);
    path.addOval(Rect.fromCircle(center: lastPoint, radius: linePaint.strokeWidth * 0.5));

    Path animatedPath = createAnimatedPath(path, transformedValue);

    canvas.drawPath(animatedPath, linePaint..style);
  }

  void _drawLine4(Canvas canvas, Size size, Paint linePaint, double transformedValue) {
    Path path = Path()..moveTo(size.width * 0.63, size.height);

    path.lineTo(size.width * 0.63, size.height * 0.65);
    path.lineTo(size.width * 0.53, size.height * 0.65);

    Offset lastPoint = Offset(size.width * 0.53, size.height * 0.38);
    path.lineTo(lastPoint.dx, lastPoint.dy);

    path.addOval(Rect.fromCircle(center: lastPoint, radius: linePaint.strokeWidth * 0.5));
    Path animatedPath = createAnimatedPath(path, transformedValue);

    canvas.drawPath(animatedPath, linePaint);
  }

  void _drawLine5(Canvas canvas, Size size, Paint linePaint, double transformedValue) {
    Path path = Path()..moveTo(size.width * 0.73, size.height);

    Offset lastPoint = Offset(size.width * 0.73, size.height * 0.62);
    path.lineTo(lastPoint.dx, lastPoint.dy);

    path.addOval(Rect.fromCircle(center: lastPoint, radius: linePaint.strokeWidth * 0.5));

    Path animatedPath = createAnimatedPath(path, transformedValue);

    canvas.drawPath(animatedPath, linePaint);
  }

  Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
    final totalLength = originalPath.computeMetrics().fold<double>(0.0, (previousValue, element) => previousValue + element.length);

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }
}
