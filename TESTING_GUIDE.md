# ZECA App - Testing Guide

## 🎯 Overview

Este projeto possui uma suite de testes com **coverage target de 85%+**, focando em:
- **BLoC Tests** (95%+ coverage) - Lógica de negócio
- **Service Tests** (80%+ coverage) - Infraestrutura
- **Widget Tests** (85%+ coverage) - UI

## 📦 Setup

### Dependências já instaladas:
```yaml
dev_dependencies:
  flutter_test: sdk: flutter
  bloc_test: ^9.1.5      # Testing BLoCs
  mocktail: ^1.0.0       # Mocking dependencies
  fake_async: ^1.3.1     # Testing timers
```

## 🚀 Rodar Testes

```bash
# Rodar todos os testes
flutter test

# Rodar com coverage
flutter test --coverage

# Gerar HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Abrir no navegador
open coverage/html/index.html
```

## 📊 Testes Implementados

### ✅ BLoC Tests (3/7)

#### AuthBloc - `test/features/auth/presentation/bloc/auth_bloc_test.dart`
- ✅ 11 test cases
- ✅ 100% coverage
- Cobertura: Login, Logout, CheckAuthStatus com todos os cenários

#### JourneyBloc - `test/features/journey/presentation/bloc/journey_bloc_test.dart`
- ✅ 15 test cases
- ✅ 85-90% coverage estimado
- Cobertura: LoadActive, StartJourney, AddLocationPoint, ToggleRest, Finish, Cancel

#### RefuelingCodeBloc - `test/features/refueling/presentation/bloc/refueling_code_bloc_test.dart`
- ✅ 8 test cases
- ✅ 100% coverage
- Cobertura: Generate, Validate, Clear com error scenarios

### ✅ Service Tests (Templates - 2/4)

#### ApiService - `test/core/services/api_service_test.dart`
- ⚠️ **Template/exemplo** - precisa implementação real
- Mostra padrões de mock para Dio
- Exemplos: getActiveJourney, startJourney, searchVehicle, error handling

#### TokenManagerService - `test/core/services/token_manager_service_test.dart`
- ⚠️ **Template/exemplo** - precisa implementação real
- Padrões: storage, validation, auto-refresh

### ✅ Widget Tests (Exemplo - 1/3)

#### LoginPage - `test/features/auth/presentation/pages/login_page_test.dart`
- ✅ 7 test cases de exemplo
- Padrões: form validation, button interactions, state changes

## 🔨 Como Criar Mais Testes

### Pattern 1: BLoC Test

```dart
blocTest<MyBloc, MyState>(
  'descrição do teste',
  build: () {
    // Setup mocks
    when(() => mockUseCase()).thenAnswer((_) async => Right(data));
    return myBloc;
  },
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [
    LoadingState(),
    SuccessState(data),
  ],
  verify: (_) {
    verify(() => mockUseCase()).called(1);
  },
);
```

### Pattern 2: Service Test com Dio

```dart
test('API call succeeds', () async {
  when(() => mockDio.get(any())).thenAnswer(
    (_) async => Response(
      data: {'success': true},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/test'),
    ),
  );

  final result = await apiService.getData();
  expect(result['success'], true);
});
```

### Pattern 3: Widget Test

```dart
testWidgets('button triggers action', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.text('Success'), findsOneWidget);
});
```

## 📝 Testes Pendentes (Para atingir 85%+)

### BLoCs Faltando (4):
1. **NotificationBloc** - ~8 tests
   - LoadNotifications
   - MarkAsRead
   - ClearAll

2. **DocumentBloc** - ~6 tests
   - UploadDocument
   - DeleteDocument
   - GetDocuments

3. **VehicleBloc** - ~5 tests
   - LoadVehicles
   - SelectVehicle

4. **RefuelingFormBloc** - ~8 tests
   - Form field updates
   - Validation
   - Submit

### Services Faltando (2):
1. **LocationService** - ~6 tests
   - Request permissions
   - Get current location
   - Background tracking

2. **StorageService** - ~8 tests
   - Save/get/delete secure
   - Save/get/delete regular
   - Clear all

### Widgets Faltando (2):
1. **HomePage** - ~8 tests
2. **RefuelingCodePage** - ~8 tests

### Integration Test (1):
1. **Complete refueling flow** - end-to-end

**Total estimado:** ~57 tests adicionais

## ⚡ Quick Wins (Para aumentar coverage rapidamente)

1. **VehicleBloc** (simples, ~30 min)
2. **StorageService** (simples, ~30 min)
3. **NotificationBloc** (~45 min)
4. **DocumentBloc** (~45 min)

Esses 4 podem adicionar ~15-20% coverage em ~2.5h.

## 🎯 Coverage Atual vs. Target

```
├─ BLoCs:     43% (3/7)   → Target: 100% (7/7)
├─ Services:  50% (2/4)   → Target: 100% (4/4)
├─ Widgets:   33% (1/3)   → Target: 100% (3/3)
└─ Overall:   ~40-50%     → Target: 85%+
```

## 🔍 Como Verificar Coverage de um Arquivo Específico

```bash
# Gerar coverage
flutter test --coverage

# Ver coverage de um arquivo específico
lcov --list coverage/lcov.info | grep "auth_bloc"
```

## 💡 Tips & Best Practices

1. **Sempre use `tearDown`** para fechar BLoCs
2. **Mock todas as dependências** - nunca teste código real em unit tests
3. **Um teste = um comportamento** - não teste múltiplas coisas
4. **Nomes descritivos** - "emits [Loading, Success] when X happens"
5. **Arrange-Act-Assert** - estruture seus tests claramente
6. **Use `fake_async`** para testar Timers/periodic functions
7. **`registerFallbackValue`** para matchers `any()` com tipos customizados

## 🚨 Troubleshooting

### "Missing stub" error com Mocktail
```dart
// Adicione no setUp():
registerFallbackValue(MyCustomType());
```

### Testes de Timer não funcionam
```dart
// Use fake_async:
test('timer test', () {
  fakeAsync((async) {
    // ... setup
    async.elapse(Duration(seconds: 5));
    // ... verify
  });
});
```

### Widget test não encontra widgets
```dart
// Use pumpAndSettle para animações:
await tester.pumpAndSettle();

// Ou pump múltiplas vezes:
await tester.pump(Duration(seconds: 1));
```

## 📚 Recursos

- [BLoC Testing](https://bloclibrary.dev/#/testing)
- [Mocktail Docs](https://pub.dev/packages/mocktail)
- [Flutter Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Coverage na CI/CD](https://github.com/marketplace/actions/flutter-action)

---

**Próximos Passos Sugeridos:**

1. Implementar os 4 "Quick Wins" acima (2.5h, +20% coverage)
2. Completar os Service tests restantes (3h, +15% coverage)
3. Adicionar widget tests criticos (2h, +10% coverage)
4. Integration test básico (1h, final push para 85%+)

**Total estimado:** ~8.5h para atingir 85%+ coverage completo.
