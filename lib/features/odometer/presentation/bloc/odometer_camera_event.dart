part of 'odometer_camera_bloc.dart';

/// Eventos do OdometerCameraBloc
@freezed
class OdometerCameraEvent with _$OdometerCameraEvent {
  /// Inicializa a câmera
  const factory OdometerCameraEvent.initializeCamera() = _InitializeCamera;

  /// Câmera inicializada com sucesso
  const factory OdometerCameraEvent.cameraInitialized({
    required double minZoom,
    required double maxZoom,
  }) = _CameraInitialized;

  /// Erro na inicialização
  const factory OdometerCameraEvent.initializationFailed(String message) = _InitializationFailed;

  /// Captura foto da câmera
  const factory OdometerCameraEvent.capturePhoto() = _CapturePhoto;

  /// Seleciona foto da galeria
  const factory OdometerCameraEvent.pickFromGallery() = _PickFromGallery;

  /// Inicia processamento OCR
  const factory OdometerCameraEvent.startProcessing() = _StartProcessing;

  /// Processamento OCR concluído com sucesso
  const factory OdometerCameraEvent.processingCompleted({
    required int rawValue,
    required String formattedValue,
  }) = _ProcessingCompleted;

  /// Processamento OCR falhou
  const factory OdometerCameraEvent.processingFailed(String message) = _ProcessingFailed;

  /// Ajusta nível de zoom
  const factory OdometerCameraEvent.setZoomLevel(double zoom) = _SetZoomLevel;

  /// Usuário confirmou o valor extraído
  const factory OdometerCameraEvent.confirmValue() = _ConfirmValue;

  /// Limpa erro
  const factory OdometerCameraEvent.clearError() = _ClearError;

  /// Reseta estado para nova captura
  const factory OdometerCameraEvent.reset() = _Reset;
}
