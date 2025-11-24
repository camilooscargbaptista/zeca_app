import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/errors/failures.dart';
import 'package:zeca_app/features/home/domain/entities/vehicle_entity.dart';
import 'package:zeca_app/features/home/domain/usecases/search_vehicle_usecase.dart';
import 'package:zeca_app/features/home/domain/usecases/get_nearby_stations_usecase.dart';
import 'package:zeca_app/features/home/domain/usecases/validate_station_usecase.dart';
import 'package:zeca_app/features/home/presentation/bloc/vehicle_bloc.dart';

// Mocks
class MockSearchVehicleUseCase extends Mock implements SearchVehicleUseCase {}
class MockGetNearbyStationsUseCase extends Mock implements GetNearbyStationsUseCase {}
class MockValidateStationUseCase extends Mock implements ValidateStationUseCase {}

void main() {
  late VehicleBloc vehicleBloc;
  late MockSearchVehicleUseCase mockSearchVehicleUseCase;
  late MockGetNearbyStationsUseCase mockGetNearbyStationsUseCase;
  late MockValidateStationUseCase mockValidateStationUseCase;

  // Test data
  const tPlaca = 'ABC1234';
  final tVehicle = VehicleEntity(
    id: 'vehicle-123',
    placa: tPlaca,
    modelo: 'Caminhão Baú',
    marca: 'Mercedes-Benz',
    ano: 2020,
    cor: 'Branco',
    combustiveis: ['DIESEL'],
    ultimoKm: 50000,
    especificacoes: const VehicleSpecsEntity(
      capacidadeTanque: 300.0,
      consumoMedio: 2.5,
      transmissao: 'Manual',
      eixos: 3,
      pesoBruto: 23000,
    ),
    empresaId: 'company-123',
    empresaNome: 'Transportadora ABC',
    ativo: true,
    criadoEm: DateTime(2020, 1, 1),
  );

  setUp(() {
    mockSearchVehicleUseCase = MockSearchVehicleUseCase();
    mockGetNearbyStationsUseCase = MockGetNearbyStationsUseCase();
    mockValidateStationUseCase = MockValidateStationUseCase();

    vehicleBloc = VehicleBloc(
      searchVehicleUseCase: mockSearchVehicleUseCase,
      getNearbyStationsUseCase: mockGetNearbyStationsUseCase,
      validateStationUseCase: mockValidateStationUseCase,
    );
  });

  tearDown(() {
    vehicleBloc.close();
  });

  group('VehicleBloc', () {
    test('initial state is VehicleInitial', () {
      expect(vehicleBloc.state, equals(const VehicleInitial()));
    });

    group('SearchVehicle', () {
      blocTest<VehicleBloc, VehicleState>(
        'emits [VehicleLoading, VehicleLoaded] when search succeeds',
        build: () {
          when(() => mockSearchVehicleUseCase(tPlaca))
              .thenAnswer((_) async => Right(tVehicle));
          return vehicleBloc;
        },
        act: (bloc) => bloc.add(const SearchVehicle(tPlaca)),
        expect: () => [
          const VehicleLoading(),
          VehicleLoaded(tVehicle),
        ],
        verify: (_) {
          verify(() => mockSearchVehicleUseCase(tPlaca)).called(1);
        },
      );

      blocTest<VehicleBloc, VehicleState>(
        'emits [VehicleLoading, VehicleError] when search fails',
        build: () {
          when(() => mockSearchVehicleUseCase(tPlaca))
              .thenAnswer((_) async => const Left(ServerFailure(message: 'Veículo não encontrado')));
          return vehicleBloc;
        },
        act: (bloc) => bloc.add(const SearchVehicle(tPlaca)),
        expect: () => [
          const VehicleLoading(),
          const VehicleError('Veículo não encontrado'),
        ],
      );

      blocTest<VehicleBloc, VehicleState>(
        'emits [VehicleLoading, VehicleError] when network error occurs',
        build: () {
          when(() => mockSearchVehicleUseCase(tPlaca))
              .thenAnswer((_) async => const Left(NetworkFailure(message: 'Sem conexão')));
          return vehicleBloc;
        },
        act: (bloc) => bloc.add(const SearchVehicle(tPlaca)),
        expect: () => [
          const VehicleLoading(),
          const VehicleError('Sem conexão'),
        ],
      );
    });

    group('LoadUserInfo', () {
      blocTest<VehicleBloc, VehicleState>(
        'emits [VehicleInitial] (TODO implementation)',
        build: () => vehicleBloc,
        act: (bloc) => bloc.add(const LoadUserInfo()),
        expect: () => [
          const VehicleInitial(),
        ],
      );
    });

    group('ClearVehicle', () {
      blocTest<VehicleBloc, VehicleState>(
        'emits [VehicleInitial] when clearing vehicle',
        build: () => vehicleBloc,
        seed: () => VehicleLoaded(tVehicle),
        act: (bloc) => bloc.add(const ClearVehicle()),
        expect: () => [
          const VehicleInitial(),
        ],
      );
    });
  });
}
