import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlavorConfig.instance.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: Abrir drawer menu
          },
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              children: [
                // Card Bem-vindo
                _buildWelcomeCard(primaryColor),
                const SizedBox(height: 16),

                // Card Veículo
                _buildVehicleCard(primaryColor),
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
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
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
                child: const Text(
                  'CONFIRMAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(Color primaryColor) {
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
          Row(
            children: [
              Icon(Icons.person, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Bem-vindo!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info: Motorista
          _buildInfoRow(Icons.badge, 'Motorista:', _driverInfo['name']!),
          const SizedBox(height: 8),

          // Info: CPF
          _buildInfoRow(Icons.credit_card, 'CPF:', _driverInfo['cpf']!),
          const SizedBox(height: 12),

          // Badge Autônomo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_shipping, size: 14, color: Color(0xFFE65100)),
                SizedBox(width: 6),
                Text(
                  'Motorista Autônomo',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE65100),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9E9E9E)),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: const TextStyle(fontSize: 14, color: Color(0xFF424242)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
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
              Icon(Icons.directions_car, size: 20, color: Color(0xFFE53935)),
              SizedBox(width: 8),
              Text(
                'Veículo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
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
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
              color: const Color(0xFFE3F2FD),
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
}
