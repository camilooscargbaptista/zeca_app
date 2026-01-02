import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/models/payment_confirmed_model.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/refueling_polling_service.dart';
import '../../../../core/services/websocket_service.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/storage_service.dart';

class AutonomousPaymentSuccessPage extends StatefulWidget {
  final PaymentConfirmedModel? data;
  final String? refuelingCode;
  
  const AutonomousPaymentSuccessPage({
    Key? key, 
    this.data,
    this.refuelingCode,
  }) : super(key: key);

  @override
  State<AutonomousPaymentSuccessPage> createState() => _AutonomousPaymentSuccessPageState();
}

class _AutonomousPaymentSuccessPageState extends State<AutonomousPaymentSuccessPage> {
  late PaymentConfirmedModel? _data;
  bool _isLoading = true;
  final RefuelingPollingService _pollingService = RefuelingPollingService();
  
  @override
  void initState() {
    super.initState();
    debugPrint('🚀 [AutonomousSuccess] initState. RefuelingCode: ${widget.refuelingCode}, Data: ${widget.data}');
    
    _data = widget.data;
    
    // Se já temos dados, não precisamos carregar
    if (_data != null) {
      debugPrint('✅ [AutonomousSuccess] Dados já disponíveis: ${_data!.status}');
      _isLoading = false;
    } else if (widget.refuelingCode != null) {
      // Se temos apenas o código, iniciar polling/websocket
      debugPrint('⏳ [AutonomousSuccess] Iniciando listeners...');
      _startListening();
    } else {
      // Estado inválido - nem dados nem código
      debugPrint('⚠️ [AutonomousSuccess] Estado inválido: Sem dados e sem código!');
      _isLoading = false;
    }
  }
  
  @override
  void dispose() {
    _pollingService.stopPolling();
    // Não desconectar WebSocket aqui pois pode ser usado globalmente,
    // mas o serviço gerencia seus listeners
    super.dispose();
  }
  
  void _startListening() {
    debugPrint('🚀 [AutonomousSuccess] Iniciando escuta para código: ${widget.refuelingCode}');
    
    // 0. Check imediato (Code)
    _pollingService.checkStatusByCodeOnce(widget.refuelingCode!).then((data) {
      if (data != null && (data['status'] == 'CONCLUIDO' || data['status'] == 'concluido')) {
         debugPrint('⚡️ [AutonomousSuccess] Status CONCLUIDO detectado na verificação inicial!');
         _processSuccessData(data);
         return; // Se já achou, não precisa iniciar o resto (mas o processSuccessData já para o polling se precisar)
      }
    });
    
    // 1. Garantir que WebSocket está conectado
    _ensureWebSocketConnected();
    
    // 2. Configurar listener
    WebSocketService().listenForAutonomousPaymentConfirmed((data) {
      debugPrint('💰 [AutonomousSuccess] WebSocket confirmou pagamento: $data');
      _processSuccessData(data);
    });
    
    // 3. Iniciar Polling como fallback
    _pollingService.startPollingForStatus(
      refuelingCode: widget.refuelingCode!,
      targetStatus: 'CONCLUIDO',
      intervalSeconds: 3, // Polling rápido
      onStatusReached: (data) {
        debugPrint('✅ [AutonomousSuccess] Polling confirmou status CONCLUIDO');
        _processSuccessData(data);
      },
    );
    
    // Forçar refresh visual
    if (mounted) setState(() {});
  }
  
  void _ensureWebSocketConnected() async {
    // Se já estiver conectado, não faz nada
    if (WebSocketService().isConnected) {
      debugPrint('✅ [AutonomousSuccess] WebSocket já conectado');
      return;
    }
    
    debugPrint('🔌 [AutonomousSuccess] WebSocket desconectado, tentando reconectar...');
    
    try {
      final storageService = GetIt.I<StorageService>();
      final token = await storageService.getAccessToken();
      
      if (token != null && token.isNotEmpty) {
        WebSocketService().connect(
          token: token,
          onAutonomousPaymentConfirmed: (data) {
             debugPrint('💰 [AutonomousSuccess] WebSocket (reconexão) confirmou pagamento: $data');
             _processSuccessData(data);
          },
          onConnected: () {
             debugPrint('✅ [AutonomousSuccess] WebSocket reconectado com sucesso!');
          },
        );
      } else {
        debugPrint('⚠️ [AutonomousSuccess] Token não disponível para reconexão WebSocket');
      }
    } catch (e) {
      debugPrint('❌ [AutonomousSuccess] Erro ao tentar conectar WebSocket: $e');
    }
  }

