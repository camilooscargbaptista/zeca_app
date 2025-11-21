import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/usecases/upload_document_usecase.dart';

part 'document_event.dart';
part 'document_state.dart';

@injectable
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final UploadDocumentUseCase _uploadDocumentUseCase;

  DocumentBloc({
    required UploadDocumentUseCase uploadDocumentUseCase,
  })  : _uploadDocumentUseCase = uploadDocumentUseCase,
        super(const DocumentInitial()) {
    on<UploadDocument>(_onUploadDocument);
    on<DeleteDocument>(_onDeleteDocument);
    on<ClearDocuments>(_onClearDocuments);
  }

  Future<void> _onUploadDocument(
    UploadDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentLoading());

    final result = await _uploadDocumentUseCase(
      filePath: event.filePath,
      refuelingId: event.refuelingId,
      tipo: event.tipo,
      descricao: event.descricao,
    );

    result.fold(
      (failure) => emit(DocumentError(failure.message)),
      (document) => emit(DocumentUploaded(document)),
    );
  }

  void _onDeleteDocument(
    DeleteDocument event,
    Emitter<DocumentState> emit,
  ) {
    // TODO: Implementar delete document
    emit(const DocumentInitial());
  }

  void _onClearDocuments(
    ClearDocuments event,
    Emitter<DocumentState> emit,
  ) {
    emit(const DocumentInitial());
  }
}
