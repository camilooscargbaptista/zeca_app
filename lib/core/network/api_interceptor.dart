import 'dart:io';
import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import '../services/device_service.dart';
import '../../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../di/injection.dart';

class ApiInterceptor extends Interceptor {
  final StorageService _storageService = getIt<StorageService>();
  final DeviceService _deviceService = DeviceService();
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Adicionar token de autenticação
    final token = await _storageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // ⚠️ OBRIGATÓRIO: Adicionar Device ID para JWT Sliding Window
    try {
      final deviceId = await _deviceService.getDeviceId();
      options.headers['x-device-id'] = deviceId;
    } catch (e) {
      print('⚠️ Erro ao obter Device ID: $e');
    }
    
    // Adicionar informações adicionais
    options.headers['X-Platform'] = Platform.isAndroid ? 'android' : 'ios';
    options.headers['X-App-Version'] = '1.0.0';
    options.headers['X-App-Name'] = 'ZECA';
    
    handler.next(options);
  }
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Tentar refresh token se 401
    if (err.response?.statusCode == 401) {
      try {
        final refreshUseCase = getIt<RefreshTokenUseCase>();
        final result = await refreshUseCase();
        
        result.fold(
          (failure) => handler.next(err),
          (newToken) async {
            // Retry request com novo token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            
            final dio = Dio();
            final response = await dio.fetch(opts);
            handler.resolve(response);
          },
        );
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
