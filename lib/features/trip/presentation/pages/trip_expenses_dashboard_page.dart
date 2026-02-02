import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../domain/entities/trip_summary.dart';
import '../bloc/trip_expenses_bloc.dart';
import '../bloc/trip_expenses_event.dart';
import '../bloc/trip_expenses_state.dart';

/// Trip Expenses Dashboard Page (US-003)
/// Displays summary of trip expenses with categories breakdown
/// INTEGRADO COM API - Zero Hardcode
class TripExpensesDashboardPage extends StatelessWidget {
  const TripExpensesDashboardPage({super.key});

  // Colors
  static const Color _primaryOrange = Color(0xFFFF9800);
  static const Color _bgGray = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TripExpensesBloc>()
        ..add(const TripExpensesEvent.loadActiveTrip())
        ..add(const TripExpensesEvent.loadCategories()),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  static const Color _primaryOrange = Color(0xFFFF9800);
  static const Color _bgGray = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _bgGray,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        title: const Text('Gestão de Gastos'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
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
      body: BlocBuilder<TripExpensesBloc, TripExpensesState>(
        builder: (context, state) {
          // Loading state
          if (state.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: _primaryOrange),
                  SizedBox(height: 16),
                  Text('Carregando dados...'),
                ],
              ),
            );
          }

          // Error state
          if (state.errorMessage != null) {
            return _buildErrorState(context, state.errorMessage!);
          }

          // No active trip state
          if (state.activeTrip == null) {
            return _buildNoTripState(context);
          }

          // Data loaded - show dashboard
          return _buildDashboard(context, state);
        },
      ),
      floatingActionButton: BlocBuilder<TripExpensesBloc, TripExpensesState>(
        builder: (context, state) {
          if (state.activeTrip == null) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => context.push('/trip-expenses/add'),
            backgroundColor: _primaryOrange,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Novo Gasto'),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar dados',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
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

  Widget _buildNoTripState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined,
                size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Nenhuma viagem ativa',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Inicie uma viagem para registrar\ne gerenciar seus gastos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to start trip
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryOrange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              icon: const Icon(Icons.add_road),
              label: const Text('Iniciar Viagem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, TripExpensesState state) {
    final summary = state.tripSummary ?? TripSummary.empty(state.activeTrip!.id);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TripExpensesBloc>().add(
              const TripExpensesEvent.refresh(),
            );
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Summary Card
                _buildSummaryCard(summary),
                const SizedBox(height: 16),

                // Profit Card
                _buildProfitCard(summary),
                const SizedBox(height: 16),

                // Category Title
                const Text(
                  'Gastos por Categoria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Category Cards or Empty state
                if (summary.expensesByCategory.isEmpty)
                  _buildEmptyCategoryState()
                else
                  ..._buildCategoryCards(summary.expensesByCategory),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(TripSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFE67E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Total de Gastos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatCurrency(summary.totalExpenses),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.3), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('${summary.expenseCount}', 'Registros'),
              _buildStatItem(
                  'R\$ ${summary.costPerKm.toStringAsFixed(2)}', 'Custo/Km'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildProfitCard(TripSummary summary) {
    final margin = summary.totalRevenues > 0
        ? (summary.netProfit / summary.totalRevenues * 100)
        : 0.0;
    final isProfit = summary.netProfit >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isProfit
              ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
              : [const Color(0xFFE53935), const Color(0xFFC62828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isProfit ? 'Lucro Líquido' : 'Prejuízo',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(summary.netProfit.abs()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
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
            child: Row(
              children: [
                Icon(
                  isProfit ? Icons.trending_up : Icons.trending_down,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${margin.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategoryState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Nenhum gasto registrado',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Toque em "+ Novo Gasto" para adicionar',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryCards(Map<String, double> categories) {
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

    final names = {
      'FUEL': 'Combustível',
      'COMBUSTIVEL': 'Combustível',
      'TOLL': 'Pedágio',
      'PEDAGIO': 'Pedágio',
      'FOOD': 'Alimentação',
      'ALIMENTACAO': 'Alimentação',
      'LODGING': 'Hospedagem',
      'HOSPEDAGEM': 'Hospedagem',
      'MAINTENANCE': 'Manutenção',
      'MANUTENCAO': 'Manutenção',
      'OTHER': 'Outros',
      'OUTROS': 'Outros',
    };

    return categories.entries.map((entry) {
      final code = entry.key.toUpperCase();
      final value = entry.value;
      final icon = icons[code] ?? Icons.receipt;
      final color = colors[code] ?? Colors.grey;
      final name = names[code] ?? entry.key;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                _formatCurrency(value),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }
}
