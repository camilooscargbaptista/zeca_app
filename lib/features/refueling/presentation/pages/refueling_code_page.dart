import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/common/custom_toast.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../bloc/refueling_code_bloc.dart';

class RefuelingCodePage extends StatefulWidget {
  const RefuelingCodePage({Key? key}) : super(key: key);
  
  @override
  State<RefuelingCodePage> createState() => _RefuelingCodePageState();
}

class _RefuelingCodePageState extends State<RefuelingCodePage> {
  @override
  void initState() {
    super.initState();
    // TODO: Carregar dados do código de abastecimento
    // context.read<RefuelingCodeBloc>().add(LoadRefuelingCode());
  }
  
  void _onCancelCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Código'),
        content: const Text('Tem certeza que deseja cancelar este código de abastecimento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar cancelamento
              CustomToast.showInfo(context, 'Código cancelado');
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }
  
  void _onFinalizeRefueling() {
    // TODO: Implementar finalização do abastecimento
    CustomToast.showInfo(context, 'Funcionalidade em desenvolvimento');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Código de Abastecimento'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<RefuelingCodeBloc>(),
        child: BlocConsumer<RefuelingCodeBloc, RefuelingCodeState>(
          listener: (context, state) {
            if (state is RefuelingCodeError) {
              CustomToast.showError(context, state.message);
            } else if (state is RefuelingCodeGenerated) {
              CustomToast.showSuccess(context, 'Código carregado com sucesso!');
            }
          },
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is RefuelingCodeLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Status Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  color: FlavorConfig.instance.primaryColor,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status do Código',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      Text(
                                        'Ativo - Válido por 2 horas',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // QR Code Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Código QR para o Posto',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            
                            // QR Code Placeholder
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.qr_code,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'QR Code',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Code Text
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ABC1-DEF2-GHI3',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontFamily: 'monospace',
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Vehicle Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informações do Veículo',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Placa', 'ABC1234'),
                            _buildInfoRow('Modelo', 'Volvo FH 540'),
                            _buildInfoRow('Marca', 'Volvo'),
                            _buildInfoRow('KM Atual', '150.500'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Station Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informações do Posto',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Nome', 'Shell Express'),
                            _buildInfoRow('CNPJ', '12.345.678/0001-99'),
                            _buildInfoRow('Endereço', 'Av. Paulista, 1000 - São Paulo/SP'),
                            _buildInfoRow('Combustível', 'Diesel'),
                            _buildInfoRow('Preço/Litro', 'R\$ 4,50'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Cancelar',
                            type: ButtonType.secondary,
                            onPressed: _onCancelCode,
                            icon: Icons.cancel,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Finalizar',
                            type: ButtonType.success,
                            onPressed: _onFinalizeRefueling,
                            icon: Icons.check,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Instructions
                    Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Instruções',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '1. Mostre o QR Code para o atendente do posto\n'
                              '2. Confirme os dados do abastecimento\n'
                              '3. Após o abastecimento, finalize o processo\n'
                              '4. Faça upload dos comprovantes',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
