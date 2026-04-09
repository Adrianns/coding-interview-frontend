import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/currency.dart';
import '../../domain/repositories/exchange_repository.dart';
import 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final ExchangeRepository _repository;
  Timer? _debounceTimer;

  ExchangeCubit({required ExchangeRepository repository})
      : _repository = repository,
        super(ExchangeState.initial());

  void updateAmount(String value) {
    emit(state.copyWith(amount: value));

    _debounceTimer?.cancel();

    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      emit(state.copyWith(
        status: ExchangeStatus.initial,
        result: () => null,
        errorMessage: () => null,
      ));
      return;
    }

    emit(state.copyWith(status: ExchangeStatus.loading));
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchRate();
    });
  }

  void selectSourceCurrency(Currency currency) {
    emit(state.copyWith(sourceCurrency: currency));
    _fetchIfValid();
  }

  void selectTargetCurrency(Currency currency) {
    emit(state.copyWith(targetCurrency: currency));
    _fetchIfValid();
  }

  void swapCurrencies() {
    _debounceTimer?.cancel();
    emit(state.copyWith(
      sourceCurrency: state.targetCurrency,
      targetCurrency: state.sourceCurrency,
      result: () => null,
      errorMessage: () => null,
    ));
    _fetchIfValid();
  }

  void _fetchIfValid() {
    final parsed = double.tryParse(state.amount);
    if (parsed != null && parsed > 0) {
      emit(state.copyWith(status: ExchangeStatus.loading));
      _fetchRate();
    }
  }

  Future<void> _fetchRate() async {
    final parsed = double.tryParse(state.amount);
    if (parsed == null || parsed <= 0) return;

    final result = await _repository.getExchangeRate(
      sourceCurrency: state.sourceCurrency,
      targetCurrency: state.targetCurrency,
      amount: parsed,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ExchangeStatus.error,
        result: () => null,
        errorMessage: () => failure.message,
      )),
      (exchangeResult) => emit(state.copyWith(
        status: ExchangeStatus.success,
        result: () => exchangeResult,
        errorMessage: () => null,
      )),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
