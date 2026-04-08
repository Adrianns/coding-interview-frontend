import '../entities/currency.dart';
import '../entities/exchange_result.dart';

abstract class ExchangeRepository {
  Future<ExchangeResult> getExchangeRate({
    required Currency sourceCurrency,
    required Currency targetCurrency,
    required double amount,
  });
}
