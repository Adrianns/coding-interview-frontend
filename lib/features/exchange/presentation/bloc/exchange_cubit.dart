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

    try {
      final result = await _repository.getExchangeRate(
        sourceCurrency: state.sourceCurrency,
        targetCurrency: state.targetCurrency,
        amount: parsed,
      );
      emit(state.copyWith(
        status: ExchangeStatus.success,
        result: () => result,
        errorMessage: () => null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: ExchangeStatus.error,
        result: () => null,
        errorMessage: () => _mapErrorMessage(e),
      ));
    }
  }

  String _mapErrorMessage(Exception e) {
    final msg = e.toString().replaceAll('Exception: ', '');

    if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
      return 'Sin conexión a internet. Verificá tu red e intentá de nuevo.';
    }
    if (msg.contains('TimeoutException') || msg.contains('timed out')) {
      return 'La solicitud tardó demasiado. Intentá de nuevo.';
    }
    if (msg.contains('No hay ofertas')) {
      return msg;
    }
    return 'Ocurrió un error inesperado. Intentá de nuevo.';
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
