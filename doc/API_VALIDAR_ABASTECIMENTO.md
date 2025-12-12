# 📡 API de Validação de Abastecimento - Especificações

**Data:** 30 de dezembro de 2025

---

## 🔍 Quando é Chamada

A API é chamada quando o motorista clica em **"Validar Agora"** na tela de abastecimentos pendentes ou na tela de aguardando validação.

---

## 📡 API Chamada

### Endpoint:
```
POST /api/v1/refueling/:id/validate
```

### Endpoint Completo:
```
POST https://www.abastecacomzeca.com.br/api/v1/refueling/uuid-do-refueling/validate
```

### Código no App:
```dart
// api_service.dart (linha 831)
Future<Map<String, dynamic>> validateRefueling({
  required String refuelingId,
  required String device,
  required double latitude,
  required double longitude,
  String? address,
}) async {
  final requestData = {
    'device': device,
    'latitude': latitude,
    'longitude': longitude,
    if (address != null && address.isNotEmpty) 'address': address,
  };

  final response = await _dio.post(
    '/refueling/$refuelingId/validate',
    data: requestData,
  );
}
```

---

## 📤 O Que o App Envia (Request Body)

### Campos Obrigatórios:
```json
{
  "device": "iPhone 15 Pro",  // Nome do dispositivo
  "latitude": -23.5505199,    // Latitude da localização atual
  "longitude": -46.6333094    // Longitude da localização atual
}
```

### Campos Opcionais:
```json
{
  "address": "Rua Exemplo, 123 - São Paulo, SP"  // Endereço completo (opcional)
}
```

### Exemplo Completo:
```json
{
  "device": "iPhone 15 Pro",
  "latitude": -23.5505199,
  "longitude": -46.6333094,
  "address": "Rua Exemplo, 123 - São Paulo, SP"
}
```

### Como o App Obtém os Dados:

1. **`device`**: Nome do dispositivo
   ```dart
   // Obtido via DeviceService
   final deviceInfo = await _deviceService.getDeviceInfo();
   final device = '${deviceInfo['device_model']}';
   ```

2. **`latitude` e `longitude`**: Localização atual do GPS
   ```dart
   // Obtido via LocationService
   final locationData = await _locationService.getCurrentLocation();
   final latitude = locationData['latitude'];
   final longitude = locationData['longitude'];
   ```

3. **`address`**: Endereço completo (opcional)
   ```dart
   // Obtido via GeocodingService (se disponível)
   final address = await _geocodingService.getFullAddress(location);
   ```

---

## 📥 O Que o App Espera Receber (Response)

### ✅ Resposta de SUCESSO (200 ou 201):

```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "VALIDADO",  // ⚠️ Status deve mudar para VALIDADO
  "quantity_liters": 100.5,
  "odometer_reading": 50000,
  "pump_number": "3",
  "unit_price": 4.50,
  "total_amount": 452.25,
  "attendant_name": "João Silva",
  "notes": "Observações do posto",
  "vehicle_plate": "ABC-1234",
  "driver_cpf": "555.666.777-88",
  "driver_name": "Pedro Oliveira",
  "transporter_cnpj": "98.765.432/0001-10",
  "transporter_name": "Transportadora ABC Ltda",
  "fuel_type": "Diesel S10",
  "refueling_datetime": "2025-11-12T14:00:00Z",
  "validated_at": "2025-11-12T15:00:00Z",  // ⚠️ Data/hora da validação
  "validated_by": "uuid-do-motorista",      // ⚠️ ID do motorista que validou
  "validation_location": {                  // ⚠️ Localização da validação
    "latitude": -23.5505199,
    "longitude": -46.6333094,
    "address": "Rua Exemplo, 123 - São Paulo, SP"
  },
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T15:00:00Z"
}
```

### ⚠️ Campos Críticos que o App Espera:

