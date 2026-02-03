import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/trip_expenses_bloc.dart';
import '../bloc/trip_expenses_event.dart';
import '../bloc/trip_expenses_state.dart';

/// Add Expense Page (US-004)
/// Form to register a new trip expense
/// INTEGRADO COM API - Zero Hardcode
class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TripExpensesBloc>()
        ..add(const TripExpensesEvent.loadActiveTrip())
        ..add(const TripExpensesEvent.loadCategories()),
      child: const _AddExpenseContent(),
    );
  }
}

class _AddExpenseContent extends StatefulWidget {
  const _AddExpenseContent();

  @override
  State<_AddExpenseContent> createState() => _AddExpenseContentState();
}

class _AddExpenseContentState extends State<_AddExpenseContent> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategoryId;

  static const Color _primaryOrange = Color(0xFFFF9800);

  // Icon/color maps for category display
  IconData _getCategoryIcon(String? code) {
    final icons = {
      'FUEL': Icons.local_gas_station,
      'COMBUSTIVEL': Icons.local_gas_station,
      'TOLL': Icons.toll,
      'PEDAGIO': Icons.toll,
      'FOOD': Icons.restaurant,
      'ALIMENTACAO': Icons.restaurant,
      'LODGING': Icons.hotel,
      'HOSPEDAGEM': Icons.hotel,
      'MAINTENANCE': Icons.build,
      'MANUTENCAO': Icons.build,
      'OTHER': Icons.more_horiz,
      'OUTROS': Icons.more_horiz,
    };
    return icons[code?.toUpperCase()] ?? Icons.receipt;
  }

  Color _getCategoryColor(String? code) {
    final colors = {
      'FUEL': const Color(0xFFE53935),
      'COMBUSTIVEL': const Color(0xFFE53935),
      'TOLL': const Color(0xFF1976D2),
      'PEDAGIO': const Color(0xFF1976D2),
      'FOOD': const Color(0xFFFFA000),
      'ALIMENTACAO': const Color(0xFFFFA000),
      'LODGING': const Color(0xFF7B1FA2),
      'HOSPEDAGEM': const Color(0xFF7B1FA2),
      'MAINTENANCE': const Color(0xFF455A64),
      'MANUTENCAO': const Color(0xFF455A64),
      'OTHER': const Color(0xFF757575),
      'OUTROS': const Color(0xFF757575),
    };
    return colors[code?.toUpperCase()] ?? Colors.grey;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final state = context.read<TripExpensesBloc>().state;
    if (state.activeTrip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma viagem ativa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

    context.read<TripExpensesBloc>().add(
          TripExpensesEvent.createExpense(
            tripId: state.activeTrip!.id,
            categoryId: _selectedCategoryId!,
            amount: amount,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
            location: _locationController.text.isNotEmpty
                ? _locationController.text
                : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripExpensesBloc, TripExpensesState>(
      listener: (context, state) {
        // Success - show success screen then pop
        if (state.expenseCreatedSuccess) {
          _showSuccessAndPop();
        }

        // Error - show snackbar
        if (state.errorMessage != null && !state.isCreatingExpense) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // Loading categories
        if (state.isLoadingCategories || (state.isLoading && state.categories.isEmpty)) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _primaryOrange,
              foregroundColor: Colors.white,
              title: const Text('Novo Gasto'),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: _primaryOrange),
            ),
          );
        }

        // No active trip
        if (!state.isLoading && state.activeTrip == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _primaryOrange,
              foregroundColor: Colors.white,
              title: const Text('Novo Gasto'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Nenhuma viagem ativa'),
                  const SizedBox(height: 8),
                  Text(
                    'Inicie uma viagem para registrar gastos',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildForm(context, state);
      },
    );
  }

  Future<void> _showSuccessAndPop() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: const Color(0xFF4CAF50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Gasto Registrado!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${_amountController.text}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pop(); // Close dialog
      context.pop(); // Go back to dashboard
    }
  }

  Widget _buildForm(BuildContext context, TripExpensesState state) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        title: const Text('Novo Gasto'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection
              const Text(
                'Tipo de Gasto',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildCategoryGrid(state.categories),
              const SizedBox(height: 24),

              // Amount Input
              const Text(
                'Valor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildAmountInput(),
              const SizedBox(height: 20),

              // Description Input
              const Text(
                'Descrição (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildDescriptionInput(),
              const SizedBox(height: 20),

              // Location Input
              const Text(
                'Local (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildLocationInput(),
              const SizedBox(height: 20),

              // Receipt Attachment
              _buildReceiptAttachment(),
              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(state.isCreatingExpense),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(List<ExpenseCategoryEntity> categories) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.category_outlined, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Nenhuma categoria disponível',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Separar categorias pai (sem parentId) e filhos (com parentId)
    final parentCategories = categories.where((c) => c.isParent).toList();
    final childCategories = categories.where((c) => c.isChild).toList();

    // Agrupar filhos por parentId
    final Map<String, List<ExpenseCategoryEntity>> childrenByParent = {};
    for (var child in childCategories) {
      childrenByParent.putIfAbsent(child.parentId!, () => []).add(child);
    }

    return Column(
      children: parentCategories.map((parent) {
        final children = childrenByParent[parent.id] ?? [];
        
        // Se não tem filhos, mostra como card simples
        if (children.isEmpty) {
          return _buildCategoryCard(parent);
        }
        
        // Se tem filhos, mostra como seção expansível
        return _buildExpandableCategory(parent, children);
      }).toList(),
    );
  }

  Widget _buildCategoryCard(ExpenseCategoryEntity category) {
    final isSelected = _selectedCategoryId == category.id;
    final icon = _getCategoryIcon(category.code);
    final color = _getCategoryColor(category.code);

    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = category.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCategory(
    ExpenseCategoryEntity parent,
    List<ExpenseCategoryEntity> children,
  ) {
    final parentIcon = _getCategoryIcon(parent.code);
    final parentColor = _getCategoryColor(parent.code);
    final hasChildSelected = children.any((c) => c.id == _selectedCategoryId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasChildSelected ? parentColor : Colors.grey[300]!,
          width: hasChildSelected ? 2 : 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: hasChildSelected,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: parentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(parentIcon, color: parentColor, size: 24),
          ),
          title: Text(
            parent.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: hasChildSelected ? parentColor : Colors.black87,
            ),
          ),
          subtitle: Text(
            '${children.length} opções',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: children.map((child) {
                  final isSelected = _selectedCategoryId == child.id;
                  final color = _getCategoryColor(parent.code);
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryId = child.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.15)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            child.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? color : Colors.black87,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.check, color: color, size: 16),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
      ],
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        prefixText: 'R\$ ',
        prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        hintText: '0,00',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryOrange, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o valor';
        }
        final amount = double.tryParse(value.replaceAll(',', '.'));
        if (amount == null || amount <= 0) {
          return 'Valor deve ser maior que zero';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'Ex: Abastecimento completo',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryOrange, width: 2),
        ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        hintText: 'Ex: Posto Shell BR-101',
        prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryOrange, width: 2),
        ),
      ),
    );
  }

  Widget _buildReceiptAttachment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.camera_alt, color: Colors.grey[600], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comprovante (opcional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Tire uma foto do cupom fiscal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Em breve: Captura de comprovante')),
              );
            },
            child: const Text(
              'ANEXAR',
              style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _saveExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'SALVAR GASTO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
