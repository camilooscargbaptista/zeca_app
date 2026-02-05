import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/location_service.dart';
import '../bloc/nearby_stations/nearby_stations_bloc.dart';
import '../widgets/nearby_stations/filter_pill.dart';
import '../widgets/nearby_stations/nearby_station_card.dart';

class NearbyStationsPage extends StatelessWidget {
  const NearbyStationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Não carrega postos imediatamente - a View buscará a localização real
      create: (context) => GetIt.I<NearbyStationsBloc>(),
      child: const NearbyStationsView(),
    );
  }
}

class NearbyStationsView extends StatefulWidget {
  const NearbyStationsView({Key? key}) : super(key: key);

  @override
  State<NearbyStationsView> createState() => _NearbyStationsViewState();
}

class _NearbyStationsViewState extends State<NearbyStationsView> {
  String _activeFilter = 'Todos';
  String _userLocation = 'Carregando localização...';
  
  // Coordenadas reais do usuário (atualizadas pelo GPS)
  double _userLatitude = -23.5505; // Fallback São Paulo
  double _userLongitude = -46.6333;
  bool _locationLoaded = false;
  
  // Controlador de busca
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadUserLocationFromGPS();
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  /// Dispara busca no backend com debounce
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    
    // Cancela timer anterior para debounce
    _debounceTimer?.cancel();
    
