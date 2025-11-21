import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/theme/app_colors.dart';

/// Widget compartilhado para o drawer (menu hambúrguer)
/// Usado em todas as telas do app para manter consistência
class AppDrawer extends StatelessWidget {
  final String? currentRoute;

  const AppDrawer({
    Key? key,
    this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usar FutureBuilder para obter dados do usuário de forma assíncrona
    return FutureBuilder<Map<String, dynamic>?>(
      future: SharedPreferences.getInstance().then((prefs) {
        final userJson = prefs.getString('user_data');
        if (userJson != null) {
          try {
            return jsonDecode(userJson) as Map<String, dynamic>;
          } catch (e) {
            return null;
          }
        }
        return null;
      }),
      builder: (context, snapshot) {
        final userData = snapshot.data;
        final userName = userData?['nome'] ?? userData?['name'] ?? 'Usuário';

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.zecaBlue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.local_gas_station,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ZECA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.local_gas_station, color: AppColors.zecaBlue),
                title: const Text('Gerar Abastecimento'),
                selected: currentRoute == '/home',
                selectedTileColor: AppColors.zecaBlue.withOpacity(0.1),
                onTap: () {
                  Navigator.of(context).pop(); // Fechar o drawer
                  if (currentRoute != '/home') {
                    context.go('/home');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car, color: AppColors.zecaBlue),
                title: const Text('Registrar Jornada'),
                selected: currentRoute == '/journey',
                selectedTileColor: AppColors.zecaBlue.withOpacity(0.1),
                onTap: () {
                  Navigator.of(context).pop(); // Fechar o drawer
                  if (currentRoute != '/journey') {
                    context.go('/journey');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.checklist, color: AppColors.zecaBlue),
                title: const Text('Checklist'),
                selected: currentRoute == '/checklist',
                selectedTileColor: AppColors.zecaBlue.withOpacity(0.1),
                onTap: () {
                  Navigator.of(context).pop(); // Fechar o drawer
                  // TODO: Implementar tela de checklist
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade em desenvolvimento'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.of(context).pop(); // Fechar o drawer
                  context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

