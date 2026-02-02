import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/trip_summary.dart';
import '../bloc/trip_expenses_bloc.dart';
import '../bloc/trip_expenses_event.dart';
import '../bloc/trip_expenses_state.dart';

/// Trip Summary Page (US-006)
/// Complete financial summary of the current/selected trip
/// INTEGRADO COM API - Zero Hardcode
class TripSummaryPage extends StatelessWidget {
  final String? tripId;

  const TripSummaryPage({super.key, this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TripExpensesBloc>()
        ..add(const TripExpensesEvent.loadActiveTrip()),
      child: const _TripSummaryContent(),
    );
  }
}

class _TripSummaryContent extends StatelessWidget {
  const _TripSummaryContent();

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Em andamento';
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: const Text('Resumo da Viagem'),
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
      body: BlocBuilder<TripExpensesBloc, TripExpensesState>(
        builder: (context, state) {
          // Loading
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1976D2)),
            );
          }

          // Error
          if (state.errorMessage != null) {
            return _buildErrorState(context, state.errorMessage!);
          }

          // No active trip
          if (state.activeTrip == null) {
            return _buildNoTripState(context);
          }

          // Show summary
          final summary =
              state.tripSummary ?? TripSummary.empty(state.activeTrip!.id);
          return _buildContent(context, state, summary);
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

  Widget _buildNoTripState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.summarize_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Nenhuma viagem ativa',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Inicie uma viagem para ver o resumo financeiro.',
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

  Widget _buildContent(
      BuildContext context, TripExpensesState state, TripSummary summary) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TripExpensesBloc>().add(
              const TripExpensesEvent.refresh(),
            );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Route Header
            _buildRouteHeader(summary, state),
            const SizedBox(height: 16),

            // Main KPIs
            _buildMainKPIs(summary),
            const SizedBox(height: 16),

            // Financial Breakdown
            _buildFinancialBreakdown(summary),
            const SizedBox(height: 16),

            // Expenses by Category
            _buildCategoryBreakdown(summary),
            const SizedBox(height: 16),

            // Quick Actions
            _buildQuickActions(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteHeader(TripSummary summary, TripExpensesState state) {
    final origin = summary.origin ?? state.activeTrip?.origin ?? 'Origem';
    final destination =
        summary.destination ?? state.activeTrip?.destination ?? 'Destino';
    final distance = summary.totalDistanceKm;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.route, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$origin → $destination',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${distance.toStringAsFixed(0)} km',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDateInfo('Início', _formatDate(summary.startedAt)),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildDateInfo('Fim', _formatDate(summary.endedAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMainKPIs(TripSummary summary) {
    final isProfit = summary.netProfit >= 0;

    return Row(
      children: [
        // Profit Card
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isProfit
                    ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                    : [const Color(0xFFE53935), const Color(0xFFC62828)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isProfit ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isProfit ? 'Lucro Líquido' : 'Prejuízo',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatCurrency(summary.netProfit.abs()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Margem: ${summary.profitMargin.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Cost per KM Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custo/Km',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${summary.costPerKm.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF1976D2),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialBreakdown(TripSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balanço Financeiro',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildFinancialRow(
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF4CAF50),
            label: 'Total Receitas',
            sublabel: '${summary.revenueCount} frete(s)',
            value: summary.totalRevenues,
            valueColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 12),
          _buildFinancialRow(
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFFE53935),
            label: 'Total Despesas',
            sublabel: '${summary.expenseCount} registro(s)',
            value: summary.totalExpenses,
            valueColor: const Color(0xFFE53935),
            isNegative: true,
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Resultado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                _formatCurrency(summary.netProfit),
                style: TextStyle(
                  color: summary.netProfit >= 0
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String sublabel,
    required double value,
    required Color valueColor,
    bool isNegative = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                sublabel,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ),
        Text(
          '${isNegative ? '- ' : '+ '}${_formatCurrency(value)}',
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(TripSummary summary) {
    if (summary.expensesByCategory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.pie_chart_outline, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Nenhum gasto registrado',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final categoryInfo = {
      'FUEL': {'name': 'Combustível', 'color': const Color(0xFFE53935)},
      'COMBUSTIVEL': {'name': 'Combustível', 'color': const Color(0xFFE53935)},
      'TOLL': {'name': 'Pedágio', 'color': const Color(0xFF1976D2)},
      'PEDAGIO': {'name': 'Pedágio', 'color': const Color(0xFF1976D2)},
      'FOOD': {'name': 'Alimentação', 'color': const Color(0xFFFFA000)},
      'ALIMENTACAO': {'name': 'Alimentação', 'color': const Color(0xFFFFA000)},
      'LODGING': {'name': 'Hospedagem', 'color': const Color(0xFF7B1FA2)},
      'HOSPEDAGEM': {'name': 'Hospedagem', 'color': const Color(0xFF7B1FA2)},
      'MAINTENANCE': {'name': 'Manutenção', 'color': const Color(0xFF455A64)},
      'MANUTENCAO': {'name': 'Manutenção', 'color': const Color(0xFF455A64)},
      'OTHER': {'name': 'Outros', 'color': const Color(0xFF757575)},
      'OUTROS': {'name': 'Outros', 'color': const Color(0xFF757575)},
    };

    final total = summary.totalExpenses;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Despesas por Categoria',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ...summary.expensesByCategory.entries.map((entry) {
            final code = entry.key.toUpperCase();
            final info = categoryInfo[code] ?? {'name': entry.key, 'color': Colors.grey};
            final value = entry.value;
            final percentage = total > 0 ? (value / total * 100) : 0;
            final color = info['color'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          info['name'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _formatCurrency(value),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: total > 0 ? value / total : 0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.add_circle_outline,
            label: 'Add Gasto',
            color: const Color(0xFFFF9800),
            onTap: () => context.push('/trip-expenses/add'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.attach_money,
            label: 'Add Receita',
            color: const Color(0xFF4CAF50),
            onTap: () => context.push('/trip-revenues'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.list_alt,
            label: 'Ver Gastos',
            color: const Color(0xFF1976D2),
            onTap: () => context.push('/trip-expenses'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
