import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page_simple.dart';
import 'features/home/presentation/pages/home_page_simple.dart';
import 'features/refueling/presentation/pages/refueling_code_page_simple.dart';
import 'features/refueling/presentation/pages/refueling_waiting_page.dart';
import 'features/refueling/presentation/pages/refueling_validation_page.dart';
import 'features/refueling/presentation/pages/pending_refuelings_page.dart';
import 'features/history/presentation/pages/history_page_simple.dart';
import 'core/services/app_initialization_service.dart';
import 'core/services/api_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/deep_link_service.dart';
import 'core/theme/app_colors.dart';

// Handler para notificações em background (deve ser top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📨 Notificação recebida em background: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configurar handler de notificações em background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // Inicializar Firebase Service (push notifications)
  await FirebaseService().initialize();
  
  await AppInitializationService.initialize();
  
  // Inicializar API Service
  ApiService().initialize();
  
  runApp(const ZecaApp());
}

class ZecaApp extends StatelessWidget {
  const ZecaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeepLinkHandler(
      child: MaterialApp.router(
        title: 'ZECA - App de Abastecimento',
        theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2A70C0, {
          50: const Color(0xFFE3F2FD),
          100: const Color(0xFFBBDEFB),
          200: const Color(0xFF90CAF9),
          300: const Color(0xFF64B5F6),
          400: const Color(0xFF42A5F5),
          500: const Color(0xFF2A70C0), // ZECA Blue
          600: const Color(0xFF1E5A9A),
          700: const Color(0xFF1976D2),
          800: const Color(0xFF1565C0),
          900: const Color(0xFF0D47A1),
        }),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.zecaBlue,
          primary: AppColors.zecaBlue,
          secondary: AppColors.zecaGreen,
          surface: AppColors.zecaWhite,
          background: AppColors.zecaWhite,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.zecaBlue,
          foregroundColor: AppColors.zecaWhite,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.zecaBlue,
            foregroundColor: AppColors.zecaWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.zecaBlue,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.zecaBlue,
            side: BorderSide(color: AppColors.zecaBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Widget para processar deep links quando app está rodando
class DeepLinkHandler extends StatefulWidget {
  final Widget child;
  
  const DeepLinkHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessageHandlers();
  }

  void _setupFirebaseMessageHandlers() {
    // Handler para quando app está em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;
      debugPrint('📨 Notificação recebida em foreground: ${message.messageId}');
      debugPrint('   Título: ${message.notification?.title}');
      debugPrint('   Corpo: ${message.notification?.body}');
      debugPrint('   Dados: $data');
      
      if (data['type'] == 'refueling_validation_pending') {
        // Processar deep link se app estiver rodando
        if (mounted) {
          DeepLinkService().handleDeepLink(context, data);
        }
      }
    });

    // Handler para quando app está em background e usuário toca na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📨 Notificação aberta (app em background): ${message.messageId}');
      if (mounted) {
        DeepLinkService().handleDeepLink(context, message.data);
      }
    });

    // Verificar se app foi aberto por uma notificação (quando estava fechado)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('📨 App aberto por notificação: ${message.messageId}');
        // Aguardar um pouco para o app inicializar completamente
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            DeepLinkService().handleDeepLink(context, message.data);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true, // Habilitar logs de debug do GoRouter
  routes: [
    // Log para verificar se as rotas estão sendo registradas
    // debugPrint('🔍 Registrando rotas do GoRouter...'),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPageSimple(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePageSimple(),
    ),
    GoRoute(
      path: '/refueling-code',
      name: 'refueling-code',
      builder: (context, state) => const RefuelingCodePageSimple(),
    ),
    GoRoute(
      path: '/refueling-waiting',
      name: 'refueling-waiting',
      builder: (context, state) {
        debugPrint('🎯 ========== GoRoute builder CHAMADO para /refueling-waiting ==========');
        debugPrint('📍 State.uri: ${state.uri}');
        debugPrint('📍 State.fullPath: ${state.fullPath}');
        debugPrint('📍 State.matchedLocation: ${state.matchedLocation}');
        debugPrint('📍 State.extra: ${state.extra}');
        debugPrint('📍 State.extra tipo: ${state.extra.runtimeType}');
        final extra = state.extra as Map<String, dynamic>?;
        debugPrint('📍 Extra parseado: $extra');
        debugPrint('📍 refueling_id: ${extra?['refueling_id']}');
        debugPrint('📍 refueling_code: ${extra?['refueling_code']}');
        debugPrint('📍 vehicle_data: ${extra?['vehicle_data']}');
        debugPrint('📍 station_data: ${extra?['station_data']}');
        debugPrint('🎯 Criando RefuelingWaitingPage...');
        return RefuelingWaitingPage(
          refuelingId: extra?['refueling_id'] ?? '',
          refuelingCode: extra?['refueling_code'] ?? '',
          vehicleData: extra?['vehicle_data'],
          stationData: extra?['station_data'],
        );
      },
    ),
    GoRoute(
      path: '/refueling-validation/:id',
      name: 'refueling-validation',
      builder: (context, state) {
        final refuelingId = state.pathParameters['id'] ?? '';
        return RefuelingValidationPage(refuelingId: refuelingId);
      },
    ),
    GoRoute(
      path: '/pending-refuelings',
      name: 'pending-refuelings',
      builder: (context, state) => const PendingRefuelingsPage(),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryPageSimple(),
    ),
  ],
  errorBuilder: (context, state) {
    debugPrint('❌ GoRouter Error Builder chamado');
    debugPrint('📍 URI: ${state.uri}');
    debugPrint('📍 FullPath: ${state.fullPath}');
    debugPrint('📍 MatchedLocation: ${state.matchedLocation}');
    debugPrint('📍 Error: ${state.error}');
    debugPrint('📍 Extra: ${state.extra}');
    debugPrint('📍 PathParameters: ${state.pathParameters}');
    debugPrint('📍 QueryParameters: ${state.queryParameters}');
    debugPrint('📍 Routes disponíveis: ${_router.configuration.routes.map((r) => r.path).join(", ")}');
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Página não encontrada',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'A página que você está procurando não existe.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Voltar ao início'),
          ),
        ],
      ),
    ),
  );
  },
);
