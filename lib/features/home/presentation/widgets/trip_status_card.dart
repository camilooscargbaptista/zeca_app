import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeca_app/features/trip/domain/entities/trip.dart';
import 'package:zeca_app/features/trip/presentation/pages/trip_start_page.dart';
import 'package:zeca_app/features/trip/presentation/pages/trip_active_page.dart';
import '../bloc/trip_home_bloc.dart';

/// Card na Home que mostra status da viagem
/// 
/// Mockup: MOCK-trip-flow-screens.html
/// 
/// Estado "sem viagem": Card azul com ícone caminhão e "Iniciar Viagem"
/// Estado "viagem ativa": Card azul com "São Paulo → Rio de Janeiro" + tempo + km
class TripStatusCard extends StatefulWidget {
  final String vehicleId;
  final String vehiclePlate;
  final String? vehicleModel;

  const TripStatusCard({
    super.key,
    required this.vehicleId,
    required this.vehiclePlate,
    this.vehicleModel,
  });

  @override
  State<TripStatusCard> createState() => _TripStatusCardState();
}

class _TripStatusCardState extends State<TripStatusCard> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Trip? _currentTrip;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(Trip trip) {
    _timer?.cancel();
    _currentTrip = trip;
    
    if (trip.startedAt != null) {
      _elapsed = DateTime.now().difference(trip.startedAt!);
    }
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsed = _elapsed + const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripHomeBloc, TripHomeState>(
      listener: (context, state) {
        state.whenOrNull(
          active: (trip) {
            if (_currentTrip?.id != trip.id) {
              _startTimer(trip);
            }
          },
          noActiveTrip: () {
            _timer?.cancel();
            _currentTrip = null;
            _elapsed = Duration.zero;
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => _buildLoadingCard(),
          noActiveTrip: () => _buildStartTripCard(context),
          active: (trip) => _buildActiveTripCard(context, trip),
          error: (message) => _buildErrorCard(context, message),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B9BD5), Color(0xFF2A70C0)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildStartTripCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToStartTrip(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícone caminhão - NÃO EMOJI
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_shipping,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Iniciar Viagem',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  /// Card de viagem ativa mostrando: Origem → Destino + tempo + km
  /// Ou "Rota Livre" se não tiver origem e destino definidos
  Widget _buildActiveTripCard(BuildContext context, Trip trip) {
    // Iniciar timer se necessário
    if (_currentTrip?.id != trip.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer(trip);
      });
    }
    
    // Formatar rota - "Rota Livre" se não tiver origem e destino
    final hasOrigin = trip.origin != null && trip.origin!.isNotEmpty;
    final hasDestination = trip.destination != null && trip.destination!.isNotEmpty;
    
    String routeText;
    if (hasOrigin && hasDestination) {
      routeText = '${trip.origin} → ${trip.destination}';
    } else if (hasOrigin) {
      routeText = '${trip.origin} → ...';
    } else if (hasDestination) {
      routeText = '... → ${trip.destination}';
    } else {
      routeText = 'Rota Livre';
    }
    
    // Formatar info linha 2
    final distanceText = trip.totalDistanceKm != null 
        ? '${trip.totalDistanceKm!.toStringAsFixed(0)} km'
        : '--';
    final infoText = '${_formatDuration(_elapsed)} • $distanceText';
    
    return GestureDetector(
      onTap: () => _navigateToActiveTrip(context, trip),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5B9BD5), Color(0xFF2A70C0)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ponto verde de ativo
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linha 1: Origem → Destino
                  Text(
                    routeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Linha 2: tempo • km
                  Text(
                    infoText,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return GestureDetector(
      onTap: () => context.read<TripHomeBloc>().add(const LoadActiveTrip()),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 13,
                ),
              ),
            ),
            Icon(Icons.refresh, color: Colors.red.shade600, size: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToStartTrip(BuildContext context) async {
    final bloc = context.read<TripHomeBloc>();
    
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: TripStartPage(
            vehicleId: widget.vehicleId,
            vehiclePlate: widget.vehiclePlate,
            vehicleModel: widget.vehicleModel,
          ),
        ),
      ),
    );
    
    if (result == true) {
      bloc.add(const LoadActiveTrip());
    }
  }

  void _navigateToActiveTrip(BuildContext context, Trip trip) async {
    final bloc = context.read<TripHomeBloc>();
    
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: TripActivePage(
            trip: trip,
            vehiclePlate: widget.vehiclePlate,
          ),
        ),
      ),
    );
    
    if (result == true) {
      bloc.add(const LoadActiveTrip());
    }
  }
}
