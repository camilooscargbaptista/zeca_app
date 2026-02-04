import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget displaying dual cards: Economy + Trip Expenses
/// According to mockup: compact side-by-side cards
class DualSummaryCards extends StatelessWidget {
  final double economySavings;
  final int totalRefuelings;
  final double? avgConsumption;
  final String monthName;
  final double tripExpensesTotal;
  final VoidCallback? onEconomyTap;
  final VoidCallback? onExpensesTap;

  const DualSummaryCards({
    super.key,
    required this.economySavings,
    required this.totalRefuelings,
    this.avgConsumption,
    required this.monthName,
    this.tripExpensesTotal = 0,
    this.onEconomyTap,
    this.onExpensesTap,
  });

  String _formatCurrency(double value) {
    if (value >= 1000) {
      return NumberFormat.compactCurrency(locale: 'pt_BR', symbol: 'R\$')
          .format(value);
    }
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Economy Card (Green)
        Expanded(
          child: _buildMiniCard(
            color: const Color(0xFF43A047),
            gradientEnd: const Color(0xFF2E7D32),
            icon: Icons.savings,
            title: 'Economia • $monthName',
            value: _formatCurrency(economySavings),
            onTap: onEconomyTap,
          ),
        ),
        const SizedBox(width: 8),
        // Trip Expenses Card (Orange)
        Expanded(
          child: _buildMiniCard(
            color: const Color(0xFFFF9800),
            gradientEnd: const Color(0xFFE67E00),
            icon: Icons.account_balance_wallet,
            title: 'Gastos Viagem',
            value: _formatCurrency(tripExpensesTotal),
            onTap: onExpensesTap,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard({
    required Color color,
    required Color gradientEnd,
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: Colors.white, size: 12),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
