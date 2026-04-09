import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/currency.dart';
import '../entities/exchange_result.dart';

abstract class ExchangeRepository {
  Future<Either<Failure, ExchangeResult>> getExchangeRate({
    required Currency sourceCurrency,
    required Currency targetCurrency,
    required double amount,
  });
}
