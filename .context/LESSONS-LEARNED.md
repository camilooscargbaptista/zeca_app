# ZECA App - Lessons Learned

> **⚠️ LEIA ESTE ARQUIVO ANTES DE QUALQUER TAREFA**
> 
> Este arquivo contém erros que já aconteceram e NUNCA devem se repetir.
> Cada lição aqui custou tempo e retrabalho. Aprenda com eles.

---

## 🚨 CRÍTICO - Erros Graves

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
```

**Regra:** Alterou Freezed = rodar build_runner imediatamente.

---

### LESSON-005: BLoC para telas complexas, não setState

**Data:** 2025-12-XX
**Erro:** Usou setState em tela com múltiplos estados e chamadas assíncronas.
**Impacto:** Estado inconsistente, bugs difíceis de reproduzir.

**Causa:** "Parecia simples" mas cresceu em complexidade.

**Solução:**
```dart
// ❌ NUNCA em telas com lógica
setState(() => isLoading = true);

// ✅ SEMPRE usar BLoC
context.read<MyBloc>().add(LoadData());
```

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
```

**Regra:** SEMPRE verificar se o código existe antes de usar.

---

## ⚠️ IMPORTANTE - Erros Frequentes

### LESSON-007: Dispose de subscriptions

**Erro:** StreamSubscription sem cancel no dispose.
**Sintoma:** Memory leak, comportamento estranho.

**Solução:**
```dart
class _MyPageState extends State<MyPage> {
  StreamSubscription? _subscription;
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

---

### LESSON-008: BlocBuilder sem buildWhen

**Erro:** Widget pesado rebuildando em toda mudança de estado.
**Sintoma:** UI lenta, jank.

**Solução:**
```dart
BlocBuilder<MyBloc, MyState>(
  buildWhen: (previous, current) => 
    previous.specificField != current.specificField,
  builder: (context, state) => ExpensiveWidget(),
)
```

---

### LESSON-009: Esquecer estados de UI

**Erro:** Tela sem tratamento de Loading/Error/Empty.
**Sintoma:** Tela em branco, usuário não sabe o que aconteceu.

**Solução:**
```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    if (state is Loading) return LoadingWidget();
    if (state is Error) return ErrorWidget(state.message);
    if (state is Empty) return EmptyWidget();
    if (state is Loaded) return ContentWidget(state.data);
    return SizedBox.shrink();
  },
)
```

---

### LESSON-010: Hardcode de strings

**Erro:** Strings hardcoded espalhadas pelo código.
**Sintoma:** Difícil manutenção, impossível traduzir.

**Solução:**
```dart
// ❌ Ruim
Text('Carregando...')

// ✅ Bom
Text(AppStrings.loading)
```

---

### LESSON-011: Cores fora do tema

**Erro:** Cores hardcoded ao invés de usar Theme.
**Sintoma:** Inconsistência visual, difícil mudar tema.

**Solução:**
```dart
// ❌ Ruim
Container(color: Color(0xFF3F51B5))

// ✅ Bom
Container(color: Theme.of(context).primaryColor)
// ou
Container(color: AppColors.primary)
```

---

### LESSON-012: Model sem null safety adequado

**Erro:** Model com campos required que podem vir null da API.
**Sintoma:** Crash ao parsear JSON.

**Solução:**
```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    String? optionalField,  // Pode ser null
    @Default('') String withDefault,  // Default se null
  }) = _MyModel;
}
```

---

## 📝 BOAS PRÁTICAS Aprendidas

### BP-001: Estrutura consistente de Feature

```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

### BP-002: Nomenclatura de BLoC Events

```dart
// Verbos no infinitivo
class LoadUsers extends UsersEvent {}
class CreateUser extends UsersEvent {}
class DeleteUser extends UsersEvent {}
class RefreshUsers extends UsersEvent {}
```

---

### BP-003: Estados do BLoC

```dart
// Adjetivos/substantivos
class UsersInitial extends UsersState {}
class UsersLoading extends UsersState {}
class UsersLoaded extends UsersState {}
class UsersError extends UsersState {}
class UsersEmpty extends UsersState {}
```

---

### BP-004: Tratamento de Either

```dart
// Sempre usar fold
final result = await useCase(params);

result.fold(
  (failure) => emit(MyError(failure.message)),
  (success) => emit(MyLoaded(success)),
);
```

---

### BP-005: Const widgets

```dart
// Sempre que possível, usar const
return const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Static text'),
);
```

---

## 📊 Métricas de Qualidade

### Meta: Cobertura ≥ 60%

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Meta: Zero warnings no analyze

```bash
flutter analyze
```

### Meta: Código formatado

```bash
dart format lib/
```

---

## 🔄 Como Atualizar Este Arquivo

Quando encontrar um novo problema que custou tempo:

1. Identificar a causa raiz
2. Documentar seguindo o formato:
   - **Data:** YYYY-MM-DD
   - **Erro:** O que aconteceu
   - **Impacto:** Consequência do erro
   - **Causa:** Por que aconteceu
   - **Solução:** Como corrigir/evitar
   - **Regra:** Regra clara para não repetir

3. Adicionar na seção apropriada (CRÍTICO, IMPORTANTE, ou BOAS PRÁTICAS)

---

**Lembre-se:** Cada erro aqui foi real e custou tempo. Não repita os mesmos erros.
