# ZECA App - Sistema de Agentes Especialistas

> **IMPORTANTE**: Este arquivo é lido AUTOMATICAMENTE pelo Antigravity.
> Todas as regras aqui são OBRIGATÓRIAS e INEGOCIÁVEIS.

---

## 🎯 IDENTIDADE DO PROJETO

**Projeto:** ZECA App - Aplicativo Mobile
**Stack:** Flutter 3.x + Dart
**Arquitetura:** Clean Architecture + BLoC Pattern
**State Management:** flutter_bloc
**DI:** get_it + injectable
**HTTP:** dio
**Testes:** flutter_test + mockito + bloc_test
**Meta de Cobertura:** ≥60%

---

## 🚨 REGRAS INEGOCIÁVEIS

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  1. CONSULTAR .context/ ANTES de qualquer ação                               ║
║  2. MOCKUP ASCII para aprovação ANTES de implementar UI                      ║
║  3. WIDGET REAL (NUNCA imagem PNG/JPG para representar UI)                  ║
║  4. TESTES OBRIGATÓRIOS (≥60% cobertura)                                    ║
║  5. NÃO PERGUNTAR - FAZER (executar comandos, não sugerir)                  ║
║  6. NÃO QUEBRAR fluxo existente                                             ║
║  7. VERIFICAR API-CONTRACTS.md ANTES de criar chamadas HTTP                 ║
║  8. NÃO INVENTAR código - SEMPRE verificar o que existe primeiro            ║
║  9. USAR BLoC para state management (NUNCA setState em telas complexas)     ║
║  10. SEGUIR Clean Architecture (data → domain → presentation)               ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 📋 FLUXO OBRIGATÓRIO (ORCHESTRATOR)

### Para QUALQUER tarefa, seguir este fluxo:

```
┌─────────────────────────────────────────────────────────────────┐
│  1. DIAGNÓSTICO                                                  │
│     - Ler .context/LESSONS-LEARNED.md                           │
│     - Verificar estrutura existente                             │
│     - Identificar arquivos impactados                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. ANÁLISE (ANALYST)                                           │
│     - Gerar User Story com critérios de aceite                  │
│     - Quebrar em Tasks técnicas                                 │
│     - Definir ordem de execução                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  3. MOCKUP ASCII (se houver UI)                                 │
│     - Criar mockup ASCII art                                    │
│     - AGUARDAR APROVAÇÃO antes de implementar                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  4. IMPLEMENTAÇÃO                                               │
│     - Seguir Clean Architecture                                 │
│     - Data Layer → Domain Layer → Presentation Layer            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  5. TESTES (QA-MASTER)                                          │
│     - Criar testes unitários (BLoC, Repository, UseCase)        │
│     - Criar widget tests                                        │
│     - Verificar cobertura ≥60%                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  6. VALIDAÇÃO FINAL                                             │
│     - flutter analyze (zero warnings)                           │
│     - flutter test                                              │
│     - Testar no emulador/dispositivo                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔍 DIAGNÓSTICO OBRIGATÓRIO

### Antes de QUALQUER código, executar:

```bash
# 1. Ler lições aprendidas
cat .context/LESSONS-LEARNED.md

# 2. Verificar contratos de API
cat .context/API-CONTRACTS.md

# 3. Verificar arquitetura
cat .context/ARCHITECTURE.md

# 4. Verificar regras de negócio
cat .context/BUSINESS-RULES.md
```

### Verificar Estrutura Existente:

```bash
# Estrutura de features
ls -la lib/features/

# Verificar se feature já existe
find lib -name "*[nome]*" -type d

# Verificar BLoCs existentes
find lib -name "*_bloc.dart" | head -20

# Verificar models existentes
find lib -name "*_model.dart" | head -20

# Verificar repositories existentes
find lib -name "*_repository*.dart" | head -20

# Verificar services existentes
find lib -name "*_service.dart" | head -20
```

---

## 📝 ANALYST - Geração de User Stories e Tasks

### Formato de User Story:

```markdown
## US-XXX: [Título]

**COMO** [persona: motorista/frotista/atendente]
**QUERO** [ação]
**PARA** [benefício]

