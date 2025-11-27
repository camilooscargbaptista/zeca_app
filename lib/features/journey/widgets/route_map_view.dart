import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

/// Widget principal que exibe o Google Maps com a rota
/// 
/// Suporta dois modos:
/// - **Modo Rota Completa** (isNavigationMode = false): Mostra toda a rota do início ao fim
/// - **Modo Navegação** (isNavigationMode = true): Foca na posição atual do veículo, estilo Waze
class RouteMapView extends StatefulWidget {
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final String? polyline;
  final String? destinationName;
  final bool isNavigationMode;
  final LatLng? currentPosition;

  const RouteMapView({
    Key? key,
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    this.polyline,
    this.destinationName,
    this.isNavigationMode = true,
    this.currentPosition,
  }) : super(key: key);

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeMapElements();
  }

  @override
  void didUpdateWidget(RouteMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Atualizar mapa quando o modo mudar
    if (oldWidget.isNavigationMode != widget.isNavigationMode) {
      _updateCamera();
    }
    
    // 🆕 ATUALIZAR CÂMERA EM TEMPO REAL quando posição mudar
    if (oldWidget.currentPosition != widget.currentPosition && widget.currentPosition != null) {
      _initializeMapElements();
      
      // 🎯 SEMPRE animar para posição atual em modo navegação
      if (widget.isNavigationMode) {
        debugPrint('🎬 [Map] Animando câmera para posição: ${widget.currentPosition!.latitude}, ${widget.currentPosition!.longitude}');
        _animateToCurrentPosition();
      }
    }
  }

  void _initializeMapElements() {
    _markers = {
      // Marcador de origem
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(widget.originLat, widget.originLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Início'),
      ),
      // Marcador de destino
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destLat, widget.destLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Destino',
          snippet: widget.destinationName,
        ),
      ),
    };

    // Adicionar marcador de posição atual se disponível
    if (widget.currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_position'),
          position: widget.currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Você está aqui'),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    // Adicionar polyline se disponível
    if (widget.polyline != null && widget.polyline!.isNotEmpty) {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: _decodePolyline(widget.polyline!),
          color: Colors.blue,
          width: 5,
          geodesic: true,
        ),
      };
    }
  }

  /// Decodifica polyline do Google Directions API
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return poly;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateCamera();
  }

  void _updateCamera() {
    if (_mapController == null) return;

    if (widget.isNavigationMode && widget.currentPosition != null) {
      // Modo navegação: foca na posição atual com zoom próximo
      _animateToCurrentPosition();
    } else {
      // Modo rota completa: mostra toda a rota
      _showFullRoute();
    }
  }

  void _animateToCurrentPosition() {
    if (_mapController == null || widget.currentPosition == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.currentPosition!,
          zoom: 18.0, // 🆕 Zoom mais próximo para navegação
          tilt: 55.0, // 🆕 Mais inclinação para efeito 3D
          bearing: 0.0, // TODO: atualizar com heading do GPS
        ),
      ),
      duration: const Duration(milliseconds: 500), // 🆕 Animação suave
    );
    
    debugPrint('✅ [Map] Câmera atualizada - Zoom: 18, Tilt: 55°');
  }

  void _showFullRoute() {
    if (_mapController == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        widget.originLat < widget.destLat ? widget.originLat : widget.destLat,
        widget.originLng < widget.destLng ? widget.originLng : widget.destLng,
      ),
      northeast: LatLng(
        widget.originLat > widget.destLat ? widget.originLat : widget.destLat,
        widget.originLng > widget.destLng ? widget.originLng : widget.destLng,
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100), // 100px de padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.currentPosition ?? LatLng(widget.originLat, widget.originLng),
        zoom: widget.isNavigationMode ? 18.0 : 12.0, // 🆕 Zoom mais próximo
        tilt: widget.isNavigationMode ? 55.0 : 0.0, // 🆕 Mais inclinação
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true, // 🔵 Ponto azul da localização
      myLocationButtonEnabled: false,
      mapType: MapType.normal, // Estradas, prédios, etc.
      compassEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      trafficEnabled: true, // 🆕 ATIVAR TRÁFEGO (mostrar congestionamentos)
      buildingsEnabled: true, // 🏢 Mostrar prédios em 3D
      indoorViewEnabled: false,
      // 🆕 Estilo do mapa (pode personalizar depois)
      minMaxZoomPreference: const MinMaxZoomPreference(3.0, 20.0),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

