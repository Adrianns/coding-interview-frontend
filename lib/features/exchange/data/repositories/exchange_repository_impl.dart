import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_result.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../datasources/exchange_remote_datasource.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  const ExchangeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ExchangeResult> getExchangeRate({
    required Currency sourceCurrency,
    required Currency targetCurrency,
    required double amount,
  }) async {
    final isCryptoToFiat = sourceCurrency.type == CurrencyType.crypto;
    final type = isCryptoToFiat
        ? ApiConstants.typeCryptoToFiat
        : ApiConstants.typeFiatToCrypto;

    final cryptoCurrency = isCryptoToFiat ? sourceCurrency : targetCurrency;
    final fiatCurrency = isCryptoToFiat ? targetCurrency : sourceCurrency;

    final recommendation = await remoteDataSource.getRecommendation(
      type: type,
      cryptoCurrencyId: cryptoCurrency.id,
      fiatCurrencyId: fiatCurrency.id,
      amount: amount,
      amountCurrencyId: sourceCurrency.id,
    );

    final rate = recommendation.fiatToCryptoExchangeRate;
    final estimatedReceive = isCryptoToFiat ? amount * rate : amount / rate;

    return ExchangeResult(
      exchangeRate: rate,
      estimatedReceive: estimatedReceive,
      estimatedTime: recommendation.estimatedTimeMinutes,
    );
  }
}
