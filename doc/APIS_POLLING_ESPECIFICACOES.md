# 📡 APIs Chamadas no Polling - Especificações

**Data:** 30 de dezembro de 2025

---

## 🔍 APIs Chamadas pelo Polling

O polling chama **2 APIs principais**, dependendo se o app tem ou não o `refuelingId`:

---

## 1️⃣ API: `GET /api/v1/refueling/by-code/:code`

### Quando é chamada:
- Quando o app **NÃO tem** o `refuelingId` (apenas o código)
- O polling precisa descobrir o `refuelingId` a partir do código

### Código no app:
```dart
// refueling_polling_service.dart (linha 103)
final codeResponse = await _apiService.getRefuelingByCode(_currentRefuelingCode!);
```

### Endpoint completo:
```
GET https://www.abastecacomzeca.com.br/api/v1/refueling/by-code/A1B2-2024-3F7A8B9C
```

### O que o app espera receber:

#### ✅ Resposta de SUCESSO (200):
```json
{
  "id": "uuid-do-refueling",  // ⚠️ CRÍTICO: ID do refueling, não do código!
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",  // ⚠️ CRÍTICO: Status do refueling
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
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T14:30:00Z"
}
```

#### ⚠️ Resposta quando ainda não existe refueling (código pendente):
```json
{
  "id": "uuid-do-codigo",  // ⚠️ ID do código, não do refueling
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "ACTIVE",  // ou "VALIDADO"
  "is_pending_code": true  // ⚠️ Flag indicando que é código, não refueling
}
```

### O que o app faz com a resposta:

```dart
// refueling_polling_service.dart (linhas 107-128)
if (codeResponse['success'] == true && codeResponse['data'] != null) {
  final refuelingData = codeResponse['data'] as Map<String, dynamic>;
  refuelingIdToCheck = refuelingData['id'] as String?;  // Extrai o ID
  final status = refuelingData['status'] as String?;     // Extrai o status
  
  if (refuelingIdToCheck != null) {
    _currentRefuelingId = refuelingIdToCheck; // Salva para próximas verificações
    
    // Verifica se status é AGUARDANDO_VALIDACAO_MOTORISTA
    if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
      _onStatusChanged?.call(refuelingIdToCheck); // ✅ Chama callback!
      return;
    }
  }
}
```

### ⚠️ Problema atual:
- Se o backend retornar o **código** ao invés do **refueling**, o app recebe `id` do código
- Quando o app tenta usar esse `id` na próxima API, pode dar erro 404
- O app não consegue detectar quando o refueling é criado

---

## 2️⃣ API: `GET /api/v1/refueling/:id`

### Quando é chamada:
- Quando o app **JÁ TEM** o `refuelingId`
- Ou após obter o `refuelingId` do endpoint `/by-code/:code`

### Código no app:
```dart
// refueling_polling_service.dart (linha 147)
final response = await _apiService.getRefuelingStatus(refuelingIdToCheck);
```

### Endpoint completo:
```
GET https://www.abastecacomzeca.com.br/api/v1/refueling/uuid-do-refueling
```

### O que o app espera receber:

#### ✅ Resposta de SUCESSO (200):
```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",  // ⚠️ CRÍTICO: Este é o status que o app procura
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
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T14:30:00Z"
}
```

#### ❌ Resposta de ERRO (404):
```json
{
  "statusCode": 404,
  "message": "Abastecimento não encontrado",
  "error": "Not Found"
}
```

### O que o app faz com a resposta:

```dart
// refueling_polling_service.dart (linhas 151-171)
if (response['success'] == true && response['data'] != null) {
  final data = response['data'] as Map<String, dynamic>;
  final status = data['status'] as String?;
  
  if (status != null) {
    // Verifica se status é AGUARDANDO_VALIDACAO_MOTORISTA
    if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
        status == 'aguardando_validacao_motorista' ||
        status.toUpperCase() == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
      _onStatusChanged?.call(refuelingIdToCheck); // ✅ Chama callback!
    } else {
      // Status ainda não é o esperado, continua polling...
    }
  }
}
```

### ⚠️ Problema atual:
- Se o status não for `'AGUARDANDO_VALIDACAO_MOTORISTA'`, o polling continua indefinidamente
- O app não detecta quando o refueling é criado

---

## 3️⃣ API: `GET /api/v1/refueling?status=AGUARDANDO_VALIDACAO_MOTORISTA`

### Quando é chamada:
- **NÃO está sendo usada atualmente no polling!**
- Está disponível em `api_service.dart` como `getPendingRefuelings()`
- Poderia ser uma alternativa melhor ao polling atual

### Código no app:
```dart
// api_service.dart (linha 927)
Future<Map<String, dynamic>> getPendingRefuelings() async {
  final response = await _dio.get(
    '/refueling',
    queryParameters: {
      'status': 'AGUARDANDO_VALIDACAO_MOTORISTA',
      'limit': 100,
      'sortBy': 'created_at',
      'sortOrder': 'DESC',
    },
  );
}
```

