# 📐 Padrões e Boas Práticas - ZECA App

Este documento reúne todos os padrões de código, testes e UI/UX do projeto mobile.

---

## 📚 Índice de Padrões

### **1. Arquitetura**
→ Ver [../architecture/README.md](../architecture/README.md)
- Clean Architecture (data/domain/presentation)
- BLoC Pattern
- Dependency Injection (GetIt + Injectable)

### **2. Decisões Técnicas (ADRs)**
→ Ver [../decisions/](../decisions/)
- ADR-001: Clean Architecture + BLoC
- ADR-002: GetIt + Injectable
- ADR-003: flutter_background_geolocation
- ADR-004: Google ML Kit OCR

### **3. Código Flutter/Dart**
→ Este documento (seções abaixo)

### **4. Testes**
→ Ver seção "Estratégia de Testes" abaixo

### **5. UI/UX Mobile**
→ Ver seção "Padrões de UI/UX" abaixo

---

## 🎨 Padrões de Código Flutter/Dart

### **Nomenclatura**

```dart
// ✅ Classes: PascalCase
class VehicleBloc extends Bloc {}
class RefuelingModel {}

// ✅ Variáveis/Funções: camelCase
final vehicleBloc = VehicleBloc();
void fetchVehicles() {}

// ✅ Constantes: SCREAMING_SNAKE_CASE
const API_TIMEOUT = Duration(seconds: 30);
const MAX_RETRY_ATTEMPTS = 3;

// ✅ Arquivos: snake_case
vehicle_bloc.dart
refueling_model.dart
home_page.dart

// ✅ Privados: _ prefix
class _HomePageState extends State<HomePage> {}
final _controller = TextEditingController();
void _onSubmit() {}
```

### **Estrutura de Feature**

```dart
// ✅ SEMPRE seguir Clean Architecture
lib/features/nome_feature/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_datasource.dart
│   │   └── feature_local_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
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
        └── feature_widget.dart
```

### **BLoC Pattern**

```dart
// ✅ BOM: Separar em arquivos
// feature_event.dart
abstract class FeatureEvent extends Equatable {}
class FetchFeature extends FeatureEvent {}
class CreateFeature extends FeatureEvent {
  final String data;
  CreateFeature(this.data);
  @override
  List<Object> get props => [data];
}

// feature_state.dart
abstract class FeatureState extends Equatable {}
class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final List<FeatureEntity> items;
  FeatureLoaded(this.items);
  @override
  List<Object> get props => [items];
}
class FeatureError extends FeatureState {
  final String message;
  FeatureError(this.message);
  @override
  List<Object> get props => [message];
}

// feature_bloc.dart
@injectable
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final GetFeatureUseCase getFeatureUseCase;
  
  FeatureBloc(this.getFeatureUseCase) : super(FeatureInitial()) {
    on<FetchFeature>(_onFetch);
    on<CreateFeature>(_onCreate);
  }
  
  Future<void> _onFetch(
    FetchFeature event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());
    
    final result = await getFeatureUseCase.execute();
    
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(data)),
    );
  }
  
  Future<void> _onCreate(
    CreateFeature event,
    Emitter<FeatureState> emit,
  ) async {
    // Implementação
  }
}
```

### **Widgets**

```dart
// ✅ BOM: StatelessWidget quando possível
class FeatureCard extends StatelessWidget {
  final FeatureEntity feature;
  final VoidCallback onTap;
  
  const FeatureCard({
    Key? key,
    required this.feature,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(feature.name),
        onTap: onTap,
      ),
    );
  }
}

// ✅ BOM: Extract widgets complexos
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _buildBody(), // ✅ Extract método
    );
  }
  
  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) return _buildLoading();
        if (state is HomeError) return _buildError(state.message);
        if (state is HomeLoaded) return _buildList(state.items);
        return Container();
      },
    );
  }
  
  Widget _buildLoading() => Center(child: CircularProgressIndicator());
  Widget _buildError(String message) => Center(child: Text('Erro: $message'));
  Widget _buildList(List items) => ListView.builder(...);
}

// ❌ RUIM: Widget gigante monolítico
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(...),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // 500 linhas de código aqui...
        },
      ),
    );
  }
}
```

### **Error Handling**

```dart
// ✅ BOM: Usar Either (dartz) para error handling
import 'package:dartz/dartz.dart';

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

// Repository
Future<Either<Failure, Vehicle>> getVehicle(String plate) async {
  try {
    final vehicle = await remoteDataSource.getVehicle(plate);
    return Right(vehicle.toEntity());
  } on ServerException {
    return Left(ServerFailure('Erro ao buscar veículo'));
  } catch (e) {
    return Left(CacheFailure('Erro inesperado'));
  }
}

// BLoC
result.fold(
  (failure) => emit(FeatureError(failure.message)),
  (data) => emit(FeatureLoaded(data)),
);
```

