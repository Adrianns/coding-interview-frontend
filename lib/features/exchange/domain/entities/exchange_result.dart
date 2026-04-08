import 'package:equatable/equatable.dart';

class ExchangeResult extends Equatable {
  final double exchangeRate;
  final double estimatedReceive;
  final double estimatedTime;

  const ExchangeResult({
    required this.exchangeRate,
    required this.estimatedReceive,
    required this.estimatedTime,
  });

  @override
  List<Object?> get props => [exchangeRate, estimatedReceive, estimatedTime];
}
