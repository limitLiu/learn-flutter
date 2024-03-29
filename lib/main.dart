import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );
  runApp(const Paper());
}

class Paper extends StatelessWidget {
  const Paper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(painter: PaperPainter()),
    );
  }
}

class PaperPainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke;
  late Paint _grid;
  final double _strokeWidth = 0.5;
  final double _step = 20;
  final Color _color = Colors.grey;

  final List<Offset> points = const [
    Offset(-120, -20),
    Offset(-80, -80),
    Offset(-40, -40),
    Offset(0, -100),
    Offset(40, -140),
    Offset(80, -160),
    Offset(120, -100),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(100, 100), 10, _paint);
    canvas.drawLine(const Offset(0, 0), const Offset(120, 120), _paint);
    final path = Path();
    path.moveTo(130, 130);
    path.lineTo(200, 0);
    canvas.drawPath(path, _paint..color = Colors.red);

    canvas.drawCircle(
      const Offset(200, 180),
      50,
      _paint
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = Colors.blue
        ..strokeWidth = 5,
    );

    canvas.drawCircle(
      const Offset(310, 180),
      50,
      _paint
        ..isAntiAlias = false
        ..color = Colors.red
        ..strokeWidth = 1
        ..invertColors = false,
    );

    canvas.drawCircle(
      const Offset(450, 180),
      50,
      _paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 50
        ..invertColors = true,
    );

    canvas.drawCircle(
      const Offset(600, 180),
      50,
      _paint
        ..style = PaintingStyle.fill
        ..strokeWidth = 50,
    );

    _drawStrokeJoin(canvas);
    _drawStrokeMiterLimit(canvas);

    canvas.translate(size.width / 2, size.height / 2);
    _grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..color = _color;

    _drawGrids(canvas, size);
    canvas.save();
    canvas.scale(1, -1);
    _drawGrids(canvas, size);
    canvas.restore();
    canvas.save();
    canvas.scale(-1, 1);
    _drawGrids(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1);
    _drawGrids(canvas, size);
    canvas.restore();

    canvas.drawCircle(const Offset(0, 0), 50, _paint..color = Colors.purple);
    canvas.drawLine(
      const Offset(20, 20),
      const Offset(50, 50),
      _paint
        ..strokeWidth = 5
        ..color = Colors.green
        ..strokeCap = StrokeCap.round,
    );

    canvas.save();
    const count = 12;
    for (var i = 0; i < count; ++i) {
      const angle = 2 * pi / count;
      canvas.drawLine(Offset(0, 4 * _step), Offset(0, 5 * _step), _paint);
      canvas.rotate(angle);
    }
    canvas.restore();

    _drawPoints(canvas);
    _drawLines(canvas);
    _drawPolygon(canvas);
    _drawAxis(canvas, size);

    _drawRect(canvas);
    _drawRRect(canvas);
    _drawDRRect(canvas);
  }

  void _drawDRRect(Canvas canvas) {
    _paint
      ..color = Colors.blue
      ..strokeWidth = 1.5;

    const orign = Offset(0, 0);
    final outRect = Rect.fromCenter(center: orign, width: 100, height: 100);
    final inner = Rect.fromCenter(center: orign, width: 80, height: 80);
    canvas.drawDRRect(RRect.fromRectXY(outRect, 20, 20),
        RRect.fromRectXY(inner, 10, 10), _paint);

    final outRect1 = Rect.fromCenter(center: orign, width: 60, height: 60);
    final inner1 = Rect.fromCenter(center: orign, width: 40, height: 40);
    canvas.drawDRRect(RRect.fromRectXY(outRect1, 20, 20),
        RRect.fromRectXY(inner1, 10, 10), _paint..color = Colors.green);
  }

  void _drawAxis(Canvas canvas, Size size) {
    _paint
      ..color = Colors.blue
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(-size.width / 2, 0),
      Offset(size.width / 2, 0),
      _paint,
    );
    canvas.drawLine(
      Offset(0, -size.height / 2),
      Offset(0, size.height / 2),
      _paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(-7, size.height / 2 - 10),
      _paint,
    );

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(7, size.height / 2 - 10),
      _paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2 - 10, -7),
      _paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2 - 10, 7),
      _paint,
    );
  }

  void _drawRRect(Canvas canvas) {
    _paint
      ..color = Colors.amber
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;
    final rect =
        Rect.fromCenter(center: const Offset(0, 0), width: 120, height: 120);
    canvas.drawRRect(RRect.fromRectXY(rect, 40, 20), _paint);

    canvas.drawRRect(const RRect.fromLTRBXY(-120, -120, -60, -60, 20, 10),
        _paint..color = Colors.cyan);

    canvas.drawRRect(
        RRect.fromLTRBR(60, 60, 120, 120, const Radius.circular(10)),
        _paint..color = Colors.teal);

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(-60, 60, -120, 120,
          bottomRight: const Radius.elliptical(10, 10)),
      _paint..color = Colors.red,
    );

    final rectPoint =
        Rect.fromPoints(const Offset(60, -60), const Offset(120, -120));
    canvas.drawRRect(
        RRect.fromRectAndCorners(rectPoint,
            bottomLeft: const Radius.elliptical(10, 10)),
        _paint..color = Colors.pink);
  }

  void _drawRect(Canvas canvas) {
    _paint
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;
    final rect =
        Rect.fromCenter(center: const Offset(0, 0), width: 120, height: 120);
    canvas.drawRect(rect, _paint);
    const rectLTRB = Rect.fromLTRB(-120, -120, -60, -60);
    canvas.drawRect(rectLTRB, _paint..color = Colors.red);

    const rectLTWH = Rect.fromLTWH(60, 60, 60, 60);
    canvas.drawRect(rectLTWH, _paint..color = Colors.pink);

    final rectCircle =
        Rect.fromCircle(center: const Offset(-90, 90), radius: 30);
    canvas.drawRect(rectCircle, _paint..color = Colors.cyan);
    final rectPoint =
        Rect.fromPoints(const Offset(60, -60), const Offset(120, -120));
    canvas.drawRect(rectPoint, _paint..color = Colors.teal);
  }

  void _drawPolygon(Canvas canvas) {
    _paint
      ..invertColors = false
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.polygon, points, _paint);
  }

  _drawLines(Canvas canvas) {
    _paint
      ..invertColors = false
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.lines, points, _paint);
  }

  _drawPoints(Canvas canvas) {
    _paint
      ..invertColors = false
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.points, points, _paint);
  }

  _drawStrokeJoin(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 20;
    final path = Path();
    path.moveTo(20, 20);
    path.lineTo(20, 120);
    path.relativeLineTo(120, -50);
    path.relativeLineTo(0, 120);
    canvas.drawPath(path, paint..strokeJoin = StrokeJoin.bevel);

    path.reset();
    path.moveTo(20, 220);
    path.lineTo(20, 320);
    path.relativeLineTo(100, -50);
    path.relativeLineTo(0, 100);
    canvas.drawPath(path, paint..strokeJoin = StrokeJoin.miter);

    path.reset();
    path.moveTo(150, 220);
    path.lineTo(150, 320);
    path.relativeLineTo(100, -50);
    path.relativeLineTo(0, 100);
    canvas.drawPath(path, paint..strokeJoin = StrokeJoin.round);
  }

  _drawStrokeMiterLimit(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 20;
    final path = Path();

    for (var i = 0; i < 4; ++i) {
      path.reset();
      path.moveTo(50 + 150.0 * i, 50);
      path.lineTo(50 + 150.0 * i, 150);
      path.relativeLineTo(100, -(40.0 * i + 20));
      canvas.drawPath(path, paint..strokeMiterLimit = 2);
    }

    for (var i = 0; i < 4; ++i) {
      path.reset();
      path.moveTo(50 + 150.0 * i, 170);
      path.lineTo(50 + 150.0 * i, 150 + 150);
      path.relativeLineTo(100, -(40.0 * i + 20));
      canvas.drawPath(path, paint..strokeMiterLimit = 3);
    }
  }

  _drawGrids(Canvas canvas, Size size) {
    canvas.save();
    for (var i = 0; i < size.height / 2 / _step; ++i) {
      canvas.drawLine(const Offset(0, 0), Offset(size.width / 2, 0), _grid);
      canvas.translate(0, _step);
    }
    canvas.restore();
    canvas.save();

    for (var i = 0; i < size.width / 2 / _step; ++i) {
      canvas.drawLine(const Offset(0, 0), Offset(0, size.height / 2), _grid);
      canvas.translate(_step, 0);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
