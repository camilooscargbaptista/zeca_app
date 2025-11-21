class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  AppException(this.message, [this.statusCode]);
  
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ApiException extends AppException {
  ApiException(String message, int? statusCode) : super(message, statusCode);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message, 401);
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, 404);
}

class ServerException extends AppException {
  ServerException(String message) : super(message, 500);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}

class ValidationException extends AppException {
  final String? field;
  final Map<String, dynamic>? details;
  
  ValidationException(String message, {this.field, this.details}) : super(message);
}
