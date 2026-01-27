import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../core/di/injection.dart';
import '../bloc/checklist_bloc.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({Key? key}) : super(key: key);

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late final ChecklistBloc _bloc;
  String? _executionId;

  @override
  void initState() {
    super.initState();
    _bloc = ChecklistBloc();
    _loadVehicleAndChecklist();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  /// Carregar dados do veículo e buscar checklist
  Future<void> _loadVehicleAndChecklist() async {
    _bloc.add(const ChecklistEvent.loadData());
    
    try {
      final storageService = getIt<StorageService>();
      final vehicleData = await storageService.getJourneyVehicleData();
      
      if (vehicleData == null || vehicleData.isEmpty) {
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro',
            message: 'Nenhum veículo selecionado. Selecione um veículo primeiro.',
          );
          context.go('/journey-start');
        }
        return;
      }
      
      _bloc.add(ChecklistEvent.vehicleLoaded(vehicleData));
      await _fetchChecklist(vehicleData);
      
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Erro ao carregar dados: $e');
      }
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao carregar dados do checklist: $e',
        );
      }
      _bloc.add(ChecklistEvent.loadFailed('Erro ao carregar: $e'));
    }
  }

  /// Buscar checklist pela placa
  Future<void> _fetchChecklist(Map<String, dynamic> vehicleData) async {
    try {
      final apiService = ApiService();
      final plate = vehicleData['placa'];
      final cleanPlate = plate?.toString().replaceAll('-', '').replaceAll(' ', '').toUpperCase() ?? '';
      
      if (kDebugMode) {
        print('🔍 Buscando checklist para placa: $cleanPlate');
      }
      
      var response = await apiService.getChecklistByPlate(
        plate: cleanPlate,
        executionType: 'pre_trip',
      );
      
      if (response['success'] == true) {
        final data = response['data'];
        List<dynamic> checklists = [];
        if (data is Map<String, dynamic>) {
          checklists = data['checklists'] as List<dynamic>? ?? [];
        } else if (data is List) {
          checklists = data;
        }
        
        if (checklists.isEmpty) {
          response = await apiService.getChecklistByPlate(
            plate: cleanPlate,
            executionType: null,
          );
        }
      }
      
      if (response['success'] == true) {
        final data = response['data'];
        Map<String, dynamic> checklistData;
        
        if (data is Map<String, dynamic>) {
          checklistData = data;
        } else if (data is List) {
          checklistData = {
            'vehicle': vehicleData,
            'checklists': data,
          };
        } else {
          checklistData = {
            'vehicle': vehicleData,
            'checklists': [],
          };
        }
        
        _bloc.add(ChecklistEvent.checklistLoaded(checklistData));
      } else {
        _bloc.add(ChecklistEvent.checklistLoaded({
          'vehicle': vehicleData,
          'checklists': [],
        }));
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao buscar checklist: $e');
      }
      _bloc.add(ChecklistEvent.loadFailed('Erro ao buscar checklist: $e'));
    }
  }

  /// Responder um item
  void _answerItem({
    required String itemId,
    required String value,
    bool isConforming = true,
    String? notes,
  }) {
    _bloc.add(ChecklistEvent.answerItem(
      itemId: itemId,
      value: value,
      isConforming: isConforming,
      notes: notes,
    ));
  }

  /// Mostrar modal de confirmação
  Future<void> _showConfirmationDialog() async {
    if (!_bloc.areAllRequiredItemsAnswered()) {
      ErrorDialog.show(
        context,
        title: 'Itens Obrigatórios',
        message: 'Por favor, responda todos os itens críticos (marcados com *) antes de finalizar.',
      );
      return;
    }
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Checklist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Você preencheu todos os itens do checklist.'),
            const SizedBox(height: 16),
            const Text('Deseja finalizar e enviar?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Após enviar, não será possível editar.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Revisar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryRed,
            ),
            child: const Text('Confirmar e Enviar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _saveChecklist();
    }
  }

  /// Salvar checklist
  Future<void> _saveChecklist() async {
    _bloc.add(const ChecklistEvent.startSaving());

    try {
      final state = _bloc.state;
      final apiService = ApiService();
      
      final checklists = state.checklistData!['checklists'] as List;
      final checklist = checklists[0];
      final templateId = checklist['id'];
      final vehicleId = state.vehicleData!['id'];
      
      if (kDebugMode) {
        print('📋 Iniciando execução do checklist...');
      }
      
      final executionResponse = await apiService.startChecklistExecution(
        fleetTemplateId: templateId,
        vehicleId: vehicleId,
        executionType: 'pre_trip',
      );
      
      if (executionResponse['success'] != true) {
        throw Exception(executionResponse['error'] ?? 'Erro ao iniciar execução');
      }
      
      final executionData = executionResponse['data'];
      _executionId = executionData['data']?['id'] ?? executionData['id'];
      _bloc.add(ChecklistEvent.executionStarted(_executionId!));
      
      // Enviar respostas
      for (final entry in state.responses.entries) {
        final itemId = entry.key;
        final response = entry.value;
        
        await apiService.answerChecklistItem(
          executionId: _executionId!,
          itemId: itemId,
          responseValue: response['value'],
          isConforming: response['is_conforming'] ?? true,
          notes: response['notes'],
        );
      }
      
      // Finalizar
      final completeResponse = await apiService.completeChecklistExecution(
        executionId: _executionId!,
        notes: 'Checklist concluído via app móvel',
      );
      
      if (completeResponse['success'] != true) {
        throw Exception(completeResponse['error'] ?? 'Erro ao finalizar checklist');
      }
      
      _bloc.add(const ChecklistEvent.saveCompleted());
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 32),
                const SizedBox(width: 12),
                const Text('Sucesso!'),
              ],
            ),
            content: const Text('Checklist finalizado e enviado com sucesso!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/journey-dashboard');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao salvar checklist: $e');
      }
      _bloc.add(ChecklistEvent.saveFailed('Erro ao salvar: $e'));
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro ao Salvar',
          message: 'Erro ao salvar checklist: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ChecklistBloc, ChecklistState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Checklist'),
              centerTitle: true,
              elevation: 2,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/journey-dashboard'),
                tooltip: 'Voltar',
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.isSaving
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 24),
                            Text(
                              'Salvando checklist...',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aguarde enquanto enviamos suas respostas',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 16.0,
                          bottom: 16.0 + MediaQuery.of(context).viewPadding.bottom + 80,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildVehicleCard(state),
                            const SizedBox(height: 16),
                            if (_bloc.hasChecklist()) _buildProgressBar(state),
                            if (_bloc.hasChecklist()) const SizedBox(height: 24),
                            ..._buildChecklistSections(state),
                          ],
                        ),
                      ),
            bottomNavigationBar: !state.isLoading && !state.isSaving && _bloc.hasChecklist()
                ? Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 12 + MediaQuery.of(context).viewPadding.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _showConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Finalizar Checklist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(ChecklistState state) {
    final progress = _bloc.calculateProgress();
    final total = progress['total'] as int;
    final answered = progress['answered'] as int;
    final percentage = progress['percentage'] as double;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progresso do Checklist',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$answered/$total',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: percentage == 1.0 ? Colors.green[700] : AppColors.zecaBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage == 1.0 ? Colors.green[600]! : AppColors.zecaBlue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              percentage == 1.0
                  ? '✅ Checklist completo! Você pode finalizar agora.'
                  : '${(percentage * 100).toStringAsFixed(0)}% concluído',
              style: TextStyle(
                fontSize: 13,
                color: percentage == 1.0 ? Colors.green[700] : Colors.grey[600],
                fontWeight: percentage == 1.0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(ChecklistState state) {
    if (state.vehicleData == null) return const SizedBox.shrink();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppColors.zecaBlue, AppColors.zecaBlue.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.directions_car, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Veículo', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    state.vehicleData!['placa'] ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${state.vehicleData!['marca']} ${state.vehicleData!['modelo']}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChecklistSections(ChecklistState state) {
    final checklists = state.checklistData?['checklists'] as List?;
    if (checklists == null || checklists.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 24),
                Text(
                  'Nenhum checklist disponível',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Não há checklist configurado para este veículo no momento.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ];
    }
    
    final checklist = checklists[0];
    final sections = checklist['sections'] as List?;
    
    if (sections == null || sections.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Checklist vazio'),
          ),
        ),
      ];
    }
    
    final sortedSections = List.from(sections)
      ..sort((a, b) => (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));
    
    final widgets = <Widget>[];
    
    widgets.add(
      Text(
        checklist['name'] ?? 'Checklist',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
    
    if (checklist['description'] != null) {
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        Text(
          checklist['description'],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      );
    }
    
    widgets.add(const SizedBox(height: 24));
    
    for (final section in sortedSections) {
      widgets.add(_buildSection(section, state));
      widgets.add(const SizedBox(height: 16));
    }
    
    return widgets;
  }

  bool _isSectionComplete(Map<String, dynamic> section, ChecklistState state) {
    final items = section['items'] as List?;
    if (items == null || items.isEmpty) return true;
    
    for (final item in items) {
      if (!state.responses.containsKey(item['id'])) return false;
    }
    return true;
  }

  int _getAnsweredItemsCount(Map<String, dynamic> section, ChecklistState state) {
    final items = section['items'] as List?;
    if (items == null || items.isEmpty) return 0;
    
    int count = 0;
    for (final item in items) {
      if (state.responses.containsKey(item['id'])) count++;
    }
    return count;
  }

  Widget _buildSection(Map<String, dynamic> section, ChecklistState state) {
    final items = section['items'] as List?;
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    
    final sortedItems = List.from(items)
      ..sort((a, b) => (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));
    
    final isComplete = _isSectionComplete(section, state);
    final answeredCount = _getAnsweredItemsCount(section, state);
    final totalItems = sortedItems.length;
    
    final backgroundColor = isComplete ? Colors.green[50] : Colors.white;
    final iconColor = isComplete ? Colors.green[700] : AppColors.zecaBlue;
    final textColor = isComplete ? Colors.green[900] : Colors.black87;
    
    return Card(
      elevation: isComplete ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isComplete ? BorderSide(color: Colors.green[700]!, width: 2) : BorderSide.none,
      ),
      color: backgroundColor,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        leading: Icon(
          isComplete ? Icons.check_circle : Icons.check_box_outline_blank,
          color: iconColor,
          size: 28,
        ),
        title: Text(
          section['name'] ?? 'Seção',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text(
                '$answeredCount/$totalItems itens',
                style: TextStyle(
                  fontSize: 13,
                  color: isComplete ? Colors.green[700] : Colors.grey[600],
                  fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (isComplete) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'COMPLETO',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
        initiallyExpanded: !isComplete,
        children: sortedItems.map((item) => _buildItem(item, state)).toList(),
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item, ChecklistState state) {
    final isCritical = item['is_critical'] == true;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isCritical) ...[
                const Text('*', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  item['name'] ?? 'Item',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCritical ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (item['description'] != null) ...[
            const SizedBox(height: 4),
            Text(item['description'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
          const SizedBox(height: 12),
          _buildItemInput(item, state),
        ],
      ),
    );
  }

  Widget _buildItemInput(Map<String, dynamic> item, ChecklistState state) {
    final itemType = item['item_type'];
    
    switch (itemType) {
      case 'checkbox':
        return _buildCheckboxInput(item, state);
      case 'select':
        return _buildSelectInput(item, state);
      case 'text':
      case 'number':
      default:
        return _buildTextInput(item, state);
    }
  }

  Widget _buildCheckboxInput(Map<String, dynamic> item, ChecklistState state) {
    final itemId = item['id'];
    final currentValue = state.responses[itemId]?['value'];
    final isChecked = currentValue == 'true' || currentValue == true || currentValue == 'Sim';
    
    return CheckboxListTile(
      value: isChecked,
      onChanged: (value) {
        _answerItem(
          itemId: itemId,
          value: value == true ? 'Sim' : 'Não',
          isConforming: value == true,
        );
      },
      title: Text(
        isChecked ? 'Conforme' : 'Não conforme',
        style: TextStyle(fontSize: 14, color: isChecked ? Colors.green[700] : Colors.grey[700]),
      ),
      activeColor: Colors.green,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildSelectInput(Map<String, dynamic> item, ChecklistState state) {
    final itemId = item['id'];
    final currentValue = state.responses[itemId]?['value'];
    final options = item['options']?['options'] as List?;
    
    if (options == null || options.isEmpty) {
      return const Text('Nenhuma opção disponível');
    }
    
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      hint: const Text('Selecione uma opção'),
      items: options.map<DropdownMenuItem<String>>((option) {
        return DropdownMenuItem<String>(
          value: option.toString(),
          child: Text(option.toString()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          _answerItem(
            itemId: itemId,
            value: value,
            isConforming: value != 'Ruim',
          );
        }
      },
    );
  }

  Widget _buildTextInput(Map<String, dynamic> item, ChecklistState state) {
    final itemId = item['id'];
    final itemType = item['item_type'];
    final currentValue = state.responses[itemId]?['value'];
    
    return TextFormField(
      initialValue: currentValue,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Digite sua resposta',
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: itemType == 'number' ? TextInputType.number : TextInputType.text,
      maxLines: itemType == 'text' ? 3 : 1,
      onChanged: (value) {
        _answerItem(itemId: itemId, value: value);
      },
    );
  }
}
