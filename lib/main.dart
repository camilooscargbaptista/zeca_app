import 'dart:async';
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
  // Capturar erros não tratados
  FlutterError.onError = (FlutterErrorDetails details) {
    print('❌ [FLUTTER_ERROR] ${details.exception}');
    print('❌ [FLUTTER_ERROR] Stack: ${details.stack}');
    FlutterError.presentError(details);
  };
  
  // Configurar ErrorWidget.builder para mostrar erros de forma amigável
  ErrorWidget.builder = (FlutterErrorDetails details) {
    print('❌ [ERROR_WIDGET] ${details.exception}');
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Erro ao renderizar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${details.exception}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  };
  
  // Capturar erros de zona assíncrona
  runZonedGuarded(() async {
    try {
      await mainCommon(Flavor.dev);
    } catch (e, stackTrace) {
      print('❌ [MAIN] Erro na inicialização do app: $e');
      print('❌ [MAIN] Stack trace: $stackTrace');
      rethrow;
    }
  }, (error, stackTrace) {
    print('❌ [ZONE_ERROR] Erro não capturado: $error');
    print('❌ [ZONE_ERROR] Stack: $stackTrace');
  });
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
    try {
      final config = FlavorConfig.instance;
      print('🔧 [ZecaApp] FlavorConfig obtido');
      
      final router = getIt<AppRouter>();
      print('🔧 [ZecaApp] AppRouter obtido');
      
      final authBloc = getIt<AuthBloc>();
      print('🔧 [ZecaApp] AuthBloc obtido');
      
      return BlocProvider<AuthBloc>(
        create: (context) => authBloc,
        child: MaterialApp.router(
          title: config.appName,
          theme: config.theme,
          routerConfig: router.router,
          // debugShowCheckedModeBanner: config.isDevelopment,
          debugShowCheckedModeBanner: false,
        ),
      );
    } catch (e, stackTrace) {
      print('❌ [ZecaApp] Erro crítico no build: $e');
      print('❌ [ZecaApp] Stack trace: $stackTrace');
      
      // Fallback: mostrar tela de erro
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao inicializar o app',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Tentar reiniciar
                    main();
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
