# ⚡ Performance Guide - ZECA App

> **Otimização e boas práticas de performance Flutter.**

---

## 🎯 Métricas Alvo

| Métrica | Alvo | Ferramenta |
|---------|------|------------|
| FPS | 60 fps (idealmente) | DevTools Performance |
| Startup Time | < 3 segundos | DevTools Timeline |
| Memory | Sem leaks | DevTools Memory |
| App Size | < 50 MB | `flutter build apk --analyze-size` |

---

## 🔧 Otimizações de Widget

### 1. Use const Sempre que Possível

```dart
// ❌ Ruim - recria a cada build
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Text('Hello'),
  );
}

// ✅ Bom - reusa instância
Widget build(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('Hello'),
  );
}
```

**Impacto:** Reduz até 70% de rebuilds desnecessários.

### 2. buildWhen em BlocBuilder

```dart
// ❌ Ruim - rebuilda em qualquer mudança
BlocBuilder<RefuelingBloc, RefuelingState>(
  builder: (context, state) {
    return ExpensiveWidget(data: state.items);
  },
)

// ✅ Bom - rebuilda só quando necessário
BlocBuilder<RefuelingBloc, RefuelingState>(
  buildWhen: (previous, current) => previous.items != current.items,
  builder: (context, state) {
    return ExpensiveWidget(data: state.items);
  },
)
```

### 3. Extrair Widgets

```dart
// ❌ Ruim - widget tree profunda em um arquivo
Widget build(BuildContext context) {
  return Column(
    children: [
      Container(
        child: Row(
          children: [
            // 100+ linhas de código
          ],
        ),
      ),
    ],
  );
}

// ✅ Bom - componentes extraídos
Widget build(BuildContext context) {
  return Column(
    children: const [
      _Header(),
      _Content(),
      _Footer(),
    ],
  );
}
```

---

## 📋 Otimizações de Lista

### 1. ListView.builder para Listas Grandes

```dart
// ❌ Ruim - cria todos os itens de uma vez
ListView(
  children: items.map((item) => ItemCard(item: item)).toList(),
)

// ✅ Bom - cria sob demanda
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)
```

**Regra:** Use `.builder` para listas com mais de 10-20 itens.

### 2. Use Keys para Listas Dinâmicas

```dart
// ❌ Ruim - pode causar bugs de estado
ListView.builder(
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)

// ✅ Bom - mantém estado correto ao reordenar
ListView.builder(
  itemBuilder: (context, index) => ItemCard(
    key: ValueKey(items[index].id),
    item: items[index],
  ),
)
```

### 3. itemExtent para Performance

```dart
// ✅ Quando itens têm altura fixa
ListView.builder(
  itemExtent: 72, // Altura fixa
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)
```

---

## 🖼️ Otimizações de Imagem

### 1. CachedNetworkImage

```dart
// ❌ Ruim - sem cache
Image.network(url)

// ✅ Bom - com cache e placeholder
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => const ShimmerPlaceholder(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheWidth: 300, // Limita resolução em memória
)
```

### 2. Imagens Otimizadas

```dart
// Usar formato WebP quando possível
// assets/images/logo.webp ao invés de logo.png

// Especificar tamanho máximo
Image.asset(
  'assets/images/logo.webp',
  width: 200,
  height: 200,
  cacheWidth: 400, // 2x para telas retina
  cacheHeight: 400,
)
```

### 3. Precache Imagens Críticas

```dart
// No initState ou didChangeDependencies
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(
    const AssetImage('assets/images/logo.webp'),
    context,
  );
}
```

---

## 🔄 Otimizações de Estado

### 1. Getters Computados no State

```dart
// ❌ Ruim - computa no build
Widget build(BuildContext context) {
  final filtered = items.where((i) => i.active).toList();
  final sorted = filtered..sort((a, b) => a.date.compareTo(b.date));
  return ListView(...);
}

// ✅ Bom - getter no state
@freezed
class MyState with _$MyState {
  const factory MyState({
    @Default([]) List<Item> items,
  }) = _MyState;

  const MyState._();

  List<Item> get activeItems => items
      .where((i) => i.active)
      .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
}

// No build
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: state.activeItems.length,
    itemBuilder: ...
  );
}
```

### 2. Memoização para Cálculos Pesados

```dart
// Para cálculos muito pesados, use computed/memoized
import 'package:collection/collection.dart';

final groupedByDate = items.groupListsBy((i) => i.date.day);
```

---

## 🧹 Memory Management

### 1. Dispose Controllers

```dart
class _MyPageState extends State<MyPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
```

### 2. Dispose AnimationController

```dart
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
```

### 3. Cancel Async Operations

```dart
class _MyPageState extends State<MyPage> {
  bool _mounted = true;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await api.getData();
    if (_mounted) {
      setState(() => _data = data);
    }
  }
}
```

---

## 📱 Build Otimizações

### 1. Evitar Lógica Pesada no build()

```dart
// ❌ Ruim
Widget build(BuildContext context) {
  // Processamento pesado aqui
  final processed = heavyProcessing(data);
  return ListView(...);
}

// ✅ Bom - processar no BLoC/State
class MyBloc extends Bloc<MyEvent, MyState> {
  void _onDataLoaded(DataLoaded event, Emitter<MyState> emit) {
    final processed = heavyProcessing(event.data);
    emit(state.copyWith(processedData: processed));
  }
}
```

### 2. Evitar setState em Loop

```dart
// ❌ Ruim - múltiplos rebuilds
for (final item in items) {
  setState(() => _list.add(item));
}

// ✅ Bom - um único rebuild
setState(() {
  _list.addAll(items);
});
```

---

## 🔍 Profiling

### DevTools Commands

```bash
# Abrir DevTools
flutter run --profile
# Pressione 'd' no terminal

# Build com análise de tamanho
flutter build apk --analyze-size
```

### Debug Rebuilds

```dart
// Em main.dart (apenas debug)
import 'package:flutter/rendering.dart';

void main() {
  debugPrintRebuildDirtyWidgets = true; // Ver rebuilds
  debugProfileBuildsEnabled = true;     // Profile builds
  runApp(const MyApp());
}
```

### Checklist de Performance

```
□ const em widgets estáticos
□ buildWhen em BlocBuilder pesados
□ ListView.builder para listas grandes
□ Keys em listas dinâmicas
□ CachedNetworkImage para imagens
□ Dispose em todos os controllers
□ Sem lógica pesada no build()
□ setState único (não em loop)
□ Imagens otimizadas (WebP, tamanho adequado)
□ Profile com DevTools
```

---

## 📊 Benchmark

### Medir Tempo de Operação

```dart
import 'dart:developer';

void measureOperation() {
  final stopwatch = Stopwatch()..start();

  // Operação a medir
  heavyOperation();

  stopwatch.stop();
  log('Operation took: ${stopwatch.elapsedMilliseconds}ms');
}
```

### Timeline Events

```dart
import 'dart:developer';

Future<void> loadData() async {
  Timeline.startSync('loadData');
  try {
    await _fetchData();
  } finally {
    Timeline.finishSync();
  }
}
```

---

*Performance Guide v2.0.0 - Janeiro 2026*
