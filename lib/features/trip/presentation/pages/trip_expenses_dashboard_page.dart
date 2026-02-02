import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_drawer.dart';

/// Trip Expenses Dashboard Page (US-003)
/// Displays summary of trip expenses with categories breakdown
class TripExpensesDashboardPage extends StatefulWidget {
  const TripExpensesDashboardPage({super.key});

  @override
  State<TripExpensesDashboardPage> createState() => _TripExpensesDashboardPageState();
}

class _TripExpensesDashboardPageState extends State<TripExpensesDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  // Colors
  static const Color _primaryOrange = Color(0xFFFF9800);
  static const Color _bgGray = Color(0xFFF5F5F5);

  // Mock data - will be replaced with BLoC integration
  final Map<String, dynamic> _mockData = {
    'total_expenses': 1256.00,
    'total_revenues': 2500.00,
    'net_profit': 1244.00,
    'cost_per_km': 2.79,
    'expense_count': 8,
    'expenses_by_category': {
      'FUEL': {'name': 'Combustível', 'value': 856.00, 'count': 3},
      'TOLL': {'name': 'Pedágio', 'value': 245.00, 'count': 4},
      'FOOD': {'name': 'Alimentação', 'value': 95.00, 'count': 2},
      'OTHER': {'name': 'Outros', 'value': 60.00, 'count': 1},
    },
  };

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgGray,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        title: const Text('Gestão de Gastos'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to expenses history
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Summary Card
                      _buildSummaryCard(),
                      const SizedBox(height: 16),

                      // Profit Card
                      _buildProfitCard(),
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

                      // Category Cards
                      ..._buildCategoryCards(),
                    ]),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/trip-expenses/add');
        },
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Gasto'),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalExpenses = _mockData['total_expenses'] as double;
    final expenseCount = _mockData['expense_count'] as int;
    final costPerKm = _mockData['cost_per_km'] as double;

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
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
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
            _formatCurrency(totalExpenses),
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
              _buildStatItem('$expenseCount', 'Registros'),
              _buildStatItem('R\$ ${costPerKm.toStringAsFixed(2)}', 'Custo/Km'),
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

  Widget _buildProfitCard() {
    final revenues = _mockData['total_revenues'] as double;
    final profit = _mockData['net_profit'] as double;
    final margin = (profit / revenues * 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
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
                const Text(
                  'Lucro Líquido',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(profit),
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
                const Icon(Icons.trending_up, color: Colors.white, size: 16),
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

  List<Widget> _buildCategoryCards() {
    final categories = _mockData['expenses_by_category'] as Map<String, dynamic>;
    final icons = {
      'FUEL': Icons.local_gas_station,
      'TOLL': Icons.toll,
      'FOOD': Icons.restaurant,
      'LODGING': Icons.hotel,
      'MAINTENANCE': Icons.build,
      'OTHER': Icons.more_horiz,
    };
    final colors = {
      'FUEL': const Color(0xFFE53935),
      'TOLL': const Color(0xFF1976D2),
      'FOOD': const Color(0xFFFFA000),
      'LODGING': const Color(0xFF7B1FA2),
      'MAINTENANCE': const Color(0xFF455A64),
      'OTHER': const Color(0xFF757575),
    };

    return categories.entries.map((entry) {
      final code = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final icon = icons[code] ?? Icons.receipt;
      final color = colors[code] ?? Colors.grey;
      
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${data['count']} registro(s)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatCurrency(data['value'] as double),
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
}
