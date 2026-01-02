import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../errors/exceptions.dart';
import '../config/api_config.dart';

class DioClient {
  late Dio _dio;
  final Connectivity _connectivity = Connectivity();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: ApiConfig.defaultHeaders,
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check connectivity
          final connectivityResult = await _connectivity.checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: NetworkException('Sem conexão com a internet'),
              ),
            );
            return;
          }

          // Add auth token if available
          // TODO: Add token from secure storage
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          if (error is DioException) {
            switch (error.type) {
              case DioExceptionType.connectionTimeout:
              case DioExceptionType.sendTimeout:
              case DioExceptionType.receiveTimeout:
                handler.next(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: NetworkException('Timeout de conexão'),
                  ),
                );
                break;
              case DioExceptionType.badResponse:
                final statusCode = error.response?.statusCode;
                if (statusCode == 401) {
                  handler.next(
                    DioException(
                      requestOptions: error.requestOptions,
                      error: UnauthorizedException('Não autorizado'),
                    ),
                  );
                } else if (statusCode == 404) {
                  handler.next(
                    DioException(
                      requestOptions: error.requestOptions,
                      error: NotFoundException('Recurso não encontrado'),
                    ),
                  );
                } else if (statusCode != null && statusCode >= 500) {
                  handler.next(
                    DioException(
                      requestOptions: error.requestOptions,
                      error: ServerException('Erro interno do servidor'),
                    ),
                  );
                } else {
                  handler.next(
                    DioException(
                      requestOptions: error.requestOptions,
                      error: ApiException(
                        'Erro na API: ${error.response?.statusMessage ?? 'Erro desconhecido'}',
                        statusCode,
                      ),
                    ),
                  );
                }
                break;
              case DioExceptionType.cancel:
                handler.next(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: NetworkException('Requisição cancelada'),
                  ),
                );
                break;
              case DioExceptionType.connectionError:
                handler.next(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: NetworkException('Erro de conexão'),
                  ),
                );
                break;
              default:
                handler.next(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: NetworkException('Erro de rede desconhecido'),
                  ),
                );
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro inesperado: $e');
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro inesperado: $e');
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro inesperado: $e');
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro inesperado: $e');
    }
  }
}