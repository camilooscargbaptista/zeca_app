import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/errors/failures.dart';
import 'package:zeca_app/features/refueling/domain/entities/document_entity.dart';
import 'package:zeca_app/features/refueling/domain/usecases/upload_document_usecase.dart';
import 'package:zeca_app/features/refueling/presentation/bloc/document_bloc.dart';

// Mock
class MockUploadDocumentUseCase extends Mock implements UploadDocumentUseCase {}

void main() {
  late DocumentBloc documentBloc;
  late MockUploadDocumentUseCase mockUploadDocumentUseCase;

  // Test data
  const tFilePath = '/path/to/document.pdf';
  const tRefuelingId = 'refueling-123';
  const tTipo = DocumentType.notaFiscal;
  const tDescricao = 'Nota fiscal do abastecimento';

  final tDocument = DocumentEntity(
    id: 'doc-123',
    nomeOriginal: 'nota_fiscal.pdf',
    nomeArquivo: 'doc-123.pdf',
    tipo: 'nota_fiscal',
    tamanhoBytes: 1024000,
    mimeType: 'application/pdf',
    url: 'https://storage.example.com/doc-123.pdf',
    uploadadoEm: DateTime(2024, 1, 15),
    uploadadoPor: const DocumentUserEntity(
      id: 'user-123',
      nome: 'João Motorista',
    ),
    refuelingId: tRefuelingId,
  );

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue('/fake/path');
    registerFallbackValue('fake-id');
    registerFallbackValue(DocumentType.notaFiscal);
  });

  setUp(() {
    mockUploadDocumentUseCase = MockUploadDocumentUseCase();
    documentBloc = DocumentBloc(
      uploadDocumentUseCase: mockUploadDocumentUseCase,
    );
  });

  tearDown(() {
    documentBloc.close();
  });

  group('DocumentBloc', () {
    test('initial state is DocumentInitial', () {
      expect(documentBloc.state, equals(const DocumentInitial()));
    });

    group('UploadDocument', () {
      blocTest<DocumentBloc, DocumentState>(
        'emits [DocumentLoading, DocumentUploaded] when upload succeeds',
        build: () {
          when(() => mockUploadDocumentUseCase(
                filePath: tFilePath,
                refuelingId: tRefuelingId,
                tipo: tTipo,
                descricao: tDescricao,
              )).thenAnswer((_) async => Right(tDocument));
          return documentBloc;
        },
        act: (bloc) => bloc.add(const UploadDocument(
          filePath: tFilePath,
          refuelingId: tRefuelingId,
          tipo: tTipo,
          descricao: tDescricao,
        )),
        expect: () => [
          const DocumentLoading(),
          DocumentUploaded(tDocument),
        ],
        verify: (_) {
          verify(() => mockUploadDocumentUseCase(
                filePath: tFilePath,
                refuelingId: tRefuelingId,
                tipo: tTipo,
                descricao: tDescricao,
              )).called(1);
        },
      );

      blocTest<DocumentBloc, DocumentState>(
        'emits [DocumentLoading, DocumentError] when upload fails with server error',
        build: () {
          when(() => mockUploadDocumentUseCase(
                filePath: any(named: 'filePath'),
                refuelingId: any(named: 'refuelingId'),
                tipo: any(named: 'tipo'),
                descricao: any(named: 'descricao'),
              )).thenAnswer((_) async => const Left(ServerFailure(message: 'Erro ao fazer upload')));
          return documentBloc;
        },
        act: (bloc) => bloc.add(const UploadDocument(
          filePath: tFilePath,
          refuelingId: tRefuelingId,
          tipo: tTipo,
          descricao: tDescricao,
        )),
        expect: () => [
          const DocumentLoading(),
          const DocumentError('Erro ao fazer upload'),
        ],
      );

      blocTest<DocumentBloc, DocumentState>(
        'emits [DocumentLoading, DocumentError] when file is too large',
        build: () {
          when(() => mockUploadDocumentUseCase(
                filePath: any(named: 'filePath'),
                refuelingId: any(named: 'refuelingId'),
                tipo: any(named: 'tipo'),
                descricao: any(named: 'descricao'),
              )).thenAnswer((_) async => const Left(ValidationFailure(message: 'Arquivo muito grande')));
          return documentBloc;
        },
        act: (bloc) => bloc.add(const UploadDocument(
          filePath: tFilePath,
          refuelingId: tRefuelingId,
          tipo: tTipo,
        )),
        expect: () => [
          const DocumentLoading(),
          const DocumentError('Arquivo muito grande'),
        ],
      );
    });

    group('DeleteDocument', () {
      blocTest<DocumentBloc, DocumentState>(
        'emits [DocumentInitial] (TODO implementation)',
        build: () => documentBloc,
        act: (bloc) => bloc.add(const DeleteDocument('doc-123')),
        expect: () => [
          const DocumentInitial(),
        ],
      );
    });

    group('ClearDocuments', () {
      blocTest<DocumentBloc, DocumentState>(
        'emits [DocumentInitial] when clearing documents',
        build: () => documentBloc,
        seed: () => DocumentUploaded(tDocument),
        act: (bloc) => bloc.add(const ClearDocuments()),
        expect: () => [
          const DocumentInitial(),
        ],
      );
    });
  });
}
