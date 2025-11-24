import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeca_app/features/home/domain/entities/fuel_station_entity.dart';
import 'package:zeca_app/features/home/domain/entities/refueling_data_entity.dart';
import 'package:zeca_app/features/home/presentation/bloc/refueling_form_bloc.dart';

void main() {
  late RefuelingFormBloc refuelingFormBloc;

  // Test data
  const tVeiculoId = 'vehicle-123';
  const tVeiculoPlaca = 'ABC1234';
  const tKmAtual = 50000;
  const tCombustivel = 'DIESEL';
  const tObservacoes = 'Teste de abastecimento';

  final tStation = FuelStationEntity(
    id: 'station-123',
    razaoSocial: 'Posto Shell',
    nomeFantasia: 'Shell Centro',
    cnpj: '12345678000190',
    endereco: const FuelStationAddressEntity(
      logradouro: 'Rua Principal',
      numero: '100',
      bairro: 'Centro',
      cidade: 'São Paulo',
      uf: 'SP',
      cep: '01000-000',
      latitude: -23.5505,
      longitude: -46.6333,
    ),
    conveniado: true,
    precos: const {'DIESEL': 5.99, 'GASOLINA': 6.49},
    servicos: const ['Troca de Óleo', 'Calibragem'],
    formasPagamento: const ['DINHEIRO', 'CARTÃO'],
    ativo: true,
    distanciaKm: 2.5,
  );

  setUp(() {
    refuelingFormBloc = RefuelingFormBloc();
  });

  tearDown(() {
    refuelingFormBloc.close();
  });

  group('RefuelingFormBloc', () {
    test('initial state is RefuelingFormInitial with default data', () {
      expect(refuelingFormBloc.state, isA<RefuelingFormInitial>());
      expect(refuelingFormBloc.state.refuelingData.veiculoId, equals(''));
      expect(refuelingFormBloc.state.refuelingData.combustivel, equals('diesel'));
      expect(refuelingFormBloc.state.refuelingData.abastecerArla, equals(false));
    });

    group('UpdateRefuelingData', () {
      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'updates all data fields',
        build: () => refuelingFormBloc,
        act: (bloc) => bloc.add(const UpdateRefuelingData(
          veiculoId: tVeiculoId,
          veiculoPlaca: tVeiculoPlaca,
          kmAtual: tKmAtual,
          combustivel: tCombustivel,
          abastecerArla: true,
          observacoes: tObservacoes,
        )),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.veiculoId, 'veiculoId', tVeiculoId)
              .having((s) => s.refuelingData.veiculoPlaca, 'veiculoPlaca', tVeiculoPlaca)
              .having((s) => s.refuelingData.kmAtual, 'kmAtual', tKmAtual)
              .having((s) => s.refuelingData.combustivel, 'combustivel', tCombustivel)
              .having((s) => s.refuelingData.abastecerArla, 'abastecerArla', true)
              .having((s) => s.refuelingData.observacoes, 'observacoes', tObservacoes),
        ],
      );

      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'updates only specified fields, keeping others',
        build: () => refuelingFormBloc,
        seed: () => const RefuelingFormUpdated(RefuelingDataEntity(
          veiculoId: tVeiculoId,
          veiculoPlaca: tVeiculoPlaca,
          kmAtual: 0,
          combustivel: 'diesel',
          abastecerArla: false,
        )),
        act: (bloc) => bloc.add(const UpdateRefuelingData(kmAtual: tKmAtual)),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.veiculoId, 'veiculoId', tVeiculoId)
              .having((s) => s.refuelingData.kmAtual, 'kmAtual', tKmAtual),
        ],
      );
    });

    group('SelectFuelType', () {
      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'updates combustivel field',
        build: () => refuelingFormBloc,
        act: (bloc) => bloc.add(const SelectFuelType('GASOLINA')),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.combustivel, 'combustivel', 'GASOLINA'),
        ],
      );
    });

    group('SelectStation', () {
      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'updates station id and cnpj',
        build: () => refuelingFormBloc,
        act: (bloc) => bloc.add(SelectStation(tStation)),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.postoId, 'postoId', 'station-123')
              .having((s) => s.refuelingData.postoCnpj, 'postoCnpj', '12345678000190'),
        ],
      );
    });

    group('UpdateKm', () {
      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'updates km field',
        build: () => refuelingFormBloc,
        act: (bloc) => bloc.add(const UpdateKm(75000)),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.kmAtual, 'kmAtual', 75000),
        ],
      );
    });

    group('ToggleArla', () {
      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'enables arla when true',
        build: () => refuelingFormBloc,
        act: (bloc) => bloc.add(const ToggleArla(true)),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.abastecerArla, 'abastecerArla', true),
        ],
      );

      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'disables arla when false',
        build: () => refuelingFormBloc,
        seed: () => const RefuelingFormUpdated(RefuelingDataEntity(
          veiculoId: '',
          veiculoPlaca: '',
          kmAtual: 0,
          combustivel: 'diesel',
          abastecerArla: true,
        )),
        act: (bloc) => bloc.add(const ToggleArla(false)),
        expect: () => [
          isA<RefuelingFormUpdated>()
              .having((s) => s.refuelingData.abastecerArla, 'abastecerArla', false),
        ],
      );
    });

    group('ClearForm', () {
      blocTest<RefuelingFormBloc, RefuelingFormState>(
        'resets to initial state',
        build: () => refuelingFormBloc,
        seed: () => const RefuelingFormUpdated(RefuelingDataEntity(
          veiculoId: tVeiculoId,
          veiculoPlaca: tVeiculoPlaca,
          kmAtual: tKmAtual,
          combustivel: tCombustivel,
          abastecerArla: true,
          observacoes: tObservacoes,
        )),
        act: (bloc) => bloc.add(const ClearForm()),
        expect: () => [
          const RefuelingFormInitial(),
        ],
      );
    });
  });
}
