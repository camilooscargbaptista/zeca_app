import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/errors/failures.dart';
import 'package:zeca_app/features/home/domain/entities/fuel_station_entity.dart';
import 'package:zeca_app/features/home/domain/usecases/get_nearby_stations_usecase.dart';
import 'package:zeca_app/features/home/presentation/bloc/nearby_stations/nearby_stations_bloc.dart';

class MockGetNearbyStationsUseCase extends Mock implements GetNearbyStationsUseCase {}

void main() {
  late NearbyStationsBloc bloc;
  late MockGetNearbyStationsUseCase mockUseCase;

  // Test data
  const tStation = FuelStationEntity(
    id: 'station-1',
    cnpj: '00.000.000/0001-00',
    razaoSocial: 'Posto Teste',
    nomeFantasia: 'Posto Teste',
    endereco: FuelStationAddressEntity(
      logradouro: 'Rua das Flores',
      numero: '123',
      bairro: 'Centro',
      cidade: 'São Paulo',
      uf: 'SP',
      cep: '01000-000',
      latitude: -23.5505,
      longitude: -46.6333,
    ),
    conveniado: true,
    precos: {'DIESEL S10': 5.50},
    servicos: [],
    formasPagamento: [],
    ativo: true,
    distanciaKm: 1.5,
  );

  setUp(() {
    mockUseCase = MockGetNearbyStationsUseCase();
    bloc = NearbyStationsBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('NearbyStationsBloc', () {
    test('initial state is NearbyStationsInitial', () {
      expect(bloc.state, equals(NearbyStationsInitial()));
    });

    blocTest<NearbyStationsBloc, NearbyStationsState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(() => mockUseCase(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          radius: any(named: 'radius'),
          combustivel: any(named: 'combustivel'),
          conveniado: any(named: 'conveniado'),
        )).thenAnswer((_) async => const Right([tStation]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadNearbyStations(
        latitude: -23.5505,
        longitude: -46.6333,
      )),
      expect: () => [
        NearbyStationsLoading(),
        const NearbyStationsLoaded(
          stations: [tStation],
          total: 1,
          radiusKm: 50,
        ),
      ],
    );

    blocTest<NearbyStationsBloc, NearbyStationsState>(
      'should emit [Loading, Empty] when data is empty',
      build: () {
        when(() => mockUseCase(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          radius: any(named: 'radius'),
          combustivel: any(named: 'combustivel'),
          conveniado: any(named: 'conveniado'),
        )).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadNearbyStations(
        latitude: -23.5505,
        longitude: -46.6333,
      )),
      expect: () => [
        NearbyStationsLoading(),
        NearbyStationsEmpty(),
      ],
    );

    blocTest<NearbyStationsBloc, NearbyStationsState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(() => mockUseCase(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          radius: any(named: 'radius'),
          combustivel: any(named: 'combustivel'),
          conveniado: any(named: 'conveniado'),
        )).thenAnswer((_) async => Left(ServerFailure(message: 'Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadNearbyStations(
        latitude: -23.5505,
        longitude: -46.6333,
      )),
      expect: () => [
        NearbyStationsLoading(),
        const NearbyStationsError('Server Error'),
      ],
    );
  });
}
