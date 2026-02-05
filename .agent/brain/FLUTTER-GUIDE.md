---
antigravity:
  trigger: "always_on"
  globs: ["**/*.dart"]
  description: "Guia Flutter - padrões obrigatórios do projeto"
---


# 📱 FLUTTER GUIDE - Guia Completo ZECA App

> **"Código Flutter de qualidade espacial."**

---

## 📚 ÍNDICE

1. [Estrutura de Feature](#estrutura-de-feature)
2. [Data Layer](#data-layer)
3. [Domain Layer](#domain-layer)
4. [Presentation Layer](#presentation-layer)
5. [BLoC Pattern](#bloc-pattern)
6. [Dependency Injection](#dependency-injection)
7. [Navegação](#navegação)
8. [Widgets](#widgets)

---

## 🏗️ ESTRUTURA DE FEATURE

### Criar Nova Feature
```bash
# 1. Criar estrutura de pastas
mkdir -p lib/features/nome_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}

# 2. Após criar arquivos freezed
dart run build_runner build --delete-conflicting-outputs
```

### Estrutura Completa
```
lib/features/nome_feature/
├── data/
│   ├── datasources/
│   │   ├── nome_remote_datasource.dart
│   │   └── nome_local_datasource.dart
│   ├── models/
│   │   ├── nome_model.dart
│   │   ├── nome_model.freezed.dart
│   │   └── nome_model.g.dart
│   └── repositories/
│       └── nome_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── nome_entity.dart
│   ├── repositories/
│   │   └── nome_repository.dart
│   └── usecases/
│       ├── get_nome_usecase.dart
│       └── create_nome_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── nome_bloc.dart
    │   ├── nome_event.dart
    │   └── nome_state.dart
    ├── pages/
    │   └── nome_page.dart
    └── widgets/
        └── nome_item_widget.dart
```

---

## 📊 DATA LAYER

### Model com Freezed
```dart
// nome_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nome_model.freezed.dart';
part 'nome_model.g.dart';

@freezed
class NomeModel with _$NomeModel {
  const factory NomeModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default(false) bool isActive,
  }) = _NomeModel;

  factory NomeModel.fromJson(Map<String, dynamic> json) =>
      _$NomeModelFromJson(json);
}
```

### Remote DataSource com Retrofit
```dart
// nome_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'nome_remote_datasource.g.dart';

@RestApi()
@injectable
abstract class NomeRemoteDataSource {
  @factoryMethod
  factory NomeRemoteDataSource(Dio dio) = _NomeRemoteDataSource;

  @GET('/nome')
  Future<List<NomeModel>> getAll();

  @GET('/nome/{id}')
  Future<NomeModel> getById(@Path('id') String id);

  @POST('/nome')
  Future<NomeModel> create(@Body() Map<String, dynamic> data);

  @PUT('/nome/{id}')
  Future<NomeModel> update(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/nome/{id}')
  Future<void> delete(@Path('id') String id);
}
```

### Repository Implementation
```dart
// nome_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

@Injectable(as: NomeRepository)
class NomeRepositoryImpl implements NomeRepository {
  final NomeRemoteDataSource _remoteDataSource;

  NomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NomeEntity>>> getAll() async {
    try {
      final models = await _remoteDataSource.getAll();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erro de servidor'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NomeEntity>> create(CreateNomeParams params) async {
    try {
      final model = await _remoteDataSource.create(params.toJson());
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erro ao criar'));
    }
  }
}
```

---

## 🎯 DOMAIN LAYER

### Entity
```dart
// nome_entity.dart
import 'package:equatable/equatable.dart';

class NomeEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final bool isActive;

  const NomeEntity({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt, isActive];
}
```

### Repository Interface
```dart
// nome_repository.dart
import 'package:dartz/dartz.dart';

abstract class NomeRepository {
  Future<Either<Failure, List<NomeEntity>>> getAll();
  Future<Either<Failure, NomeEntity>> getById(String id);
  Future<Either<Failure, NomeEntity>> create(CreateNomeParams params);
  Future<Either<Failure, NomeEntity>> update(String id, UpdateNomeParams params);
  Future<Either<Failure, void>> delete(String id);
}
```

### UseCase
```dart
// get_nome_usecase.dart
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

@injectable
class GetNomeUseCase {
  final NomeRepository _repository;

  GetNomeUseCase(this._repository);

  Future<Either<Failure, List<NomeEntity>>> call() {
    return _repository.getAll();
  }
}

// create_nome_usecase.dart
@injectable
class CreateNomeUseCase {
  final NomeRepository _repository;

  CreateNomeUseCase(this._repository);

  Future<Either<Failure, NomeEntity>> call(CreateNomeParams params) {
    return _repository.create(params);
  }
}

// Params
class CreateNomeParams {
  final String name;
  final String? description;

  CreateNomeParams({required this.name, this.description});

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null) 'description': description,
  };
}
```

---

## 🎨 PRESENTATION LAYER

### Page
```dart
// nome_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NomePage extends StatelessWidget {
  const NomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NomeBloc>()..add(const NomeEvent.loadRequested()),
      child: const _NomeView(),
    );
  }
}

class _NomeView extends StatelessWidget {
  const _NomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nome')),
      body: BlocBuilder<NomeBloc, NomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (items) => _buildList(items),
            error: (message) => _buildError(context, message),
          );
        },
      ),
    );
  }

  Widget _buildList(List<NomeEntity> items) {
    if (items.isEmpty) {
      return const Center(child: Text('Nenhum item encontrado'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => NomeItemWidget(item: items[index]),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<NomeBloc>().add(
              const NomeEvent.loadRequested(),
            ),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔄 BLOC PATTERN

### Event (com Freezed)
```dart
// nome_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nome_event.freezed.dart';

@freezed
class NomeEvent with _$NomeEvent {
  const factory NomeEvent.loadRequested() = _LoadRequested;
  const factory NomeEvent.createRequested(CreateNomeParams params) = _CreateRequested;
  const factory NomeEvent.deleteRequested(String id) = _DeleteRequested;
  const factory NomeEvent.refreshRequested() = _RefreshRequested;
}
```

### State (com Freezed)
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

### BLoC
```dart
// nome_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NomeBloc extends Bloc<NomeEvent, NomeState> {
  final GetNomeUseCase _getNomeUseCase;
  final CreateNomeUseCase _createNomeUseCase;

  NomeBloc(this._getNomeUseCase, this._createNomeUseCase)
      : super(const NomeState.initial()) {
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
      (_) => add(const NomeEvent.loadRequested()), // Reload após criar
    );
  }

  Future<void> _onRefreshRequested(
    _RefreshRequested event,
    Emitter<NomeState> emit,
  ) async {
    add(const NomeEvent.loadRequested());
  }
}
```

---

## 💉 DEPENDENCY INJECTION

### Registrar no get_it
```dart
// Em lib/core/di/injection.dart ou arquivo específico da feature

@module
abstract class NomeModule {
  // DataSource já é registrado via @injectable no próprio arquivo

  // Repository é registrado via @Injectable(as: NomeRepository)

  // UseCase é registrado via @injectable

  // BLoC é registrado via @injectable
}
```

### Após criar novos arquivos injectable
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🛤️ NAVEGAÇÃO

### Adicionar Rota
```dart
// Em lib/routes/app_router.dart

GoRoute(
  path: '/nome',
  name: 'nome',
  builder: (context, state) => const NomePage(),
),

GoRoute(
  path: '/nome/:id',
  name: 'nome-detail',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return NomeDetailPage(id: id);
  },
),
```

### Navegar
```dart
// Push
context.push('/nome');

// Go (substitui)
context.go('/nome');

// Com parâmetros
context.push('/nome/$id');

// Pop
context.pop();
```

---

## 🧩 WIDGETS

### Widget Reutilizável
```dart
// nome_item_widget.dart
class NomeItemWidget extends StatelessWidget {
  final NomeEntity item;
  final VoidCallback? onTap;

  const NomeItemWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: item.description != null ? Text(item.description!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
```

---

## 📋 CHECKLIST NOVA FEATURE

```
□ Criar estrutura de pastas
□ Criar Model com Freezed
□ Criar Remote DataSource com Retrofit
□ Criar Entity
□ Criar Repository Interface
□ Criar Repository Implementation
□ Criar UseCase(s)
□ Criar BLoC Event com Freezed
□ Criar BLoC State com Freezed
□ Criar BLoC
□ Criar Page
□ Criar Widget(s)
□ Registrar rota no GoRouter
□ Rodar build_runner
□ Testar fluxo completo
```

---

## 🔧 COMANDOS ÚTEIS

```bash
# Gerar código Freezed/Retrofit
dart run build_runner build --delete-conflicting-outputs

# Watch mode (gera automaticamente)
dart run build_runner watch --delete-conflicting-outputs

# Limpar e regenerar
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# Analisar código
flutter analyze

# Formatar código
dart format lib/
```

---

**CONSULTAR ESTE GUIA ANTES DE CRIAR CÓDIGO FLUTTER.**
