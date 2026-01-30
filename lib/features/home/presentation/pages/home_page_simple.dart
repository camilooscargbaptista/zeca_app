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
  bool _hasArlaAvailable = false; // Indica se o posto tem ARLA disponível
  double _arlaPrice = 0.0; // Preço do ARLA por litro
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
  
  // Último KM registrado do veículo
  double? _lastOdometer;
  String? _lastOdometerDate;
  bool _showKmWarning = false;
  
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJourneyOnStart();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarregar contador quando voltar para a tela
    _loadPendingRefuelingsCount();
  }

  Future<void> _loadJourneyOnStart() async {
    try {
      final storage = getIt<StorageService>();
      final vehicleData = await storage.getJourneyVehicleData();
      
      if (vehicleData != null && mounted) {
        debugPrint('🚗 [HomePage] Dados da jornada carregados: ${vehicleData['placa']}');
        setState(() {
          _vehicleData = vehicleData;
          _placaController.text = vehicleData['placa'] ?? '';
          _kmController.text = vehicleData['km_atual']?.toString() ?? '';
          
          // Tentar extrair combustivel (pode vir como 'tipo_combustivel' ou 'fuel_type')
          String fuel = vehicleData['tipo_combustivel'] ?? vehicleData['fuel_type'] ?? 'Diesel';
          // Validar se fuel está na lista de available, se não, adicionar
          if (!_availableFuels.contains(fuel)) {
             _availableFuels = [fuel, 'Diesel', 'Gasolina', 'Etanol']; 
          }
          _selectedFuel = fuel;
          
          _vehicleSearched = true;
          _vehicleConfirmed = true; // Auto-confirmar para habilitar o fluxo
        });
        
        // Buscar estatísticas do veículo (último KM e consumo médio)
        _fetchVehicleStats(vehicleData['placa'] ?? '');
      } else {
        debugPrint('⚠️ [HomePage] Nenhuma jornada ativa encontrada no storage.');
        // Opcional: Redirecionar para seleção de jornada ou mostrar aviso
      }
    } catch (e) {
      debugPrint('❌ [HomePage] Erro ao carregar jornada: $e');
    }
  }


  /// ============================================================
  /// MÉTODOS AUXILIARES
  /// ============================================================

  /// Fechar teclado
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }
  
  Widget _buildVehicleDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


  /// Carregar dados do usuário logado do token JWT e UserService
  Future<void> _loadUserData() async {
    try {
      final userService = UserService();
      final storageService = getIt<StorageService>();
      final storedUserData = storageService.getUserData();
      
      // Tentar obter CNPJ e is_autonomous do token JWT
      String? cnpjFromToken;
      bool isAutonomousFromToken = false;
      try {
        final token = await storageService.getAccessToken();
        if (token != null) {
          final decoded = _decodeJwtToken(token);
          cnpjFromToken = decoded['company_cnpj'] as String?;
          isAutonomousFromToken = decoded['is_autonomous'] == true;
          debugPrint('🔍 CNPJ do token JWT: $cnpjFromToken');
          debugPrint('🔍 is_autonomous do token: $isAutonomousFromToken');
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
            // Priorizar is_autonomous do JWT token (mais confiável)
            'isAutonomous': isAutonomousFromToken || storedUserData?['is_autonomous'] == true,
          };
        });
        debugPrint('✅ Dados do usuário carregados do UserService (isAutonomous: ${_userData!['isAutonomous']})');
      } else if (storedUserData != null && storedUserData.isNotEmpty) {
        setState(() {
          _userData = {
            'nome': storedUserData['name'] ?? storedUserData['nome'] ?? 'Motorista',
            'cpf': storedUserData['cpf'] ?? '---',
            'empresa': storedUserData['company']?['name'] ?? storedUserData['empresa'] ?? 'Transportadora',
            'cnpj': cnpjFromToken ?? storedUserData['company']?['cnpj'] ?? storedUserData['cnpj'] ?? '---',
            'telefone': storedUserData['phone'] ?? storedUserData['telefone'] ?? '---',
            'email': storedUserData['email'] ?? '---',
            'isAutonomous': isAutonomousFromToken || storedUserData['is_autonomous'] == true,
          };
        });
        debugPrint('✅ Dados do usuário carregados do storage (isAutonomous: ${_userData!['isAutonomous']})');
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
              'isAutonomous': isAutonomousFromToken,
            };
          });
          debugPrint('✅ CNPJ carregado do token JWT (isAutonomous: $isAutonomousFromToken)');
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

  /// Busca estatísticas do veículo (consumo médio e último KM)
  /// Chamada única para /drivers/dashboard-summary que retorna ambos os dados
  Future<void> _fetchVehicleStats(String plate) async {
    if (plate.isEmpty) return;
    
    try {
      // Usar ApiService() direto (padrão usado em journey_dashboard_page)
      final apiService = ApiService();
      final cleanPlate = plate.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
      
      debugPrint('🔍 [HomePage] Buscando stats do veículo: $cleanPlate');
      final response = await apiService.get('/drivers/dashboard-summary?plate=$cleanPlate');
      
      debugPrint('📊 [HomePage] Resposta dashboard-summary: $response');
      
      if (mounted && response != null && response is Map<String, dynamic>) {
        // Navegar estrutura (pode ter duplo wrapper: data.data)
        Map<String, dynamic>? data;
        
        if (response['success'] == true && response['data'] != null) {
          final level1 = response['data'];
          if (level1 is Map<String, dynamic>) {
            // Verificar se tem segundo nível (duplo wrapper)
            if (level1['success'] == true && level1['data'] != null) {
              data = level1['data'] as Map<String, dynamic>;
              debugPrint('📊 [HomePage] Duplo wrapper detectado, usando data.data');
            } else if (level1['economy'] != null || level1['vehicle'] != null) {
              data = level1;
              debugPrint('📊 [HomePage] Single wrapper, usando data');
            }
          }
        } else if (response['economy'] != null || response['vehicle'] != null) {
          data = response;
          debugPrint('📊 [HomePage] Sem wrapper, usando response direto');
        }
        
        if (data != null) {
          // Extrair economy
          final economy = data['economy'] as Map<String, dynamic>?;
          final avgConsumption = economy?['avg_consumption'];
          
          // Extrair vehicle
          final vehicle = data['vehicle'] as Map<String, dynamic>?;
          final lastOdometer = vehicle?['last_odometer'];
          
          debugPrint('✅ [HomePage] avg_consumption: $avgConsumption');
          debugPrint('✅ [HomePage] last_odometer: $lastOdometer');
          
          setState(() {
            if (_vehicleData != null) {
              // Consumo médio
              if (avgConsumption != null) {
                _vehicleData!['consumo_medio'] = avgConsumption is num 
                    ? avgConsumption.toDouble() 
                    : double.tryParse(avgConsumption.toString()) ?? 0.0;
                _vehicleData!['avg_consumption'] = avgConsumption;
              }
              
              // Último KM
              if (lastOdometer != null) {
                final lastOdometerValue = lastOdometer is num 
                    ? lastOdometer.toInt() 
                    : int.tryParse(lastOdometer.toString()) ?? 0;
                _vehicleData!['ultimo_km'] = lastOdometerValue;
                _vehicleData!['last_odometer'] = lastOdometerValue;
                _lastOdometer = lastOdometerValue.toDouble();
              }
              
              debugPrint('✅ [HomePage] _vehicleData atualizado: ultimo_km=${_vehicleData!['ultimo_km']}, consumo_medio=${_vehicleData!['consumo_medio']}');
            }
          });
        } else {
          debugPrint('⚠️ [HomePage] Dados não encontrados na resposta');
        }
      }
    } catch (e) {
      debugPrint('❌ [HomePage] Erro ao buscar stats: $e');
    }
  }

  /// Valida se o KM atual é maior que o último registrado
  void _validateKmInput() {
    if (_lastOdometer == null) {
      setState(() {
        _showKmWarning = false;
      });
      return;
    }
    
    final currentKmText = _kmController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (currentKmText.isEmpty) {
      setState(() {
        _showKmWarning = false;
      });
      return;
    }
    
    final currentKm = double.tryParse(currentKmText) ?? 0;
    setState(() {
      _showKmWarning = currentKm <= _lastOdometer!;
    });
  }

  /// Reseta a validação do posto para permitir trocar
  void _resetStation() {
    setState(() {
      _isStationValidated = false;
      _stationData = null;
      _cnpjPostoController.clear();
      _hasArlaAvailable = false;
      _arlaPrice = 0.0;
      _abastecerArla = false;
    });
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


  // Métodos de busca manual removidos em favor do carregamento automático da jornada
  // _searchVehicle, _confirmVehicle, _cancelVehicle foram obsoletados.

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
        // Obter preços brutos
        final rawFuelPrices = data['fuel_prices'] as List?;
        
        // Determinar combustível do veículo (da jornada)
        // Se _vehicleData for null, fallback para _selectedFuel atual (que é Diesel por padrão)
        final vehicleFuelType = _vehicleData?['tipoCombustivel'] ?? _vehicleData?['fuel_type'] ?? 'Diesel';
        
        // Filtrar combustíveis compatíveis
        final compatibleFuels = _getCompatibleFuels(vehicleFuelType, rawFuelPrices);
        
        setState(() {
          _stationData = {
            'nome': data['station']['name'],
            'endereco': '${data['station']['address']['street']}, ${data['station']['address']['number']}',
            'cidade': '${data['station']['address']['city']} - ${data['station']['address']['state']}',
            'cnpj': data['station']['cnpj'],
            'partnership': data['partnership'],
            'terms': data['terms'],
            'fuel_prices': rawFuelPrices,
            // Preço de referência (apenas visual, será atualizado pelo dropdown)
            'preco': 0.0,
          };
          
          // Ler has_arla_available e arla_price da resposta da API
          _hasArlaAvailable = data['has_arla_available'] == true;
          _arlaPrice = double.tryParse(data['arla_price']?.toString() ?? '0') ?? 0.0;
          // Se ARLA não disponível, garantir que checkbox esteja desmarcado
          if (!_hasArlaAvailable) {
            _abastecerArla = false;
          }
          
          _availableFuels = compatibleFuels;
          
          // Selecionar automaticamente o primeiro compatível, se houver
          // Selecionar automaticamente o combustível mais apropriado
          if (_availableFuels.isNotEmpty) {
             // 1. Tentar manter o veículo fuel type exato se possível
             // Normalizar vehicleFuelType para comparação (Title Case ou como estiver na lista)
             String? bestMatch;
             
             // Tentar encontrar match exato ou parcial com a preferência do veículo
             try {
                bestMatch = _availableFuels.firstWhere(
                  (f) => f.toLowerCase() == vehicleFuelType.toLowerCase(),
                  orElse: () => _availableFuels.firstWhere(
                    (f) => f.toLowerCase().contains(vehicleFuelType.toLowerCase()) || 
                           vehicleFuelType.toLowerCase().contains(f.toLowerCase()),
                    orElse: () => _availableFuels.first
                  )
                );
             } catch (e) {
                bestMatch = _availableFuels.first;
             }
             
             _selectedFuel = bestMatch ?? _availableFuels.first;

             // Atualizar preço de referência com base na seleção automática
             if (rawFuelPrices != null) {
                final priceObj = rawFuelPrices.firstWhere(
                  (fp) => fp['fuel_type']['name'] == _selectedFuel,
                  orElse: () => null
                );
                if (priceObj != null) {
                  _stationData!['preco'] = double.tryParse(priceObj['price_per_liter'].toString()) ?? 0.0;
                }
             }
          } else {
            // Nenhum combustível compatível encontrado
            _selectedFuel = ''; // Indica estado inválido
          }
          
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
  
  /// Retorna lista de combustíveis do posto compatíveis com o veículo
  List<String> _getCompatibleFuels(String vehicleFuel, List<dynamic>? stationPrices) {
    if (stationPrices == null || stationPrices.isEmpty) return [];
    
    final vFuel = vehicleFuel.toLowerCase();
    final stationFuels = stationPrices.map((p) => p['fuel_type']['name'].toString()).toList();
    
    // Lista para armazenar matches
    Set<String> matches = {};
    
    for (var sFuelName in stationFuels) {
      final sFuel = sFuelName.toLowerCase();
      
      if (vFuel.contains('diesel')) {
        // Veículo Diesel -> Aceita qualquer Diesel (S10, S500, Aditivado, Comum)
        if (sFuel.contains('diesel')) {
          matches.add(sFuelName);
        }
      } else if (vFuel.contains('gasolina')) {
        // Veículo Gasolina -> Aceita qualquer Gasolina (Comum, Aditivada, Premium)
        if (sFuel.contains('gasolina')) {
           matches.add(sFuelName);
        }
      } else if (vFuel.contains('etanol') || vFuel.contains('álcool')) {
        // Veículo Etanol -> Aceita Etanol
        if (sFuel.contains('etanol') || sFuel.contains('álcool')) {
          matches.add(sFuelName);
        }
      } else if (vFuel.contains('flex')) {
        // Veículo Flex -> Aceita Gasolina E Etanol
        if (sFuel.contains('gasolina') || sFuel.contains('etanol') || sFuel.contains('álcool')) {
          matches.add(sFuelName);
        }
      } else {
        // Outros casos: tenta match exato ou "contains" genérico
        if (sFuel.contains(vFuel) || vFuel.contains(sFuel)) {
          matches.add(sFuelName);
        }
      }
    }
    
    return matches.toList()..sort();
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
            // Mesclar vehicle_data com last_odometer
            'vehicle_data': {
              ...(_vehicleData ?? {}),
              'last_odometer': _lastOdometer?.toInt() ?? 0,
              'km': _lastOdometer?.toInt() ?? 0,
            },
            'station_data': _stationData,
            'fuel_type': _selectedFuel,
            'km_atual': OdometerFormatter.parseFormattedValue(_kmController.text), // Converter valor formatado para número
            'abastecer_arla': _abastecerArla,
            'transporter_cnpj': _userData?['cnpj'] ?? '',  // CNPJ/CPF para NF
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
            // ===== CARD: VEÍCULO (Sem header - Design Mockup) =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_vehicleData != null) ...[
                      // Layout compacto: Placa + Info
                      Row(
                        children: [
                          // Badge da Placa
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.zecaBlue, Colors.blue[800]!],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _vehicleData!['placa'] ?? '---',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info do veículo
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _vehicleData!['tipo_combustivel'] ?? _vehicleData!['fuel_type'] ?? _vehicleData!['tipoCombustivel'] ?? 'Diesel',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Consumo: ${_vehicleData!['consumo_medio']?.toStringAsFixed(1) ?? '--'} km/L',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  'Último: ${_vehicleData!['ultimo_km'] != null ? OdometerFormatter.formatValue((_vehicleData!['ultimo_km'] as num).toInt()) : '--'} km',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Sem jornada ativa
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nenhuma jornada ativa',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                  Text(
                                    'Inicie uma jornada para abastecer.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/journey'),
                              child: const Text('Iniciar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // ===== CARD: POSTO / CNPJ (Compacto) =====
            if (_vehicleConfirmed) ...[
              const SizedBox(height: 12),
              
              // Card informativo azul - aparece apenas quando posto NÃO está validado
              if (!_isStationValidated)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pergunte o CNPJ do posto no caixa antes de abastecer. Sem ele, não será possível gerar o código.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[800],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header do card
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _isStationValidated ? Colors.green[50] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.local_gas_station,
                              color: _isStationValidated ? Colors.green[700] : Colors.grey[600],
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isStationValidated ? 'POSTO VALIDADO' : 'CNPJ DO POSTO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _isStationValidated ? Colors.green[700] : Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Input ou Info do Posto
                      if (!_isStationValidated) ...[
                        // Input CNPJ
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cnpjPostoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_cnpjMaskFormatter],
                                decoration: InputDecoration(
                                  labelText: 'CNPJ do Posto',
                                  hintText: '00.000.000/0000-00',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _validateStation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.zecaBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Validar'),
                            ),
                          ],
                        ),
                      ] else if (_stationData != null) ...[
                        // Posto Validado - Layout Compacto
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _stationData!['nome'] ?? 'Posto',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Badge tipo
                                      Builder(
                                        builder: (context) {
                                          final isAutonomous = _userData?['isAutonomous'] == true;
                                          final hasPartnership = _stationData!['partnership']?['is_active'] == true;
                                          
                                          Color badgeColor = AppColors.zecaBlue;
                                          String badgeText = 'Frota';
                                          
                                          if (isAutonomous) {
                                            badgeColor = Colors.orange;
                                            badgeText = 'Autônomo';
                                          } else if (hasPartnership) {
                                            badgeColor = Colors.green;
                                            badgeText = 'Parceria';
                                          }
                                          
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: badgeColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              badgeText,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_stationData!['endereco'] ?? ''} - ${_stationData!['cidade'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botão Trocar
                            TextButton.icon(
                              onPressed: _resetStation,
                              icon: Icon(Icons.swap_horiz, size: 16, color: Colors.grey[600]),
                              label: Text(
                                'Trocar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Fuel Price Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // Chip do combustível selecionado
                            if (_stationData!['fuel_prices'] != null) ...[
                              Builder(
                                builder: (context) {
                                  final fuelPrices = _stationData!['fuel_prices'] as List;
                                  final selectedPrice = fuelPrices.firstWhere(
                                    (fp) => fp['fuel_type']['name'] == _selectedFuel,
                                    orElse: () => fuelPrices.isNotEmpty ? fuelPrices.first : null,
                                  );
                                  
                                  if (selectedPrice != null) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.green[500]!, Colors.green[700]!],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            selectedPrice['fuel_type']['name'],
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            'R\$ ${double.parse(selectedPrice['price_per_liter'].toString()).toStringAsFixed(2)}/L',
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
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                            // Chip ARLA se disponível
                            if (_hasArlaAvailable && _arlaPrice > 0) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue[500]!, Colors.blue[700]!],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'ARLA 32',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      'R\$ ${_arlaPrice.toStringAsFixed(2)}/L',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
                      // KM Input com último registro e validação
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Campo de digitação à esquerda
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _kmController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: false),
                              inputFormatters: [
                                OdometerFormatter(),
                              ],
                              onChanged: (_) => _validateKmInput(),
                              decoration: InputDecoration(
                                labelText: 'KM Atual',
                                border: const OutlineInputBorder(),
                                hintText: '0',
                                errorBorder: _showKmWarning ? OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange[700]!, width: 2),
                                ) : null,
                                focusedErrorBorder: _showKmWarning ? OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange[700]!, width: 2),
                                ) : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Badge de Último KM à direita (sempre visível)
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Último KM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _lastOdometer != null 
                                        ? '${OdometerFormatter.formatValue(_lastOdometer!.toInt())} km'
                                        : '-- km',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _lastOdometer != null ? AppColors.zecaBlue : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Aviso quando KM é menor ou igual ao último
                      if (_showKmWarning) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'KM menor que o último registro',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange[900],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'O KM informado é menor que o último registro (${OdometerFormatter.formatValue(_lastOdometer!.toInt())}). Verifique se está correto.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Mensagem de incentivo quando não há histórico de KM
                      if (_lastOdometer == null && _vehicleConfirmed) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Registrar o KM ajuda a calcular o consumo médio e otimizar a gestão do veículo.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      
                      // Lógica de UI para Combustível Compatível
                      if (_selectedFuel.isEmpty) ...[
                        // Nenhum combustível compatível
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Posto sem combustível compatível',
                                      style: TextStyle(
                                        color: Colors.red[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'O veículo utiliza ${_vehicleData?['tipoCombustivel'] ?? 'Desconhecido'}, mas o posto só oferece: ${(_stationData?['fuel_prices'] as List?)?.map((f) => f['fuel_type']['name']).join(', ') ?? 'Nenhum'}',
                                style: TextStyle(color: Colors.red[800], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_availableFuels.length > 1) ...[
                        // Múltiplos compatíveis -> Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedFuel,
                          decoration: const InputDecoration(
                            labelText: 'Combustível',
                            border: OutlineInputBorder(),
                            helperText: 'Escolha um combustível compatível',
                          ),
                          items: _availableFuels.map((fuel) {
                            return DropdownMenuItem(value: fuel, child: Text(fuel));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFuel = value!;
                            });
                          },
                        ),
                      ] else ...[
                        // Apenas 1 compatível -> Readonly
                        TextFormField(
                          initialValue: _selectedFuel,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Combustível (Compatível)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.check_circle, color: Colors.green),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      if (_selectedFuel.isNotEmpty && _selectedFuel.toLowerCase().contains('diesel') && _hasArlaAvailable) ...[
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
                            Expanded(
                              child: Text(
                                'Abastecer ARLA 32 (R\$ ${_arlaPrice.toStringAsFixed(2)}/litro)',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
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
    // Botão fixo no rodapé (bottomNavigationBar)
    bottomNavigationBar: (_vehicleConfirmed && _isStationValidated)
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: (_isLoading || _selectedFuel.isEmpty) ? null : _handleGenerateCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zecaBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Text('Gerando...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            ),
          )
        : null,
    );
  }
}