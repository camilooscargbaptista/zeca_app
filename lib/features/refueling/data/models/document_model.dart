import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/document_entity.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

@freezed
class DocumentModel with _$DocumentModel {
  const DocumentModel._();
  
  const factory DocumentModel({
    required String id,
    @JsonKey(name: 'original_name') required String originalName,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_type') required String fileType,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'mime_type') required String mimeType,
    required String url,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'uploaded_at') required DateTime uploadedAt,
    @JsonKey(name: 'uploaded_by_id') required String uploadedById,
    @JsonKey(name: 'uploaded_by_name') required String uploadedByName,
    @JsonKey(name: 'refueling_id') String? refuelingId,
    @JsonKey(name: 'description') String? description,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      nomeOriginal: originalName,
      nomeArquivo: fileName,
      tipo: fileType,
      tamanhoBytes: fileSize,
      mimeType: mimeType,
      url: url,
      urlThumbnail: thumbnailUrl,
      uploadadoEm: uploadedAt,
      uploadadoPor: DocumentUserEntity(
        id: uploadedById,
        nome: uploadedByName,
      ),
      refuelingId: refuelingId,
    );
  }
}
