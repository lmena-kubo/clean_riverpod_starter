sealed class Failure implements Exception {
  const Failure({required this.message, this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Problema de conexión. Revisa tu red.',
    super.cause,
  });
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'El servidor tardó demasiado en responder.',
    super.cause,
  });
}

final class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Credenciales inválidas o sesión expirada.',
    super.cause,
  });
}

final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required this.statusCode,
    super.cause,
  });

  final int statusCode;
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Ocurrió un error inesperado.',
    super.cause,
  });
}
