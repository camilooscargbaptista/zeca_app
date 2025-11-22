import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/odometer_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../bloc/journey_bloc.dart';
import '../bloc/journey_event.dart';
import '../bloc/journey_state.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/places_service.dart';
import '../../../../core/services/directions_service.dart';
import '../../data/services/journey_storage_service.dart';
import '../../domain/entities/journey_entity.dart';
import '../../../odometer/presentation/pages/odometer_camera_page.dart';
import '../../../../shared/widgets/places_autocomplete_field.dart';
import '../../../../shared/widgets/route_map_view.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({Key? key}) : super(key: key);

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  final _odometroController = TextEditingController();
  final _destinoController = TextEditingController();
  final _previsaoKmController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Formatter para odômetro (formato brasileiro: 123.456 - apenas inteiros)
  final _odometroFormatter = OdometerFormatter();

  // Dados do veículo e usuário (carregados do storage)
  String? _placa;
  String? _nomeMotorista;
  String? _nomeTransportadora;

  // Serviços para Places e Directions
  final _placesService = PlacesService();
  final _directionsService = DirectionsService();
  final _locationService = LocationService();
  
  // Estado para cálculo de rota
  bool _isCalculatingRoute = false;
  
  // Dados da rota calculada (para exibir no mapa)
  double? _routeOriginLat;
  double? _routeOriginLng;
  double? _routeDestLat;
  double? _routeDestLng;
  String? _routePolyline;
  String? _routeDestinationName;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
    // Carregar jornada ativa ao iniciar
    context.read<JourneyBloc>().add(const LoadActiveJourney());
  }

  Future<void> _loadVehicleData() async {
    final storageService = getIt<StorageService>();
    final vehicleData = await storageService.getJourneyVehicleData();
    final userData = storageService.getUserData();
    
    setState(() {
      _placa = vehicleData?['placa'] ?? '';
      _nomeMotorista = userData?['motorista']?['nome'] ?? userData?['nome'] ?? '';
      _nomeTransportadora = userData?['transportadora']?['nome'] ?? '';
    });
  }

  /// Abre a tela de câmera para capturar odômetro
  Future<void> _openOdometerCamera() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const OdometerCameraPage(),
      ),
    );

    if (result != null && mounted) {
      // Preencher campo com valor extraído
      setState(() {
        _odometroController.text = result;
      });
    }
  }

  /// Chamado quando um lugar é selecionado no autocomplete
  /// Calcula automaticamente a rota e preenche o campo de KM
  Future<void> _onPlaceSelected(Place place) async {
    if (place.latitude == null || place.longitude == null) {
      debugPrint('⚠️ [Journey] Lugar selecionado sem coordenadas');
      return;
    }

    setState(() {
      _isCalculatingRoute = true;
    });

    try {
      // Obter localização atual do GPS
      final currentLocation = await _locationService.getCurrentPosition();
      
      if (currentLocation == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível obter sua localização atual. Verifique as permissões de GPS.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() {
          _isCalculatingRoute = false;
        });
        return;
      }

      // Detectar tipo de veículo baseado no modelo (se disponível)
      // Por padrão, assume 'car'. Se o modelo contém palavras-chave de caminhão, usa 'truck'
      String vehicleType = 'car'; // Padrão: carro
      if (_placa != null) {
        final storageService = getIt<StorageService>();
        final vehicleData = await storageService.getJourneyVehicleData();
        final model = vehicleData?['modelo']?.toString().toLowerCase() ?? '';
        final brand = vehicleData?['marca']?.toString().toLowerCase() ?? '';
        final combined = '$model $brand';
        
        // Palavras-chave que indicam caminhão
        if (combined.contains('caminhão') || 
            combined.contains('caminhao') ||
            combined.contains('truck') ||
            combined.contains('onibus') ||
            combined.contains('ônibus') ||
            combined.contains('van') ||
            model.contains('350') || // Modelos comuns de caminhão
            model.contains('450') ||
            model.contains('550')) {
          vehicleType = 'truck';
        }
      }

      // Calcular rota
      final routeResult = await _directionsService.calculateRoute(
        originLat: currentLocation.latitude,
        originLng: currentLocation.longitude,
        destLat: place.latitude!,
        destLng: place.longitude!,
        vehicleType: vehicleType,
      );

      if (mounted) {
        setState(() {
          _isCalculatingRoute = false;
        });

        if (routeResult != null) {
          // Preencher campo de previsão de KM automaticamente
          _previsaoKmController.text = routeResult.distanceKm.round().toString();
          
          // Salvar dados da rota para exibir no mapa
          setState(() {
            _routeOriginLat = currentLocation.latitude;
            _routeOriginLng = currentLocation.longitude;
            _routeDestLat = place.latitude;
            _routeDestLng = place.longitude;
            _routePolyline = routeResult.polyline;
            _routeDestinationName = place.description;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Rota calculada: ${routeResult.distanceKm.toStringAsFixed(1)} km (${routeResult.formattedDuration})',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não foi possível calcular a rota. Você pode digitar o KM manualmente.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [Journey] Erro ao calcular rota: $e');
      if (mounted) {
        setState(() {
          _isCalculatingRoute = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao calcular rota: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _odometroController.dispose();
    _destinoController.dispose();
    _previsaoKmController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  String _formatarTempo(int segundos) {
    final horas = segundos ~/ 3600;
    final minutos = (segundos % 3600) ~/ 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
  }

  /// Converte DateTime para horário do Brasil (GMT-3)
  /// Sempre converte para GMT-3, independente da configuração do dispositivo
  DateTime _toBrazilTime(DateTime dateTime) {
    // Sempre trabalhar com UTC como referência
    final utcTime = dateTime.isUtc ? dateTime : dateTime.toUtc();
    // Subtrair 3 horas do UTC para obter GMT-3 (horário do Brasil)
    return utcTime.subtract(const Duration(hours: 3));
  }

  String _formatBrazilTime(DateTime dateTime) {
    final brazilTime = _toBrazilTime(dateTime);
    return '${brazilTime.hour.toString().padLeft(2, '0')}:${brazilTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatBrazilDate(DateTime dateTime) {
    final brazilTime = _toBrazilTime(dateTime);
    return '${brazilTime.day}/${brazilTime.month}/${brazilTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zecaBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
            context.go('/journey-dashboard');
            },
          tooltip: 'Voltar',
        ),
        title: const Text(
          'Viagem',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<JourneyBloc, JourneyState>(
        listener: (context, state) {
          if (state is JourneyError) {
            ErrorDialog.show(
              context,
              title: 'Erro',
              message: state.message,
            );
          } else if (state is JourneyFinished) {
            _showFinishDialog(state.journey);
          }
        },
        builder: (context, state) {
          if (state is JourneyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JourneyLoaded) {
            return _buildActiveJourneyView(state);
          }

          if (state is JourneyFinished) {
            return _buildFinishedJourneyView(state.journey);
          }

          return _buildStartJourneyView();
        },
      ),
    );
  }

  Widget _buildStartJourneyView() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping,
                            size: 32,
                            color: AppColors.zecaBlue,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Iniciar Viagem',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatBrazilDate(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Card Informativo (Placa, Motorista, Transportadora)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.zecaBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.zecaBlue.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Placa
                            Row(
                              children: [
                                const Icon(Icons.directions_car, size: 20, color: AppColors.zecaBlue),
                                const SizedBox(width: 8),
                                Text(
                                  'Veículo: ${_placa ?? 'Carregando...'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (_nomeMotorista != null && _nomeMotorista!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Motorista: $_nomeMotorista',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_nomeTransportadora != null && _nomeTransportadora!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.business, size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Transportadora: $_nomeTransportadora',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo Odômetro (OBRIGATÓRIO)
                      TextFormField(
                        controller: _odometroController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [_odometroFormatter],
                        decoration: InputDecoration(
                          labelText: 'Odômetro Inicial (km) *',
                          hintText: '0',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.speed, color: AppColors.zecaBlue),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.camera_alt, color: AppColors.zecaBlue),
                            onPressed: _openOdometerCamera,
                            tooltip: 'Capturar odômetro com câmera',
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.trim().isEmpty) {
                            return 'Digite o odômetro inicial';
                          }
                          final odometro = OdometerFormatter.parseFormattedValue(value);
                          if (odometro <= 0) {
                            return 'Odômetro deve ser maior que zero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Destino (OPCIONAL) com Autocomplete
                      Stack(
                        children: [
                          PlacesAutocompleteField(
                            controller: _destinoController,
                            labelText: 'Destino (opcional)',
                            hintText: 'Ex: São Paulo - SP',
                            prefixIcon: Icons.location_on,
                            onPlaceSelected: _onPlaceSelected,
                            decoration: InputDecoration(
                              labelText: 'Destino (opcional)',
                              hintText: 'Ex: São Paulo - SP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                            ),
                          ),
                          if (_isCalculatingRoute)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Campo Previsão de KM (OPCIONAL) - Preenchido automaticamente
                      TextFormField(
                        controller: _previsaoKmController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        readOnly: _isCalculatingRoute,
                        decoration: InputDecoration(
                          labelText: 'Previsão de KM (opcional)',
                          hintText: _isCalculatingRoute ? 'Calculando rota...' : 'Ex: 500',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.route, color: Colors.grey),
                          suffixText: 'km',
                          suffixIcon: _isCalculatingRoute
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Observações (OPCIONAL)
                      TextFormField(
                        controller: _observacoesController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Observações (opcional)',
                          hintText: 'Notas sobre a viagem...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.notes, color: Colors.grey),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botão Iniciar
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (_placa == null || _placa!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erro ao carregar dados do veículo'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            final odometro = OdometerFormatter.parseFormattedValue(
                              _odometroController.text,
                            );
                            
                            // Obter valores dos campos opcionais
                            final destino = _destinoController.text.trim();
                            final previsaoKmText = _previsaoKmController.text.trim();
                            final previsaoKm = previsaoKmText.isNotEmpty 
                                ? int.tryParse(previsaoKmText) 
                                : null;
                            final observacoes = _observacoesController.text.trim();
                            
                            context.read<JourneyBloc>().add(
                                  StartJourney(
                                    placa: _placa!,
                                    odometroInicial: odometro,
                                    destino: destino.isNotEmpty ? destino : null,
                                    previsaoKm: previsaoKm,
                                    observacoes: observacoes.isNotEmpty ? observacoes : null,
                                  ),
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.zecaBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Iniciar Viagem',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveJourneyView(JourneyLoaded state) {
    final journey = state.journey;
    final tempoFormatado = _formatarTempo(state.tempoDecorridoSegundos);
    final kmFormatado = state.kmPercorridos.toStringAsFixed(1);
    final odometroFinal = journey.odometroInicial + state.kmPercorridos.round();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // Mapa ocupando toda a tela
            if (_routeOriginLat != null && _routeDestLat != null)
              RouteMapView(
                originLat: _routeOriginLat!,
                originLng: _routeOriginLng!,
                destLat: _routeDestLat!,
                destLng: _routeDestLng!,
                polyline: _routePolyline,
                destinationName: _routeDestinationName,
              )
            else
              // Se não houver rota, mostrar mapa com localização atual
              FutureBuilder(
                future: _locationService.getCurrentPosition(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final position = snapshot.data!;
                    return RouteMapView(
                      originLat: position.latitude,
                      originLng: position.longitude,
                      destLat: position.latitude,
                      destLng: position.longitude,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),

            // Header compacto no topo
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.zecaBlue.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, size: 24, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            journey.placa,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            tempoFormatado,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indicador de descanso (se aplicável)
                    if (state.emDescanso)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.coffee, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Descanso',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Cards flutuantes com informações (canto superior direito)
            Positioned(
              top: 60,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Card de KM percorridos
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'KM',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          kmFormatado,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Card de odômetro inicial
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Odômetro',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          OdometerFormatter.formatValue(journey.odometroInicial),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zecaBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Botões de controle no canto inferior direito (menores)
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Botão Finalizar (vermelho)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showFinishConfirmation(),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.stop, color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                              const Text(
                                'Finalizar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Botão Descanso/Retomar
                  Container(
                    decoration: BoxDecoration(
                      color: state.emDescanso ? AppColors.zecaBlue : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.read<JourneyBloc>().add(
                                ToggleRest(isStartingRest: !state.emDescanso),
                              );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.emDescanso ? Icons.play_arrow : Icons.pause,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                state.emDescanso ? 'Retomar' : 'Descanso',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedJourneyView(JourneyEntity journey) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.zecaBlue,
            AppColors.zecaBlue.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jornada Finalizada!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    const SizedBox(height: 8),
                  const Text(
                    'Resumo da Jornada',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Distância percorrida
                  _buildInfoRow(
                    icon: Icons.route,
                    label: 'Distância Percorrida',
                    value: '${journey.kmPercorridos.toStringAsFixed(1)} km',
                  ),
                  const Divider(height: 24),
                  
                  // Tempo de percurso
                  _buildInfoRow(
                    icon: Icons.timer,
                    label: 'Tempo de Percurso',
                    value: journey.formattedTempoDirecao,
                  ),
                  const Divider(height: 24),
                  
                  // Tempo de descanso
                  _buildInfoRow(
                    icon: Icons.hotel,
                    label: 'Tempo de Descanso',
                    value: journey.formattedTempoDescanso,
                  ),
                  
                  // Velocidades (somente se disponíveis)
                  if (journey.velocidadeMedia != null || journey.velocidadeMaxima != null) ...[
                    const Divider(height: 24),
                    const Text(
                      'Velocidades',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.zecaBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (journey.velocidadeMedia != null)
                    _buildInfoRow(
                      icon: Icons.speed,
                      label: 'Velocidade Média',
                      value: '${journey.velocidadeMedia!.toStringAsFixed(1)} km/h',
                      isCompact: true,
                    ),
                  
                  if (journey.velocidadeMaxima != null) ...[
                    if (journey.velocidadeMedia != null) const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.speed,
                      label: 'Velocidade Máxima',
                      value: '${journey.velocidadeMaxima!.toStringAsFixed(1)} km/h',
                      isCompact: true,
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.read<JourneyBloc>().add(const LoadActiveJourney());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.zecaBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      'Voltar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFinishConfirmation() {
    // Obter o bloc e o estado antes de abrir o diálogo para garantir acesso
    final journeyBloc = context.read<JourneyBloc>();
    final currentState = journeyBloc.state;
    
    if (currentState is! JourneyLoaded) {
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'Não é possível finalizar a jornada no estado atual',
      );
      return;
    }
    
    // Calcular odômetro final
    final journey = currentState.journey;
    final odometroFinal = journey.odometroInicial + currentState.kmPercorridos.round();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finalizar Jornada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deseja finalizar a jornada do dia?'),
            const SizedBox(height: 8),
            Text('Odômetro Final: ${OdometerFormatter.formatValue(odometroFinal)} km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              journeyBloc.add(FinishJourney(odometroFinal: odometroFinal));
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }


  void _showFinishDialog(JourneyEntity journey) {
    // Obter o bloc antes de abrir o diálogo para garantir acesso
    final journeyBloc = context.read<JourneyBloc>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Jornada Finalizada'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Text(
                'Resumo da Jornada',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zecaBlue,
                ),
              ),
              const SizedBox(height: 16),
              
              // Distância percorrida
              _buildInfoRow(
                icon: Icons.route,
                label: 'Distância Percorrida',
                value: '${journey.kmPercorridos.toStringAsFixed(1)} km',
              ),
              const Divider(height: 24),
              
              // Tempo de percurso
              _buildInfoRow(
                icon: Icons.timer,
                label: 'Tempo de Percurso',
                value: journey.formattedTempoDirecao,
              ),
              const Divider(height: 24),
              
              // Tempo de descanso
              _buildInfoRow(
                icon: Icons.hotel,
                label: 'Tempo de Descanso',
                value: journey.formattedTempoDescanso,
              ),
              
              // Velocidades (somente se disponíveis)
              if (journey.velocidadeMedia != null || journey.velocidadeMaxima != null) ...[
                const Divider(height: 24),
                const Text(
                  'Velocidades',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.zecaBlue,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
            if (journey.velocidadeMedia != null)
                _buildInfoRow(
                  icon: Icons.speed,
                  label: 'Velocidade Média',
                  value: '${journey.velocidadeMedia!.toStringAsFixed(1)} km/h',
                  isCompact: true,
                ),
              
              if (journey.velocidadeMaxima != null) ...[
                if (journey.velocidadeMedia != null) const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.speed,
                  label: 'Velocidade Máxima',
                  value: '${journey.velocidadeMaxima!.toStringAsFixed(1)} km/h',
                  isCompact: true,
                ),
              ],
              
              // NOVO: Seção de trechos (se disponível)
              if (journey.segmentsSummary != null && journey.segmentsSummary!.isNotEmpty) ...[
                const Divider(height: 32),
                _buildSegmentsSummary(journey.segmentsSummary!),
          ],
            ],
          ),
        ),
        actions: [
          // Botão "Ver Detalhes dos Trechos" (se houver trechos)
          if (journey.segmentsSummary != null && journey.segmentsSummary!.isNotEmpty)
          TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.push('/journey-segments/${journey.id}');
              },
              child: const Text('Ver Detalhes'),
            ),
          
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              journeyBloc.add(const LoadActiveJourney());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zecaBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentsSummary(List<dynamic> segments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.timeline, size: 20, color: AppColors.zecaBlue),
            const SizedBox(width: 8),
            const Text(
              'Trechos Percorridos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.zecaBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Lista de trechos (compacta)
        ...segments.map((segment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                // Número do trecho
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.zecaBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '${segment.segmentNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.zecaBlue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Info do trecho
                Expanded(
                  child: Text(
                    '${segment.formattedDistance} | ${segment.formattedDuration}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                
                // Velocidade média
                if (segment.avgSpeedKmh != null)
                  Text(
                    segment.formattedAvgSpeed,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isCompact = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isCompact ? 18 : 24,
          color: AppColors.zecaBlue.withOpacity(0.7),
        ),
        SizedBox(width: isCompact ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isCompact ? 15 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

