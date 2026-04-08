import 'package:equatable/equatable.dart';

enum CurrencyType { crypto, fiat }

class Currency extends Equatable {
  final String id;
  final String code;
  final String name;
  final CurrencyType type;
  final String iconPath;

  const Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.iconPath,
  });

  @override
  List<Object?> get props => [id, code, type];
}

class CurrencyRegistry {
  CurrencyRegistry._();

  static const List<Currency> cryptoCurrencies = [
    Currency(
      id: 'TATUM-TRON-USDT',
      code: 'USDT',
      name: 'Tether (USDT)',
      type: CurrencyType.crypto,
      iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
    ),
    Currency(
      id: 'TATUM-TRON-USDC',
      code: 'USDC',
      name: 'USD Coin (USDC)',
      type: CurrencyType.crypto,
      iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
    ),
  ];

  static const List<Currency> fiatCurrencies = [
    Currency(
      id: 'VES',
      code: 'VES',
      name: 'Bolivares (Bs)',
      type: CurrencyType.fiat,
      iconPath: 'assets/fiat_currencies/VES.png',
    ),
    Currency(
      id: 'COP',
      code: 'COP',
      name: 'Pesos Colombianos (COL\$)',
      type: CurrencyType.fiat,
      iconPath: 'assets/fiat_currencies/COP.png',
    ),
    Currency(
      id: 'ARS',
      code: 'ARS',
      name: 'Pesos Argentinos (ARS\$)',
      type: CurrencyType.fiat,
      iconPath: 'assets/fiat_currencies/VES.png',
    ),
    Currency(
      id: 'PEN',
      code: 'PEN',
      name: 'Soles Peruanos (S/)',
      type: CurrencyType.fiat,
      iconPath: 'assets/fiat_currencies/PEN.png',
    ),
    Currency(
      id: 'BRL',
      code: 'BRL',
      name: 'Real Brasileno (R\$)',
      type: CurrencyType.fiat,
      iconPath: 'assets/fiat_currencies/BRL.png',
    ),
    Currency(
      id: 'BOB',
      code: 'BOB',
      name: 'Boliviano (Bs)',
      type: CurrencyType.fiat,
      iconPath: 'assets/fiat_currencies/VES.png',
    ),
  ];

  static Currency get defaultCrypto => cryptoCurrencies.first;
  static Currency get defaultFiat => fiatCurrencies.first;
}
