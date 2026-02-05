import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation widget for the Home V3 redesign.
/// Features a floating FAB in the center for the primary action (Refuel).
/// Adapts navigation items based on user type (Autonomous vs Fleet).
class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isAutonomous;
  final VoidCallback onRefuelTap;

  const HomeBottomNav({
    Key? key,
    this.currentIndex = 0,
    required this.isAutonomous,
    required this.onRefuelTap,
  }) : super(key: key);

  // Design colors
  static const Color _primaryBlue = Color(0xFF2B6CB0);
  static const Color _activeColor = Color(0xFF2B6CB0);
  static const Color _inactiveColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Início
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: 'Início',
                index: 0,
                onTap: () => _navigateTo(context, 0),
              ),
              
              // Veículos (Autônomo) ou Jornadas (Frota)
              _buildNavItem(
                context,
                icon: isAutonomous ? Icons.directions_car : Icons.assignment,
                label: isAutonomous ? 'Veículos' : 'Jornadas',
                index: 1,
                onTap: () => _navigateTo(context, 1),
              ),
              
              // FAB central (Abastecer)
              _buildCenterFAB(),
              
              // Eficiência
              _buildNavItem(
                context,
                icon: Icons.speed,
                label: 'Eficiência',
                index: 2,
                onTap: () => _navigateTo(context, 2),
              ),
              
              // Perfil
              _buildNavItem(
                context,
                icon: Icons.person_outline_rounded,
                label: 'Perfil',
                index: 3,
                onTap: () => _navigateTo(context, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    // Adjust index for items after the FAB
    final adjustedCurrentIndex = currentIndex;
    final isActive = adjustedCurrentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? _activeColor : _inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? _activeColor : _inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterFAB() {
    return Expanded(
      child: GestureDetector(
        onTap: onRefuelTap,
        child: Transform.translate(
          offset: const Offset(0, -16),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3182CE), Color(0xFF2B6CB0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primaryBlue.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_gas_station,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Já está na home
        break;
      case 1:
        if (isAutonomous) {
          context.push('/autonomous/vehicles');
        } else {
          // TODO: Implementar tela de jornadas para frota
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Jornadas - Em breve'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
      case 2:
        context.push('/efficiency');
        break;
      case 3:
        context.push('/profile');
        break;
    }
  }
}
