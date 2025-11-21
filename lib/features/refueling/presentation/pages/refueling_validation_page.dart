import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/api_service.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';

class RefuelingValidationPage extends StatefulWidget {
  final String refuelingId;
  
  const RefuelingValidationPage({
    Key? key,
    required this.refuelingId,
  }) : super(key: key);

  @override
  State<RefuelingValidationPage> createState() => _RefuelingValidationPageState();
}

class _RefuelingValidationPageState extends State<RefuelingValidationPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _validationData;
  Map<String, dynamic>? _refuelingData;
  
  // Controllers para edição (se contestar)
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  bool _isContesting = false;

  @override
  void initState() {
    super.initState();
    _loadValidationData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _kmController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadValidationData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Tentar usar endpoint específico primeiro, depois fallback para status
      final response = await _apiService.getPendingValidation(widget.refuelingId);
      
      if (response['success'] == true) {
        if (response['data'] != null) {
          final data = response['data'] as Map<String, dynamic>;
          
          setState(() {
            _validationData = data;
            _refuelingData = data;
            
            // Preencher controllers com dados registrados
            if (data['quantity_liters'] != null) {
              _quantityController.text = data['quantity_liters'].toString();
            }
            if (data['odometer_reading'] != null) {
              _kmController.text = data['odometer_reading'].toString();
            }
            
            _isLoading = false;
          });
        } else {
          // Sem dados pendentes
          setState(() {
            _isLoading = false;
          });
          
          if (mounted) {
            ErrorDialog.show(
              context,
              title: 'Sem Validação Pendente',
              message: 'Não há dados pendentes de validação para este abastecimento.',
            );
            
            // Voltar após 2 segundos
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go('/home');
              }
            });
          }
        }
      } else {
        throw Exception(response['error'] ?? 'Erro ao carregar dados de validação');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao carregar dados: $e',
        );
      }
    }
  }

  Future<void> _confirmValidation() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _apiService.validateRefueling(
        refuelingId: widget.refuelingId,
        action: 'confirmar',
      );
      
      if (response['success'] == true) {
        if (mounted) {
          SuccessDialog.show(
            context,
            title: 'Validação Confirmada',
            message: 'Dados do abastecimento confirmados com sucesso!',
          );
          
          // Voltar para home após 2 segundos
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go('/home');
            }
          });
        }
      } else {
        throw Exception(response['error'] ?? 'Erro ao confirmar validação');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao confirmar validação: $e',
        );
      }
    }
  }

  Future<void> _contestValidation() async {
    if (_quantityController.text.isEmpty || _kmController.text.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'Dados Incompletos',
        message: 'Por favor, preencha todos os campos corrigidos.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final correctedData = {
        'quantidade_litros': double.tryParse(_quantityController.text) ?? 0.0,
        'km_final': int.tryParse(_kmController.text) ?? 0,
        if (_notesController.text.isNotEmpty) 'observacoes': _notesController.text,
      };

      final response = await _apiService.validateRefueling(
        refuelingId: widget.refuelingId,
        action: 'contestar',
        correctedData: correctedData,
      );
      
      if (response['success'] == true) {
        if (mounted) {
          SuccessDialog.show(
            context,
            title: 'Contestação Enviada',
            message: 'Sua contestação foi registrada e será analisada.',
          );
          
          // Voltar para home após 2 segundos
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go('/home');
            }
          });
        }
      } else {
        throw Exception(response['error'] ?? 'Erro ao enviar contestação');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao enviar contestação: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validação de Abastecimento'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _validationData == null
              ? const Center(child: Text('Sem dados para validar'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card de Informações
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dados Registrados pelo Posto',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow('Veículo', _refuelingData?['vehicle_plate'] ?? 'N/A'),
                                _buildInfoRow('Posto', _refuelingData?['station']?['nome'] ?? 'N/A'),
                                _buildInfoRow('Combustível', _refuelingData?['fuel_type'] ?? 'N/A'),
                                _buildInfoRow('Quantidade (L)', _refuelingData?['quantity_liters']?.toString() ?? 'N/A'),
                                _buildInfoRow('Valor Total', _refuelingData?['total_amount'] != null 
                                    ? 'R\$ ${_refuelingData!['total_amount'].toStringAsFixed(2)}'
                                    : 'N/A'),
                                _buildInfoRow('KM do Odômetro', _refuelingData?['odometer_reading']?.toString() ?? 'N/A'),
                                if (_refuelingData?['pump_number'] != null)
                                  _buildInfoRow('Bomba', _refuelingData!['pump_number']),
                                if (_refuelingData?['attendant_name'] != null)
                                  _buildInfoRow('Atendente', _refuelingData!['attendant_name']),
                                if (_refuelingData?['notes'] != null && _refuelingData!['notes'].toString().isNotEmpty)
                                  _buildInfoRow('Observações', _refuelingData!['notes']),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Toggle para contestar
                        Card(
                          child: SwitchListTile(
                            title: const Text('Contestar Dados'),
                            subtitle: const Text('Marque se os dados estão incorretos'),
                            value: _isContesting,
                            onChanged: (value) {
                              setState(() {
                                _isContesting = value;
                              });
                            },
                          ),
                        ),
                        
                        // Campos de correção (se contestar)
                        if (_isContesting) ...[
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dados Corrigidos',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _quantityController,
                                    decoration: const InputDecoration(
                                      labelText: 'Quantidade (Litros)',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.local_gas_station),
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _kmController,
                                    decoration: const InputDecoration(
                                      labelText: 'KM do Odômetro',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.speed),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _notesController,
                                    decoration: const InputDecoration(
                                      labelText: 'Observações (Opcional)',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.note),
                                    ),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Botões de ação
                        if (!_isContesting)
                          CustomButton(
                            text: 'Confirmar Dados',
                            onPressed: _isSubmitting ? null : _confirmValidation,
                            isFullWidth: true,
                            icon: Icons.check_circle,
                          )
                        else
                          CustomButton(
                            text: 'Enviar Contestação',
                            onPressed: _isSubmitting ? null : _contestValidation,
                            isFullWidth: true,
                            icon: Icons.report_problem,
                            backgroundColor: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

