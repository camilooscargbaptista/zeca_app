---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Contexto LESSONS-LEARNED.md"
---


# ZECA App - Lessons Learned

> **LEIA ESTE ARQUIVO ANTES DE QUALQUER TAREFA**
>
> Este arquivo contém erros que já aconteceram e NUNCA devem se repetir.
> Cada lição aqui custou tempo e retrabalho. Aprenda com eles.
>
> **Versão:** 2.0.0 | **Atualizado:** Janeiro 2026

---

## Índice de Lições

| ID | Prioridade | Descrição |
|----|------------|-----------|
| LESSON-001 | CRÍTICO | Widget real, NÃO imagem |
| LESSON-002 | CRÍTICO | Mockup ASCII ANTES de implementar |
| LESSON-003 | CRÍTICO | Verificar API-CONTRACTS antes de chamar |
| LESSON-004 | CRÍTICO | Rodar build_runner após Freezed |
| LESSON-005 | CRÍTICO | BLoC para telas complexas, não setState |
| LESSON-006 | CRÍTICO | Não inventar código |
| LESSON-007 | CRÍTICO | Nunca modificar state diretamente |
| LESSON-008 | CRÍTICO | Validar regras RN-XXX antes de implementar |
| LESSON-009 | IMPORTANTE | Dispose de subscriptions |
| LESSON-010 | IMPORTANTE | BlocBuilder com buildWhen |
| LESSON-011 | IMPORTANTE | Tratar todos os estados de UI |
| LESSON-012 | IMPORTANTE | Evitar hardcode de strings |
| LESSON-013 | IMPORTANTE | Cores sempre do Theme |
| LESSON-014 | IMPORTANTE | Model com null safety adequado |
| LESSON-015 | IMPORTANTE | Either sempre com fold |
| LESSON-016 | IMPORTANTE | UseCase retorna Either, não throw |
| LESSON-017 | IMPORTANTE | Injectable com escopo correto |
| LESSON-018 | IMPORTANTE | Testar BLoC com bloc_test |
| LESSON-019 | DESEJÁVEL | const widgets sempre que possível |
| LESSON-020 | DESEJÁVEL | Keys em listas dinâmicas |
| LESSON-021 | DESEJÁVEL | ListView.builder para listas grandes |
| LESSON-022 | DESEJÁVEL | Documentação com /// em públicos |
| LESSON-023 | DESEJÁVEL | Imports organizados por tipo |
| LESSON-024 | DESEJÁVEL | Commits convencionais |
| LESSON-025 | DESEJÁVEL | Feature flags para código experimental |
| **LESSON-046** | **CRÍTICO** | **Verificar core dependencies ANTES de criar arquivos** |

---

## CRÍTICO - Erros Graves (NUNCA repetir)

### LESSON-001: Widget real, NÃO imagem

**Data:** 2025-12-XX
**Erro:** Agente criou imagem PNG ao invés de Widget Flutter funcional.
**Impacto:** Usuário recebeu imagem inútil, não um componente utilizável.

**Causa:** Interpretação errada do pedido de "mostrar como ficaria".

**Solução:**
- Mockup = ASCII art para visualização
- Widget = Código Dart funcional
- NUNCA criar imagem para representar UI

**Regra:** UI sempre em código Dart, NUNCA em imagem PNG/JPG.

---

### LESSON-002: Mockup ASCII ANTES de implementar

**Data:** 2025-12-XX
**Erro:** Implementou tela direto sem aprovação visual.
**Impacto:** Tela diferente do esperado, teve que refazer.

**Causa:** Pulou etapa de mockup para "ganhar tempo".

**Solução:**
1. Criar mockup ASCII primeiro
2. Mostrar para aprovação
3. Aguardar "aprovado" antes de implementar

