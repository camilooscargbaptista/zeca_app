import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/api_service.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import 'refueling_waiting_page.dart';

class PendingRefuelingsPage extends StatefulWidget {
  const PendingRefuelingsPage({Key? key}) : super(key: key);

  @override
  State<PendingRefuelingsPage> createState() => _PendingRefuelingsPageState();
}

class _PendingRefuelingsPageState extends State<PendingRefuelingsPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _pendingRefuelings = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadPendingRefuelings();
  }

  Future<void> _loadPendingRefuelings() async {
    if (_isRefreshing) return; // Evitar múltiplas chamadas simultâneas
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Buscar abastecimentos com status AGUARDANDO_VALIDACAO_MOTORISTA
      debugPrint('🔄 Carregando abastecimentos pendentes...');
      final response = await _apiService.getPendingRefuelings();
      debugPrint('📦 Resposta recebida: ${response.toString()}');

      if (response['success'] == true) {
        final data = response['data'];
        debugPrint('📦 Data recebida: ${data.toString()}');
        debugPrint('📦 Tipo de data: ${data.runtimeType}');
        
        // A resposta pode vir como Map ou List diretamente
        List<dynamic> refuelings = [];
        
        if (data is Map<String, dynamic>) {
          // Se for Map, tentar pegar a propriedade 'data'
          refuelings = data['data'] as List<dynamic>? ?? [];
          debugPrint('📦 Refuelings do Map: ${refuelings.length}');
        } else if (data is List) {
          // Se for List diretamente
          refuelings = data;
          debugPrint('📦 Refuelings da List: ${refuelings.length}');
        }
        
        debugPrint('✅ Total de abastecimentos pendentes: ${refuelings.length}');
        
        setState(() {
          _pendingRefuelings = refuelings
              .map((r) => r as Map<String, dynamic>)
              .toList();
          _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
        
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro',
            message: response['error'] ?? 'Erro ao carregar abastecimentos pendentes',
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao carregar abastecimentos pendentes: $e',
        );
      }
    }
  }

  Future<void> _refreshPendingRefuelings() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadPendingRefuelings();
  }

  void _navigateToValidation(String refuelingId, Map<String, dynamic> refuelingData) {
    // Extrair dados necessários para navegação
    // Os dados podem vir com vehicle/station como objetos ou apenas com os nomes diretos
    Map<String, dynamic>? vehicleData;
    Map<String, dynamic>? stationData;
    
    // Tentar pegar vehicle como objeto
    if (refuelingData['vehicle'] != null) {
      final vehicle = refuelingData['vehicle'] as Map<String, dynamic>?;
      vehicleData = {
        'placa': vehicle?['plate'] ?? refuelingData['vehicle_plate'] ?? '',
        'id': vehicle?['id'] ?? '',
      };
    } else if (refuelingData['vehicle_plate'] != null) {
      // Se não tiver vehicle como objeto, usar vehicle_plate direto
      vehicleData = {
        'placa': refuelingData['vehicle_plate'] as String? ?? '',
        'id': '',
      };
    }
    
    // Tentar pegar station como objeto
    if (refuelingData['station'] != null) {
      final station = refuelingData['station'] as Map<String, dynamic>?;
      stationData = {
        'nome': station?['name'] ?? refuelingData['station_name'] ?? '',
        'cnpj': station?['cnpj'] ?? refuelingData['station_cnpj'] ?? '',
        'id': station?['id'] ?? '',
      };
    } else if (refuelingData['station_name'] != null) {
      // Se não tiver station como objeto, usar station_name e station_cnpj diretos
      stationData = {
        'nome': refuelingData['station_name'] as String? ?? '',
        'cnpj': refuelingData['station_cnpj'] as String? ?? '',
        'id': '',
      };
    }
    
    final refuelingCode = refuelingData['refueling_code'] as String? ?? '';

    // Navegar para a tela de validação (usando go para substituir a pilha)
    context.go(
      '/refueling-waiting',
      extra: {
        'refueling_id': refuelingId,
        'refueling_code': refuelingCode,
        'vehicle_data': vehicleData,
        'station_data': stationData,
      },
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatCurrency(double? value) {
    if (value == null) return 'R\$ 0,00';
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abastecimentos Pendentes'),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshPendingRefuelings,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading && !_isRefreshing,
        child: _pendingRefuelings.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum abastecimento pendente',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Todos os abastecimentos foram validados',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refreshPendingRefuelings,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Atualizar'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshPendingRefuelings,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingRefuelings.length,
                  itemBuilder: (context, index) {
                    final refueling = _pendingRefuelings[index];
                    final refuelingId = refueling['id'] as String? ?? '';
                    final code = refueling['refueling_code'] as String? ?? 'N/A';
                    
                    // Converter quantity_liters (pode vir como String ou double)
                    double? quantity;
                    final quantityValue = refueling['quantity_liters'];
                    if (quantityValue != null) {
                      if (quantityValue is String) {
                        quantity = double.tryParse(quantityValue);
                      } else if (quantityValue is num) {
                        quantity = quantityValue.toDouble();
                      }
                    }
                    
                    // Converter total_amount (pode vir como String ou double)
                    double? totalAmount;
                    final totalAmountValue = refueling['total_amount'];
                    if (totalAmountValue != null) {
                      if (totalAmountValue is String) {
                        totalAmount = double.tryParse(totalAmountValue);
                      } else if (totalAmountValue is num) {
                        totalAmount = totalAmountValue.toDouble();
                      }
                    }
                    
                    final createdAt = refueling['created_at'] as String?;
                    
                    // Os dados podem vir com vehicle/station como objetos ou apenas com os nomes
                    Map<String, dynamic>? vehicle;
                    Map<String, dynamic>? station;
                    String plate = 'N/A';
                    String stationName = 'N/A';
                    
                    // Tentar pegar vehicle como objeto
                    if (refueling['vehicle'] != null) {
                      vehicle = refueling['vehicle'] as Map<String, dynamic>?;
                      plate = vehicle?['plate'] as String? ?? 'N/A';
                    }
                    
                    // Se não tiver vehicle como objeto, tentar vehicle_plate direto
                    if (plate == 'N/A' && refueling['vehicle_plate'] != null) {
                      plate = refueling['vehicle_plate'] as String? ?? 'N/A';
                    }
                    
                    // Tentar pegar station como objeto
                    if (refueling['station'] != null) {
                      station = refueling['station'] as Map<String, dynamic>?;
                      stationName = station?['name'] as String? ?? 'N/A';
                    }
                    
                    // Se não tiver station como objeto, tentar station_name direto
                    if (stationName == 'N/A' && refueling['station_name'] != null) {
                      stationName = refueling['station_name'] as String? ?? 'N/A';
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: InkWell(
                        onTap: () => _navigateToValidation(refuelingId, refueling),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header com código e status
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.orange[800],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Pendente',
                                          style: TextStyle(
                                            color: Colors.orange[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    code,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Informações do abastecimento
                              _buildInfoRow(
                                Icons.directions_car,
                                'Veículo',
                                plate,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.local_gas_station,
                                'Posto',
                                stationName,
                              ),
                              const SizedBox(height: 8),
                              if (quantity != null)
                                _buildInfoRow(
                                  Icons.water_drop,
                                  'Quantidade',
                                  '${quantity.toStringAsFixed(2)} L',
                                ),
                              if (quantity != null) const SizedBox(height: 8),
                              if (totalAmount != null)
                                _buildInfoRow(
                                  Icons.attach_money,
                                  'Valor Total',
                                  _formatCurrency(totalAmount),
                                  isHighlight: true,
                                ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.calendar_today,
                                'Data/Hora',
                                _formatDate(createdAt),
                              ),
                              const SizedBox(height: 12),
                              
                              // Botão de ação
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _navigateToValidation(refuelingId, refueling),
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('Validar Agora'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                  color: isHighlight ? Colors.green[700] : null,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

