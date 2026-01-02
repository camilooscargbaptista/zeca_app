---
description: Corrigir bug com diagnóstico completo e testes de regressão
---

# /fix-bug - Correção de Bug Flutter

## Pré-requisitos

Informações necessárias:
- Qual é o erro/comportamento incorreto?
- Onde ocorre? (tela, fluxo, funcionalidade)
- Como reproduzir?
- Qual o comportamento esperado?
- Há erro no console/logs?

---

## Steps

### 1. Diagnóstico Inicial

```bash
# Ler lições aprendidas (pode ter solução similar)
cat .context/LESSONS-LEARNED.md

# Verificar se é relacionado a regras de negócio
cat .context/BUSINESS-RULES.md

# Se for erro de API
cat .context/API-CONTRACTS.md
```

### 2. Localizar o Problema

```bash
# Buscar arquivos relacionados ao erro
grep -rn "[termo do erro]" lib/ --include="*.dart" | head -20

# Se for erro em BLoC
find lib -name "*_bloc.dart" | xargs grep -l "[termo]"

# Se for erro em Widget
find lib -name "*_page.dart" -o -name "*_widget.dart" | xargs grep -l "[termo]"

# Se for erro em Model
find lib -name "*_model.dart" | xargs grep -l "[termo]"

# Se for erro de API/Repository
find lib -name "*_repository*.dart" -o -name "*_datasource.dart" | xargs grep -l "[termo]"
```

### 3. Verificar Logs de Erro

```bash
# Se tiver stacktrace, identificar:
# - Arquivo e linha do erro
# - Tipo de exceção
# - Caminho da chamada (call stack)
```

### 4. Identificar Root Cause

Documentar:
- **Arquivo(s) afetado(s):** 
- **Linha(s) do problema:**
- **Causa raiz:**
- **Impacto:**
- **Camada:** Data | Domain | Presentation

### 5. Verificar Testes Existentes

```bash
# Testes do módulo afetado
find test -name "*[modulo]*_test.dart"

# Rodar testes existentes
flutter test test/features/[modulo]/
```

### 6. Criar Teste que Reproduz o Bug

**ANTES de corrigir, criar teste que falha:**

```dart
// Para BLoC
blocTest<NomeBloc, NomeState>(
  'should [comportamento correto] - BUG FIX',
  build: () {
    // Setup que reproduz o bug
    return bloc;
  },
  act: (bloc) => bloc.add(EventQueGeraBug()),
  expect: () => [
    // Estados CORRETOS esperados
  ],
);

// Para Widget
testWidgets('should [comportamento correto] - BUG FIX', (tester) async {
  // Setup que reproduz o bug
  await tester.pumpWidget(/* ... */);
  
  // Ação que causa o bug
  await tester.tap(find.byKey(Key('botao')));
  await tester.pump();
  
  // Verificação do comportamento CORRETO
  expect(find.text('Resultado correto'), findsOneWidget);
});
```

```bash
# Rodar teste - deve FALHAR
flutter test test/features/[modulo]/[arquivo]_test.dart
```

### 7. Implementar Correção

- Fazer a correção mínima necessária
- NÃO refatorar código não relacionado
- NÃO adicionar features novas
- Seguir padrões existentes

```bash
# Após corrigir, rodar teste
flutter test test/features/[modulo]/[arquivo]_test.dart
# Agora deve PASSAR
```

### 8. Se usou Freezed, rodar build_runner

```bash
# Se alterou algum model com @freezed
dart run build_runner build --delete-conflicting-outputs
```

### 9. Testes de Regressão

```bash
# Rodar TODOS os testes do módulo
flutter test test/features/[modulo]/

# Rodar TODOS os testes
flutter test

# Análise estática
flutter analyze
```

### 10. Verificar Fluxos Existentes

Testar manualmente ou via testes:
- [ ] Fluxo principal continua funcionando
- [ ] Fluxos relacionados continuam funcionando
- [ ] Nenhum efeito colateral
- [ ] App não crasha em outros lugares

### 11. Validação Final

```bash
# Análise
flutter analyze

# Testes
flutter test

# Build
flutter build apk --debug
```

### 12. Documentar a Correção

Adicionar em `.context/LESSONS-LEARNED.md`:

```markdown
### LESSON-XXX: [Título do Bug]
- **Data:** YYYY-MM-DD
- **Erro:** [Descrição do problema]
- **Causa:** [Root cause]
- **Solução:** [Como foi corrigido]
- **Prevenção:** [Como evitar no futuro]
```

---

## Tipos Comuns de Bugs Flutter

### BLoC não emitindo estado

```dart
// ❌ Problema: Esqueceu de emitir estado
on<LoadData>((event, emit) async {
  final result = await useCase();
  // Faltou: emit(DataLoaded(result));
});

// ✅ Solução
on<LoadData>((event, emit) async {
  emit(Loading());
  final result = await useCase();
  result.fold(
    (failure) => emit(Error(failure.message)),
    (data) => emit(DataLoaded(data)),
  );
});
```

### Widget não atualizando

```dart
// ❌ Problema: BlocBuilder não está ouvindo corretamente
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    // state sempre o mesmo
  },
)

// ✅ Solução: Verificar se BLoC está fornecido corretamente
BlocProvider(
  create: (context) => getIt<MyBloc>()..add(LoadData()),
  child: BlocBuilder<MyBloc, MyState>(
    builder: (context, state) {
      // ...
    },
  ),
)
```

### Model não parseando JSON

```dart
// ❌ Problema: Nome do campo diferente do JSON
@JsonKey(name: 'user_name') // JSON tem 'userName'
final String userName;

// ✅ Solução: Verificar nome exato no JSON da API
@JsonKey(name: 'userName')
final String userName;

// Rodar build_runner após corrigir
dart run build_runner build --delete-conflicting-outputs
```

### Null Safety

```dart
// ❌ Problema: Null check operator em valor nulo
final name = user!.name; // user é null

// ✅ Solução: Verificar null antes
if (user != null) {
  final name = user.name;
}
// ou
final name = user?.name ?? 'Default';
```

---

## Checklist Final

```
□ Root cause identificada
□ Teste que reproduz o bug criado
□ Teste falhava antes da correção
□ Correção implementada (mínima necessária)
□ build_runner executado (se alterou Freezed)
□ Teste passa após correção
□ Testes de regressão passando
□ flutter analyze sem warnings
□ Fluxos existentes verificados
□ Testado no emulador/dispositivo
□ LESSONS-LEARNED.md atualizado
```