```
┌────────────────────────────┐
│  AppBar: Abastecimento     │
├────────────────────────────┤
│                            │
│  [Veículo Dropdown    ▼]   │
│                            │
│  Litros: [_____________]   │
│                            │
│  Valor:  [_____________]   │
│                            │
│  ┌──────────────────────┐  │
│  │    [ CONFIRMAR ]     │  │
│  └──────────────────────┘  │
│                            │
└────────────────────────────┘
```

**Regra:** NUNCA implementar UI sem mockup ASCII aprovado.

---

### LESSON-003: Verificar API-CONTRACTS antes de chamar

**Data:** 2025-12-XX
**Erro:** Criou DataSource chamando endpoint que não existe ou com payload errado.
**Impacto:** Erro em runtime, tempo perdido debugando.

**Causa:** Não consultou documentação da API.

**Solução:**
```bash
# SEMPRE antes de criar chamada HTTP:
cat .context/API-CONTRACTS.md | grep -A 30 "[endpoint]"

# Verificar models existentes
find lib -path "*models*" -name "*.dart" | xargs grep "class.*Model"
```

**Regra:** SEMPRE verificar API-CONTRACTS.md antes de criar DataSource.

---

### LESSON-004: Rodar build_runner após Freezed

**Data:** 2025-12-XX
**Erro:** Alterou model com @freezed mas não rodou build_runner.
**Impacto:** Erros de compilação, código gerado desatualizado.

**Causa:** Esqueceu de rodar comando após alteração.

**Solução:**
```bash
# SEMPRE após alterar arquivos com @freezed:
dart run build_runner build --delete-conflicting-outputs

# Verificar arquivos gerados
git status | grep ".g.dart\|.freezed.dart"
```

**Verificar também:**
- Models com `@freezed` ou `@JsonSerializable`
- States e Events com `@freezed`
- Classes com `@injectable`
- DataSources com `@RestApi`

**Regra:** Alterou Freezed = rodar build_runner imediatamente.

---

### LESSON-005: BLoC para telas complexas, não setState

**Data:** 2025-12-XX
**Erro:** Usou setState em tela com múltiplos estados e chamadas assíncronas.
**Impacto:** Estado inconsistente, bugs difíceis de reproduzir.

**Causa:** "Parecia simples" mas cresceu em complexidade.

**Solução:**
```dart
// NUNCA em telas com lógica
setState(() => isLoading = true);

// SEMPRE usar BLoC
context.read<MyBloc>().add(LoadData());
```

**Quando usar o quê:**
| Complexidade | Solução |
|--------------|---------|
| Simples (toggle, contador) | setState OK |
| Chamada de API | BLoC obrigatório |
| Múltiplos estados | BLoC obrigatório |
| Formulário complexo | BLoC obrigatório |

**Regra:** Se tem chamada de API = usar BLoC. Sem exceção.

---

### LESSON-006: Não inventar código

**Data:** 2025-12-XX
**Erro:** Criou código chamando métodos/classes que não existiam.
**Impacto:** Erros de compilação, tempo perdido.

**Causa:** Assumiu que certo código existia sem verificar.

**Solução:**
```bash
# Antes de usar qualquer classe/método:
grep -rn "NomeDaClasse" lib/ --include="*.dart"

# Verificar imports disponíveis:
find lib -name "*.dart" | xargs grep "class NomeDaClasse"

# Verificar exports do package
cat lib/features/feature_name/feature_name.dart
```

**Regra:** SEMPRE verificar se o código existe antes de usar.

---

### LESSON-007: Nunca modificar state diretamente

**Data:** 2026-01-XX
**Erro:** Modificou propriedade do state ao invés de emitir novo state.
**Impacto:** UI não atualizou, comportamento imprevisível.

**Causa:** Tentou "otimizar" evitando criar novo objeto.

**Solução:**
```dart
// ERRADO - Mutação direta
state.items.add(newItem);
emit(state);  // Não funciona!

// CERTO - Novo state imutável
emit(state.copyWith(
  items: [...state.items, newItem],
));
```

