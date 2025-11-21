import 'package:equatable/equatable.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class ApiFailure extends Failure {
  final int? statusCode;
  
  const ApiFailure({
    required super.message,
    super.code,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, code, statusCode];
}

// Authentication failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.code,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    required super.message,
    super.code,
  });
}

// Validation failures
class ValidationFailure extends Failure {
  final String? field;
  final Map<String, dynamic>? details;
  
  const ValidationFailure({
    required super.message,
    super.code,
    this.field,
    this.details,
  });
  
  @override
  List<Object?> get props => [message, code, field, details];
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
  });
}

// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
  });
}

// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });
}

// Business logic failures
class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure({
    required super.message,
    super.code,
  });
}

// File operation failures
class FileOperationFailure extends Failure {
  const FileOperationFailure({
    required super.message,
    super.code,
  });
}

// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

// Helper function to convert exceptions to failures
Failure exceptionToFailure(Exception exception) {
  if (exception is NetworkException) {
    return NetworkFailure(message: exception.message);
  } else if (exception is ServerException) {
    return ServerFailure(message: exception.message);
  } else if (exception is ApiException) {
    return ApiFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    );
  } else if (exception is UnauthorizedException) {
    return UnauthorizedFailure(message: exception.message);
  } else if (exception is ValidationException) {
    return ValidationFailure(
      message: exception.message,
      field: exception.field,
      details: exception.details,
    );
  } else if (exception is CacheException) {
    return CacheFailure(message: exception.message);
  } else if (exception is NotFoundException) {
    return NotFoundFailure(message: exception.message);
  } else {
    return UnknownFailure(message: exception.toString());
  }
}