1. **`status`** - Deve ser `'VALIDADO'` após validação bem-sucedida
2. **`validated_at`** - Data/hora da validação (opcional, mas útil)
3. **`validated_by`** - ID do motorista que validou (opcional, mas útil)
4. **`validation_location`** - Localização da validação (opcional, mas útil)

### ❌ Resposta de ERRO (400, 401, 404, 500):

```json
{
  "statusCode": 400,
  "message": "Erro ao validar abastecimento",
  "error": "Bad Request"
}
```

---

## 🔄 O Que o App Faz com a Resposta

### Código no App:
```dart
// refueling_waiting_page.dart (linha 256)
final response = await _apiService.validateRefueling(
  refuelingId: refuelingId,
  device: device,
  latitude: latitude,
  longitude: longitude,
  address: address,
);

if (response['success'] == true) {
  // ✅ Validação bem-sucedida
  // Mostrar mensagem de sucesso
  SuccessDialog.show(
    context,
    title: 'Validação Realizada',
    message: 'Abastecimento validado com sucesso!',
  );
  
  // Navegar para tela inicial ou lista de abastecimentos
  context.go('/home');
} else {
  // ❌ Erro na validação
  ErrorDialog.show(
    context,
    title: 'Erro',
    message: response['error'] ?? 'Erro ao validar abastecimento',
  );
}
```

---

## 📊 Fluxo Completo

```
1. Motorista clica em "Validar Agora"
   ↓
2. App verifica permissão de localização
   ↓
3. App obtém localização atual (GPS)
   ↓
4. App obtém informações do dispositivo
   ↓
5. App chama API:
   POST /api/v1/refueling/:id/validate
   {
     "device": "iPhone 15 Pro",
     "latitude": -23.5505199,
     "longitude": -46.6333094,
     "address": "Rua Exemplo, 123"
   }
   ↓
6. Backend valida o abastecimento
   - Atualiza status para "VALIDADO"
   - Salva localização da validação
   - Salva data/hora da validação
   - Salva ID do motorista que validou
   ↓
7. Backend retorna refueling atualizado:
   {
     "status": "VALIDADO",
     "validated_at": "2025-11-12T15:00:00Z",
     ...
   }
   ↓
8. App recebe resposta de sucesso
   ↓
9. App mostra mensagem de sucesso
   ↓
10. App navega para tela inicial ✅
```

---

## ⚠️ Validações que o App Faz Antes de Chamar a API

1. **Permissão de Localização:**
   ```dart
   bool hasPermission = await _locationService.checkPermission();
   if (!hasPermission) {
     hasPermission = await _locationService.requestPermission();
   }
   ```

2. **Localização Disponível:**
   ```dart
   final locationData = await _locationService.getCurrentLocation()
       .timeout(Duration(seconds: 15));
   if (locationData == null) {
     // Erro: não foi possível obter localização
   }
   ```

3. **RefuelingId Válido:**
   ```dart
   if (refuelingId.isEmpty) {
     // Erro: ID do abastecimento não encontrado
   }
   ```

---

## 📝 Resumo

### API:
- **Endpoint:** `POST /api/v1/refueling/:id/validate`
- **Método:** POST
- **Autenticação:** Sim (JWT Bearer Token)

### Request Body:
- `device` (obrigatório) - Nome do dispositivo
- `latitude` (obrigatório) - Latitude da localização
- `longitude` (obrigatório) - Longitude da localização
- `address` (opcional) - Endereço completo

### Response Esperado:
- **Status:** 200 ou 201
- **Body:** Refueling atualizado com `status: 'VALIDADO'`
- **Campos opcionais úteis:** `validated_at`, `validated_by`, `validation_location`

---

## 📚 Arquivos do App

- `lib/core/services/api_service.dart` - Método `validateRefueling()`
- `lib/features/refueling/presentation/pages/refueling_waiting_page.dart` - Método `_confirmValidation()`
- `lib/features/refueling/presentation/pages/pending_refuelings_page.dart` - Botão "Validar Agora"

