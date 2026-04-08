class ExchangeRecommendationModel {
  final double fiatToCryptoExchangeRate;
  final double estimatedTimeMinutes;

  const ExchangeRecommendationModel({
    required this.fiatToCryptoExchangeRate,
    required this.estimatedTimeMinutes,
  });

  factory ExchangeRecommendationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    if (data.isEmpty) {
      throw Exception('No exchange offers available for this currency pair');
    }

    final byPrice = data['byPrice'] as Map<String, dynamic>;
    final stats = byPrice['offerMakerStats'] as Map<String, dynamic>? ?? {};

    return ExchangeRecommendationModel(
      fiatToCryptoExchangeRate:
          double.parse(byPrice['fiatToCryptoExchangeRate'].toString()),
      estimatedTimeMinutes:
          double.tryParse(stats['marketMakerOrderTime']?.toString() ?? '') ??
              10.0,
    );
  }
}
