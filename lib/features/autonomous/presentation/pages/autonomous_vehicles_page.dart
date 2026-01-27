import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_colors.dart';

class AutonomousVehiclesPage extends StatefulWidget {
  const AutonomousVehiclesPage({Key? key}) : super(key: key);

  @override
  State<AutonomousVehiclesPage> createState() => _AutonomousVehiclesPageState();
}

class _AutonomousVehiclesPageState extends State<AutonomousVehiclesPage> {
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _error;
  List<Map<String, dynamic>> _vehicles = [];
  int _vehicleLimit = 3;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.get('/autonomous/vehicles');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        setState(() {
          _vehicles = data.map((v) => <String, dynamic>{
            'id': v['id']?.toString() ?? '',
            'plate': v['plate'] ?? '',
            'brand': v['brand'] ?? '',
            'model': v['model'] ?? '',
            'year': _parseToInt(v['year']),
            'fuelType': _formatFuelType(v['fuel_type'] ?? ''),
            'odometer': _parseToInt(v['odometer']),
          }).toList();
          _isLoading = false;
        });
        
        // Buscar limite de veículos
        final countResponse = await apiService.countAutonomousVehicles();
        if (countResponse['success'] == true) {
          setState(() {
            _vehicleLimit = countResponse['data']?['limit'] ?? 3;
          });
        }
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

  String _formatFuelType(String type) {
    switch (type) {
      case 'DIESEL_S10': return 'Diesel S10';
      case 'DIESEL_S500': return 'Diesel S500';
      case 'GASOLINA': return 'Gasolina';
      case 'ETANOL': return 'Etanol';
      default: return type;
    }
  }

  /// Converte valor para int de forma segura (API pode retornar String, num ou double)
  int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      // Remover decimais se existir (ex: "213455.000" → 213455)
      final cleanValue = value.replaceAll(RegExp(r'\..*'), '');
      return int.tryParse(cleanValue) ?? 0;
    }
    return 0;
  }

  /// Exibir modal de confirmação e excluir veículo via API
  Future<void> _deleteVehicle(String vehicleId, String plate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Excluir Veículo?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tem certeza que deseja excluir o veículo $plate?',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Esta ação não pode ser desfeita.',
                      style: TextStyle(fontSize: 13, color: AppColors.grey600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: TextStyle(color: AppColors.grey600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Chamar API para excluir
    setState(() => _isDeleting = true);

    try {
      final apiService = ApiService();
      final response = await apiService.delete('/autonomous/vehicles/$vehicleId');

      if (!mounted) return;

      if (response['success'] == true) {
        // Recarregar lista após exclusão
        await _loadVehicles();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Veículo $plate excluído com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() => _isDeleting = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'Erro ao excluir veículo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isDeleting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro de conexão: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatOdometer(int odometer) {
    return odometer.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Meus Veículos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.push('/autonomous/vehicles/add'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Conteúdo principal
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadVehicles,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Info box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: primaryColor, size: 18),
                              const SizedBox(width: 12),
                              Text(
                                '${_vehicles.length} de $_vehicleLimit veículos cadastrados',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Lista de veículos
                        if (_vehicles.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhum veículo cadastrado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Adicione seu primeiro veículo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ..._vehicles.map((vehicle) => _buildVehicleCard(vehicle)),
                      ],
                    ),
                  ),
                ),
          
          // Loading overlay durante exclusão
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Excluindo veículo...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => context.push('/autonomous/vehicles/add'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        children: [
          // Header: ícone, info, ações
          Row(
            children: [
              // Ícone do veículo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.local_shipping, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              
              // Info do veículo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle['plate'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${vehicle['brand']} ${vehicle['model']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Ações
              Row(
                children: [
                  // Editar
                  _buildActionButton(
                    icon: Icons.edit,
                    color: primaryColor,
                    backgroundColor: AppColors.primaryBlueLight,
                    onTap: () => context.push('/autonomous/vehicles/edit/${vehicle['id']}'),
                  ),
                  const SizedBox(width: 8),
                  // Excluir
                  _buildActionButton(
                    icon: Icons.delete,
                    color: AppColors.error,
                    backgroundColor: const Color(0xFFFFEBEE), // Red light bg
                    onTap: () => _deleteVehicle(vehicle['id'], vehicle['plate']),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Detalhes
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                // Combustível
                _buildDetailItem(
                  icon: Icons.local_gas_station,
                  value: vehicle['fuelType'],
                  isBadge: true,
                ),
                const SizedBox(width: 12),
                // Ano
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  value: vehicle['year'].toString(),
                ),
                const SizedBox(width: 12),
                // Quilometragem
                _buildDetailItem(
                  icon: Icons.speed,
                  value: '${_formatOdometer(vehicle['odometer'])} km',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String value,
    bool isBadge = false,
  }) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: primaryColor, size: 12),
        const SizedBox(width: 6),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0), // Orange light bg
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
