// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentModelImpl _$$DocumentModelImplFromJson(Map<String, dynamic> json) =>
    _$DocumentModelImpl(
      id: json['id'] as String,
      originalName: json['original_name'] as String,
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      uploadedById: json['uploaded_by_id'] as String,
      uploadedByName: json['uploaded_by_name'] as String,
      refuelingId: json['refueling_id'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$DocumentModelImplToJson(_$DocumentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_name': instance.originalName,
      'file_name': instance.fileName,
      'file_type': instance.fileType,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'uploaded_by_id': instance.uploadedById,
      'uploaded_by_name': instance.uploadedByName,
      'refueling_id': instance.refuelingId,
      'description': instance.description,
    };
