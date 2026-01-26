# 🚦 Quality Gates - ZECA App Flutter

> **Nenhum código passa para produção sem passar por TODOS os gates críticos.**

---

## 📊 Visão Geral

| Prioridade | Gates | Descrição |
|------------|-------|-----------|
| 🔴 CRÍTICO | QG-01 a QG-04 | Bloqueiam merge/deploy |
| 🟡 IMPORTANTE | QG-05 a QG-08 | Devem ser corrigidos antes do PR |
| 🟢 DESEJÁVEL | QG-09 a QG-12 | Melhoram qualidade geral |

---

## 🔴 GATES CRÍTICOS (Bloqueiam Deploy)

### QG-01: Compilação e Build

**Critério:** Projeto compila sem erros em todas as plataformas.

```bash
# Verificações obrigatórias
flutter analyze                                    # Zero erros
dart run build_runner build --delete-conflicting-outputs  # Código gerado OK
flutter build apk --debug                          # Build Android OK
flutter build ios --debug --no-codesign            # Build iOS OK
```

| Check | Comando | Resultado Esperado |
|-------|---------|-------------------|
| Analyze | `flutter analyze` | 0 erros, 0 warnings |
| Build Runner | `dart run build_runner build` | Sem conflitos |
| APK Debug | `flutter build apk --debug` | BUILD SUCCESSFUL |
| iOS Debug | `flutter build ios --debug` | Build Succeeded |

**Se falhar:** ❌ Não pode fazer merge. Corrigir erros de compilação primeiro.

---

### QG-02: Testes Automatizados

**Critério:** Cobertura mínima de 60% e todos os testes passando.

```bash
# Rodar testes
flutter test

# Verificar cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Abrir coverage/html/index.html
```

| Métrica | Mínimo | Ideal |
|---------|--------|-------|
| Cobertura geral | 60% | 80% |
| Testes de BLoC | 100% | 100% |
| Testes de UseCase | 80% | 100% |
| Testes de Repository | 70% | 90% |

**Checklist de Testes:**
- [ ] Testes unitários para BLoCs (bloc_test)
- [ ] Testes unitários para UseCases
- [ ] Testes de Repository com mocks
- [ ] Testes de Widget para componentes críticos
- [ ] Todos os testes passando (verde)

**Se falhar:** ❌ Não pode fazer merge. Escrever testes faltantes.

---

### QG-03: Código Gerado Atualizado

**Critério:** Arquivos .g.dart e .freezed.dart estão sincronizados.

```bash
# Regenerar código
dart run build_runner build --delete-conflicting-outputs

# Verificar se há mudanças não commitadas
git status
```

| Verificação | Esperado |
|-------------|----------|
| `*.freezed.dart` | Sem mudanças após build_runner |
| `*.g.dart` | Sem mudanças após build_runner |
| `injection.config.dart` | Atualizado com novos injetáveis |

**Arquivos que precisam de build_runner:**
- Models com `@freezed`
- States com `@freezed`
- Events com `@freezed`
- Classes com `@injectable`
- DataSources com `@RestApi`

**Se falhar:** ❌ Rodar `dart run build_runner build --delete-conflicting-outputs` e commitar.

---

### QG-04: Regras de Negócio

**Critério:** Implementação segue as regras RN-XXX documentadas.

```bash
# Consultar regras
cat .context/BUSINESS-RULES.md | grep "RN-"
```

| Verificação | Como validar |
|-------------|--------------|
| Regras implementadas | Código reflete RN-XXX |
| Validações presentes | Erros de negócio tratados |
| Fluxos corretos | Estados seguem máquina de estados |

**Checklist:**
- [ ] Consultei BUSINESS-RULES.md antes de implementar
- [ ] Todas as RN-XXX relevantes foram implementadas
- [ ] Validações de negócio estão no Domain (UseCase)
- [ ] Mensagens de erro são claras para o usuário

**Se falhar:** ❌ Revisar implementação contra regras de negócio.

---

## 🟡 GATES IMPORTANTES (Corrigir antes do PR)

### QG-05: Padrões de Estado (BLoC)

**Critério:** Estados seguem padrões definidos em BLOC-PATTERNS.md.

| Verificação | Esperado |
|-------------|----------|
| Estados com Freezed | `@freezed class XState` |
| Eventos com Freezed | `@freezed class XEvent` |
| Estados de UI | initial, loading, loaded, error |
| BlocBuilder com buildWhen | Para widgets pesados |

```dart
// ✅ CORRETO
@freezed
class RefuelingState with _$RefuelingState {
  const factory RefuelingState.initial() = _Initial;
  const factory RefuelingState.loading() = _Loading;
  const factory RefuelingState.loaded(Refueling data) = _Loaded;
  const factory RefuelingState.error(String message) = _Error;
}

// ❌ ERRADO
class RefuelingState {
  bool isLoading = false;  // Mutável!
}
```

---

### QG-06: Clean Architecture

**Critério:** Estrutura de pastas e dependências seguem Clean Architecture.

```
feature/
├── data/           # Dados externos
│   ├── datasources/    # API calls
│   ├── models/         # DTOs com fromJson/toJson
│   └── repositories/   # Implementação
├── domain/         # Regras de negócio
│   ├── entities/       # Objetos puros
│   ├── repositories/   # Interfaces (abstract)
│   └── usecases/       # Casos de uso
└── presentation/   # UI
    ├── bloc/           # BLoC/Cubit
    ├── pages/          # Telas
    └── widgets/        # Componentes
```

| Regra | Verificação |
|-------|-------------|
| Domain não importa Data | `grep -r "import.*data" lib/features/*/domain/` = vazio |
| Presentation usa Domain | BLoC injeta UseCase, não Repository |
| Data implementa Domain | Repository implementa interface do Domain |

