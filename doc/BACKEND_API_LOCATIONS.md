# 📍 API DE LOCALIZAÇÕES - DOCUMENTAÇÃO PARA BACKEND

Este documento descreve o endpoint que o **backend deve implementar** para receber as localizações dos motoristas em tempo real.

---

## 🎯 **ENDPOINT PRINCIPAL**

### **POST** `/api/v1/journeys/:journey_id/locations`

Recebe pontos de GPS capturados pelo app do motorista durante a jornada.

---

## 📥 **REQUEST**

### **Headers:**
```http
POST /api/v1/journeys/123e4567-e89b-12d3-a456-426614174000/locations HTTP/1.1
Host: api.zeca.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
x-device-id: 550e8400-e29b-41d4-a716-446655440000
```

| Header | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `Authorization` | string | ✅ | Token JWT do motorista (`Bearer <token>`) |
| `Content-Type` | string | ✅ | `application/json` |
| `x-device-id` | string | ✅ | UUID único do dispositivo (para JWT Sliding Window) |

### **URL Parameters:**
| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `journey_id` | UUID | ID da jornada ativa |

### **Body (JSON):**

O body pode conter **1 ou múltiplos pontos** (batch):

#### **Exemplo com 1 ponto:**
```json
{
  "location": {
    "latitude": -23.550520,
    "longitude": -46.633308,
    "speed": 65.5,
    "heading": 45,
    "altitude": 760,
    "accuracy": 10,
    "speed_accuracy": 1,
    "heading_accuracy": 5,
    "timestamp": "2025-11-19T23:45:30.000Z",
    "is_moving": true,
    "activity": {
      "type": "automotive_navigation",
      "confidence": 100
    },
    "battery": {
      "level": 0.75,
      "is_charging": false
    },
    "odometer": 125050.5
  },
  "journey_id": "123e4567-e89b-12d3-a456-426614174000"
}
```

#### **Exemplo com múltiplos pontos (batch):**
```json
{
  "locations": [
    {
      "latitude": -23.550520,
      "longitude": -46.633308,
      "speed": 65.5,
      "heading": 45,
      "altitude": 760,
      "accuracy": 10,
      "timestamp": "2025-11-19T23:45:30.000Z",
      "is_moving": true,
      "odometer": 125050.5
    },
    {
      "latitude": -23.550800,
      "longitude": -46.633500,
      "speed": 67.2,
      "heading": 46,
      "altitude": 762,
      "accuracy": 8,
      "timestamp": "2025-11-19T23:45:45.000Z",
      "is_moving": true,
      "odometer": 125080.8
    }
  ],
  "journey_id": "123e4567-e89b-12d3-a456-426614174000"
}
```

---

## 📤 **RESPONSE**

### **Success (200 OK):**
```json
{
  "success": true,
  "message": "Localizações salvas com sucesso",
  "data": {
    "journey_id": "123e4567-e89b-12d3-a456-426614174000",
    "locations_saved": 2,
    "total_locations": 1547,
    "journey_km": 125.08
  }
}
```

### **Error (400 Bad Request):**
```json
{
  "success": false,
  "error": "Journey não encontrada ou já finalizada"
}
```

### **Error (401 Unauthorized):**
```json
{
  "success": false,
  "error": "Token inválido ou expirado"
}
```

### **Error (403 Forbidden):**
```json
{
  "success": false,
  "error": "Motorista não autorizado para esta jornada"
}
```

---

## 🗄️ **SCHEMA DO BANCO DE DADOS**

Sugestão de tabela para armazenar as localizações:

```sql
CREATE TABLE journey_locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  journey_id UUID NOT NULL REFERENCES journeys(id) ON DELETE CASCADE,
  
  -- Coordenadas
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  altitude DECIMAL(8, 2),
  
  -- Movimento
  speed DECIMAL(6, 2), -- km/h
  heading DECIMAL(6, 2), -- graus (0-360)
  
  -- Precisão
  accuracy DECIMAL(6, 2), -- metros
  speed_accuracy DECIMAL(6, 2),
  heading_accuracy DECIMAL(6, 2),
  
  -- Metadados
  is_moving BOOLEAN DEFAULT true,
  activity_type VARCHAR(50), -- 'automotive_navigation', 'stationary', etc.
  activity_confidence INTEGER, -- 0-100
  
  -- Bateria
  battery_level DECIMAL(3, 2), -- 0.0 - 1.0
  battery_is_charging BOOLEAN,
  
  -- Odômetro
  odometer DECIMAL(12, 2), -- metros acumulados
  
  -- Timestamp
  timestamp TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  
  -- Índices
  INDEX idx_journey_locations_journey_id (journey_id),
  INDEX idx_journey_locations_timestamp (timestamp),
  INDEX idx_journey_locations_created_at (created_at)
);
```

---

## 🔐 **SEGURANÇA E VALIDAÇÕES**

### **Validações obrigatórias:**

1. ✅ **Validar JWT token** - Verificar se o token é válido e não expirou
2. ✅ **Verificar journey_id** - Garantir que a jornada existe e está ativa
3. ✅ **Validar motorista** - Confirmar que o motorista autenticado é o dono da jornada
4. ✅ **Validar coordenadas** - Latitude (-90 a 90), Longitude (-180 a 180)
5. ✅ **Validar timestamp** - Não deve ser futuro, não deve ser muito antigo (> 7 dias)
6. ✅ **Rate limiting** - Máximo 100 requests por minuto por motorista
7. ✅ **Deduplicação** - Evitar salvar pontos duplicados (mesma lat/lng/timestamp)

