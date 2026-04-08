import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/currency.dart';

class CurrencySelectorRow extends StatelessWidget {
  final Currency sourceCurrency;
  final Currency targetCurrency;
  final VoidCallback onSourceTap;
  final VoidCallback onTargetTap;
  final VoidCallback onSwapTap;

  const CurrencySelectorRow({
    super.key,
    required this.sourceCurrency,
    required this.targetCurrency,
    required this.onSourceTap,
    required this.onTargetTap,
    required this.onSwapTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Orange bordered pill container (pushed down so labels sit on border)
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.accentOrange, width: 1.5),
              ),
            ),
          ),

          // Left: TENGO label floating on the border
          Positioned(
            top: 2,
            left: AppSpacing.s28,
            child: Container(
              color: AppColors.cardWhite,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              child: Text(
                'TENGO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),

          // Right: QUIERO label floating on the border
          Positioned(
            top: 2,
            right: AppSpacing.s28,
            child: Container(
              color: AppColors.cardWhite,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              child: Text(
                'QUIERO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),

          // Currency items inside the container
          Positioned(
            top: 18,
            left: AppSpacing.s12,
            right: AppSpacing.s12,
            bottom: AppSpacing.s4,
            child: Row(
              children: [
                // Source currency
                Expanded(
                  child: GestureDetector(
                    onTap: onSourceTap,
                    behavior: HitTestBehavior.opaque,
                    child: _CurrencyChip(currency: sourceCurrency),
                  ),
                ),
                const SizedBox(width: 50),
                // Target currency
                Expanded(
                  child: GestureDetector(
                    onTap: onTargetTap,
                    behavior: HitTestBehavior.opaque,
                    child: _CurrencyChip(currency: targetCurrency),
                  ),
                ),
              ],
            ),
          ),

          // Swap button — uses Align so it's not constrained by SizedBox height
          Positioned(
            left: 0,
            right: 0,
            top: 7,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onSwapTap,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: AppColors.accentOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Colors.white,
                    size: AppSpacing.s32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final Currency currency;

  const _CurrencyChip({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Image.asset(
            currency.iconPath,
            width: AppSpacing.s28,
            height: AppSpacing.s28,
            errorBuilder: (context, error, stackTrace) => Container(
              width: AppSpacing.s28,
              height: AppSpacing.s28,
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Text(
                  currency.code[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s6),
        Flexible(
          child: Text(
            currency.code,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        const Icon(
          Icons.keyboard_arrow_down,
          size: AppSpacing.s20,
          color: AppColors.textGrey,
        ),
      ],
    );
  }
}