    // Aguarda 500ms antes de buscar (debounce)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Só busca se tiver 3+ caracteres ou se limpar a busca
      if (value.isEmpty || value.length >= 3) {
        _triggerSearch(value.isEmpty ? null : value);
      }
    });
  }
  
  /// Dispara evento de busca no bloc
  void _triggerSearch(String? searchTerm) {
    if (!_locationLoaded) return;
    
    context.read<NearbyStationsBloc>().add(
      LoadNearbyStations(
        latitude: _userLatitude,
        longitude: _userLongitude,
        radius: 20000,
        search: searchTerm,
        conveniado: _activeFilter == 'Parceiros' ? true : null,
      ),
    );
  }

  /// Carregar localização real do GPS e buscar postos próximos
  Future<void> _loadUserLocationFromGPS() async {
    try {
      final locationService = LocationService();
      
      // Verificar permissões
      final hasPermission = await locationService.checkPermission();
      if (!hasPermission) {
        final permissionGranted = await locationService.requestPermission();
        if (!permissionGranted) {
          debugPrint('⚠️ [NearbyStations] Permissão de localização negada');
          // Usar localização padrão e continuar
          _loadStationsWithFallback();
          return;
        }
      }
      
      // Obter posição atual do GPS
      final position = await locationService.getCurrentPosition();
      
      // Verificar se posição foi obtida com sucesso
      if (position == null) {
        debugPrint('⚠️ [NearbyStations] Não foi possível obter posição GPS');
        _loadStationsWithFallback();
        return;
      }
      
      if (mounted) {
        setState(() {
          _userLatitude = position.latitude;
          _userLongitude = position.longitude;
          _locationLoaded = true;
        });
        
        debugPrint('📍 [NearbyStations] GPS: lat=${position.latitude}, lng=${position.longitude}');
        
        // Buscar nome da localização
        _updateLocationName(position.latitude, position.longitude);
        
        // Carregar postos com localização real
        context.read<NearbyStationsBloc>().add(
          LoadNearbyStations(
            latitude: position.latitude,
            longitude: position.longitude,
            radius: 20000,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [NearbyStations] Erro ao obter GPS: $e');
      // Fallback para localização padrão
      _loadStationsWithFallback();
    }
  }
  
  /// Fallback quando GPS não está disponível
  void _loadStationsWithFallback() {
    if (mounted) {
      setState(() {
        _userLocation = 'Localização indisponível';
      });
      
      // Carregar postos com coordenadas padrão
      context.read<NearbyStationsBloc>().add(
        LoadNearbyStations(
          latitude: _userLatitude,
          longitude: _userLongitude,
          radius: 20000,
        ),
      );
    }
  }
  
  /// Atualizar nome da localização via geocoding
  Future<void> _updateLocationName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty && mounted) {
        final placemark = placemarks.first;
        setState(() {
          _userLocation = '${placemark.subAdministrativeArea ?? placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}';
        });
      }
    } catch (e) {
      debugPrint('⚠️ [NearbyStations] Erro geocoding: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              // Espaço para o Header Fixo
              const SizedBox(height: 225),
              
              // Lista de Postos
              Expanded(
                child: BlocBuilder<NearbyStationsBloc, NearbyStationsState>(
                  builder: (context, state) {
                    if (state is NearbyStationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (state is NearbyStationsError) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<NearbyStationsBloc>().add(
                                    LoadNearbyStations(
                                      latitude: _userLatitude,
                                      longitude: _userLongitude,
                                      radius: 20000,
                                    ),
                                  );
                                },
                                child: const Text('Tentar Novamente'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    if (state is NearbyStationsEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.location_off, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('Nenhum posto encontrado na região'),
                          ],
                        ),
                      );
                    }
                    
                    if (state is NearbyStationsLoaded) {
                      // Busca já filtrada pelo backend
                      if (state.stations.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(_searchQuery.isNotEmpty 
                                  ? 'Nenhum posto encontrado para "$_searchQuery"'
                                  : 'Nenhum posto encontrado na região'),
                            ],
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Bottom padding para scroll
                        itemCount: state.stations.length,
                        itemBuilder: (context, index) {
                          final station = state.stations[index];
                          return NearbyStationCard(
                            station: station,
                            onTap: () {
                              // Navegar para tela de abastecimento com CNPJ do posto
                              context.go('/home', extra: {
                                'station_cnpj': station.cnpj,
                                'station_name': station.nomeFantasia,
                              });
                            },
                            onNavigate: () {
                              // TODO: Abrir maps
                            },
                          );
                        },
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          
          // Fixed Header
          Container(
            height: 225,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
            ),
            child: Column(
              children: [
                // Top Bar Gradiente
                Container(
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Postos Próximos',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white70, size: 12),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _userLocation,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Removed Tune Icon
                    ],
                  ),
                ),
                
                // Search Bar (overlap)
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF999999), size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              hintText: _searchQuery.isNotEmpty && _searchQuery.length < 3
                                  ? 'Digite mais ${3 - _searchQuery.length} caractere(s)...'
                                  : 'Buscar por nome ou endereço...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              isDense: true,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 15,
                            ),
                            onChanged: _onSearchChanged,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              _searchFocusNode.unfocus();
                              // Busca imediata se tiver 3+ caracteres
                              if (value.length >= 3) {
                                _debounceTimer?.cancel();
                                _triggerSearch(value);
                              }
                            },
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _debounceTimer?.cancel();
                              setState(() {
                                _searchQuery = '';
                              });
                              // Recarrega postos sem filtro de busca
                              _triggerSearch(null);
                            },
                            child: const Icon(Icons.close, color: Color(0xFF999999), size: 18),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Filters
                SizedBox(
                  height: 34, // Altura do pill + margem
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildFilter('Todos', Icons.local_fire_department),
                      _buildFilter('Parceiros', Icons.handshake),
                      _buildFilter('Diesel S10', Icons.local_gas_station),
                      _buildFilter('ARLA 32', Icons.water_drop),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildFilter(String label, IconData icon) {
    final isActive = _activeFilter == label;
    return FilterPill(
      label: label,
      icon: icon,
      isActive: isActive,
      onTap: () {
        setState(() => _activeFilter = label);
        if (label == 'Parceiros') {
          context.read<NearbyStationsBloc>().add(
            LoadNearbyStations(
              latitude: _userLatitude,
              longitude: _userLongitude,
              conveniado: true,
              radius: 20000,
            ),
          );
        } else if (label == 'Todos') {
           context.read<NearbyStationsBloc>().add(
            LoadNearbyStations(
              latitude: _userLatitude,
              longitude: _userLongitude,
              radius: 20000,
            ),
          );
        }
      },
    );
  }
}
