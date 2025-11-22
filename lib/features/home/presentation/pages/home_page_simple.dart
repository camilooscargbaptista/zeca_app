import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import '../../../../firebase_options.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/odometer_formatter.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../odometer/presentation/pages/odometer_camera_page.dart';

class HomePageSimple extends StatefulWidget {
  const HomePageSimple({Key? key}) : super(key: key);

  @override
  State<HomePageSimple> createState() => _HomePageSimpleState();
}

class _HomePageSimpleState extends State<HomePageSimple> {
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _cnpjPostoController = TextEditingController();
  String _selectedFuel = 'Diesel';
  bool _abastecerArla = false;
  bool _isLoading = false;
  
  // Dados do usuário logado
  Map<String, dynamic>? _userData;
  
  // Estados do fluxo de busca de veículo
  bool _vehicleSearched = false;
  bool _vehicleConfirmed = false;
  Map<String, dynamic>? _vehicleData;
  List<String> _availableFuels = [];
  
  // Estados do fluxo de validação do posto
  bool _isStationValidated = false;
  Map<String, dynamic>? _stationData;
  
  // Contador de abastecimentos pendentes
  int _pendingRefuelingsCount = 0;
  bool _isLoadingPendingCount = false;
  
  // Máscara para placa (formato antigo e Mercosul)
  final _placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA-####',
    filter: {"A": RegExp(r'[A-Za-z0-9]'), "#": RegExp(r'[A-Za-z0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  
  // Máscara para CNPJ
  final _cnpjMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPendingRefuelingsCount();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarregar contador quando voltar para a tela
    _loadPendingRefuelingsCount();
  }


  /// ============================================================
  /// MÉTODOS AUXILIARES
  /// ============================================================

  /// Fechar teclado
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }


  /// Carregar dados do usuário logado do token JWT e UserService
  Future<void> _loadUserData() async {
    try {
      final userService = UserService();
      final storageService = getIt<StorageService>();
      final storedUserData = storageService.getUserData();
      
      // Tentar obter CNPJ do token JWT
      String? cnpjFromToken;
      try {
        final token = await storageService.getAccessToken();
        if (token != null) {
          final decoded = _decodeJwtToken(token);
          cnpjFromToken = decoded['company_cnpj'] as String?;
          debugPrint('🔍 CNPJ do token JWT: $cnpjFromToken');
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao decodificar token JWT: $e');
      }
      
      // Priorizar UserService (dados do login), depois token JWT, depois storage
      if (userService.isLoggedIn) {
        setState(() {
          _userData = {
            'nome': userService.userName ?? storedUserData?['name'] ?? storedUserData?['nome'] ?? 'Motorista',
            'cpf': userService.driverCpf ?? storedUserData?['cpf'] ?? '---',
            'empresa': storedUserData?['company']?['name'] ?? storedUserData?['empresa'] ?? 'Transportadora',
            'cnpj': userService.transporterCnpj ?? cnpjFromToken ?? storedUserData?['company']?['cnpj'] ?? storedUserData?['cnpj'] ?? '---',
            'telefone': storedUserData?['phone'] ?? storedUserData?['telefone'] ?? '---',
            'email': storedUserData?['email'] ?? '---',
          };
        });
        debugPrint('✅ Dados do usuário carregados do UserService');
      } else if (storedUserData != null && storedUserData.isNotEmpty) {
        setState(() {
          _userData = {
            'nome': storedUserData['name'] ?? storedUserData['nome'] ?? 'Motorista',
            'cpf': storedUserData['cpf'] ?? '---',
            'empresa': storedUserData['company']?['name'] ?? storedUserData['empresa'] ?? 'Transportadora',
            'cnpj': cnpjFromToken ?? storedUserData['company']?['cnpj'] ?? storedUserData['cnpj'] ?? '---',
            'telefone': storedUserData['phone'] ?? storedUserData['telefone'] ?? '---',
            'email': storedUserData['email'] ?? '---',
          };
        });
        debugPrint('✅ Dados do usuário carregados do storage');
      } else {
        // Fallback: tentar apenas do token JWT
        if (cnpjFromToken != null) {
          setState(() {
            _userData = {
              'nome': 'Motorista',
              'cpf': '---',
              'empresa': 'Transportadora',
              'cnpj': cnpjFromToken,
              'telefone': '---',
              'email': '---',
            };
          });
          debugPrint('✅ CNPJ carregado do token JWT');
        } else {
          debugPrint('⚠️ Nenhum dado do usuário encontrado');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar dados do usuário: $e');
    }
  }

  /// Decodificar token JWT e extrair payload
  Map<String, dynamic> _decodeJwtToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return {};
      }

      // Decodificar payload (parte 2 do JWT)
      final payload = parts[1];
      // Adicionar padding se necessário
      final normalizedPayload = payload.padRight(
        (payload.length + 3) ~/ 4 * 4,
        '=',
      );
      
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      return payloadMap;
    } catch (e) {
      debugPrint('⚠️ Erro ao decodificar token JWT: $e');
      return {};
    }
  }
  
