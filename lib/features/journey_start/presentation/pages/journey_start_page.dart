import 'dart:convert';
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
  
  // NOVO: Estado para motorista autônomo
  bool _isAutonomous = false;
  List<Map<String, dynamic>> _autonomousVehicles = [];
  String? _selectedVehicleId;
  bool _loadingVehicles = false;
  
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

  /// Carregar dados do usuário logado e verificar se é autônomo
  Future<void> _loadUserData() async {
    try {
      final userService = UserService();
      final storageService = getIt<StorageService>();
      final storedUserData = storageService.getUserData();
      final apiService = ApiService();
      
      debugPrint('🔍 Carregando dados do usuário...');
      
      // Verificar se é autônomo via token JWT
      bool isAutonomousFromToken = false;
      try {
        final token = await apiService.getToken();
        if (token != null && token.isNotEmpty) {
          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
            final decoded = jsonDecode(payload);
            isAutonomousFromToken = decoded['is_autonomous'] == true || 
                                    decoded['role'] == 'MOTORISTA_AUTONOMO';
            debugPrint('🔑 JWT is_autonomous: $isAutonomousFromToken, role: ${decoded['role']}');
          }
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao decodificar JWT: $e');
      }
      
      // Também verificar no storedUserData
      final isAutonomousFromStorage = storedUserData?['is_autonomous'] == true;
      
      setState(() {
        _isAutonomous = isAutonomousFromToken || isAutonomousFromStorage;
      });
      
      debugPrint('🚗 Usuário é autônomo: $_isAutonomous');
      
      // Carregar dados do usuário
      if (userService.isLoggedIn) {
        setState(() {
          _userData = {
            'nome': userService.userName ?? storedUserData?['name'] ?? storedUserData?['nome'] ?? 'Motorista',
            'cpf': userService.driverCpf ?? storedUserData?['cpf'] ?? '---',
            'empresa': storedUserData?['company']?['name'] ?? storedUserData?['empresa'] ?? 'Transportadora',
            'cnpj': userService.transporterCnpj ?? storedUserData?['company']?['cnpj'] ?? storedUserData?['cnpj'] ?? '---',
            'telefone': storedUserData?['phone'] ?? storedUserData?['telefone'] ?? '---',
            'email': storedUserData?['email'] ?? '---',
            'isAutonomous': _isAutonomous,
          };
        });
        
        // Se for autônomo, mostrar (Autônomo) no nome da empresa
        if (_isAutonomous) {
          setState(() {
            _userData!['empresa'] = '${_userData!['nome']} (Autônomo)';
          });
        }
        
        debugPrint('✅ Dados carregados. isAutonomous: $_isAutonomous');
      } else if (storedUserData != null && storedUserData.isNotEmpty) {
        setState(() {
          _userData = {
            'nome': storedUserData['name'] ?? storedUserData['nome'] ?? 'Motorista',
            'cpf': storedUserData['cpf'] ?? '---',
            'empresa': storedUserData['company']?['name'] ?? storedUserData['empresa'] ?? 'Transportadora',
            'cnpj': storedUserData['company']?['cnpj'] ?? storedUserData['cnpj'] ?? '---',
            'telefone': storedUserData['phone'] ?? storedUserData['telefone'] ?? '---',
            'email': storedUserData['email'] ?? '---',
            'isAutonomous': _isAutonomous,
          };
        });
        
        if (_isAutonomous) {
          setState(() {
            _userData!['empresa'] = '${_userData!['nome']} (Autônomo)';
          });
        }
      } else {
        setState(() {
          _userData = {
            'nome': 'Motorista',
            'cpf': '---',
            'empresa': 'Transportadora',
            'cnpj': '---',
            'telefone': '---',
            'email': '---',
            'isAutonomous': _isAutonomous,
          };
        });
      }
      
      // Se for autônomo, carregar veículos cadastrados
      if (_isAutonomous) {
        await _loadAutonomousVehicles();
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar dados do usuário: $e');
      setState(() {
        _userData = {
          'nome': 'Motorista',
          'cpf': '---',
          'empresa': 'Transportadora',
          'cnpj': '---',
          'telefone': '---',
          'email': '---',
          'isAutonomous': false,
        };
      });
    }
  }

  /// Carregar veículos do motorista autônomo
  Future<void> _loadAutonomousVehicles() async {
    setState(() {
      _loadingVehicles = true;
    });
    
    try {
      final apiService = ApiService();
      final response = await apiService.getMyVehicles();
      
      debugPrint('📦 Resposta getMyVehicles: $response');
      
      if (response['success'] == true && response['data'] != null) {
        final vehiclesList = response['data']['vehicles'] as List<dynamic>? ?? [];
        
        setState(() {
          _autonomousVehicles = vehiclesList.map<Map<String, dynamic>>((v) {
            return {
              'id': v['id'],
              'plate': v['plate'] ?? v['placa'],
              'plateFormatted': _formatPlate(v['plate'] ?? v['placa'] ?? ''),
              'brand': v['brand'] ?? v['marca'],
              'model': v['model'] ?? v['modelo'],
              'year': v['year'] ?? v['ano'],
              'color': v['color'] ?? v['cor'],
              'fuelType': _extractFuelType(v),
              'fuel_types': v['fuel_types'],
              'is_active': v['is_active'] ?? true,
            };
          }).where((v) => v['is_active'] == true).toList();
          _loadingVehicles = false;
        });
        
        debugPrint('✅ ${_autonomousVehicles.length} veículos ativos carregados');
      } else {
        debugPrint('⚠️ Nenhum veículo encontrado ou erro: ${response['error']}');
        setState(() {
          _loadingVehicles = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar veículos: $e');
      setState(() {
        _loadingVehicles = false;
      });
    }
  }

  /// Formatar placa com hífen
  String _formatPlate(String plate) {
    final clean = plate.replaceAll('-', '').toUpperCase();
    if (clean.length >= 7) {
      return '${clean.substring(0, 3)}-${clean.substring(3, 7)}';
    }
    return plate;
  }

  /// Extrair tipo de combustível
  String _extractFuelType(Map<String, dynamic> vehicle) {
    if (vehicle['fuel_types'] != null && vehicle['fuel_types'] is List && vehicle['fuel_types'].isNotEmpty) {
      return vehicle['fuel_types'][0]['name'] ?? 'Diesel S10';
    }
    return vehicle['fuelType'] ?? vehicle['tipoCombustivel'] ?? 'Diesel S10';
  }

  /// Verificar se já existe uma jornada iniciada
  Future<void> _checkExistingJourney() async {
    try {
      final storageService = getIt<StorageService>();
      final vehicleData = await storageService.getJourneyVehicleData();
      
      if (vehicleData != null && vehicleData.isNotEmpty) {
        if (mounted) {
          context.go('/journey-dashboard');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao verificar jornada existente: $e');
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  /// Selecionar veículo do dropdown (autônomo)
  void _selectVehicle(String? vehicleId) {
    if (vehicleId == null) return;
    
    final selected = _autonomousVehicles.firstWhere(
      (v) => v['id'] == vehicleId,
      orElse: () => {},
    );
    
    if (selected.isNotEmpty) {
      setState(() {
        _selectedVehicleId = vehicleId;
        _vehicleData = {
          'id': selected['id'],
          'placa': selected['plate'],
          'marca': selected['brand'],
          'modelo': selected['model'],
          'ano': selected['year'],
          'cor': selected['color'],
          'tipoCombustivel': selected['fuelType'],
          'tiposCombustivel': selected['fuel_types']?.map<String>((f) => f['name'] as String).toList() ?? [selected['fuelType'] ?? 'Diesel S10'],
          'fuel_types': selected['fuel_types'],
          'driver_cpf': _userData?['cpf'],
          'driver_name': _userData?['nome'],
          'transporter_cnpj': _userData?['cnpj'],
          'transporter_name': _userData?['empresa'],
        };
        _vehicleSearched = true;
      });
      
      debugPrint('✅ Veículo selecionado: ${selected['plate']} - ${selected['brand']} ${selected['model']}');
    }
  }

  /// Navegar para cadastrar novo veículo
  void _navigateToAddVehicle() {
    // TODO: Implementar navegação para tela de cadastro de veículo
    ErrorDialog.show(
      context,
      title: 'Em Desenvolvimento',
      message: 'A tela de cadastro de veículo será implementada em breve.',
    );
  }

  /// Buscar veículo pela placa (para frotista)
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
      final storageService = getIt<StorageService>();
      await storageService.saveJourneyVehicleData(_vehicleData!);
      
      debugPrint('✅ Dados do veículo salvos no storage local');
      debugPrint('📦 Dados: $_vehicleData');
      
      setState(() {
        _vehicleConfirmed = true;
        _isLoading = false;
      });
      
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
      _selectedVehicleId = null;
      _placaController.clear();
    });
  }

  /// Realizar logout
  Future<void> _handleLogout() async {
    try {
      final storageService = getIt<StorageService>();
      final apiService = ApiService();
      
      apiService.clearAuthToken();
      apiService.clearRefreshToken();
      await storageService.clearJourneyVehicleData();
      await storageService.delete('user_data');
      await storageService.delete('access_token');
      await storageService.delete('refresh_token');
      await storageService.delete('saved_cpf');
      
      final userService = UserService();
      userService.clearUserData();
      
      debugPrint('✅ Logout realizado');
      
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
      drawer: _buildDrawer(),
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
                      _buildWelcomeCard(),
                      const SizedBox(height: 24),
                      _buildVehicleCard(),
                      const SizedBox(height: 24),
                      _buildInfoCard(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
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
                  Row(
                    children: [
                      Text(
                        _userData!['cpf'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (_isAutonomous) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Autônomo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
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
              ErrorDialog.show(context, title: 'Em Desenvolvimento', message: 'Funcionalidade de perfil em desenvolvimento.');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.zecaBlue),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              ErrorDialog.show(context, title: 'Em Desenvolvimento', message: 'Funcionalidade de configurações em desenvolvimento.');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppColors.zecaBlue),
            title: const Text('Ajuda'),
            onTap: () {
              Navigator.pop(context);
              ErrorDialog.show(context, title: 'Em Desenvolvimento', message: 'Funcionalidade de ajuda em desenvolvimento.');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: AppColors.zecaBlue, size: 28),
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
              _buildInfoRow(icon: Icons.badge, label: 'Motorista', value: _userData!['nome']),
              _buildInfoRow(icon: Icons.assignment_ind, label: 'CPF', value: _userData!['cpf']),
              const Divider(height: 24),
              _buildInfoRow(icon: Icons.business, label: 'Transportadora', value: _userData!['empresa']),
              _buildInfoRow(icon: Icons.description, label: 'CNPJ', value: _userData!['cnpj']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: AppColors.secondaryRed, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isAutonomous ? 'Selecione o Veículo' : 'Veículo',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // DIFERENTE PARA AUTÔNOMO VS FROTA
            if (_isAutonomous)
              _buildAutonomousVehicleSelector()
            else
              _buildFleetVehicleSearch(),
            
            // Resultado quando veículo selecionado/buscado
            if (_vehicleSearched && _vehicleData != null) ...[
              const SizedBox(height: 16),
              _buildVehicleResult(),
              const SizedBox(height: 16),
              if (!_vehicleConfirmed) _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget para autônomo: dropdown de veículos + botão adicionar
  Widget _buildAutonomousVehicleSelector() {
    if (_loadingVehicles) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_autonomousVehicles.isEmpty) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.directions_car_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'Você ainda não tem veículos cadastrados.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _navigateToAddVehicle,
                  icon: const Icon(Icons.add),
                  label: const Text('Cadastrar Veículo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zecaBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        // Dropdown de veículos
        DropdownButtonFormField<String>(
          value: _selectedVehicleId,
          decoration: InputDecoration(
            labelText: 'Selecione um veículo',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.local_shipping, color: AppColors.zecaBlue),
          ),
          items: _autonomousVehicles.map((v) {
            final displayText = '${v['plateFormatted']} - ${v['brand']} ${v['model']} ${v['year'] ?? ''}';
            return DropdownMenuItem<String>(
              value: v['id'] as String,
              child: Text(
                displayText.trim(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: _vehicleSearched ? null : _selectVehicle,
          isExpanded: true,
        ),
        
        const SizedBox(height: 12),
        
        // Texto "Ou"
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Ou', style: TextStyle(color: Colors.grey[600])),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Botão adicionar novo veículo
        OutlinedButton.icon(
          onPressed: _navigateToAddVehicle,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Novo Veículo'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  /// Widget para frotista: campo de placa + buscar
  Widget _buildFleetVehicleSearch() {
    return Row(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: const Text('Buscar'),
        ),
      ],
    );
  }

  Widget _buildVehicleResult() {
    return Card(
      color: Colors.grey[100],
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Veículo Selecionado',
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
              '${_vehicleData!['marca']} ${_vehicleData!['modelo']} (${_vehicleData!['ano'] ?? '-'})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildVehicleInfoRow('Placa', _vehicleData!['placa']),
            if (_vehicleData!['cor'] != null)
              _buildVehicleInfoRow('Cor', _vehicleData!['cor']),
            _buildVehicleInfoRow('Combustível', _vehicleData!['tipoCombustivel'] ?? 'Diesel S10'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isAutonomous
                    ? 'Selecione o veículo que você irá utilizar nesta jornada. Após confirmar, você terá acesso às funcionalidades de abastecimento.'
                    : 'Digite a placa do veículo que você irá utilizar nesta jornada. Após confirmar, você terá acesso às funcionalidades de abastecimento, viagem e checklist.',
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
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