**Por que Freezed:**
```dart
@freezed
class MyState with _$MyState {
  const factory MyState({
    @Default([]) List<Item> items,
  }) = _MyState;
}

// copyWith garante imutabilidade
emit(state.copyWith(items: newItems));
```

**Regra:** State é IMUTÁVEL. Sempre emit() com copyWith() ou novo state.

---

### LESSON-008: Validar regras RN-XXX antes de implementar

**Data:** 2026-01-XX
**Erro:** Implementou feature sem verificar regras de negócio.
**Impacto:** Comportamento incorreto, teve que refazer toda a lógica.

**Causa:** Assumiu que entendia o requisito sem consultar documentação.

**Solução:**
```bash
# ANTES de implementar qualquer feature:
cat .context/BUSINESS-RULES.md | grep -A 10 "RN-XXX"

# Verificar regras relacionadas ao módulo
cat .context/BUSINESS-RULES.md | grep -B 2 -A 8 "[Abastecimento|Journey|Pagamento]"
```

**Checklist:**
- [ ] Li todas as RN-XXX do módulo
- [ ] Implementei validações no UseCase
- [ ] Tratei casos de erro com mensagens claras

**Regra:** SEMPRE consultar BUSINESS-RULES.md ANTES de implementar.

---

## IMPORTANTE - Erros Frequentes

### LESSON-009: Dispose de subscriptions

**Data:** 2025-12-XX
**Erro:** StreamSubscription sem cancel no dispose.
**Impacto:** Memory leak, callbacks em widget desmontado.

**Sintoma:** Erro "setState called after dispose".

**Solução:**
```dart
class _MyPageState extends State<MyPage> {
  StreamSubscription? _subscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen(_onData);
    _timer = Timer.periodic(duration, _onTick);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
```

**Regra:** Subscription/Timer criado = dispose obrigatório.

---

### LESSON-010: BlocBuilder com buildWhen

**Data:** 2025-12-XX
**Erro:** Widget pesado rebuildando em toda mudança de estado.
**Impacto:** UI lenta, jank, consumo de bateria.

**Sintoma:** Frame drops ao atualizar dados.

**Solução:**
```dart
// ERRADO - Rebuilda sempre
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) => ExpensiveWidget(data: state.data),
)

// CERTO - Rebuilda só quando necessário
BlocBuilder<MyBloc, MyState>(
  buildWhen: (previous, current) =>
    previous.data != current.data,
  builder: (context, state) => ExpensiveWidget(data: state.data),
)
```

**Regra:** Widget pesado + BlocBuilder = buildWhen obrigatório.

---

### LESSON-011: Tratar todos os estados de UI

**Data:** 2025-12-XX
**Erro:** Tela sem tratamento de Loading/Error/Empty.
**Impacto:** Tela em branco, usuário não sabe o que aconteceu.

**Sintoma:** Usuário reporta "app travou" mas não é crash.

**Solução:**
```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const LoadingWidget(),
      loaded: (data) => ContentWidget(data: data),
      empty: () => const EmptyWidget(),
      error: (message) => ErrorWidget(
        message: message,
        onRetry: () => context.read<MyBloc>().add(const LoadRequested()),
      ),
    );
  },
)
```

**Estados obrigatórios:**
- `initial` - Antes de carregar
- `loading` - Durante carregamento
- `loaded` - Com dados
- `empty` - Sem dados (lista vazia)
- `error` - Falha + botão retry

**Regra:** Toda tela com dados externos = 5 estados tratados.

---

### LESSON-012: Evitar hardcode de strings

**Data:** 2025-12-XX
**Erro:** Strings hardcoded espalhadas pelo código.
**Impacto:** Difícil manutenção, impossível traduzir.

**Sintoma:** Texto duplicado, tradução incompleta.

**Solução:**
```dart
// ERRADO
Text('Carregando...')
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Erro ao carregar')),
);

// CERTO
Text(AppStrings.loading)
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(AppStrings.loadError)),
);
```