  /// Carregar contador de abastecimentos pendentes
  Future<void> _loadPendingRefuelingsCount() async {
    if (_isLoadingPendingCount) return;
    
    setState(() {
      _isLoadingPendingCount = true;
    });
    
    try {
      final apiService = ApiService();
      final response = await apiService.getPendingRefuelings();
      
      if (response['success'] == true) {
        final data = response['data'];
        List<dynamic> refuelings = [];
        
        if (data is Map<String, dynamic>) {
          refuelings = data['data'] as List<dynamic>? ?? [];
        } else if (data is List) {
          refuelings = data;
        }
        
        if (mounted) {
          setState(() {
            _pendingRefuelingsCount = refuelings.length;
            _isLoadingPendingCount = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingPendingCount = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar contador de pendentes: $e');
      if (mounted) {
        setState(() {
          _isLoadingPendingCount = false;
        });
      }
    }
  }

  /// Métodos de navegação do menu sanduíche
  void _navigateToGerarAbastecimento() {
    Navigator.of(context).pop(); // Fechar o drawer
    // Por enquanto, a funcionalidade já está na tela principal
    // Pode ser implementada uma navegação específica depois
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gerar Abastecimento - Use o formulário na tela principal'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToRegistrarJornada() {
    Navigator.of(context).pop(); // Fechar o drawer
    context.go('/journey');
  }

  void _navigateToChecklist() {
    Navigator.of(context).pop(); // Fechar o drawer
    ErrorDialog.show(
      context,
      title: 'Checklist',
      message: 'Funcionalidade em desenvolvimento',
    );
  }


  Future<void> _testPushNotification() async {
    try {
      debugPrint('🔍 Iniciando teste de push notification...');
      
      // Verificar se Firebase está inicializado
      try {
        Firebase.app();
        debugPrint('✅ Firebase está inicializado');
      } catch (e) {
        debugPrint('⚠️ Firebase não inicializado, tentando inicializar...');
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          debugPrint('✅ Firebase inicializado com sucesso');
        } catch (initError) {
          debugPrint('❌ Erro ao inicializar Firebase: $initError');
          ErrorDialog.show(
            context,
            title: 'Erro de Firebase',
            message: 'Não foi possível inicializar o Firebase: $initError',
          );
          return;
        }
      }
      
      // Aguardar um pouco para garantir que o Firebase está pronto
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Obter token FCM
      debugPrint('🔍 Tentando obter token FCM...');
      final token = await FirebaseService().getFCMToken();
      
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ Token não obtido, tentando novamente...');
        // Tentar novamente após um delay
        await Future.delayed(const Duration(milliseconds: 1000));
        final tokenRetry = await FirebaseService().getFCMToken();
        
        if (tokenRetry == null || tokenRetry.isEmpty) {
          ErrorDialog.show(
            context,
            title: 'Token não disponível',
            message: 'Token FCM não foi obtido após várias tentativas.\n\nPossíveis causas:\n- Personal Team (conta gratuita) não suporta Push Notifications\n- É necessário Apple Developer Program (conta paga) para push no iOS\n- Verifique os logs do console para mais detalhes',
          );
          return;
        }
        
        // Usar o token da segunda tentativa
        final finalToken = tokenRetry;
        await _showTokenDialog(finalToken);
        return;
      }
      
      // Token obtido com sucesso
      await _showTokenDialog(token);

    } catch (e, stackTrace) {
      debugPrint('❌ Erro ao obter token FCM: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'Erro ao obter token: $e',
      );
    }
  }

  /// Mostrar dialog com token FCM
  Future<void> _showTokenDialog(String token) async {
    // Copiar token para clipboard
    await Clipboard.setData(ClipboardData(text: token));
    debugPrint('✅ Token copiado para clipboard: $token');
    
    // Mostrar dialog com token
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Token FCM (Copiado)'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Token copiado para a área de transferência!',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  token,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Use este token no Firebase Console para enviar uma notificação de teste.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                // Simular deep link de teste
                DeepLinkService().handleDeepLink(
                  context,
                  {
                    'type': 'refueling_validation_pending',
                    'refueling_id': 'test-refueling-id-123',
                  },
                );
                Navigator.of(context).pop();
              },
              child: const Text('Testar Deep Link'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _placaController.dispose();
    _kmController.dispose();
    _cnpjPostoController.dispose();
    super.dispose();
  }

  /// Abre a tela de câmera para capturar odômetro
  Future<void> _openOdometerCamera() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const OdometerCameraPage(),
      ),
    );

