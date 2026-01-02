
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:zeca_app/core/services/storage_service.dart';
import 'package:zeca_app/features/home/presentation/pages/home_page_simple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockStorageService extends Mock implements StorageService {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockStorageService mockStorageService;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    // Registro de fallbacks se necessário
  });

  setUp(() {
    mockStorageService = MockStorageService();
    mockSharedPreferences = MockSharedPreferences();

    final getIt = GetIt.instance;
    getIt.reset();
    
    // Registrar StorageService mockado
    getIt.registerSingleton<StorageService>(mockStorageService);
    // As vezes SharedPreferences é pedido
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('Deve exibir DADOS DO VEÍCULO quando houver jornada ativa', (WidgetTester tester) async {
    // Arrange
    when(() => mockStorageService.getUserData()).thenReturn({'name': 'Test User'});
    when(() => mockStorageService.getAccessToken()).thenAnswer((_) async => 'fake.jwt.token');
    
    // Configura dados da jornada
    final vehicleData = {
      'placa': 'TEST-1234',
      'marca': 'TestBrand',
      'modelo': 'TestModel',
      'ano': '2023',
      'tipo_combustivel': 'Diesel',
      'km_atual': 10000
    };
    when(() => mockStorageService.getJourneyVehicleData()).thenAnswer((_) async => vehicleData);
    
    // Act
    // Envolvemos em MaterialApp para ter Scaffold e Theme
    await tester.pumpWidget(const MaterialApp(home: HomePageSimple()));
    
    // Aguarda o initState e callbacks assíncronos
    await tester.pumpAndSettle(); 

    // Assert
    // Verifica se carregou os dados
    expect(find.text('DADOS DO VEÍCULO'), findsOneWidget);
    expect(find.text('TEST-1234'), findsOneWidget); // Placa formatada pelo widget
    expect(find.textContaining('TestModel'), findsOneWidget); // Detalhes
    
    // Verifica se NÃO tem input de placa (deve ter sido removido)
    expect(find.byType(TextField), findsWidgets); // Existem outros textfields (KM, CNPJ)
    // Precisaria verificar especificamente o de Placa. Mas se o texto "DADOS DO VEÍCULO" estiver lá, o Card antigo "CONFIRME A PLACA" nao deve estar.
    expect(find.text('CONFIRME A PLACA'), findsNothing);
  });

  testWidgets('Deve exibir aviso quando NÃO houver jornada ativa', (WidgetTester tester) async {
    // Arrange
    when(() => mockStorageService.getUserData()).thenReturn({'name': 'Test User'});
    when(() => mockStorageService.getAccessToken()).thenAnswer((_) async => 'fake.jwt.token');
    
    // Sem jornada
    when(() => mockStorageService.getJourneyVehicleData()).thenAnswer((_) async => null);
    
    // Act
    await tester.pumpWidget(const MaterialApp(home: HomePageSimple()));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Nenhuma jornada ativa encontrada'), findsOneWidget);
    expect(find.text('Iniciar Jornada'), findsOneWidget);
    expect(find.text('DADOS DO VEÍCULO'), findsOneWidget); // O título ainda aparece no topo do card, mas o conteudo é aviso
    // Espera, na minha implementação, "DADOS DO VEÍCULO" está dentro do `children`, antes do if.
    // Então "DADOS DO VEÍCULO" sempre aparece. Correto.
  });
}
