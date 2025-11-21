import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/flavor_config.dart';
import 'core/di/injection.dart';
import 'core/services/api_service.dart';
import 'core/services/token_manager_service.dart';
import 'routes/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/journey/data/services/journey_storage_service.dart';

Future<void> main() async {
  try {
    await mainCommon(Flavor.dev);
  } catch (e, stackTrace) {
    print('Erro na inicialização do app: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

Future<void> mainCommon(Flavor flavor) async {
  final stopwatch = Stopwatch()..start();
  
  WidgetsFlutterBinding.ensureInitialized();
  print('⏱️ [INIT] WidgetsFlutterBinding: ${stopwatch.elapsedMilliseconds}ms');
  
  // Inicializar flavor (síncrono, rápido)
  FlavorConfig.initialize(flavor);
  print('⏱️ [INIT] FlavorConfig: ${stopwatch.elapsedMilliseconds}ms');
  
  // Inicializar DI (crítico, precisa antes do runApp)
  await configureDependencies();
  print('⏱️ [INIT] DI configurado: ${stopwatch.elapsedMilliseconds}ms');
  
  // 🚀 MOSTRAR APP IMEDIATAMENTE (sem esperar outras inicializações)
  runApp(const ZecaApp());
  print('⏱️ [INIT] runApp chamado: ${stopwatch.elapsedMilliseconds}ms');
  
  // ⚡ Inicializações assíncronas DEPOIS do runApp (em paralelo)
  // Isso permite que o splash screen apareça enquanto carrega
  // TODAS AS INICIALIZAÇÕES SÃO LAZY - não bloqueiam o startup
  Future.delayed(Duration(milliseconds: 100), () async {
    try {
      print('🔄 [INIT] Iniciando inicializações lazy...');
  
  // Inicializar Hive
  await Hive.initFlutter();
      print('⏱️ [INIT] Hive inicializado: ${stopwatch.elapsedMilliseconds}ms');
      
      // Inicializar API Service
      await ApiService().initialize();
      print('⏱️ [INIT] ApiService inicializado: ${stopwatch.elapsedMilliseconds}ms');
  
  // Inicializar Journey Storage
  final journeyStorage = JourneyStorageService();
  await journeyStorage.init();
      print('⏱️ [INIT] JourneyStorage inicializado: ${stopwatch.elapsedMilliseconds}ms');
  
      // Por último, inicializar TokenManager (depende de API e Storage)
  await TokenManagerService().initialize();
      print('⏱️ [INIT] TokenManager inicializado: ${stopwatch.elapsedMilliseconds}ms');
      
      print('✅ [INIT] Todas as inicializações completadas em ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.stop();
    } catch (e, stackTrace) {
      print('❌ Erro nas inicializações assíncronas: $e');
      print('Stack trace: $stackTrace');
    }
  });
}

class ZecaApp extends StatelessWidget {
  const ZecaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;
    final router = getIt<AppRouter>();
    
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp.router(
        title: config.appName,
        theme: config.theme,
        routerConfig: router.router,
        debugShowCheckedModeBanner: config.isDevelopment,
      ),
    );
  }
}
