import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/storage_service.dart';
import '../network/dio_client.dart';
import '../../routes/app_router.dart';
import '../../features/trip/domain/repositories/trip_repository.dart';
import '../../features/trip/domain/usecases/get_active_trip.dart';
import '../../features/trip/domain/usecases/get_trip_summary.dart';
import '../../features/trip/domain/usecases/get_expense_categories.dart';
import '../../features/trip/domain/usecases/get_expenses_by_trip.dart';
import '../../features/trip/domain/usecases/create_expense.dart';
import '../../features/trip/domain/usecases/start_trip.dart';
import '../../features/trip/domain/usecases/finish_trip.dart';
import '../../features/trip/domain/repositories/expense_repository.dart';
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
  
  // GeocodingService é registrado automaticamente pelo @injectable
  
  // Initialize injectable (registers repositories and datasources)
  print('🔧 [DI] Inicializando injectable...');
  getIt.init();
  
  // Register Trip usecases manually AFTER init (they depend on TripRepository)
  print('🔧 [DI] Registrando Trip usecases...');
  if (!getIt.isRegistered<GetActiveTrip>()) {
    getIt.registerFactory<GetActiveTrip>(
      () => GetActiveTrip(getIt<TripRepository>()),
    );
  }
  if (!getIt.isRegistered<GetTripSummary>()) {
    getIt.registerFactory<GetTripSummary>(
      () => GetTripSummary(getIt<TripRepository>()),
    );
  }
  if (!getIt.isRegistered<GetExpenseCategories>()) {
    getIt.registerFactory<GetExpenseCategories>(
      () => GetExpenseCategories(getIt<ExpenseRepository>()),
    );
  }
  if (!getIt.isRegistered<GetExpensesByTrip>()) {
    getIt.registerFactory<GetExpensesByTrip>(
      () => GetExpensesByTrip(getIt<ExpenseRepository>()),
    );
  }
  if (!getIt.isRegistered<CreateExpense>()) {
    getIt.registerFactory<CreateExpense>(
      () => CreateExpense(getIt<ExpenseRepository>()),
    );
  }
  if (!getIt.isRegistered<StartTrip>()) {
    getIt.registerFactory<StartTrip>(
      () => StartTrip(getIt<TripRepository>()),
    );
  }
  if (!getIt.isRegistered<FinishTrip>()) {
    getIt.registerFactory<FinishTrip>(
      () => FinishTrip(getIt<TripRepository>()),
    );
  }
  
  print('✅ [DI] Configuração completa: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.stop();
}
