# 📱 ESPECIFICAÇÃO DE TELEMETRIA - APP FLUTTER

## 📋 RESUMO

Este documento especifica **quais dados** o app Flutter deve enviar e **quando** enviar para o backend, para implementar as funcionalidades de telemetria da Fase 1.

---

## 🎯 TIPOS DE DADOS A ENVIAR

### 1. **Eventos de Telemetria** (Tempo Real)
- Aceleração brusca
- Frenagem brusca
- Excesso de velocidade
- Alerta de fadiga

### 2. **Paradas** (Início e Fim)
- Início de parada
- Fim de parada

### 3. **Pontos GPS** (Já existe, mas pode ser melhorado)
- Localização, velocidade, timestamp

---

## 📡 QUANDO ENVIAR OS DADOS

### **1. EVENTOS DE TELEMETRIA**

#### **1.1 Aceleração Brusca**
**Quando detectar:**
- Aceleração > 2.5 m/s² (configurável)
- Velocidade > 20 km/h (para evitar falsos positivos em baixa velocidade)

**Dados a enviar:**
```json
{
  "event_type": "HARD_ACCELERATION",
  "severity": 75.5,  // 0-100, calculado baseado na aceleração
  "latitude": -23.550520,
  "longitude": -46.633308,
  "speed_kmh": 65.5,
  "acceleration_ms2": 3.2,  // Aceleração detectada (m/s²)
  "timestamp": "2025-11-19T23:45:30.000Z",
  "location_point_id": "uuid-do-ponto-gps",  // Opcional: relacionar com ponto GPS
  "sensor_data": {  // Opcional: dados brutos para análise
    "accelerometer_x": 0.5,
    "accelerometer_y": 0.3,
    "accelerometer_z": 9.8
  }
}
```

**Cálculo de Severity:**
```dart
// Aceleração de 2.5 m/s² = severity 50
// Aceleração de 5.0 m/s² = severity 100
severity = ((acceleration_ms2 - 2.5) / 2.5) * 100
severity = severity.clamp(0, 100)
```

**Frequência de envio:**
- **Imediato** quando detectado
- **Batch:** Se offline, acumular e enviar quando voltar online (máx 50 eventos)

---

#### **1.2 Frenagem Brusca**
**Quando detectar:**
- Desaceleração > 3.0 m/s² (configurável)
- Velocidade > 20 km/h

**Dados a enviar:**
```json
{
  "event_type": "HARD_BRAKING",
  "severity": 80.0,
  "latitude": -23.550520,
  "longitude": -46.633308,
  "speed_kmh": 45.0,
  "acceleration_ms2": -3.5,  // Negativo = desaceleração
  "timestamp": "2025-11-19T23:45:30.000Z",
  "location_point_id": "uuid-do-ponto-gps",
  "sensor_data": {
    "accelerometer_x": -0.8,
    "accelerometer_y": 0.2,
    "accelerometer_z": 9.8
  }
}
```

**Cálculo de Severity:**
```dart
// Desaceleração de 3.0 m/s² = severity 50
// Desaceleração de 6.0 m/s² = severity 100
final deceleration = acceleration_ms2.abs();
severity = ((deceleration - 3.0) / 3.0) * 100
severity = severity.clamp(0, 100)
```

**Frequência de envio:**
- **Imediato** quando detectado
- **Batch:** Se offline, acumular e enviar quando voltar online

---

#### **1.3 Excesso de Velocidade**
**Quando detectar:**
- Velocidade atual > limite da via
- Verificar limite via API de mapas (Google Maps, OpenStreetMap) ou cache local

**Dados a enviar:**
```json
{
  "event_type": "SPEEDING",
  "severity": 60.0,
  "latitude": -23.550520,
  "longitude": -46.633308,
  "speed_kmh": 85.0,
  "speed_limit_kmh": 60.0,  // Limite da via
  "speed_excess_kmh": 25.0,  // Excesso (85 - 60)
  "timestamp": "2025-11-19T23:45:30.000Z",
  "location_point_id": "uuid-do-ponto-gps",
  "road_type": "urban",  // Opcional: 'highway', 'urban', 'rural'
  "source": "google_maps"  // Fonte do limite de velocidade
}
```

**Cálculo de Severity:**
```dart
// Excesso de 5 km/h = severity 25
// Excesso de 20 km/h = severity 100
final excess = speed_excess_kmh;
if (excess <= 5) {
  severity = (excess / 5) * 25;  // 0-25
} else if (excess <= 20) {
  severity = 25 + ((excess - 5) / 15) * 75;  // 25-100
} else {
  severity = 100;
}
```

**Frequência de envio:**
- **A cada 30 segundos** enquanto estiver acima do limite
- **Não enviar** se já enviou nos últimos 30s para evitar spam
- **Batch:** Se offline, acumular e enviar quando voltar online

---

#### **1.4 Alerta de Fadiga**
**Quando detectar:**
- **FADIGUE_WARNING:** 3.5 horas de direção contínua
- **FATIGUE_CRITICAL:** 4.5 horas de direção contínua OU padrões anômalos de direção

