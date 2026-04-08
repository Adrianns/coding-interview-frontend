import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/background_painter.dart';
import '../widgets/exchange_card.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPainter(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: const ExchangeCard(),
            ),
          ),
        ],
      ),
    );
  }
}
