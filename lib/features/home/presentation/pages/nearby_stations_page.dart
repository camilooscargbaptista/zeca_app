import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/nearby_stations/nearby_stations_bloc.dart';
import '../widgets/nearby_stations/filter_pill.dart';
import '../widgets/nearby_stations/nearby_station_card.dart';

class NearbyStationsPage extends StatelessWidget {
  const NearbyStationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<NearbyStationsBloc>()
        ..add(const LoadNearbyStations(
          // TODO: Pegar localização real do device
          latitude: -23.5505,
          longitude: -46.6333,
          radius: 20000,
        )),
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
  String _userLocation = 'Sua localização atual';

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      // Coordenadas hardcoded (TODO: pegar localização real do GPS)
      const latitude = -23.5505;
      const longitude = -46.6333;
      
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty && mounted) {
        final placemark = placemarks.first;
        setState(() {
          _userLocation = '${placemark.subAdministrativeArea ?? placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}';
        });
      }
    } catch (e) {
      print('Erro ao obter localização: $e');
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
                                    const LoadNearbyStations(
                                      latitude: -23.5505,
                                      longitude: -46.6333,
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
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Bottom padding para scroll
                        itemCount: state.stations.length,
                        itemBuilder: (context, index) {
                          final station = state.stations[index];
                          return NearbyStationCard(
                            station: station,
                            onTap: () {
                              // TODO: Navegar para detalhes ou iniciar abastecimento
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      children: const [
                        Icon(Icons.search, color: Color(0xFF999999), size: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Buscar por nome ou endereço...',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 15,
                            ),
                          ),
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
            const LoadNearbyStations(
              latitude: -23.5505,
              longitude: -46.6333,
              conveniado: true,
              radius: 20000,
            ),
          );
        } else if (label == 'Todos') {
           context.read<NearbyStationsBloc>().add(
            const LoadNearbyStations(
              latitude: -23.5505,
              longitude: -46.6333,
              radius: 20000,
            ),
          );
        }
      },
    );
  }
}
