import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Filtro de período para histórico de eficiência
class EfficiencyPeriodFilter extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const EfficiencyPeriodFilter({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  static const periods = [
    ('week', 'Semana'),
    ('month', 'Mês'),
    ('quarter', 'Trimestre'),
    ('year', 'Ano'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: periods.map((p) {
          final isActive = p.$1 == selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onPeriodChanged(p.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.zecaBlue : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
