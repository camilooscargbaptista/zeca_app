import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../di/injection.dart';
import 'platform_service.dart';
import 'storage_service.dart';
import 'token_manager_service.dart';
import 'user_service.dart';
import 'device_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _authToken;
  String? _refreshToken;
  final DeviceService _deviceService = DeviceService();

  /// Inicializar o serviço de API
  Future<void> initialize() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: ApiConfig.defaultHeaders,
    ));
    
    // Carregar tokens do storage na inicialização
    try {
      final storageService = getIt<StorageService>();
      final accessToken = await storageService.getAccessToken();
      final refreshToken = await storageService.getRefreshToken();
      
      if (accessToken != null) {
        _authToken = accessToken;
        print('✅ Token carregado do storage na inicialização');
      }
      if (refreshToken != null) {
        _refreshToken = refreshToken;
        print('✅ Refresh token carregado do storage na inicialização');
      }
    } catch (e) {
      print('⚠️ Erro ao carregar tokens do storage: $e');
    }

    // Interceptor para logging (apenas em dev)
    if (ApiConfig.environmentConfig['dev']?['debug'] == true) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }

    // Interceptor para adicionar token de autenticação e device ID
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Buscar token da memória ou do storage
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        } else {
          // Se não tem em memória, buscar do storage
          try {
            final storageService = getIt<StorageService>();
            final token = await storageService.getAccessToken();
            if (token != null) {
              _authToken = token;
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            // Ignorar erro - continuar sem token
          }
        }
        
        // ⚠️ OBRIGATÓRIO: Adicionar Device ID para JWT Sliding Window
        try {
          final deviceId = await _deviceService.getDeviceId();
          options.headers['x-device-id'] = deviceId;
        } catch (e) {
          print('⚠️ Erro ao adicionar Device ID no header: $e');
        }
        
        handler.next(options);
      },
      onError: (error, handler) async {
        print('API Error: ${error.message}');
        
        // Tratar erro 429 (Too Many Requests) com retry com backoff exponencial
        if (error.response?.statusCode == 429) {
          print('⚠️ Rate limit atingido (429). Tentando retry com backoff...');
          
          // Máximo de 3 tentativas com backoff exponencial
          int maxRetries = 3;
          int retryCount = 0;
          
          while (retryCount < maxRetries) {
            // Backoff exponencial: 2s, 4s, 8s
            final delaySeconds = 2 * (1 << retryCount);
            print('⏳ Aguardando ${delaySeconds}s antes de retry ${retryCount + 1}/$maxRetries...');
            await Future.delayed(Duration(seconds: delaySeconds));
            
            try {
              // Retry da requisição original
              final opts = error.requestOptions;
              if (_authToken != null) {
                opts.headers['Authorization'] = 'Bearer $_authToken';
              }
              
              final dio = Dio();
              final response = await dio.fetch(opts);
              print('✅ Retry bem-sucedido após ${retryCount + 1} tentativa(s)');
              handler.resolve(response);
              return;
            } catch (retryError) {
              retryCount++;
              if (retryCount >= maxRetries) {
                print('❌ Falhou após $maxRetries tentativas. Erro: $retryError');
                // Continuar com o erro original
                break;
              }
            }
          }
        }
        
        // Se erro 401 (não autorizado), tentar refresh token
        if (error.response?.statusCode == 401) {
          try {
            print('🔄 Tentando refresh token após erro 401...');
            
            // Buscar refresh token do storage se não estiver em memória
            String? refreshTokenToUse = _refreshToken;
            if (refreshTokenToUse == null) {
              try {
                final storageService = getIt<StorageService>();
                refreshTokenToUse = await storageService.getRefreshToken();
                if (refreshTokenToUse != null) {
                  _refreshToken = refreshTokenToUse;
                }
              } catch (e) {
                print('⚠️ Erro ao buscar refresh token do storage: $e');
              }
            }
            
            if (refreshTokenToUse == null) {
              print('❌ Refresh token não encontrado');
              handler.next(error);
              return;
            }
            
            // Tentar refresh token com retry para 429
            Map<String, dynamic>? refreshResponse;
            int refreshRetries = 0;
            const maxRefreshRetries = 3;
            
            while (refreshRetries < maxRefreshRetries) {
              try {
                refreshResponse = await refreshToken(refreshTokenToUse!);
                break; // Sucesso, sair do loop
              } catch (refreshError) {
                if (refreshError is DioException && 
                    refreshError.response?.statusCode == 429) {
                  refreshRetries++;
                  if (refreshRetries < maxRefreshRetries) {
                    final delaySeconds = 2 * (1 << refreshRetries);
                    print('⏳ Rate limit no refresh token. Aguardando ${delaySeconds}s...');
                    await Future.delayed(Duration(seconds: delaySeconds));
                  } else {
                    print('❌ Falha ao renovar token após $maxRefreshRetries tentativas');
                    refreshResponse = {
                      'success': false,
                      'error': 'Rate limit no refresh token',
                    };
                  }
                } else {
                  // Outro erro, não tentar novamente
                  refreshResponse = {
                    'success': false,
                    'error': refreshError.toString(),
                  };
                  break;
                }
              }
            }
            
            if (refreshResponse != null && refreshResponse['success'] == true) {
              print('✅ Token renovado com sucesso no interceptor');
              
              // Atualizar token no storage também (já foi feito no refreshToken, mas garantir)
              if (refreshResponse['data']?['access_token'] != null) {
                final storageService = getIt<StorageService>();
                await storageService.saveAccessToken(refreshResponse['data']['access_token']);
              }
              
              // Retry da requisição original com novo token
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $_authToken';
              
              final dio = Dio();
              final response = await dio.fetch(opts);
              handler.resolve(response);
              return;
            } else {
              print('⚠️ Falha ao renovar token: ${refreshResponse?['error']}');
              
              // Se refresh token falhou, tentar re-login automático
              try {
                print('🔄 Tentando re-login automático após falha no refresh token...');
                final tokenManager = TokenManagerService();
                final autoLoginSuccess = await tokenManager.ensureValidToken(allowAutoLogin: true);
                
                if (autoLoginSuccess) {
                  print('✅ Re-login automático bem-sucedido! Retry da requisição original...');
                  // Retry da requisição original com novo token
                  final opts = error.requestOptions;
                  final newToken = await getIt<StorageService>().getAccessToken();
                  if (newToken != null) {
                    _authToken = newToken;
                    opts.headers['Authorization'] = 'Bearer $newToken';
                    
                    final dio = Dio();
                    final response = await dio.fetch(opts);
                    handler.resolve(response);
                    return;
                  }
                } else {
                  print('❌ Re-login automático também falhou');
                }
              } catch (autoLoginError) {
                print('⚠️ Erro ao tentar re-login automático: $autoLoginError');
              }
              
              // NÃO limpar tokens - dados offline não podem ser perdidos
              // Apenas logar o erro, mas não redirecionar para login durante jornada
              // Os dados ficam salvos localmente e serão sincronizados quando token for renovado
            }
          } catch (e) {
            print('⚠️ Erro ao tentar refresh token: $e');
            
            // Tentar re-login automático também em caso de exceção
            try {
              print('🔄 Tentando re-login automático após exceção no refresh token...');
              final tokenManager = TokenManagerService();
              await tokenManager.ensureValidToken(allowAutoLogin: true);
            } catch (autoLoginError) {
              print('⚠️ Erro ao tentar re-login automático: $autoLoginError');
            }
            
            // NÃO limpar tokens - preservar dados offline
            // Continuar com erro, mas não perder dados locais
          }
        }
        
        // NÃO redirecionar para login automaticamente - deixar o app continuar
        // Os dados estão salvos localmente e serão sincronizados depois
        handler.next(error);
      },
    ));
  }

  /// Definir token de autenticação
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Limpar token de autenticação
  void clearAuthToken() {
    _authToken = null;
  }

  /// Definir refresh token
  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
  }

  /// Limpar refresh token
  void clearRefreshToken() {
    _refreshToken = null;
  }

  /// Obter token de autenticação atual (para WebSocket)
  Future<String?> getToken() async {
    if (_authToken != null) {
      return _authToken;
    }
    // Se não tem em memória, buscar do storage
    try {
      final storageService = getIt<StorageService>();
      final token = await storageService.getAccessToken();
      if (token != null) {
        _authToken = token;
      }
      return token;
    } catch (e) {
      debugPrint('⚠️ Erro ao obter token: $e');
      return null;
    }
  }

  /// Limpar todos os dados de autenticação (tokens e credenciais)
  Future<void> clearAllAuth() async {
    clearAuthToken();
    clearRefreshToken();
    try {
      final storageService = getIt<StorageService>();
      await storageService.clearTokens();
    } catch (e) {
      print('⚠️ Erro ao limpar tokens do storage: $e');
    }
  }

  /// Refresh token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      // Obter Device ID para JWT Sliding Window
      final deviceId = await _deviceService.getDeviceId();
      
      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,  // Corrigido para snake_case (formato esperado pelo backend)
        'device_id': deviceId,          // JWT Sliding Window
      });

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Atualizar token se presente (em memória E no storage)
        if (data['access_token'] != null) {
          setAuthToken(data['access_token']);
          // Salvar também no StorageService para o TokenManagerService
          final storageService = getIt<StorageService>();
          await storageService.saveAccessToken(data['access_token']);
        }
        
        // Atualizar refresh token se presente
        if (data['refresh_token'] != null) {
          setRefreshToken(data['refresh_token']);
          // Salvar também no StorageService
          final storageService = getIt<StorageService>();
          await storageService.saveRefreshToken(data['refresh_token']);
        }
        
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Fazer login
  Future<Map<String, dynamic>> login({
    required String userType,
    required String cpf,
    required String password,
  }) async {
    try {
      // Obter informações do dispositivo para JWT Sliding Window
      final deviceId = await _deviceService.getDeviceId();
      final deviceInfo = await _deviceService.getDeviceInfo();
      
      print('🔐 Login com Device ID: $deviceId');
      print('📱 Device Info: ${deviceInfo['os']} ${deviceInfo['os_version']} - ${deviceInfo['device_model']}');
      
      final response = await _dio.post(
        '/auth/login',
        data: {
          'userType': userType,
          'cpf': cpf,
          'password': password,
          'device_id': deviceId,       // JWT Sliding Window
          'device_info': deviceInfo,   // JWT Sliding Window
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Salvar token se presente (usando access_token do formato real da API)
        if (data['access_token'] != null) {
          setAuthToken(data['access_token']);
          // Salvar também no StorageService para o TokenManagerService
          final storageService = getIt<StorageService>();
          await storageService.saveAccessToken(data['access_token']);
        }
        
        // Salvar refresh token se presente
        if (data['refresh_token'] != null) {
          setRefreshToken(data['refresh_token']);
          // Salvar também no StorageService para o TokenManagerService
          final storageService = getIt<StorageService>();
          await storageService.saveRefreshToken(data['refresh_token']);
        }
        
        // Decodificar JWT para extrair is_autonomous
        bool isAutonomousFromToken = false;
        String? cnpjFromToken;
        if (data['access_token'] != null) {
          try {
            final jwtPayload = _decodeJwtPayload(data['access_token']);
            isAutonomousFromToken = jwtPayload['is_autonomous'] == true;
            cnpjFromToken = jwtPayload['company_cnpj'] as String?;
            debugPrint('🔐 JWT decodificado - is_autonomous: $isAutonomousFromToken, company_cnpj: $cnpjFromToken');
          } catch (e) {
            debugPrint('⚠️ Erro ao decodificar JWT: $e');
          }
        }
        
        // Salvar dados do usuário
        // Priorizar dados do JWT para is_autonomous e cnpj
        final transporterCnpj = cnpjFromToken ?? data['user']?['company']?['cnpj'] ?? '';
        
        UserService().setUserData(
          driverCpf: cpf,
          transporterCnpj: transporterCnpj,
          userName: data['user']?['name'] ?? data['user']?['nome'],
          isAutonomous: isAutonomousFromToken || data['user']?['is_autonomous'] == true,
        );
        
        debugPrint('✅ UserService configurado - isAutonomous: ${UserService().isAutonomous}, transporterCnpj: ${UserService().transporterCnpj}');
        
        // Salvar credenciais para re-login automático (apenas durante jornada)
        try {
          final storageService = getIt<StorageService>();
          await storageService.saveLoginCredentials(
            cpf: cpf,
            password: password,
            userType: userType,
          );
          print('✅ Credenciais salvas para re-login automático');
        } catch (e) {
          print('⚠️ Erro ao salvar credenciais: $e');
        }
        
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar veículo por placa
  Future<Map<String, dynamic>> searchVehicle(String plate) async {
    try {
      final response = await _dio.post('/vehicles/validate-plate', data: {
        'plate': plate,
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': {
            'vehicles': [response.data], // Wrapping in vehicles array for compatibility
          },
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'error': 'Veículo não encontrado ou inativo',
        };
      }
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Validar CNPJ do posto e buscar dados da parceria
  Future<Map<String, dynamic>> validateStation(String cnpj) async {
    try {
      // URL encode do CNPJ para substituir / por %2F
      final encodedCnpj = cnpj.replaceAll('/', '%2F');
      final response = await _dio.get('/companies/station/$encodedCnpj/partnership-data');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'error': 'Posto não encontrado',
        };
      }
      // Extrair mensagem de erro do backend para 400
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map) {
          final message = errorData['message'] ?? errorData['error'] ?? 'Erro de validação';
          return {
            'success': false,
            'error': message.toString(),
          };
        }
      }
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Gerar código de abastecimento
  Future<Map<String, dynamic>> generateRefuelingCode({
    required String vehiclePlate,
    required String fuelType,
    required String stationCnpj,
    bool abastecerArla = false,
    bool? isAutonomous, // Novo parâmetro para forçar modo autônomo
    DateTime? dateTime,
  }) async {
    try {
      // Obter dados do usuário logado
      final userService = UserService();
      if (!userService.isLoggedIn) {
        return {
          'success': false,
          'error': 'Usuário não está logado',
        };
      }

      // Normalizar formatos conforme validações do backend
      // Placa: remover hífens e converter para maiúsculas
      final normalizedPlate = vehiclePlate.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
      
      // Formatar placa conforme regex do backend: /^[A-Z]{3}-?[0-9A-Z]{4}$/
      // Aceita: ABC-1234, ABC1234, ABC1D23 (Mercosul)
      // O backend aceita com ou sem hífen, então manter sem hífen é mais seguro
      final formattedPlate = normalizedPlate;
      
      // Verificar se é autônomo (usar parâmetro se fornecido, senão UserService)
      final isAutonomousUser = isAutonomous ?? userService.isAutonomous;
      
      // Validar CNPJ/CPF - transporterCnpj é obrigatório para TODOS
      // Para frotas = CNPJ da empresa, Para autônomos = CPF do motorista (salvo como cnpj da empresa)
      if (userService.transporterCnpj == null || userService.transporterCnpj!.isEmpty) {
        debugPrint('❌ [API] CNPJ/CPF da transportadora está vazio');
        return {
          'success': false,
          'error': 'Identificador da transportadora não encontrado. Faça login novamente.',
        };
      }
      
      if (userService.driverCpf == null || userService.driverCpf!.isEmpty) {
        debugPrint('❌ [API] CPF do motorista está vazio');
        return {
          'success': false,
          'error': 'CPF do motorista não encontrado. Faça login novamente.',
        };
      }
      
      if (stationCnpj.isEmpty) {
        debugPrint('❌ [API] CNPJ do posto está vazio');
        return {
          'success': false,
          'error': 'CNPJ do posto é obrigatório',
        };
      }
      
      // Remover formatação
      final normalizedTransporterCnpj = userService.transporterCnpj!.replaceAll(RegExp(r'[^\d]'), '');
      final normalizedStationCnpj = stationCnpj.replaceAll(RegExp(r'[^\d]'), '');
      final normalizedDriverCpf = userService.driverCpf!.replaceAll(RegExp(r'[^\d]'), '');
      
      // Validar comprimentos
      // Para autônomos: transporterCnpj contém CPF (11 dígitos)
      // Para frotas: transporterCnpj contém CNPJ (14 dígitos)
      final expectedTransporterLength = isAutonomousUser ? 11 : 14;
      if (normalizedTransporterCnpj.length != expectedTransporterLength) {
        debugPrint('❌ [API] Identificador da transportadora inválido: ${normalizedTransporterCnpj.length} dígitos (esperado: $expectedTransporterLength)');
        return {
          'success': false,
          'error': isAutonomousUser 
              ? 'CPF do autônomo inválido' 
              : 'CNPJ da transportadora inválido',
        };
      }
      
      if (normalizedStationCnpj.length != 14) {
        debugPrint('❌ [API] CNPJ do posto inválido: ${normalizedStationCnpj.length} dígitos');
        return {
          'success': false,
          'error': 'CNPJ do posto inválido',
        };
      }
      
      if (normalizedDriverCpf.length != 11) {
        debugPrint('❌ [API] CPF do motorista inválido: ${normalizedDriverCpf.length} dígitos');
        return {
          'success': false,
          'error': 'CPF do motorista inválido',
        };
      }
      
      // Formatar para envio
      // Para autônomos: formatar como CPF; Para frotas: formatar como CNPJ
      final formattedTransporterCnpj = isAutonomousUser 
          ? _formatCpf(normalizedTransporterCnpj) 
          : _formatCnpj(normalizedTransporterCnpj);
      final formattedStationCnpj = _formatCnpj(normalizedStationCnpj);
      final formattedDriverCpf = _formatCpf(normalizedDriverCpf);

      final requestData = {
        'vehicle_plate': formattedPlate,
        'driver_cpf': formattedDriverCpf,
        'fuel_type': fuelType,
        'transporter_cnpj': formattedTransporterCnpj, // Sempre envia (CPF ou CNPJ)
        'station_cnpj': formattedStationCnpj,
        'abastecer_arla': abastecerArla,
        'date_time': (dateTime ?? DateTime.now()).toIso8601String(),
        'platform': PlatformService.platformForApi,
        'is_autonomous': isAutonomousUser,
      };

      debugPrint('📤 [API] Gerando código de abastecimento:');
      debugPrint('   Placa: $vehiclePlate -> $formattedPlate');
      debugPrint('   CPF: ${userService.driverCpf} -> $formattedDriverCpf');
      debugPrint('   Autônomo: $isAutonomousUser');
      debugPrint('   ${isAutonomousUser ? "CPF" : "CNPJ"} Transportadora: ${userService.transporterCnpj} -> $formattedTransporterCnpj');
      debugPrint('   CNPJ Posto: $stationCnpj -> $formattedStationCnpj');
      debugPrint('   Combustível: $fuelType');
      debugPrint('   Plataforma: ${PlatformService.platformForApi}');
      debugPrint('   Data completa: $requestData');

      final response = await _dio.post('/codes/generate', data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return {
          'success': false,
          'error': 'Já existe um código ativo para este veículo/motorista',
        };
      }
      
      // Log detalhado para erro 400
      if (e.response?.statusCode == 400) {
        debugPrint('❌ [API] Erro 400 - Bad Request:');
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   Data enviada: ${e.requestOptions.data}');
        debugPrint('   Resposta: ${e.response?.data}');
        debugPrint('   Mensagem: ${e.message}');
        
        // Extrair mensagens de validação do backend
        final errorData = e.response?.data;
        if (errorData is Map) {
          final message = errorData['message'] ?? errorData['error'] ?? 'Erro de validação';
          final errors = errorData['errors'] as List?;
          if (errors != null && errors.isNotEmpty) {
            final errorMessages = errors.map((e) => e.toString()).join(', ');
            return {
              'success': false,
              'error': 'Erro de validação: $errorMessages',
            };
          }
          return {
            'success': false,
            'error': message.toString(),
          };
        }
      }
      
      return _handleDioError(e);
    } catch (e) {
      debugPrint('❌ [API] Erro inesperado ao gerar código: $e');
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Formata CNPJ para o formato esperado pelo backend (XX.XXX.XXX/XXXX-XX)
  String _formatCnpj(String cnpj) {
    if (cnpj.length != 14) return cnpj; // Se não tiver 14 dígitos, retornar como está
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12)}';
  }

  /// Formata CPF para o formato esperado pelo backend (XXX.XXX.XXX-XX)
  String _formatCpf(String cpf) {
    if (cpf.length != 11) return cpf; // Se não tiver 11 dígitos, retornar como está
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  /// Buscar postos próximos
  Future<Map<String, dynamic>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radius = 10.0, // km
  }) async {
    try {
      final response = await _dio.get('/stations/nearby', queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Obter status do código de abastecimento
  /// Endpoint: GET /api/v1/codes/status/:code
  Future<Map<String, dynamic>> getCodeStatus(String code) async {
    try {
      final response = await _dio.get('/codes/status/$code');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar refueling por código
  /// Endpoint: GET /api/v1/refueling/by-code/:code
  /// Solução 2: Buscar pelo código para obter refuelingId após registro pelo posto
  Future<Map<String, dynamic>> getRefuelingByCode(String code) async {
    try {
      // Remover hífens do código se houver
      final cleanCode = code.replaceAll('-', '');
      final response = await _dio.get('/refueling/by-code/$cleanCode');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Obter status do abastecimento
  Future<Map<String, dynamic>> getRefuelingStatus(String refuelingId) async {
    try {
      final response = await _dio.get('/refueling/$refuelingId');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Obter dados pendentes de validação
  Future<Map<String, dynamic>> getPendingValidation(String refuelingId) async {
    try {
      // Usar endpoint específico para dados pendentes de validação
      final response = await _dio.get('/refueling/$refuelingId/pending-validation');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Validar abastecimento (confirmar)
  /// POST /api/v1/refueling/:id/validate
  Future<Map<String, dynamic>> validateRefueling({
    required String refuelingId,
    required String device,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      final requestData = {
        'device': device,
        'latitude': latitude,
        'longitude': longitude,
        if (address != null && address.isNotEmpty) 'address': address,
      };

      debugPrint('📤 [API] POST /refueling/$refuelingId/validate');
      debugPrint('📤 [API] Request data: $requestData');

      final response = await _dio.post(
        '/refueling/$refuelingId/validate',
        data: requestData,
      );

      debugPrint('📥 [API] Status code: ${response.statusCode}');
      debugPrint('📥 [API] Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ [API] DioException: ${e.message}');
      debugPrint('❌ [API] Status code: ${e.response?.statusCode}');
      debugPrint('❌ [API] Response: ${e.response?.data}');
      return _handleDioError(e);
    } catch (e) {
      debugPrint('❌ [API] Erro inesperado: $e');
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Rejeitar abastecimento
  /// POST /api/v1/refueling/:id/reject
  Future<Map<String, dynamic>> rejectRefueling({
    required String refuelingId,
    required String device,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      final requestData = {
        'device': device,
        'latitude': latitude,
        'longitude': longitude,
        if (address != null && address.isNotEmpty) 'address': address,
      };

      final response = await _dio.post(
        '/refueling/$refuelingId/reject',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar abastecimentos pendentes de validação do motorista
  /// GET /api/v1/refueling?status=AGUARDANDO_VALIDACAO_MOTORISTA
  Future<Map<String, dynamic>> getPendingRefuelings() async {
    try {
      final response = await _dio.get(
        '/refueling',
        queryParameters: {
          'status': 'AGUARDANDO_VALIDACAO_MOTORISTA',
          'limit': 100, // Limite alto para pegar todos os pendentes
          'sortBy': 'created_at',
          'sortOrder': 'DESC',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Registrar token FCM do dispositivo
  Future<Map<String, dynamic>> registerDeviceToken({
    required String deviceToken,
    required String platform, // 'ios' ou 'android'
  }) async {
    try {
      final userService = UserService();
      if (!userService.isLoggedIn) {
        return {
          'success': false,
          'error': 'Usuário não está logado',
        };
      }

      // TODO: Implementar endpoint real quando backend estiver pronto
      // POST /users/device-token
      final response = await _dio.post('/users/device-token', data: {
        'device_token': deviceToken,
        'platform': platform,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Tratar erros do Dio
  Map<String, dynamic> _handleDioError(DioException e) {
    String errorMessage = 'Erro de conexão';
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Timeout de conexão';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Timeout ao enviar dados';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Timeout ao receber dados';
        break;
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          errorMessage = 'Não autorizado';
        } else if (e.response?.statusCode == 404) {
          errorMessage = 'Recurso não encontrado';
        } else if (e.response?.statusCode == 500) {
          errorMessage = 'Erro interno do servidor';
        } else {
          errorMessage = 'Erro do servidor: ${e.response?.statusCode}';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Requisição cancelada';
        break;
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          errorMessage = 'Sem conexão com a internet';
        } else {
          errorMessage = 'Erro desconhecido: ${e.message}';
        }
        break;
      default:
        errorMessage = 'Erro: ${e.message}';
    }

    return {
      'success': false,
      'error': errorMessage,
    };
  }

  // ============================================================
  // JORNADA - Métodos de Jornada de Trabalho
  // ============================================================

  /// Iniciar jornada
  Future<Map<String, dynamic>> startJourney({
    required String placa,
    required int odometroInicial,
    String? destino,
    int? previsaoKm,
    String? observacoes,
  }) async {
    try {
      final data = <String, dynamic>{
        'placa': placa,
        'odometro_inicial': odometroInicial,
      };

      // Adicionar campos opcionais apenas se foram fornecidos
      if (destino != null && destino.isNotEmpty) {
        data['destino'] = destino;
      }
      if (previsaoKm != null && previsaoKm > 0) {
        data['previsao_km'] = previsaoKm;
      }
      if (observacoes != null && observacoes.isNotEmpty) {
        data['observacoes'] = observacoes;
      }

      final response = await _dio.post(
        '/journeys/start',
        data: data,
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Adicionar ponto de localização (single)
  Future<Map<String, dynamic>> addLocationPoint({
    required String journeyId,
    required double latitude,
    required double longitude,
    required double velocidade,
    required DateTime timestamp,
  }) async {
    try {
      final timestampString = timestamp.toIso8601String();
      
      // Debug: verificar timestamp sendo enviado
      debugPrint('📤 [API] Enviando ponto de localização:');
      debugPrint('   - Journey ID: $journeyId');
      debugPrint('   - Lat/Lng: $latitude, $longitude');
      debugPrint('   - Velocidade: $velocidade km/h');
      debugPrint('   - Timestamp Local: $timestamp');
      debugPrint('   - Timestamp ISO8601: $timestampString');
      debugPrint('   - Timezone: ${timestamp.timeZoneName} (offset: ${timestamp.timeZoneOffset})');
      
      final response = await _dio.post(
        '/journeys/location-point',
        data: {
          'journey_id': journeyId,
          'latitude': latitude,
          'longitude': longitude,
          'velocidade': velocidade,
          'timestamp': timestampString,
        },
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Sincronizar múltiplos pontos (batch)
  Future<Map<String, dynamic>> syncLocationPoints(List<Map<String, dynamic>> points) async {
    try {
      final response = await _dio.post(
        '/journeys/location-points/sync',
        data: {
          'points': points,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Toggle descanso (iniciar/retomar)
  Future<Map<String, dynamic>> toggleRest({
    required String journeyId,
    required bool isStartingRest,
  }) async {
    try {
      final response = await _dio.post(
        '/journeys/toggle-rest',
        data: {
          'journey_id': journeyId,
          'is_starting_rest': isStartingRest,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Finalizar jornada (retorna jornada com segments_summary)
  Future<Map<String, dynamic>> finishJourney({
    required String journeyId,
    int? odometroFinal,
  }) async {
    try {
      final response = await _dio.post(
        '/journeys/finish',
        data: {
          'journey_id': journeyId,
          if (odometroFinal != null) 'odometro_final': odometroFinal,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar todos os trechos de uma jornada
  Future<Map<String, dynamic>> getJourneySegments(String journeyId) async {
    try {
      debugPrint('📡 [API] Buscando trechos da jornada: $journeyId');
      
      final response = await _dio.get('/journeys/$journeyId/segments');

      if (response.statusCode == 200) {
        debugPrint('✅ [API] Trechos carregados com sucesso');
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        debugPrint('❌ [API] Erro ao buscar trechos: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ [API] DioException ao buscar trechos: ${e.message}');
      return _handleDioError(e);
    } catch (e) {
      debugPrint('❌ [API] Erro inesperado ao buscar trechos: $e');
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar detalhes de um trecho específico
  Future<Map<String, dynamic>> getJourneySegmentDetails({
    required String journeyId,
    required String segmentId,
  }) async {
    try {
      debugPrint('📡 [API] Buscando detalhes do trecho: $segmentId (jornada: $journeyId)');
      
      final response = await _dio.get('/journeys/$journeyId/segments/$segmentId');

      if (response.statusCode == 200) {
        debugPrint('✅ [API] Detalhes do trecho carregados com sucesso');
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        debugPrint('❌ [API] Erro ao buscar detalhes do trecho: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ [API] DioException ao buscar detalhes do trecho: ${e.message}');
      return _handleDioError(e);
    } catch (e) {
      debugPrint('❌ [API] Erro inesperado ao buscar detalhes do trecho: $e');
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Obter jornada ativa
  Future<Map<String, dynamic>> getActiveJourney() async {
    try {
      final response = await _dio.get('/journeys/active');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else if (response.statusCode == 404) {
        // 404 não é erro - significa que não há jornada ativa (comportamento esperado)
        return {
          'success': false,
          'data': null,
          'error': null, // Não é erro, apenas não há jornada ativa
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      // 404 não é erro - significa que não há jornada ativa (comportamento esperado)
      if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'data': null,
          'error': null, // Não é erro, apenas não há jornada ativa
        };
      }
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Listar jornadas
  Future<Map<String, dynamic>> getJourneys({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (status != null) queryParams['status'] = status;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _dio.get('/journeys', queryParameters: queryParams);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Obter detalhes de uma jornada
  Future<Map<String, dynamic>> getJourneyDetails(String journeyId) async {
    try {
      final response = await _dio.get('/journeys/$journeyId');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Cancelar jornada
  Future<Map<String, dynamic>> cancelJourney(String journeyId) async {
    try {
      final response = await _dio.post('/journeys/$journeyId/cancel');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  // ============================================================
  // CHECKLIST APIs
  // ============================================================

  /// Buscar checklist por placa
  /// GET /api/v1/checklists/by-plate/:plate?execution_type=pre_trip
  Future<Map<String, dynamic>> getChecklistByPlate({
    required String plate,
    String? executionType, // 'pre_trip' ou 'post_trip'
  }) async {
    try {
      // Remover hífens e espaços, converter para maiúsculas
      final cleanPlate = plate.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
      
      debugPrint('🔍 [API] Buscando checklist para placa: $plate (limpa: $cleanPlate)');
      debugPrint('🔍 [API] Execution type: $executionType');
      
      final queryParams = <String, dynamic>{};
      if (executionType != null) {
        queryParams['execution_type'] = executionType;
      }

      final url = '/checklists/by-plate/$cleanPlate';
      debugPrint('🔍 [API] URL: $url');
      debugPrint('🔍 [API] Query params: $queryParams');

      final response = await _dio.get(
        url,
        queryParameters: queryParams,
      );

      debugPrint('📥 [API] Status code: ${response.statusCode}');
      debugPrint('📥 [API] Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        // Verificar se a resposta tem o formato esperado
        if (data is Map && data.containsKey('success') && data['success'] == true) {
          return {
            'success': true,
            'data': data['data'],
          };
        } else if (data is Map && data.containsKey('checklists')) {
          // Formato direto com checklists
          return {
            'success': true,
            'data': data,
          };
        } else {
          // Formato direto
          return {
            'success': true,
            'data': data,
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ [API] DioException: ${e.message}');
      debugPrint('❌ [API] Status code: ${e.response?.statusCode}');
      debugPrint('❌ [API] Response: ${e.response?.data}');
      
      if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'error': 'Nenhum checklist encontrado para este veículo',
        };
      }
      return _handleDioError(e);
    } catch (e) {
      debugPrint('❌ [API] Erro inesperado: $e');
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Iniciar execução de checklist
  /// POST /api/v1/checklist-executions
  Future<Map<String, dynamic>> startChecklistExecution({
    required String fleetTemplateId,
    required String vehicleId,
    required String executionType, // 'pre_trip' ou 'post_trip'
    String? tripId,
    int? odometerReading,
    int? fuelLevel,
    Map<String, dynamic>? location,
  }) async {
    try {
      final requestData = {
        'fleet_template_id': fleetTemplateId,
        'vehicle_id': vehicleId,
        'execution_type': executionType,
        if (tripId != null) 'trip_id': tripId,
        if (odometerReading != null) 'odometer_reading': odometerReading,
        if (fuelLevel != null) 'fuel_level': fuelLevel,
        if (location != null) 'location': location,
      };

      final response = await _dio.post(
        '/checklist-executions',
        data: requestData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Responder item do checklist
  /// PUT /api/v1/checklist-executions/:execution_id/items/:item_id
  Future<Map<String, dynamic>> answerChecklistItem({
    required String executionId,
    required String itemId,
    required String responseValue,
    bool isConforming = true,
    String? notes,
  }) async {
    try {
      final requestData = {
        'response_value': responseValue,
        'is_conforming': isConforming,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final response = await _dio.put(
        '/checklist-executions/$executionId/items/$itemId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Enviar foto para o checklist (opcional)
  /// POST /api/v1/checklist-executions/:id/photos
  Future<Map<String, dynamic>> uploadChecklistPhoto({
    required String executionId,
    required File photoFile,
    String? executionItemId,
    String? description,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last,
        ),
        if (executionItemId != null) 'execution_item_id': executionItemId,
        if (description != null) 'description': description,
      });

      final response = await _dio.post(
        '/checklist-executions/$executionId/photos',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Finalizar checklist
  /// PUT /api/v1/checklist-executions/:id/complete
  Future<Map<String, dynamic>> completeChecklistExecution({
    required String executionId,
    String? notes,
    String? signatureData, // base64: "data:image/png;base64,..."
    Map<String, dynamic>? location,
  }) async {
    try {
      final requestData = {
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (signatureData != null && signatureData.isNotEmpty) 
          'signature_data': signatureData,
        if (location != null) 'location': location,
      };

      final response = await _dio.put(
        '/checklist-executions/$executionId/complete',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar últimos abastecimentos
  Future<Map<String, dynamic>> getLastRefuelings({int limit = 5}) async {
    try {
      final response = await _dio.get(
        '/refueling',
        queryParameters: {
          'limit': limit,
          'sortBy': 'created_at',
          'sortOrder': 'DESC',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Buscar veículos do motorista logado
  /// GET /api/v1/vehicles
  Future<Map<String, dynamic>> getMyVehicles() async {
    try {
      final response = await _dio.get('/vehicles');

      if (response.statusCode == 200) {
        // Normalizar resposta para sempre ter 'vehicles' como array
        List<dynamic> vehicles = [];
        if (response.data is List) {
          vehicles = response.data;
        } else if (response.data is Map) {
          if (response.data['data'] is List) {
            vehicles = response.data['data'];
          } else if (response.data['vehicles'] is List) {
            vehicles = response.data['vehicles'];
          } else if (response.data['data']?['vehicles'] is List) {
            vehicles = response.data['data']['vehicles'];
          }
        }
        
        return {
          'success': true,
          'data': {'vehicles': vehicles},
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Contar veículos do autônomo
  /// Retorna a quantidade de veículos cadastrados pelo autônomo
  Future<Map<String, dynamic>> countAutonomousVehicles() async {
    try {
      final response = await _dio.get('/autonomous/vehicles/count');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Método GET genérico para requisições HTTP
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Método POST genérico para requisições HTTP
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Método PUT genérico para requisições HTTP
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  // ============================================
  // PASSWORD RESET VIA CPF
  // ============================================

  /// Solicitar recuperação de senha via CPF
  /// POST /auth/forgot-password/cpf
  Future<Map<String, dynamic>> forgotPasswordByCpf(String cpf) async {
    try {
      // Remover máscara do CPF
      final cleanCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');
      
      final response = await _dio.post(
        '/auth/forgot-password/cpf',
        data: {'cpf': cleanCpf},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Se o CPF estiver cadastrado, um email será enviado.',
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      // Sempre retornar sucesso para não revelar se CPF existe
      return {
        'success': true,
        'message': 'Se o CPF estiver cadastrado, um email será enviado.',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Verificar token de recuperação de senha
  /// POST /auth/verify-reset-token
  Future<Map<String, dynamic>> verifyResetToken({
    required String cpf,
    required String token,
  }) async {
    try {
      final cleanCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');
      
      final response = await _dio.post(
        '/auth/verify-reset-token',
        data: {
          'cpf': cleanCpf,
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'valid': response.data['valid'] ?? false,
        };
      } else {
        return {
          'success': false,
          'valid': false,
          'error': 'Erro no servidor',
        };
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      return {
        'success': false,
        'valid': false,
        'error': errorData?['message'] ?? 'Código inválido ou expirado',
      };
    } catch (e) {
      return {
        'success': false,
        'valid': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Redefinir senha via CPF
  /// POST /auth/reset-password/cpf
  Future<Map<String, dynamic>> resetPasswordByCpf({
    required String cpf,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final cleanCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');
      
      final response = await _dio.post(
        '/auth/reset-password/cpf',
        data: {
          'cpf': cleanCpf,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Senha alterada com sucesso',
        };
      } else {
        return {
          'success': false,
          'error': 'Erro no servidor: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String errorMessage = 'Erro ao redefinir senha';
      
      if (errorData is Map) {
        errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro inesperado: $e',
      };
    }
  }

  /// Decodificar payload do JWT
  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return {};
      }

      // Decodificar payload (parte 2 do JWT)
      final payload = parts[1];
      // Adicionar padding se necessário
      final normalizedPayload = payload.padRight(
        (payload.length + 3) ~/ 4 * 4,
        '=',
      );
      
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      return payloadMap;
    } catch (e) {
      debugPrint('⚠️ Erro ao decodificar token JWT: $e');
      return {};
    }
  }
}
