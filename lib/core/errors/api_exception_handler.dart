import 'dart:io';

import 'package:clean_riverpod_starter/core/errors/failures.dart';
import 'package:dio/dio.dart';

abstract final class ApiExceptionHandler {
  static Failure handle(Object error) {
    if (error is Failure) return error;
    if (error is DioException) return _fromDio(error);
    return UnknownFailure(cause: error);
  }

  static Failure _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutFailure(cause: e);

      case DioExceptionType.connectionError:
        return NetworkFailure(cause: e);

      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        if (status == 401 || status == 403) {
          return AuthFailure(cause: e);
        }
        return ServerFailure(
          message: _extractMessage(e.response?.data) ??
              e.response?.statusMessage ??
              'Error del servidor.',
          statusCode: status,
          cause: e,
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          message: 'Certificado SSL inválido.',
          statusCode: 0,
          cause: e,
        );

      case DioExceptionType.cancel:
        return UnknownFailure(message: 'Solicitud cancelada.', cause: e);

      case DioExceptionType.unknown:
        if (e.error is IOException) {
          return NetworkFailure(cause: e);
        }
        return UnknownFailure(cause: e);
    }
  }

  static String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final m = data['message'] ?? data['error'] ?? data['detail'];
      if (m is String && m.isNotEmpty) return m;
    }
    return null;
  }
}
