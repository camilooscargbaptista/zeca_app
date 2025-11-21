part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class UploadDocument extends DocumentEvent {
  final String filePath;
  final String refuelingId;
  final DocumentType tipo;
  final String? descricao;

  const UploadDocument({
    required this.filePath,
    required this.refuelingId,
    required this.tipo,
    this.descricao,
  });

  @override
  List<Object?> get props => [filePath, refuelingId, tipo, descricao];
}

class DeleteDocument extends DocumentEvent {
  final String documentId;

  const DeleteDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class ClearDocuments extends DocumentEvent {
  const ClearDocuments();
}