**Localização:**
```
lib/core/constants/
├── app_strings.dart    # Strings da UI
├── app_errors.dart     # Mensagens de erro
└── app_labels.dart     # Labels de formulário
```

**Regra:** String visível ao usuário = constante centralizada.

---

### LESSON-013: Cores sempre do Theme

**Data:** 2025-12-XX
**Erro:** Cores hardcoded ao invés de usar Theme.
**Impacto:** Inconsistência visual, tema dark impossível.

**Sintoma:** Texto invisível no modo dark.

**Solução:**
```dart
// ERRADO
Container(color: Color(0xFF3F51B5))
Text('Hello', style: TextStyle(color: Colors.black))

// CERTO
Container(color: Theme.of(context).primaryColor)
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)

// Ou constantes do projeto
Container(color: AppColors.primary)
```

**Hierarquia:**
1. `Theme.of(context)` - Preferido
2. `AppColors` - Cores específicas do projeto
3. Hardcode - NUNCA

**Regra:** Cor visível = Theme ou AppColors. NUNCA Color() direto.

---

### LESSON-014: Model com null safety adequado

**Data:** 2025-12-XX
**Erro:** Model com campos required que podem vir null da API.
**Impacto:** Crash ao parsear JSON.

**Sintoma:** `Null check operator used on a null value`

**Solução:**
```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,           // Sempre presente
    String? optionalField,        // Pode ser null
    @Default('') String name,     // Default se null
    @Default([]) List<Item> items,// Default para listas
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**Quando usar cada um:**
| Tipo | Quando usar |
|------|-------------|
| `required String` | Sempre vem da API, nunca null |
| `String?` | Pode ser null e faz sentido ser null |
| `@Default('')` | Pode ser null mas preferimos string vazia |

**Regra:** Verificar API real antes de definir nullability.

---

### LESSON-015: Either sempre com fold

**Data:** 2025-12-XX
**Erro:** Usou .getRight() ou casting direto em Either.
**Impacto:** Crash quando retorno é Left (erro).

**Sintoma:** `type 'Left' is not a subtype of type 'Right'`

**Solução:**
```dart
// ERRADO - Pode crashar
final data = result.getRight();
emit(Loaded(data));

// CERTO - Trata ambos os casos
result.fold(
  (failure) => emit(Error(failure.message)),
  (success) => emit(Loaded(success)),
);

// Alternativa com pattern matching
switch (result) {
  case Left(value: final failure):
    emit(Error(failure.message));
  case Right(value: final data):
    emit(Loaded(data));
}
```

**Regra:** Either = fold() obrigatório. NUNCA getRight().

---

### LESSON-016: UseCase retorna Either, não throw

**Data:** 2026-01-XX
**Erro:** UseCase fez throw de exceção ao invés de retornar Either.
**Impacto:** Try-catch obrigatório no BLoC, inconsistência no tratamento.

**Causa:** Copiou padrão de outro framework.

**Solução:**
```dart
// ERRADO
class GetRefuelingsUseCase {
  Future<List<Refueling>> call() async {
    final result = await repository.getAll();
    if (result.isEmpty) {
      throw EmptyResultException();  // NÃO!
    }
    return result;
  }
}

