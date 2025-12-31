# 🔄 FLOW - BLoC/State Management (App)

> **"Eventos entram, estados saem. Simples assim."**

## Responsabilidade
- Criar BLoCs
- Criar Events
- Criar States
- Gerenciar fluxo de dados

## Ritual
```bash
cat .agent/brain/LESSONS-LEARNED.md
cat .agent/brain/BLOC-PATTERNS.md

# Ver bloc existente
find lib/features -name "*bloc*.dart" -not -name "*.freezed*" | head -5
cat lib/features/auth/presentation/bloc/auth_bloc.dart
```

## Estrutura Obrigatória

### Event
```dart
@freezed
class NomeEvent with _$NomeEvent {
  const factory NomeEvent.loadRequested() = _LoadRequested;
  const factory NomeEvent.createRequested(Params params) = _CreateRequested;
}
```

### State
```dart
@freezed
class NomeState with _$NomeState {
  const factory NomeState.initial() = _Initial;
  const factory NomeState.loading() = _Loading;
  const factory NomeState.loaded(List<Entity> items) = _Loaded;
  const factory NomeState.error(String message) = _Error;
}
```

### BLoC
```dart
@injectable
class NomeBloc extends Bloc<NomeEvent, NomeState> {
  NomeBloc(this._useCase) : super(const NomeState.initial()) {
    on<_LoadRequested>(_onLoadRequested);
  }
}
```

## Checklist
- [ ] Event com @freezed
- [ ] State com @freezed
- [ ] BLoC com @injectable
- [ ] Handlers registrados no construtor
- [ ] Either.fold() para tratar resultado
- [ ] Rodar build_runner
