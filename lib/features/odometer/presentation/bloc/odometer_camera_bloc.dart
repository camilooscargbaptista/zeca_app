import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'odometer_camera_event.dart';
part 'odometer_camera_state.dart';
part 'odometer_camera_bloc.freezed.dart';

/// BLoC para gerenciar estado da câmera de odômetro
/// 
/// Responsabilidades:
/// - Gerenciar inicialização da câmera
/// - Controlar estado de processamento OCR
/// - Gerenciar níveis de zoom
/// - Armazenar resultado extraído
@injectable
class OdometerCameraBloc extends Bloc<OdometerCameraEvent, OdometerCameraState> {
  OdometerCameraBloc() : super(const OdometerCameraState()) {
    on<_InitializeCamera>(_onInitializeCamera);
    on<_CameraInitialized>(_onCameraInitialized);
    on<_InitializationFailed>(_onInitializationFailed);
    on<_StartProcessing>(_onStartProcessing);
    on<_ProcessingCompleted>(_onProcessingCompleted);
    on<_ProcessingFailed>(_onProcessingFailed);
    on<_SetZoomLevel>(_onSetZoomLevel);
    on<_ClearError>(_onClearError);
    on<_Reset>(_onReset);
  }

  void _onInitializeCamera(
    _InitializeCamera event,
    Emitter<OdometerCameraState> emit,
  ) {
    // Estado inicial - aguardando inicialização
    emit(state.copyWith(
      isInitialized: false,
      hasError: false,
      errorMessage: null,
    ));
  }

  void _onCameraInitialized(
    _CameraInitialized event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      isInitialized: true,
      minZoomLevel: event.minZoom,
      maxZoomLevel: event.maxZoom,
      currentZoomLevel: event.minZoom,
    ));
  }

  void _onInitializationFailed(
    _InitializationFailed event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      isInitialized: false,
      hasError: true,
      errorMessage: event.message,
    ));
  }

  void _onStartProcessing(
    _StartProcessing event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      isProcessing: true,
      hasError: false,
      errorMessage: null,
      extractedValue: null,
      formattedValue: null,
    ));
  }

  void _onProcessingCompleted(
    _ProcessingCompleted event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      isProcessing: false,
      extractedValue: event.rawValue,
      formattedValue: event.formattedValue,
    ));
  }

  void _onProcessingFailed(
    _ProcessingFailed event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      isProcessing: false,
      hasError: true,
      errorMessage: event.message,
    ));
  }

  void _onSetZoomLevel(
    _SetZoomLevel event,
    Emitter<OdometerCameraState> emit,
  ) {
    final clampedZoom = event.zoom.clamp(
      state.minZoomLevel,
      state.maxZoomLevel,
    );
    emit(state.copyWith(currentZoomLevel: clampedZoom));
  }

  void _onClearError(
    _ClearError event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      hasError: false,
      errorMessage: null,
    ));
  }

  void _onReset(
    _Reset event,
    Emitter<OdometerCameraState> emit,
  ) {
    emit(state.copyWith(
      isProcessing: false,
      hasError: false,
      errorMessage: null,
      extractedValue: null,
      formattedValue: null,
    ));
  }
}
