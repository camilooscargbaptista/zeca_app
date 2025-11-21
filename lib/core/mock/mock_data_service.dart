import 'dart:math';
import 'package:zeca_app/features/home/domain/entities/vehicle_entity.dart';
import 'package:zeca_app/features/home/domain/entities/fuel_station_entity.dart';
import 'package:zeca_app/features/refueling/domain/entities/refueling_code_entity.dart';
import 'package:zeca_app/features/notifications/domain/entities/notification_entity.dart';

class MockDataService {
  static final Random _random = Random();

  // Mock de Veículos
  static List<VehicleEntity> getMockVehicles() {
    return [
      VehicleEntity(
        id: '1',
        placa: 'ABC-1234',
        modelo: 'Volvo FH 460',
        marca: 'Volvo',
        ano: 2022,
        cor: 'Branco',
        tipoCombustivel: 'Diesel',
        capacidadeTanque: 500.0,
        kmAtual: 125000,
        status: 'Ativo',
        proprietario: 'Transportadora ABC Ltda',
        cnpj: '12.345.678/0001-90',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      VehicleEntity(
        id: '2',
        placa: 'XYZ-5678',
        modelo: 'Scania R 450',
        marca: 'Scania',
        ano: 2021,
        cor: 'Azul',
        tipoCombustivel: 'Diesel',
        capacidadeTanque: 400.0,
        kmAtual: 98000,
        status: 'Ativo',
        proprietario: 'Transportadora XYZ Ltda',
        cnpj: '98.765.432/0001-10',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
      ),
      VehicleEntity(
        id: '3',
        placa: 'DEF-9012',
        modelo: 'Mercedes Actros 1845',
        marca: 'Mercedes-Benz',
        ano: 2023,
        cor: 'Prata',
        tipoCombustivel: 'Diesel',
        capacidadeTanque: 600.0,
        kmAtual: 45000,
        status: 'Ativo',
        proprietario: 'Logística DEF Ltda',
        cnpj: '11.222.333/0001-44',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Mock de Postos de Combustível
  static List<FuelStationEntity> getMockFuelStations() {
    return [
      FuelStationEntity(
        id: '1',
        nome: 'Posto Shell - Centro',
        cnpj: '12.345.678/0001-90',
        endereco: 'Av. Paulista, 1000',
        cidade: 'São Paulo',
        estado: 'SP',
        cep: '01310-100',
        telefone: '(11) 99999-9999',
        latitude: -23.5614,
        longitude: -46.6565,
        tiposCombustivel: ['Diesel', 'Gasolina', 'Etanol'],
        precoDiesel: 4.50,
        precoGasolina: 5.20,
        precoEtanol: 3.80,
        status: 'Ativo',
        horarioFuncionamento: '24h',
        servicos: ['Lavagem', 'Arla 32', 'Restaurante'],
        avaliacao: 4.5,
        distancia: 2.5,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      FuelStationEntity(
        id: '2',
        nome: 'Posto Ipiranga - Zona Sul',
        cnpj: '98.765.432/0001-10',
        endereco: 'Rua das Flores, 500',
        cidade: 'São Paulo',
        estado: 'SP',
        cep: '04038-001',
        telefone: '(11) 88888-8888',
        latitude: -23.6500,
        longitude: -46.6333,
        tiposCombustivel: ['Diesel', 'Gasolina', 'Etanol', 'GNV'],
        precoDiesel: 4.35,
        precoGasolina: 5.10,
        precoEtanol: 3.75,
        status: 'Ativo',
        horarioFuncionamento: '06:00 - 22:00',
        servicos: ['Lavagem', 'Arla 32', 'Conveniência'],
        avaliacao: 4.2,
        distancia: 5.8,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
      ),
      FuelStationEntity(
        id: '3',
        nome: 'Posto BR - Marginal',
        cnpj: '11.222.333/0001-44',
        endereco: 'Marginal Tietê, 5000',
        cidade: 'São Paulo',
        estado: 'SP',
        cep: '02000-000',
        telefone: '(11) 77777-7777',
        latitude: -23.5000,
        longitude: -46.6000,
        tiposCombustivel: ['Diesel', 'Gasolina', 'Etanol'],
        precoDiesel: 4.60,
        precoGasolina: 5.30,
        precoEtanol: 3.90,
        status: 'Ativo',
        horarioFuncionamento: '24h',
        servicos: ['Lavagem', 'Arla 32', 'Restaurante', 'Hotel'],
        avaliacao: 4.8,
        distancia: 8.2,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Mock de Códigos de Abastecimento
  static List<RefuelingCodeEntity> getMockRefuelingCodes() {
    return [
      RefuelingCodeEntity(
        id: '1',
        codigo: 'ZECA-2024-001234',
        veiculoId: '1',
        veiculoPlaca: 'ABC-1234',
        postoId: '1',
        postoNome: 'Posto Shell - Centro',
        tipoCombustivel: 'Diesel',
        quantidadeSolicitada: 100.0,
        precoUnitario: 4.50,
        valorTotal: 450.0,
        kmAtual: 125000,
        abastecerArla: true,
        observacoes: 'Abastecimento de rotina',
        status: 'Ativo',
        dataExpiracao: DateTime.now().add(const Duration(hours: 24)),
        qrCode: 'ZECA-2024-001234',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RefuelingCodeEntity(
        id: '2',
        codigo: 'ZECA-2024-001235',
        veiculoId: '2',
        veiculoPlaca: 'XYZ-5678',
        postoId: '2',
        postoNome: 'Posto Ipiranga - Zona Sul',
        tipoCombustivel: 'Diesel',
        quantidadeSolicitada: 80.0,
        precoUnitario: 4.35,
        valorTotal: 348.0,
        kmAtual: 98000,
        abastecerArla: false,
        observacoes: 'Abastecimento emergencial',
        status: 'Usado',
        dataExpiracao: DateTime.now().add(const Duration(hours: 12)),
        qrCode: 'ZECA-2024-001235',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  // Mock de Notificações
  static List<NotificationEntity> getMockNotifications() {
    return [
      NotificationEntity(
        id: '1',
        titulo: 'Abastecimento Realizado',
        mensagem: 'Abastecimento de 100L de Diesel realizado com sucesso no Posto Shell - Centro',
        tipo: 'abastecimento',
        status: 'lida',
        dataEnvio: DateTime.now().subtract(const Duration(hours: 2)),
        dataLeitura: DateTime.now().subtract(const Duration(hours: 1)),
        dados: {
          'veiculo': 'ABC-1234',
          'posto': 'Posto Shell - Centro',
          'quantidade': '100L',
          'valor': 'R\$ 450,00'
        },
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationEntity(
        id: '2',
        titulo: 'Código de Abastecimento Expirado',
        mensagem: 'O código ZECA-2024-001235 expirou. Gere um novo código para continuar.',
        tipo: 'expiracao',
        status: 'nao_lida',
        dataEnvio: DateTime.now().subtract(const Duration(minutes: 30)),
        dataLeitura: null,
        dados: {
          'codigo': 'ZECA-2024-001235',
          'veiculo': 'XYZ-5678'
        },
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      NotificationEntity(
        id: '3',
        titulo: 'Novo Posto Disponível',
        mensagem: 'Posto BR - Marginal agora aceita códigos ZECA. Confira os preços!',
        tipo: 'promocao',
        status: 'nao_lida',
        dataEnvio: DateTime.now().subtract(const Duration(hours: 6)),
        dataLeitura: null,
        dados: {
          'posto': 'Posto BR - Marginal',
          'desconto': '5%'
        },
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  // Mock de Histórico de Abastecimentos
  static List<Map<String, dynamic>> getMockRefuelingHistory() {
    return [
      {
        'id': '1',
        'veiculo': 'ABC-1234',
        'posto': 'Posto Shell - Centro',
        'combustivel': 'Diesel',
        'quantidade': '100L',
        'valor': 'R\$ 450,00',
        'data': 'Hoje - 14:30',
        'status': 'Concluído'
      },
      {
        'id': '2',
        'veiculo': 'XYZ-5678',
        'posto': 'Posto Ipiranga - Zona Sul',
        'combustivel': 'Diesel',
        'quantidade': '80L',
        'valor': 'R\$ 348,00',
        'data': 'Ontem - 09:15',
        'status': 'Concluído'
      },
      {
        'id': '3',
        'veiculo': 'DEF-9012',
        'posto': 'Posto BR - Marginal',
        'combustivel': 'Diesel',
        'quantidade': '120L',
        'valor': 'R\$ 552,00',
        'data': '2 dias atrás - 16:45',
        'status': 'Concluído'
      },
    ];
  }

  // Mock de Estatísticas
  static Map<String, dynamic> getMockStatistics() {
    return {
      'totalAbastecimentos': 45,
      'totalLitros': 4200.0,
      'totalValor': 18900.0,
      'economia': 945.0,
      'postosFrequentes': [
        {'nome': 'Posto Shell - Centro', 'visitas': 15},
        {'nome': 'Posto Ipiranga - Zona Sul', 'visitas': 12},
        {'nome': 'Posto BR - Marginal', 'visitas': 8},
      ],
      'veiculosFrequentes': [
        {'placa': 'ABC-1234', 'abastecimentos': 20},
        {'placa': 'XYZ-5678', 'abastecimentos': 15},
        {'placa': 'DEF-9012', 'abastecimentos': 10},
      ],
    };
  }

  // Simular delay de rede
  static Future<T> simulateNetworkDelay<T>(T data) async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
    return data;
  }

  // Simular erro de rede (10% de chance)
  static Future<T> simulateNetworkError<T>() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    throw Exception('Erro de conexão com o servidor');
  }
}
