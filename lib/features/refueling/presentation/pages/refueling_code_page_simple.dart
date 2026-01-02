import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_api_service.dart';
import '../../../../core/services/refueling_polling_service.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/odometer_formatter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../shared/widgets/permissions/permission_request_dialog.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';
import 'refueling_waiting_page.dart';
import 'dart:io';

class RefuelingCodePageSimple extends StatefulWidget {
  const RefuelingCodePageSimple({Key? key}) : super(key: key);

  @override
  State<RefuelingCodePageSimple> createState() => _RefuelingCodePageSimpleState();
}

class _RefuelingCodePageSimpleState extends State<RefuelingCodePageSimple> {
  String _refuelingCode = '';
  bool _isLoading = false;
  bool _isUploading = false;
  Map<String, dynamic>? _refuelingData;
  List<File> _attachedImages = [];
  int _maxImages = 3;
  
  // Dados reais passados da tela anterior
  Map<String, dynamic>? _vehicleData;
  Map<String, dynamic>? _stationData;
  String _fuelType = '';
  String _kmAtual = '';
  bool _abastecerArla = false;
  String? _refuelingId; // ID do abastecimento para polling
  
  // Serviços
  final RefuelingPollingService _pollingService = RefuelingPollingService();
  final WebSocketService _webSocketService = WebSocketService();
  final ApiService _apiService = ApiService();
  bool _usingWebSocket = false; // Flag para saber se está usando WebSocket

  /// Formatar código no padrão XXXX-XXXX-XXXXXXXX
  String _formatCode(String code) {
    if (code.isEmpty) return '';
    
    // Remover todos os caracteres não alfanuméricos
    final cleanCode = code.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    
    if (cleanCode.length <= 4) {
      return cleanCode;
    } else if (cleanCode.length <= 8) {
      return '${cleanCode.substring(0, 4)}-${cleanCode.substring(4)}';
    } else {
      return '${cleanCode.substring(0, 4)}-${cleanCode.substring(4, 8)}-${cleanCode.substring(8)}';
    }
  }

