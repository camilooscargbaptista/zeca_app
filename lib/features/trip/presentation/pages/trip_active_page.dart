import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeca_app/core/theme/app_colors.dart';
import 'package:zeca_app/features/trip/domain/entities/trip.dart';
import 'package:zeca_app/features/home/presentation/bloc/trip_home_bloc.dart';

/// Tela full-screen para viagem em andamento
/// Segue mockup MOCK-trip-flow-screens.html (Tela 4. TELA DETALHES)
/// 
/// Layout:
/// - Timer grande no topo (00:04:18)
/// - Tabela de informações (Origem, Destino, Distância, etc)
/// - GPS Ativo indicator
/// - Botões Google Maps e Waze lado a lado
/// - Botão Finalizar Viagem
class TripActivePage extends StatefulWidget {
  final Trip trip;
  final String? vehiclePlate;

  const TripActivePage({
    super.key,
    required this.trip,
    this.vehiclePlate,
  });

  @override
  State<TripActivePage> createState() => _TripActivePageState();
}

class _TripActivePageState extends State<TripActivePage> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initTimer() {
    if (widget.trip.startedAt != null) {
      _elapsed = DateTime.now().difference(widget.trip.startedAt!);
    }
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsed = _elapsed + const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _handleFinishTrip() async {
    if (_isFinishing) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Viagem'),
        content: const Text(
          'Tem certeza que deseja finalizar esta viagem? '
          'Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    setState(() {
      _isFinishing = true;
    });
    
    context.read<TripHomeBloc>().add(FinishTripRequested(
      tripId: widget.trip.id,
    ));
    
    Navigator.of(context).pop(true);
  }

  Future<void> _launchGoogleMaps() async {
    if (widget.trip.destination == null || widget.trip.destination!.isEmpty) {
      return;
    }
    
    final destination = Uri.encodeComponent(widget.trip.destination!);
    final googleUrl = Uri.parse('google.navigation:q=$destination');
    final webUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$destination');
    
    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Erro ao abrir Google Maps: $e');
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchWaze() async {
    if (widget.trip.destination == null || widget.trip.destination!.isEmpty) {
      return;
    }
    
    final destination = Uri.encodeComponent(widget.trip.destination!);
    final wazeUrl = Uri.parse('waze://?q=$destination&navigate=yes');
    final webUrl = Uri.parse('https://waze.com/ul?q=$destination&navigate=yes');
    
    try {
      if (await canLaunchUrl(wazeUrl)) {
        await launchUrl(wazeUrl);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Erro ao abrir Waze: $e');
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: const Text(
          'Viagem em Andamento',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Timer grande no topo
                  _buildTimerSection(),
                  const SizedBox(height: 24),
                  
                  // Tabela de informações
                  _buildInfoTable(),
                  const SizedBox(height: 24),
                  
                  // GPS Ativo indicator
                  _buildGpsIndicator(),
                  const SizedBox(height: 24),
                  
                  // Botões de navegação
                  if (widget.trip.destination != null && widget.trip.destination!.isNotEmpty)
                    _buildNavigationButtons(),
                ],
              ),
            ),
            
            // Botão Finalizar fixo no bottom
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          // Timer grande
          Text(
            _formatDuration(_elapsed),
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tempo decorrido',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          _buildInfoRow('Origem', widget.trip.origin ?? 'Não definida'),
          _buildDivider(),
          _buildInfoRow('Destino', widget.trip.destination ?? 'Não definido'),
          _buildDivider(),
          _buildInfoRow('Distância', widget.trip.totalDistanceKm != null 
              ? '${widget.trip.totalDistanceKm!.toStringAsFixed(0)} km' 
              : '--'),
          _buildDivider(),
          _buildInfoRow('Veículo', widget.vehiclePlate ?? '--'),
          _buildDivider(),
          _buildInfoRow('Início', _formatTime(widget.trip.startedAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.grey200);
  }

  String _formatEstimatedTime(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}min';
  }

  Widget _buildGpsIndicator() {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'GPS Ativo',
          style: TextStyle(
            color: AppColors.success,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Rastreando posição...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        // Google Maps - Verde
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _launchGoogleMaps,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.navigation, size: 20),
            label: const Text(
              'Google Maps',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Waze - Ciano
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _launchWaze,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF33CCFF), // Cyan do Waze
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.timer_outlined, size: 20),
            label: const Text(
              'Waze',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinishButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFinishing ? null : _handleFinishTrip,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isFinishing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.flag, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isFinishing ? 'Finalizando...' : 'Finalizar Viagem',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