### Critérios de Aceite:
- [ ] CA1: [critério mensurável]
- [ ] CA2: [critério mensurável]
- [ ] CA3: [critério mensurável]

### Regras de Negócio:
- RN01: [descrição]
- RN02: [descrição]

### Dependências:
- [lista de dependências técnicas]
```

### Formato de Task:

```markdown
## TASK-XXX: [Título]

**Agente:** APP-MASTER
**Camada:** Data | Domain | Presentation
**Prioridade:** Alta | Média | Baixa
**Dependência:** TASK-YYY (ou nenhuma)

### Descrição:
[O que fazer]

### Arquivos a Criar/Modificar:
- `lib/features/[feature]/data/...`
- `lib/features/[feature]/domain/...`
- `lib/features/[feature]/presentation/...`

### Comandos de Diagnóstico:
```bash
[comandos para verificar antes]
```

### Critérios de Aceite:
- [ ] [critério 1]
- [ ] [critério 2]

### Testes Obrigatórios:
- [ ] Teste unitário para BLoC
- [ ] Teste unitário para Repository
- [ ] Widget test para tela
```

---

## 🏗️ CLEAN ARCHITECTURE - Estrutura Obrigatória

### Estrutura de Feature:

```
lib/features/[nome_feature]/
├── data/
│   ├── datasources/
│   │   ├── [nome]_remote_datasource.dart
│   │   └── [nome]_local_datasource.dart
│   ├── models/
│   │   └── [nome]_model.dart
│   └── repositories/
│       └── [nome]_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── [nome]_entity.dart
│   ├── repositories/
│   │   └── [nome]_repository.dart (abstract)
│   └── usecases/
│       ├── get_[nome].dart
│       ├── create_[nome].dart
│       └── ...
│
└── presentation/
    ├── bloc/
    │   ├── [nome]_bloc.dart
    │   ├── [nome]_event.dart
    │   └── [nome]_state.dart
    ├── pages/
    │   └── [nome]_page.dart
    └── widgets/
        └── [nome]_widget.dart
```

### Ordem de Implementação:

```
1. Domain Layer (Entities, Repository Interface, UseCases)
2. Data Layer (Models, DataSources, Repository Implementation)
3. Presentation Layer (BLoC, Pages, Widgets)
4. Testes (Unit tests, Widget tests)
```

---

## 📱 APP-MASTER - Regras Flutter

### BLoC Pattern:

```dart
// ✅ CORRETO - BLoC com estados tipados
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final GetRefuelingUseCase _getRefuelingUseCase;
  
  RefuelingBloc(this._getRefuelingUseCase) : super(RefuelingInitial()) {
    on<LoadRefueling>(_onLoadRefueling);
  }
  
  Future<void> _onLoadRefueling(
    LoadRefueling event,
    Emitter<RefuelingState> emit,
  ) async {
    emit(RefuelingLoading());
    final result = await _getRefuelingUseCase(event.id);
    result.fold(
      (failure) => emit(RefuelingError(failure.message)),
      (refueling) => emit(RefuelingLoaded(refueling)),
    );
  }
}

// ❌ ERRADO - setState em tela complexa
class _RefuelingPageState extends State<RefuelingPage> {
  bool isLoading = false;
  void loadData() {
    setState(() => isLoading = true); // NUNCA fazer isso!
  }
}
```

### Models com Freezed:

```dart
// lib/features/refueling/data/models/refueling_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'refueling_model.freezed.dart';
part 'refueling_model.g.dart';

@freezed
class RefuelingModel with _$RefuelingModel {
  const factory RefuelingModel({
    required String id,
    required String code,
    required String status,
    required double totalValue,
    required double quantityLiters,
    required double pricePerLiter,
    required double pumpPrice,
    required double savings,
    required String stationName,
    required String vehiclePlate,
    required String fuelType,
    required DateTime timestamp,
  }) = _RefuelingModel;

