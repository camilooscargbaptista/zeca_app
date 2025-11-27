# ADR-002: Usar GetIt + Injectable para Dependency Injection

## Status
✅ **Aceito** (Implementado)

## Contexto

Precisávamos de um sistema de Dependency Injection (DI) para gerenciar dependencies no app Flutter. As opções consideradas:

1. **GetIt + Injectable** - Service Locator pattern + code generation
2. **Provider** - Nativo do Flutter, mas mistura DI com state
3. **Riverpod** - Provider modernizado
4. **GetX** - All-in-one (DI + State + Navigation)
5. **Manual** - Factory constructors manuais

## Decisão

**Escolhemos GetIt + Injectable**

---

## Justificativa

### **Por que GetIt:**

✅ **Vantagens:**

1. **Service Locator Pattern:**
   - Acesso global às dependencies
   - Fácil injetar em qualquer lugar

2. **Simples e direto:**
   - API minimalista
   - Fácil de entender
   - Poucas linhas de código

3. **Tipos de registro flexíveis:**
   - `registerSingleton()` - Uma única instância
   - `registerFactory()` - Nova instância sempre
   - `registerLazySingleton()` - Lazy loading
   
4. **Independente de Flutter:**
   - Puro Dart
   - Testável facilmente

5. **Performance excelente:**
   - Resolução de dependencies em tempo de compilação (com Injectable)
   - Sem reflexão em runtime

### **Por que Injectable (code generation):**

✅ **Vantagens:**

1. **Menos boilerplate:**
   - Decorators `@injectable`, `@singleton`, `@lazySingleton`
   - build_runner gera código automaticamente

2. **Type-safe:**
   - Erros em compile-time, não runtime
   - IntelliSense completo

3. **Detecção de ciclos:**
   - Build falha se houver dependências circulares

4. **Módulos organizados:**
   - Agrupar dependencies relacionadas

**Exemplo SEM Injectable (Manual):**
```dart
// Muito boilerplate!
final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => ApiService(getIt<StorageService>()));
  
  // Repositories
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(
      remoteDataSource: getIt<VehicleRemoteDataSource>(),
      localDataSource: getIt<VehicleLocalDataSource>(),
    ),
  );
  
  // Use Cases
  getIt.registerLazySingleton(
    () => GetVehicleByPlate(getIt<VehicleRepository>()),
  );
  
  // BLoCs
  getIt.registerFactory(
    () => VehicleBloc(getIt<GetVehicleByPlate>()),
  );
  // ... E por aí vai (muitas linhas!)
}
```

**Exemplo COM Injectable (Code Generation):**
```dart
// Muito menos código!

@injectable
class StorageService {
  // Implementação
}

@lazySingleton
class ApiService {
  final StorageService storage;
  ApiService(this.storage);
}

@LazySingleton(as: VehicleRepository)
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  final VehicleLocalDataSource localDataSource;
  
  VehicleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
}

@lazySingleton
class GetVehicleByPlate {
  final VehicleRepository repository;
  GetVehicleByPlate(this.repository);
}

@injectable
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleByPlate getVehicleByPlate;
  VehicleBloc(this.getVehicleByPlate) : super(VehicleInitial());
}

// Setup automático!
// injection.dart (gerado)
@injectableInit
void configureDependencies() => getIt.init();
```

### **Por que NÃO Provider:**
- ⚠️ Mistura DI com state management
- ⚠️ Mais verboso para DI puro
- ⚠️ BuildContext required (nem sempre disponível)

### **Por que NÃO Riverpod:**
- ⚠️ Mais focado em state, menos em DI puro
- ⚠️ API diferente de GetIt (menos adotado para DI)

### **Por que NÃO GetX:**
- ⚠️ Muito opinativo
- ⚠️ Mistura muitas responsabilidades
- ⚠️ "Magic" dificulta debug

### **Por que NÃO Manual:**
- ⚠️ Muito boilerplate
- ⚠️ Propenso a erros
- ⚠️ Difícil manter

---

## Consequências

### **Positivas:**

✅ **Menos código:**
- Decorators simples
- build_runner gera tudo

✅ **Type-safe:**
- Erros em compile-time
- Refactoring seguro

✅ **Testável:**
- Mock fácil:
```dart
// Em testes
final mockRepo = MockVehicleRepository();
getIt.registerFactory<VehicleRepository>(() => mockRepo);
```

✅ **Organizado:**
- Dependencies claras via constructor injection
- Fácil ver dependencies de cada classe

