import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

/// Widget para exibir mapa com rota traçada
class RouteMapView extends StatefulWidget {
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final String? polyline; // Polyline codificado da rota
  final String? originName;
  final String? destinationName;
  final LatLng? currentPosition; // Posição atual do veículo (para navegação)
  final bool isNavigationMode; // Se está em modo navegação

  const RouteMapView({
    Key? key,
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    this.polyline,
    this.originName,
    this.destinationName,
    this.currentPosition,
    this.isNavigationMode = false,
  }) : super(key: key);

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    
    // Validar coordenadas antes de inicializar
    if (_isValidCoordinate(widget.originLat, widget.originLng) &&
        _isValidCoordinate(widget.destLat, widget.destLng)) {
      _initializeMap();
    } else {
      debugPrint('❌ [Map] Coordenadas inválidas no initState: origin(${widget.originLat}, ${widget.originLng}), dest(${widget.destLat}, ${widget.destLng})');
    }
  }

  @override
  void didUpdateWidget(RouteMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Se o polyline mudou, atualizar
    if (oldWidget.polyline != widget.polyline) {
      _initializeMap();
    }
    
    // Se mudou para modo navegação ou posição atual, atualizar câmera
    if (widget.isNavigationMode && widget.currentPosition != null && _mapController != null) {
      if (oldWidget.currentPosition != widget.currentPosition || 
          oldWidget.isNavigationMode != widget.isNavigationMode) {
        // Calcular bearing baseado na direção do movimento
        double bearing = 0;
        if (oldWidget.currentPosition != null && widget.currentPosition != null) {
          bearing = _calculateBearing(
            oldWidget.currentPosition!,
            widget.currentPosition!,
          );
        }
        _centerCameraOnPosition(widget.currentPosition!, bearing);
      }
    } else if (!widget.isNavigationMode && oldWidget.isNavigationMode && _mapController != null) {
      _fitBounds();
    } else if (widget.currentPosition != null && oldWidget.currentPosition != widget.currentPosition && _mapController != null) {
      // Se apenas a posição mudou (sem mudança de modo), atualizar câmera
      if (widget.isNavigationMode) {
        double bearing = 0;
        if (oldWidget.currentPosition != null) {
          bearing = _calculateBearing(
            oldWidget.currentPosition!,
            widget.currentPosition!,
          );
        }
        _centerCameraOnPosition(widget.currentPosition!, bearing);
      }
    }
  }

  void _initializeMap() {
    try {
      // Decodificar polyline e criar rota
      if (widget.polyline != null && widget.polyline!.isNotEmpty) {
        try {
          final points = _decodePolyline(widget.polyline!);
          if (points.isNotEmpty) {
            setState(() {
              _polylines = {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: points,
                  color: Colors.blue,
                  width: 5,
                  patterns: [],
                ),
              };
            });
            debugPrint('✅ [Map] Polyline decodificado com ${points.length} pontos');
          } else {
            debugPrint('⚠️ [Map] Polyline decodificado mas sem pontos');
            setState(() {
              _polylines = {};
            });
          }
        } catch (e) {
          debugPrint('❌ [Map] Erro ao decodificar polyline: $e');
          setState(() {
            _polylines = {};
          });
        }
      } else {
        debugPrint('ℹ️ [Map] Sem polyline para exibir');
        setState(() {
          _polylines = {};
        });
      }
    } catch (e) {
      debugPrint('❌ [Map] Erro ao inicializar mapa: $e');
      setState(() {
        _polylines = {};
      });
    }
  }

  /// Decodifica polyline do Google Maps
  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    
    if (encoded.isEmpty) {
      debugPrint('⚠️ [Map] Polyline vazio');
      return points;
    }
    
    try {
      int index = 0;
      int lat = 0;
      int lng = 0;

      while (index < encoded.length) {
        int shift = 0;
        int result = 0;
        int byte;

        // Decodificar latitude
        do {
          if (index >= encoded.length) {
            debugPrint('⚠️ [Map] Erro: índice fora dos limites ao decodificar latitude');
            break;
          }
          byte = encoded.codeUnitAt(index++) - 63;
          result |= (byte & 0x1F) << shift;
          shift += 5;
        } while (byte >= 0x20);

        int deltaLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
        lat += deltaLat;

        // Decodificar longitude
        shift = 0;
        result = 0;

        do {
          if (index >= encoded.length) {
            debugPrint('⚠️ [Map] Erro: índice fora dos limites ao decodificar longitude');
            break;
          }
          byte = encoded.codeUnitAt(index++) - 63;
          result |= (byte & 0x1F) << shift;
          shift += 5;
        } while (byte >= 0x20);

        int deltaLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
        lng += deltaLng;

        // Validar coordenadas antes de adicionar
        final decodedLat = lat / 1e5;
        final decodedLng = lng / 1e5;
        
        if (_isValidCoordinate(decodedLat, decodedLng)) {
          points.add(LatLng(decodedLat, decodedLng));
        } else {
          debugPrint('⚠️ [Map] Coordenada inválida decodificada: lat=$decodedLat, lng=$decodedLng');
        }
      }

      debugPrint('✅ [Map] Polyline decodificado: ${points.length} pontos válidos');
      return points;
    } catch (e) {
      debugPrint('❌ [Map] Erro ao decodificar polyline: $e');
      return points; // Retornar lista vazia em caso de erro
    }
  }

  /// Atualiza a posição atual e rotação do marker (para navegação)
  void updateCurrentPosition(LatLng position, double bearing) {
    if (!mounted) return;
    
    setState(() {  
      // Atualizar markers com nova posição
      _updateMarkers(position, bearing);
      
      // Se estiver em modo navegação, centralizar câmera na posição
      if (widget.isNavigationMode) {
        _centerCameraOnPosition(position, bearing);
      }
    });
  }

  /// Atualiza markers incluindo posição atual com rotação
  void _updateMarkers(LatLng? currentPos, double bearing) {
    final Set<Marker> markers = {};

    // Marker de origem (vermelho)
    if (_isValidCoordinate(widget.originLat, widget.originLng)) {
      markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(widget.originLat, widget.originLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Origem',
            snippet: widget.originName,
          ),
        ),
      );
    }

    // Marker de destino (verde)
    if (_isValidCoordinate(widget.destLat, widget.destLng)) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(widget.destLat, widget.destLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: 'Destino',
            snippet: widget.destinationName,
          ),
        ),
      );
    }

    // Marker de posição atual (azul, rotacionado) - apenas em modo navegação
    if (widget.isNavigationMode && currentPos != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_position'),
          position: currentPos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          rotation: bearing, // Rotação baseada no bearing
          anchor: const Offset(0.5, 0.5), // Centralizar rotação
          flat: true, // Marker fica "plano" no mapa (melhor para navegação)
          infoWindow: const InfoWindow(
            title: 'Você está aqui',
          ),
        ),
      );
    }

    // Este método não retorna nada, apenas atualiza os marcadores via setState
    // Os marcadores são construídos dinamicamente em _buildMarkers()
  }

  /// Centraliza câmera na posição com bearing
  Future<void> _centerCameraOnPosition(LatLng position, double bearing) async {
    if (_mapController == null) return;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 16.0, // Zoom ajustado para mostrar ruas e nomes (16 é ideal)
            bearing: bearing, // Rotação do mapa baseada na direção
            tilt: 45.0, // Inclinação para perspectiva 3D
          ),
        ),
      );
      
      // Aguardar um pouco e forçar atualização para garantir que os tiles sejam carregados
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && _mapController != null) {
        // Forçar refresh do mapa movendo a câmera ligeiramente e voltando
        await _mapController!.moveCamera(
          CameraUpdate.newLatLngZoom(position, 16.0),
        );
        debugPrint('✅ [Map] Câmera atualizada: $position, zoom: 16.0, bearing: $bearing');
      }
    } catch (e) {
      debugPrint('❌ [Map] Erro ao centralizar câmera: $e');
    }
  }

  /// Ajusta a câmera para mostrar toda a rota
  Future<void> _fitBounds() async {
    if (_mapController == null) return;

    try {
      // Calcular bounds para incluir origem e destino
      double minLat = widget.originLat < widget.destLat ? widget.originLat : widget.destLat;
      double maxLat = widget.originLat > widget.destLat ? widget.originLat : widget.destLat;
      double minLng = widget.originLng < widget.destLng ? widget.originLng : widget.destLng;
      double maxLng = widget.originLng > widget.destLng ? widget.originLng : widget.destLng;

      // Se origem e destino são muito próximos (mesmo ponto), usar zoom fixo
      final latDiff = maxLat - minLat;
      final lngDiff = maxLng - minLng;
      
      if (latDiff < 0.001 && lngDiff < 0.001) {
        // Mesmo ponto ou muito próximos - apenas centralizar
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(widget.originLat, widget.originLng),
            15.0,
          ),
        );
        return;
      }

      // Adicionar padding mínimo para evitar bounds muito pequenos
      final latPadding = math.max((maxLat - minLat) * 0.2, 0.01);
      final lngPadding = math.max((maxLng - minLng) * 0.2, 0.01);

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat - latPadding, minLng - lngPadding),
            northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
          ),
          100.0, // Padding em pixels
        ),
      );
    } catch (e) {
      debugPrint('❌ [Map] Erro ao ajustar bounds: $e');
      // Fallback: apenas centralizar na origem
      try {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(widget.originLat, widget.originLng),
            15.0,
          ),
        );
      } catch (e2) {
        debugPrint('❌ [Map] Erro no fallback: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Validar coordenadas
    if (!_isValidCoordinate(widget.originLat, widget.originLng) ||
        !_isValidCoordinate(widget.destLat, widget.destLng)) {
      debugPrint('❌ [Map] Coordenadas inválidas: origin(${widget.originLat}, ${widget.originLng}), dest(${widget.destLat}, ${widget.destLng})');
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erro ao carregar mapa'),
              const Text('Coordenadas inválidas', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Text(
                'Origin: (${widget.originLat}, ${widget.originLng})\n'
                'Dest: (${widget.destLat}, ${widget.destLng})',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Calcular centro e bounds
    final centerLat = (widget.originLat + widget.destLat) / 2;
    final centerLng = (widget.originLng + widget.destLng) / 2;

    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.isNavigationMode && widget.currentPosition != null
              ? widget.currentPosition!
              : LatLng(centerLat, centerLng),
          zoom: widget.isNavigationMode ? 16 : 13, // Zoom ajustado para mostrar ruas (16 é melhor que 18)
          bearing: 0,
          tilt: widget.isNavigationMode ? 45 : 0, // Perspectiva 3D ajustada
        ),
        markers: _buildMarkers(),
        polylines: _polylines.isEmpty ? {} : _polylines,
        myLocationEnabled: true, // Habilitar para mostrar localização
        myLocationButtonEnabled: true, // ✅ Sempre habilitado
        zoomControlsEnabled: true, // ✅ Sempre habilitado
        mapToolbarEnabled: false,
        compassEnabled: true, // ✅ Sempre habilitado para orientação
        rotateGesturesEnabled: true, // ✅ Sempre permitir rotação
        scrollGesturesEnabled: true, // ✅ Sempre permitir movimento
        tiltGesturesEnabled: true, // ✅ Sempre permitir inclinação
        zoomGesturesEnabled: true, // ✅ Sempre permitir zoom
        mapType: MapType.normal, // Sempre normal para mostrar ruas
        trafficEnabled: false, // Tráfego desabilitado por padrão
        buildingsEnabled: widget.isNavigationMode, // Edifícios 3D em navegação
        onMapCreated: (GoogleMapController controller) {
          try {
            _mapController = controller;
            debugPrint('✅ [Map] Mapa criado com sucesso');

            // Ajustar câmera para mostrar toda a rota (apenas se não estiver navegando)
            if (!widget.isNavigationMode) {
              _fitBounds();
            } else if (widget.currentPosition != null) {
              // Em modo navegação, centralizar na posição atual com zoom adequado para ruas
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted && _mapController != null) {
                  _centerCameraOnPosition(widget.currentPosition!, 0);
                }
              });
            }
            
            // Forçar atualização do mapa para garantir que as ruas apareçam
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && _mapController != null) {
                debugPrint('✅ [Map] Verificando configuração do mapa:');
                debugPrint('   - Tipo: normal (deve mostrar ruas)');
                debugPrint('   - Zoom: ${widget.isNavigationMode ? 16 : 13}');
                debugPrint('   - Modo navegação: ${widget.isNavigationMode}');
                
                // Forçar atualização da câmera para garantir que os tiles sejam carregados
                if (widget.isNavigationMode && widget.currentPosition != null) {
                  _mapController!.moveCamera(
                    CameraUpdate.newLatLngZoom(
                      widget.currentPosition!,
                      16.0, // Zoom ideal para ver ruas
                    ),
                  );
                }
              }
            });
          } catch (e) {
            debugPrint('❌ [Map] Erro ao criar mapa: $e');
          }
        },
      );
  }

  /// Constrói marcadores incluindo posição atual se disponível
  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    
    // Sempre adicionar marcadores de origem e destino
    markers.add(
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(widget.originLat, widget.originLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Origem',
          snippet: widget.originName ?? 'Ponto de partida',
        ),
      ),
    );
    
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destLat, widget.destLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Destino',
          snippet: widget.destinationName ?? 'Ponto de chegada',
        ),
      ),
    );
    
    // Em modo navegação, não adicionar marker customizado - usar myLocationEnabled
    // Isso mostra a seta azul do Google Maps que rotaciona com a direção
    // O marker customizado só é usado quando não está em navegação
    if (!widget.isNavigationMode && widget.currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_position'),
          position: widget.currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Sua Posição',
            snippet: 'Posição atual do veículo',
          ),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }
    
    return markers;
  }

  /// Calcula bearing (direção) entre dois pontos
  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * (math.pi / 180);
    final lat2 = to.latitude * (math.pi / 180);
    final dLon = (to.longitude - from.longitude) * (math.pi / 180);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    final bearing = (math.atan2(y, x) * (180 / math.pi) + 360) % 360;

    return bearing;
  }

  /// Centraliza mapa na posição atual (modo navegação)
  Future<void> _centerOnCurrentPosition() async {
    if (_mapController == null || widget.currentPosition == null) return;
    
    try {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.currentPosition!,
            zoom: 16.0, // Zoom ajustado para mostrar ruas (16 é melhor que 18 para ver nomes)
            bearing: 0, // Será atualizado pelo _centerCameraOnPosition
            tilt: 45.0, // Inclinação ajustada para ver melhor as ruas
          ),
        ),
      );
      
      // Forçar atualização do tipo de mapa para garantir que as ruas apareçam
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted && _mapController != null) {
        // Forçar refresh do mapa
        await _mapController!.moveCamera(
          CameraUpdate.newLatLngZoom(widget.currentPosition!, 16.0),
        );
      }
    } catch (e) {
      debugPrint('❌ [Map] Erro ao centralizar na posição atual: $e');
    }
  }

  /// Valida se as coordenadas são válidas
  bool _isValidCoordinate(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180 &&
           !lat.isNaN && !lng.isNaN && lat.isFinite && lng.isFinite;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

