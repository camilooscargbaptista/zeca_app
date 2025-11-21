import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../core/di/injection.dart';

class JourneyStartPage extends StatefulWidget {
  const JourneyStartPage({Key? key}) : super(key: key);

  @override
  State<JourneyStartPage> createState() => _JourneyStartPageState();
}

class _JourneyStartPageState extends State<JourneyStartPage> {
  final _placaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Dados do usuário logado
  Map<String, dynamic>? _userData;
  
  // Estados do fluxo de busca de veículo
  bool _vehicleSearched = false;
  bool _vehicleConfirmed = false;
  Map<String, dynamic>? _vehicleData;
  
  // Máscara para placa (formato antigo e Mercosul)
  final _placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA-####',
    filter: {"A": RegExp(r'[A-Za-z0-9]'), "#": RegExp(r'[A-Za-z0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkExistingJourney();
  }

  @override
  void dispose() {
    _placaController.dispose();
    super.dispose();
  }

  /// Carregar dados do usuário logado
  Future<void> _loadUserData() async {
    try {
      // Buscar dados do UserService (salvos no login)
      final userService = UserService();
      final storageService = getIt<StorageService>();
      final storedUserData = storageService.getUserData();
      
      debugPrint('🔍 Carregando dados do usuário...');
      debugPrint('   UserService CPF: ${userService.driverCpf}');
      debugPrint('   UserService Nome: ${userService.userName}');
      debugPrint('   UserService CNPJ: ${userService.transporterCnpj}');
      debugPrint('   Storage Data: $storedUserData');
      
      // Priorizar UserService (dados do login)
      if (userService.isLoggedIn) {
        setState(() {
          _userData = {
            'nome': userService.userName ?? storedUserData?['name'] ?? storedUserData?['nome'] ?? 'Motorista',
            'cpf': userService.driverCpf ?? storedUserData?['cpf'] ?? '---',
            'empresa': storedUserData?['company']?['name'] ?? storedUserData?['empresa'] ?? 'Transportadora',
            'cnpj': userService.transporterCnpj ?? storedUserData?['company']?['cnpj'] ?? storedUserData?['cnpj'] ?? '---',
            'telefone': storedUserData?['phone'] ?? storedUserData?['telefone'] ?? '---',
            'email': storedUserData?['email'] ?? '---',
          };
        });
        debugPrint('✅ Dados carregados do UserService');
      } else if (storedUserData != null && storedUserData.isNotEmpty) {
        // Fallback para dados do storage
        setState(() {
          _userData = {
            'nome': storedUserData['name'] ?? storedUserData['nome'] ?? 'Motorista',
            'cpf': storedUserData['cpf'] ?? '---',
            'empresa': storedUserData['company']?['name'] ?? storedUserData['empresa'] ?? 'Transportadora',
            'cnpj': storedUserData['company']?['cnpj'] ?? storedUserData['cnpj'] ?? '---',
            'telefone': storedUserData['phone'] ?? storedUserData['telefone'] ?? '---',
            'email': storedUserData['email'] ?? '---',
          };
        });
        debugPrint('✅ Dados carregados do Storage');
      } else {
        // Usar dados de fallback se não houver nada
        setState(() {
          _userData = {
            'nome': 'Motorista',
            'cpf': '---',
            'empresa': 'Transportadora',
            'cnpj': '---',
            'telefone': '---',
            'email': '---',
          };
        });
        debugPrint('⚠️ Nenhum dado encontrado, usando fallback');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar dados do usuário: $e');
      // Usar dados de fallback
      setState(() {
        _userData = {
          'nome': 'Motorista',
          'cpf': '---',
          'empresa': 'Transportadora',
          'cnpj': '---',
          'telefone': '---',
          'email': '---',
        };
      });
    }
  }

  /// Verificar se já existe uma jornada iniciada
  Future<void> _checkExistingJourney() async {
    try {
      final storageService = getIt<StorageService>();
      final vehicleData = await storageService.getJourneyVehicleData();
      
      if (vehicleData != null && vehicleData.isNotEmpty) {
        // Já existe uma jornada iniciada, redirecionar para dashboard
        if (mounted) {
          context.go('/journey-dashboard');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao verificar jornada existente: $e');
    }
  }

  /// Fechar teclado
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  /// Buscar veículo pela placa
  Future<void> _searchVehicle() async {
    _dismissKeyboard();
    
    if (_placaController.text.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'Placa Obrigatória',
        message: 'Por favor, digite a placa do veículo',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.searchVehicle(_placaController.text);
      
      if (response['success'] == true && response['data']['vehicles'].isNotEmpty) {
        final vehicle = response['data']['vehicles'][0];
        
        setState(() {
          _vehicleData = {
            'id': vehicle['id'],
            'placa': vehicle['plate'],
            'marca': vehicle['brand'],
            'modelo': vehicle['model'],
            'ano': vehicle['year'],
            'cor': vehicle['color'],
            'capacidade': vehicle['capacity'],
            'tipoCombustivel': vehicle['fuel_types']?.isNotEmpty == true 
                ? vehicle['fuel_types'][0]['name'] 
                : 'Diesel S10',
            'tiposCombustivel': vehicle['fuel_types']?.map<String>((fuel) => fuel['name'] as String).toList() ?? ['Diesel S10'],
            'fuel_types': vehicle['fuel_types'],
            'transporter': vehicle['transporter'],
            'is_active': vehicle['is_active'],
            'driver_cpf': _userData?['cpf'],
            'driver_name': _userData?['nome'],
            'transporter_cnpj': _userData?['cnpj'],
            'transporter_name': _userData?['empresa'],
          };
          _vehicleSearched = true;
          _vehicleConfirmed = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ErrorDialog.show(
          context,
          title: 'Veículo Não Encontrado',
          message: response['error'] ?? 'Nenhum veículo encontrado com a placa informada.',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ErrorDialog.show(
        context,
        title: 'Erro na Busca',
        message: 'Erro ao buscar veículo: $e',
      );
    }
  }

  /// Confirmar veículo e iniciar jornada
  Future<void> _confirmVehicle() async {
    if (_vehicleData == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Salvar dados no storage local
      final storageService = getIt<StorageService>();
      await storageService.saveJourneyVehicleData(_vehicleData!);
      
      debugPrint('✅ Dados do veículo salvos no storage local');
      debugPrint('📦 Dados: $_vehicleData');
      
      setState(() {
        _vehicleConfirmed = true;
        _isLoading = false;
      });
      
      // Redirecionar para dashboard com os 3 cards
      if (mounted) {
        context.go('/journey-dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ErrorDialog.show(
        context,
        title: 'Erro ao Salvar',
        message: 'Erro ao salvar dados do veículo: $e',
      );
    }
  }

  /// Cancelar seleção de veículo
  void _cancelVehicle() {
    setState(() {
      _vehicleSearched = false;
      _vehicleConfirmed = false;
      _vehicleData = null;
      _placaController.clear();
    });
  }

  /// Realizar logout e limpar todo o storage
  Future<void> _handleLogout() async {
    try {
      final storageService = getIt<StorageService>();
      final apiService = ApiService();
      
      // Limpar tokens
      apiService.clearAuthToken();
      apiService.clearRefreshToken();
      
      // Limpar dados do veículo da jornada
      await storageService.clearJourneyVehicleData();
      
      // Limpar todos os dados do storage
      await storageService.delete('user_data');
      await storageService.delete('access_token');
      await storageService.delete('refresh_token');
      await storageService.delete('saved_cpf');
      
      // Limpar UserService
      final userService = UserService();
      userService.clearUserData();
      
      debugPrint('✅ Logout realizado - Storage limpo');
      
      // Redirecionar para login
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      debugPrint('❌ Erro ao realizar logout: $e');
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro ao Sair',
          message: 'Não foi possível realizar o logout. Tente novamente.',
        );
      }
    }
  }

  /// Mostrar notificações (placeholder)
  void _showNotifications() {
    ErrorDialog.show(
      context,
      title: 'Notificações',
      message: 'Funcionalidade de notificações em desenvolvimento.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zecaBlue,
        elevation: 2,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Menu',
          ),
        ),
        title: const Text(
          'Iniciar Jornada',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: _showNotifications,
            tooltip: 'Notificações',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.zecaBlue, AppColors.zecaBlue.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.zecaBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_userData != null) ...[
                    Text(
                      _userData!['nome'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _userData!['cpf'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.zecaBlue),
              title: const Text('Meu Perfil'),
              onTap: () {
                Navigator.pop(context);
                ErrorDialog.show(
                  context,
                  title: 'Em Desenvolvimento',
                  message: 'Funcionalidade de perfil em desenvolvimento.',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.zecaBlue),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                ErrorDialog.show(
                  context,
                  title: 'Em Desenvolvimento',
                  message: 'Funcionalidade de configurações em desenvolvimento.',
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.zecaBlue),
              title: const Text('Ajuda'),
              onTap: () {
                Navigator.pop(context);
                ErrorDialog.show(
                  context,
                  title: 'Em Desenvolvimento',
                  message: 'Funcionalidade de ajuda em desenvolvimento.',
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context); // Fechar drawer
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmar Saída'),
                    content: const Text('Deseja realmente sair do aplicativo?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleLogout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: _dismissKeyboard,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0 + MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card de Boas-vindas com dados do motorista e transportadora
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppColors.zecaBlue,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Bem-vindo!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.zecaBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (_userData != null) ...[
                                _buildInfoRow(
                                  icon: Icons.badge,
                                  label: 'Motorista',
                                  value: _userData!['nome'],
                                ),
                                _buildInfoRow(
                                  icon: Icons.assignment_ind,
                                  label: 'CPF',
                                  value: _userData!['cpf'],
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  icon: Icons.business,
                                  label: 'Transportadora',
                                  value: _userData!['empresa'],
                                ),
                                _buildInfoRow(
                                  icon: Icons.description,
                                  label: 'CNPJ',
                                  value: _userData!['cnpj'],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Card de Seleção de Veículo
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                Icon(
                  Icons.directions_car,
                  color: AppColors.secondaryRed,
                  size: 24,
                ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Veículo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Campo de Placa
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _placaController,
                                      inputFormatters: [_placaMaskFormatter],
                                      decoration: const InputDecoration(
                                        labelText: 'Placa do Veículo',
                                        hintText: 'ABC-1234',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.pin),
                                      ),
                                      enabled: !_vehicleSearched,
                                      textCapitalization: TextCapitalization.characters,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite a placa do veículo';
                                        }
                                        if (value.length < 7) {
                                          return 'Placa inválida';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _searchVehicle(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: _vehicleSearched ? null : _searchVehicle,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text('Buscar'),
                                  ),
                                ],
                              ),
                              
                              // Resultado da Busca
                              if (_vehicleSearched && _vehicleData != null) ...[
                                const SizedBox(height: 16),
                                Card(
                                  color: Colors.grey[100],
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green[700],
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Veículo Encontrado',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 16),
                                        Text(
                                          '${_vehicleData!['marca']} ${_vehicleData!['modelo']} (${_vehicleData!['ano']})',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildVehicleInfoRow('Placa', _vehicleData!['placa']),
                                        _buildVehicleInfoRow('Cor', _vehicleData!['cor']),
                                        _buildVehicleInfoRow('Combustível', _vehicleData!['tipoCombustivel']),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Botões de Ação
                                if (!_vehicleConfirmed)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: _cancelVehicle,
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: const Text('Cancelar'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: _confirmVehicle,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            backgroundColor: AppColors.secondaryRed,
                                          ),
                                          child: const Text(
                                            'Iniciar Jornada',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Informação adicional
                      Card(
                        color: Colors.blue[50],
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Digite a placa do veículo que você irá utilizar nesta jornada. Após confirmar, você terá acesso às funcionalidades de abastecimento, viagem e checklist.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[900],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