### **Async/Await**

```dart
// ✅ BOM: Sempre usar try-catch em async
Future<void> fetchData() async {
  try {
    final data = await apiService.getData();
    // Processar data
  } catch (e) {
    print('Erro: $e');
    rethrow; // Ou tratar apropriadamente
  }
}

// ✅ BOM: Usar FutureBuilder para async UI
FutureBuilder<Vehicle>(
  future: getVehicle(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Erro: ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return Text('Nenhum dado');
    }
    return Text(snapshot.data!.name);
  },
)
```

### **Dispose & Cleanup**

```dart
// ✅ BOM: Sempre dispose de controllers/streams
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

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
  
  @override
  Widget build(BuildContext context) {
    // Build
  }
}
```

### **Dependency Injection**

```dart
// ✅ BOM: Usar GetIt + Injectable
@injectable
class VehicleBloc extends Bloc {
  final GetVehicleUseCase getVehicleUseCase;
  
  VehicleBloc(this.getVehicleUseCase) : super(VehicleInitial());
}

// Widget
BlocProvider(
  create: (_) => getIt<VehicleBloc>()..add(FetchVehicle()),
  child: VehiclePage(),
)

// ❌ RUIM: Criar manualmente
BlocProvider(
  create: (_) => VehicleBloc(
    GetVehicleUseCase(
      VehicleRepositoryImpl(
        VehicleRemoteDataSource(),
      ),
    ),
  ),
  child: VehiclePage(),
)
```

---

## 🧪 Estratégia de Testes

### **Pirâmide de Testes**

```
        /\
       /  \
      / E2E \          <- Poucos (5-10)
     /______\
    /        \
   / Widget  \         <- Alguns (20-30)
  /__________\
 /            \
/  Unit Tests \        <- Muitos (50-100)
/______________\
```

### **Unit Tests (Domain + Data)**

```dart
// test/domain/usecases/get_vehicle_test.dart

void main() {
  late GetVehicleUseCase useCase;
  late MockVehicleRepository mockRepo;
  
  setUp(() {
    mockRepo = MockVehicleRepository();
    useCase = GetVehicleUseCase(mockRepo);
  });
  
  group('GetVehicleUseCase', () {
    final tPlate = 'ABC1234';
    final tVehicle = Vehicle(id: '1', plate: tPlate);
    
    test('should return vehicle when repository succeeds', () async {
      // Arrange
      when(mockRepo.getVehicleByPlate(tPlate))
          .thenAnswer((_) async => Right(tVehicle));
      
      // Act
      final result = await useCase.execute(tPlate);
      
      // Assert
      expect(result, Right(tVehicle));
      verify(mockRepo.getVehicleByPlate(tPlate)).called(1);
    });
    
    test('should return failure when repository fails', () async {
      // Arrange
      when(mockRepo.getVehicleByPlate(tPlate))
          .thenAnswer((_) async => Left(ServerFailure('Error')));
      
      // Act
      final result = await useCase.execute(tPlate);
      
      // Assert
      expect(result, Left(ServerFailure('Error')));
    });
  });
}
```

### **BLoC Tests**

```dart
// test/presentation/bloc/vehicle_bloc_test.dart

void main() {
  late VehicleBloc bloc;
  late MockGetVehicleUseCase mockUseCase;
  
  setUp(() {
    mockUseCase = MockGetVehicleUseCase();
    bloc = VehicleBloc(mockUseCase);
  });
  
  tearDown(() {
    bloc.close();
  });
  
  group('FetchVehicle', () {
    final tPlate = 'ABC1234';
    final tVehicle = Vehicle(id: '1', plate: tPlate);
    
    blocTest<VehicleBloc, VehicleState>(
      'should emit [Loading, Loaded] when successful',
      build: () {
        when(mockUseCase.execute(tPlate))
            .thenAnswer((_) async => Right(tVehicle));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchVehicle(tPlate)),
      expect: () => [
        VehicleLoading(),
        VehicleLoaded(tVehicle),
      ],
      verify: (_) {
        verify(mockUseCase.execute(tPlate)).called(1);
      },
    );
    
    blocTest<VehicleBloc, VehicleState>(
      'should emit [Loading, Error] when fails',
      build: () {
        when(mockUseCase.execute(tPlate))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchVehicle(tPlate)),
      expect: () => [
        VehicleLoading(),
        VehicleError('Error'),
      ],
    );
  });
}
```

### **Widget Tests**

