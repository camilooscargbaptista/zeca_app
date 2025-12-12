// =============================================================================
// ARQUIVO TEMPORARIAMENTE DESATIVADO
// =============================================================================
// Motivo: A dependência google_maps_flutter foi removida do pubspec.yaml
// devido a incompatibilidade com páginas de memória de 16KB exigidas pela
// Google Play Store (Android 15+).
//
// Este arquivo será reativado quando:
// 1. A dependência for atualizada para versão compatível
// 2. Ou quando migrarmos para outra solução de mapas (ex: mapbox, flutter_map)
//
// Data: 12/12/2025
// Branch: feature/store-preparation
// =============================================================================

/*
// CÓDIGO ORIGINAL COMENTADO - NÃO REMOVER
// TODO: Reativar quando google_maps_flutter for compatível

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
  final String? polyline;
  final String? originName;
  final String? destinationName;
  final LatLng? currentPosition;
  final bool isNavigationMode;

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

// ... restante do código comentado no histórico git ...

*/

// =============================================================================
// WIDGET PLACEHOLDER - Exibe mensagem enquanto Google Maps não está disponível
// =============================================================================

import 'package:flutter/material.dart';

/// Placeholder temporário para RouteMapView enquanto Google Maps está desativado
class RouteMapView extends StatelessWidget {
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final String? polyline;
  final String? originName;
  final String? destinationName;
  final dynamic currentPosition; // Era LatLng
  final bool isNavigationMode;

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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Mapa temporariamente indisponível',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Use o botão de navegação para abrir no Google Maps ou Waze',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Mostrar informações da rota
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationRow(
                    icon: Icons.trip_origin,
                    color: Colors.green,
                    label: 'Origem',
                    name: originName ?? 'Coordenadas: $originLat, $originLng',
                  ),
                  const Divider(height: 16),
                  _buildLocationRow(
                    icon: Icons.location_on,
                    color: Colors.red,
                    label: 'Destino',
                    name: destinationName ?? 'Coordenadas: $destLat, $destLng',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color color,
    required String label,
    required String name,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
