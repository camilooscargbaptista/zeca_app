# 🏗️ Arquitetura do ZECA App (Flutter)

**Visão geral da arquitetura mobile**

---

## 📊 Visão Macro da Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    PLATAFORMAS MOBILE                        │
├──────────────────────────┬──────────────────────────────────┤
│         iOS              │          Android                 │
│   (iPhone/iPad)          │   (Smartphone/Tablet)            │
└──────────────────────────┴──────────────────────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │   Flutter Engine   │
                    │   (Dart Runtime)   │
                    └─────────┬──────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼────────┐  ┌─────────▼────────┐  ┌───────▼────────┐
│  Presentation  │  │     Domain       │  │      Data      │
│    (BLoC)      │  │   (Use Cases)    │  │  (Repository)  │
└────────────────┘  └──────────────────┘  └───────┬────────┘
                                                   │
        ┌──────────────────────────────────────────┼──────────────┐
        │                                          │              │
┌───────▼───────┐              ┌──────────────────▼────┐  ┌──────▼──────┐
│  Local Data   │              │    Remote Data        │  │   Device    │
│  (Hive/SP)    │              │   (API REST/Dio)      │  │  Hardware   │
└───────────────┘              └───────────────────────┘  └─────────────┘
                                          │
                                ┌─────────▼──────────┐
                                │   Backend API      │
                                │   (zeca_site)      │
                                │  NestJS + Postgres │
                                └────────────────────┘
```

---

## 🎯 Arquitetura: Clean Architecture + BLoC

### **Camadas:**

```
lib/
├── core/                    # Funcionalidades compartilhadas
│   ├── config/              # Configurações (API, env, flavor)
│   ├── constants/           # Constantes
│   ├── di/                  # Dependency Injection (GetIt)
│   ├── errors/              # Exceptions & Failures
│   ├── network/             # HTTP Client (Dio)
│   ├── services/            # Serviços core (Storage, Location, etc)
│   ├── theme/               # Tema visual (white-label)
│   └── utils/               # Utilitários
│
├── features/                # Features (Clean Architecture)
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/  # APIs, Local DB
│       │   ├── models/       # DTOs/Models
│       │   └── repositories/ # Repository Implementation
│       ├── domain/
│       │   ├── entities/     # Business Objects
│       │   ├── repositories/ # Repository Interface
│       │   └── usecases/     # Business Logic
│       └── presentation/
│           ├── bloc/         # BLoC (State Management)
│           ├── pages/        # Telas
│           └── widgets/      # Widgets específicos
│
├── shared/                  # Widgets compartilhados
│   ├── mixins/
│   └── widgets/
│       ├── buttons/
│       ├── dialogs/
│       ├── inputs/
│       └── loading/
│
└── routes/                  # Navegação (GoRouter)
```

---

## 🧩 Detalhamento das Camadas

### **1. PRESENTATION LAYER** (UI + State)

**Responsabilidade:**
- Renderizar UI
- Capturar eventos do usuário
- Gerenciar estado da tela (via BLoC)
- Navegação

**Tecnologias:**
- **UI**: Flutter Widgets (Material Design)
- **State**: BLoC (flutter_bloc)
- **Navigation**: GoRouter

**Estrutura:**

```dart
// BLoC
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final UseCase useCase;
  
  FeatureBloc(this.useCase) : super(FeatureInitial()) {
    on<FeatureEventStarted>(_onStarted);
  }
  
  Future<void> _onStarted(
    FeatureEventStarted event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());
    final result = await useCase.execute();
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(data)),
    );
  }
}

// Page
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeatureBloc>()..add(FeatureEventStarted()),
      child: BlocBuilder<FeatureBloc, FeatureState>(
        builder: (context, state) {
          if (state is FeatureLoading) return LoadingWidget();
          if (state is FeatureError) return ErrorWidget(state.message);
          if (state is FeatureLoaded) return ContentWidget(state.data);
          return Container();
        },
      ),
    );
  }
}
```

---

### **2. DOMAIN LAYER** (Business Logic)

**Responsabilidade:**
- Regras de negócio
- Entities (objetos de negócio)
- Use Cases (casos de uso)
- Interfaces de repositórios

**Princípios:**
- ✅ **Independente** de frameworks
- ✅ **Independente** de UI
- ✅ **Independente** de banco de dados
- ✅ **Testável** facilmente

**Estrutura:**

```dart
// Entity (Objeto de negócio)
class Vehicle {
  final String id;
  final String plate;
  final String model;
  final int fuelCapacity;
  
  Vehicle({
    required this.id,
    required this.plate,
    required this.model,
    required this.fuelCapacity,
  });
}

// Repository Interface
abstract class VehicleRepository {
  Future<Either<Failure, Vehicle>> getVehicleByPlate(String plate);
  Future<Either<Failure, List<Vehicle>>> getVehicles();
}