**Dados a enviar:**
```json
{
  "event_type": "FATIGUE_WARNING",  // ou "FATIGUE_CRITICAL"
  "severity": 70.0,
  "latitude": -23.550520,
  "longitude": -46.633308,
  "speed_kmh": 65.5,
  "driving_hours": 3.75,  // Horas de direção contínua
  "timestamp": "2025-11-19T23:45:30.000Z",
  "location_point_id": "uuid-do-ponto-gps",
  "indicators": {  // Indicadores de fadiga detectados
    "speed_variations": 5,  // Variações de velocidade nos últimos 10 min
    "lane_departures": 2,  // Saídas de faixa (se detectável)
    "reaction_time_ms": 850  // Tempo de reação estimado (se detectável)
  }
}
```

**Cálculo de Severity:**
```dart
if (event_type == "FATIGUE_WARNING") {
  // 3.5h = severity 50, 4.0h = severity 100
  severity = ((driving_hours - 3.5) / 0.5) * 50 + 50;
} else {  // FATIGUE_CRITICAL
  // 4.5h = severity 100
  severity = 100;
}
severity = severity.clamp(0, 100);
```

**Frequência de envio:**
- **FATIGUE_WARNING:** A cada 15 minutos após 3.5h
- **FATIGUE_CRITICAL:** Imediato quando detectado
- **Batch:** Se offline, acumular e enviar quando voltar online

---

### **2. PARADAS**

#### **2.1 Início de Parada**
**Quando detectar:**
- Velocidade < 5 km/h por > 30 segundos
- GPS indica que está parado

**Dados a enviar:**
```json
{
  "action": "START",  // ou "END"
  "stop_type": null,  // Será classificado pelo backend ou usuário
  "latitude": -23.550520,
  "longitude": -46.633308,
  "start_timestamp": "2025-11-19T23:45:30.000Z",
  "odometer_km": 125050.5,
  "speed_before_kmh": 65.5,  // Velocidade antes de parar
  "address": "Rua Exemplo, 123 - São Paulo, SP"  // Opcional: via geocoding
}
```

**Frequência de envio:**
- **Imediato** quando detectar parada
- **Não enviar** se já enviou início nos últimos 2 minutos (evitar duplicatas)

---

#### **2.2 Fim de Parada**
**Quando detectar:**
- Após parada iniciada, velocidade > 10 km/h por > 10 segundos

**Dados a enviar:**
```json
{
  "action": "END",
  "stop_id": "uuid-da-parada-iniciada",  // ID retornado pelo backend ao iniciar
  "end_timestamp": "2025-11-19T23:50:30.000Z",
  "speed_after_kmh": 15.0,  // Velocidade após retomar
  "duration_seconds": 300  // Duração calculada (opcional, backend pode calcular)
}
```

**Frequência de envio:**
- **Imediato** quando detectar retomada
- **Fallback:** Se não tiver stop_id, enviar latitude/longitude para backend encontrar

---

### **3. PONTOS GPS** (Melhorias)

**Dados adicionais a incluir (se disponíveis):**
```json
{
  "latitude": -23.550520,
  "longitude": -46.633308,
  "speed": 65.5,
  "heading": 45.0,  // Direção (0-360 graus)
  "altitude": 760.0,  // Metros
  "accuracy": 10.0,  // Precisão em metros
  "timestamp": "2025-11-19T23:45:30.000Z",
  "is_moving": true,
  "sensor_data": {  // Opcional: dados dos sensores
    "accelerometer": {
      "x": 0.5,
      "y": 0.3,
      "z": 9.8
    },
    "gyroscope": {
      "x": 0.1,
      "y": 0.2,
      "z": 0.0
    }
  }
}
```

---

## 🔄 FLUXO DE ENVIO

### **1. Detecção em Tempo Real**

```
Sensores do Celular
    ↓
Detecção de Evento (algoritmo)
    ↓
Armazenar Localmente (SQLite)
    ↓
Tentar Enviar Imediatamente
    ↓
Se Sucesso: Marcar como enviado
Se Falha: Manter local, tentar depois
```

### **2. Envio em Batch**

**Quando enviar batch:**
- A cada **5 eventos** acumulados
- A cada **30 segundos** (se houver eventos pendentes)
- Quando **voltar online** (se estava offline)
- Ao **finalizar jornada**

**Estrutura do batch:**
```json
{
  "journey_id": "uuid-da-jornada",
  "events": [
    { /* evento 1 */ },
    { /* evento 2 */ },
    { /* evento 3 */ }
  ],
  "stops": [
    { /* parada 1 */ },
    { /* parada 2 */ }
  ]
}
```

---

## 📍 ENDPOINTS DA API

### **1. POST** `/api/v1/journeys/:journey_id/telemetry-events`

**Enviar eventos de telemetria (batch ou individual)**

