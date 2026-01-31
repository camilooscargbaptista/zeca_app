---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Contexto API-CONTRACTS.md"
---


# ZECA App - API Contracts

> **IMPORTANTE:** Consulte este arquivo ANTES de criar chamadas HTTP.
> Mantenha sincronizado com o backend (zeca_site).

---

## Base URL

```dart
// Desenvolvimento
const String baseUrl = 'http://localhost:3000/api/v1';

// Produção
const String baseUrl = 'https://api.zeca.com.br/api/v1';
```

---

## Autenticação

Todas as requisições (exceto `/auth/*`) devem incluir:

```dart
headers: {
  'Authorization': 'Bearer $accessToken',
  'Content-Type': 'application/json',
}
```

---

## Endpoints do App

### Auth

#### POST /auth/login

**Descrição:** Login do motorista/frotista

**Request:**
```dart
class LoginRequest {
  final String cpf;      // "123.456.789-00"
  final String password;
  final String userType; // "DRIVER" ou "FLEET"
}
```

**Response 200:**
```dart
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String type;      // DRIVER, FLEET
  final String? fleetId;
  final FleetModel? fleet;
}
```

**Response 401:**
```dart
class ErrorResponse {
  final int statusCode;   // 401
  final String message;   // "Credenciais inválidas"
  final String error;     // "Unauthorized"
}
```

---

#### POST /auth/refresh

**Request:**
```dart
class RefreshRequest {
  final String refreshToken;
}
```

**Response 200:**
```dart
class TokenResponse {
  final String accessToken;
  final String refreshToken;
}
```

---

### Vehicles (Veículos do Motorista)

#### GET /vehicles/my

**Descrição:** Listar veículos do motorista logado

**Response 200:**
```dart
class VehiclesResponse {
  final List<VehicleModel> data;
}

class VehicleModel {
  final String id;
  final String plate;
  final String brand;
  final String model;
  final int year;
  final String color;
  final String fuelType;    // GASOLINE, ETHANOL, DIESEL, FLEX
  final double? tankCapacity;
  final int? odometer;
  final bool isActive;
}
```

---

### Stations (Postos)

#### GET /stations

**Descrição:** Listar postos próximos

**Query Params:**
```dart
class StationsParams {
  final double? latitude;
  final double? longitude;
  final int? radius;        // km, default: 10
  final int? page;          // default: 1
  final int? limit;         // default: 10
}
```

**Response 200:**
```dart
class StationsResponse {
  final List<StationModel> data;
  final MetaModel meta;
}

class StationModel {
  final String id;
  final String name;
  final String tradeName;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final double? pumpPriceGasoline;
  final double? pumpPriceEthanol;
  final double? pumpPriceDiesel;
  final bool isActive;
  final double? distance;   // km (se passou lat/lng)
}

class MetaModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
}
```

---

#### GET /stations/:id

**Descrição:** Detalhe do posto

**Response 200:**
```dart
class StationDetailModel {
  final String id;
  final String name;
  final String cnpj;
  final String tradeName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final double? pumpPriceGasoline;
  final double? pumpPriceEthanol;
  final double? pumpPriceDiesel;
  final List<String>? services;  // Serviços oferecidos
  final String? workingHours;
}
```

---

### Refuelings (Abastecimentos)

#### POST /refuelings/generate-code

**Descrição:** Gerar código de abastecimento

**Request:**
```dart
class GenerateCodeRequest {
  final String vehicleId;
  final String stationId;
  final String fuelType;      // GASOLINE, ETHANOL, DIESEL
  final double? estimatedLiters;
}
```

**Response 201:**
```dart
class RefuelingCodeResponse {
  final String id;
  final String code;          // "ZECA2025AB12CD34"
  final String status;        // "PENDING"
  final DateTime expiresAt;
  final VehicleModel vehicle;
  final StationModel station;
  final String fuelType;
  final double pricePerLiter; // Preço ZECA
  final double pumpPrice;     // Preço bomba
}
```

---

#### GET /refuelings/:id

**Descrição:** Buscar abastecimento por ID

**Response 200:**
```dart
class RefuelingModel {
  final String id;
  final String code;
  final String status;        // PENDING, VALIDATED, IN_PROGRESS, AWAITING_PAYMENT, COMPLETED, CANCELLED
  final VehicleModel vehicle;
  final StationModel station;
  final UserModel driver;
  final String fuelType;
  final double? quantityLiters;
  final double pricePerLiter;
  final double pumpPrice;
  final double? totalValue;
  final double? savings;
  final int? odometer;
  final DateTime startedAt;
  final DateTime? completedAt;
}
```

---

#### GET /refuelings/active