```dart
// test/presentation/widgets/vehicle_card_test.dart

void main() {
  testWidgets('VehicleCard displays vehicle info', (tester) async {
    // Arrange
    final vehicle = Vehicle(
      id: '1',
      plate: 'ABC1234',
      model: 'Truck',
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleCard(vehicle: vehicle),
        ),
      ),
    );
    
    // Assert
    expect(find.text('ABC1234'), findsOneWidget);
    expect(find.text('Truck'), findsOneWidget);
  });
  
  testWidgets('VehicleCard calls onTap when tapped', (tester) async {
    // Arrange
    bool tapped = false;
    final vehicle = Vehicle(id: '1', plate: 'ABC1234');
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleCard(
            vehicle: vehicle,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    
    await tester.tap(find.byType(VehicleCard));
    await tester.pump();
    
    // Assert
    expect(tapped, true);
  });
}
```

### **Integration Tests**

```dart
// integration_test/app_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('complete refueling flow', (tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());
    
    // Act & Assert
    // 1. Login
    await tester.enterText(find.byKey(Key('cpf_field')), '12345678900');
    await tester.enterText(find.byKey(Key('password_field')), 'senha123');
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();
    
    expect(find.text('Home'), findsOneWidget);
    
    // 2. Search vehicle
    await tester.enterText(find.byKey(Key('plate_field')), 'ABC1234');
    await tester.tap(find.byKey(Key('search_button')));
    await tester.pumpAndSettle();
    
    expect(find.text('Veículo encontrado'), findsOneWidget);
    
    // 3. Generate code
    await tester.tap(find.byKey(Key('generate_code_button')));
    await tester.pumpAndSettle();
    
    expect(find.byKey(Key('qr_code')), findsOneWidget);
  });
}
```

---

## 🎨 Padrões de UI/UX Mobile

### **Design System**

#### Cores (theme/app_colors.dart):
```dart
class AppColors {
  static const primary = Color(0xFF00A859);      // Verde principal
  static const secondary = Color(0xFF2C3E50);    // Cinza escuro
  static const error = Color(0xFFE74C3C);        // Vermelho erro
  static const success = Color(0xFF27AE60);      // Verde sucesso
  static const warning = Color(0xFFF39C12);      // Amarelo aviso
  
  // Grayscale
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFE0E0E0);
  static const gray300 = Color(0xFFBDBDBD);
  // ...
}
```

#### Espaçamentos:
```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}
```

#### Tipografia:
```dart
class AppTextStyles {
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  // ...
}
```

### **Componentes Reutilizáveis**

✅ **SEMPRE** usar componentes da pasta `shared/widgets/`:

```dart
// Botões
CustomButton(
  text: 'Confirmar',
  onPressed: () {},
  variant: ButtonVariant.primary,
)

// Inputs
CustomTextField(
  label: 'Placa',
  hint: 'ABC-1234',
  validator: Validators.plate,
)

// Loading
LoadingOverlay(
  isLoading: state is Loading,
  child: Content(),
)

// Dialogs
ErrorDialog.show(context, 'Mensagem de erro');
SuccessDialog.show(context, 'Sucesso!');
```

### **Responsividade**

```dart
// ✅ BOM: Usar MediaQuery
final screenWidth = MediaQuery.of(context).size.width;
final isTablet = screenWidth > 600;

// ✅ BOM: LayoutBuilder para UI adaptativa
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return TabletLayout();
    }
    return MobileLayout();
  },
)
```

### **Loading States**

```dart
// ✅ BOM: Sempre mostrar feedback
if (state is Loading) {
  return Center(child: CircularProgressIndicator());
}

// ✅ BOM: Skeleton screens para listas
if (state is Loading) {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (_, __) => ShimmerCard(),
  );
}
```

### **Error States**

```dart
// ✅ BOM: Mensagens de erro claras
if (state is Error) {
  return Column(
    children: [
      Icon(Icons.error_outline, size: 64, color: Colors.red),
      SizedBox(height: 16),
      Text(
        state.message,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      ElevatedButton(
        onPressed: retry,
        child: Text('Tentar Novamente'),
      ),
    ],
  );
}
```

### **Empty States**

```dart
// ✅ BOM: Empty states informativos
if (items.isEmpty) {
  return Column(
    children: [
      Image.asset('assets/empty_state.png'),
      SizedBox(height: 16),
      Text(
        'Nenhum item encontrado',
        style: AppTextStyles.h3,
      ),
      SizedBox(height: 8),
      Text(
        'Adicione um novo item para começar',
        style: AppTextStyles.body2,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
```

---

## 📋 Checklist de Code Review

### **Antes de criar Pull Request:**

- [ ] Código segue Clean Architecture
- [ ] BLoC implementado corretamente
- [ ] Widgets extraídos (não monolíticos)
- [ ] Error handling com Either
- [ ] Dispose de controllers/streams
- [ ] Dependency Injection com GetIt
- [ ] Testes escritos (unit + widget)
- [ ] Sem warnings do linter
- [ ] Comentários em código complexo
- [ ] README atualizado (se necessário)

---

**Criado em:** 27/11/2025  
**Versão:** 1.0.0  
**Responsável:** Time ZECA Mobile