// Use Case
class GetVehicleByPlate {
  final VehicleRepository repository;
  
  GetVehicleByPlate(this.repository);
  
  Future<Either<Failure, Vehicle>> execute(String plate) async {
    return await repository.getVehicleByPlate(plate);
  }
}
```

---

### **3. DATA LAYER** (Dados)

**Responsabilidade:**
- Implementar repositórios
- Comunicar com APIs (remote)
- Comunicar com banco local (local)
- Mapear DTOs ↔ Entities

**Tecnologias:**
- **HTTP**: Dio + Retrofit
- **Local DB**: Hive
- **Secure Storage**: flutter_secure_storage
- **Preferences**: shared_preferences

**Estrutura:**

```dart
// Model (DTO)
@JsonSerializable()
class VehicleModel {
  final String id;
  final String plate;
  final String model;
  @JsonKey(name: 'fuel_capacity')
  final int fuelCapacity;
  
  VehicleModel({
    required this.id,
    required this.plate,
    required this.model,
    required this.fuelCapacity,
  });
  
  // Mappers
  Vehicle toEntity() {
    return Vehicle(
      id: id,
      plate: plate,
      model: model,
      fuelCapacity: fuelCapacity,
    );
  }
  
  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}

// DataSource (Remote)
abstract class VehicleRemoteDataSource {
  Future<VehicleModel> getVehicleByPlate(String plate);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;
  
  VehicleRemoteDataSourceImpl(this.dio);
  
  @override
  Future<VehicleModel> getVehicleByPlate(String plate) async {
    try {
      final response = await dio.get('/vehicles/by-plate/$plate');
      return VehicleModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }
}

// Repository Implementation
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  final VehicleLocalDataSource localDataSource;
  
  VehicleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, Vehicle>> getVehicleByPlate(String plate) async {
    try {
      final model = await remoteDataSource.getVehicleByPlate(plate);
      await localDataSource.cacheVehicle(model); // Cache local
      return Right(model.toEntity());
    } on ServerException {
      return Left(ServerFailure('Erro ao buscar veículo'));
    } catch (e) {
      return Left(UnexpectedFailure('Erro inesperado'));
    }
  }
}
```

---

## 🔐 Autenticação & Segurança

### **Fluxo de Autenticação:**

```
1. Login (CPF + Senha)
   ↓
2. Backend valida → JWT Access Token + Refresh Token
   ↓
3. App armazena tokens (flutter_secure_storage)
   ↓
4. Interceptor Dio adiciona token em todas as requests
   ↓
5. Se token expirar (401) → Renova automaticamente
   ↓
6. Logout → Limpa tokens + navega para login
```

**Implementação:**

```dart
// Interceptor JWT
class JwtInterceptor extends Interceptor {
  final StorageService storage;
  final Dio dio;
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expirado, renovar
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Retry request original
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
        return;
      }
    }
    handler.next(err);
  }
  
  Future<bool> _refreshToken() async {
    // Implementar refresh token
  }
}
```

---

## 🗺️ Features Principais

### **1. Autenticação**
- Login com CPF + Senha
- JWT sliding window
- Refresh token automático
- Logout

### **2. Abastecimento**
- Buscar veículo por placa
- Gerar QR Code para posto
- Polling status (aguardando validação)
- Validar dados do posto
- Tirar fotos do hodômetro (OCR)
- Enviar fotos

### **3. Jornadas**
- Iniciar jornada
- Tracking GPS em background
- Navegação com Google Maps
- Pausar/Retomar
- Finalizar jornada
- Histórico de jornadas

### **4. Odômetro OCR**
- Captura de foto do hodômetro
- Pré-processamento de imagem
- OCR com Google ML Kit
- Validação de leitura
- Correção manual

### **5. Notificações Push**
- Firebase Cloud Messaging
- Notificações de abastecimento
- Deep links
- Badge counter

### **6. Checklist de Veículos**
- Checklist pré-viagem
- Fotos de evidência
- Sincronização com backend

---

## 🌐 Integração com Backend

### **Base URL:**
```dart
// Produção
const API_URL = 'https://api.abastecacomzeca.com.br/api/v1';