    if (result != null && mounted) {
      // Preencher campo com valor extraído
      setState(() {
        _kmController.text = result;
      });
    }
  }


  Future<void> _searchVehicle() async {
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
        
        // Mapear os dados da API real para o formato esperado pela UI
        setState(() {
          _vehicleData = {
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
            'fuel_types': vehicle['fuel_types'], // Manter os dados originais para uso posterior
            'kmAtual': 0, // KM não vem da API, será preenchido pelo usuário
            'transporter': vehicle['transporter'],
            'is_active': vehicle['is_active'],
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

  void _confirmVehicle() {
    if (_vehicleData != null) {
      // Usar os fuel_types originais da API
      final fuelTypes = _vehicleData!['fuel_types'] as List?;
      setState(() {
        _vehicleConfirmed = true;
        if (fuelTypes != null && fuelTypes.isNotEmpty) {
          _availableFuels = fuelTypes.map<String>((fuel) => fuel['name'] as String).toList();
          _selectedFuel = _availableFuels.first;
        } else {
          _availableFuels = ['Diesel S10'];
          _selectedFuel = 'Diesel S10';
        }
        _kmController.clear(); // Campo KM deve ficar vazio para o usuário preencher
      });
    }
  }

  void _cancelVehicle() {
    setState(() {
      _vehicleSearched = false;
      _vehicleConfirmed = false;
      _vehicleData = null;
      _availableFuels = [];
      _placaController.clear();
      _kmController.clear();
      // Limpar também os dados do posto quando trocar veículo
      _isStationValidated = false;
      _stationData = null;
      _cnpjPostoController.clear();
    });
  }

  Future<void> _validateStation() async {
    // Fechar teclado ao validar
    _dismissKeyboard();
    
    if (_cnpjPostoController.text.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'CNPJ Obrigatório',
        message: 'Por favor, digite o CNPJ do posto',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      // Remover formatação do CNPJ (apenas números)
      final cnpjSemFormatacao = _cnpjPostoController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final response = await apiService.validateStation(cnpjSemFormatacao);
      
      if (response['success'] == true) {
        final data = response['data'];
        
        // Mapear os dados da API real para o formato esperado pela UI
        setState(() {
          _stationData = {
            'nome': data['station']['name'],
            'endereco': '${data['station']['address']['street']}, ${data['station']['address']['number']}',
            'cidade': '${data['station']['address']['city']} - ${data['station']['address']['state']}',
            'cnpj': data['station']['cnpj'],
            'partnership': data['partnership'],
            'terms': data['terms'],
            'fuel_prices': data['fuel_prices'],
            // Preços dos combustíveis - pegar o primeiro preço disponível como exemplo
            'preco': data['fuel_prices']?.isNotEmpty == true
                ? double.parse(data['fuel_prices'][0]['price_per_liter'])
                : 0.0,
            'precoArla': 8.50, // ARLA não vem da API, manter valor fixo por enquanto
          };
          _isStationValidated = true;
          _isLoading = false;
        });
        
        // Scroll automático para o final da tela após validar CNPJ
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ErrorDialog.show(
          context,
          title: 'Posto Não Encontrado',
          message: response['error'] ?? 'Posto não encontrado ou não possui parceria ativa.',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ErrorDialog.show(
        context,
        title: 'Erro na Validação',
        message: 'Erro ao validar posto: $e',
      );
    }
  }

  Future<void> _handleGenerateCode() async {
    // Validar KM (remover formatação antes de validar)
    final kmText = _kmController.text.trim();
    final kmValue = OdometerFormatter.parseFormattedValue(kmText);
    
    if (!_vehicleConfirmed || kmText.isEmpty || kmValue <= 0 || !_isStationValidated) {
      ErrorDialog.show(
        context,
        title: 'Dados Incompletos',
        message: 'Por favor, confirme o veículo, preencha o KM e valide o posto',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      
      // Mapear o tipo de combustível para o formato da API
      String fuelTypeApi = _selectedFuel;
      if (_selectedFuel == 'Diesel S10') {
        fuelTypeApi = 'DIESEL_S10';
      } else if (_selectedFuel == 'Diesel B5') {
        fuelTypeApi = 'DIESEL_B5';
      } else if (_selectedFuel == 'Diesel') {
        fuelTypeApi = 'DIESEL_S10'; // Default para Diesel S10
      }
      
      final codeResponse = await apiService.generateRefuelingCode(
        vehiclePlate: _vehicleData!['placa'],
        fuelType: fuelTypeApi,
        stationCnpj: _stationData!['cnpj'],
        abastecerArla: _abastecerArla,
      );

      if (codeResponse['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        
        // Navegar diretamente para a página do código com os dados
        if (mounted) {
          context.go('/refueling-code', extra: {
            'id': codeResponse['data']['id'], // ID do abastecimento para polling
            'code': codeResponse['data']['code'],
            'expires_at': codeResponse['data']['expires_at'],
            'status': codeResponse['data']['status'],
            'created_at': codeResponse['data']['created_at'],
            'vehicle_data': _vehicleData,
            'station_data': _stationData,
            'fuel_type': _selectedFuel,
            'km_atual': OdometerFormatter.parseFormattedValue(_kmController.text), // Converter valor formatado para número
            'abastecer_arla': _abastecerArla,
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        
        // Se erro de autenticação, redirecionar para login
        if (codeResponse['error']?.toString().toLowerCase().contains('não autorizado') == true ||
            codeResponse['error']?.toString().toLowerCase().contains('unauthorized') == true) {
          // Limpar tokens e redirecionar para login
          final apiService = ApiService();
          apiService.clearAuthToken();
          apiService.clearRefreshToken();
          
          ErrorDialog.show(
            context,
            title: 'Sessão Expirada',
            message: 'Sua sessão expirou. Faça login novamente.',
          );
          
          // Redirecionar para login após mostrar o erro
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go('/login');
            }
          });
        } else {
          ErrorDialog.show(
            context,
            title: 'Erro ao Gerar Código',
            message: codeResponse['error'] ?? 'Erro ao gerar código de abastecimento',
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'Erro: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zecaBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/journey-dashboard');
          },
          tooltip: 'Voltar',
        ),
        title: const Text(
          'Abastecimento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Botão para abastecimentos pendentes com badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.pending_actions, color: Colors.white),
                onPressed: () async {
                  await context.push('/pending-refuelings');
                  // Recarregar contador ao voltar
                  _loadPendingRefuelingsCount();
                },
                tooltip: 'Abastecimentos Pendentes',
              ),
              if (_pendingRefuelingsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _pendingRefuelingsCount > 99 ? '99+' : '$_pendingRefuelingsCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 16.0 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner de alerta para abastecimentos pendentes
            if (_pendingRefuelingsCount > 0) ...[
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                color: Colors.orange[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.orange[300]!, width: 2),
                ),
                child: InkWell(
                  onTap: () async {
                    await context.push('/pending-refuelings');
                    _loadPendingRefuelingsCount();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange[800],
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Abastecimentos Pendentes',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[900],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _pendingRefuelingsCount == 1
                                    ? 'Você tem 1 abastecimento aguardando validação'
                                    : 'Você tem $_pendingRefuelingsCount abastecimentos aguardando validação',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange[800],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            // Card de Boas-vindas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.zecaBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_userData != null) ...[
                      Text(
                        _userData!['nome'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('CPF: ${_userData!['cpf']}'),
                      Text(_userData!['empresa']),
                      Text('CNPJ: ${_userData!['cnpj']}'),
                    ],
                  ],
                ),
              ),
            ),
            
            // Card de Busca de Veículo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.directions_car, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'CONFIRME A PLACA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _placaController,
                            inputFormatters: [_placaMaskFormatter],
                            decoration: const InputDecoration(
                              labelText: 'Placa',
                              hintText: 'ABC-1234',
                              border: OutlineInputBorder(),
                            ),
                            enabled: !_vehicleSearched,
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _vehicleSearched ? null : _searchVehicle,
                          child: const Text('Buscar'),
                        ),
                      ],
                    ),
                    if (_vehicleSearched && _vehicleData != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_vehicleData!['marca']} ${_vehicleData!['modelo']} ${_vehicleData!['ano']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Combustível: ${_vehicleData!['tipoCombustivel']}'),
                              Text('Último KM: ${_vehicleData!['kmAtual']}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!_vehicleConfirmed)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancelVehicle,
                                child: const Text('Cancelar'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _confirmVehicle,
                                child: const Text('Confirmar'),
                              ),
                            ),
                          ],
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _cancelVehicle,
                            child: const Text('Trocar Veículo'),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Card de CNPJ do Posto (mostrar APENAS após confirmar veículo)
            if (_vehicleConfirmed) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CNPJ do Posto',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cnpjPostoController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_cnpjMaskFormatter],
                              decoration: const InputDecoration(
                                labelText: 'CNPJ do Posto',
                                hintText: '00.000.000/0000-00',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isStationValidated ? null : _validateStation,
                            child: const Text('Validar'),
                          ),
                        ],
                      ),
                      if (_isStationValidated && _stationData != null) ...[
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.green[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.local_gas_station, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _stationData!['nome'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _stationData!['partnership']['is_active'] 
                                            ? Colors.green 
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _stationData!['partnership']['is_active'] 
                                            ? 'Parceria Ativa' 
                                            : 'Parceria Inativa',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(_stationData!['endereco']),
                                Text(_stationData!['cidade']),
                                const SizedBox(height: 12),
                                
                                // Preço do combustível selecionado
                                if (_stationData!['fuel_prices'] != null && 
                                    (_stationData!['fuel_prices'] as List).isNotEmpty) ...[
                                  Builder(
                                    builder: (context) {
                                      // Encontrar o preço do combustível selecionado
                                      final selectedFuelPrice = (_stationData!['fuel_prices'] as List).firstWhere(
                                        (fuelPrice) => fuelPrice['fuel_type']['name'] == _selectedFuel,
                                        orElse: () => null,
                                      );
                                      
                                      if (selectedFuelPrice != null) {
                                        return Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.blue[300]!, Colors.blue[600]!],
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  selectedFuelPrice['fuel_type']['name'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'R\$ ${double.parse(selectedFuelPrice['price_per_liter']).toStringAsFixed(2)}/L',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        // Se não encontrar, mostrar o primeiro disponível
                                        final firstFuelPrice = (_stationData!['fuel_prices'] as List).first;
                                        return Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.blue[300]!, Colors.blue[600]!],
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  firstFuelPrice['fuel_type']['name'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'R\$ ${double.parse(firstFuelPrice['price_per_liter']).toStringAsFixed(2)}/L',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ] else ...[
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.green[300]!, Colors.green[600]!],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Valor do Combustível',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'R\$ ${_stationData!['preco']}/L',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                
                                if (_selectedFuel == 'Diesel' && _abastecerArla) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.orange[300]!, Colors.orange[600]!],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Valor do ARLA 32',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'R\$ ${_stationData!['precoArla']}/L',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            
            // Card de Dados do Abastecimento (mostrar APENAS após validar CNPJ)
            if (_vehicleConfirmed && _isStationValidated) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.local_gas_station, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Abastecimento',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _kmController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          OdometerFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'KM Atual',
                          border: const OutlineInputBorder(),
                          hintText: '0',
                          helperText: 'Digite apenas números (ex: 123456 = 123.456)',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.red),
                            onPressed: _openOdometerCamera,
                            tooltip: 'Capturar odômetro com câmera',
                          ),
                        ),
                      ),
                      if (_vehicleData != null)
                        Text(
                          'Último KM: ${_vehicleData!['kmAtual']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      const SizedBox(height: 16),
                      if (_availableFuels.length > 1)
                        DropdownButtonFormField<String>(
                          value: _selectedFuel,
                          decoration: const InputDecoration(
                            labelText: 'Combustível',
                            border: OutlineInputBorder(),
                          ),
                          items: _availableFuels.map((fuel) {
                            return DropdownMenuItem(value: fuel, child: Text(fuel));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFuel = value!;
                            });
                          },
                        )
                      else
                        TextFormField(
                          initialValue: _selectedFuel,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Combustível',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (_selectedFuel.toLowerCase().contains('diesel'))
                        Row(
                          children: [
                            Checkbox(
                              value: _abastecerArla,
                              onChanged: (value) {
                                setState(() {
                                  _abastecerArla = value ?? false;
                                });
                              },
                            ),
                            const Text('Abastecer ARLA 32'),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
            
            // Botão Gerar Código
            if (_vehicleConfirmed && _isStationValidated) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleGenerateCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Gerando...'),
                        ],
                      )
                    : const Text(
                        'GERAR CÓDIGO DE ABASTECIMENTO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    ),
    );
  }
}