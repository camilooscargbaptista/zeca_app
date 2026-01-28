import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeca_app/core/services/location_service.dart';
import 'package:zeca_app/core/services/pending_validation_storage.dart';
import 'package:zeca_app/shared/widgets/dialogs/error_dialog.dart';
import 'package:zeca_app/shared/widgets/dialogs/success_dialog.dart';
import '../bloc/refueling_confirmation_bloc.dart';

/// Página de confirmação de abastecimento para FROTA
/// 
/// Recebe dados do posto e permite o motorista validar ou rejeitar
class FleetConfirmationPage extends StatefulWidget {
  final String refuelingCode;
  final Map<String, dynamic>? vehicleData;
  final Map<String, dynamic>? stationData;

  const FleetConfirmationPage({
    super.key,
    required this.refuelingCode,
    this.vehicleData,
    this.stationData,
  });

  @override
  State<FleetConfirmationPage> createState() => _FleetConfirmationPageState();
}

class _FleetConfirmationPageState extends State<FleetConfirmationPage> {
  final LocationService _locationService = LocationService();
  late RefuelingConfirmationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RefuelingConfirmationBloc();
    
    // Iniciar escuta
    _bloc.add(StartListeningForConfirmation(
      refuelingCode: widget.refuelingCode,
      isAutonomous: false,
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
        return 'Aguardando Posto';
      case ConfirmationStatus.dataReceived:
        return 'Confirmar Dados';
      case ConfirmationStatus.validating:
        return 'Validando...';
      case ConfirmationStatus.completed:
        return 'Concluído';
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
      case ConfirmationStatus.completed:
        PendingValidationStorage.clearPendingValidation();
        SuccessDialog.show(
          context,
          title: 'Validação Confirmada',
          message: 'Dados do abastecimento confirmados com sucesso!',
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/home');
          },
        );
        break;
        
      case ConfirmationStatus.rejected:
        PendingValidationStorage.clearPendingValidation();
        SuccessDialog.show(
          context,
          title: 'Abastecimento Rejeitado',
          message: 'O abastecimento foi rejeitado.',
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/home');
          },
        );
        break;
        
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
        
      case ConfirmationStatus.dataReceived:
        return _buildDataReceivedState(context, state);
        
      case ConfirmationStatus.validating:
        return _buildValidatingState();
        
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
          const CircularProgressIndicator(),
          const SizedBox(height: 32),
          Text(
            'Aguardando posto registrar...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Código: ${widget.refuelingCode}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

  Widget _buildDataReceivedState(BuildContext context, RefuelingConfirmationState state) {
    final data = state.refuelingData ?? {};
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Confira os dados registrados pelo posto e confirme ou rejeite.',
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                _buildDataCard(data),
              ],
            ),
          ),
        ),
        
        // Botões de ação
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showRejectConfirmation(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('REJEITAR'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _confirmValidation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('CONFIRMAR'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataCard(Map<String, dynamic> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dados do Abastecimento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildDataRow('Litros', '${_formatNumber(data['quantity_liters'])} L'),
            _buildDataRow('Valor Total', 'R\$ ${_formatCurrency(data['total_amount'])}'),
            _buildDataRow('Preço/L', 'R\$ ${_formatCurrency(data['unit_price'])}'),
            if (data['odometer_reading'] != null)
              _buildDataRow('Km', _formatNumber(data['odometer_reading'])),
            _buildDataRow('Veículo', data['vehicle_plate']?.toString() ?? '-'),
            _buildDataRow('Posto', data['station_name']?.toString() ?? 
                widget.stationData?['nome']?.toString() ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
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

  Widget _buildValidatingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text('Processando...'),
        ],
      ),
    );
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
              'Não recebemos confirmação do posto.\n\n'
              'Isso pode acontecer se:\n'
              '• O posto ainda não registrou\n'
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

  void _showRejectConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Rejeição'),
        content: const Text(
          'Tem certeza que deseja rejeitar os dados registrados pelo posto?\n\n'
          'Você precisará informar os valores corretos para contestação.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _rejectValidation(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rejeitar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmValidation(BuildContext context) async {
    final refuelingId = _bloc.state.refuelingId;
    if (refuelingId == null) {
      ErrorDialog.show(context, title: 'Erro', message: 'ID do abastecimento não encontrado');
      return;
    }

    // Obter localização
    final locationData = await _getLocationWithPermission(context);
    if (locationData == null) return;

    _bloc.add(ConfirmValidation(
      refuelingId: refuelingId,
      latitude: locationData['latitude'] as double,
      longitude: locationData['longitude'] as double,
      address: locationData['address'] as String?,
      device: _locationService.getDeviceName(),
    ));
  }

  Future<void> _rejectValidation(BuildContext context) async {
    final refuelingId = _bloc.state.refuelingId;
    if (refuelingId == null) {
      ErrorDialog.show(context, title: 'Erro', message: 'ID do abastecimento não encontrado');
      return;
    }

    // Obter localização
    final locationData = await _getLocationWithPermission(context);
    if (locationData == null) return;

    _bloc.add(RejectValidation(
      refuelingId: refuelingId,
      latitude: locationData['latitude'] as double,
      longitude: locationData['longitude'] as double,
      address: locationData['address'] as String?,
      device: _locationService.getDeviceName(),
    ));
  }

  Future<Map<String, dynamic>?> _getLocationWithPermission(BuildContext context) async {
    bool hasPermission = await _locationService.checkPermission();
    if (!hasPermission) {
      hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Permissão Necessária',
            message: 'É necessário permitir o acesso à localização.',
          );
        }
        return null;
      }
    }

    final locationData = await _locationService.getCurrentLocation();
    if (locationData == null && mounted) {
      ErrorDialog.show(
        context,
        title: 'Erro de Localização',
        message: 'Não foi possível obter a localização atual.',
      );
    }
    return locationData;
  }

  void _onBackPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da Validação'),
        content: const Text(
          'Tem certeza que deseja sair?\n\n'
          'Você poderá retornar através da tela de abastecimentos pendentes.',
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