  void _processSuccessData(dynamic rawData) {
    if (!mounted) return;
    
    // Evitar processamento duplo
    if (_data != null) return;
    
    try {
      _pollingService.stopPolling();
      
      final payload = rawData['data'] ?? rawData;
      debugPrint('📦 [AutonomousSuccess] Payload recebido: $payload');
      
      // Helper para parse seguro
      double parseDouble(dynamic value) {
        if (value == null) return 0.0;
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
      }

      // Helper para fuel type - Lidar com string, objeto, ou JSON stringificado
      String parseFuelType(dynamic value) {
        if (value == null) return 'Combustível';
        
        // Se for um mapa (objeto)
        if (value is Map) {
            return value['name']?.toString() ?? 
                   value['nome']?.toString() ?? 
                   value['code']?.toString() ?? 
                   value['description']?.toString() ?? 
                   'Combustível';
        }
        
        // Se for string
        if (value is String) {
          // Verificar se parece um JSON stringificado (começa com {)
          final trimmed = value.trim();
          if (trimmed.startsWith('{')) {
            try {
              // Tentar parsear como JSON
              final decoded = Map<String, dynamic>.from(
                  (const JsonDecoder()).convert(trimmed)
              );
              return decoded['name']?.toString() ?? 
                     decoded['nome']?.toString() ?? 
                     decoded['code']?.toString() ?? 
                     'Combustível';
            } catch (e) {
              // Se falhar o parse, retornar a string como está (limpando o {)
              debugPrint('⚠️ [parseFuelType] Falha ao parsear JSON: $e');
            }
          }
          
          // Se não for JSON, retornar a string diretamente
          // Mas limpar se parecer um objeto truncado
          if (!trimmed.startsWith('{')) {
            return trimmed;
          }
        }
        
        return 'Combustível';
      }

      // Helper para nome do posto
      String parseStationName(dynamic payload) {
        // Tentar direto
        if (payload['station_name'] != null) return payload['station_name'].toString();
        
        // Tentar objeto station
        if (payload['station'] is Map) {
          final station = payload['station'];
          return station['trade_name'] ?? station['fantasy_name'] ?? station['name'] ?? 'Posto Parceiro';
        }
        
        return 'Posto Parceiro';
      }
      
      // Log detalhado dos campos de economia
      debugPrint('💰 [AutonomousSuccess] Dados de economia do payload:');
      debugPrint('   pump_price: ${payload['pump_price']}');
      debugPrint('   savings: ${payload['savings']}');
      debugPrint('   unit_price: ${payload['unit_price']}');
      debugPrint('   quantity_liters: ${payload['quantity_liters']}');
      
      final model = PaymentConfirmedModel(
        refuelingCode: widget.refuelingCode ?? '',
        status: payload['status']?.toString() ?? 'CONCLUIDO',
        totalValue: parseDouble(payload['total_amount']),
        quantityLiters: parseDouble(payload['quantity_liters']),
        pricePerLiter: parseDouble(payload['unit_price']),
        pumpPrice: parseDouble(payload['pump_price']),
        savings: parseDouble(payload['savings']),
        stationName: parseStationName(payload),
        vehiclePlate: payload['vehicle_plate']?.toString() ?? '',
        fuelType: parseFuelType(payload['fuel_type']),
        timestamp: DateTime.now().toIso8601String(),
      );
      
      debugPrint('💰 [AutonomousSuccess] Model criado: pumpPrice=${model.pumpPrice}, savings=${model.savings}');
      
      setState(() {
        _data = model;
        _isLoading = false;
      });
      
    } catch (e) {
      debugPrint('❌ [AutonomousSuccess] Erro ao processar dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_isLoading ? 'Processando Pagamento' : 'Abastecimento Concluído'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Bloquear volta durante processamento
      ),
      body: SafeArea(
        child: _isLoading ? _buildLoadingState() : _buildSuccessState(),
      ),
    );
  }
  
  Widget _buildLoadingState() {
     // ... (mantido igual)
     return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 32),
          Text(
            'Confirmando abastecimento...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // ... resto do loading state
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Aguarde enquanto o posto finaliza o registro. Isso deve levar apenas alguns instantes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          if (widget.refuelingCode != null) ...[
             const SizedBox(height: 24),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                 color: Colors.grey[200],
                 borderRadius: BorderRadius.circular(8),
               ),
               child: SelectableText( // Permitir copiar
                 'Código: ${widget.refuelingCode}',
                 style: const TextStyle(fontWeight: FontWeight.bold),
               ),
             ),
             
