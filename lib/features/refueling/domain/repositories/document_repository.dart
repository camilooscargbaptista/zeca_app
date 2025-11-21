import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document_entity.dart';

abstract class DocumentRepository {
  Future<Either<Failure, DocumentEntity>> uploadDocument({
    required String filePath,
    required String refuelingId,
    required DocumentType tipo,
    String? descricao,
  });

  Future<Either<Failure, List<DocumentEntity>>> getRefuelingDocuments(String refuelingId);

  Future<Either<Failure, void>> deleteDocument(String documentId);

  Future<Either<Failure, String>> compressImage(String imagePath);

  Future<Either<Failure, String>> cropImage({
    required String imagePath,
    required double x,
    required double y,
    required double width,
    required double height,
  });
}
