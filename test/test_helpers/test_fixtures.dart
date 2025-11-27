import 'package:zeca_app/features/auth/domain/entities/user_entity.dart';
import 'package:zeca_app/features/journey/domain/entities/journey_entity.dart';
import 'package:zeca_app/features/journey/domain/entities/location_point_entity.dart';

// ============================================================
// TEST FIXTURES - USER
// ============================================================

const tUserEntity = UserEntity(
  id: '123e4567-e89b-12d3-a456-426614174000',
  nome: 'João Motorista',
  cpf: '12345678900',
  empresaId: 'company-123',
  empresaNome: 'Transportadora ABC',
  email: 'joao@example.com',
  telefone: '11999999999',
);

// ============================================================
// TEST FIXTURES - JOURNEY
// ============================================================

final tJourneyEntity = JourneyEntity(
  id: 'journey-123',
  driverId: 'driver-123',
  vehicleId: 'vehicle-123',
  placa: 'ABC1234',
  odometroInicial: 10000,
  destino: 'São Paulo - SP',
  previsaoKm: 500,
  observacoes: 'Carga frágil',
  dataInicio: DateTime(2024, 1, 15, 8, 0),
  dataFim: null,
  status: JourneyStatus.ACTIVE,
  tempoDirecaoSegundos: 3600,
  tempoDescansoSegundos: 0,
  kmPercorridos: 50.5,
  velocidadeMedia: null,
  velocidadeMaxima: null,
  latVelocidadeMaxima: null,
  longVelocidadeMaxima: null,
  createdAt: DateTime(2024, 1, 15, 8, 0),
  updatedAt: DateTime(2024, 1, 15, 9, 0),
);

final tLocationPoint = LocationPointEntity(
  id: 'point-1',
  journeyId: 'journey-123',
  latitude: -23.5505,
  longitude: -46.6333,
  velocidade: 60.0,
  timestamp: DateTime(2024, 1, 15, 8, 30),
  sincronizado: false,
  createdAt: DateTime(2024, 1, 15, 8, 30),
);

// ============================================================
// TEST FIXTURES - JSON RESPONSES
// ============================================================

const tJourneyJson = {
  'id': 'journey-123',
  'driver_id': 'driver-123',
  'vehicle_id': 'vehicle-123',
  'placa': 'ABC1234',
  'odometro_inicial': 10000,
  'destino': 'São Paulo - SP',
  'previsao_km': 500,
  'observacoes': 'Carga frágil',
  'data_inicio': '2024-01-15T08:00:00.000Z',
  'data_fim': null,
  'status': 'ACTIVE',
  'tempo_direcao_segundos': 3600,
  'tempo_descanso_segundos': 0,
  'km_percorridos': 50.5,
  'velocidade_media': null,
  'velocidade_maxima': null,
  'lat_velocidade_maxima': null,
  'long_velocidade_maxima': null,
  'created_at': '2024-01-15T08:00:00.000Z',
  'updated_at': '2024-01-15T09:00:00.000Z',
};

const tUserJson = {
  'id': '123e4567-e89b-12d3-a456-426614174000',
  'nome': 'João Motorista',
  'cpf': '12345678900',
  'empresa_id': 'company-123',
  'empresa_nome': 'Transportadora ABC',
  'email': 'joao@example.com',
  'telefone': '11999999999',
};
