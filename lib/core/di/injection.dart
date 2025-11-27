import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/storage_service.dart';
import '../services/geocoding_service.dart';
import '../network/dio_client.dart';
import '../../routes/app_router.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  final stopwatch = Stopwatch()..start();
  
  print('🔧 [DI] Iniciando configuração de dependências...');
  
  // Register external dependencies
  print('🔧 [DI] Obtendo SharedPreferences...');
  final sharedPreferences = await SharedPreferences.getInstance();
  print('🔧 [DI] SharedPreferences obtido: ${stopwatch.elapsedMilliseconds}ms');
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  print('🔧 [DI] Criando FlutterSecureStorage...');
  const secureStorage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  print('🔧 [DI] FlutterSecureStorage criado: ${stopwatch.elapsedMilliseconds}ms');
  
  // Register StorageService manually
  print('🔧 [DI] Registrando StorageService...');
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(
      getIt<FlutterSecureStorage>(),
      getIt<SharedPreferences>(),
    ),
  );
  
  // Register DioClient manually
  print('🔧 [DI] Registrando DioClient...');
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  
  // Register AppRouter manually
  print('🔧 [DI] Registrando AppRouter...');
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
  
  // Initialize injectable
  print('🔧 [DI] Inicializando injectable...');
  getIt.init();
  
  print('✅ [DI] Configuração completa: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.stop();
}
