import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeca_app/core/services/pending_validation_storage.dart';
import 'package:zeca_app/shared/widgets/dialogs/error_dialog.dart';
import '../bloc/refueling_confirmation_bloc.dart';

/// Página de confirmação de pagamento para AUTÔNOMO
/// 
/// Aguarda confirmação do posto e exibe sucesso com economia
class AutonomousPaymentPage extends StatefulWidget {
  final String refuelingCode;
  final Map<String, dynamic>? vehicleData;
  final Map<String, dynamic>? stationData;

  const AutonomousPaymentPage({
    super.key,
    required this.refuelingCode,
    this.vehicleData,
    this.stationData,
  });

  @override
  State<AutonomousPaymentPage> createState() => _AutonomousPaymentPageState();
}

class _AutonomousPaymentPageState extends State<AutonomousPaymentPage> {
  late RefuelingConfirmationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RefuelingConfirmationBloc();
    
    // Iniciar escuta
    _bloc.add(StartListeningForConfirmation(
      refuelingCode: widget.refuelingCode,
      isAutonomous: true,
      vehicleData: widget.vehicleData,
      stationData: widget.stationData,
    ));
  }

  @override
  void dispose() {
    _bloc.add(const StopListening());
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<RefuelingConfirmationBloc, RefuelingConfirmationState>(
        listener: _handleStateChange,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_getTitle(state)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _onBackPressed(context),
              ),
            ),
            body: SafeArea(
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  String _getTitle(RefuelingConfirmationState state) {
    switch (state.status) {
      case ConfirmationStatus.waitingForStation:
        return 'Aguardando Pagamento';
      case ConfirmationStatus.completed:
        return 'Pagamento Confirmado';
      case ConfirmationStatus.cancelled:
        return 'Cancelado';
      case ConfirmationStatus.timeout:
        return 'Tempo Esgotado';
      case ConfirmationStatus.error:
        return 'Erro';
      default:
        return 'Confirmação';
    }
  }

  void _handleStateChange(BuildContext context, RefuelingConfirmationState state) {
    switch (state.status) {
      case ConfirmationStatus.cancelled:
        _showCancelledDialog(context, state.cancellationReason);
        break;
        
      case ConfirmationStatus.error:
        if (state.errorMessage != null) {
          ErrorDialog.show(
            context,
            title: 'Erro',
            message: state.errorMessage!,
          );
        }
        break;
        
      default:
        break;
    }
  }

  void _showCancelledDialog(BuildContext context, String? reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.cancel, color: Colors.red, size: 48),
        title: const Text('Abastecimento Cancelado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('O posto cancelou este abastecimento.'),
            if (reason != null && reason.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Motivo: $reason',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home');
            },
            child: const Text('Voltar ao Início'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, RefuelingConfirmationState state) {
    switch (state.status) {
      case ConfirmationStatus.initial:
      case ConfirmationStatus.connecting:
      case ConfirmationStatus.waitingForStation:
        return _buildWaitingState(state);
        
      case ConfirmationStatus.completed:
        return _buildSuccessState(context, state);
        
      case ConfirmationStatus.timeout:
        return _buildTimeoutState(context);
        
      case ConfirmationStatus.error:
        return _buildErrorState(context, state);
        
      default:
        return _buildWaitingState(state);
    }
  }

  Widget _buildWaitingState(RefuelingConfirmationState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
          const SizedBox(height: 32),
          Text(
            'Aguardando pagamento...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Realize o pagamento no caixa do posto',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.refuelingCode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Theme.of(context).primaryColor,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () => _bloc.add(const ForceCheckStatus()),
            icon: const Icon(Icons.refresh),
            label: const Text('Verificar Agora'),
          ),
          if (state.isPollingFallback) ...[
            const SizedBox(height: 16),
            Text(
              '(usando conexão alternativa)',
              style: TextStyle(color: Colors.orange[700], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, RefuelingConfirmationState state) {
    PendingValidationStorage.clearPendingValidation();
    
    final data = state.refuelingData ?? {};
    final savings = double.tryParse(data['savings']?.toString() ?? '0') ?? 0;
    final hasSavings = savings > 0;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header de sucesso
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pagamento Confirmado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          
          // Economia
          if (hasSavings)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade400, Colors.orange.shade500],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '🎉 Você economizou!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${_formatCurrency(savings)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (data['savings_per_liter'] != null)
                    Text(
                      'R\$ ${_formatCurrency(data['savings_per_liter'])} por litro',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                ],
              ),
            ),
          
          // Dados do abastecimento
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumo do Abastecimento',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    _buildDataRow('Litros', '${_formatNumber(data['quantity_liters'])} L'),
                    _buildDataRow('Preço Pago/L', 'R\$ ${_formatCurrency(data['unit_price'])}'),
                    if (hasSavings)
                      _buildDataRow(
                        'Preço Bomba/L', 
                        'R\$ ${_formatCurrency(data['pump_price'])}',
                        isStrikethrough: true,
                      ),
                    const Divider(),
                    _buildDataRow(
                      'Total Pago', 
                      'R\$ ${_formatCurrency(data['total_amount'])}',
                      isHighlighted: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDataRow('Veículo', data['vehicle_plate']?.toString() ?? '-'),
                    _buildDataRow('Posto', data['station_name']?.toString() ?? 
                        widget.stationData?['nome']?.toString() ?? '-'),
                    _buildDataRow('Combustível', data['fuel_type']?.toString() ?? '-'),
                  ],
                ),
              ),
            ),
          ),
          
          // Botão voltar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Voltar ao Início'),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isHighlighted = false, bool isStrikethrough = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              color: isHighlighted ? null : Colors.grey[600],
              fontWeight: isHighlighted ? FontWeight.bold : null,
            ),
          ),
          Text(
            value, 
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              fontSize: isHighlighted ? 18 : null,
              decoration: isStrikethrough ? TextDecoration.lineThrough : null,
              color: isStrikethrough ? Colors.grey : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    final num = double.tryParse(value.toString()) ?? 0;
    return num.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '0,00';
    final num = double.tryParse(value.toString()) ?? 0;
    return num.toStringAsFixed(2).replaceAll('.', ',');
  }

  Widget _buildTimeoutState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer_off, size: 64, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'Tempo Esgotado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Não recebemos confirmação do pagamento.\n\n'
              'Isso pode acontecer se:\n'
              '• O pagamento ainda não foi realizado\n'
              '• Houve problema de conexão',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Voltar ao Início'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _bloc.add(const RetryConnection()),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push('/pending-validations'),
              child: const Text('Ver Abastecimentos Pendentes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, RefuelingConfirmationState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Erro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Ocorreu um erro inesperado.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Voltar ao Início'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _bloc.add(const RetryConnection()),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onBackPressed(BuildContext context) {
    final state = _bloc.state;
    
    // Se já completou, deixa voltar direto
    if (state.status == ConfirmationStatus.completed) {
      context.go('/home');
      return;
    }
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text(
          'Tem certeza que deseja sair?\n\n'
          'Você pode verificar o status deste abastecimento depois.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
