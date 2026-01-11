import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page_simple.dart';
import '../features/home/presentation/pages/home_page_simple.dart';
import '../features/refueling/presentation/pages/refueling_code_page_simple.dart';
import '../features/refueling/presentation/pages/refueling_waiting_page.dart';
import '../features/refueling/presentation/pages/pending_refuelings_page.dart';
import '../features/refueling/presentation/pages/autonomous_payment_success_page.dart';
import '../features/refueling/data/models/payment_confirmed_model.dart';
import '../features/journey/presentation/pages/journey_page.dart';
import '../features/journey/presentation/bloc/journey_bloc.dart';
import '../features/journey/presentation/bloc/journey_event.dart';
import '../features/journey_start/presentation/pages/journey_start_page.dart';
import '../features/journey_start/presentation/pages/journey_dashboard_page.dart';
import '../features/checklist/presentation/pages/checklist_page.dart';
import '../features/journey/presentation/pages/journey_segments_page.dart';
import '../core/services/api_service.dart';
import '../core/services/location_service.dart';
import '../features/journey/data/services/journey_storage_service.dart';
import '../core/di/injection.dart';
// Autonomous imports
import '../features/autonomous/presentation/pages/autonomous_register_page.dart';
import '../features/autonomous/presentation/pages/autonomous_vehicles_page.dart';
import '../features/autonomous/presentation/pages/autonomous_vehicle_form_page.dart';
import '../features/autonomous/presentation/pages/autonomous_journey_start_page.dart';
import '../features/autonomous/presentation/pages/autonomous_first_access_page.dart';
import '../features/autonomous/presentation/bloc/autonomous_registration_bloc.dart';
import '../features/autonomous/presentation/bloc/autonomous_vehicles_bloc.dart';
import '../features/home/presentation/pages/nearby_stations_page.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) {
          debugPrint('🛣️ [Router] Navegando para /splash');
          return const SplashPage();
        },
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
          final extra = state.extra as Map<String, dynamic>?;
          return RefuelingWaitingPage(
            refuelingId: extra?['refueling_id'] ?? '',
            refuelingCode: extra?['refueling_code'] ?? '',
            vehicleData: extra?['vehicle_data'],
            stationData: extra?['station_data'],
          );
        },
      ),
      GoRoute(
        path: '/pending-refuelings',
        name: 'pending-refuelings',
        builder: (context, state) => const PendingRefuelingsPage(),
      ),
      GoRoute(
        path: '/autonomous-success',
        name: 'autonomous-success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final refuelingCode = extra?['refuelingCode'] as String?;
          
          PaymentConfirmedModel? data;
          
          // Só construir o model se tivermos dados reais do pagamento
          if (extra != null && extra.containsKey('totalValue')) {
             data = PaymentConfirmedModel(
              refuelingCode: refuelingCode ?? '',
              status: extra['status'] ?? 'CONCLUIDO',
              totalValue: (extra['totalValue'] as num?)?.toDouble() ?? 0.0,
              quantityLiters: (extra['quantityLiters'] as num?)?.toDouble() ?? 0.0,
              pricePerLiter: (extra['pricePerLiter'] as num?)?.toDouble() ?? 0.0,
              pumpPrice: (extra['pumpPrice'] as num?)?.toDouble() ?? 0.0,
              savings: (extra['savings'] as num?)?.toDouble() ?? 0.0,
              stationName: extra['stationName'] ?? 'Posto',
              vehiclePlate: extra['vehiclePlate'] ?? '',
              fuelType: extra['fuelType'] ?? 'Combustível',
              timestamp: extra['timestamp'] ?? DateTime.now().toIso8601String(),
            );
          }

          return AutonomousPaymentSuccessPage(
            data: data,
            refuelingCode: refuelingCode,
          );
        },
      ),
      GoRoute(
        path: '/journey-start',
        name: 'journey-start',
        builder: (context, state) => const JourneyStartPage(),
      ),
      GoRoute(
        path: '/journey-dashboard',
        name: 'journey-dashboard',
        builder: (context, state) => const JourneyDashboardPage(),
      ),
      GoRoute(
        path: '/journey',
        name: 'journey',
        builder: (context, state) => BlocProvider(
          create: (context) => JourneyBloc(
            apiService: ApiService(),
            locationService: LocationService(),
            storageService: JourneyStorageService(),
          )..add(const LoadActiveJourney()),
          child: const JourneyPage(),
        ),
      ),
      GoRoute(
        path: '/checklist',
        name: 'checklist',
        builder: (context, state) => const ChecklistPage(),
      ),
      GoRoute(
        path: '/journey-segments/:journeyId',
        name: 'journey-segments',
        builder: (context, state) {
          final journeyId = state.pathParameters['journeyId']!;
          return JourneySegmentsPage(journeyId: journeyId);
        },
      ),
      // Rotas para Motorista Autônomo
      GoRoute(
        path: '/autonomous/register',
        name: 'autonomous-register',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<AutonomousRegistrationBloc>(),
            child: const AutonomousRegisterPage(),
          );
        },
      ),
      GoRoute(
        path: '/autonomous/vehicles',
        name: 'autonomous-vehicles',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<AutonomousVehiclesBloc>(),
            child: const AutonomousVehiclesPage(),
          );
        },
      ),
      GoRoute(
        path: '/autonomous/vehicles/add',
        name: 'autonomous-vehicles-add',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<AutonomousVehiclesBloc>(),
            child: const AutonomousVehicleFormPage(),
          );
        },
      ),
      GoRoute(
        path: '/autonomous/vehicles/edit/:vehicleId',
        name: 'autonomous-vehicles-edit',
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId']!;
          return BlocProvider(
            create: (context) => getIt<AutonomousVehiclesBloc>(),
            child: AutonomousVehicleFormPage(vehicleId: vehicleId),
          );
        },
      ),
      GoRoute(
        path: '/autonomous/journey-start',
        name: 'autonomous-journey-start',
        builder: (context, state) => const AutonomousJourneyStartPage(),
      ),
      GoRoute(
        path: '/autonomous/first-access',
        name: 'autonomous-first-access',
        builder: (context, state) => const AutonomousFirstAccessPage(),
      ),
      GoRoute(
        path: '/nearby-stations',
        name: 'nearby-stations',
        builder: (context, state) => const NearbyStationsPage(),
      ),
    ],
    errorBuilder: (context, state) {
      debugPrint('❌ [Router] Erro de rota: ${state.error}');
      debugPrint('❌ [Router] Rota: ${state.uri}');
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
              const SizedBox(height: 8),
              Text(
                'Erro: ${state.error}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
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
  
  GoRouter get router => _router;
}
