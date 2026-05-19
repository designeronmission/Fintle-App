import 'package:flutter/material.dart';

class IllustrationWidget extends StatelessWidget {
  const IllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 312,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FC),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: 280,
          height: 280,
          child: CustomPaint(
            painter: FintleIllustrationPainter(),
          ),
        ),
      ),
    );
  }
}

class FintleIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF263238)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final fillPaint = Paint()
      ..color = const Color(0xFF172862)
      ..style = PaintingStyle.fill;
    
    final lightFillPaint = Paint()
      ..color = const Color(0xFFE1E6F6)
      ..style = PaintingStyle.fill;
    
    final grayFillPaint = Paint()
      ..color = const Color(0xFF4A5568)
      ..style = PaintingStyle.fill;
    
    final lightGrayFillPaint = Paint()
      ..color = const Color(0xFF5A6678)
      ..style = PaintingStyle.fill;
    
    // Calendar icon (top-left area)
    // Calendar box
    canvas.drawRect(const Rect.fromLTWH(20, 40, 50, 45), paint);
    
    // Calendar top lines (for dates)
    final linePaint = Paint()..color = const Color(0xFF263238)..strokeWidth = 1;
    canvas.drawLine(const Offset(25, 52), const Offset(65, 52), linePaint);
    canvas.drawLine(const Offset(25, 60), const Offset(65, 60), linePaint);
    canvas.drawLine(const Offset(25, 68), const Offset(65, 68), linePaint);
    canvas.drawLine(const Offset(25, 76), const Offset(65, 76), linePaint);
    canvas.drawLine(const Offset(33, 48), const Offset(33, 82), linePaint);
    canvas.drawLine(const Offset(41, 48), const Offset(41, 82), linePaint);
    canvas.drawLine(const Offset(49, 48), const Offset(49, 82), linePaint);
    canvas.drawLine(const Offset(57, 48), const Offset(57, 82), linePaint);
    
    // Calendar top tabs
    final topPaint = Paint()..color = const Color(0xFF263238)..strokeWidth = 2;
    canvas.drawLine(const Offset(30, 35), const Offset(30, 45), topPaint);
    canvas.drawLine(const Offset(40, 35), const Offset(40, 45), topPaint);
    canvas.drawLine(const Offset(50, 35), const Offset(50, 45), topPaint);
    canvas.drawLine(const Offset(60, 35), const Offset(60, 45), topPaint);
    
    // Clipboard with Dollar Sign
    canvas.drawRect(const Rect.fromLTWH(100, 30, 80, 100), paint);
    final clipPaint = Paint()..color = const Color(0xFF8B8D97);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(120, 25, 40, 12), const Radius.circular(6)),
      clipPaint,
    );
    canvas.drawCircle(const Offset(140, 70), 20, fillPaint);
    
    // Dollar sign text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(140 - textPainter.width / 2, 70 - textPainter.height / 2));
    
    // Clipboard lines
    final clipLinePaint = Paint()..color = const Color(0xFF263238)..strokeWidth = 1.5;
    canvas.drawLine(const Offset(110, 95), const Offset(130, 95), clipLinePaint);
    canvas.drawLine(const Offset(150, 95), const Offset(170, 95), clipLinePaint);
    canvas.drawLine(const Offset(110, 102), const Offset(170, 102), clipLinePaint);
    canvas.drawLine(const Offset(110, 109), const Offset(170, 109), clipLinePaint);
    canvas.drawLine(const Offset(110, 116), const Offset(145, 116), clipLinePaint);
    
    // Receipt/Paper with Magnifying Glass
    canvas.drawRect(const Rect.fromLTWH(35, 140, 60, 80), paint);
    final receiptLinePaint = Paint()..color = const Color(0xFF263238)..strokeWidth = 1.5;
    canvas.drawLine(const Offset(45, 150), const Offset(75, 150), receiptLinePaint);
    canvas.drawLine(const Offset(45, 157), const Offset(75, 157), receiptLinePaint);
    canvas.drawLine(const Offset(45, 164), const Offset(75, 164), receiptLinePaint);
    canvas.drawLine(const Offset(45, 171), const Offset(75, 171), receiptLinePaint);
    canvas.drawLine(const Offset(45, 178), const Offset(70, 178), receiptLinePaint);
    
    // Magnifying Glass
    canvas.drawCircle(const Offset(70, 195), 18, paint);
    canvas.drawLine(const Offset(83, 208), const Offset(95, 220), paint);
    
    // Calculator
    canvas.drawRect(const Rect.fromLTWH(120, 155, 70, 90), paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(127, 162, 56, 20), const Radius.circular(3)),
      lightFillPaint,
    );
    
    // Calculator buttons
    final btnPaint = Paint()..color = const Color(0xFF263238);
    canvas.drawRect(const Rect.fromLTWH(130, 190, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(147, 190, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(164, 190, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(130, 205, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(147, 205, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(164, 205, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(130, 220, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(147, 220, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(164, 220, 12, 10), btnPaint);
    canvas.drawRect(const Rect.fromLTWH(130, 230, 12, 10), btnPaint);
    
    // Stacked Coins - Fixed: Using drawOval instead of drawEllipse
    canvas.drawOval(const Rect.fromLTWH(72, 232, 36, 12), grayFillPaint);
    canvas.drawRect(const Rect.fromLTWH(72, 226, 36, 6), grayFillPaint);
    canvas.drawOval(const Rect.fromLTWH(72, 226, 36, 12), lightGrayFillPaint);
    canvas.drawOval(const Rect.fromLTWH(72, 220, 36, 12), grayFillPaint);
    canvas.drawRect(const Rect.fromLTWH(72, 214, 36, 6), grayFillPaint);
    canvas.drawOval(const Rect.fromLTWH(72, 214, 36, 12), lightGrayFillPaint);
    canvas.drawOval(const Rect.fromLTWH(72, 208, 36, 12), grayFillPaint);
    canvas.drawRect(const Rect.fromLTWH(72, 202, 36, 6), grayFillPaint);
    canvas.drawOval(const Rect.fromLTWH(72, 202, 36, 12), lightGrayFillPaint);

    // Person Left (with laptop)
    // Head
    final skinPaint = Paint()..color = const Color(0xFFFFC1A6);
    canvas.drawCircle(const Offset(35, 175), 8, skinPaint);
    // Body
    final bodyPaint = Paint()..color = const Color(0xFF263238)..strokeWidth = 2;
    canvas.drawLine(const Offset(35, 183), const Offset(35, 210), bodyPaint);
    canvas.drawLine(const Offset(35, 195), const Offset(28, 205), bodyPaint);
    canvas.drawLine(const Offset(35, 195), const Offset(42, 205), bodyPaint);
    canvas.drawLine(const Offset(35, 210), const Offset(28, 225), bodyPaint);
    canvas.drawLine(const Offset(35, 210), const Offset(42, 225), bodyPaint);
    // Laptop
    canvas.drawRect(const Rect.fromLTWH(25, 200, 22, 14), bodyPaint);
    final screenPaint = Paint()..color = const Color(0xFFE1E6F6)..strokeWidth = 0.5;
    canvas.drawLine(const Offset(27, 204), const Offset(45, 204), screenPaint);
    canvas.drawLine(const Offset(27, 207), const Offset(45, 207), screenPaint);
    canvas.drawLine(const Offset(27, 210), const Offset(45, 210), screenPaint);

    // Person Right (with documents)
    canvas.drawCircle(const Offset(245, 175), 8, skinPaint);
    canvas.drawLine(const Offset(245, 183), const Offset(245, 210), bodyPaint);
    canvas.drawLine(const Offset(245, 195), const Offset(238, 205), bodyPaint);
    canvas.drawLine(const Offset(245, 195), const Offset(252, 205), bodyPaint);
    canvas.drawLine(const Offset(245, 210), const Offset(238, 225), bodyPaint);
    canvas.drawLine(const Offset(245, 210), const Offset(252, 225), bodyPaint);
    // Document
    canvas.drawRect(const Rect.fromLTWH(235, 195, 14, 18), paint);
    final docLinePaint = Paint()..color = const Color(0xFF263238)..strokeWidth = 1;
    canvas.drawLine(const Offset(238, 199), const Offset(246, 199), docLinePaint);
    canvas.drawLine(const Offset(238, 202), const Offset(246, 202), docLinePaint);
    canvas.drawLine(const Offset(238, 205), const Offset(246, 205), docLinePaint);
    canvas.drawLine(const Offset(238, 208), const Offset(246, 208), docLinePaint);

    // Decorative circles/targets
    final circlePaint = Paint()
      ..color = const Color(0xFFE1E6F6)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(230, 75), 28, circlePaint);
    
    final innerCirclePaint = Paint()
      ..color = const Color(0xFFD0D5F0)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(230, 75), 18, innerCirclePaint);
    
    // Chart bars background
    final barPaint = Paint()
      ..color = const Color(0xFFE1E6F6)
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Rect.fromLTWH(210, 55, 8, 25), barPaint);
    canvas.drawRect(const Rect.fromLTWH(220, 45, 8, 35), barPaint);
    canvas.drawRect(const Rect.fromLTWH(230, 50, 8, 30), barPaint);
    canvas.drawRect(const Rect.fromLTWH(240, 40, 8, 40), barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}