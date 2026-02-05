import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeca_app/core/theme/app_colors.dart';
import 'package:zeca_app/core/services/location_service.dart';
import 'package:zeca_app/core/services/directions_service.dart';
import 'package:zeca_app/core/services/places_service.dart';
import 'package:zeca_app/shared/widgets/places_autocomplete_field.dart';
import 'package:zeca_app/features/home/presentation/bloc/trip_home_bloc.dart';

/// Tela full-screen para iniciar nova viagem
/// Segue mockup MOCK-trip-flow-screens.html exatamente
/// 
/// Features:
/// - Card do veículo (Placa + Modelo)
/// - Campos Origem e Destino com autocomplete
/// - Card azul de preview de rota quando ambos são preenchidos
/// - Botão "Abrir no Google Maps" no preview
class TripStartPage extends StatefulWidget {
  final String vehicleId;
  final String vehiclePlate;
  final String? vehicleModel;

  const TripStartPage({
    super.key,
    required this.vehicleId,
    required this.vehiclePlate,
    this.vehicleModel,
  });

  @override
  State<TripStartPage> createState() => _TripStartPageState();
}

class _TripStartPageState extends State<TripStartPage> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  
  final LocationService _locationService = LocationService();
  final DirectionsService _directionsService = DirectionsService();
  final PlacesService _placesService = PlacesService();
  
  bool _isInitialized = false;
  bool _isStarting = false;
  bool _hasGpsPermission = false;
  bool _isOnline = true;
  
  // Preview de rota
  bool _isLoadingRoute = false;
  RouteResult? _routeResult;
  String? _originText;
  String? _destinationText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
    
    // Listeners para calcular rota automaticamente
    _originController.addListener(_onAddressChanged);
    _destinationController.addListener(_onAddressChanged);
  }

  @override
  void dispose() {
    _originController.removeListener(_onAddressChanged);
    _destinationController.removeListener(_onAddressChanged);
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final hasPermission = await _locationService.checkPermission();
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = connectivityResult != ConnectivityResult.none;
    
    if (mounted) {
      setState(() {
        _hasGpsPermission = hasPermission;
        _isOnline = isOnline;
        _isInitialized = true;
      });
    }
  }

  void _onAddressChanged() {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();
    
    // Sempre atualizar o estado para mostrar/esconder botão Traçar Rota
    // Limpar preview se origem ou destino mudou
    if (origin != _originText || destination != _destinationText) {
      setState(() {
        _routeResult = null;
      });
    } else {
      // Forçar reconstrução para atualizar visibilidade do botão
      setState(() {});
    }
  }

  Future<void> _calculateRoute() async {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();
    
    if (origin.isEmpty || destination.isEmpty) return;
    if (origin == _originText && destination == _destinationText && _routeResult != null) return;
    
    setState(() {
      _isLoadingRoute = true;
    });
    
    try {
      // Obter coordenadas dos lugares
      final originPlaces = await _placesService.searchPlaces(origin);
      final destPlaces = await _placesService.searchPlaces(destination);
      
      if (originPlaces.isEmpty || destPlaces.isEmpty) {
        setState(() {
          _isLoadingRoute = false;
        });
        return;
      }
      
      final originDetails = await _placesService.getPlaceDetails(originPlaces.first.placeId);
      final destDetails = await _placesService.getPlaceDetails(destPlaces.first.placeId);
      
      if (originDetails == null || destDetails == null ||
          originDetails.latitude == null || originDetails.longitude == null ||
          destDetails.latitude == null || destDetails.longitude == null) {
        setState(() {
          _isLoadingRoute = false;
        });
        return;
      }
      
      // Calcular rota
      final route = await _directionsService.calculateRoute(
        originLat: originDetails.latitude!,
        originLng: originDetails.longitude!,
        destLat: destDetails.latitude!,
        destLng: destDetails.longitude!,
      );
      
      if (mounted) {
        setState(() {
          _routeResult = route;
          _originText = origin;
          _destinationText = destination;
          _isLoadingRoute = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao calcular rota: $e');
      if (mounted) {
        setState(() {
          _isLoadingRoute = false;
        });
      }
    }
  }

  Future<void> _requestGpsPermission() async {
    final granted = await _locationService.requestPermission();
    if (mounted) {
      setState(() {
        _hasGpsPermission = granted;
      });
    }
    
    if (!granted) {
      _showOpenSettingsDialog();
    }
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão de Localização'),
        content: const Text(
          'Para iniciar viagens, o ZECA precisa de acesso à sua localização. '
          'Por favor, habilite nas configurações do dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _locationService.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartTrip() async {
    if (!_hasGpsPermission) {
      await _requestGpsPermission();
      if (!_hasGpsPermission) return;
    }
    
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = connectivityResult != ConnectivityResult.none;
    
    if (!isOnline) {
      _showNoConnectionDialog();
      return;
    }
    
    if (_isStarting) return;
    
    setState(() {
      _isStarting = true;
    });
    
    context.read<TripHomeBloc>().add(StartTripRequested(
      vehicleId: widget.vehicleId,
      origin: _originController.text.trim().isNotEmpty 
          ? _originController.text.trim() 
          : null,
      destination: _destinationController.text.trim().isNotEmpty 
          ? _destinationController.text.trim() 
          : null,
    ));
    
    Navigator.of(context).pop(true);
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sem Conexão'),
        content: const Text(
          'Você precisa de conexão com a internet para iniciar uma viagem. '
          'Por favor, verifique sua conexão e tente novamente.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps() async {
    if (_originText == null || _destinationText == null) return;
    
    final origin = Uri.encodeComponent(_originText!);
    final destination = Uri.encodeComponent(_destinationText!);
    
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving');
    
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Erro ao abrir Google Maps: $e');
    }
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
          'Iniciar Viagem',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Card do veículo
                        _buildVehicleCard(),
                        const SizedBox(height: 24),
                        
                        // Avisos
                        if (!_hasGpsPermission) ...[
                          _buildGpsWarning(),
                          const SizedBox(height: 16),
                        ],
                        if (!_isOnline) ...[
                          _buildOfflineWarning(),
                          const SizedBox(height: 16),
                        ],
                        
                        // Label Origem
                        const Text(
                          'ORIGEM',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildOriginField(),
                        const SizedBox(height: 20),
                        
                        // Label Destino
                        const Text(
                          'DESTINO',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDestinationField(),
                        
                        const SizedBox(height: 16),
                        
                        // Botão Traçar Rota (aparece quando tem origem e destino)
                        if (_originController.text.trim().isNotEmpty && 
                            _destinationController.text.trim().isNotEmpty &&
                            _routeResult == null &&
                            !_isLoadingRoute)
                          _buildTraceRouteButton(),
                        
                        // Indicador de carregamento da rota
                        if (_isLoadingRoute)
                          _buildLoadingRoute(),
                        
                        // Preview de rota (card azul)
                        if (_routeResult != null) ...[
                          const SizedBox(height: 16),
                          _buildRoutePreviewCard(),
                        ],
                        
                        const SizedBox(height: 8),
                        _buildRouteFreeHint(),
                      ],
                    ),
                  ),
                  
                  // Botões fixos no bottom
                  _buildBottomButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_shipping,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehiclePlate,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.vehicleModel ?? 'Veículo',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGpsWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GPS Desativado', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Ative a localização', style: TextStyle(color: AppColors.error.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: _requestGpsPermission, child: const Text('Ativar')),
        ],
      ),
    );
  }

  Widget _buildOfflineWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.warning, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sem Conexão', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Conecte-se à internet', style: TextStyle(color: AppColors.warning.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success, width: 2),
      ),
      child: PlacesAutocompleteField(
        controller: _originController,
        hintText: 'Ex: São Paulo, SP',
        prefixIcon: Icons.trip_origin,
      ),
    );
  }

  Widget _buildDestinationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error, width: 2),
      ),
      child: PlacesAutocompleteField(
        controller: _destinationController,
        hintText: 'Ex: Rio de Janeiro, RJ',
        prefixIcon: Icons.place,
      ),
    );
  }

  Widget _buildTraceRouteButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton.icon(
        onPressed: _calculateRoute,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.route),
        label: const Text('Traçar Rota', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildLoadingRoute() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue)),
            SizedBox(width: 12),
            Text('Calculando rota...', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  /// Card azul de preview de rota - conforme mockup
  Widget _buildRoutePreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com ícone e nome da via
          Row(
            children: [
              Icon(Icons.navigation, color: AppColors.primaryBlue, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _routeResult?.summary != null && _routeResult!.summary!.isNotEmpty
                      ? '${_routeResult!.summary} (mais rápido)'
                      : 'Via mais rápida',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Distância e Tempo
          Row(
            children: [
              // Distância
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_routeResult?.distanceKm.toStringAsFixed(0) ?? '--'} km',
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Distância',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Tempo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDuration(_routeResult?.durationMinutes ?? 0),
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Tempo estimado',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}min';
  }

  Widget _buildRouteFreeHint() {
    return Row(
      children: [
        Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 16),
        const SizedBox(width: 8),
        Text(
          'Deixe em branco para "Rota Livre"',
          style: TextStyle(color: AppColors.primaryBlue, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    final canStart = _hasGpsPermission && _isOnline && !_isStarting;
    
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botão Iniciar Viagem (azul)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canStart ? _handleStartTrip : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canStart ? AppColors.primaryBlue : AppColors.grey400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isStarting)
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    else
                      const Icon(Icons.play_arrow, size: 20),
                    const SizedBox(width: 8),
                    Text(_isStarting ? 'Iniciando...' : 'Iniciar Viagem', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            
            // Botão Abrir no Google Maps (verde) - só aparece se tiver rota
            if (_routeResult != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openGoogleMaps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.navigation, size: 20),
                  label: const Text('Abrir no Google Maps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
