import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_result.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../datasources/exchange_remote_datasource.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  const ExchangeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ExchangeResult>> getExchangeRate({
    required Currency sourceCurrency,
    required Currency targetCurrency,
    required double amount,
  }) async {
    try {
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

      return Right(ExchangeResult(
        exchangeRate: rate,
        estimatedReceive: estimatedReceive,
        estimatedTime: recommendation.estimatedTimeMinutes,
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(TimeoutFailure());
      }
      if (e.error is SocketException) {
        return const Left(NetworkFailure());
      }
      return const Left(ServerFailure());
    } on SocketException {
      return const Left(NetworkFailure());
    } on FormatException catch (e) {
      if (e.message == 'No offers available') {
        return const Left(NoOffersFailure());
      }
      return const Left(ParsingFailure());
    }
  }
}