  @override
  void initState() {
    super.initState();
    // Aguardar o primeiro frame para garantir que o GoRouterState esteja disponível
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRefuelingCode();
    });
  }

  @override
  void dispose() {
    // Parar polling e desconectar WebSocket quando sair da tela
    _pollingService.stopPolling();
    _webSocketService.disconnect();
    super.dispose();
  }

  Future<void> _loadRefuelingCode() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Obter dados passados da tela anterior
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      
      if (extra != null && extra.isNotEmpty) {
        if (mounted) {
          setState(() {
            _refuelingCode = extra['code'] ?? '';
            _vehicleData = extra['vehicle_data'];
            _stationData = extra['station_data'];
            _fuelType = extra['fuel_type'] ?? '';
            // Converter km_atual para String (pode vir como int ou String)
            final kmAtualValue = extra['km_atual'];
            if (kmAtualValue != null) {
              if (kmAtualValue is int) {
                // Se for int, formatar com OdometerFormatter
                _kmAtual = OdometerFormatter.formatValue(kmAtualValue);
              } else if (kmAtualValue is String) {
                _kmAtual = kmAtualValue;
              } else {
                _kmAtual = kmAtualValue.toString();
              }
            } else {
              _kmAtual = '';
            }
            _abastecerArla = extra['abastecer_arla'] ?? false;
            _refuelingData = {
              'code': extra['code'],
              'expires_at': extra['expires_at'],
              'status': extra['status'],
              'created_at': extra['created_at'],
            };
            _refuelingId = extra['id'] as String?; // ID do abastecimento (pode não existir ainda)
            _isLoading = false;
          });
          
          // Iniciar polling sempre (usando código ou refueling_id)
          _startPolling();
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Se não há dados, mostrar erro mas não navegar automaticamente
          // O usuário pode usar o botão de voltar ou cancelar
          ErrorDialog.show(
            context,
            title: 'Dados não encontrados',
            message: 'Não foi possível carregar os dados do código de abastecimento.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Se erro, mostrar erro mas não navegar automaticamente
        ErrorDialog.show(
          context,
          title: 'Erro ao carregar código',
          message: 'Erro ao carregar dados do código de abastecimento: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Código de Abastecimento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBackPressed,
        ),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Card do Código QR
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Código de Abastecimento',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // QR Code
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: QrImageView(
                            data: _formatCode(_refuelingCode),
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Código de Texto
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatCode(_refuelingCode),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Botão Copiar
                        ElevatedButton.icon(
                          onPressed: _copyCode,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copiar Código'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Card de Informações
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informações do Abastecimento',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (_vehicleData != null && _stationData != null) ...[
                          _buildInfoRow('Veículo', _vehicleData!['placa'] ?? 'N/A'),
                          _buildInfoRow('Posto', _stationData!['nome'] ?? 'N/A'),
                          _buildInfoRow('Combustível', _fuelType.isNotEmpty ? _fuelType : 'N/A'),
                          _buildInfoRow('KM Atual', _kmAtual.isNotEmpty ? _kmAtual : 'N/A'),
                          if (_abastecerArla)
                            _buildInfoRow('ARLA 32', 'Sim'),
                          if (_refuelingData?['expires_at'] != null)
                            _buildInfoRow('Validade', _formatValidity(_refuelingData!['expires_at'])),
                        ] else ...[
                          _buildInfoRow('Veículo', 'N/A'),
                          _buildInfoRow('Posto', 'N/A'),
                          _buildInfoRow('Combustível', 'N/A'),
                          _buildInfoRow('KM Atual', 'N/A'),
                        ],
                      ],
                    ),
                  ),
                ),
                // TODO: Card de Comprovante - Funcionalidade comentada temporariamente
                // const SizedBox(height: 24),
                // 
                // // Card de Comprovante (NOVO)
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             Text(
                //               'Comprovante',
                //               style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             const SizedBox(width: 8),
                //             Container(
                //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //               decoration: BoxDecoration(
                //                 color: Colors.red,
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //               child: const Text(
                //                 'Obrigatório',
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 12,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 8),
                //         Text(
                //           'Anexe o comprovante fiscal (NF/Danfe/Cupom)',
                //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //             color: Colors.grey[600],
                //           ),
                //         ),
                //         const SizedBox(height: 16),
                //         
                //         // Botões de Ação para Upload
                //         Row(
                //           children: [
                //             Expanded(
                //               child: ElevatedButton.icon(
                //                 onPressed: _attachedImages.length < _maxImages ? _takePhoto : null,
                //                 icon: const Icon(Icons.camera_alt),
                //                 label: const Text('Tirar Foto'),
                //                 style: ElevatedButton.styleFrom(
                //                   backgroundColor: Colors.blue,
                //                   foregroundColor: Colors.white,
                //                   padding: const EdgeInsets.symmetric(vertical: 12),
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(width: 12),
                //             Expanded(
                //               child: ElevatedButton.icon(
                //                 onPressed: _attachedImages.length < _maxImages ? _pickFromGallery : null,
                //                 icon: const Icon(Icons.attach_file),
                //                 label: const Text('Anexar da Galeria'),
                //                 style: ElevatedButton.styleFrom(
                //                   backgroundColor: Colors.green,
                //                   foregroundColor: Colors.white,
                //                   padding: const EdgeInsets.symmetric(vertical: 12),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 16),
                //         
                //         // Contador de fotos
                //         Text(
                //           'Fotos anexadas: ${_attachedImages.length}/$_maxImages',
                //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //             fontWeight: FontWeight.w500,
                //             color: _attachedImages.length == _maxImages ? Colors.green : Colors.grey[600],
                //           ),
                //         ),
                //         const SizedBox(height: 16),
                //         
                //         // Grid de imagens anexadas
                //         if (_attachedImages.isNotEmpty) ...[
                //           GridView.builder(
                //             shrinkWrap: true,
                //             physics: const NeverScrollableScrollPhysics(),
                //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //               crossAxisCount: 3,
                //               crossAxisSpacing: 8,
                //               mainAxisSpacing: 8,
                //               childAspectRatio: 1,
                //             ),
                //             itemCount: _attachedImages.length,
                //             itemBuilder: (context, index) {
                //               return Stack(
                //                 children: [
                //                   Container(
                //                     decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(8),
                //                       border: Border.all(color: Colors.grey[300]!),
                //                     ),
                //                     child: ClipRRect(
                //                       borderRadius: BorderRadius.circular(8),
                //                       child: Image.file(
                //                         _attachedImages[index],
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                   ),
                //                   Positioned(
                //                     top: 4,
                //                     right: 4,
                //                     child: GestureDetector(
                //                       onTap: () => _removeImage(index),
                //                       child: Container(
                //                         padding: const EdgeInsets.all(4),
                //                         decoration: const BoxDecoration(
                //                           color: Colors.red,
                //                           shape: BoxShape.circle,
                //                         ),
                //                         child: const Icon(
                //                           Icons.close,
                //                           color: Colors.white,
                //                           size: 16,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             },
                //           ),
                //         ],
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24),
                
                // Card de Instruções
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Como usar',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        const ListTile(
                          leading: Icon(Icons.qr_code, color: Colors.blue),
                          title: Text('1. Mostre o QR Code no posto'),
                          subtitle: Text('O funcionário irá escanear o código'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.local_gas_station, color: Colors.green),
                          title: Text('2. Realize o abastecimento'),
                          subtitle: Text('Abasteça conforme necessário'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('3. Finalize o abastecimento'),
                          subtitle: Text('Confirme para concluir o processo'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botão de finalizar sempre habilitado (sem validação de foto)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _finalizeRefueling,
                      icon: _isUploading 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text(_isUploading ? 'Finalizando...' : 'Finalizar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatValidity(dynamic expiresAt) {
    if (expiresAt == null) return 'N/A';
    
    try {
      // Verificar status do código PRIMEIRO - se está ACTIVE, sempre mostrar como válido
      final status = _refuelingData?['status'] as String?;
      if (status != null && status.toUpperCase() == 'ACTIVE') {
        // Se status é ACTIVE, calcular tempo restante ou mostrar como válido
        DateTime expiresDate;
        if (expiresAt is String) {
          expiresDate = DateTime.parse(expiresAt);
        } else {
          return 'Válido';
        }
        
        final now = DateTime.now().toUtc();
        final expiresUtc = expiresDate.toUtc();
        final difference = expiresUtc.difference(now);
        
        // Se ainda não expirou, mostrar tempo restante
        if (difference.inDays > 0) {
          return '${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
        } else if (difference.inHours > 0) {
          return '${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
        } else if (difference.inMinutes > 0) {
          return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
        } else if (difference.inSeconds > 0) {
          return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'segundo' : 'segundos'}';
        } else {
          // Se passou mas status é ACTIVE, mostrar como válido
          return 'Válido';
        }
      } else {
        // Se status não é ACTIVE, verificar se expirou
        DateTime expiresDate;
        if (expiresAt is String) {
          expiresDate = DateTime.parse(expiresAt);
        } else {
          return 'N/A';
        }
        
        final now = DateTime.now().toUtc();
        final expiresUtc = expiresDate.toUtc();
        final difference = expiresUtc.difference(now);
        
        if (difference.inDays > 0) {
          return '${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
        } else if (difference.inHours > 0) {
          return '${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
        } else if (difference.inMinutes > 0) {
          return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
        } else {
          return 'Expirado';
        }
      }
    } catch (e) {
      // Em caso de erro, verificar status novamente
      final status = _refuelingData?['status'] as String?;
      if (status != null && status.toUpperCase() == 'ACTIVE') {
        return 'Válido';
      }
      return 'N/A';
    }
  }

  /// Iniciar WebSocket (primário) ou polling (fallback) para verificar status
  void _startPolling() async {
    // Limpar código (remover hífens) para passar ao polling
    final cleanCode = _refuelingCode.replaceAll('-', '').replaceAll(' ', '');
    
    debugPrint('🔄 [RefuelingCodePage] Iniciando notificações: refuelingId=$_refuelingId, refuelingCode=$cleanCode');
    
    // Tentar conectar via WebSocket primeiro (mais eficiente)
    try {
      final token = await _apiService.getToken();
      
      if (token != null && token.isNotEmpty) {
        debugPrint('📡 [RefuelingCodePage] Tentando conectar via WebSocket...');
        
        _webSocketService.connect(
          token: token,
          onRefuelingPendingValidation: (data) {
            debugPrint('🎯 [WebSocket] Evento recebido: $data');
            
            final refuelingId = data['refueling_id']?.toString() ?? '';
            if (refuelingId.isEmpty) {
              debugPrint('⚠️ [WebSocket] refueling_id vazio no evento');
              return;
            }
            
            if (mounted) {
              _webSocketService.disconnect();
              _pollingService.stopPolling();
              
              debugPrint('🚀 [WebSocket] Navegando para /refueling-waiting com refuelingId: $refuelingId');
              
              context.go(
                '/refueling-waiting',
                extra: {
                  'refueling_id': refuelingId,
                  'refueling_code': _refuelingCode,
                  'vehicle_data': _vehicleData,
                  'station_data': _stationData,
                },
              );
            }
          },
          onConnected: () {
            debugPrint('✅ [WebSocket] Conectado! Usando WebSocket para notificações');
            if (mounted) {
              setState(() {
                _usingWebSocket = true;
              });
            }
          },
          onError: (error) {
            debugPrint('❌ [WebSocket] Erro: $error - Ativando fallback de polling');
            _startPollingFallback(cleanCode);
          },
          onDisconnected: () {
            debugPrint('🔌 [WebSocket] Desconectado');
            // Se desconectar, ativar polling como fallback
            if (mounted && !_pollingService.isPolling) {
              _startPollingFallback(cleanCode);
            }
          },
        );
        
        // Também iniciar polling com intervalo maior como backup
        // (caso WebSocket falhe silenciosamente)
        _startPollingFallback(cleanCode, intervalSeconds: 60);
        
      } else {
        debugPrint('⚠️ [RefuelingCodePage] Token não disponível, usando polling');
        _startPollingFallback(cleanCode);
      }
    } catch (e) {
      debugPrint('❌ [RefuelingCodePage] Erro ao conectar WebSocket: $e');
      _startPollingFallback(cleanCode);
    }
  }
  
  /// Fallback de polling quando WebSocket não está disponível
  void _startPollingFallback(String cleanCode, {int intervalSeconds = 15}) {
    if (_pollingService.isPolling) {
      debugPrint('⚠️ [RefuelingCodePage] Polling já está ativo');
      return;
    }
    
    debugPrint('🔄 [RefuelingCodePage] Iniciando polling (fallback) a cada ${intervalSeconds}s');
    
    _pollingService.startPolling(
      refuelingId: _refuelingId,
      refuelingCode: cleanCode.isNotEmpty ? cleanCode : null,
      intervalSeconds: intervalSeconds,
      onStatusChanged: (refuelingId) {
        debugPrint('🎯 [Polling] Status mudou para refuelingId: $refuelingId');
        
        if (mounted) {
          _pollingService.stopPolling();
          _webSocketService.disconnect();
          
          context.go(
            '/refueling-waiting',
            extra: {
              'refueling_id': refuelingId,
              'refueling_code': _refuelingCode,
              'vehicle_data': _vehicleData,
              'station_data': _stationData,
            },
          );
        }
      },
    );
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _formatCode(_refuelingCode)));
    SuccessDialog.show(
      context,
      title: 'Código Copiado',
      message: 'Código copiado para a área de transferência',
    );
  }

  Future<void> _takePhoto() async {
    try {
      // Verificar status atual da permissão
      final status = await Permission.camera.status;
      
      // Só solicitar permissão se não foi dada ou foi negada
      if (status.isDenied) {
        final newStatus = await Permission.camera.request();
        if (newStatus.isDenied) {
          ErrorDialog.show(
            context,
            title: 'Permissão Negada',
            message: 'É necessário permitir o acesso à câmera para tirar fotos.',
          );
          return;
        }
      }
      
      if (status.isPermanentlyDenied) {
        ErrorDialog.show(
          context,
          title: 'Permissão Bloqueada',
          message: 'A permissão da câmera foi bloqueada. Vá em Configurações > Zeca App para habilitar.',
        );
        return;
      }

      // Usar a câmera
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _attachedImages.add(File(image.path));
        });
        
        SuccessDialog.show(
          context,
          title: 'Foto Capturada',
          message: 'Foto capturada com sucesso',
        );
      }
    } catch (e) {
      ErrorDialog.show(
        context,
        title: 'Erro na Câmera',
        message: 'Erro ao capturar foto: $e',
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      // Verificar status atual da permissão
      final status = await Permission.photos.status;
      
      // Só solicitar permissão se não foi dada ou foi negada
      if (status.isDenied) {
        final newStatus = await Permission.photos.request();
        if (newStatus.isDenied) {
          ErrorDialog.show(
            context,
            title: 'Permissão Negada',
            message: 'É necessário permitir o acesso à galeria para escolher fotos.',
          );
          return;
        }
      }
      
      if (status.isPermanentlyDenied) {
        ErrorDialog.show(
          context,
          title: 'Permissão Bloqueada',
          message: 'A permissão da galeria foi bloqueada. Vá em Configurações > Zeca App para habilitar.',
        );
        return;
      }

      // Usar a galeria
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _attachedImages.add(File(image.path));
        });
        
        SuccessDialog.show(
          context,
          title: 'Imagem Selecionada',
          message: 'Imagem selecionada da galeria',
        );
      }
    } catch (e) {
      ErrorDialog.show(
        context,
        title: 'Erro na Galeria',
        message: 'Erro ao selecionar imagem: $e',
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  Future<void> _requestPermissions(List<String> permissions) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionRequestDialog(
        requiredPermissions: permissions,
        onAllGranted: () {
          // Tentar novamente a ação que foi interrompida
          if (permissions.contains('camera')) {
            _takePhoto();
          } else if (permissions.contains('storage')) {
            _pickFromGallery();
          }
        },
        onDenied: () {
          ErrorDialog.show(
            context,
            title: 'Permissões Negadas',
            message: 'Permissões necessárias foram negadas',
          );
        },
      ),
    );
  }

  Future<void> _finalizeRefueling() async {
    // Evitar múltiplos cliques
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // 1. PRIMEIRO: Verificar status do código antes de finalizar
      // Remover hífens do código para enviar à API (aceita com ou sem hífens)
      final codeToCheck = _refuelingCode.replaceAll('-', '');
      debugPrint('🔍 Verificando status do código antes de finalizar: $_refuelingCode (enviando: $codeToCheck)');
      final codeStatusResponse = await _apiService.getCodeStatus(codeToCheck);
      
      if (!mounted) return;
      
      if (codeStatusResponse['success'] == true && codeStatusResponse['data'] != null) {
        final codeStatusData = codeStatusResponse['data'] as Map<String, dynamic>;
        final codeStatus = codeStatusData['code_status'] as String?;
        final exists = codeStatusData['exists'] as bool? ?? false;
        final hasRefueling = codeStatusData['has_refueling'] as bool? ?? false;
        final message = codeStatusData['message'] as String?;
        
        debugPrint('📊 Status do código: $codeStatus');
        debugPrint('📊 Existe: $exists');
        debugPrint('📊 Tem refueling: $hasRefueling');
        
        // Verificar se código existe
        if (!exists) {
          setState(() {
            _isUploading = false;
          });
          
          ErrorDialog.show(
            context,
            title: 'Código Inválido',
            message: message ?? 'Código não encontrado. Por favor, gere um novo código.',
          );
          return;
        }
        
        // Verificar status e tomar ação apropriada
        // ACTIVE: não permitir finalização (posto ainda não validou)
        if (codeStatus == 'ACTIVE') {
          setState(() {
            _isUploading = false;
          });
          
          ErrorDialog.show(
            context,
            title: 'Código Não Validado',
            message: 'Este código ainda não foi validado no caixa do posto.\n\nPor favor, valide o código no caixa antes de finalizar o abastecimento.',
          );
          return;
        }
        
        // EXPIRED: não permitir finalização
        if (codeStatus == 'EXPIRED') {
          setState(() {
            _isUploading = false;
          });
          
          ErrorDialog.show(
            context,
            title: 'Código Expirado',
            message: 'Este código expirou e não pode mais ser utilizado.\n\nPor favor, gere um novo código para continuar.',
          );
          return;
        }
        
        // Permitir apenas VALIDADO ou USED para finalização
        // VALIDADO: posto validou, motorista pode finalizar
        // USED: posto já registrou, motorista pode finalizar
        if (codeStatus != 'VALIDADO' && codeStatus != 'USED') {
          setState(() {
            _isUploading = false;
          });
          
          ErrorDialog.show(
            context,
            title: 'Código Inválido',
            message: message ?? 'Status do código inválido para finalização: $codeStatus\n\nO código deve estar VALIDADO ou USED para ser finalizado.',
          );
          return;
        }
        
        // Se chegou aqui, status é VALIDADO ou USED - continuar com finalização
        debugPrint('✅ Código validado (status: $codeStatus), prosseguindo com finalização...');
      } else {
        // Erro ao verificar status
        setState(() {
          _isUploading = false;
        });
        
        ErrorDialog.show(
          context,
          title: 'Erro ao Verificar Código',
          message: codeStatusResponse['error'] ?? 'Não foi possível verificar o status do código. Tente novamente.',
        );
        return;
      }
      
      // 2. SEGUNDO: Prosseguir com finalização (código está VALIDADO)
      // Simular upload das imagens para o backend
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular chamada para API de finalização
      final response = await MockApiService.finalizeRefueling(
        refuelingCode: _refuelingCode,
        images: _attachedImages,
      );

      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });

      if (response['success'] == true) {
        // Parar polling antes de navegar
        _pollingService.stopPolling();
        
        // Preparar dados para navegação
        final navigationData = {
          'refueling_id': _refuelingId ?? '',
          'refueling_code': _refuelingCode,
          'vehicle_data': _vehicleData,
          'station_data': _stationData,
        };
        
        // Mostrar modal de sucesso e navegar após clicar em OK
        if (mounted) {
          // Log antes de mostrar o modal
          debugPrint('🔗 Preparando navegação para: /refueling-waiting');
          debugPrint('📦 Dados de navegação: $navigationData');
          
          await SuccessDialog.show(
            context,
            title: 'Abastecimento Finalizado',
            message: 'Aguardando registro dos dados pelo posto...',
            onPressed: () {
              // Log para debug
              debugPrint('🔗 Botão OK pressionado no modal');
              debugPrint('📦 Dados de navegação: $navigationData');
              
              // Fechar o modal primeiro
              Navigator.of(context).pop();
              
              // Navegar para a tela de aguardando confirmação após um pequeno delay
              // para garantir que o modal foi fechado
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  debugPrint('🚀 Executando navegação para /refueling-waiting');
                  debugPrint('📦 Extra sendo enviado: $navigationData');
                  debugPrint('📦 Tipo do extra: ${navigationData.runtimeType}');
                  
                  // Tentar múltiplas abordagens de navegação
                  bool navigationSuccess = false;
                  
                  // Tentativa 1: goNamed com nome da rota
                  try {
                    debugPrint('🔄 Tentativa 1: context.goNamed...');
                    context.goNamed(
                      'refueling-waiting',
                      extra: navigationData,
                    );
                    debugPrint('✅ context.goNamed executado');
                    navigationSuccess = true;
                  } catch (e1) {
                    debugPrint('❌ Erro com goNamed: $e1');
                  }
                  
                  // Tentativa 2: Navigator.push direto (bypass GoRouter temporariamente)
                  if (!navigationSuccess) {
                    try {
                      debugPrint('🔄 Tentativa 2: Navigator.push direto...');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RefuelingWaitingPage(
                            refuelingId: (navigationData['refueling_id'] as String?) ?? '',
                            refuelingCode: (navigationData['refueling_code'] as String?) ?? '',
                            vehicleData: navigationData['vehicle_data'] as Map<String, dynamic>?,
                            stationData: navigationData['station_data'] as Map<String, dynamic>?,
                          ),
                        ),
                      );
                      debugPrint('✅ Navigator.push executado');
                      navigationSuccess = true;
                    } catch (e2, stackTrace) {
                      debugPrint('❌ Erro com Navigator.push: $e2');
                      debugPrint('📚 Stack trace: $stackTrace');
                    }
                  }
                  
                  // Tentativa 3: push com path (GoRouter)
                  if (!navigationSuccess) {
                    try {
                      debugPrint('🔄 Tentativa 3: context.push...');
                      context.push('/refueling-waiting', extra: navigationData);
                      debugPrint('✅ context.push executado');
                      navigationSuccess = true;
                    } catch (e3, stackTrace) {
                      debugPrint('❌ Erro com push: $e3');
                      debugPrint('📚 Stack trace: $stackTrace');
                    }
                  }
                  
                  // Tentativa 4: go com path
                  if (!navigationSuccess) {
                    try {
                      debugPrint('🔄 Tentativa 4: context.go...');
                      context.go('/refueling-waiting', extra: navigationData);
                      debugPrint('✅ context.go executado');
                      navigationSuccess = true;
                    } catch (e4) {
                      debugPrint('❌ Erro com go: $e4');
                    }
                  }
                  
                  // Tentativa 5: go sem extra
                  if (!navigationSuccess) {
                    try {
                      debugPrint('🔄 Tentativa 5: context.go sem extra...');
                      context.go('/refueling-waiting');
                      debugPrint('✅ context.go sem extra executado');
                      navigationSuccess = true;
                    } catch (e5) {
                      debugPrint('❌ Erro com go sem extra: $e5');
                      if (mounted) {
                        ErrorDialog.show(
                          context,
                          title: 'Erro de Navegação',
                          message: 'Não foi possível navegar para a tela de aguardando.\n\nErro: $e5\n\nVerifique os logs para mais detalhes.',
                        );
                      }
                    }
                  }
                } else {
                  debugPrint('⚠️ Widget não está montado, cancelando navegação');
                }
              });
            },
          );
        }
      } else {
        ErrorDialog.show(
          context,
          title: 'Erro ao Finalizar',
          message: response['message'] ?? 'Erro ao finalizar abastecimento',
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isUploading = false;
      });
      
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'Erro ao finalizar: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  /// Método chamado ao pressionar o botão voltar
  Future<void> _onBackPressed() async {
    // Parar polling antes de mostrar o diálogo
    _pollingService.stopPolling();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Código'),
        content: const Text(
          'Tem certeza que deseja cancelar este código de abastecimento?\n\n'
          'Ao cancelar, você precisará gerar um novo código para abastecer.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Reiniciar polling se o usuário cancelar o diálogo
              if (_refuelingCode.isNotEmpty) {
                _startPolling();
              }
              Navigator.of(context).pop(false);
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim, Cancelar'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Parar polling definitivamente
      _pollingService.stopPolling();
      
      // Navegar de volta para home (reinicia o processo de geração)
      context.go('/home');
    } else if (mounted) {
      // Se não confirmou, reiniciar polling
      if (_refuelingCode.isNotEmpty) {
        _startPolling();
      }
    }
  }

  Future<void> _cancelRefueling() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Abastecimento'),
        content: const Text('Tem certeza que deseja cancelar este código de abastecimento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Parar polling
        _pollingService.stopPolling();
        
        // Simular cancelamento via API
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          SuccessDialog.show(
            context,
            title: 'Código Cancelado',
            message: 'Código de abastecimento cancelado',
          );
          
          // Navegar de volta para home
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ErrorDialog.show(
            context,
            title: 'Erro ao Cancelar',
            message: 'Erro ao cancelar: $e',
          );
        }
      }
    }
  }

}