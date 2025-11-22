import 'package:flutter/material.dart';
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

  const RouteMapView({
    Key? key,
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    this.polyline,
    this.originName,
    this.destinationName,
  }) : super(key: key);

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    // Criar marcadores de origem e destino
    _markers = {
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(widget.originLat, widget.originLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Origem',
          snippet: widget.originName ?? 'Ponto de partida',
        ),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destLat, widget.destLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Destino',
          snippet: widget.destinationName ?? 'Ponto de chegada',
        ),
      ),
    };

    // Decodificar polyline e criar rota
    if (widget.polyline != null && widget.polyline!.isNotEmpty) {
      try {
        final points = _decodePolyline(widget.polyline!);
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
            patterns: [],
          ),
        };
      } catch (e) {
        debugPrint('❌ [Map] Erro ao decodificar polyline: $e');
      }
    }
  }

  /// Decodifica polyline do Google Maps
  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Erro ao carregar mapa'),
            Text('Coordenadas inválidas', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          (widget.originLat + widget.destLat) / 2,
          (widget.originLng + widget.destLng) / 2,
        ),
        zoom: 10,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        // Ajustar bounds após o mapa ser criado
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _fitBounds();
          }
        });
      },
      onCameraMoveStarted: () {
        debugPrint('🗺️ [Map] Câmera começou a se mover');
      },
      onCameraIdle: () {
        debugPrint('🗺️ [Map] Câmera parou');
      },
    );
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

