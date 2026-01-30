import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/refueling_polling_service.dart';
import '../../../../core/services/pending_validation_storage.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';

/// Tela exibida quando o código foi VALIDADO pelo posto.
/// Motorista está liberado para abastecer e pode registrar os dados.
class RefuelingValidatedPage extends StatefulWidget {
  final String refuelingId;
  final String refuelingCode;
  final Map<String, dynamic>? vehicleData;
  final Map<String, dynamic>? stationData;
  
  const RefuelingValidatedPage({
    Key? key,
    required this.refuelingId,
    required this.refuelingCode,
    this.vehicleData,
    this.stationData,
  }) : super(key: key);

  @override
  State<RefuelingValidatedPage> createState() => _RefuelingValidatedPageState();
}

class _RefuelingValidatedPageState extends State<RefuelingValidatedPage> {
  final _formKey = GlobalKey<FormState>();
  final _litrosController = TextEditingController();
  final _precoLitroController = TextEditingController();
  final _valorTotalController = TextEditingController();
  
  final RefuelingPollingService _pollingService = RefuelingPollingService();
  final ApiService _apiService = ApiService();
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Iniciar polling para detectar se posto registra os dados
    _startMonitoringPolling();
    
    // Auto-calcular valor total quando litros ou preço mudam
    _litrosController.addListener(_calcularValorTotal);
    _precoLitroController.addListener(_calcularValorTotal);
  }

  @override
  void dispose() {
    // NOTA: NÃO chamar _pollingService.stopPolling() aqui!
    // O polling é gerenciado por _finalizarEIrAoCaixa() e a próxima tela
    // Se pararmos aqui, vamos interferir no polling da RefuelingWaitingPage
    _litrosController.dispose();
    _precoLitroController.dispose();
    _valorTotalController.dispose();
    super.dispose();
  }

  /// Calcula valor total automaticamente
  void _calcularValorTotal() {
    // Converte formato brasileiro (vírgula) para ponto decimal
    final litros = double.tryParse(_litrosController.text.replaceAll(',', '.')) ?? 0;
    final preco = double.tryParse(_precoLitroController.text.replaceAll(',', '.')) ?? 0;
    
    if (litros > 0 && preco > 0) {
      final total = litros * preco;
      // Formata de volta para padrão brasileiro (vírgula)
      _valorTotalController.text = total.toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  /// Polling para detectar mudanças de status
  void _startMonitoringPolling() {
    debugPrint('🔄 [VALIDATED] Iniciando polling de monitoramento...');
    
    _pollingService.startPolling(
      refuelingId: widget.refuelingId.isNotEmpty ? widget.refuelingId : null,
      refuelingCode: widget.refuelingCode,
      intervalSeconds: 3, // Polling rápido para detectar validação do posto
      onStatusWithData: (status, id, data) async {
        debugPrint('🔔 [VALIDATED] Status detectado: $status');
        
        if (!mounted) return;
        
        // Quando posto registra dados
        if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
          debugPrint('📋 [VALIDATED] Posto registrou dados! Navegando para validação...');
          _pollingService.stopPolling();
          await PendingValidationStorage.clearPendingValidation();
          
          context.go('/refueling-waiting', extra: {
            'refueling_id': id ?? widget.refuelingId,
            'refueling_code': widget.refuelingCode,
            'vehicle_data': widget.vehicleData,
            'station_data': widget.stationData,
          });
          return;
        }
        
        // Posto validou/concluiu diretamente
        if (status == 'CONCLUIDO') {
          debugPrint('✅ [VALIDATED] Abastecimento concluído!');
          _pollingService.stopPolling();
          await PendingValidationStorage.clearPendingValidation();
          _showSuccessAndGoHome('Abastecimento concluído com sucesso!');
          return;
        }
        
        // Cancelado
        if (status == 'CANCELADO') {
          debugPrint('❌ [VALIDATED] Abastecimento cancelado');
          _pollingService.stopPolling();
          await PendingValidationStorage.clearPendingValidation();
          _showErrorAndGoHome('Abastecimento foi cancelado pelo posto.');
          return;
        }
      },
    );
  }

  void _showSuccessAndGoHome(String message) {
    SuccessDialog.show(
      context,
      title: 'Sucesso!',
      message: message,
      onPressed: () {
        Navigator.of(context).pop();
        context.go('/home');
      },
    );
  }

  void _showErrorAndGoHome(String message) {
    ErrorDialog.show(
      context,
      title: 'Aviso',
      message: message,
      onPressed: () {
        Navigator.of(context).pop();
        context.go('/home');
      },
    );
  }

  /// Finalizar e ir ao caixa (salvar dados se preenchidos)
  Future<void> _finalizarEIrAoCaixa() async {
    // Validar que os 3 campos foram preenchidos
    if (_litrosController.text.isEmpty || 
        _precoLitroController.text.isEmpty || 
        _valorTotalController.text.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'Campos Obrigatórios',
        message: 'Preencha todos os campos: Litros, Preço/Litro e Valor Total.',
        onPressed: () => Navigator.of(context).pop(),
      );
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      // Converte formato brasileiro (vírgula) para ponto decimal
      final litros = double.tryParse(_litrosController.text.replaceAll(',', '.')) ?? 0;
      final preco = double.tryParse(_precoLitroController.text.replaceAll(',', '.')) ?? 0;
      final total = double.tryParse(_valorTotalController.text.replaceAll(',', '.')) ?? 0;
      
      // Validar valores numéricos
      if (litros <= 0 || preco <= 0 || total <= 0) {
        ErrorDialog.show(
          context,
          title: 'Valores Inválidos',
          message: 'Os valores devem ser maiores que zero.',
          onPressed: () => Navigator.of(context).pop(),
        );
        setState(() => _isSubmitting = false);
        return;
      }
      
      debugPrint('📊 [VALIDATED] Dados registrados pelo motorista:');
      debugPrint('   Litros: $litros');
      debugPrint('   Preço/L: $preco');
      debugPrint('   Total: $total');
      
      // Enviar ao backend para histórico/analytics
      try {
        await _apiService.saveDriverRefuelingEstimate(
          code: widget.refuelingCode,
          estimatedLiters: litros,
          estimatedPrice: preco,
          estimatedTotal: total,
        );
        debugPrint('✅ [VALIDATED] Estimativa salva no backend');
      } catch (e) {
        debugPrint('⚠️ [VALIDATED] Erro ao salvar estimativa (não crítico): $e');
        // Continuar mesmo se falhar o salvamento da estimativa
      }
      
      // Manter o estado pendente (não limpar ainda)
      _pollingService.stopPolling();
      
      // Navegar para tela de espera com os dados digitados pelo motorista
      if (mounted) {
        context.go('/refueling-waiting', extra: {
          'refueling_id': widget.refuelingId,
          'refueling_code': widget.refuelingCode,
          'vehicle_data': widget.vehicleData,
          'station_data': widget.stationData,
          // Dados digitados pelo motorista para mostrar na tela
          'driver_estimate': {
            'liters': litros,
            'price': preco,
            'total': total,
          },
        });
      }
    } catch (e) {
      debugPrint('❌ Erro ao finalizar: $e');
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Não foi possível salvar os dados. Tente novamente.',
          onPressed: () => Navigator.of(context).pop(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// Pular registro e ir ao caixa
  void _pularEIrAoCaixa() {
    _pollingService.stopPolling();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liberado para Abastecer'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success Section (compacto)
                _buildSuccessSection(),
                
                const SizedBox(height: 12),
                
                // Info Card (compacto)
                _buildInfoCard(),
                
                const SizedBox(height: 16),
                
                // Form Section
                _buildFormSection(),
                
                const SizedBox(height: 16),
                
                // Submit Button
                _buildSubmitButton(),
                
                const SizedBox(height: 8),
                
                // Hint
                Center(
                  child: Text(
                    'Informe esses dados no caixa do posto',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Skip Link
                _buildSkipLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          // Ícone de sucesso
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Código Validado!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Você está liberado. Registre os dados após abastecer.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final vehiclePlate = widget.vehicleData?['placa'] ?? 
                         widget.vehicleData?['plate'] ?? 
                         widget.vehicleData?['license_plate'] ?? 
                         '---';
    final stationName = widget.stationData?['name'] ?? 
                        widget.stationData?['company_name'] ?? 
                        widget.stationData?['nome'] ??
                        'Posto ZECA';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildInfoRow('🚗', 'Veículo', vehiclePlate),
          Divider(height: 16, color: Colors.grey[300]),
          _buildInfoRow('⛽', 'Posto', stationName),
          Divider(height: 16, color: Colors.grey[300]),
          _buildInfoRow('🔢', 'Código', widget.refuelingCode, isCode: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String icon, String label, String value, {bool isCode = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$icon $label',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isCode ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            fontFamily: isCode ? 'monospace' : null,
            letterSpacing: isCode ? 0.5 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('⛽', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            const Text(
              'Dados do Abastecimento',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Grid 2 colunas
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'LITROS',
                controller: _litrosController,
                hint: '150,50',
                suffix: 'L',
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'pt_BR',
                    decimalDigits: 2,
                    symbol: '',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildInputField(
                label: 'PREÇO/LITRO (R\$)',
                controller: _precoLitroController,
                hint: '5,89',
                prefix: 'R\$ ',
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'pt_BR',
                    decimalDigits: 2,
                    symbol: '',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Valor total
        _buildInputField(
          label: 'VALOR TOTAL (R\$)',
          controller: _valorTotalController,
          hint: '886,35',
          prefix: 'R\$ ',
          inputFormatters: [
            CurrencyTextInputFormatter.currency(
              locale: 'pt_BR',
              decimalDigits: 2,
              symbol: '',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? prefix,
    String? suffix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 14),
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixText: prefix,
            suffixText: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _finalizarEIrAoCaixa,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
      ),
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Finalizar e Ir ao Caixa',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildSkipLink() {
    return TextButton(
      onPressed: _pularEIrAoCaixa,
      child: const Text(
        'Pular registro e ir ao caixa →',
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF2196F3),
        ),
      ),
    );
  }
}
