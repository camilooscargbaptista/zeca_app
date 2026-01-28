import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/app_drawer.dart';
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
  
  // NOVO: Estatísticas do veículo (para card de resumo)
  Map<String, dynamic>? _vehicleStats;
  bool _loadingStats = false;
  
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
      
      // Buscar stats do veículo
      _fetchVehicleStats(selected['plate']);
    }
  }
  
  /// Buscar estatísticas do veículo (último KM, consumo médio, abast. do mês)
  Future<void> _fetchVehicleStats(String plate) async {
    setState(() {
      _loadingStats = true;
    });
    
    try {
      final apiService = ApiService();
      final cleanPlate = plate.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
      final response = await apiService.get('/vehicles/$cleanPlate/stats');
      
      debugPrint('📊 Stats do veículo $cleanPlate: $response');
      
      if (mounted && response != null) {
        setState(() {
          _vehicleStats = {
            'last_odometer': response['last_odometer'],
            'average_consumption': response['average_consumption'],
            'refuelings_this_month': response['refuelings_this_month'],
          };
          _loadingStats = false;
        });
      } else {
        setState(() {
          _loadingStats = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar stats do veículo: $e');
      setState(() {
        _loadingStats = false;
      });
    }
  }

  /// Navegar para cadastrar novo veículo
  void _navigateToAddVehicle() {
    // TODO: Implementar navegação para tela de cadastro de veículo
    ErrorDialog.show(
      context,
      title: 'Cadastro de Veículo',
      message: 'Para cadastrar um novo veículo, acesse o portal web em abastecacomzeca.com.br ou entre em contato com o suporte.',
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
      drawer: const AppDrawer(),
      // NOVO: Botão fixo no rodapé
      bottomNavigationBar: _vehicleSearched && _vehicleData != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zecaBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Iniciar Jornada',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            )
          : null,
      body: _isLoading && !_vehicleSearched
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: _dismissKeyboard,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: _vehicleSearched ? 100.0 : 16.0 + MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildWelcomeCard(),
                      const SizedBox(height: 16),
                      _buildVehicleCard(),
                      // NOVO: Card de estatísticas quando veículo selecionado
                      if (_vehicleSearched && _vehicleData != null) ...[
                        const SizedBox(height: 16),
                        _buildVehicleStatsCard(),
                      ],
                      const SizedBox(height: 16),
                      // Hint compacto
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: Colors.blue[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Selecione um veículo para iniciar sua jornada de trabalho.',
                                style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
  /// NOVO: Card de estatísticas do veículo
  Widget _buildVehicleStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.analytics_outlined, color: Colors.orange[700], size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Resumo do Veículo',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _loadingStats
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.speed,
                        label: 'Último KM',
                        value: _formatOdometer(_vehicleStats?['last_odometer']),
                        color: Colors.blue,
                      ),
                      _buildStatItem(
                        icon: Icons.local_gas_station,
                        label: 'Km/L Médio',
                        value: _vehicleStats?['average_consumption']?.toString() ?? '--',
                        color: Colors.green,
                      ),
                      _buildStatItem(
                        icon: Icons.calendar_month,
                        label: 'Abast. Mês',
                        value: _vehicleStats?['refuelings_this_month']?.toString() ?? '0',
                        color: Colors.purple,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
  
  /// Formatar odômetro para display
  String _formatOdometer(dynamic value) {
    if (value == null) return '--';
    final intValue = value is double ? value.toInt() : int.tryParse(value.toString()) ?? 0;
    final formatted = intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return formatted;
  }
  
  /// Widget para cada item de estatística
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // REMOVIDO: _buildDrawer() - Agora usa AppDrawer unificado (lib/shared/widgets/app_drawer.dart)

  Widget _buildWelcomeCard() {
    // Extrair iniciais do nome
    String initials = '';
    if (_userData != null && _userData!['nome'] != null) {
      final names = _userData!['nome'].toString().split(' ');
      if (names.length >= 2) {
        initials = '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
      } else if (names.isNotEmpty) {
        initials = names[0].substring(0, 2).toUpperCase();
      }
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar com iniciais
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.zecaBlue, AppColors.zecaBlue.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userData?['nome'] ?? 'Motorista',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'CPF: ${_userData?['cpf'] ?? '---'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Badge Autônomo ou Frota
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _isAutonomous ? Colors.blue[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _isAutonomous ? 'Autônomo' : 'Frota',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _isAutonomous ? Colors.blue[800] : Colors.green[800],
                ),
              ),
            ),
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
              // FROTA: Ocultar campo de busca quando veículo já foi selecionado
              if (!_vehicleSearched || _vehicleData == null)
                _buildFleetVehicleSearch(),
            
            // Resultado quando veículo selecionado/buscado
            if (_vehicleSearched && _vehicleData != null) ...[
              const SizedBox(height: 16),
              _buildVehicleResult(),
              // FROTA: Botões inline removidos (botão Iniciar está no rodapé)
              // AUTONOMO: Mantém os botões inline
              if (!_vehicleConfirmed && _isAutonomous) ...[
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
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
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToAddVehicle,
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Adicionar Novo Veículo',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              minimumSize: const Size(double.infinity, 52),
            ),
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
                const Spacer(),
                // FROTA: Link Trocar para trocar de veículo
                if (!_isAutonomous)
                  GestureDetector(
                    onTap: _cancelVehicle,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swap_horiz, color: AppColors.zecaBlue, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Trocar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.zecaBlue,
                          ),
                        ),
                      ],
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
