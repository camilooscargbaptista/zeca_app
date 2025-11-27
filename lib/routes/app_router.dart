import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page_simple.dart';
import '../features/home/presentation/pages/home_page_simple.dart';
import '../features/refueling/presentation/pages/refueling_code_page_simple.dart';
import '../features/refueling/presentation/pages/refueling_waiting_page.dart';
import '../features/refueling/presentation/pages/pending_refuelings_page.dart';
import '../features/journey/presentation/pages/journey_page.dart';
import '../test_google_maps_page.dart';
import '../features/journey/presentation/bloc/journey_bloc.dart';
import '../features/journey/presentation/bloc/journey_event.dart';
import '../features/journey_start/presentation/pages/journey_start_page.dart';
import '../features/journey_start/presentation/pages/journey_dashboard_page.dart';
import '../features/checklist/presentation/pages/checklist_page.dart';
import '../features/journey/presentation/pages/journey_segments_page.dart';
import '../core/services/api_service.dart';
import '../core/services/location_service.dart';
import '../features/journey/data/services/journey_storage_service.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    // 🧪 DEBUG: Rota inicial temporária para teste do Google Maps
    initialLocation: '/test-maps', // VOLTAR para '/splash' após debug!
    routes: [
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
      // 🧪 Rota de TESTE para debug do Google Maps
      GoRoute(
        path: '/test-maps',
        name: 'test-maps',
        builder: (context, state) => const TestGoogleMapsPage(),
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
    ],
    errorBuilder: (context, state) => Scaffold(
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
    ),
  );
  
  GoRouter get router => _router;
}
