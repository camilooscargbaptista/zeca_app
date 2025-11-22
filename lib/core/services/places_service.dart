import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Modelo para um lugar retornado pela API
class Place {
  final String placeId;
  final String description;
  final String? mainText;
  final String? secondaryText;
  final double? latitude;
  final double? longitude;

  Place({
    required this.placeId,
    required this.description,
    this.mainText,
    this.secondaryText,
    this.latitude,
    this.longitude,
  });

  @override
  String toString() => description;
}

/// Serviço para buscar lugares usando Google Places API
class PlacesService {
  // API Key do Google Maps (Places e Directions)
  // Esta chave precisa ter as APIs Places e Directions habilitadas no Google Cloud Console
  static const String _apiKey = 'AIzaSyCTlAYLa9K04yfP65Qjg83vqoXhjee5Z2Q';
  
  final Dio _dio = Dio();

  PlacesService() {
    _dio.options.baseUrl = 'https://maps.googleapis.com/maps/api';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// Busca lugares (autocomplete) baseado no texto digitado
  /// Retorna lista de sugestões de lugares
  Future<List<Place>> searchPlaces(String query, {String? language = 'pt-BR'}) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      debugPrint('🔍 [Places] Buscando lugares para: "$query"');

      final response = await _dio.get(
        '/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'language': language ?? 'pt-BR',
          'components': 'country:br', // Restringir ao Brasil
          // Removido 'types' para permitir busca de ruas, endereços, cidades, etc.
          // Isso permite encontrar: ruas, endereços, cidades, pontos de interesse
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final predictions = response.data['predictions'] as List?;
        
        if (predictions == null || predictions.isEmpty) {
          debugPrint('⚠️ [Places] Nenhum lugar encontrado');
          return [];
        }

        final places = predictions.map((prediction) {
          final structuredFormatting = prediction['structured_formatting'];
          return Place(
            placeId: prediction['place_id'] as String,
            description: prediction['description'] as String,
            mainText: structuredFormatting?['main_text'] as String?,
            secondaryText: structuredFormatting?['secondary_text'] as String?,
          );
        }).toList();

        debugPrint('✅ [Places] ${places.length} lugares encontrados');
        return places;
      } else {
        final status = response.data['status'] as String?;
        final errorMessage = response.data['error_message'] as String?;
        debugPrint('❌ [Places] Erro na busca: $status - $errorMessage');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [Places] Erro ao buscar lugares: $e');
      return [];
    }
  }

  /// Obtém detalhes de um lugar (incluindo coordenadas) usando place_id
  Future<Place?> getPlaceDetails(String placeId) async {
    try {
      debugPrint('📍 [Places] Obtendo detalhes do lugar: $placeId');

      final response = await _dio.get(
        '/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': _apiKey,
          'language': 'pt-BR',
          'fields': 'place_id,formatted_address,geometry,name,address_components',
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final result = response.data['result'] as Map<String, dynamic>;
        final geometry = result['geometry'] as Map<String, dynamic>;
        final location = geometry['location'] as Map<String, dynamic>;

        final place = Place(
          placeId: result['place_id'] as String,
          description: result['formatted_address'] as String? ?? result['name'] as String? ?? '',
          latitude: (location['lat'] as num?)?.toDouble(),
          longitude: (location['lng'] as num?)?.toDouble(),
        );

        debugPrint('✅ [Places] Detalhes obtidos: ${place.description} (${place.latitude}, ${place.longitude})');
        return place;
      } else {
        final status = response.data['status'] as String?;
        final errorMessage = response.data['error_message'] as String?;
        debugPrint('❌ [Places] Erro ao obter detalhes: $status - $errorMessage');
        return null;
      }
    } catch (e) {
      debugPrint('❌ [Places] Erro ao obter detalhes do lugar: $e');
      return null;
    }
  }
}

