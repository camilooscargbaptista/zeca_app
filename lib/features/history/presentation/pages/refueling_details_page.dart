import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/volume.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/di/injection.dart';

/// Página de detalhes de um abastecimento específico
class RefuelingDetailsPage extends StatefulWidget {
  final String refuelingId;

  const RefuelingDetailsPage({
    Key? key,
    required this.refuelingId,
  }) : super(key: key);

  @override
  State<RefuelingDetailsPage> createState() => _RefuelingDetailsPageState();
}

class _RefuelingDetailsPageState extends State<RefuelingDetailsPage> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final client = getIt<DioClient>();
      final response = await client.get('/refueling/${widget.refuelingId}');
      
      setState(() {
        _data = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Abastecimento'),
        backgroundColor: AppColors.zecaBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Erro ao carregar detalhes', style: TextStyle(fontSize: 18, color: AppColors.grey700)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.grey600)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDetails,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.zecaBlue),
              child: const Text('Tentar novamente', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_data == null) {
      return const Center(child: Text('Nenhum dado encontrado'));
    }

    return RefreshIndicator(
      onRefresh: _loadDetails,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildMainInfoCard(),
            const SizedBox(height: 16),
            _buildDetailsCard(),
            const SizedBox(height: 16),
            _buildCodeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = _data!['status'] ?? 'DESCONHECIDO';
    final isAutonomous = _data!['is_autonomous'] == true;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'CONCLUIDO':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'PENDENTE':
      case 'AGUARDANDO_VALIDACAO_MOTORISTA':
        statusColor = AppColors.warning;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'CANCELADO':
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.grey600;
        statusIcon = Icons.info;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusLabel(status),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                  if (isAutonomous)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.zecaOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Autônomo', style: TextStyle(fontSize: 12, color: AppColors.zecaOrange, fontWeight: FontWeight.w500)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    // Converte UTC para timezone local
    final datetime = DateTime.tryParse(_data!['refueling_datetime'] ?? '')?.toLocal();
    
    final quantityLiters = double.tryParse(_data!['quantity_liters']?.toString() ?? '0') ?? 0;
    final totalAmount = double.tryParse(_data!['total_amount']?.toString() ?? '0') ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Litros', style: TextStyle(fontSize: 12, color: AppColors.grey600)),
                    Text(Volume.fromDouble(quantityLiters).formatted, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Valor Total', style: TextStyle(fontSize: 12, color: AppColors.grey600)),
                    Text(Money.fromDouble(totalAmount).formatted, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.zecaGreen)),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text(
                  datetime != null ? '${dateFormat.format(datetime)} às ${timeFormat.format(datetime)}' : '--',
                  style: TextStyle(color: AppColors.grey700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    // Helper para extrair nome de campos que podem ser String ou Map
    String _extractName(dynamic value, [String fallback = '--']) {
      if (value == null) return fallback;
      if (value is String) return value;
      if (value is Map) {
        // Tenta extrair 'name' ou 'plate' do objeto
        return value['name']?.toString() 
            ?? value['plate']?.toString() 
            ?? value['code']?.toString()
            ?? fallback;
      }
      return value.toString();
    }

    // Extrair valores de forma segura
    final stationName = _data!['station']?['company_name'] 
        ?? _data!['station']?['name']
        ?? _data!['station_name'] 
        ?? '--';
    final vehiclePlate = _data!['vehicle']?['plate'] 
        ?? _data!['vehicle_plate'] 
        ?? '--';
    final fuelType = _extractName(_data!['fuel_type']);
    final driverName = _data!['driver']?['name'] 
        ?? _data!['driver_name'] 
        ?? '--';
    final transporterName = _data!['transporter']?['name'] 
        ?? _data!['transporter_name'] 
        ?? '--';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalhes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.grey800)),
            const SizedBox(height: 12),
            _detailRow(Icons.local_gas_station, 'Posto', stationName.toString()),
            _detailRow(Icons.directions_car, 'Veículo', vehiclePlate.toString()),
            _detailRow(Icons.local_drink, 'Combustível', fuelType),
            _detailRow(Icons.person, 'Motorista', driverName.toString()),
            _detailRow(Icons.business, 'Transportadora', transporterName.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard() {
    final code = _data!['refueling_code'] ?? '--';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código do Abastecimento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.grey800)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Text(
                code,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'monospace', color: AppColors.zecaBlue, letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.grey500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: AppColors.grey600)),
          ),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey800)),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'CONCLUIDO': return 'Concluído';
      case 'PENDENTE': return 'Pendente';
      case 'AGUARDANDO_VALIDACAO_MOTORISTA': return 'Aguardando Validação';
      case 'AGUARDANDO_NFE': return 'Aguardando NFE';
      case 'VALIDADO': return 'Validado';
      case 'CANCELADO': return 'Cancelado';
      case 'CONTESTADO': return 'Contestado';
      default: return status;
    }
  }
}
