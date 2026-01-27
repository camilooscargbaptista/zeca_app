import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/document_model.dart';
import '../../domain/entities/document_entity.dart';

abstract class DocumentRemoteDataSource {
  Future<DocumentModel> uploadDocument({
    required String filePath,
    required String refuelingId,
    required DocumentType tipo,
    String? descricao,
  });

  Future<List<DocumentModel>> getRefuelingDocuments(String refuelingId);

  Future<void> deleteDocument(String documentId);

  Future<String> compressImage(String imagePath);

  Future<String> cropImage({
    required String imagePath,
    required double x,
    required double y,
    required double width,
    required double height,
  });
}

@LazySingleton(as: DocumentRemoteDataSource)
class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final DioClient _client;

  DocumentRemoteDataSourceImpl(this._client);

  @override
  Future<DocumentModel> uploadDocument({
    required String filePath,
    required String refuelingId,
    required DocumentType tipo,
    String? descricao,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'refueling_id': refuelingId,
      'document_type': tipo.value,
      if (descricao != null) 'description': descricao,
    });

    final response = await _client.post(
      ApiConstants.documents,
      data: formData,
    );
    return DocumentModel.fromJson(response.data['data']);
  }

  @override
  Future<List<DocumentModel>> getRefuelingDocuments(String refuelingId) async {
    final response = await _client.get(
      '${ApiConstants.documents}/refueling/$refuelingId',
    );

    final List<dynamic> documentsJson = response.data['data'];
    return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    await _client.delete('${ApiConstants.documents}/$documentId');
  }

  @override
  Future<String> compressImage(String imagePath) async {
    // TODO: Implementar compressão de imagem local
    // Por enquanto, retorna o caminho original
    return imagePath;
  }

  @override
  Future<String> cropImage({
    required String imagePath,
    required double x,
    required double y,
    required double width,
    required double height,
  }) async {
    // TODO: Implementar crop de imagem local
    // Por enquanto, retorna o caminho original
    return imagePath;
  }
}
