import 'package:flutter/material.dart';

/// Toggle para alternar entre km/L e L/100km
class EfficiencyUnitToggle extends StatelessWidget {
  final bool useL100km;
  final VoidCallback onToggle;

  const EfficiencyUnitToggle({
    super.key,
    required this.useL100km,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption('km/L', !useL100km),
            _buildOption('L/100', useL100km),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF2A70C0) : Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}