// Desenvolvimento
const API_URL = 'http://192.168.x.x:3000/api/v1';
```

### **Principais Endpoints:**

| Feature | Endpoint | Método |
|---------|----------|--------|
| Login | `/auth/login` | POST |
| Refresh Token | `/auth/refresh` | POST |
| Buscar Veículo | `/vehicles/by-plate/:plate` | GET |
| Gerar Código | `/codes/generate` | POST |
| Status Código | `/codes/status/:code` | GET |
| Buscar Refueling | `/refueling/by-code/:code` | GET |
| Validar Abastecimento | `/refueling/:id/driver-validation` | POST |
| Iniciar Jornada | `/journeys/start` | POST |
| Atualizar Localização | `/journeys/:id/locations` | POST |
| Push Token | `/notifications/register-device` | POST |

---

## 📦 Packages Principais

### **Core:**
- `flutter_bloc` - State management
- `get_it` + `injectable` - Dependency Injection
- `equatable` - Value equality

### **Network:**
- `dio` - HTTP client
- `retrofit` - Type-safe API client
- `connectivity_plus` - Check connection

### **Storage:**
- `hive` - Local NoSQL database
- `flutter_secure_storage` - Secure storage (tokens)
- `shared_preferences` - Simple key-value

### **Location & Maps:**
- `flutter_background_geolocation` - Background tracking
- `geolocator` - Location
- `geocoding` - Reverse geocoding
- `google_maps_flutter` - Maps

### **Camera & OCR:**
- `camera` - Camera access
- `image_picker` - Pick images
- `google_mlkit_text_recognition` - OCR

### **Push Notifications:**
- `firebase_core` + `firebase_messaging`

### **QR Code:**
- `qr_flutter` - Generate QR
- `mobile_scanner` - Scan QR

### **UI:**
- `go_router` - Navigation
- `cached_network_image` - Image cache
- `shimmer` - Loading skeletons

---

## 🎨 White-label (Multi-brand)

### **Estrutura:**

```dart
// Configuração de Flavor
class FlavorConfig {
  final String appName;
  final String apiUrl;
  final String theme;
  final String logoPath;
  
  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance!;
  
  static void configure({
    required String appName,
    required String apiUrl,
    required String theme,
    required String logoPath,
  }) {
    _instance = FlavorConfig._(
      appName: appName,
      apiUrl: apiUrl,
      theme: theme,
      logoPath: logoPath,
    );
  }
}

// main_brand_a.dart
void main() {
  FlavorConfig.configure(
    appName: 'ZECA Brand A',
    apiUrl: 'https://api-brand-a.com',
    theme: 'brand_a',
    logoPath: 'assets/images/brand_a/logo.png',
  );
  runApp(MyApp());
}

// main_brand_b.dart
void main() {
  FlavorConfig.configure(
    appName: 'ZECA Brand B',
    apiUrl: 'https://api-brand-b.com',
    theme: 'brand_b',
    logoPath: 'assets/images/brand_b/logo.png',
  );
  runApp(MyApp());
}
```

---

## 📱 Plataformas

### **iOS:**
- Minimum: iOS 13.0
- Target: iOS 17.0
- Swift 5.x
- CocoaPods

### **Android:**
- Minimum: API 21 (Android 5.0 Lollipop)
- Target: API 34 (Android 14)
- Kotlin 1.9.x
- Gradle 8.x

---

## 🧪 Estratégia de Testes

### **Unit Tests:**
- Domain layer (use cases)
- Data layer (repositories, models)
- BLoC (events, states)

### **Widget Tests:**
- Widgets isolados
- Pages

### **Integration Tests:**
- Fluxos completos
- Navegação

---

## 📊 Performance

### **Otimizações:**
- Lazy loading de listas
- Cache de imagens (cached_network_image)
- Cache local (Hive) para offline-first
- Debounce em buscas
- Pagination em listas grandes

---

## 📖 Documentação Adicional

| Documento | Link |
|-----------|------|
| Padrões de Código Flutter | [../patterns/coding-standards-flutter.md](../patterns/coding-standards-flutter.md) |
| Padrões UI/UX Mobile | [../patterns/ui-ux-mobile-standards.md](../patterns/ui-ux-mobile-standards.md) |
| Estratégia de Testes | [../patterns/testing-strategy-flutter.md](../patterns/testing-strategy-flutter.md) |
| Integração Backend | [../patterns/backend-integration.md](../patterns/backend-integration.md) |
| Guia de Desenvolvimento | [../patterns/development-guide-flutter.md](../patterns/development-guide-flutter.md) |

---

## 📝 Decisões Arquiteturais

| ADR | Decisão |
|-----|---------|
| [ADR-001](../decisions/ADR-001-clean-architecture-bloc.md) | Usar Clean Architecture + BLoC |
| [ADR-002](../decisions/ADR-002-getit-injectable.md) | Usar GetIt + Injectable para DI |
| [ADR-003](../decisions/ADR-003-hive-storage.md) | Usar Hive para storage local |
| [ADR-004](../decisions/ADR-004-flutter-background-geolocation.md) | Usar flutter_background_geolocation |
| [ADR-005](../decisions/ADR-005-google-mlkit-ocr.md) | Usar Google ML Kit para OCR |

---

**Última atualização:** 27/11/2025  
**Versão:** 1.0.0  
**Responsável:** Time ZECA Mobile

