import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../core/utils/odometer_formatter.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../domain/services/odometer_ocr_service.dart';
import '../bloc/odometer_camera_bloc.dart';

/// Tela para capturar foto do odômetro e extrair valor via OCR
class OdometerCameraPage extends StatefulWidget {
  final Function(String)? onOdometerExtracted;

  const OdometerCameraPage({
    Key? key,
    this.onOdometerExtracted,
  }) : super(key: key);

  @override
  State<OdometerCameraPage> createState() => _OdometerCameraPageState();
}

class _OdometerCameraPageState extends State<OdometerCameraPage> {
  // Câmera precisa ficar no State (não pode ser gerenciada pelo BLoC)
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  final OdometerOcrService _ocrService = OdometerOcrService();
  final ImagePicker _imagePicker = ImagePicker();
  
  late final OdometerCameraBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = OdometerCameraBloc();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _bloc.add(const OdometerCameraEvent.initializeCamera());
    
    try {
      // Verificar permissão
      final status = await Permission.camera.status;
      if (status.isDenied) {
        final newStatus = await Permission.camera.request();
        if (newStatus.isDenied) {
          if (mounted) {
            ErrorDialog.show(
              context,
              title: 'Permissão Negada',
              message: 'É necessário permitir o acesso à câmera para capturar o odômetro.',
            );
            Navigator.of(context).pop();
          }
          return;
        }
      }

      if (status.isPermanentlyDenied) {
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Permissão Bloqueada',
            message: 'A permissão da câmera foi bloqueada. Vá em Configurações > Zeca App para habilitar.',
          );
          Navigator.of(context).pop();
        }
        return;
      }

      // Obter câmeras disponíveis
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro',
            message: 'Nenhuma câmera disponível no dispositivo.',
          );
          Navigator.of(context).pop();
        }
        return;
      }

      // Inicializar câmera traseira (ou primeira disponível)
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Obter níveis de zoom disponíveis
      final minZoom = await _cameraController!.getMinZoomLevel();
      final maxZoom = await _cameraController!.getMaxZoomLevel();

      if (mounted) {
        _bloc.add(OdometerCameraEvent.cameraInitialized(
          minZoom: minZoom,
          maxZoom: maxZoom,
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao inicializar câmera: $e');
      }
      if (mounted) {
        _bloc.add(OdometerCameraEvent.initializationFailed('Erro ao inicializar câmera: $e'));
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao inicializar câmera: $e',
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _bloc.add(const OdometerCameraEvent.startProcessing());

    try {
      // Capturar foto
      final XFile image = await _cameraController!.takePicture();

      // Permitir recortar a imagem para focar apenas no odômetro
      final croppedFile = await _cropImage(image.path);

      if (croppedFile == null) {
        // Usuário cancelou o crop, deletar foto original
        try {
          final file = File(image.path);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Erro ao deletar foto: $e');
          }
        }

        if (mounted) {
          _bloc.add(const OdometerCameraEvent.processingFailed('Captura cancelada'));
          _bloc.add(const OdometerCameraEvent.reset());
        }
        return;
      }

      // Processar com OCR na imagem recortada
      if (kDebugMode) {
        print('📸 Foto capturada e recortada: ${croppedFile.path}');
        print('🔍 Processando com OCR...');
      }

      final extractedValue = await _ocrService.extractOdometerValue(croppedFile.path);

      // Deletar fotos temporárias
      try {
        final originalFile = File(image.path);
        if (await originalFile.exists()) {
          await originalFile.delete();
        }
        if (await croppedFile.exists()) {
          await croppedFile.delete();
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Erro ao deletar fotos temporárias: $e');
        }
      }

      if (mounted) {
        if (extractedValue != null && extractedValue.isNotEmpty) {
          // Converter para int e formatar
          final odometerValue = int.tryParse(extractedValue) ?? 0;
          final formattedValue = OdometerFormatter.formatValue(odometerValue);

          _bloc.add(OdometerCameraEvent.processingCompleted(
            rawValue: odometerValue,
            formattedValue: formattedValue,
          ));

          // Mostrar diálogo de confirmação
          _showConfirmationDialog(formattedValue, odometerValue);
        } else {
          _bloc.add(const OdometerCameraEvent.processingFailed('Valor não extraído'));
          ErrorDialog.show(
            context,
            title: 'Valor Não Encontrado',
            message: 'Não foi possível extrair o valor do odômetro da foto.\n\n'
                'Dicas:\n'
                '• Recorte apenas a área do odômetro\n'
                '• Certifique-se de que está nítido e bem iluminado\n'
                '• Evite reflexos ou sombras\n\n'
                'Tente novamente ou digite o valor manualmente.',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao capturar foto: $e');
      }
      if (mounted) {
        _bloc.add(OdometerCameraEvent.processingFailed('Erro: $e'));
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao processar foto: $e',
        );
      }
    }
  }

  /// Recortar imagem para focar apenas no odômetro
  Future<File?> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 1), // Proporção horizontal para odômetro
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Odômetro',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false, // Permitir ajuste livre
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
            hideBottomControls: false,
            showCropGrid: true,
            cropFrameColor: Colors.green,
            activeControlsWidgetColor: Colors.green,
          ),
          IOSUiSettings(
            title: 'Recortar Odômetro',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
            resetAspectRatioEnabled: false,
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao recortar imagem: $e');
      }
      // Se falhar o crop, usar imagem original
      return File(imagePath);
    }
  }

  /// Abrir galeria para selecionar foto
  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) return;

      _bloc.add(const OdometerCameraEvent.startProcessing());

      // Recortar imagem
      final croppedFile = await _cropImage(image.path);

      if (croppedFile == null) {
        if (mounted) {
          _bloc.add(const OdometerCameraEvent.reset());
        }
        return;
      }

      // Processar com OCR
      if (kDebugMode) {
        print('📸 Imagem selecionada e recortada: ${croppedFile.path}');
        print('🔍 Processando com OCR...');
      }

      final extractedValue = await _ocrService.extractOdometerValue(croppedFile.path);

      // Deletar arquivo temporário
      try {
        if (await croppedFile.exists()) {
          await croppedFile.delete();
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Erro ao deletar arquivo temporário: $e');
        }
      }

      if (mounted) {
        if (extractedValue != null && extractedValue.isNotEmpty) {
          final odometerValue = int.tryParse(extractedValue) ?? 0;
          final formattedValue = OdometerFormatter.formatValue(odometerValue);
          
          _bloc.add(OdometerCameraEvent.processingCompleted(
            rawValue: odometerValue,
            formattedValue: formattedValue,
          ));
          
          _showConfirmationDialog(formattedValue, odometerValue);
        } else {
          _bloc.add(const OdometerCameraEvent.processingFailed('Valor não extraído'));
          ErrorDialog.show(
            context,
            title: 'Valor Não Encontrado',
            message: 'Não foi possível extrair o valor do odômetro da imagem.\n\n'
                'Tente recortar apenas a área do odômetro ou digite o valor manualmente.',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao selecionar imagem: $e');
      }
      if (mounted) {
        _bloc.add(OdometerCameraEvent.processingFailed('Erro: $e'));
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao processar imagem: $e',
        );
      }
    }
  }

  /// Ajustar zoom da câmera
  Future<void> _setZoomLevel(double zoom) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final state = _bloc.state;
    final clampedZoom = zoom.clamp(state.minZoomLevel, state.maxZoomLevel);
    await _cameraController!.setZoomLevel(clampedZoom);
    _bloc.add(OdometerCameraEvent.setZoomLevel(clampedZoom));
  }

  void _showConfirmationDialog(String formattedValue, int rawValue) {
    _bloc.add(const OdometerCameraEvent.reset()); // Reseta processing
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odômetro Detectado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Valor extraído da foto:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.speed, color: Colors.green[700], size: 28),
                  const SizedBox(width: 12),
                  Text(
                    formattedValue,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  const Text(
                    ' km',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Este valor está correto?',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tentar Novamente'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmValue(rawValue);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text('Usar Este Valor'),
          ),
        ],
      ),
    );
  }

  void _confirmValue(int value) {
    // Formatar valor
    final formattedValue = OdometerFormatter.formatValue(value);

    // Chamar callback se fornecido
    if (widget.onOdometerExtracted != null) {
      widget.onOdometerExtracted!(formattedValue);
    }

    // Retornar valor para tela anterior
    Navigator.of(context).pop(formattedValue);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _ocrService.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<OdometerCameraBloc, OdometerCameraState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Capturar Odômetro'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: _pickFromGallery,
                  tooltip: 'Selecionar da galeria',
                ),
              ],
            ),
            body: state.isProcessing
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Processando imagem...',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Aguarde enquanto extraímos o valor do odômetro',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : state.isInitialized && _cameraController != null
                    ? GestureDetector(
                        onScaleUpdate: (details) {
                          if (details.scale != 1.0) {
                            final newZoom = state.currentZoomLevel * details.scale;
                            _setZoomLevel(newZoom);
                          }
                        },
                        child: Stack(
                          children: [
                            // Preview da câmera
                            Positioned.fill(
                              child: CameraPreview(_cameraController!),
                            ),
                          // Overlay com guia visual
                          Positioned.fill(
                            child: _buildOverlay(),
                          ),
                          // Controles de zoom
                          Positioned(
                            right: 16,
                            top: 100,
                            child: Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  onPressed: () => _setZoomLevel(state.currentZoomLevel + 0.5),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Slider(
                                      value: state.currentZoomLevel,
                                      min: state.minZoomLevel,
                                      max: state.maxZoomLevel,
                                      onChanged: _setZoomLevel,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.white),
                                  onPressed: () => _setZoomLevel(state.currentZoomLevel - 0.5),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botão de captura
                          Positioned(
                            bottom: 40,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: FloatingActionButton(
                                onPressed: _capturePhoto,
                                backgroundColor: Colors.red,
                                child: const Icon(Icons.camera_alt, size: 32),
                              ),
                            ),
                          ),
                          // Instruções
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Dicas para melhor resultado:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '• Use o zoom para aproximar o odômetro\n'
                                    '• Após capturar, recorte apenas a área do odômetro\n'
                                    '• Certifique-se de que está bem iluminado\n'
                                    '• Evite reflexos e sombras',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildOverlay() {
    return CustomPaint(
      painter: OdometerOverlayPainter(),
      child: Container(),
    );
  }
}

/// Painter para desenhar overlay com guia visual
class OdometerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Área central para posicionar o odômetro (60% da largura, 30% da altura)
    final rectWidth = size.width * 0.6;
    final rectHeight = size.height * 0.3;
    final rectLeft = (size.width - rectWidth) / 2;
    final rectTop = (size.height - rectHeight) / 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
      const Radius.circular(12),
    );

    // Desenhar retângulo central
    canvas.drawRRect(rect, paint);

    // Desenhar cantos destacados
    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Canto superior esquerdo
    canvas.drawLine(
      Offset(rectLeft, rectTop),
      Offset(rectLeft + cornerLength, rectTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rectLeft, rectTop),
      Offset(rectLeft, rectTop + cornerLength),
      cornerPaint,
    );

    // Canto superior direito
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop),
      Offset(rectLeft + rectWidth - cornerLength, rectTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop),
      Offset(rectLeft + rectWidth, rectTop + cornerLength),
      cornerPaint,
    );

    // Canto inferior esquerdo
    canvas.drawLine(
      Offset(rectLeft, rectTop + rectHeight),
      Offset(rectLeft + cornerLength, rectTop + rectHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rectLeft, rectTop + rectHeight),
      Offset(rectLeft, rectTop + rectHeight - cornerLength),
      cornerPaint,
    );

    // Canto inferior direito
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop + rectHeight),
      Offset(rectLeft + rectWidth - cornerLength, rectTop + rectHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop + rectHeight),
      Offset(rectLeft + rectWidth, rectTop + rectHeight - cornerLength),
      cornerPaint,
    );

    // Texto "Posicione o odômetro aqui"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Posicione o odômetro aqui',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        rectTop - textPainter.height - 20,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
