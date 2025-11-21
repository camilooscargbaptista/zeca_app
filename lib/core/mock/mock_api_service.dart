import 'dart:convert';
import 'dart:math';

class MockApiService {
  static final Random _random = Random();

  // Simular autenticação
  static Future<Map<String, dynamic>> login(String cpf, String senha) async {
    await _simulateNetworkDelay();
    
    // Simular erro de rede ocasional
    if (_random.nextInt(10) == 0) {
      await _simulateNetworkError();
    }
    
    // Normalizar CPF removendo formatação
    final cpfNormalizado = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpfNormalizado == '12345678900' && senha == '123456') {
      return {
        'success': true,
        'data': {
          'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'id': '1',
            'nome': 'João Silva',
            'cpf': '123.456.789-00',
            'email': 'joao.silva@empresa.com',
            'empresa': 'Transportadora ABC Ltda',
            'cnpj': '12.345.678/0001-90',
            'telefone': '(11) 99999-9999',
            'perfil': 'admin'
          },
          'expires_in': 3600
        }
      };
    } else {
      return {
        'success': false,
        'error': {
          'code': 'INVALID_CREDENTIALS',
          'message': 'CPF ou senha inválidos'
        }
      };
    }
  }

  // Simular busca de veículos
  static Future<Map<String, dynamic>> searchVehicles(String query) async {
    await _simulateNetworkDelay();
    
    final vehicles = [
      {
        'id': '1',
        'placa': 'ABC-1234',
        'modelo': 'Volvo FH 460',
        'marca': 'Volvo',
        'ano': 2022,
        'cor': 'Branco',
        'tipoCombustivel': 'Diesel',
        'capacidadeTanque': 500.0,
        'kmAtual': 125000,
        'status': 'Ativo',
        'proprietario': 'Transportadora ABC Ltda',
        'cnpj': '12.345.678/0001-90',
      },
      {
        'id': '2',
        'placa': 'XYZ-5678',
        'modelo': 'Scania R 450',
        'marca': 'Scania',
        'ano': 2021,
        'cor': 'Azul',
        'tipoCombustivel': 'Diesel',
        'capacidadeTanque': 400.0,
        'kmAtual': 98000,
        'status': 'Ativo',
        'proprietario': 'Transportadora XYZ Ltda',
        'cnpj': '98.765.432/0001-10',
      },
    ];
    
    final filteredVehicles = vehicles.where((vehicle) =>
      vehicle['placa'].toString().toLowerCase().contains(query.toLowerCase()) ||
      vehicle['modelo'].toString().toLowerCase().contains(query.toLowerCase()) ||
      vehicle['marca'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    return {
      'success': true,
      'data': {
        'vehicles': filteredVehicles,
        'total': filteredVehicles.length
      }
    };
  }

  // Simular busca de postos
  static Future<Map<String, dynamic>> searchFuelStations({
    double? latitude,
    double? longitude,
    double? radius = 10.0,
    String? tipoCombustivel,
  }) async {
    await _simulateNetworkDelay();
    
    final stations = [
      {
        'id': '1',
        'nome': 'Posto Shell - Centro',
        'cnpj': '12.345.678/0001-90',
        'endereco': 'Av. Paulista, 1000',
        'cidade': 'São Paulo',
        'estado': 'SP',
        'cep': '01310-100',
        'telefone': '(11) 99999-9999',
        'latitude': -23.5614,
        'longitude': -46.6565,
        'tiposCombustivel': ['Diesel', 'Gasolina', 'Etanol'],
        'precoDiesel': 4.50,
        'precoGasolina': 5.20,
        'precoEtanol': 3.80,
        'status': 'Ativo',
        'horarioFuncionamento': '24h',
        'servicos': ['Lavagem', 'Arla 32', 'Restaurante'],
        'avaliacao': 4.5,
        'distancia': 2.5,
      },
      {
        'id': '2',
        'nome': 'Posto Ipiranga - Zona Sul',
        'cnpj': '98.765.432/0001-10',
        'endereco': 'Rua das Flores, 500',
        'cidade': 'São Paulo',
        'estado': 'SP',
        'cep': '04038-001',
        'telefone': '(11) 88888-8888',
        'latitude': -23.6500,
        'longitude': -46.6333,
        'tiposCombustivel': ['Diesel', 'Gasolina', 'Etanol', 'GNV'],
        'precoDiesel': 4.35,
        'precoGasolina': 5.10,
        'precoEtanol': 3.75,
        'status': 'Ativo',
        'horarioFuncionamento': '06:00 - 22:00',
        'servicos': ['Lavagem', 'Arla 32', 'Conveniência'],
        'avaliacao': 4.2,
        'distancia': 5.8,
      },
    ];
    
    List<Map<String, dynamic>> filteredStations = List<Map<String, dynamic>>.from(stations);
    
    // Filtrar por tipo de combustível
    if (tipoCombustivel != null) {
      filteredStations = stations.where((station) =>
        (station['tiposCombustivel'] as List).contains(tipoCombustivel)
      ).toList();
    }
    
    return {
      'success': true,
      'data': {
        'stations': filteredStations,
        'total': filteredStations.length
      }
    };
  }

  // Simular geração de código de abastecimento
  static Future<Map<String, dynamic>> generateRefuelingCode({
    required String veiculoId,
    required String postoId,
    required String tipoCombustivel,
    required double quantidade,
    required int kmAtual,
    required bool abastecerArla,
    String? observacoes,
  }) async {
    await _simulateNetworkDelay();
    
    final codigo = 'ZECA-2024-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final precoUnitario = _getFuelPrice(tipoCombustivel);
    final valorTotal = quantidade * precoUnitario;
    
    return {
      'success': true,
      'data': {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'codigo': codigo,
        'veiculo_id': veiculoId,
        'veiculo_placa': 'ABC-1234',
        'posto_id': postoId,
        'posto_nome': 'Posto Shell - Centro',
        'tipo_combustivel': tipoCombustivel,
        'quantidade_solicitada': quantidade,
        'preco_unitario': precoUnitario,
        'valor_total': valorTotal,
        'km_atual': kmAtual,
        'abastecer_arla': abastecerArla,
        'observacoes': observacoes,
        'status': 'Ativo',
        'data_expiracao': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        'qr_code': codigo,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }
    };
  }

  // Simular busca de notificações
  static Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    await _simulateNetworkDelay();
    
    final notifications = [
      {
        'id': '1',
        'titulo': 'Abastecimento Realizado',
        'mensagem': 'Abastecimento de 100L de Diesel realizado com sucesso no Posto Shell - Centro',
        'tipo': 'abastecimento',
        'status': 'lida',
        'data_envio': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'data_leitura': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        'dados': {
          'veiculo': 'ABC-1234',
          'posto': 'Posto Shell - Centro',
          'quantidade': '100L',
          'valor': 'R\$ 450,00'
        },
      },
      {
        'id': '2',
        'titulo': 'Código de Abastecimento Expirado',
        'mensagem': 'O código ZECA-2024-001235 expirou. Gere um novo código para continuar.',
        'tipo': 'expiracao',
        'status': 'nao_lida',
        'data_envio': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        'data_leitura': null,
        'dados': {
          'codigo': 'ZECA-2024-001235',
          'veiculo': 'XYZ-5678'
        },
      },
    ];
    
    List<Map<String, dynamic>> filteredNotifications = List<Map<String, dynamic>>.from(notifications);
    
    if (status != null) {
      filteredNotifications = notifications.where((n) => n['status'] == status).toList();
    }
    
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedNotifications = filteredNotifications
        .skip(startIndex)
        .take(limit)
        .toList();
    
    return {
      'success': true,
      'data': {
        'notifications': paginatedNotifications,
        'total': filteredNotifications.length,
        'page': page,
        'limit': limit,
        'total_pages': (filteredNotifications.length / limit).ceil()
      }
    };
  }

  // Simular marcar notificação como lida
  static Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': {
        'id': notificationId,
        'status': 'lida',
        'data_leitura': DateTime.now().toIso8601String()
      }
    };
  }

  // Simular histórico de abastecimentos
  static Future<Map<String, dynamic>> getRefuelingHistory({
    int page = 1,
    int limit = 20,
    String? veiculoId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    await _simulateNetworkDelay();
    
    // Simular dados baseados no mês solicitado
    final now = DateTime.now();
    final requestedMonth = dataInicio?.month ?? now.month;
    final requestedYear = dataInicio?.year ?? now.year;
    
    List<Map<String, dynamic>> history = [];
    
    if (requestedMonth == now.month && requestedYear == now.year) {
      // Mês atual - mostrar dados recentes
      history = [
        {
          'id': '1',
          'veiculo': 'ABC-1234',
          'posto': 'Posto Shell - Centro',
          'combustivel': 'Diesel',
          'quantidade': '100L',
          'valor': 'R\$ 450,00',
          'data': 'Hoje',
          'hora': '14:30',
          'codigo': 'ZEC-001',
          'status': 'Concluído'
        },
        {
          'id': '2',
          'veiculo': 'XYZ-5678',
          'posto': 'Posto Ipiranga - Zona Sul',
          'combustivel': 'Diesel',
          'quantidade': '80L',
          'valor': 'R\$ 348,00',
          'data': 'Ontem',
          'hora': '09:15',
          'codigo': 'ZEC-002',
          'status': 'Concluído'
        },
        {
          'id': '3',
          'veiculo': 'DEF-9012',
          'posto': 'Posto BR - Marginal',
          'combustivel': 'Diesel',
          'quantidade': '120L',
          'valor': 'R\$ 552,00',
          'data': '2 dias atrás',
          'hora': '16:45',
          'codigo': 'ZEC-003',
          'status': 'Concluído'
        },
        {
          'id': '4',
          'veiculo': 'ABC-1234',
          'posto': 'Posto Shell - Centro',
          'combustivel': 'Diesel',
          'quantidade': '90L',
          'valor': 'R\$ 405,00',
          'data': '3 dias atrás',
          'hora': '11:20',
          'codigo': 'ZEC-004',
          'status': 'Concluído'
        },
        {
          'id': '5',
          'veiculo': 'XYZ-5678',
          'posto': 'Posto Ipiranga - Zona Sul',
          'combustivel': 'Diesel',
          'quantidade': '110L',
          'valor': 'R\$ 495,00',
          'data': '5 dias atrás',
          'hora': '08:45',
          'codigo': 'ZEC-005',
          'status': 'Concluído'
        },
      ];
    } else {
      // Mês anterior - mostrar dados históricos
      history = [
        {
          'id': '6',
          'veiculo': 'ABC-1234',
          'posto': 'Posto Shell - Centro',
          'combustivel': 'Diesel',
          'quantidade': '95L',
          'valor': 'R\$ 427,50',
          'data': '15/${requestedMonth.toString().padLeft(2, '0')}',
          'hora': '16:30',
          'codigo': 'ZEC-006',
          'status': 'Concluído'
        },
        {
          'id': '7',
          'veiculo': 'XYZ-5678',
          'posto': 'Posto Ipiranga - Zona Sul',
          'combustivel': 'Diesel',
          'quantidade': '85L',
          'valor': 'R\$ 382,50',
          'data': '12/${requestedMonth.toString().padLeft(2, '0')}',
          'hora': '13:15',
          'codigo': 'ZEC-007',
          'status': 'Concluído'
        },
        {
          'id': '8',
          'veiculo': 'DEF-9012',
          'posto': 'Posto BR - Marginal',
          'combustivel': 'Diesel',
          'quantidade': '105L',
          'valor': 'R\$ 472,50',
          'data': '8/${requestedMonth.toString().padLeft(2, '0')}',
          'hora': '10:45',
          'codigo': 'ZEC-008',
          'status': 'Concluído'
        },
      ];
    }
    
    // Calcular estatísticas do mês
    final totalAbastecimentos = history.length;
    final totalLitros = history.fold<double>(0, (sum, item) {
      final litros = double.tryParse(item['quantidade'].toString().replaceAll('L', '')) ?? 0;
      return sum + litros;
    });
    final totalValor = history.fold<double>(0, (sum, item) {
      final valor = double.tryParse(item['valor'].toString().replaceAll('R\$ ', '').replaceAll(',', '.')) ?? 0;
      return sum + valor;
    });
    
    return {
      'success': true,
      'data': {
        'history': history,
        'total': history.length,
        'page': page,
        'limit': limit,
        'total_pages': (history.length / limit).ceil(),
        'total_abastecimentos': totalAbastecimentos,
        'total_litros': totalLitros,
        'total_valor': totalValor,
        'economia': totalValor * 0.05, // 5% de economia
      }
    };
  }

  // Simular estatísticas
  static Future<Map<String, dynamic>> getStatistics({
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': {
        'total_abastecimentos': 45,
        'total_litros': 4200.0,
        'total_valor': 18900.0,
        'economia': 945.0,
        'postos_frequentes': [
          {'nome': 'Posto Shell - Centro', 'visitas': 15},
          {'nome': 'Posto Ipiranga - Zona Sul', 'visitas': 12},
          {'nome': 'Posto BR - Marginal', 'visitas': 8},
        ],
        'veiculos_frequentes': [
          {'placa': 'ABC-1234', 'abastecimentos': 20},
          {'placa': 'XYZ-5678', 'abastecimentos': 15},
          {'placa': 'DEF-9012', 'abastecimentos': 10},
        ],
      }
    };
  }

  // Simular validação de código QR
  static Future<Map<String, dynamic>> validateRefuelingCode(String codigo) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': {
        'id': '1',
        'codigo': codigo,
        'veiculo_placa': 'ABC-1234',
        'posto_nome': 'Posto Shell - Centro',
        'tipo_combustivel': 'Diesel',
        'quantidade_solicitada': 100.0,
        'preco_unitario': 4.50,
        'valor_total': 450.0,
        'km_atual': 125000,
        'abastecer_arla': true,
        'status': 'Ativo',
        'data_expiracao': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      }
    };
  }

  // Simular confirmação de abastecimento
  static Future<Map<String, dynamic>> confirmRefueling({
    required String codigo,
    required double quantidadeReal,
    required int kmFinal,
  }) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'codigo': codigo,
        'quantidade_real': quantidadeReal,
        'km_final': kmFinal,
        'data_abastecimento': DateTime.now().toIso8601String(),
        'status': 'Concluído'
      }
    };
  }

  // Métodos auxiliares
  static double _getFuelPrice(String tipoCombustivel) {
    switch (tipoCombustivel.toLowerCase()) {
      case 'diesel':
        return 4.50;
      case 'gasolina':
        return 5.20;
      case 'etanol':
        return 3.80;
      default:
        return 4.50;
    }
  }

  // Simular finalização de abastecimento
  static Future<Map<String, dynamic>> finalizeRefueling({
    required String refuelingCode,
    required List<dynamic> images,
  }) async {
    await _simulateNetworkDelay();
    
    // Validação de comprovante removida - não é mais obrigatório
    
    // Simular upload das imagens (se houver)
    final uploadedImages = <Map<String, dynamic>>[];
    for (int i = 0; i < images.length; i++) {
      uploadedImages.add({
        'id': 'img_${DateTime.now().millisecondsSinceEpoch}_$i',
        'url': 'https://storage.zeca.com.br/receipts/${refuelingCode}_$i.jpg',
        'filename': 'comprovante_${i + 1}.jpg',
        'size': 1024 * 1024 * (1 + _random.nextInt(3)), // 1-4MB
        'uploaded_at': DateTime.now().toIso8601String(),
      });
    }
    
    return {
      'success': true,
      'data': {
        'refueling_id': 'ref_${DateTime.now().millisecondsSinceEpoch}',
        'code': refuelingCode,
        'status': 'finalized',
        'finalized_at': DateTime.now().toIso8601String(),
        'uploaded_images': uploadedImages,
        'total_images': images.length,
        'message': 'Abastecimento finalizado com sucesso'
      }
    };
  }

  // Simular cancelamento de abastecimento
  static Future<Map<String, dynamic>> cancelRefueling({
    required String refuelingCode,
    String? reason,
  }) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': {
        'refueling_id': 'ref_${DateTime.now().millisecondsSinceEpoch}',
        'code': refuelingCode,
        'status': 'cancelled',
        'cancelled_at': DateTime.now().toIso8601String(),
        'reason': reason ?? 'Cancelado pelo usuário',
        'message': 'Código de abastecimento cancelado com sucesso'
      }
    };
  }

  // Simular validação de posto por CNPJ
  static Future<Map<String, dynamic>> validateStation(String cnpj) async {
    await _simulateNetworkDelay();
    
    // Simular erro de rede ocasional
    if (_random.nextInt(10) == 0) {
      await _simulateNetworkError();
    }
    
    // Simular validação de CNPJ
    final cnpjNormalizado = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cnpjNormalizado.length == 14) {
      return {
        'success': true,
        'data': {
          'id': 'posto_${cnpjNormalizado}',
          'nome': 'Posto Ipiranga Centro',
          'cnpj': cnpj,
          'endereco': 'Rua das Flores, 123',
          'cidade': 'São Paulo - SP',
          'preco_diesel': 5.89,
          'preco_gasolina': 6.20,
          'preco_etanol': 4.50,
          'preco_arla': 8.50, // Preço do ARLA 32
          'conveniado': true,
          'distancia_km': 2.5,
          'horario_funcionamento': '24h',
          'servicos': ['ARLA 32', 'Lava-jato', 'Conveniência'],
        }
      };
    } else {
      return {
        'success': false,
        'message': 'CNPJ inválido'
      };
    }
  }

  // Simular delay de rede
  static Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
  }

  // Simular erro de rede (10% de chance)
  static Future<void> _simulateNetworkError() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    throw Exception('Erro de conexão com o servidor');
  }
}