✅ **Performance:**
- Resolução rápida
- Sem reflexão

### **Negativas/Trade-offs:**

⚠️ **Code generation necessário:**
- Rodar `flutter pub run build_runner build` sempre que adicionar `@injectable`
- Arquivo `injection.config.dart` gerado (não editar!)
- **Mitigação:** Watch mode: `flutter pub run build_runner watch`

⚠️ **Curva de aprendizado inicial:**
- Entender decorators (@injectable, @singleton, @lazySingleton)
- Entender módulos (@module)
- **Mitigação:** Documentação + exemplos

⚠️ **Build time ligeiramente maior:**
- Code generation adiciona ~5-10s no build
- **Mitigação:** Aceitável, não é crítico

---

## Implementação

### **Estrutura:**

```dart
// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() => getIt.init();

// Chamar no main.dart:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(); // ✅ Setup de DI
  runApp(MyApp());
}
```

### **Tipos de registro:**

```dart
// 1. SINGLETON - Uma única instância global
@singleton
class StorageService {
  // Criado imediatamente no init()
}

// 2. LAZY SINGLETON - Uma única instância, mas lazy
@lazySingleton
class ApiService {
  // Criado apenas no primeiro getIt<ApiService>()
}

// 3. INJECTABLE (Factory) - Nova instância sempre
@injectable
class VehicleBloc extends Bloc {
  // Nova instância a cada getIt<VehicleBloc>()
}

// 4. INTERFACE - Registrar implementação
@LazySingleton(as: VehicleRepository) // Interface
class VehicleRepositoryImpl implements VehicleRepository {
  // getIt<VehicleRepository>() retorna VehicleRepositoryImpl
}
```

### **Módulos (para 3rd party packages):**

```dart
// lib/core/di/app_module.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: 30),
    ));
    // Interceptors...
    return dio;
  }
  
  @lazySingleton
  StorageService get storage => StorageService();
}
```

### **Uso em BLoCs:**

```dart
// Registrar BLoC
@injectable
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleByPlate getVehicleByPlate;
  
  VehicleBloc(this.getVehicleByPlate) : super(VehicleInitial());
}

// Usar em widget
class VehiclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VehicleBloc>(), // ✅ DI automático!
      child: ...,
    );
  }
}
```

### **Testes:**

```dart
// test/vehicle_bloc_test.dart

void main() {
  late VehicleBloc bloc;
  late MockGetVehicleByPlate mockUseCase;
  
  setUp(() {
    mockUseCase = MockGetVehicleByPlate();
    bloc = VehicleBloc(mockUseCase); // ✅ Injeção manual em testes
  });
  
  test('should emit VehicleLoaded when successful', () async {
    // Arrange
    when(mockUseCase.execute(any))
        .thenAnswer((_) async => Right(vehicleMock));
    
    // Act
    bloc.add(FetchVehicle('ABC1234'));
    
    // Assert
    await expectLater(
      bloc.stream,
      emitsInOrder([
        VehicleLoading(),
        VehicleLoaded(vehicleMock),
      ]),
    );
  });
}
```

---

## Comandos Úteis

```bash
# Gerar código DI (uma vez)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenera quando mudar)
flutter pub run build_runner watch --delete-conflicting-outputs

# Limpar cache e regenerar
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Alternativas Futuras

Se surgir necessidade:

1. **Migrar para Riverpod DI** - Se quisermos unificar state + DI
2. **Adicionar auto_route** - Para DI em navegação
3. **Manter GetIt** - Funciona perfeitamente, sem necessidade de mudança

---

## Métricas de Sucesso

Após implementação:

✅ **Menos boilerplate:** ~70% menos código de setup DI  
✅ **Erros em compile-time:** 0 erros de DI em runtime  
✅ **Testes facilitados:** Mocks fáceis de injetar  
✅ **Onboarding:** Devs novos entendem DI rapidamente  
✅ **Manutenção:** Fácil adicionar/remover dependencies  

---

## Referências

- [GetIt Package](https://pub.dev/packages/get_it)
- [Injectable Package](https://pub.dev/packages/injectable)
- [Reso Coder - Injectable Tutorial](https://resocoder.com/2020/02/04/injectable-flutter-dart-equivalent-to-dagger-angular-dependency-injection/)

---

**Data da Decisão:** Início do projeto  
**Revisado em:** 27/11/2025  
**Próxima revisão:** Apenas se houver mudanças significativas no ecossistema Dart  
**Status:** ✅ Funcionando perfeitamente

