# 🔄 BLOC PATTERNS - ZECA App

> **"Estado previsível, código testável."**

---

## 📊 ESTRUTURA DO BLOC

```
presentation/bloc/
├── nome_bloc.dart       # Lógica
├── nome_event.dart      # Eventos (input)
└── nome_state.dart      # Estados (output)
```

---

## 📥 EVENTS (com Freezed)

### Padrão
```dart
// nome_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nome_event.freezed.dart';

@freezed
class NomeEvent with _$NomeEvent {
  // Carregar dados
  const factory NomeEvent.loadRequested() = _LoadRequested;
  
  // Criar
  const factory NomeEvent.createRequested(CreateNomeParams params) = _CreateRequested;
  
  // Atualizar
  const factory NomeEvent.updateRequested(String id, UpdateNomeParams params) = _UpdateRequested;
  
  // Deletar
  const factory NomeEvent.deleteRequested(String id) = _DeleteRequested;
  
  // Refresh
  const factory NomeEvent.refreshRequested() = _RefreshRequested;
  
  // Busca
  const factory NomeEvent.searchRequested(String query) = _SearchRequested;
  
  // Seleção
  const factory NomeEvent.itemSelected(NomeEntity item) = _ItemSelected;
  
  // Form
  const factory NomeEvent.formSubmitted() = _FormSubmitted;
  const factory NomeEvent.fieldChanged(String field, dynamic value) = _FieldChanged;
}
```

### Nomenclatura de Events
| Ação | Sufixo | Exemplo |
|------|--------|---------|
| Carregar | `Requested` | `loadRequested` |
| Criar | `Requested` | `createRequested` |
| Mudar campo | `Changed` | `fieldChanged` |
| Submeter | `Submitted` | `formSubmitted` |
| Selecionar | `Selected` | `itemSelected` |

---

## 📤 STATES (com Freezed)

### Padrão Simples (Lista)
```dart
// nome_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nome_state.freezed.dart';

@freezed
class NomeState with _$NomeState {
  const factory NomeState.initial() = _Initial;
  const factory NomeState.loading() = _Loading;
  const factory NomeState.loaded(List<NomeEntity> items) = _Loaded;
  const factory NomeState.error(String message) = _Error;
}
```

### Padrão Complexo (Form)
```dart
@freezed
class NomeFormState with _$NomeFormState {
  const factory NomeFormState({
    @Default('') String name,
    @Default('') String description,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
    NomeEntity? createdItem,
  }) = _NomeFormState;
  
  // Getters computados
  const NomeFormState._();
  
  bool get isValid => name.isNotEmpty && name.length >= 3;
  bool get hasError => errorMessage != null;
}
```

### Padrão com Dados Mantidos
```dart
@freezed
class NomeState with _$NomeState {
  const factory NomeState({
    @Default([]) List<NomeEntity> items,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    NomeEntity? selectedItem,
    @Default('') String searchQuery,
  }) = _NomeState;
  
  const NomeState._();
  
  bool get hasItems => items.isNotEmpty;
  bool get hasError => errorMessage != null;
  
  List<NomeEntity> get filteredItems {
    if (searchQuery.isEmpty) return items;
    return items.where((i) => 
      i.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
}
```

---

## ⚙️ BLOC

### Estrutura Básica
```dart
// nome_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NomeBloc extends Bloc<NomeEvent, NomeState> {
  final GetNomeUseCase _getNomeUseCase;
  final CreateNomeUseCase _createNomeUseCase;

  NomeBloc(
    this._getNomeUseCase,
    this._createNomeUseCase,
  ) : super(const NomeState.initial()) {
    on<_LoadRequested>(_onLoadRequested);
    on<_CreateRequested>(_onCreateRequested);
    on<_RefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<NomeState> emit,
  ) async {
    emit(const NomeState.loading());

    final result = await _getNomeUseCase();

    result.fold(
      (failure) => emit(NomeState.error(failure.message)),
      (items) => emit(NomeState.loaded(items)),
    );
  }

  Future<void> _onCreateRequested(
    _CreateRequested event,
    Emitter<NomeState> emit,
  ) async {
    emit(const NomeState.loading());

    final result = await _createNomeUseCase(event.params);

    result.fold(
      (failure) => emit(NomeState.error(failure.message)),
      (_) => add(const NomeEvent.loadRequested()),
    );
  }

  Future<void> _onRefreshRequested(
    _RefreshRequested event,
    Emitter<NomeState> emit,
  ) async {
    // Não emite loading para manter dados na tela
    final result = await _getNomeUseCase();

    result.fold(
      (failure) => emit(NomeState.error(failure.message)),
      (items) => emit(NomeState.loaded(items)),
    );
  }
}
```

