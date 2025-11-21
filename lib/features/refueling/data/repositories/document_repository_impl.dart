import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_remote_datasource.dart';

@Injectable(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource _remoteDataSource;

  DocumentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DocumentEntity>> uploadDocument({
    required String filePath,
    required String refuelingId,
    required DocumentType tipo,
    String? descricao,
  }) async {
    try {
      final documentModel = await _remoteDataSource.uploadDocument(
        filePath: filePath,
        refuelingId: refuelingId,
        tipo: tipo,
        descricao: descricao,
      );
      final documentEntity = documentModel.toEntity();
      return Right(documentEntity);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DocumentEntity>>> getRefuelingDocuments(String refuelingId) async {
    try {
      final documentModels = await _remoteDataSource.getRefuelingDocuments(refuelingId);
      final documentEntities = documentModels.map((model) => model.toEntity()).toList();
      return Right(documentEntities);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String documentId) async {
    try {
      await _remoteDataSource.deleteDocument(documentId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> compressImage(String imagePath) async {
    try {
      final compressedPath = await _remoteDataSource.compressImage(imagePath);
      return Right(compressedPath);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> cropImage({
    required String imagePath,
    required double x,
    required double y,
    required double width,
    required double height,
  }) async {
    try {
      final croppedPath = await _remoteDataSource.cropImage(
        imagePath: imagePath,
        x: x,
        y: y,
        width: width,
        height: height,
      );
      return Right(croppedPath);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
