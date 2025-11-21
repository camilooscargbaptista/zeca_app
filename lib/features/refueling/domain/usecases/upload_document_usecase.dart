import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

@injectable
class UploadDocumentUseCase {
  final DocumentRepository repository;

  UploadDocumentUseCase(this.repository);

  Future<Either<Failure, DocumentEntity>> call({
    required String filePath,
    required String refuelingId,
    required DocumentType tipo,
    String? descricao,
  }) async {
    return await repository.uploadDocument(
      filePath: filePath,
      refuelingId: refuelingId,
      tipo: tipo,
      descricao: descricao,
    );
  }
}
