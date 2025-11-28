# 📋 **RESUMO PARA TIME DE BACKEND**

**Data:** 28-Nov-2025  
**Feature:** UH-004 - Tracking GPS  
**Problema:** Status 400 - Body Inválido  

---

## 🚨 **O PROBLEMA:**

O plugin `flutter_background_geolocation` está **ignorando o locationTemplate** e enviando **TODOS os seus campos internos** para o endpoint `/api/v1/journeys/location-point`.

---

## ❌ **O QUE O APP ESTÁ ENVIANDO (formato do plugin):**

```json
{
  "uuid": "abc-123-def-456",
  "odometer": 1234.56,
  "extras": {},
  "mock": false,
  "age": 123,
  "timestampMeta": {
    "time": "2025-11-28T14:56:37.591Z"
  },
  "event": "motionchange",
  "battery": {
    "level": 0.9,
    "is_charging": true
  },
  "coords": {
    "latitude": -21.1704,
    "longitude": -47.8103,
    "accuracy": 10.5,
    "altitude": 500.2,
    "altitude_accuracy": 5.0,
    "speed": 16.7,  ← m/s, não km/h!
    "speed_accuracy": 1.0,
    "heading": 180.5,
    "heading_accuracy": 2.0
  },
  "is_moving": true,
  "activity": {
    "type": "in_vehicle",
    "confidence": 100
  },
  "journey_id": ""  ← Vazio ou inexistente!
}
```

---

## ✅ **O QUE O BACKEND ESPERA:**

```json
{
  "journey_id": "ef912076-3ee4-46b9-ad72-99ebdeed1171",
  "latitude": -21.1704,
  "longitude": -47.8103,
  "velocidade": 60.12,  ← km/h
  "timestamp": "2025-11-28T14:56:37.591Z"
}
```

---

## 🔍 **ERRO DE VALIDAÇÃO (NestJS):**

```
{
  "statusCode": 400,
  "message": [
    "property uuid should not exist",
    "property odometer should not exist",
    "property extras should not exist",
    "property mock should not exist",
    "property age should not exist",
    "property timestampMeta should not exist",
    "property event should not exist",
    "property battery should not exist",
    "property coords should not exist",
    "property is_moving should not exist",
    "property activity should not exist",
    "journey_id should not be empty",
    "journey_id must be a UUID",
    "latitude must be a number",
    "longitude must be a number",
    "velocidade must be a number"
  ]
}
```

---

## 💡 **SOLUÇÕES POSSÍVEIS:**

### **Opção A: Backend mapear campos do plugin** ⭐ RECOMENDADO
```typescript
// No DTO, aceitar ambos os formatos:
export class AddLocationPointDto {
  @IsOptional() // Aceitar campos do plugin
  coords?: {
    latitude: number;
    longitude: number;
    speed: number;  // m/s
  };
  
  // Ou formato direto
  @IsOptional()
  latitude?: number;
  
  @IsOptional()
  longitude?: number;
  
  @IsOptional()
  velocidade?: number;  // km/h
  
  // ... outros campos opcionais para ignorar
  @IsOptional()
  uuid?: string;
  
  @IsOptional()
  odometer?: number;
  
  // etc...
}

// No service, mapear:
if (dto.coords) {
  latitude = dto.coords.latitude;
  longitude = dto.coords.longitude;
  velocidade = dto.coords.speed * 3.6;  // m/s → km/h
} else {
  latitude = dto.latitude;
  longitude = dto.longitude;
  velocidade = dto.velocidade;
}
```

### **Opção B: Endpoint alternativo**
```typescript
@Post('location-point/plugin')
async addLocationPointFromPlugin(
  @Body() pluginDto: PluginLocationDto  // DTO específico para o plugin
)
```

### **Opção C: App usar HTTP manual** ❌ NÃO RECOMENDADO
- Perderíamos tracking em background robusto
- Perderíamos persistência local (offline)
- Mais código para manter no app

---

## 📝 **CURL PARA TESTE:**

```bash
#!/bin/bash

TOKEN="COLE_SEU_TOKEN_AQUI"
JOURNEY_ID="ef912076-3ee4-46b9-ad72-99ebdeed1171"

# Formato CORRETO (o que backend espera)
curl -X POST "https://www.abastecacomzeca.com.br/api/v1/journeys/location-point" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "x-device-id: test-123" \
  -d '{
    "journey_id": "'$JOURNEY_ID'",
    "latitude": -21.1704,
    "longitude": -47.8103,
    "velocidade": 60.12,
    "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'"
  }' \
  -w "\n\nHTTP Status: %{http_code}\n"
```

---

## 🎯 **RECOMENDAÇÃO:**

**Opção A** é a melhor:
- ✅ Minimal changes no backend
- ✅ App continua usando plugin robusto
- ✅ Suporta ambos os formatos (retrocompatível)

**DTO flexível:**
```typescript
@IsOptional() uuid?: string;
@IsOptional() odometer?: number;
@IsOptional() extras?: any;
@IsOptional() coords?: { latitude: number; longitude: number; speed: number; };
@IsOptional() latitude?: number;
@IsOptional() longitude?: number;
@IsOptional() velocidade?: number;
// ... demais campos opcionais
```

---

**Aguardando retorno do time de backend com curl que funciona! 🚀**

