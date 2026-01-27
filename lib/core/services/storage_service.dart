import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;

  StorageService(this._secureStorage, this._preferences);

  // Secure Storage methods
  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAllSecure() async {
    await _secureStorage.deleteAll();
  }

  // SharedPreferences methods
  Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
    }
  }

  T? read<T>(String key) {
    return _preferences.get(key) as T?;
  }

  Future<void> delete(String key) async {
    await _preferences.remove(key);
  }

  Future<void> deleteAll() async {
    await _preferences.clear();
  }

  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  Set<String> getKeys() {
    return _preferences.getKeys();
  }

  // Token management methods
  Future<void> saveAccessToken(String token) async {
    await writeSecure('access_token', token);
  }

  Future<String?> getAccessToken() async {
    return await readSecure('access_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await writeSecure('refresh_token', token);
  }

  Future<String?> getRefreshToken() async {
    return await readSecure('refresh_token');
  }

  Future<void> clearTokens() async {
    await deleteSecure('access_token');
    await deleteSecure('refresh_token');
    // Limpar credenciais também no logout
    await clearLoginCredentials();
  }

  // User data management methods
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final userJson = jsonEncode(userData);
    await write('user_data', userJson);
  }

  Map<String, dynamic>? getUserData() {
    final userJson = read<String>('user_data');
    if (userJson == null) return null;
    try {
      return jsonDecode(userJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUserData() async {
    await delete('user_data');
  }

  // CPF remember methods
  String? getRememberCpf() {
    return read<String>('remember_cpf');
  }

  Future<void> saveRememberCpf(String cpf) async {
    await write('remember_cpf', cpf);
  }

  Future<void> clearRememberCpf() async {
    await delete('remember_cpf');
  }

  // Credenciais para re-login automático (apenas durante jornada)
  Future<void> saveLoginCredentials({
    required String cpf,
    required String password,
    required String userType,
  }) async {
    // Salvar no SecureStorage (criptografado)
    await writeSecure('saved_cpf', cpf);
    await writeSecure('saved_password', password);
    await writeSecure('saved_user_type', userType);
  }

  Future<Map<String, String>?> getLoginCredentials() async {
    try {
      final cpf = await readSecure('saved_cpf');
      final password = await readSecure('saved_password');
      final userType = await readSecure('saved_user_type');
      
      if (cpf != null && password != null && userType != null) {
        return {
          'cpf': cpf,
          'password': password,
          'userType': userType,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearLoginCredentials() async {
    await deleteSecure('saved_cpf');
    await deleteSecure('saved_password');
    await deleteSecure('saved_user_type');
  }

  // ============================================================
  // JOURNEY VEHICLE DATA (dados do veículo da jornada ativa)
  // ============================================================
  
  /// Salvar dados do veículo da jornada ativa
  Future<void> saveJourneyVehicleData(Map<String, dynamic> vehicleData) async {
    final vehicleJson = jsonEncode(vehicleData);
    await write('journey_vehicle_data', vehicleJson);
    if (kDebugMode) {
      print('✅ Dados do veículo salvos: $vehicleData');
    }
  }

  /// Recuperar dados do veículo da jornada ativa
  Future<Map<String, dynamic>?> getJourneyVehicleData() async {
    final vehicleJson = read<String>('journey_vehicle_data');
    if (vehicleJson == null) return null;
    try {
      return jsonDecode(vehicleJson) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Erro ao decodificar dados do veículo: $e');
      }
      return null;
    }
  }

  /// Limpar dados do veículo da jornada (ao finalizar jornada ou logout)
  Future<void> clearJourneyVehicleData() async {
    await delete('journey_vehicle_data');
    if (kDebugMode) {
      print('🗑️ Dados do veículo da jornada limpos');
    }
  }

  /// Verificar se existe uma jornada ativa (veículo selecionado)
  Future<bool> hasActiveJourney() async {
    final vehicleData = await getJourneyVehicleData();
    return vehicleData != null && vehicleData.isNotEmpty;
  }
}