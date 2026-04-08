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
      emit(state.copyWith(status: ExchangeStatus.initial, result: null));
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
    emit(state.copyWith(
      sourceCurrency: state.targetCurrency,
      targetCurrency: state.sourceCurrency,
      result: null,
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

    try {
      final result = await _repository.getExchangeRate(
        sourceCurrency: state.sourceCurrency,
        targetCurrency: state.targetCurrency,
        amount: parsed,
      );
      emit(state.copyWith(status: ExchangeStatus.success, result: result));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: ExchangeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
