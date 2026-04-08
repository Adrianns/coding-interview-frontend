import 'package:equatable/equatable.dart';

import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_result.dart';

enum ExchangeStatus { initial, loading, success, error }

class ExchangeState extends Equatable {
  final Currency sourceCurrency;
  final Currency targetCurrency;
  final String amount;
  final ExchangeStatus status;
  final ExchangeResult? result;
  final String? errorMessage;

  const ExchangeState({
    required this.sourceCurrency,
    required this.targetCurrency,
    this.amount = '',
    this.status = ExchangeStatus.initial,
    this.result,
    this.errorMessage,
  });

  factory ExchangeState.initial() => ExchangeState(
        sourceCurrency: CurrencyRegistry.defaultCrypto,
        targetCurrency: CurrencyRegistry.defaultFiat,
      );

  ExchangeState copyWith({
    Currency? sourceCurrency,
    Currency? targetCurrency,
    String? amount,
    ExchangeStatus? status,
    ExchangeResult? result,
    String? errorMessage,
  }) {
    return ExchangeState(
      sourceCurrency: sourceCurrency ?? this.sourceCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        sourceCurrency,
        targetCurrency,
        amount,
        status,
        result,
        errorMessage,
      ];
}
