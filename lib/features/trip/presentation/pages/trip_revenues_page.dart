import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/trip_expenses_bloc.dart';
import '../bloc/trip_expenses_event.dart';
import '../bloc/trip_expenses_state.dart';

/// Trip Revenues Page (US-005)
/// Manage trip revenues/freights
/// INTEGRADO COM API - Zero Hardcode
class TripRevenuesPage extends StatelessWidget {
  const TripRevenuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TripExpensesBloc>()
        ..add(const TripExpensesEvent.loadActiveTrip()),
      child: const _TripRevenuesContent(),
    );
  }
}

class _TripRevenuesContent extends StatefulWidget {
  const _TripRevenuesContent();

  @override
  State<_TripRevenuesContent> createState() => _TripRevenuesContentState();
}

class _TripRevenuesContentState extends State<_TripRevenuesContent> {
  bool _showAddForm = false;

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  static const Color _primaryGreen = Color(0xFF4CAF50);

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _addRevenue() {
    if (_amountController.text.isEmpty) return;
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0) return;

    final state = context.read<TripExpensesBloc>().state;
    if (state.activeTrip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma viagem ativa'), backgroundColor: Colors.red),
      );
      return;
    }

    final trip = state.activeTrip!;
    
    // Dispatch createRevenue event to BLoC
    context.read<TripExpensesBloc>().add(
      TripExpensesEvent.createRevenue(
        tripId: trip.id,
        vehicleId: trip.vehicleId,
        amount: amount,
        origin: _originController.text.isEmpty ? null : _originController.text,
        destination: _destinationController.text.isEmpty ? null : _destinationController.text,
        clientName: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      ),
    );

    setState(() {
      _showAddForm = false;
      _amountController.clear();
      _descriptionController.clear();
      _originController.clear();
      _destinationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: _primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('Receitas / Fretes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TripExpensesBloc>().add(
                    const TripExpensesEvent.refresh(),
                  );
            },
          ),
        ],
      ),
      body: BlocListener<TripExpensesBloc, TripExpensesState>(
        listenWhen: (prev, curr) =>
            prev.revenueCreatedSuccess != curr.revenueCreatedSuccess ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.revenueCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Receita adicionada com sucesso!'),
                backgroundColor: _primaryGreen,
              ),
            );
            context.read<TripExpensesBloc>().add(const TripExpensesEvent.clearSuccessFlag());
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TripExpensesBloc, TripExpensesState>(
        builder: (context, state) {
          // Loading
          if (state.isLoading || state.isCreatingRevenue) {
            return const Center(
              child: CircularProgressIndicator(color: _primaryGreen),
            );
          }

          // Error
          if (state.errorMessage != null) {
            return _buildErrorState(state.errorMessage!);
          }

          // No active trip
          if (state.activeTrip == null) {
            return _buildNoTripState();
          }

          // Content
          return _buildContent(state);
        },
      ),
      ),
      floatingActionButton: BlocBuilder<TripExpensesBloc, TripExpensesState>(
        builder: (context, state) {
          if (state.activeTrip == null || _showAddForm) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => setState(() => _showAddForm = true),
            backgroundColor: _primaryGreen,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Nova Receita'),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Erro: $error', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<TripExpensesBloc>().add(
                      const TripExpensesEvent.loadActiveTrip(),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTripState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Nenhuma viagem ativa',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Inicie uma viagem para registrar receitas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TripExpensesState state) {
    final summary = state.tripSummary;
    final totalRevenue = summary?.totalRevenues ?? 0;
    final revenueCount = summary?.revenueCount ?? 0;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TripExpensesBloc>().add(
              const TripExpensesEvent.refresh(),
            );
      },
      child: Column(
        children: [
          // Summary Header
          _buildSummaryHeader(totalRevenue, revenueCount),

          // Content
          Expanded(
            child: revenueCount == 0 && !_showAddForm
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_showAddForm) _buildAddForm(),
                      if (revenueCount == 0 && _showAddForm)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Suas receitas aparecerão aqui após serem registradas',
                              style: TextStyle(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      // TODO: Add revenue list when revenue entities are implemented
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(double totalRevenue, int revenueCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.attach_money, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total de Receitas',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(totalRevenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$revenueCount frete(s)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma receita registrada',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione seus fretes para controlar seus ganhos',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_circle, color: _primaryGreen),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Nova Receita',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _showAddForm = false),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Amount
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Valor do Frete',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descrição (opcional)',
              hintText: 'Ex: Carga de grãos',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),

          // Origin / Destination
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _originController,
                  decoration: InputDecoration(
                    labelText: 'Origem',
                    hintText: 'Cidade, UF',
                    prefixIcon: const Icon(Icons.trip_origin, size: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destino',
                    hintText: 'Cidade, UF',
                    prefixIcon: const Icon(Icons.place, size: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addRevenue,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'ADICIONAR RECEITA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
