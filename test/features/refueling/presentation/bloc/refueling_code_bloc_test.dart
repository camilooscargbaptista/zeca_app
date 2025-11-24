import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/errors/failures.dart';
import 'package:zeca_app/features/refueling/domain/entities/refueling_code_entity.dart';
import 'package:zeca_app/features/refueling/domain/entities/refueling_shared_entities.dart';
import 'package:zeca_app/features/refueling/domain/usecases/generate_refueling_code_usecase.dart';
import 'package:zeca_app/features/refueling/domain/usecases/validate_refueling_code_usecase.dart';
import 'package:zeca_app/features/refueling/presentation/bloc/refueling_code_bloc.dart';

// Mocks
class MockGenerateRefuelingCodeUseCase extends Mock implements GenerateRefuelingCodeUseCase {}
class MockValidateRefuelingCodeUseCase extends Mock implements ValidateRefuelingCodeUseCase {}

void main() {
  late RefuelingCodeBloc refuelingCodeBloc;
  late MockGenerateRefuelingCodeUseCase mockGenerateRefuelingCodeUseCase;
  late MockValidateRefuelingCodeUseCase mockValidateRefuelingCodeUseCase;

  // Test data
  const tVeiculoId = 'vehicle-123';
  const tVeiculoPlaca = 'ABC1234';
  const tKmAtual = 50000;
  const tCombustivel = 'DIESEL';
  const tAbastecerArla = true;
  const tCodigo = 'ZECA123456';

  final tRefuelingCode = RefuelingCodeEntity(
    id: 'code-123',
    codigo: tCodigo,
    qrCode: 'QR_CODE_DATA',
    veiculo: const RefuelingVehicleEntity(
      id: tVeiculoId,
      placa: tVeiculoPlaca,
      modelo: 'Caminhão',
      marca: 'Mercedes',
    ),
    posto: const RefuelingStationEntity(
      id: 'station-123',
      cnpj: '12345678000190',
      nome: 'Posto Shell',
      endereco: 'Rua Principal, 100',
    ),
    dadosAbastecimento: const RefuelingDataEntity(
      combustivel: tCombustivel,
      precoLitro: 5.99,
      quantidadeMaxima: 300.0,
      valorMaximo: 1797.0,
      kmRegistrado: tKmAtual,
      abastecerArla: tAbastecerArla,
    ),
    validade: RefuelingValidityEntity(
      validoAte: DateTime.now().add(const Duration(hours: 2)),
      tempoRestanteMinutos: 120,
    ),
    status: 'ATIVO',
    geradoEm: DateTime.now(),
    geradoPor: const RefuelingUserEntity(
      id: 'user-123',
      nome: 'João Motorista',
      cpf: '12345678900',
    ),
  );

  setUp(() {
    mockGenerateRefuelingCodeUseCase = MockGenerateRefuelingCodeUseCase();
    mockValidateRefuelingCodeUseCase = MockValidateRefuelingCodeUseCase();

    refuelingCodeBloc = RefuelingCodeBloc(
      generateRefuelingCodeUseCase: mockGenerateRefuelingCodeUseCase,
      validateRefuelingCodeUseCase: mockValidateRefuelingCodeUseCase,
    );
  });

  tearDown(() {
    refuelingCodeBloc.close();
  });

  group('RefuelingCodeBloc', () {
    test('initial state is RefuelingCodeInitial', () {
      expect(refuelingCodeBloc.state, equals(const RefuelingCodeInitial()));
    });

    group('GenerateRefuelingCode', () {
      blocTest<RefuelingCodeBloc, RefuelingCodeState>(
        'emits [RefuelingCodeLoading, RefuelingCodeGenerated] when generation succeeds',
        build: () {
          when(() => mockGenerateRefuelingCodeUseCase(
                veiculoId: tVeiculoId,
                veiculoPlaca: tVeiculoPlaca,
                kmAtual: tKmAtual,
                combustivel: tCombustivel,
                abastecerArla: tAbastecerArla,
                postoId: any(named: 'postoId'),
                postoCnpj: any(named: 'postoCnpj'),
                observacoes: any(named: 'observacoes'),
              )).thenAnswer((_) async => Right(tRefuelingCode));
          return refuelingCodeBloc;
        },
        act: (bloc) => bloc.add(const GenerateRefuelingCode(
          veiculoId: tVeiculoId,
          veiculoPlaca: tVeiculoPlaca,
          kmAtual: tKmAtual,
          combustivel: tCombustivel,
          abastecerArla: tAbastecerArla,
        )),
        expect: () => [
          const RefuelingCodeLoading(),
          RefuelingCodeGenerated(tRefuelingCode),
        ],
        verify: (_) {
          verify(() => mockGenerateRefuelingCodeUseCase(
                veiculoId: tVeiculoId,
                veiculoPlaca: tVeiculoPlaca,
                kmAtual: tKmAtual,
                combustivel: tCombustivel,
                abastecerArla: tAbastecerArla,
                postoId: any(named: 'postoId'),
                postoCnpj: any(named: 'postoCnpj'),
                observacoes: any(named: 'observacoes'),
              )).called(1);
        },
      );

      blocTest<RefuelingCodeBloc, RefuelingCodeState>(
        'emits [RefuelingCodeLoading, RefuelingCodeError] when generation fails',
        build: () {
          when(() => mockGenerateRefuelingCodeUseCase(
                veiculoId: any(named: 'veiculoId'),
                veiculoPlaca: any(named: 'veiculoPlaca'),
                kmAtual: any(named: 'kmAtual'),
                combustivel: any(named: 'combustivel'),
                abastecerArla: any(named: 'abastecerArla'),
                postoId: any(named: 'postoId'),
                postoCnpj: any(named: 'postoCnpj'),
                observacoes: any(named: 'observacoes'),
              )).thenAnswer((_) async => const Left(ServerFailure(message: 'Erro ao gerar código')));
          return refuelingCodeBloc;
        },
        act: (bloc) => bloc.add(const GenerateRefuelingCode(
          veiculoId: tVeiculoId,
          veiculoPlaca: tVeiculoPlaca,
          kmAtual: tKmAtual,
          combustivel: tCombustivel,
          abastecerArla: false,
        )),
        expect: () => [
          const RefuelingCodeLoading(),
          const RefuelingCodeError('Erro ao gerar código'),
        ],
      );
    });

    group('ValidateRefuelingCode', () {
      blocTest<RefuelingCodeBloc, RefuelingCodeState>(
        'emits [RefuelingCodeLoading, RefuelingCodeValidated] when validation succeeds',
        build: () {
          when(() => mockValidateRefuelingCodeUseCase(tCodigo))
              .thenAnswer((_) async => Right(tRefuelingCode));
          return refuelingCodeBloc;
        },
        act: (bloc) => bloc.add(const ValidateRefuelingCode(tCodigo)),
        expect: () => [
          const RefuelingCodeLoading(),
          RefuelingCodeValidated(tRefuelingCode),
        ],
        verify: (_) {
          verify(() => mockValidateRefuelingCodeUseCase(tCodigo)).called(1);
        },
      );

      blocTest<RefuelingCodeBloc, RefuelingCodeState>(
        'emits [RefuelingCodeLoading, RefuelingCodeError] when code is invalid',
        build: () {
          when(() => mockValidateRefuelingCodeUseCase(any()))
              .thenAnswer((_) async => const Left(ValidationFailure(message: 'Código inválido')));
          return refuelingCodeBloc;
        },
        act: (bloc) => bloc.add(const ValidateRefuelingCode('INVALID')),
        expect: () => [
          const RefuelingCodeLoading(),
          const RefuelingCodeError('Código inválido'),
        ],
      );

      blocTest<RefuelingCodeBloc, RefuelingCodeState>(
        'emits [RefuelingCodeLoading, RefuelingCodeError] when code is expired',
        build: () {
          when(() => mockValidateRefuelingCodeUseCase(any()))
              .thenAnswer((_) async => const Left(ValidationFailure(message: 'Código expirado')));
          return refuelingCodeBloc;
        },
        act: (bloc) => bloc.add(const ValidateRefuelingCode(tCodigo)),
        expect: () => [
          const RefuelingCodeLoading(),
          const RefuelingCodeError('Código expirado'),
        ],
      );
    });

    group('ClearRefuelingCode', () {
      blocTest<RefuelingCodeBloc, RefuelingCodeState>(
        'emits [RefuelingCodeInitial] when clearing code',
        build: () => refuelingCodeBloc,
        seed: () => RefuelingCodeGenerated(tRefuelingCode),
        act: (bloc) => bloc.add(const ClearRefuelingCode()),
        expect: () => [
          const RefuelingCodeInitial(),
        ],
      );
    });
  });
}