  factory RefuelingModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingModelFromJson(json);
}
```

### Após criar/modificar models com Freezed:

```bash
# OBRIGATÓRIO após alterar models
dart run build_runner build --delete-conflicting-outputs
```

### Convenções de Nomenclatura:

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Feature folder | snake_case | `refueling`, `auth`, `vehicle` |
| BLoC | PascalCase + Bloc | `RefuelingBloc` |
| Event | PascalCase + Event | `LoadRefueling`, `SubmitRefueling` |
| State | PascalCase + State | `RefuelingLoading`, `RefuelingLoaded` |
| Model | PascalCase + Model | `RefuelingModel` |
| Entity | PascalCase | `Refueling` |
| Repository | PascalCase + Repository | `RefuelingRepository` |
| UseCase | PascalCase | `GetRefueling`, `CreateRefueling` |
| Page | PascalCase + Page | `RefuelingPage` |
| Widget | PascalCase + Widget | `RefuelingCard` |

### NUNCA fazer:

- ❌ Usar `setState` em telas com lógica complexa
- ❌ Chamar API direto no Widget
- ❌ Criar Widget sem considerar estados (loading, error, empty)
- ❌ Hardcodar strings (usar AppStrings ou i18n)
- ❌ Hardcodar cores (usar AppColors ou Theme)
- ❌ Criar model sem Freezed
- ❌ Esquecer de rodar `build_runner` após alterar models

---

## 🎨 UI/UX - Regras de Interface

### Mockup ASCII Obrigatório:

Antes de implementar qualquer tela, criar mockup ASCII:

```
┌─────────────────────────────────────────┐
│ ←  Título da Tela                       │
├─────────────────────────────────────────┤
│                                         │
│   ┌─────────────────────────────────┐   │
│   │  Conteúdo do Card               │   │
│   │  - Item 1                       │   │
│   │  - Item 2                       │   │
│   └─────────────────────────────────┘   │
│                                         │
│   ┌─────────────────────────────────┐   │
│   │       BOTÃO PRIMÁRIO            │   │
│   └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

**AGUARDAR APROVAÇÃO antes de implementar!**

### Estados Obrigatórios:

Toda tela deve implementar:

```dart
BlocBuilder<RefuelingBloc, RefuelingState>(
  builder: (context, state) {
    // 1. Loading
    if (state is RefuelingLoading) {
      return const LoadingWidget();
    }
    
    // 2. Error
    if (state is RefuelingError) {
      return ErrorWidget(
        message: state.message,
        onRetry: () => context.read<RefuelingBloc>().add(LoadRefueling()),
      );
    }
    
    // 3. Empty
    if (state is RefuelingLoaded && state.items.isEmpty) {
      return const EmptyWidget(message: 'Nenhum abastecimento encontrado');
    }
    
    // 4. Success/Loaded
    if (state is RefuelingLoaded) {
      return RefuelingList(items: state.items);
    }
    
    return const SizedBox.shrink();
  },
)
```

### Cores e Temas:

```dart
// Usar SEMPRE do tema, nunca hardcodar
Theme.of(context).primaryColor        // ✅
Theme.of(context).colorScheme.error   // ✅
Color(0xFF3F51B5)                     // ❌ NUNCA

// Ou usar AppColors centralizadas
AppColors.primary    // ✅
AppColors.success    // ✅
```

---

## 🧪 QA-MASTER - Regras de Testes

### Cobertura Mínima: 60%

### Estrutura de Testes:

```
test/
├── features/
│   └── refueling/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── refueling_remote_datasource_test.dart
│       │   └── repositories/
│       │       └── refueling_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── get_refueling_test.dart
│       └── presentation/
│           ├── bloc/
│           │   └── refueling_bloc_test.dart
│           └── pages/
│               └── refueling_page_test.dart
├── mocks/
│   └── mock_repositories.dart
└── fixtures/
    └── refueling_fixture.dart
```

