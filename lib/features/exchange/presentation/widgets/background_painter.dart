import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BackgroundPainter extends StatelessWidget {
  const BackgroundPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _BackgroundCustomPainter(),
    );
  }
}

class _BackgroundCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.backgroundTeal,
    );

    canvas.drawCircle(
      Offset(size.width * 2, size.height * 0.38),
      size.height * 0.65,
      Paint()..color = AppColors.accentOrange,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
