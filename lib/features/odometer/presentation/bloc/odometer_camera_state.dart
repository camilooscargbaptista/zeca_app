part of 'odometer_camera_bloc.dart';

/// Estados do OdometerCameraBloc
@freezed
class OdometerCameraState with _$OdometerCameraState {
  const factory OdometerCameraState({
    // Estado de inicialização da câmera
    @Default(false) bool isInitialized,
    @Default(false) bool isProcessing,
    @Default(false) bool hasError,
    @Default(null) String? errorMessage,

    // Configurações de zoom
    @Default(1.0) double currentZoomLevel,
    @Default(1.0) double minZoomLevel,
    @Default(1.0) double maxZoomLevel,

    // Resultado do OCR
    @Default(null) int? extractedValue,
    @Default(null) String? formattedValue,
  }) = _OdometerCameraState;
}