### Endpoint completo:
```
GET https://www.abastecacomzeca.com.br/api/v1/refueling?status=AGUARDANDO_VALIDACAO_MOTORISTA&limit=100&sortBy=created_at&sortOrder=DESC
```

### O que o app espera receber:

#### ✅ Resposta de SUCESSO (200):
```json
{
  "data": [
    {
      "id": "uuid-do-refueling-1",
      "refueling_code": "A1B2-2024-3F7A8B9C",
      "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
      "created_at": "2025-11-12T14:00:00Z",
      "quantity_liters": 100.5,
      "odometer_reading": 50000,
      // ... outros campos ...
    },
    {
      "id": "uuid-do-refueling-2",
      "refueling_code": "C3D4-2024-5G8H9I0J",
      "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
      "created_at": "2025-11-12T15:00:00Z",
      // ... outros campos ...
    }
  ],
  "total": 2,
  "page": 1,
  "limit": 100
}
```

### Vantagem de usar esta API:
- ✅ Retorna **todos** os refuelings pendentes de uma vez
- ✅ O app pode filtrar pelo `refueling_code` que está monitorando
- ✅ Mais confiável porque usa a mesma API que a tela de abastecimento usa
- ✅ Não depende de buscar por código (que pode retornar código ao invés de refueling)

---

## 📊 Fluxo Completo do Polling

```
1. App inicia polling com código: "A1B2-2024-3F7A8B9C"
   ↓
2. App NÃO tem refuelingId → Chama API 1:
   GET /api/v1/refueling/by-code/A1B2-2024-3F7A8B9C
   ↓
3. Backend retorna código (não refueling):
   {
     "id": "uuid-do-codigo",
     "status": "ACTIVE",
     "is_pending_code": true
   }
   ↓
4. App não encontra refuelingId → Continua polling...
   ↓
5. Posto registra abastecimento → Refueling criado
   ↓
6. App chama API 1 novamente:
   GET /api/v1/refueling/by-code/A1B2-2024-3F7A8B9C
   ↓
7. Backend DEVERIA retornar refueling:
   {
     "id": "uuid-do-refueling",  // ✅ ID do refueling
     "status": "AGUARDANDO_VALIDACAO_MOTORISTA"  // ✅ Status correto
   }
   ↓
8. App recebe refuelingId → Salva para próximas verificações
   ↓
9. App chama API 2:
   GET /api/v1/refueling/uuid-do-refueling
   ↓
10. Backend retorna refueling com status:
    {
      "status": "AGUARDANDO_VALIDACAO_MOTORISTA"
    }
    ↓
11. App detecta status correto → Chama callback ✅
    ↓
12. App navega para tela de validação ✅
```

---

## ⚠️ Campos Críticos que o App Espera

### Na API `/by-code/:code`:
1. **`id`** - Deve ser o ID do **refueling**, não do código
2. **`status`** - Deve ser `'AGUARDANDO_VALIDACAO_MOTORISTA'` quando refueling existe
3. **`refueling_code`** - Código do abastecimento

### Na API `/refueling/:id`:
1. **`status`** - Deve ser `'AGUARDANDO_VALIDACAO_MOTORISTA'` quando aguardando validação
2. **`id`** - ID do refueling

### Campos opcionais (mas úteis):
- `quantity_liters` - Quantidade em litros
- `odometer_reading` - Quilometragem
- `pump_number` - Número da bomba
- `unit_price` - Preço unitário
- `total_amount` - Valor total
- `attendant_name` - Nome do atendente
- `notes` - Observações
- `vehicle_plate` - Placa do veículo
- `driver_cpf` - CPF do motorista
- `driver_name` - Nome do motorista
- `transporter_cnpj` - CNPJ da transportadora
- `transporter_name` - Nome da transportadora
- `fuel_type` - Tipo de combustível
- `refueling_datetime` - Data/hora do abastecimento
- `created_at` - Data de criação
- `updated_at` - Data de atualização

---

## ✅ Resumo

### APIs chamadas:
1. **`GET /api/v1/refueling/by-code/:code`** - Quando não tem refuelingId
2. **`GET /api/v1/refueling/:id`** - Quando já tem refuelingId

### O que o app espera:
- **`id`** do refueling (não do código)
- **`status`** = `'AGUARDANDO_VALIDACAO_MOTORISTA'` quando refueling existe

### Problema atual:
- Backend pode retornar código ao invés de refueling
- App não consegue obter refuelingId corretamente
- Polling não detecta quando refueling é criado

---

## 📚 Arquivos do App

- `lib/core/services/refueling_polling_service.dart` - Serviço de polling
- `lib/core/services/api_service.dart` - Serviço de API
- `lib/features/refueling/presentation/pages/refueling_waiting_page.dart` - Tela de aguardando