             const SizedBox(height: 32),
             TextButton.icon(
               onPressed: () {
                 debugPrint('👆 [AutonomousSuccess] Verificação manual solicitada');
                 // USAR checkStatusByCodeOnce (o código é alfanumérico, checkStatusOnce espera UUID)
                 _pollingService.checkStatusByCodeOnce(widget.refuelingCode!).then((data) {
                   if (data != null && (data['status'] == 'CONCLUIDO' || data['status'] == 'concluido')) {
                      _processSuccessData(data);
                   } else {
                     if (mounted) {
                       final status = data?['status'] ?? 'Não encontrado';
                       final msg = status == 'VALIDADO' 
                           ? 'Abastecimento validado! Aguardando finalização pelo frentista.' 
                           : 'Status atual: $status';
                           
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text(msg),
                           backgroundColor: status == 'VALIDADO' ? Colors.orange : null,
                         ),
                       );
                     }
                   }
                 });
               },
               icon: const Icon(Icons.refresh),
               label: const Text('Verificar Agora'),
             ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    if (_data == null) {
       return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Erro ao carregar dados'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _goToHome(context),
              child: const Text('Voltar para Início'),
            ),
          ],
        ),
      );
    }
    
    // Calcular economia se não vier preenchida mas tivermos os preços
    double calculatedSavings = _data!.savings;
    if (calculatedSavings <= 0 && _data!.pumpPrice > 0) {
      calculatedSavings = (_data!.pumpPrice * _data!.quantityLiters) - _data!.totalValue;
    }
    
    // Garantir que não mostre economia negativa ou zero irrelevante (erro de arredondamento)
    if (calculatedSavings < 0.01) calculatedSavings = 0;

    final bool hasSavings = calculatedSavings > 0;
                           
    debugPrint('💰 [AutonomousSuccess] Check Savings: savingsField=${_data!.savings}, calculated=$calculatedSavings, pumpPrice=${_data!.pumpPrice} -> HasSavings: $hasSavings');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Pagamento Confirmado!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Obrigado por usar o ZECA!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Mostrar Card de Economia OU Card de Total Pago
                if (hasSavings)
                  _buildSavingsCard(calculatedSavings)
                else
                  _buildTotalPaidCard(),
                
                const SizedBox(height: 16),
                
                // Card de detalhes
                _buildDetailsCard(hasSavings, calculatedSavings),
              ],
            ),
          ),
        ),
        
        // Botão voltar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _goToHome(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'VOLTAR PARA INÍCIO',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void _goToHome(BuildContext context) {
    _pollingService.stopPolling();
    context.go('/home'); 
  }

  Widget _buildSavingsCard(double savingsAmount) {
    // Calcular o que pagaria na bomba para mostrar comparativo
    final double totalAtPump = _data!.totalValue + savingsAmount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          // Seção de Economia (destaque verde)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const Text(
                  '🎉 Você economizou:',
                  style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${savingsAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
          
          // Seção de Comparativo
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                 _comparativeRow('Total Pago:', _data!.totalValue, Colors.blue),
                 const SizedBox(height: 8),
                 _comparativeRow('Pagaria na bomba:', totalAtPump, Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _comparativeRow(String label, double value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
        ),
        Text(
          'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }

  Widget _buildTotalPaidCard() {
    return Card(
      color: Colors.blue.shade50,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Total Pago:',
              style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${_data!.totalValue.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailsCard(bool showSavings, double savingsAmount) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            if (showSavings) ...[
                _detailRow('Preço ZECA:', 'R\$ ${_data!.pricePerLiter.toStringAsFixed(2).replaceAll('.', ',')}/L'),
                if (_data!.pumpPrice > 0)
                  _detailRow('Preço Bomba:', 'R\$ ${_data!.pumpPrice.toStringAsFixed(2).replaceAll('.', ',')}/L'),
            ] else ...[
                 _detailRow('Preço por litro:', 'R\$ ${_data!.pricePerLiter.toStringAsFixed(2).replaceAll('.', ',')}/L'),
            ],

            _detailRow('Litros:', '${_data!.quantityLiters.toStringAsFixed(2).replaceAll('.', ',')} L'),
            _detailRow('Posto:', _data!.stationName),
            _detailRow('Veículo:', _data!.vehiclePlate),
             
             // Fuel Type com parsing corrigido no _processSuccessData
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Combustível:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Flexible(
                    child: Text(
                        _data!.fuelType, 
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
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
  
  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
              value, 
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500, 
                  fontSize: isBold ? 16 : 14,
                  color: isBold ? Colors.black87 : null
              ),
          ),
        ],
      ),
    );
  }
}