### **Exemplo de validação (Node.js):**
```javascript
// Middleware de validação
async function validateLocationRequest(req, res, next) {
  const { journey_id } = req.params;
  const { locations, location } = req.body;
  const motorista_id = req.user.id; // do JWT
  
  // Validar journey
  const journey = await db.journeys.findOne({
    where: { id: journey_id, driver_id: motorista_id, status: 'active' }
  });
  
  if (!journey) {
    return res.status(400).json({
      success: false,
      error: 'Journey não encontrada ou não está ativa'
    });
  }
  
  // Validar coordenadas
  const pointsToValidate = locations || [location];
  for (const point of pointsToValidate) {
    if (point.latitude < -90 || point.latitude > 90) {
      return res.status(400).json({
        success: false,
        error: 'Latitude inválida'
      });
    }
    if (point.longitude < -180 || point.longitude > 180) {
      return res.status(400).json({
        success: false,
        error: 'Longitude inválida'
      });
    }
  }
  
  next();
}
```

---

## 📊 **PERFORMANCE E OTIMIZAÇÕES**

### **1. Batch Insert**
Quando receber múltiplos pontos, usar INSERT em lote:

```javascript
// Node.js + PostgreSQL exemplo
await db.journeyLocations.bulkCreate(locations, {
  returning: false, // não retornar os registros criados (mais rápido)
  logging: false // desabilitar log de SQL (mais rápido)
});
```

### **2. Índices**
Criar índices para queries comuns:

```sql
-- Para buscar localizações por jornada
CREATE INDEX idx_journey_locations_journey_id ON journey_locations(journey_id);

-- Para buscar por timestamp
CREATE INDEX idx_journey_locations_timestamp ON journey_locations(timestamp);

-- Para queries de range geográfico (se precisar)
CREATE INDEX idx_journey_locations_coords ON journey_locations USING gist (
  ll_to_earth(latitude, longitude)
);
```

### **3. Particionamento (Opcional)**
Se tiver muitos dados, particionar por data:

```sql
-- Particionamento por mês
CREATE TABLE journey_locations_2025_11 PARTITION OF journey_locations
FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');
```

---

## 🔔 **NOTIFICAÇÕES EM TEMPO REAL (OPCIONAL)**

Se quiser notificar dashboards em tempo real quando novos pontos chegarem:

### **WebSocket:**
```javascript
// Após salvar no banco, emitir evento
io.to(`journey:${journey_id}`).emit('location:update', {
  journey_id,
  vehicle_plate: journey.vehicle_plate,
  latitude: location.latitude,
  longitude: location.longitude,
  speed: location.speed,
  timestamp: location.timestamp
});
```

### **Firebase Realtime Database:**
```javascript
// Após salvar no banco, atualizar Firebase
await admin.database()
  .ref(`vehicles/${journey.vehicle_plate}/current`)
  .set({
    latitude: location.latitude,
    longitude: location.longitude,
    speed: location.speed,
    timestamp: location.timestamp
  });
```

---

## 📈 **MÉTRICAS E MONITORAMENTO**

### **Logs importantes:**
```
✅ Localização salva: journey_id=xxx, lat=xxx, lng=xxx, speed=xxx km/h
⚠️ Rate limit excedido: motorista_id=xxx, ip=xxx
❌ Journey não encontrada: journey_id=xxx, motorista_id=xxx
❌ Coordenadas inválidas: lat=xxx, lng=xxx
```

### **Métricas para monitorar:**
- Total de localizações/min
- Latência média de processamento
- Taxa de erro (400/401/500)
- Pontos por jornada (média)
- Tempo entre pontos (média)

---

## 🧪 **TESTE DO ENDPOINT**

### **cURL:**
```bash
curl -X POST https://api.zeca.com/api/v1/journeys/123e4567-e89b-12d3-a456-426614174000/locations \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR..." \
  -H "Content-Type: application/json" \
  -H "x-device-id: 550e8400-e29b-41d4-a716-446655440000" \
  -d '{
    "location": {
      "latitude": -23.550520,
      "longitude": -46.633308,
      "speed": 65.5,
      "heading": 45,
      "altitude": 760,
      "accuracy": 10,
      "timestamp": "2025-11-19T23:45:30.000Z",
      "is_moving": true,
      "odometer": 125050.5
    },
    "journey_id": "123e4567-e89b-12d3-a456-426614174000"
  }'
```

### **Postman Collection:**
Disponibilizar collection do Postman com exemplos de requests.

---

## ❓ **FAQ**

### **1. Qual a frequência de envio?**
- **Movimento:** A cada 30 metros OU a cada 15 segundos
- **Parado:** A cada 5 minutos (heartbeat)
- **Batch:** A cada 5 pontos acumulados

### **2. E se o motorista ficar offline?**
- Pontos ficam salvos localmente no dispositivo (SQLite)
- Quando voltar online, são enviados em batch automaticamente
- Máximo 1000 pontos podem ser armazenados localmente

### **3. Como tratar pontos duplicados?**
- Criar constraint UNIQUE em (journey_id, timestamp, latitude, longitude)
- Ou verificar antes de inserir se já existe ponto muito próximo

### **4. Precisa retornar algo no response?**
- Mínimo: `{ "success": true }`
- Ideal: Incluir total de pontos salvos e KM acumulado

### **5. Como calcular KM percorridos?**
- Usar fórmula de Haversine entre pontos consecutivos
- Ou usar campo `odometer` que já vem do GPS

---

## 📞 **CONTATO**

Dúvidas sobre a integração:
- **Time de Mobile:** [seu email]
- **Documentação:** Este arquivo
- **Exemplo de request:** Ver seção "Teste do Endpoint"

---

**Data de criação:** 2025-11-19  
**Última atualização:** 2025-11-19  
**Versão da API:** v1

