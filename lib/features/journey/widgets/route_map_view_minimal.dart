import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Versão MINIMALISTA do RouteMapView para debug
/// 
/// Remove TODAS as funcionalidades complexas para isolar problemas:
/// - Sem animações
/// - Sem controle de câmera
/// - Sem listeners
/// - Apenas exibição básica
class RouteMapViewMinimal extends StatelessWidget {
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final String? polyline;
  final LatLng? currentPosition;

  const RouteMapViewMinimal({
    Key? key,
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    this.polyline,
    this.currentPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('🗺️ [MapMinimal] Construindo mapa...');
    debugPrint('   - Origin: ($originLat, $originLng)');
    debugPrint('   - Dest: ($destLat, $destLng)');
    debugPrint('   - Current: $currentPosition');
    
    // Marcadores básicos
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(originLat, originLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('dest'),
        position: LatLng(destLat, destLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
    
    // Polyline básico (sem decodificação complexa)
    final Set<Polyline> polylines = {};
    if (polyline != null && polyline!.isNotEmpty) {
      try {
        final points = _simpleDecodePolyline(polyline!);
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
        debugPrint('✅ [MapMinimal] Polyline com ${points.length} pontos');
      } catch (e) {
        debugPrint('❌ [MapMinimal] Erro ao decodificar polyline: $e');
      }
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition ?? LatLng(originLat, originLng),
        zoom: 15.0, // Zoom moderado
      ),
      markers: markers,
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        debugPrint('✅ [MapMinimal] GoogleMap criado!');
      },
    );
  }

  /// Decodificação simples de polyline
  List<LatLng> _simpleDecodePolyline(String encoded) {
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
}

