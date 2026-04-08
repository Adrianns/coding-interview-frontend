import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onTap;

  const SwapButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.s40,
        height: AppSpacing.s40,
        decoration: const BoxDecoration(
          color: AppColors.accentOrange,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.swap_horiz,
          color: Colors.white,
          size: AppSpacing.s20,
        ),
      ),
    );
  }
}
