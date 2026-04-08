import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/currency.dart';

class CurrencyBottomSheet extends StatelessWidget {
  final String title;
  final List<Currency> currencies;
  final Currency selectedCurrency;
  final ValueChanged<Currency> onSelected;

  const CurrencyBottomSheet({
    super.key,
    required this.title,
    required this.currencies,
    required this.selectedCurrency,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<Currency> currencies,
    required Currency selectedCurrency,
    required ValueChanged<Currency> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => CurrencyBottomSheet(
        title: title,
        currencies: currencies,
        selectedCurrency: selectedCurrency,
        onSelected: (currency) {
          onSelected(currency);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: AppSpacing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Drag handle
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return _CurrencyTile(
                  currency: currency,
                  isSelected: currency == selectedCurrency,
                  onTap: () => onSelected(currency),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s24,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                currency.iconPath,
                width: AppSpacing.s40,
                height: AppSpacing.s40,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: AppSpacing.s40,
                  height: AppSpacing.s40,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      currency.code[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    currency.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: AppSpacing.s24,
              height: AppSpacing.s24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentOrange
                      : AppColors.textGrey,
                  width: 2,
                ),
                color: isSelected ? AppColors.accentOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