**Request:**
```json
{
  "events": [
    {
      "event_type": "HARD_ACCELERATION",
      "severity": 75.5,
      "latitude": -23.550520,
      "longitude": -46.633308,
      "speed_kmh": 65.5,
      "acceleration_ms2": 3.2,
      "timestamp": "2025-11-19T23:45:30.000Z",
      "location_point_id": "uuid-opcional"
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "events_saved": 1,
    "journey_id": "uuid"
  }
}
```

---

### **2. POST** `/api/v1/journeys/:journey_id/stops`

**Registrar início ou fim de parada**

**Request (Início):**
```json
{
  "action": "START",
  "latitude": -23.550520,
  "longitude": -46.633308,
  "start_timestamp": "2025-11-19T23:45:30.000Z",
  "odometer_km": 125050.5,
  "speed_before_kmh": 65.5
}
```

**Request (Fim):**
```json
{
  "action": "END",
  "stop_id": "uuid-retornado-no-start",
  "end_timestamp": "2025-11-19T23:50:30.000Z",
  "speed_after_kmh": 15.0
}
```

**Response (Início):**
```json
{
  "success": true,
  "data": {
    "stop_id": "uuid-da-parada",
    "journey_id": "uuid"
  }
}
```

**Response (Fim):**
```json
{
  "success": true,
  "data": {
    "stop_id": "uuid-da-parada",
    "duration_seconds": 300
  }
}
```

---

## 🛠️ IMPLEMENTAÇÃO NO APP

### **Estrutura de Pastas:**
```
lib/features/telemetry/
├── domain/
│   ├── entities/
│   │   ├── telemetry_event.entity.dart
│   │   └── journey_stop.entity.dart
│   └── services/
│       ├── telemetry_detection_service.dart
│       └── telemetry_sync_service.dart
├── data/
│   ├── models/
│   │   ├── telemetry_event_model.dart
│   │   └── journey_stop_model.dart
│   └── datasources/
│       ├── telemetry_local_datasource.dart
│       └── telemetry_remote_datasource.dart
└── presentation/
    └── services/
        └── telemetry_service.dart  // Serviço principal
```

### **Serviço Principal:**

```dart
class TelemetryService {
  // Detectar eventos em tempo real
  void startMonitoring(String journeyId);
  
  // Parar monitoramento
  void stopMonitoring();
  
  // Enviar eventos pendentes
  Future<void> syncPendingEvents();
  
  // Detectar paradas
  void detectStops();
}
```

---

## ⚙️ CONFIGURAÇÕES

### **Thresholds (Ajustáveis):**
```dart
class TelemetryConfig {
  // Aceleração
  static const double hardAccelerationThreshold = 2.5; // m/s²
  
  // Frenagem
  static const double hardBrakingThreshold = 3.0; // m/s²
  
  // Velocidade
  static const double speedingCheckInterval = 30.0; // segundos
  
  // Fadiga
  static const double fatigueWarningHours = 3.5; // horas
  static const double fatigueCriticalHours = 4.5; // horas
  
  // Paradas
  static const double stopSpeedThreshold = 5.0; // km/h
  static const double stopDurationThreshold = 30.0; // segundos
  
  // Batch
  static const int batchSize = 5; // eventos
  static const Duration batchInterval = Duration(seconds: 30);
}
```

---

## 📊 RESUMO DE ENVIO

| Tipo de Dado | Quando Enviar | Frequência | Batch |
|--------------|---------------|------------|-------|
| **Aceleração Brusca** | Imediato ao detectar | Event-driven | Sim (se offline) |
| **Frenagem Brusca** | Imediato ao detectar | Event-driven | Sim (se offline) |
| **Excesso Velocidade** | A cada 30s (se acima do limite) | Periódico | Sim (se offline) |
| **Fadiga Warning** | A cada 15min após 3.5h | Periódico | Sim (se offline) |
| **Fadiga Critical** | Imediato ao detectar | Event-driven | Sim (se offline) |
| **Início Parada** | Imediato ao detectar | Event-driven | Sim (se offline) |
| **Fim Parada** | Imediato ao detectar | Event-driven | Sim (se offline) |
| **Pontos GPS** | A cada 30m ou 15s | Periódico | Sim (já existe) |

---

## 🔐 VALIDAÇÕES NO APP

### **Antes de enviar:**
1. ✅ Verificar se jornada está ativa
2. ✅ Validar coordenadas (lat: -90 a 90, lng: -180 a 180)
3. ✅ Validar timestamp (não futuro, não muito antigo)
4. ✅ Validar severity (0-100)
5. ✅ Validar velocidade (>= 0)
6. ✅ Verificar conexão (se offline, salvar local)

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Criar estrutura de pastas no app
2. ✅ Implementar detecção de eventos
3. ✅ Implementar armazenamento local
4. ✅ Implementar sincronização com backend
5. ✅ Integrar com JourneyBloc
6. ✅ Testes unitários e de integração

---

**Data:** 2025-01-XX  
**Versão:** 1.0  
**Status:** Especificação

