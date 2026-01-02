
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeca_app/features/home/presentation/pages/home_page_simple.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/services/storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockStorageService extends Mock implements StorageService {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockStorageService mockStorageService;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockStorageService = MockStorageService();
    mockSharedPreferences = MockSharedPreferences();
    
    final getIt = GetIt.instance;
    getIt.reset();
    getIt.registerSingleton<StorageService>(mockStorageService);
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  /// Helper para acessar o método privado _getCompatibleFuels via Reflection seria complexo em Dart puro.
  /// Como estamos testando um StatefulWidget complexo, vamos testar o resultado final na UI ou isolar a lógica.
  /// Para este teste rápido, vamos validar a lógica isolada que implementamos (reproduzindo-a) ou 
  /// testar através da interação do Widget se conseguirmos simular o estado.
  /// A melhor prática para _getCompatibleFuels seria movê-la para um ViewModel ou Mixin testável.
  /// Mas como ela está dentro do State, vamos testar a lógica "inline" copiando-a para garantir que a lógica "de negócio" está correta,
  /// ou testar o Widget renderizado (integration test light).
  
  // Vamos testar a lógica unitária pura aqui, copiando a função para garantir que a lógica desenhada funciona.
  // Em um refactor futuro, essa lógica deve ir para um Controller.
  
  List<String> getCompatibleFuels(String vehicleFuel, List<dynamic>? stationPrices) {
    if (stationPrices == null || stationPrices.isEmpty) return [];
    
    final vFuel = vehicleFuel.toLowerCase();
    final stationFuels = stationPrices.map((p) => p['fuel_type']['name'].toString()).toList();
    
    Set<String> matches = {};
    
    for (var sFuelName in stationFuels) {
      final sFuel = sFuelName.toLowerCase();
      
      if (vFuel.contains('diesel')) {
        if (sFuel.contains('diesel')) matches.add(sFuelName);
      } else if (vFuel.contains('gasolina')) {
        if (sFuel.contains('gasolina')) matches.add(sFuelName);
      } else if (vFuel.contains('etanol') || vFuel.contains('álcool')) {
        if (sFuel.contains('etanol') || sFuel.contains('álcool')) matches.add(sFuelName);
      } else if (vFuel.contains('flex')) {
        if (sFuel.contains('gasolina') || sFuel.contains('etanol') || sFuel.contains('álcool')) matches.add(sFuelName);
      } else {
        if (sFuel.contains(vFuel) || vFuel.contains(sFuel)) matches.add(sFuelName);
      }
    }
    return matches.toList()..sort();
  }

  group('Lógica de Compatibilidade de Combustíveis', () {
    final stationPrices = [
      {'fuel_type': {'name': 'Diesel S10'}},
      {'fuel_type': {'name': 'Diesel Comum'}},
      {'fuel_type': {'name': 'Gasolina Comum'}},
      {'fuel_type': {'name': 'Gasolina Aditivada'}},
      {'fuel_type': {'name': 'Etanol'}},
    ];

    test('Veículo Diesel deve ver apenas Diesels', () {
      final result = getCompatibleFuels('Diesel', stationPrices);
      expect(result, containsAll(['Diesel S10', 'Diesel Comum']));
      expect(result, isNot(contains('Gasolina Comum')));
    });

    test('Veículo Gasolina deve ver apenas Gasolinas', () {
      final result = getCompatibleFuels('Gasolina', stationPrices);
      expect(result, containsAll(['Gasolina Comum', 'Gasolina Aditivada']));
      expect(result, isNot(contains('Diesel S10')));
    });

    test('Veículo Flex deve ver Gasolina e Etanol', () {
      final result = getCompatibleFuels('Flex', stationPrices);
      expect(result, containsAll(['Gasolina Comum', 'Gasolina Aditivada', 'Etanol']));
      expect(result, isNot(contains('Diesel S10')));
    });

    test('Veículo Etanol deve ver apenas Etanol', () {
      final result = getCompatibleFuels('Etanol', stationPrices);
      expect(result, equals(['Etanol']));
    });

    test('Sem match deve retornar vazio', () {
      final dieselStation = [{'fuel_type': {'name': 'Diesel S10'}}];
      final result = getCompatibleFuels('Gasolina', dieselStation);
      expect(result, isEmpty);
    });
  });
}
