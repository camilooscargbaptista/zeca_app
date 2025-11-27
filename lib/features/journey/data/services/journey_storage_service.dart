import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/entities/location_point_entity.dart';

/// Serviço de storage local para jornadas usando Hive
class JourneyStorageService {
  static const String _journeyBoxName = 'journeys';
  static const String _locationPointsBoxName = 'location_points';
  static const String _activeJourneyKey = 'active_journey_id';
  static const String _routeDataKeyPrefix = 'route_data_';

  Box? _journeyBox;
  Box? _locationPointsBox;

  /// Inicializar storage
  Future<void> init() async {
    try {
      _journeyBox = await Hive.openBox(_journeyBoxName);
      _locationPointsBox = await Hive.openBox(_locationPointsBoxName);
      debugPrint('✅ Journey storage inicializado');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar journey storage: $e');
    }
  }

  /// Salvar jornada localmente
  Future<void> saveJourney(JourneyEntity journey) async {
    try {
      await _journeyBox?.put(journey.id, _journeyToJson(journey));
      debugPrint('✅ Jornada salva localmente: ${journey.id}');
    } catch (e) {
      debugPrint('❌ Erro ao salvar jornada: $e');
    }
  }

  /// Obter jornada por ID
  JourneyEntity? getJourney(String journeyId) {
    try {
      final json = _journeyBox?.get(journeyId);
      if (json == null) return null;
      return _journeyFromJson(json as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Erro ao obter jornada: $e');
      return null;
    }
  }

  /// Obter jornada ativa
  JourneyEntity? getActiveJourney() {
    try {
      // Verificar se o box está inicializado
      if (_journeyBox == null) {
        debugPrint('⚠️ Journey box não está inicializado');
        return null;
      }
      
      final activeId = _journeyBox?.get(_activeJourneyKey) as String?;
      if (activeId == null) return null;
      return getJourney(activeId);
    } catch (e) {
      debugPrint('❌ Erro ao obter jornada ativa: $e');
      return null;
    }
  }

  /// Definir jornada ativa
  Future<void> setActiveJourney(String? journeyId) async {
    try {
      if (journeyId == null) {
        await _journeyBox?.delete(_activeJourneyKey);
      } else {
        await _journeyBox?.put(_activeJourneyKey, journeyId);
      }
    } catch (e) {
      debugPrint('❌ Erro ao definir jornada ativa: $e');
    }
  }

  /// Salvar ponto de localização
  Future<void> saveLocationPoint(LocationPointEntity point) async {
    try {
      // Usar ID único do ponto como chave para evitar duplicação
      final key = '${point.journeyId}_${point.id}';
      final json = _pointToJson(point);
      await _locationPointsBox?.put(key, json);
      debugPrint('💾 [Storage] Ponto salvo localmente: key=$key, id=${point.id}, lat=${point.latitude.toStringAsFixed(6)}, lng=${point.longitude.toStringAsFixed(6)}, vel=${point.velocidade.toStringAsFixed(1)} km/h, sincronizado=${point.sincronizado}');
      
      // Verificar se foi salvo corretamente
      final saved = _locationPointsBox?.get(key);
      if (saved == null) {
        debugPrint('⚠️ [Storage] ATENÇÃO: Ponto não foi salvo corretamente! key=$key');
      }
    } catch (e) {
      debugPrint('❌ [Storage] Erro ao salvar ponto: $e');
      debugPrint('📚 Stack trace: ${StackTrace.current}');
      rethrow; // Relançar erro para que seja tratado no JourneyBloc
    }
  }

  /// Obter pontos não sincronizados de uma jornada
  List<LocationPointEntity> getUnsyncedPoints(String journeyId) {
    try {
      final allKeys = _locationPointsBox?.keys.toList() ?? [];
      final points = <LocationPointEntity>[];

      debugPrint('🔍 [Storage] Buscando pontos não sincronizados para jornada: $journeyId');
      debugPrint('🔍 [Storage] Total de chaves no storage: ${allKeys.length}');

      for (final key in allKeys) {
        final keyStr = key.toString();
        if (keyStr.startsWith('${journeyId}_')) {
          final json = _locationPointsBox?.get(key) as Map<String, dynamic>?;
          if (json != null) {
            try {
              final point = _pointFromJson(json);
              if (!point.sincronizado) {
                points.add(point);
                debugPrint('📍 [Storage] Ponto não sincronizado encontrado: id=${point.id}, lat=${point.latitude.toStringAsFixed(6)}, lng=${point.longitude.toStringAsFixed(6)}, vel=${point.velocidade.toStringAsFixed(1)} km/h');
              }
            } catch (e) {
              debugPrint('⚠️ [Storage] Erro ao converter ponto do JSON: $e, key=$key');
            }
          }
        }
      }

      // Ordenar por timestamp
      points.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      debugPrint('✅ [Storage] Total de ${points.length} pontos não sincronizados encontrados');
      return points;
    } catch (e) {
      debugPrint('❌ [Storage] Erro ao obter pontos não sincronizados: $e');
      debugPrint('📚 Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  /// Marcar pontos como sincronizados
  Future<void> markPointsAsSynced(List<String> pointIds) async {
    try {
      int markedCount = 0;
      final allKeys = _locationPointsBox?.keys.toList() ?? [];
      
      for (final pointId in pointIds) {
        for (final key in allKeys) {
          final json = _locationPointsBox?.get(key) as Map<String, dynamic>?;
          if (json != null && json['id'] == pointId && json['sincronizado'] != true) {
            json['sincronizado'] = true;
            await _locationPointsBox?.put(key, json);
            markedCount++;
            debugPrint('✅ Ponto marcado como sincronizado: id=$pointId, key=$key');
          }
        }
      }
      debugPrint('✅ Total de $markedCount pontos marcados como sincronizados (de ${pointIds.length} IDs fornecidos)');
    } catch (e) {
      debugPrint('❌ Erro ao marcar pontos como sincronizados: $e');
      rethrow;
    }
  }

  /// Obter todos os pontos de uma jornada (para debug)
  List<LocationPointEntity> getAllPoints(String journeyId) {
    try {
      final allKeys = _locationPointsBox?.keys.toList() ?? [];
      final points = <LocationPointEntity>[];

      for (final key in allKeys) {
        if (key.toString().startsWith('${journeyId}_')) {
          final json = _locationPointsBox?.get(key) as Map<String, dynamic>?;
          if (json != null) {
            points.add(_pointFromJson(json));
          }
        }
      }

      // Ordenar por timestamp
      points.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return points;
    } catch (e) {
      debugPrint('❌ Erro ao obter todos os pontos: $e');
      return [];
    }
  }

  /// Contar pontos não sincronizados
  int countUnsyncedPoints(String journeyId) {
    return getUnsyncedPoints(journeyId).length;
  }

  /// Remover jornada e seus pontos
  Future<void> deleteJourney(String journeyId) async {
    try {
      // Remover jornada
      await _journeyBox?.delete(journeyId);

      // Remover pontos
      final allKeys = _locationPointsBox?.keys.toList() ?? [];
      for (final key in allKeys) {
        if (key.toString().startsWith('${journeyId}_')) {
          await _locationPointsBox?.delete(key);
        }
      }

      // Se era a jornada ativa, limpar
      final activeId = _journeyBox?.get(_activeJourneyKey) as String?;
      if (activeId == journeyId) {
        await _journeyBox?.delete(_activeJourneyKey);
      }

      debugPrint('✅ Jornada removida: $journeyId');
    } catch (e) {
      debugPrint('❌ Erro ao remover jornada: $e');
    }
  }

  /// Limpar todos os dados
  /// Salvar dados da rota para uma jornada
  Future<void> saveRouteData(String journeyId, {
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? polyline,
    String? destinationName,
  }) async {
    try {
      final key = '$_routeDataKeyPrefix$journeyId';
      final data = {
        'origin_lat': originLat,
        'origin_lng': originLng,
        'dest_lat': destLat,
        'dest_lng': destLng,
        'polyline': polyline,
        'destination_name': destinationName,
      };
      await _journeyBox?.put(key, data);
      debugPrint('✅ Dados da rota salvos para jornada: $journeyId');
    } catch (e) {
      debugPrint('❌ Erro ao salvar dados da rota: $e');
    }
  }

  /// Obter dados da rota de uma jornada
  Map<String, dynamic>? getRouteData(String journeyId) {
    try {
      final key = '$_routeDataKeyPrefix$journeyId';
      final data = _journeyBox?.get(key);
      if (data == null) return null;
      return data as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Erro ao obter dados da rota: $e');
      return null;
    }
  }

  /// Limpar dados da rota de uma jornada
  Future<void> clearRouteData(String journeyId) async {
    try {
      final key = '$_routeDataKeyPrefix$journeyId';
      await _journeyBox?.delete(key);
      debugPrint('✅ Dados da rota limpos para jornada: $journeyId');
    } catch (e) {
      debugPrint('❌ Erro ao limpar dados da rota: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await _journeyBox?.clear();
      await _locationPointsBox?.clear();
      debugPrint('✅ Storage limpo');
    } catch (e) {
      debugPrint('❌ Erro ao limpar storage: $e');
    }
  }

  // ============================================================
  // HELPERS - Conversão JSON
  // ============================================================

  Map<String, dynamic> _journeyToJson(JourneyEntity journey) {
    return {
      'id': journey.id,
      'driver_id': journey.driverId,
      'vehicle_id': journey.vehicleId,
      'placa': journey.placa,
      'odometro_inicial': journey.odometroInicial,
      'destino': journey.destino,
      'previsao_km': journey.previsaoKm,
      'observacoes': journey.observacoes,
      'data_inicio': journey.dataInicio.toIso8601String(),
      'data_fim': journey.dataFim?.toIso8601String(),
      'status': journey.status.name,
      'tempo_direcao_segundos': journey.tempoDirecaoSegundos,
      'tempo_descanso_segundos': journey.tempoDescansoSegundos,
      'km_percorridos': journey.kmPercorridos,
      'velocidade_media': journey.velocidadeMedia,
      'velocidade_maxima': journey.velocidadeMaxima,
      'lat_velocidade_maxima': journey.latVelocidadeMaxima,
      'long_velocidade_maxima': journey.longVelocidadeMaxima,
      'created_at': journey.createdAt.toIso8601String(),
      'updated_at': journey.updatedAt.toIso8601String(),
    };
  }

  JourneyEntity _journeyFromJson(Map<String, dynamic> json) {
    return JourneyEntity(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      placa: json['placa'] as String,
      odometroInicial: json['odometro_inicial'] as int,
      destino: json['destino'] as String?,
      previsaoKm: json['previsao_km'] as int?,
      observacoes: json['observacoes'] as String?,
      dataInicio: DateTime.parse(json['data_inicio'] as String),
      dataFim: json['data_fim'] != null 
          ? DateTime.parse(json['data_fim'] as String) 
          : null,
      status: JourneyStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toUpperCase(),
        orElse: () => JourneyStatus.ACTIVE,
      ),
      tempoDirecaoSegundos: json['tempo_direcao_segundos'] as int? ?? 0,
      tempoDescansoSegundos: json['tempo_descanso_segundos'] as int? ?? 0,
      kmPercorridos: (json['km_percorridos'] as num?)?.toDouble() ?? 0.0,
      velocidadeMedia: (json['velocidade_media'] as num?)?.toDouble(),
      velocidadeMaxima: (json['velocidade_maxima'] as num?)?.toDouble(),
      latVelocidadeMaxima: (json['lat_velocidade_maxima'] as num?)?.toDouble(),
      longVelocidadeMaxima: (json['long_velocidade_maxima'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> _pointToJson(LocationPointEntity point) {
    return {
      'id': point.id,
      'journey_id': point.journeyId,
      'latitude': point.latitude,
      'longitude': point.longitude,
      'velocidade': point.velocidade,
      'timestamp': point.timestamp.toIso8601String(),
      'sincronizado': point.sincronizado,
      'created_at': point.createdAt.toIso8601String(),
    };
  }

  LocationPointEntity _pointFromJson(Map<String, dynamic> json) {
    return LocationPointEntity(
      id: json['id'] as String,
      journeyId: json['journey_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      velocidade: (json['velocidade'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sincronizado: json['sincronizado'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

