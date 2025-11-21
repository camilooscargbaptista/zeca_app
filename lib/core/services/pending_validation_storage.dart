import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Serviço para salvar e recuperar estado de validação pendente
/// Evita perder o contexto se o usuário precisar fazer login novamente
class PendingValidationStorage {
  static const String _keyRefuelingId = 'pending_validation_refueling_id';
  static const String _keyRefuelingCode = 'pending_validation_refueling_code';
  static const String _keyVehicleData = 'pending_validation_vehicle_data';
  static const String _keyStationData = 'pending_validation_station_data';
  static const String _keyTimestamp = 'pending_validation_timestamp';

  /// Salvar estado de validação pendente
  static Future<void> savePendingValidation({
    required String refuelingId,
    required String refuelingCode,
    Map<String, dynamic>? vehicleData,
    Map<String, dynamic>? stationData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_keyRefuelingId, refuelingId);
      await prefs.setString(_keyRefuelingCode, refuelingCode);
      await prefs.setInt(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
      
      if (vehicleData != null) {
        await prefs.setString(_keyVehicleData, jsonEncode(vehicleData));
      }
      
      if (stationData != null) {
        await prefs.setString(_keyStationData, jsonEncode(stationData));
      }
      
      debugPrint('✅ Estado de validação pendente salvo: $refuelingId');
    } catch (e) {
      debugPrint('❌ Erro ao salvar estado de validação: $e');
    }
  }

  /// Recuperar estado de validação pendente
  static Future<Map<String, dynamic>?> getPendingValidation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final refuelingId = prefs.getString(_keyRefuelingId);
      final refuelingCode = prefs.getString(_keyRefuelingCode);
      
      if (refuelingId == null || refuelingCode == null) {
        return null;
      }
      
      // Verificar se não expirou (válido por 24 horas)
      final timestamp = prefs.getInt(_keyTimestamp);
      if (timestamp != null) {
        final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(savedTime);
        
        if (difference.inHours > 24) {
          debugPrint('⚠️ Estado de validação expirado (mais de 24h)');
          await clearPendingValidation();
          return null;
        }
      }
      
      // Parse JSON strings para Map
      Map<String, dynamic>? vehicleDataMap;
      Map<String, dynamic>? stationDataMap;
      
      try {
        final vehicleDataStr = prefs.getString(_keyVehicleData);
        if (vehicleDataStr != null && vehicleDataStr.isNotEmpty) {
          vehicleDataMap = jsonDecode(vehicleDataStr) as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao parse vehicleData: $e');
      }
      
      try {
        final stationDataStr = prefs.getString(_keyStationData);
        if (stationDataStr != null && stationDataStr.isNotEmpty) {
          stationDataMap = jsonDecode(stationDataStr) as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao parse stationData: $e');
      }
      
      return {
        'refuelingId': refuelingId,
        'refuelingCode': refuelingCode,
        'vehicleData': vehicleDataMap,
        'stationData': stationDataMap,
        'timestamp': timestamp,
      };
    } catch (e) {
      debugPrint('❌ Erro ao recuperar estado de validação: $e');
      return null;
    }
  }

  /// Limpar estado de validação pendente
  static Future<void> clearPendingValidation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_keyRefuelingId);
      await prefs.remove(_keyRefuelingCode);
      await prefs.remove(_keyVehicleData);
      await prefs.remove(_keyStationData);
      await prefs.remove(_keyTimestamp);
      
      debugPrint('✅ Estado de validação pendente limpo');
    } catch (e) {
      debugPrint('❌ Erro ao limpar estado de validação: $e');
    }
  }

  /// Verificar se há validação pendente
  static Future<bool> hasPendingValidation() async {
    final state = await getPendingValidation();
    return state != null;
  }
}

