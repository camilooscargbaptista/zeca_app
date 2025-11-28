import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/odometer_formatter.dart';
import '../../../../core/di/injection.dart';
import'../../../../core/services/storage_service.dart';
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
import '../../widgets/route_map_view.dart';
import '../../widgets/navigation_info_card.dart';
import '../../widgets/speed_card.dart';
import '../../widgets/route_summary_card.dart';
import '../../widgets/navigation_bottom_sheet.dart';
import '../../widgets/navigation_countdown_dialog.dart';
import '../../widgets/route_overview_card.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/directions_service.dart' as ds;

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
  String? _routeEstimatedTime;
  double? _routeDistanceKm;
  String? _routeOriginName;
  
  // Estado de navegação
  bool _isNavigationMode = false;
  Position? _currentLocation;
  StreamSubscription<Position>? _locationSubscription;
  
  // Animação inicial (5s overview)
  bool _showingInitialOverview = false;
  Timer? _overviewTimer;
  
  // Serviço de geocoding (lazy initialization)
  GeocodingService? _geocodingService;
  GeocodingService get geocodingService {
    _geocodingService ??= getIt<GeocodingService>();
    return _geocodingService!;
  }
  
  // 🆕 NavigationService para navegação turn-by-turn
  NavigationService? _navigationService;
  NavigationService get navigationService {
    _navigationService ??= getIt<NavigationService>();
    return _navigationService!;
  }
  StreamSubscription? _navigationSubscription;
  
  // Dados de navegação (atualizados em tempo real)
  String? _currentStreetName;
  double _currentSpeed = 0; // km/h
  int? _speedLimit; // km/h
  
  // 🆕 Dados do step atual de navegação
  String? _currentNavigationInstruction;
  String? _currentManeuverType;
  double? _distanceToNextMeters;
  
  // 🆕 Controlador do Google Maps (para atualizar câmera diretamente)
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
    // Verificar se há jornada ativa e perguntar ao usuário
    // Usar um delay maior para garantir que tudo está inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkActiveJourney();
        }
      });
    });
  }

  /// Verifica se há jornada ativa e pergunta ao usuário o que fazer
  Future<void> _checkActiveJourney() async {
    if (!mounted) {
      debugPrint('⚠️ [Journey] Widget não está mais montado, cancelando verificação');
      return;
    }

    try {
      final journeyStorageService = JourneyStorageService();
      
      // Tentar inicializar se necessário (pode já estar inicializado)
      try {
        await journeyStorageService.init();
      } catch (e) {
        debugPrint('⚠️ [Journey] Erro ao inicializar storage: $e');
        // Continuar mesmo se houver erro na inicialização
      }
      
      if (!mounted) return;
      
      final activeJourney = journeyStorageService.getActiveJourney();
      
      if (activeJourney != null && activeJourney.isActive) {
        // Carregar dados da rota se existirem
        final routeData = journeyStorageService.getRouteData(activeJourney.id);
        if (routeData != null) {
          setState(() {
            _routeOriginLat = (routeData['origin_lat'] as num?)?.toDouble();
            _routeOriginLng = (routeData['origin_lng'] as num?)?.toDouble();
            _routeDestLat = (routeData['dest_lat'] as num?)?.toDouble();
            _routeDestLng = (routeData['dest_lng'] as num?)?.toDouble();
            _routePolyline = routeData['polyline'] as String?;
            _routeDestinationName = routeData['destination_name'] as String?;
          });
          debugPrint('✅ [Journey] Dados da rota carregados da jornada ativa');
        }
        
        // Há jornada ativa - perguntar ao usuário
        if (!mounted) return;
        
        final shouldContinue = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Viagem Ativa Encontrada'),
            content: Text(
              'Existe uma viagem ativa para o veículo ${activeJourney.placa}.\\n\\n'
              'O que deseja fazer?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Iniciar Nova'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zecaBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continuar Viagem'),
              ),
            ],
          ),
        );

        if (!mounted) return;

        if (shouldContinue == true) {
          // Continuar viagem ativa
          context.read<JourneyBloc>().add(const LoadActiveJourney());
        } else {
          // Limpar jornada ativa - o estado inicial já é JourneyInitial
          try {
            await journeyStorageService.setActiveJourney(null);
            // Limpar dados da rota também
            await journeyStorageService.clearRouteData(activeJourney.id);
            setState(() {
              _routeOriginLat = null;
              _routeOriginLng = null;
              _routeDestLat = null;
              _routeDestLng = null;
              _routePolyline = null;
              _routeDestinationName = null;
            });
          } catch (e) {
            debugPrint('⚠️ [Journey] Erro ao limpar jornada ativa: $e');
          }
          // Não precisa fazer nada, o estado já é JourneyInitial por padrão
        }
      } else {
        // Não há jornada ativa - o estado inicial já é JourneyInitial
        // Não precisa fazer nada
        debugPrint('ℹ️ [Journey] Nenhuma jornada ativa encontrada');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [Journey] Erro ao verificar jornada ativa: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      // Em caso de erro, o estado inicial já é JourneyInitial por padrão
      // Não precisa fazer nada
    }
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

  /// Carrega dados da rota para uma jornada
  Future<void> _loadRouteDataForJourney(JourneyEntity journey) async {
    try {
      final journeyStorageService = JourneyStorageService();
      final routeData = journeyStorageService.getRouteData(journey.id);
      if (routeData != null && mounted) {
        setState(() {
          _routeOriginLat = (routeData['origin_lat'] as num?)?.toDouble();
          _routeOriginLng = (routeData['origin_lng'] as num?)?.toDouble();
          _routeDestLat = (routeData['dest_lat'] as num?)?.toDouble();
          _routeDestLng = (routeData['dest_lng'] as num?)?.toDouble();
          _routePolyline = routeData['polyline'] as String?;
          _routeDestinationName = routeData['destination_name'] as String?;
        });
        debugPrint('✅ [Journey] Dados da rota carregados para jornada: ${journey.id}');
      }
    } catch (e) {
      debugPrint('❌ [Journey] Erro ao carregar dados da rota: $e');
    }
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
      // 🆕 Calcular rota COM steps para navegação turn-by-turn
      final routeResult = await _directionsService.calculateRouteWithSteps(
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
          // 🆕 Carregar steps no NavigationService
          if (routeResult.steps.isNotEmpty) {
            navigationService.setSteps(routeResult.steps);
            debugPrint('✅ [Journey] ${routeResult.steps.length} steps carregados no NavigationService');
            
            // Subscribe ao stream de navegação
            _navigationSubscription?.cancel();
            _navigationSubscription = navigationService.statusStream.listen((status) {
              if (mounted && status.currentStep != null) {
                setState(() {
                  _currentNavigationInstruction = status.currentStep!.instruction;
                  _currentManeuverType = status.currentStep!.maneuver;
                  _distanceToNextMeters = status.distanceToNextMeters;
                });
                debugPrint('🧭 [Navigation] Step ${status.currentStepIndex ?? 0}: ${status.currentStep!.instruction}');
              }
            });
          }
          
          // Preencher campo de previsão de KM automaticamente
          _previsaoKmController.text = routeResult.distanceKm.round().toString();
          
          // Obter nome da origem (rua atual)
          String? originName;
          try {
            originName = await geocodingService.getStreetName(
              LatLng(currentLocation.latitude, currentLocation.longitude),
            );
          } catch (e) {
            debugPrint('⚠️ [Journey] Erro ao obter nome da origem: $e');
          }
          
          // Calcular hora de chegada estimada
          final now = DateTime.now();
          final arrivalTime = now.add(Duration(minutes: routeResult.durationMinutes));
          final arrivalTimeStr = DateFormat('HH:mm').format(arrivalTime);
          
          // Salvar dados da rota para exibir no mapa
          setState(() {
            _routeOriginLat = currentLocation.latitude;
            _routeOriginLng = currentLocation.longitude;
            _routeDestLat = place.latitude;
            _routeDestLng = place.longitude;
            _routePolyline = routeResult.polyline;
            _routeDestinationName = place.description;
            _routeEstimatedTime = routeResult.formattedDuration;
            _routeDistanceKm = routeResult.distanceKm;
            _routeOriginName = originName ?? 'Seu local';
          });
          
          // Salvar dados da rota no storage (se houver jornada ativa)
          final journeyStorageService = JourneyStorageService();
          final activeJourney = journeyStorageService.getActiveJourney();
          if (activeJourney != null) {
            await journeyStorageService.saveRouteData(
              activeJourney.id,
              originLat: currentLocation.latitude,
              originLng: currentLocation.longitude,
              destLat: place.latitude!,
              destLng: place.longitude!,
              polyline: routeResult.polyline,
              destinationName: place.description,
            );
          }
          
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
    _navigationSubscription?.cancel(); // 🆕 Cancelar subscription de navegação
    _overviewTimer?.cancel(); // Cancelar timer da animação
    _previsaoKmController.dispose();
    _observacoesController.dispose();
    _locationSubscription?.cancel();
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
            // Parar navegação quando jornada termina
            _stopNavigation();
          } else if (state is JourneyLoaded) {
            // 🆕 RESTAURAR dados da rota se não existirem (viagem já em andamento)
            if (_routeOriginLat == null || _routeOriginLng == null) {
              debugPrint('🔄 [Journey] Restaurando dados da rota do storage...');
              final journeyStorageService = JourneyStorageService();
              final routeData = journeyStorageService.getRouteData(state.journey.id);
              
              if (routeData != null && mounted) {
                setState(() {
                  _routeOriginLat = routeData['origin_lat'] as double?;
                  _routeOriginLng = routeData['origin_lng'] as double?;
                  _routeDestLat = routeData['dest_lat'] as double?;
                  _routeDestLng = routeData['dest_lng'] as double?;
                  _routePolyline = routeData['polyline'] as String?;
                  _routeDestinationName = routeData['destination_name'] as String?;
                });
                debugPrint('✅ [Journey] Dados da rota restaurados!');
                debugPrint('   - Origin: ($_routeOriginLat, $_routeOriginLng)');
                debugPrint('   - Dest: ($_routeDestLat, $_routeDestLng)');
                
                // Iniciar navegação após restaurar rota
                if (_routeOriginLat != null) {
                  _startNavigation();
                }
              } else {
                debugPrint('⚠️ [Journey] Sem dados de rota salvos');
              }
            }
            
            // Salvar dados da rota quando a jornada é carregada (após iniciar ou continuar)
            if (_routeOriginLat != null && 
                _routeOriginLng != null && 
                _routeDestLat != null && 
                _routeDestLng != null) {
              final journeyStorageService = JourneyStorageService();
              journeyStorageService.saveRouteData(
                state.journey.id,
                originLat: _routeOriginLat!,
                originLng: _routeOriginLng!,
                destLat: _routeDestLat!,
                destLng: _routeDestLng!,
                polyline: _routePolyline,
                destinationName: _routeDestinationName,
              ).then((_) {
                debugPrint('✅ [Journey] Dados da rota salvos após jornada ser iniciada/carregada');
              });
            }
            
            // Iniciar tracking de localização
            _startLocationTracking();
            
            // Se houver rota, iniciar navegação automaticamente
            if (_routeOriginLat != null && 
                _routeOriginLng != null && 
                _routeDestLat != null && 
                _routeDestLng != null) {
              // Iniciar navegação automaticamente quando jornada começa com rota
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_isNavigationMode && !_showingInitialOverview) {
                  // 🆕 Iniciar animação inicial (5s em zoom out)
                  debugPrint('🎬 [Journey] Iniciando animação inicial (5s overview)');
                  setState(() {
                    _showingInitialOverview = true;
                    _isNavigationMode = false; // Zoom out
                  });
                  
                  // Após 5 segundos, entrar em modo navegação
                  _overviewTimer = Timer(const Duration(seconds: 5), () {
                    if (mounted) {
                      debugPrint('✅ [Journey] Animação concluída, entrando em modo navegação');
                      setState(() {
                        _showingInitialOverview = false;
                        _isNavigationMode = true;
                      });
                      _startNavigation();
                    }
                  });
                }
              });
            }
          }
        },
        builder: (context, state) {
          if (state is JourneyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JourneyLoaded) {
            // Carregar dados da rota quando a jornada é carregada
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadRouteDataForJourney(state.journey);
            });
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

                      // Campo Destino (OBRIGATÓRIO) com Autocomplete
                      Stack(
                        children: [
                          PlacesAutocompleteField(
                            controller: _destinoController,
                            labelText: 'Destino *',
                            hintText: 'Ex: São Paulo - SP',
                            prefixIcon: Icons.location_on,
                            onPlaceSelected: _onPlaceSelected,
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
                            // Os dados da rota serão salvos no listener quando JourneyLoaded for emitido
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

    debugPrint('🗺️ [Journey] Construindo view de jornada ativa');
    debugPrint('   - Rota disponível: ${_routeOriginLat != null && _routeOriginLng != null && _routeDestLat != null && _routeDestLng != null}');
    debugPrint('   - Origin: ($_routeOriginLat, $_routeOriginLng)');
    debugPrint('   - Dest: ($_routeDestLat, $_routeDestLng)');

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // Mapa ocupando toda a tela (API Key corrigida - tiles funcionam!)
            if (_routeOriginLat != null && 
                _routeOriginLng != null && 
                _routeDestLat != null && 
                _routeDestLng != null)
              RouteMapView(
                onMapCreated: (controller) {
                  _googleMapController = controller;
                  debugPrint('✅ [Journey] GoogleMapController criado');
                },
                originLat: _routeOriginLat!,
                originLng: _routeOriginLng!,
                destLat: _routeDestLat!,
                destLng: _routeDestLng!,
                polyline: _routePolyline,
                destinationName: _routeDestinationName,
                isNavigationMode: _isNavigationMode,
                currentPosition: _currentLocation != null 
                    ? LatLng(_currentLocation!.latitude, _currentLocation!.longitude)
                    : null,
              )
            else
              // Se não houver rota, mostrar mapa com localização atual
              RouteMapView(
                onMapCreated: (controller) {
                  _googleMapController = controller;
                  debugPrint('✅ [Journey] GoogleMapController criado (sem rota)');
                },
                originLat: _currentLocation?.latitude ?? -21.1704,
                originLng: _currentLocation?.longitude ?? -47.8103,
                destLat: _currentLocation?.latitude ?? -21.1704,
                destLng: _currentLocation?.longitude ?? -47.8103,
                currentPosition: _currentLocation != null
                    ? LatLng(_currentLocation!.latitude, _currentLocation!.longitude)
                    : null,
                isNavigationMode: true,
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

            // 🆕 FAB Visualizar Rota (topo-direito, abaixo do header)
            if (_routeOriginLat != null && 
                _routeOriginLng != null && 
                _routeDestLat != null && 
                _routeDestLng != null &&
                !_showingInitialOverview) // Não mostrar durante animação inicial
              Positioned(
                top: 60,
                right: 12,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _isNavigationMode = !_isNavigationMode;
                    });
                    debugPrint('🗺️ [Journey] Toggle visualização: ${_isNavigationMode ? "Navegação" : "Rota Completa"}');
                  },
                  child: Icon(
                    _isNavigationMode ? Icons.map_outlined : Icons.navigation,
                    color: AppColors.zecaBlue,
                  ),
                  tooltip: _isNavigationMode ? 'Ver rota completa' : 'Modo navegação',
                ),
              ),

            // ❌ Cards de KM e Odômetro REMOVIDOS (conforme solicitado)

            // CARD DE ROTA (antes da navegação) - estilo Google Maps
            if (!_isNavigationMode && 
                _routeOriginLat != null && 
                _routeDestLat != null &&
                _routeDestinationName != null) ...[
              Positioned(
                top: 60, // Abaixo do header
                left: 0,
                right: 0,
                child: RouteSummaryCard(
                  originName: _routeOriginName,
                  destinationName: _routeDestinationName,
                  estimatedTime: _routeEstimatedTime,
                  distanceKm: _routeDistanceKm,
                  arrivalTime: _routeEstimatedTime != null 
                      ? _calculateArrivalTime(_routeEstimatedTime!)
                      : null,
                  onStart: () {
                    // Mostrar diálogo de contagem regressiva
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => NavigationCountdownDialog(
                        onComplete: () {
                          setState(() {
                            _isNavigationMode = true;
                          });
                          _startNavigation();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],

            // NAVIGATION OVERLAYS (durante navegação) - estilo Google Maps
            if (_isNavigationMode) ...[
              // Card verde de navegação no topo - FULL WIDTH
              Positioned(
                top: 60, // Abaixo do header
                left: 0,
                right: 0, // ✅ FULL WIDTH (era 80)
                child: NavigationInfoCard(
                  currentStreet: _currentStreetName ?? 'Carregando...',
                  nextStreet: _routeDestinationName,
                  nextInstruction: _currentNavigationInstruction, // 🆕 Instrução do NavigationService
                  maneuverType: _currentManeuverType, // 🆕 Tipo de manobra
                  distanceToNextMeters: _distanceToNextMeters, // 🆕 Distância em metros
                  onNextInstruction: () {
                    // TODO: Avançar para próximo step manualmente (se necessário)
                  },
                ),
              ),
            ],

            // Botões de ação - lado direito (mais para baixo)
            Positioned(
              right: 16,
              bottom: 30, // ✅ Movido mais para baixo (era 90)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            // Botão Finalizar
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
            
            // ❌ BOTÃO "PARAR" REMOVIDO
            // ❌ BOTÃO "DESCANSO" REMOVIDO (revisitar futuramente)
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

  /// Inicia navegação estilo Waze
  void _startNavigation() async {
    try {
      // Obter posição atual
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _currentLocation = position;
          _currentSpeed = position.speed * 3.6; // m/s para km/h
        });
        
        // Obter nome da rua atual
        try {
          final streetName = await geocodingService.getStreetName(
            LatLng(position.latitude, position.longitude),
          );
          if (mounted && streetName != null) {
            setState(() {
              _currentStreetName = streetName;
            });
          }
        } catch (e) {
          debugPrint('❌ [Navigation] Erro ao obter nome da rua inicial: $e');
        }
        
        debugPrint('✅ [Navigation] Navegação iniciada na posição: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      debugPrint('❌ [Journey] Erro ao iniciar navegação: $e');
    }
  }

  /// Mostra diálogo para parar navegação
  void _showStopNavigationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parar Navegação?'),
        content: const Text('Deseja parar a navegação? Você poderá retomá-la depois.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // ✅ Primeiro fechar o diálogo
              Navigator.of(context).pop();
              // ✅ Depois parar navegação (já inclui setState)
              _stopNavigation();
              // ✅ Forçar atualização do estado
              setState(() {
                _isNavigationMode = false;
              });
            },
            child: const Text('Parar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _stopNavigation() {
    debugPrint('🛑 [Journey] Parando navegação');
    _locationSubscription?.cancel();
    _locationSubscription = null;
    
    setState(() {
      _currentStreetName = null;
      _currentSpeed = 0;
      _speedLimit = null;
    });
  }

  /// Calcula hora de chegada baseado no tempo estimado
  String? _calculateArrivalTime(String estimatedTime) {
    try {
      // Parse do tempo estimado (ex: "24 min", "1h 30min", "3h")
      int minutes = 0;
      if (estimatedTime.contains('h')) {
        final parts = estimatedTime.split('h');
        final hours = int.tryParse(parts[0].trim()) ?? 0;
        minutes = hours * 60;
        if (parts.length > 1 && parts[1].contains('min')) {
          final minPart = parts[1].replaceAll('min', '').trim();
          minutes += int.tryParse(minPart) ?? 0;
        }
      } else if (estimatedTime.contains('min')) {
        final minPart = estimatedTime.replaceAll('min', '').trim();
        minutes = int.tryParse(minPart) ?? 0;
      }
      
      if (minutes > 0) {
        final arrival = DateTime.now().add(Duration(minutes: minutes));
        return DateFormat('HH:mm').format(arrival);
      }
    } catch (e) {
      debugPrint('❌ [Journey] Erro ao calcular hora de chegada: $e');
    }
    return null;
  }

  /// Inicia tracking de localização para atualizar o mapa
  void _startLocationTracking() {
    if (_locationSubscription != null) return; // Já está ativo
    
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Atualizar a cada 10 metros
      ),
    ).listen(
      (Position position) async {
        if (mounted) {
          setState(() {
            _currentLocation = position;
            _currentSpeed = position.speed * 3.6; // m/s para km/h
          });
          
          // 🆕 LOG: Confirmar atualização de posição
          debugPrint('📍 [Journey] Posição atualizada: ${position.latitude}, ${position.longitude}');
          
          // 🆕 ATUALIZAR CÂMERA DIRETAMENTE (solução estável)
          if (_googleMapController != null && _isNavigationMode) {
            try {
              await _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 18.0,
                    tilt: 55.0,
                    bearing: position.heading, // 🆕 Rotação do mapa!
                  ),
                ),
              );
              debugPrint('✅ [Journey] Câmera atualizada! Zoom: 18, Tilt: 55°, Bearing: ${position.heading}°');
            } catch (e) {
              debugPrint('⚠️ [Journey] Erro ao atualizar câmera: $e');
            }
          } else {
            if (_googleMapController == null) {
              debugPrint('⚠️ [Journey] GoogleMapController ainda null');
            }
            if (!_isNavigationMode) {
              debugPrint('⚠️ [Journey] Modo navegação desligado');
            }
          }
          
          // 🆕 Atualizar posição no NavigationService
          if (_isNavigationMode && navigationService.steps.isNotEmpty) {
            navigationService.updateCurrentPosition(
              LatLng(position.latitude, position.longitude),
            );
          }
          
          // Atualizar nome da rua se estiver em modo navegação
          if (_isNavigationMode) {
            try {
              final streetName = await geocodingService.getStreetName(
                LatLng(position.latitude, position.longitude),
              );
              if (mounted && streetName != null) {
                setState(() {
                  _currentStreetName = streetName;
                });
              }
            } catch (e) {
              debugPrint('❌ [Navigation] Erro ao obter nome da rua: $e');
            }
          }
          
          debugPrint('📍 [Navigation] Nova posição: ${position.latitude}, ${position.longitude}, ${_currentSpeed.toStringAsFixed(1)} km/h');
        }
      },
      onError: (error) {
        debugPrint('❌ [Navigation] Erro no tracking: $error');
      },
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