### BLoC com Estado Mantido
```dart
@injectable
class NomeBloc extends Bloc<NomeEvent, NomeState> {
  NomeBloc(this._useCase) : super(const NomeState()) {
    on<_LoadRequested>(_onLoadRequested);
    on<_SearchRequested>(_onSearchRequested);
    on<_ItemSelected>(_onItemSelected);
  }

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<NomeState> emit,
  ) async {
    // Mantém dados, muda só isLoading
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _useCase();

    result.fold(
      (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  void _onSearchRequested(
    _SearchRequested event,
    Emitter<NomeState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onItemSelected(
    _ItemSelected event,
    Emitter<NomeState> emit,
  ) {
    emit(state.copyWith(selectedItem: event.item));
  }
}
```

---

## 🎨 USO NA PAGE

### BlocBuilder
```dart
BlocBuilder<NomeBloc, NomeState>(
  builder: (context, state) {
    // Com Freezed union types
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      loaded: (items) => ListView.builder(...),
      error: (message) => Text(message),
    );
  },
)
```

### BlocListener (side effects)
```dart
BlocListener<NomeBloc, NomeState>(
  listener: (context, state) {
    state.whenOrNull(
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  },
  child: ...,
)
```

### BlocConsumer (builder + listener)
```dart
BlocConsumer<NomeBloc, NomeState>(
  listener: (context, state) {
    // Side effects (snackbar, navegação, etc)
  },
  builder: (context, state) {
    // UI
  },
)
```

### Disparar Event
```dart
// Na Page
context.read<NomeBloc>().add(const NomeEvent.loadRequested());

// Com parâmetros
context.read<NomeBloc>().add(NomeEvent.createRequested(params));
```

---

## 💉 INJEÇÃO NO WIDGET

### Com BlocProvider
```dart
class NomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NomeBloc>()..add(const NomeEvent.loadRequested()),
      child: const _NomeView(),
    );
  }
}

class _NomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NomeBloc, NomeState>(...);
  }
}
```

### Múltiplos BLoCs
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => getIt<NomeBloc>()),
    BlocProvider(create: (_) => getIt<OutroBloc>()),
  ],
  child: const _View(),
)
```

---

## 📋 CHECKLIST

```
Novo BLoC:
□ Criar nome_event.dart com @freezed
□ Criar nome_state.dart com @freezed
□ Criar nome_bloc.dart com @injectable
□ Registrar handlers no construtor
□ Injetar UseCases necessários
□ Rodar build_runner
□ Usar BlocProvider na Page
□ Testar todos os estados
```

---

## ⚠️ REGRAS

### ❌ NUNCA
```dart
// ❌ Chamar API diretamente no BLoC
class NomeBloc {
  final Dio dio; // ERRADO! Usar UseCase
}

// ❌ Lógica de UI no BLoC
emit(NomeState.loaded(items, showSnackbar: true)); // ERRADO!

// ❌ State mutável
class NomeState {
  List<Item> items; // ERRADO! Usar final + Freezed
}
```

### ✅ SEMPRE
```dart
// ✅ Usar UseCases
class NomeBloc {
  final GetNomeUseCase _useCase;
}

// ✅ Side effects no Listener
BlocListener(
  listener: (context, state) {
    // Snackbar, navegação aqui
  },
)

// ✅ State imutável com Freezed
@freezed
class NomeState with _$NomeState {
  const factory NomeState.loaded(List<Item> items) = _Loaded;
}
```

---

**EVENTOS ENTRAM, ESTADOS SAEM. SIMPLES ASSIM.**