---

### QG-07: Tratamento de Erros

**Critério:** Todos os erros são tratados e mostram feedback ao usuário.

```dart
// ✅ CORRETO - Erro tratado
result.fold(
  (failure) => emit(RefuelingState.error(failure.message)),
  (data) => emit(RefuelingState.loaded(data)),
);

// ❌ ERRADO - Erro ignorado
try {
  await doSomething();
} catch (e) {
  print(e);  // Usuário não vê nada!
}
```

| Estado | Tratamento no App |
|--------|-------------------|
| Loading | Mostrar indicador de carregamento |
| Error | Mostrar mensagem + botão "Tentar novamente" |
| Empty | Mostrar estado vazio com instrução |
| Offline | Mostrar "Sem conexão" |

---

### QG-08: Injeção de Dependência

**Critério:** Todas as classes injetáveis estão registradas corretamente.

```dart
// ✅ CORRETO
@lazySingleton
class RefuelingRepositoryImpl implements RefuelingRepository {}

@injectable
class GetRefuelingUseCase {
  final RefuelingRepository _repository;
  GetRefuelingUseCase(this._repository);
}

@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final GetRefuelingUseCase _useCase;
  RefuelingBloc(this._useCase) : super(const RefuelingState.initial());
}
```

| Tipo | Annotation | Escopo |
|------|------------|--------|
| DataSource | `@lazySingleton` | Uma instância |
| Repository | `@lazySingleton` | Uma instância |
| UseCase | `@injectable` | Nova instância |
| BLoC | `@injectable` | Nova instância por tela |

---

## 🟢 GATES DESEJÁVEIS (Melhoram qualidade)

### QG-09: Performance

**Critério:** App roda suave, sem jank ou memory leaks.

| Verificação | Ferramenta |
|-------------|------------|
| 60 FPS | Flutter DevTools > Performance |
| Memory leaks | Flutter DevTools > Memory |
| Widget rebuilds | `debugPrintRebuildDirtyWidgets = true` |

**Boas práticas:**
- [ ] `const` em widgets estáticos
- [ ] `ListView.builder` para listas longas
- [ ] `buildWhen` em BlocBuilder pesados
- [ ] Imagens otimizadas (WebP, cache)
- [ ] Dispose de subscriptions

---

### QG-10: Code Style

**Critério:** Código segue Effective Dart e convenções do projeto.

```bash
# Verificar formatação
dart format --set-exit-if-changed lib/

# Análise com regras customizadas
flutter analyze
```

| Convenção | Exemplo |
|-----------|---------|
| Classes | `PascalCase` → `RefuelingBloc` |
| Arquivos | `snake_case` → `refueling_bloc.dart` |
| Variáveis | `camelCase` → `refuelingData` |
| Constantes | `camelCase` → `maxRetries` |
| Privados | `_prefixo` → `_repository` |

---

### QG-11: Documentação

**Critério:** Código complexo está documentado.

```dart
/// Processa um abastecimento e retorna o resultado.
///
/// [refuelingId] - ID do abastecimento a processar
///
/// Throws [RefuelingException] se o abastecimento não existir.
///
/// Exemplo:
/// ```dart
/// final result = await processRefueling('ABC123');
/// ```
Future<Either<Failure, Refueling>> call(String refuelingId);
```

| O que documentar | Como |
|------------------|------|
| UseCases públicos | `///` com exemplo |
| Lógica complexa | Comentário explicativo |
| Decisões técnicas | `// DECISION:` |
| TODOs | `// TODO(nome): descrição` |

---

### QG-12: Git e Commits

**Critério:** Commits seguem Conventional Commits e branch está atualizada.

```bash
# Formato do commit
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
| `style` | Formatação (não afeta código) |
| `chore` | Tarefas de manutenção |

**Checklist Git:**
- [ ] Branch atualizada com develop (`git pull origin develop`)
- [ ] Commits atômicos (um propósito por commit)
- [ ] Mensagens descritivas
- [ ] Sem arquivos sensíveis (`.env`, keys)

---

## 📋 Checklist Completo Pré-PR

### 🔴 Críticos (OBRIGATÓRIO)
- [ ] QG-01: `flutter analyze` sem erros
- [ ] QG-01: Build Android OK
- [ ] QG-01: Build iOS OK
- [ ] QG-02: Testes passando
- [ ] QG-02: Cobertura ≥ 60%
- [ ] QG-03: build_runner executado
- [ ] QG-04: Regras RN-XXX implementadas

### 🟡 Importantes (RECOMENDADO)
- [ ] QG-05: Estados com Freezed
- [ ] QG-06: Clean Architecture respeitada
- [ ] QG-07: Erros tratados com feedback
- [ ] QG-08: DI configurada corretamente

### 🟢 Desejáveis (BÔNUS)
- [ ] QG-09: Performance OK
- [ ] QG-10: Código formatado
- [ ] QG-11: Documentação presente
- [ ] QG-12: Commits organizados

---

## 🚨 Ações em Caso de Falha

| Gate | Ação |
|------|------|
| QG-01 Compilação | Corrigir erros, rodar build_runner |
| QG-02 Testes | Escrever testes faltantes |
| QG-03 Build Runner | `dart run build_runner build --delete-conflicting-outputs` |
| QG-04 Regras | Revisar BUSINESS-RULES.md e ajustar código |
| QG-05 BLoC | Refatorar para usar Freezed |
| QG-06 Arquitetura | Mover código para camada correta |
| QG-07 Erros | Adicionar tratamento e feedback |
| QG-08 DI | Adicionar annotations corretas |

---

*Quality Gates v2.0.0 - Janeiro 2026*
