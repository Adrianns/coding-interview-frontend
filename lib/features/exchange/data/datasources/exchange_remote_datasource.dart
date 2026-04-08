import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/exchange_recommendation_model.dart';

abstract class ExchangeRemoteDataSource {
  Future<ExchangeRecommendationModel> getRecommendation({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  });
}

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final Dio dio;

  const ExchangeRemoteDataSourceImpl({required this.dio});

  @override
  Future<ExchangeRecommendationModel> getRecommendation({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    final response = await dio.get(
      ApiConstants.recommendationsPath,
      queryParameters: {
        'type': type,
        'cryptoCurrencyId': cryptoCurrencyId,
        'fiatCurrencyId': fiatCurrencyId,
        'amount': amount,
        'amountCurrencyId': amountCurrencyId,
      },
    );

    return ExchangeRecommendationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
