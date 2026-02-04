import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_input_formatter.dart';
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
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedParentId;
  String? _selectedCategoryId;
  XFile? _receiptImage;

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

    final amount = _amountController.text.toCurrencyDouble();

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
            receiptPath: _receiptImage?.path,
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
      barrierDismissible: true,
      builder: (ctx) => Dialog(
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (mounted) {
      context.read<TripExpensesBloc>().add(const TripExpensesEvent.clearSuccessFlag());
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Espaço para o botão fixo
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection - Dois Dropdowns
              const Text(
                'Categoria',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildCategoryDropdown(state.categories),
              const SizedBox(height: 16),
              // Subcategoria (só aparece se tiver filhos)
              _buildSubcategoryDropdown(state.categories),
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
            ],
          ),
        ),
      ),
      // Botão SALVAR fixo no rodapé
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _buildSubmitButton(state.isCreatingExpense),
      ),
    );
  }

  /// Dropdown para selecionar categoria pai
  Widget _buildCategoryDropdown(List<ExpenseCategoryEntity> categories) {
    // Categorias pai são aquelas sem parentId
    final parentCategories = categories.where((c) => c.isParent).toList();

    return DropdownButtonFormField<String>(
      value: _selectedParentId,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      hint: const Text('Selecione a categoria'),
      isExpanded: true,
      items: parentCategories.map((category) {
        final icon = _getCategoryIcon(category.code);
        final color = _getCategoryColor(category.code);
        
        return DropdownMenuItem<String>(
          value: category.id,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(category.name, style: const TextStyle(fontSize: 15)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedParentId = value;
          // Verifica se a categoria pai tem filhos
          final children = categories.where((c) => c.parentId == value).toList();
          if (children.isEmpty) {
            // Se não tem filhos, usa a própria categoria pai
            _selectedCategoryId = value;
          } else {
            // Se tem filhos, limpa a seleção (usuário precisa escolher subcategoria)
            _selectedCategoryId = null;
          }
        });
      },
    );
  }

  /// Dropdown para selecionar subcategoria (só aparece se a categoria pai tiver filhos)
  Widget _buildSubcategoryDropdown(List<ExpenseCategoryEntity> categories) {
    // Se nenhuma categoria pai foi selecionada, não mostra nada
    if (_selectedParentId == null) {
      return const SizedBox.shrink();
    }

    // Filtra as subcategorias do pai selecionado
    final subcategories = categories
        .where((c) => c.parentId == _selectedParentId)
        .toList();

    // Se não há subcategorias, não mostra nada
    if (subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    // Encontra a categoria pai para usar sua cor
    final parent = categories.firstWhere(
      (c) => c.id == _selectedParentId,
      orElse: () => categories.first,
    );
    final parentColor = _getCategoryColor(parent.code);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo específico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            filled: true,
            fillColor: parentColor.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: parentColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: parentColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: parentColor, width: 2),
            ),
          ),
          hint: const Text('Selecione o tipo'),
          isExpanded: true,
          items: subcategories.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name, style: const TextStyle(fontSize: 15)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
          },
          validator: (value) {
            if (value == null && subcategories.isNotEmpty) {
              return 'Selecione o tipo específico';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyInputFormatter(),
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
        final amount = value.toCurrencyDouble();
        if (amount <= 0) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comprovante (opcional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // Mostrar preview se tiver imagem selecionada
        if (_receiptImage != null)
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryOrange, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_receiptImage!.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.receipt_long, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _receiptImage = null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: _showReceiptOptions,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _primaryOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo, color: _primaryOrange, size: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Anexar comprovante',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tire uma foto ou escolha da galeria',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showReceiptOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Adicionar comprovante',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primaryOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: _primaryOrange),
                ),
                title: const Text('Tirar foto'),
                subtitle: const Text('Usar a câmera do dispositivo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text('Escolher da galeria'),
                subtitle: const Text('Selecionar imagem existente'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _receiptImage = image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
