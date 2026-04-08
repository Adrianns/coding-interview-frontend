import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/currency.dart';
import '../bloc/exchange_cubit.dart';
import '../bloc/exchange_state.dart';
import 'amount_input_field.dart';
import 'currency_bottom_sheet.dart';
import 'currency_selector.dart';
import 'exchange_info_row.dart';

class ExchangeCard extends StatefulWidget {
  const ExchangeCard({super.key});

  @override
  State<ExchangeCard> createState() => _ExchangeCardState();
}

class _ExchangeCardState extends State<ExchangeCard> {
  final _amountController = TextEditingController();
  final _numberFormat = NumberFormat('#,##0.00');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeCubit, ExchangeState>(
      builder: (context, state) {
        final cubit = context.read<ExchangeCubit>();
        final isLoading = state.status == ExchangeStatus.loading;
        final targetCode = state.targetCurrency.code;

        String rateValue = '--';
        String receiveValue = '--';
        String timeValue = '--';

        if (state.status == ExchangeStatus.success && state.result != null) {
          rateValue =
              '\u2248 ${_numberFormat.format(state.result!.exchangeRate)} $targetCode';
          receiveValue =
              '\u2248 ${_numberFormat.format(state.result!.estimatedReceive)} $targetCode';
          timeValue =
              '\u2248 ${state.result!.estimatedTime.round()} Min';
        } else if (state.status == ExchangeStatus.error) {
          rateValue = '--';
          receiveValue = '--';
          timeValue = '--';
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Currency selectors row
              CurrencySelectorRow(
                sourceCurrency: state.sourceCurrency,
                targetCurrency: state.targetCurrency,
                onSourceTap: () => _showSourceSheet(context, state),
                onTargetTap: () => _showTargetSheet(context, state),
                onSwapTap: cubit.swapCurrencies,
              ),
              const SizedBox(height: AppSpacing.s20),

              // Amount input
              AmountInputField(
                currencyCode: state.sourceCurrency.code,
                controller: _amountController,
                onChanged: cubit.updateAmount,
              ),
              const SizedBox(height: AppSpacing.s24),

              // Info rows
              ExchangeInfoRow(
                label: 'Tasa estimada',
                value: rateValue,
                isLoading: isLoading,
              ),
              ExchangeInfoRow(
                label: 'Recibirás',
                value: receiveValue,
                isLoading: isLoading,
              ),
              ExchangeInfoRow(
                label: 'Tiempo estimado',
                value: timeValue,
                isLoading: isLoading,
              ),

              // Error message
              if (state.status == ExchangeStatus.error &&
                  state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s12),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: AppSpacing.s24),

              // CTA button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.status == ExchangeStatus.success
                      ? () => _onExchangePressed(context, state)
                      : null,
                  child: const Text('Cambiar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onExchangePressed(BuildContext context, ExchangeState state) {
    if (state.result == null) return;
    final result = state.result!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${state.amount} ${state.sourceCurrency.code} → '
          '${_numberFormat.format(result.estimatedReceive)} ${state.targetCurrency.code}',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  void _showSourceSheet(BuildContext context, ExchangeState state) {
    final currencies = state.sourceCurrency.type == CurrencyType.crypto
        ? CurrencyRegistry.cryptoCurrencies
        : CurrencyRegistry.fiatCurrencies;
    final title =
        state.sourceCurrency.type == CurrencyType.crypto ? 'Cripto' : 'FIAT';

    CurrencyBottomSheet.show(
      context: context,
      title: title,
      currencies: currencies,
      selectedCurrency: state.sourceCurrency,
      onSelected: context.read<ExchangeCubit>().selectSourceCurrency,
    );
  }

  void _showTargetSheet(BuildContext context, ExchangeState state) {
    final currencies = state.targetCurrency.type == CurrencyType.crypto
        ? CurrencyRegistry.cryptoCurrencies
        : CurrencyRegistry.fiatCurrencies;
    final title =
        state.targetCurrency.type == CurrencyType.crypto ? 'Cripto' : 'FIAT';

    CurrencyBottomSheet.show(
      context: context,
      title: title,
      currencies: currencies,
      selectedCurrency: state.targetCurrency,
      onSelected: context.read<ExchangeCubit>().selectTargetCurrency,
    );
  }
}
