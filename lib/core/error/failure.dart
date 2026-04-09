import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('Sin conexion a internet. Verifica tu red e intenta de nuevo.');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure()
      : super('La solicitud tardo demasiado. Intenta de nuevo.');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor. Intenta de nuevo.']);
}

class ParsingFailure extends Failure {
  const ParsingFailure()
      : super('Error al procesar la respuesta. Intenta de nuevo.');
}

class NoOffersFailure extends Failure {
  const NoOffersFailure()
      : super('No hay ofertas disponibles para este par de monedas.');
}
