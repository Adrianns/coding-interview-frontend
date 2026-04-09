class ExchangeRecommendationModel {
  final double fiatToCryptoExchangeRate;
  final double estimatedTimeMinutes;

  const ExchangeRecommendationModel({
    required this.fiatToCryptoExchangeRate,
    required this.estimatedTimeMinutes,
  });

  factory ExchangeRecommendationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) {
      throw const FormatException('No offers available');
    }

    final byPrice = data['byPrice'] as Map<String, dynamic>?;
    if (byPrice == null) {
      throw const FormatException('Missing byPrice field');
    }

    final stats = byPrice['offerMakerStats'] as Map<String, dynamic>? ?? {};

    final rate = double.tryParse(
      byPrice['fiatToCryptoExchangeRate']?.toString() ?? '',
    );
    if (rate == null || rate <= 0) {
      throw const FormatException('Invalid exchange rate');
    }

    return ExchangeRecommendationModel(
      fiatToCryptoExchangeRate: rate,
      estimatedTimeMinutes:
          double.tryParse(stats['marketMakerOrderTime']?.toString() ?? '') ??
              10.0,
    );
  }
}
