import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/di/injection.dart';

/// Tela exibida quando o autônomo faz login pela primeira vez
/// e ainda não tem nenhum veículo cadastrado.
class AutonomousFirstAccessPage extends StatelessWidget {
  const AutonomousFirstAccessPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do aplicativo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && context.mounted) {
      final storage = getIt<StorageService>();
      await storage.clearTokens();
      await storage.clearUserData();
      await storage.clearJourneyVehicleData();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Bem-vindo!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Navegar para notificações
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.account_circle, size: 60, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Motorista Autônomo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: primaryColor),
              title: const Text('Início'),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Conteúdo central
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone grande
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Título
                  const Text(
                    'Cadastre seu veículo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Descrição
                  const Text(
                    'Para começar a usar o ZECA, você precisa cadastrar pelo menos um veículo.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Card de passos
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildStepItem(
                          context,
                          number: '1',
                          text: 'Cadastre seu veículo (placa, modelo, combustível)',
                          primaryColor: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildStepItem(
                          context,
                          number: '2',
                          text: 'Selecione o veículo para iniciar a jornada',
                          primaryColor: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildStepItem(
                          context,
                          number: '3',
                          text: 'Gere o código e abasteça no posto parceiro',
                          primaryColor: primaryColor,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom bar fixo
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/autonomous/vehicles/add'),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'CADASTRAR VEÍCULO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required String number,
    required String text,
    required Color primaryColor,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Número do passo
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Texto do passo
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
