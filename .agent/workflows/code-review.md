---
antigravity:
  trigger: "manual"
  description: "Revisar código Flutter e sugerir melhorias"
---


# /code-review - Revisão de Código Flutter

## Pré-requisitos

Informar:
- Qual arquivo/módulo revisar?
- Foco específico? (performance, padrões, testes, todos)

---

## Steps

### 1. Identificar Arquivos

```bash
# Localizar arquivo(s)
find lib -name "*[nome]*" -type f | grep "\.dart$"

# Ler conteúdo
cat [caminho/do/arquivo]
```

### 2. Verificar Padrões do Projeto

```bash
# Ler arquitetura
cat .context/ARCHITECTURE.md

# Ler lições aprendidas
cat .context/LESSONS-LEARNED.md
```

---

## Checklist de Revisão

### 🏗️ Clean Architecture

```
□ Camadas separadas corretamente (data/domain/presentation)
□ Dependências apontam para dentro (presentation → domain ← data)
□ Entities não dependem de Models
□ UseCases têm responsabilidade única
□ Repository abstrato no Domain, implementação no Data
□ BLoC não conhece DataSource diretamente
```

### 📦 BLoC Pattern

```
□ Estados são imutáveis (Equatable ou Freezed)
□ Eventos descrevem ações do usuário
□ Sem lógica de negócio no Widget
□ Emit chamado para cada mudança de estado
□ BLoC fechado no dispose
□ Usando BlocBuilder/BlocListener corretamente
```

### 📝 Qualidade de Código

```
□ Código legível e autoexplicativo
□ Funções pequenas (< 30 linhas)
□ Sem código duplicado (DRY)
□ Sem código morto / comentado
□ Tratamento de erros adequado
□ Null safety respeitado
□ Tipos explícitos onde necessário
□ Sem 'dynamic' desnecessário
□ Sem 'as' cast desnecessário
```

### 🎨 UI/UX

```
□ Estados implementados (loading, error, empty, success)
□ Feedback visual para ações do usuário
□ Cores do tema (não hardcoded)
□ Strings centralizadas (não hardcoded)
□ Responsividade considerada
□ Acessibilidade (semantics)
□ Animações suaves
```

### ⚡ Performance

```
□ Widgets const onde possível
□ Keys em listas/grids
□ ListView.builder para listas longas
□ Imagens otimizadas (cache, resize)
□ Sem rebuilds desnecessários
□ BlocBuilder com buildWhen
□ Sem operações pesadas no build()
□ Dispose de controllers/streams
```

### 🔒 Segurança

```
□ Tokens não hardcoded
□ Dados sensíveis não em logs
□ Validação de inputs
□ HTTPS para todas as chamadas
□ Certificados validados
□ Secure storage para dados sensíveis
```

### 🧪 Testabilidade

```
□ Dependências injetadas (não instanciadas)
□ Código testável (funções puras quando possível)
□ Mocks possíveis para dependências
□ Testes existem
□ Cobertura adequada (≥60%)
```

---

## Formato do Relatório

### Resumo
- **Arquivo(s) revisado(s):** 
- **Linhas de código:** 
- **Camada:** Data | Domain | Presentation
- **Complexidade geral:** Baixa / Média / Alta
- **Score geral:** X/10

### Issues Encontradas

#### 🔴 Crítico (deve corrigir)
| Linha | Issue | Sugestão |
|-------|-------|----------|
| XX | [Descrição] | [Como corrigir] |

#### 🟡 Importante (deveria corrigir)
| Linha | Issue | Sugestão |
|-------|-------|----------|
| XX | [Descrição] | [Como corrigir] |

#### 🟢 Sugestão (pode melhorar)
| Linha | Issue | Sugestão |
|-------|-------|----------|
| XX | [Descrição] | [Como corrigir] |

### Pontos Positivos
- [O que está bem feito]
- [Boas práticas observadas]

### Recomendações Gerais
1. [Recomendação 1]
2. [Recomendação 2]

---

## Exemplos de Issues Comuns

### BLoC

```dart
// ❌ RUIM - Estado mutável
class MyState {
  List<Item> items = []; // Mutável!
}

// ✅ BOM - Estado imutável
class MyState extends Equatable {
  final List<Item> items;
  const MyState(this.items);
  
  @override
  List<Object?> get props => [items];
}
```

```dart
// ❌ RUIM - Lógica no Widget
onPressed: () async {
  final response = await api.getData();
  setState(() => data = response);
}

// ✅ BOM - Lógica no BLoC
onPressed: () => context.read<MyBloc>().add(LoadData())
```

### Performance

```dart
// ❌ RUIM - Rebuilds desnecessários
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    return ExpensiveWidget(); // Rebuild sempre
  },
)

// ✅ BOM - Rebuild condicional
BlocBuilder<MyBloc, MyState>(
  buildWhen: (previous, current) => previous.items != current.items,
  builder: (context, state) {
    return ExpensiveWidget();
  },
)
```

```dart
// ❌ RUIM - Sem const
return Container(
  child: Text('Hello'),
);

// ✅ BOM - Com const
return const Text('Hello');
```

### Null Safety

```dart
// ❌ RUIM - Null check forçado perigoso
final name = user!.name; // Pode crashar

// ✅ BOM - Null check seguro
final name = user?.name ?? 'Unknown';

// Ou com verificação
if (user != null) {
  final name = user.name;
}
```

### Clean Architecture

```dart
// ❌ RUIM - BLoC conhece DataSource
class MyBloc {
  final MyRemoteDataSource dataSource; // Errado!
}

// ✅ BOM - BLoC conhece apenas UseCase
class MyBloc {
  final GetDataUseCase getDataUseCase; // Correto!
}
```

### Memory Leaks

```dart
// ❌ RUIM - Subscription sem dispose
class _MyState extends State<MyWidget> {
  StreamSubscription? subscription;
  
  @override
  void initState() {
    subscription = stream.listen((data) {});
    // Esqueceu do dispose!
  }
}

// ✅ BOM - Com dispose
@override
void dispose() {
  subscription?.cancel();
  super.dispose();
}
```

---

## Comandos de Verificação

```bash
# Análise estática
flutter analyze

# Formatação
dart format lib/

# Verificar imports não usados
dart fix --dry-run

# Aplicar fixes automáticos
dart fix --apply

# Testes
flutter test

# Cobertura
flutter test --coverage
```

---

## Após Revisão

Se encontrar issues críticas ou importantes:
1. Criar lista de correções priorizadas
2. Executar correções
3. Rodar testes
4. Nova revisão rápida

```bash
# Verificar se correções não quebraram nada
flutter analyze
flutter test
flutter build apk --debug
```