### Teste de BLoC:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late RefuelingBloc bloc;
  late MockGetRefuelingUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetRefuelingUseCase();
    bloc = RefuelingBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('RefuelingBloc', () {
    blocTest<RefuelingBloc, RefuelingState>(
      'should emit [Loading, Loaded] when data is fetched successfully',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => Right(tRefueling),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadRefueling('123')),
      expect: () => [
        RefuelingLoading(),
        RefuelingLoaded(tRefueling),
      ],
    );

    blocTest<RefuelingBloc, RefuelingState>(
      'should emit [Loading, Error] when fetching fails',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => Left(ServerFailure('Error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadRefueling('123')),
      expect: () => [
        RefuelingLoading(),
        RefuelingError('Error'),
      ],
    );
  });
}
```

### Widget Test:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

void main() {
  late MockRefuelingBloc mockBloc;

  setUp(() {
    mockBloc = MockRefuelingBloc();
  });

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    when(mockBloc.state).thenReturn(RefuelingLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<RefuelingBloc>.value(
          value: mockBloc,
          child: RefuelingPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error message when state is error',
      (tester) async {
    when(mockBloc.state).thenReturn(RefuelingError('Erro ao carregar'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<RefuelingBloc>.value(
          value: mockBloc,
          child: RefuelingPage(),
        ),
      ),
    );

    expect(find.text('Erro ao carregar'), findsOneWidget);
  });
}
```

### Comandos de Teste:

```bash
# Rodar todos os testes
flutter test

# Rodar com cobertura
flutter test --coverage

# Rodar teste específico
flutter test test/features/refueling/presentation/bloc/refueling_bloc_test.dart

# Ver relatório de cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📚 REFERÊNCIA AOS ARQUIVOS .context/

### SEMPRE consultar antes de codar:

| Arquivo | Quando Consultar |
|---------|------------------|
| `ARCHITECTURE.md` | Estrutura de pastas, padrões, convenções |
| `API-CONTRACTS.md` | Criar/modificar chamadas HTTP |
| `BUSINESS-RULES.md` | Regras específicas do ZECA |
| `LESSONS-LEARNED.md` | SEMPRE - antes de qualquer tarefa |

---

## ⚠️ LESSONS LEARNED - Erros que NUNCA podem se repetir

### LESSON-001: Widget real, não imagem
- **Erro:** Agente criou imagem PNG ao invés de Widget Flutter
- **Regra:** NUNCA usar imagem para representar UI

### LESSON-002: Mockup ASCII antes de implementar
- **Erro:** Implementou tela direto sem aprovação
- **Regra:** SEMPRE criar mockup ASCII e aguardar aprovação

### LESSON-003: Verificar API antes de chamar
- **Erro:** Chamou endpoint que não existe ou com payload errado
- **Regra:** SEMPRE consultar API-CONTRACTS.md

### LESSON-004: Rodar build_runner após Freezed
- **Erro:** Esqueceu de rodar build_runner após alterar model
- **Regra:** SEMPRE rodar `dart run build_runner build`

### LESSON-005: BLoC para telas complexas
- **Erro:** Usou setState em tela com múltiplos estados
- **Regra:** SEMPRE usar BLoC para telas com lógica

### LESSON-006: Não inventar código
- **Erro:** Criou código chamando métodos inexistentes
- **Regra:** SEMPRE verificar o que existe antes de usar

---

## 🔄 WORKFLOWS DISPONÍVEIS

Use `/comando` para acionar:

| Comando | Descrição |
|---------|-----------|
| `/new-feature` | Criar nova funcionalidade completa |
| `/fix-bug` | Corrigir bug com diagnóstico |
| `/generate-tests` | Gerar testes para arquivo/módulo |
| `/create-mock` | Criar mockup ASCII para UI |
| `/code-review` | Revisar código e sugerir melhorias |

---

## ✅ CHECKLIST FINAL (antes de dizer "pronto")

```
□ Diagnóstico executado (.context/ consultado)
□ User Story e Tasks definidas (se feature nova)
□ Mockup ASCII aprovado (se houver UI)
□ Clean Architecture seguida (data → domain → presentation)
□ BLoC implementado corretamente
□ build_runner executado (se usou Freezed)
□ Testes criados e passando
□ Cobertura ≥60%
□ flutter analyze sem warnings
□ flutter test passando
□ Testado no emulador/dispositivo
□ Fluxos existentes continuam funcionando
□ API-CONTRACTS.md consultado (se chamou API)
□ LESSONS-LEARNED.md atualizado (se aprendeu algo)
```

---

**🚀 LEMBRE-SE: Qualidade > Velocidade. Fazer certo da primeira vez.**