**Descrição:** Buscar abastecimento ativo do motorista (se houver)

**Response 200:** `RefuelingModel` ou `null`

---

#### POST /refuelings/:id/confirm

**Descrição:** Motorista confirma abastecimento (fluxo Frota)

**Response 200:**
```dart
class RefuelingConfirmResponse {
  final String id;
  final String status;  // "COMPLETED"
  final double totalValue;
  final double savings;
}
```

---

#### DELETE /refuelings/:id

**Descrição:** Cancelar código de abastecimento (antes de validar)

**Response 204:** No content

---

### History (Histórico)

#### GET /refuelings

**Descrição:** Histórico de abastecimentos do motorista

**Query Params:**
```dart
class HistoryParams {
  final int? page;
  final int? limit;
  final String? startDate;  // YYYY-MM-DD
  final String? endDate;    // YYYY-MM-DD
  final String? status;
}
```

**Response 200:**
```dart
class HistoryResponse {
  final List<RefuelingModel> data;
  final MetaModel meta;
  final HistorySummary? summary;
}

class HistorySummary {
  final int totalRefuelings;
  final double totalLiters;
  final double totalValue;
  final double totalSavings;
}
```

---

### Payments (Pagamentos - Autônomo)

#### POST /payments/pix/generate

**Descrição:** Gerar QR Code PIX para pagamento

**Request:**
```dart
class GeneratePixRequest {
  final String refuelingId;
}
```

**Response 201:**
```dart
class PixResponse {
  final String id;
  final String refuelingId;
  final double amount;
  final String pixKey;
  final String qrCode;        // Código copia-cola
  final String qrCodeBase64;  // Imagem em base64
  final DateTime expiresAt;
}
```

---

#### GET /payments/:id/status

**Descrição:** Verificar status do pagamento

**Response 200:**
```dart
class PaymentStatusResponse {
  final String id;
  final String status;  // PENDING, PROCESSING, COMPLETED, FAILED
  final double amount;
  final DateTime? paidAt;
}
```

---

### Profile (Perfil)

#### GET /users/me

**Descrição:** Dados do usuário logado

**Response 200:** `UserModel`

---

#### PUT /users/me

**Descrição:** Atualizar perfil

**Request:**
```dart
class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? email;
}
```

---

#### PUT /users/me/password

**Descrição:** Alterar senha

**Request:**
```dart
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
}
```

---

## WebSocket Events

### Conexão

```dart
// Conectar ao WebSocket
socket = io('wss://api.zeca.com.br', {
  'auth': {'token': accessToken},
});

// Entrar na sala do motorista
socket.emit('join', {'room': 'driver:$userId'});
```

### Eventos Recebidos

#### autonomous_payment_confirmed

**Descrição:** PIX confirmado (fluxo autônomo)

```dart
class PaymentConfirmedEvent {
  final String refuelingCode;
  final String status;        // "COMPLETED"
  final double totalValue;
  final double quantityLiters;
  final double pricePerLiter;
  final double pumpPrice;
  final double savings;
  final String stationName;
  final String vehiclePlate;
  final String fuelType;
  final DateTime timestamp;
}
```

#### refueling_validated

**Descrição:** Código validado pelo posto

```dart
class RefuelingValidatedEvent {
  final String refuelingId;
  final String code;
  final String stationName;
}
```

#### refueling_completed

**Descrição:** Abastecimento finalizado pelo posto

```dart
class RefuelingCompletedEvent {
  final String refuelingId;
  final double quantityLiters;
  final double totalValue;
  final double savings;
}
```

---

## Códigos de Erro

| Status | Significado | Ação no App |
|--------|-------------|-------------|
| 400 | Dados inválidos | Mostrar mensagem de validação |
| 401 | Token inválido/expirado | Tentar refresh, se falhar → logout |
| 403 | Sem permissão | Mostrar erro de permissão |
| 404 | Não encontrado | Mostrar erro específico |
| 409 | Conflito (já existe) | Mostrar mensagem específica |
| 422 | Validação falhou | Mostrar erros de campo |
| 500 | Erro interno | Mostrar erro genérico + retry |

---

## Exemplo de DataSource

```dart
@LazySingleton(as: RefuelingRemoteDataSource)
class RefuelingRemoteDataSourceImpl implements RefuelingRemoteDataSource {
  final Dio dio;

  RefuelingRemoteDataSourceImpl(this.dio);

  @override
  Future<RefuelingModel> generateCode(GenerateCodeRequest request) async {
    try {
      final response = await dio.post(
        '/refuelings/generate-code',
        data: request.toJson(),
      );
      return RefuelingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Erro ao gerar código');
    }
  }
}
```
