import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ExchangeInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLoading;

  const ExchangeInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: AppSpacing.s16,
              height: AppSpacing.s16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accentOrange,
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
        ],
      ),
    );
  }
}
