class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage';

  static const String recommendationsPath = '/orderbook/public/recommendations';

  // type param: 0 = crypto -> fiat, 1 = fiat -> crypto followed by the README.md instructions
  static const int typeCryptoToFiat = 0;
  static const int typeFiatToCrypto = 1;
}
