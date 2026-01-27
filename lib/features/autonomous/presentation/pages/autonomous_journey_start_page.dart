import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../core/di/injection.dart';


class AutonomousJourneyStartPage extends StatefulWidget {
  const AutonomousJourneyStartPage({Key? key}) : super(key: key);

  @override
  State<AutonomousJourneyStartPage> createState() => _AutonomousJourneyStartPageState();
}

class _AutonomousJourneyStartPageState extends State<AutonomousJourneyStartPage> {
  String? _selectedVehicleId;
  bool _isLoading = true;
  String? _error;

  // Dados carregados da API
  Map<String, String> _driverInfo = {
    'name': '',
    'cpf': '',
  };

  List<Map<String, dynamic>> _vehicles = [];
  
  // NOVO: Estatísticas do veículo
  Map<String, dynamic>? _vehicleStats;
  bool _loadingStats = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Carregar dados do usuário do storage
      final storageService = getIt<StorageService>();
      final userData = storageService.getUserData();
      
      if (userData != null) {
        setState(() {
          _driverInfo = {
            'name': userData['name'] ?? userData['nome'] ?? '',
            'cpf': _formatCpf(userData['cpf'] ?? ''),
          };
        });
      }

      // Carregar veículos da API
      final apiService = ApiService();
      final response = await apiService.get('/autonomous/vehicles');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        setState(() {
          _vehicles = data.map((v) => {
            'id': v['id']?.toString() ?? '',
            'plate': v['plate'] ?? '',
            'model': '${v['brand'] ?? ''} ${v['model'] ?? ''}'.trim(),
          }).toList();
          _isLoading = false;
          
          // Selecionar primeiro veículo automaticamente se houver apenas um
          if (_vehicles.length == 1) {
            _selectedVehicleId = _vehicles.first['id'];
            // Buscar stats do veículo auto-selecionado
            if (_vehicles.first['plate'] != null) {
              _fetchVehicleStats(_vehicles.first['plate']);
            }
          }
        });
      } else {
        setState(() {
          _error = response['error'] ?? 'Erro ao carregar veículos';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão: $e';
        _isLoading = false;
      });
    }
  }

  String _formatCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 11) return cpf;
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
  }

  void _onConfirm() async {
    if (_selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um veículo para continuar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Buscar veículo selecionado
      final selectedVehicle = _vehicles.firstWhere(
        (v) => v['id'] == _selectedVehicleId,
        orElse: () => {},
      );
      
      if (selectedVehicle.isEmpty) {
        throw Exception('Veículo não encontrado');
      }

      // Buscar dados detalhados do veículo da API
      final apiService = ApiService();
      final response = await apiService.get('/autonomous/vehicles/$_selectedVehicleId');
      
      Map<String, dynamic> vehicleDetails;
      if (response['success'] == true && response['data'] != null) {
        vehicleDetails = response['data'];
      } else {
        // Usar dados já carregados se API falhar
        vehicleDetails = selectedVehicle;
      }

      // Salvar dados do veículo no formato esperado pelo journey_dashboard
      final storageService = getIt<StorageService>();
      await storageService.saveJourneyVehicleData({
        'placa': vehicleDetails['plate'] ?? selectedVehicle['plate'],
        'marca': vehicleDetails['brand'] ?? '',
        'modelo': vehicleDetails['model'] ?? selectedVehicle['model'],
        'ano': vehicleDetails['year']?.toString() ?? '',
        'tipoCombustivel': _formatFuelType(vehicleDetails['fuel_type'] ?? ''),
        'driver_name': _driverInfo['name'] ?? '',
        'transporter_name': '${_driverInfo['name']} (Autônomo)',
        'is_autonomous': true,
      });

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jornada iniciada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navegar para tela de Jornada Ativa (mesma dos motoristas normais)
        context.go('/journey-dashboard');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao iniciar jornada: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  String _formatFuelType(String type) {
    switch (type) {
      case 'DIESEL_S10': return 'Diesel S10';
      case 'DIESEL_S500': return 'Diesel S500';
      case 'GASOLINA': return 'Gasolina';
      case 'ETANOL': return 'Etanol';
      default: return type;
    }
  }
  
  /// Buscar estatísticas do veículo (último KM, consumo médio, abast. do mês)
  Future<void> _fetchVehicleStats(String plate) async {
    setState(() {
      _loadingStats = true;
    });
    
    try {
      final apiService = ApiService();
      final cleanPlate = plate.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
      final response = await apiService.get('/vehicles/$cleanPlate/stats');
      
      debugPrint('📊 Stats do veículo $cleanPlate: $response');
      
      if (mounted && response != null && response['success'] == true) {
        final data = response['data'] ?? {};
        setState(() {
          _vehicleStats = {
            'last_odometer': data['last_odometer'],
            'average_consumption': data['average_consumption'],
            'refuelings_this_month': data['refuelings_this_month'],
          };
          _loadingStats = false;
        });
      } else {
        setState(() {
          _loadingStats = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar stats do veículo: $e');
      setState(() {
        _loadingStats = false;
      });
    }
  }
  
  /// Formatar odômetro para display
  String _formatOdometer(dynamic value) {
    if (value == null) return '--';
    final intValue = value is double ? value.toInt() : int.tryParse(value.toString()) ?? 0;
    final formatted = intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlavorConfig.instance.primaryColor;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'Iniciar Jornada',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Mostrar notificações
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              children: [
                // Card Motorista (compacto)
                _buildWelcomeCard(primaryColor),
                const SizedBox(height: 16),

                // Card Veículo
                _buildVehicleCard(primaryColor),
                
                // Card Stats (quando veículo selecionado)
                if (_selectedVehicleId != null) ...[
                  const SizedBox(height: 16),
                  _buildVehicleStatsCard(primaryColor),
                ],
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Iniciar Jornada',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(Color primaryColor) {
    // Extrair iniciais do nome
    String initials = '';
    if (_driverInfo['name']!.isNotEmpty) {
      final names = _driverInfo['name']!.split(' ');
      if (names.length >= 2) {
        initials = '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
      } else if (names.isNotEmpty) {
        initials = names[0].substring(0, 2).toUpperCase();
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar com iniciais
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _driverInfo['name'] ?? 'Motorista',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'CPF: ${_driverInfo['cpf'] ?? '---'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Badge Autônomo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Autônomo',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.orange[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // REMOVIDO: _buildDrawer() - Agora usa AppDrawer unificado (lib/shared/widgets/app_drawer.dart)

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey500),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: TextStyle(fontSize: 14, color: AppColors.grey800),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.directions_car, size: 20, color: AppColors.error),
              SizedBox(width: 8),
              Text(
                'Veículo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Select de veículos
          DropdownButtonFormField<String>(
            value: _selectedVehicleId,
            decoration: InputDecoration(
              hintText: 'Selecione um veículo',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            items: _vehicles.map((vehicle) {
              return DropdownMenuItem<String>(
                value: vehicle['id'] as String,
                child: Text('${vehicle['plate']} - ${vehicle['model']}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedVehicleId = value);
              // Buscar stats do veículo selecionado
              if (value != null) {
                final vehicle = _vehicles.firstWhere((v) => v['id'] == value, orElse: () => {});
                if (vehicle.isNotEmpty && vehicle['plate'] != null) {
                  _fetchVehicleStats(vehicle['plate']);
                }
              }
            },
          ),
          const SizedBox(height: 12),

          // Botão adicionar veículo
          OutlinedButton.icon(
            onPressed: () => context.push('/autonomous/vehicles/add'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Cadastrar novo veículo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor, style: BorderStyle.solid),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: primaryColor, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Selecione o veículo que você irá utilizar nesta jornada. Após confirmar, você terá acesso às funcionalidades de abastecimento.',
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Card de estatísticas do veículo
  Widget _buildVehicleStatsCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.analytics_outlined, color: Colors.orange[700], size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Resumo do Veículo',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _loadingStats
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.speed,
                      label: 'Último KM',
                      value: _formatOdometer(_vehicleStats?['last_odometer']),
                      color: Colors.blue,
                    ),
                    _buildStatItem(
                      icon: Icons.local_gas_station,
                      label: 'Km/L Médio',
                      value: _vehicleStats?['average_consumption']?.toString() ?? '--',
                      color: Colors.green,
                    ),
                    _buildStatItem(
                      icon: Icons.calendar_month,
                      label: 'Abast. Mês',
                      value: _vehicleStats?['refuelings_this_month']?.toString() ?? '0',
                      color: Colors.purple,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
  
  /// Widget para cada item de estatística
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
