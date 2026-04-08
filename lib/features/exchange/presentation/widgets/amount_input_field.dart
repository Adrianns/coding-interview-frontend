import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

class AmountInputField extends StatelessWidget {
  final String currencyCode;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const AmountInputField({
    super.key,
    required this.currencyCode,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: '0.00',
        hintStyle: TextStyle(
          color: AppColors.textGrey.withValues(alpha: 0.5),
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s16, right: AppSpacing.s8),
          child: Text(
            currencyCode,
            style: const TextStyle(
              color: AppColors.accentOrange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderOrange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.borderOrange,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s14,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