// CERTO
class GetRefuelingsUseCase {
  Future<Either<Failure, List<Refueling>>> call() async {
    try {
      final result = await repository.getAll();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

**Regra:** UseCase retorna Either<Failure, Success>. NUNCA throw.

---

### LESSON-017: Injectable com escopo correto

**Data:** 2026-01-XX
**Erro:** Usou @singleton em BLoC, causando estado compartilhado entre telas.
**Impacto:** Dados de uma tela aparecendo em outra.

**Causa:** Não entendeu diferença entre escopos.

**Solução:**
```dart
// Escopo CORRETO por tipo:

@lazySingleton  // UMA instância no app
class RefuelingRemoteDataSource {}

@lazySingleton  // UMA instância no app
class RefuelingRepositoryImpl implements RefuelingRepository {}

@injectable     // NOVA instância por chamada
class GetRefuelingsUseCase {}

@injectable     // NOVA instância por tela
class RefuelingBloc {}
```

| Tipo | Annotation | Motivo |
|------|------------|--------|
| DataSource | `@lazySingleton` | Reutiliza conexão HTTP |
| Repository | `@lazySingleton` | Reutiliza cache |
| UseCase | `@injectable` | Stateless, pode ser novo |
| BLoC | `@injectable` | OBRIGATÓRIO novo por tela |

**Regra:** BLoC é SEMPRE @injectable, NUNCA singleton.

---

### LESSON-018: Testar BLoC com bloc_test

**Data:** 2026-01-XX
**Erro:** Testou BLoC manualmente com expect/await.
**Impacto:** Testes flaky, estados intermediários não testados.

**Causa:** Não conhecia bloc_test package.

**Solução:**
```dart
// ERRADO - Teste manual
test('should emit loaded', () async {
  bloc.add(LoadRequested());
  await Future.delayed(Duration(milliseconds: 100));
  expect(bloc.state, isA<Loaded>());
});

// CERTO - Com bloc_test
blocTest<RefuelingBloc, RefuelingState>(
  'emits [Loading, Loaded] when LoadRequested is added',
  build: () {
    when(() => useCase()).thenAnswer((_) async => Right(mockData));
    return RefuelingBloc(useCase);
  },
  act: (bloc) => bloc.add(const LoadRequested()),
  expect: () => [
    const RefuelingState.loading(),
    RefuelingState.loaded(mockData),
  ],
  verify: (_) {
    verify(() => useCase()).called(1);
  },
);
```

**Regra:** Testes de BLoC = bloc_test package. SEMPRE.

---

## DESEJÁVEL - Boas Práticas

### LESSON-019: const widgets sempre que possível

**Data:** 2025-12-XX
**Erro:** Widgets estáticos sem const, causando rebuilds desnecessários.
**Impacto:** Performance degradada.

**Solução:**
```dart
// ERRADO - Recria a cada build
return Padding(
  padding: EdgeInsets.all(16),
  child: Text('Static text'),
);

// CERTO - Reusa instância
return const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Static text'),
);
```

**Impacto:** Reduz até 70% de rebuilds desnecessários.

**Regra:** Se não depende de variável = const.

---

### LESSON-020: Keys em listas dinâmicas

**Data:** 2026-01-XX
**Erro:** Lista sem keys, causando bugs ao reordenar/remover itens.
**Impacto:** Estado de widgets misturado entre itens.

**Sintoma:** Checkbox marcado no item errado após reordenar.

**Solução:**
```dart
// ERRADO
ListView.builder(
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)

// CERTO
ListView.builder(
  itemBuilder: (context, index) => ItemCard(
    key: ValueKey(items[index].id),
    item: items[index],
  ),
)
```

**Quando usar Key:**
- Listas que podem ser reordenadas
- Listas com itens removíveis
- Widgets stateful em listas

**Regra:** Lista dinâmica + StatefulWidget = Key obrigatória.

---

### LESSON-021: ListView.builder para listas grandes

**Data:** 2026-01-XX
**Erro:** Usou ListView(children: items.map(...).toList()) para 100+ itens.
**Impacto:** Jank no scroll, consumo de memória.

**Solução:**
```dart
// ERRADO - Cria todos de uma vez
ListView(
  children: items.map((item) => ItemCard(item: item)).toList(),
)

// CERTO - Cria sob demanda (lazy)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)
```

**Regra:** Lista com mais de 20 itens = ListView.builder.

---

### LESSON-022: Documentação com /// em públicos

**Data:** 2026-01-XX
**Erro:** UseCase público sem documentação.
**Impacto:** Difícil entender o que faz sem ler código.

**Solução:**
```dart
/// Busca abastecimentos do motorista atual.
///
/// Retorna lista ordenada por data (mais recente primeiro).
///
/// [params] - Filtros opcionais (período, veículo).
///
/// Returns [Right] com lista de [Refueling].
/// Returns [Left] com [Failure] se erro de conexão.
///
/// Exemplo:
/// ```dart
/// final result = await useCase(GetRefuelingsParams());
/// result.fold(
///   (failure) => print(failure.message),
///   (refuelings) => print(refuelings.length),
/// );
/// ```
Future<Either<Failure, List<Refueling>>> call(GetRefuelingsParams params);
```

**Regra:** API pública = documentação com ///.

---

### LESSON-023: Imports organizados por tipo

**Data:** 2026-01-XX
**Erro:** Imports desorganizados, difícil encontrar dependências.
**Impacto:** Tempo perdido navegando imports.

**Solução:**
```dart
// 1. Dart core
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages externos (alfabético)
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 4. Imports do projeto (relativos)
import '../../../core/error/failures.dart';
import '../../domain/entities/refueling.dart';

// 5. Parts (sempre por último)
part 'refueling_state.freezed.dart';
```

**Regra:** Imports sempre nesta ordem, com linha vazia entre grupos.

---

### LESSON-024: Commits convencionais

**Data:** 2026-01-XX
**Erro:** Commits com mensagens genéricas "fix bug", "update code".
**Impacto:** Histórico inútil, impossível rastrear mudanças.

**Solução:**
```bash
# Formato
<type>(<scope>): <description>

# Exemplos
feat(refueling): add QR code payment screen
fix(journey): resolve crash on empty vehicle list
refactor(bloc): migrate to freezed states
test(auth): add login bloc tests
docs(readme): update installation instructions
```

| Type | Uso |
|------|-----|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `refactor` | Refatoração sem mudança de comportamento |
| `test` | Adição/correção de testes |
| `docs` | Documentação |
| `style` | Formatação |
| `chore` | Tarefas de manutenção |

**Regra:** Todo commit segue Conventional Commits.

---

### LESSON-025: Feature flags para código experimental

**Data:** 2026-01-XX
**Erro:** Código experimental direto em produção.
**Impacto:** Bugs em produção, rollback complexo.

**Solução:**
```dart
// lib/core/config/feature_flags.dart
abstract class FeatureFlags {
  static const bool enableNewPayment = false;
  static const bool enableBiometricAuth = true;
  static const bool showDebugInfo = kDebugMode;
}

// Uso
if (FeatureFlags.enableNewPayment) {
  // Código experimental
} else {
  // Código estável
}
```

**Regra:** Feature não finalizada = feature flag desabilitada.

---

## BOAS PRÁTICAS Consolidadas

### BP-001: Estrutura consistente de Feature

```
feature/
├── data/
│   ├── datasources/
│   │   └── feature_remote_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       └── get_feature_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── feature_bloc.dart
    │   ├── feature_event.dart
    │   └── feature_state.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_card.dart
```

---

### BP-002: Nomenclatura de BLoC Events

```dart
// Padrão: {Ação}Requested ou {Campo}Changed

// Ações
sealed class RefuelingEvent with _$RefuelingEvent {
  const factory RefuelingEvent.loadRequested() = LoadRequested;
  const factory RefuelingEvent.refreshRequested() = RefreshRequested;
  const factory RefuelingEvent.deleteRequested(String id) = DeleteRequested;
  const factory RefuelingEvent.submitRequested() = SubmitRequested;
}

// Mudanças de campo
sealed class FormEvent with _$FormEvent {
  const factory FormEvent.vehicleChanged(String id) = VehicleChanged;
  const factory FormEvent.litersChanged(double value) = LitersChanged;
}
```

---

### BP-003: Estados do BLoC

```dart
// Padrão: Estados descritivos

@freezed
sealed class RefuelingState with _$RefuelingState {
  const factory RefuelingState.initial() = _Initial;
  const factory RefuelingState.loading() = _Loading;
  const factory RefuelingState.loaded(List<Refueling> items) = _Loaded;
  const factory RefuelingState.empty() = _Empty;
  const factory RefuelingState.error(String message) = _Error;
}
```

---

### BP-004: Tratamento de Either

```dart
// Sempre usar fold ou pattern matching
final result = await useCase(params);

// Opção 1: fold
result.fold(
  (failure) => emit(RefuelingState.error(failure.message)),
  (success) => emit(RefuelingState.loaded(success)),
);

// Opção 2: pattern matching (Dart 3+)
switch (result) {
  case Left(value: final failure):
    emit(RefuelingState.error(failure.message));
  case Right(value: final data):
    emit(RefuelingState.loaded(data));
}
```

---

### BP-005: Const em tudo estático

```dart
// Widgets
return const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Static text'),
);

// EdgeInsets
const EdgeInsets.all(16)
const EdgeInsets.symmetric(horizontal: 16, vertical: 8)

// SizedBox
const SizedBox(height: 8)
const SizedBox(width: 16)
const SizedBox.shrink()

// Colors (se usando AppColors)
const Color(0xFF3F51B5)  // OK em constantes
```

---

## Métricas de Qualidade

### Meta: Cobertura ≥ 60%

```bash
# Rodar testes com cobertura
flutter test --coverage

# Gerar relatório HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir relatório
open coverage/html/index.html
```

### Meta: Zero warnings no analyze

```bash
# Verificar
flutter analyze

# Resultado esperado
Analyzing zeca_app...
No issues found!
```

### Meta: Código formatado

```bash
# Verificar formatação
dart format --set-exit-if-changed lib/

# Aplicar formatação
dart format lib/
```

### Meta: Build sem erros

```bash
# Android
flutter build apk --debug

# iOS
flutter build ios --debug --no-codesign

# Build runner atualizado
dart run build_runner build --delete-conflicting-outputs
```

---

## Como Atualizar Este Arquivo

Quando encontrar um novo problema que custou tempo:

1. **Identificar a causa raiz**
   - O que exatamente deu errado?
   - Por que aconteceu?

2. **Documentar seguindo o formato:**
   ```markdown
   ### LESSON-XXX: Título descritivo

   **Data:** YYYY-MM-DD
   **Erro:** O que aconteceu
   **Impacto:** Consequência do erro

   **Causa:** Por que aconteceu

   **Solução:**
   ```código da solução```

   **Regra:** Regra clara para não repetir
   ```

3. **Classificar por prioridade:**
   - CRÍTICO: Causa crash, perda de dados, retrabalho grande
   - IMPORTANTE: Bug visível, impacta UX, tempo perdido
   - DESEJÁVEL: Melhoria de qualidade, manutenibilidade

4. **Atualizar índice** no topo do arquivo

---

## Consulta Rápida

### Antes de implementar UI:
- [ ] LESSON-001: Widget real, não imagem
- [ ] LESSON-002: Mockup ASCII aprovado

### Antes de chamar API:
- [ ] LESSON-003: Verificar API-CONTRACTS
- [ ] LESSON-006: Código existe?

### Após alterar Freezed:
- [ ] LESSON-004: build_runner executado

### Ao criar BLoC:
- [ ] LESSON-005: BLoC, não setState
- [ ] LESSON-007: State imutável
- [ ] LESSON-011: 5 estados tratados
- [ ] LESSON-017: @injectable, não @singleton

### Ao criar UseCase:
- [ ] LESSON-008: Regras RN-XXX verificadas
- [ ] LESSON-016: Retorna Either

---

**Lembre-se:** Cada erro aqui foi real e custou tempo. Não repita os mesmos erros.

---

*Lessons Learned v2.0.0 - Janeiro 2026*
