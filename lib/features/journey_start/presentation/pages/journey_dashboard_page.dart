import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../core/di/injection.dart';

class JourneyDashboardPage extends StatefulWidget {
  const JourneyDashboardPage({Key? key}) : super(key: key);

  @override
  State<JourneyDashboardPage> createState() => _JourneyDashboardPageState();
}

class _JourneyDashboardPageState extends State<JourneyDashboardPage> {
  Map<String, dynamic>? _vehicleData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  /// Carregar dados do veículo da jornada ativa
  Future<void> _loadVehicleData() async {
    try {
      final storageService = getIt<StorageService>();
      final vehicleData = await storageService.getJourneyVehicleData();
      
      if (vehicleData == null || vehicleData.isEmpty) {
        // Não há jornada ativa, redirecionar para tela de início
        if (mounted) {
          context.go('/journey-start');
        }
        return;
      }
      
      setState(() {
        _vehicleData = vehicleData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar dados do veículo: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Finalizar jornada (limpar dados do veículo)
  Future<void> _finishJourney() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Jornada'),
        content: const Text(
          'Tem certeza que deseja finalizar esta jornada? Os dados do veículo serão removidos e você precisará selecionar outro veículo para iniciar uma nova jornada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final storageService = getIt<StorageService>();
        await storageService.clearJourneyVehicleData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Jornada finalizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/journey-start');
        }
      } catch (e) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao finalizar jornada: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZECA - Jornada Ativa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            tooltip: 'Finalizar Jornada',
            onPressed: _finishJourney,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 16.0 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card de Informações do Veículo Ativo
                  _buildVehicleInfoCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Título da Seção
                  Text(
                    'O que você deseja fazer?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Card 1: Abastecimento
                  _buildActionCard(
                    icon: Icons.local_gas_station,
                    title: 'Abastecimento',
                    description: 'Registrar abastecimento do veículo',
                    color: AppColors.secondaryRed,
                    onTap: () => context.go('/home'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Card 2: Iniciar Viagem
                  _buildActionCard(
                    icon: Icons.route,
                    title: 'Iniciar Viagem',
                    description: 'Iniciar registro de viagem',
                    color: AppColors.zecaBlue,
                    onTap: () => context.go('/journey'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Card 3: Checklist
                  _buildActionCard(
                    icon: Icons.assignment_turned_in,
                    title: 'Checklist',
                    description: 'Realizar checklist do veículo',
                    color: Colors.green,
                    onTap: () => context.go('/checklist'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildVehicleInfoCard() {
    if (_vehicleData == null) return const SizedBox.shrink();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.zecaBlue,
              AppColors.zecaBlue.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Veículo Ativo',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _vehicleData!['placa'] ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ATIVA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white30, height: 24),
            _buildVehicleInfoRow(
              icon: Icons.local_offer,
              label: 'Modelo',
              value: '${_vehicleData!['marca']} ${_vehicleData!['modelo']} (${_vehicleData!['ano']})',
            ),
            const SizedBox(height: 8),
            _buildVehicleInfoRow(
              icon: Icons.local_gas_station,
              label: 'Combustível',
              value: _vehicleData!['tipoCombustivel'] ?? 'N/A',
            ),
            const SizedBox(height: 8),
            _buildVehicleInfoRow(
              icon: Icons.person,
              label: 'Motorista',
              value: _vehicleData!['driver_name'] ?? 'N/A',
            ),
            const SizedBox(height: 8),
            // Transportadora (sem label, apenas valor)
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _vehicleData!['transporter_name'] ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

