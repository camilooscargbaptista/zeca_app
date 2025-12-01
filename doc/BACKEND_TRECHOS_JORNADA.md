# 🚛 Especificação: Trechos de Jornada

## 📋 Sumário

Este documento especifica a funcionalidade de **Trechos de Jornada**, onde cada parada e retomada de direção cria um novo trecho, permitindo análises detalhadas do comportamento do motorista.

---

## 🎯 Objetivo

Dividir uma jornada em **trechos individuais**, onde:
- Cada **trecho** representa um período contínuo de direção (sem paradas para descanso)
- Cada vez que o motorista **inicia descanso**, o trecho atual é **finalizado**
- Cada vez que o motorista **retoma direção**, um **novo trecho** é iniciado

---

## 📊 Modelo de Dados

### Entidade: `JourneySegment` (Trecho de Jornada)

```typescript
interface JourneySegment {
  id: string;                      // UUID único do trecho
  journey_id: string;              // ID da jornada pai
  segment_number: number;          // Número sequencial do trecho (1, 2, 3...)
  
  // Timestamps
  start_time: DateTime;            // Início do trecho (retomada de direção)
  end_time: DateTime | null;       // Fim do trecho (início de descanso ou fim da jornada)
  
  // Localização
  start_latitude: number;          // Coordenadas do ponto inicial
  start_longitude: number;
  end_latitude: number | null;     // Coordenadas do ponto final
  end_longitude: number | null;
  
  // Métricas de percurso
  distance_km: number;             // Distância percorrida neste trecho (km)
  duration_seconds: number;        // Duração total do trecho (segundos)
  
  // Métricas de velocidade
  avg_speed_kmh: number | null;    // Velocidade média do trecho
  max_speed_kmh: number | null;    // Velocidade máxima atingida no trecho
  max_speed_latitude: number | null;   // Onde ocorreu a velocidade máxima
  max_speed_longitude: number | null;
  
  // Contadores
  location_points_count: number;   // Quantidade de pontos GPS capturados
  
  // Metadados
  created_at: DateTime;
  updated_at: DateTime;
}
```

---

## 🔄 Lógica de Negócio

### 1. **Iniciar Jornada**
```
POST /api/v1/journeys

Ação:
✅ Criar registro da jornada
✅ Criar primeiro trecho (segment_number = 1)
✅ Marcar trecho como ativo (end_time = null)
```

### 2. **Capturar Ponto de Localização**
```
POST /api/v1/journeys/{journey_id}/locations

Ação:
✅ Salvar ponto de localização na tabela principal
✅ Atualizar métricas do TRECHO ATIVO:
   - distance_km (somar distância desde último ponto)
   - duration_seconds (diferença entre start_time e agora)
   - avg_speed_kmh (recalcular média)
   - max_speed_kmh (atualizar se for novo máximo)
   - location_points_count (incrementar)
```

### 3. **Iniciar Descanso**
```
POST /api/v1/journeys/{journey_id}/rest/start

Ação:
✅ Marcar jornada como "em descanso"
✅ FINALIZAR TRECHO ATIVO:
   - Definir end_time = agora
   - Definir end_latitude/end_longitude = último ponto capturado
   - Marcar como finalizado
```

### 4. **Retomar Direção**
```
POST /api/v1/journeys/{journey_id}/rest/stop

Ação:
✅ Marcar jornada como "em movimento"
✅ CRIAR NOVO TRECHO:
   - segment_number = último_trecho.segment_number + 1
   - start_time = agora
   - start_latitude/start_longitude = coordenadas atuais
   - end_time = null (trecho ativo)
```

### 5. **Finalizar Jornada**
```
POST /api/v1/journeys/{journey_id}/finish

Ação:
✅ Marcar jornada como finalizada
✅ FINALIZAR TRECHO ATIVO (se houver):
   - Definir end_time = agora
   - Definir end_latitude/end_longitude = último ponto capturado
   - Calcular métricas finais
```

---

## 🌐 Endpoints da API

### 1. **Listar Trechos de uma Jornada**

```http
GET /api/v1/journeys/{journey_id}/segments
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "journey_id": "550e8400-e29b-41d4-a716-446655440000",
    "total_segments": 3,
    "segments": [
      {
        "id": "seg-001",
        "segment_number": 1,
        "start_time": "2024-11-19T08:00:00Z",
        "end_time": "2024-11-19T10:30:00Z",
        "start_latitude": -23.5505,
        "start_longitude": -46.6333,
        "end_latitude": -23.6505,
        "end_longitude": -46.7333,
        "distance_km": 120.5,
        "duration_seconds": 9000,
        "avg_speed_kmh": 48.2,
        "max_speed_kmh": 85.0,
        "max_speed_latitude": -23.6000,
        "max_speed_longitude": -46.7000,
        "location_points_count": 180,
        "created_at": "2024-11-19T08:00:00Z",
        "updated_at": "2024-11-19T10:30:00Z"
      },
      {
        "id": "seg-002",
        "segment_number": 2,
        "start_time": "2024-11-19T11:00:00Z",
        "end_time": "2024-11-19T13:45:00Z",
        "start_latitude": -23.6505,
        "start_longitude": -46.7333,
        "end_latitude": -23.8000,
        "end_longitude": -46.9000,
        "distance_km": 156.8,
        "duration_seconds": 9900,
        "avg_speed_kmh": 57.0,
        "max_speed_kmh": 92.0,
        "max_speed_latitude": -23.7200,
        "max_speed_longitude": -46.8500,
        "location_points_count": 198,
        "created_at": "2024-11-19T11:00:00Z",
        "updated_at": "2024-11-19T13:45:00Z"
      },
      {
        "id": "seg-003",
        "segment_number": 3,
        "start_time": "2024-11-19T14:15:00Z",
        "end_time": null,
        "start_latitude": -23.8000,
        "start_longitude": -46.9000,
        "end_latitude": null,
        "end_longitude": null,
        "distance_km": 45.2,
        "duration_seconds": 2700,
        "avg_speed_kmh": 60.3,
        "max_speed_kmh": 88.0,
        "max_speed_latitude": -23.8500,
        "max_speed_longitude": -46.9500,
        "location_points_count": 54,
        "created_at": "2024-11-19T14:15:00Z",
        "updated_at": "2024-11-19T14:45:00Z"
      }
    ]
  }
}
```

---

### 2. **Obter Detalhes de um Trecho Específico**

```http
GET /api/v1/journeys/{journey_id}/segments/{segment_id}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "seg-001",
    "journey_id": "550e8400-e29b-41d4-a716-446655440000",
    "segment_number": 1,
    "start_time": "2024-11-19T08:00:00Z",
    "end_time": "2024-11-19T10:30:00Z",
    "start_latitude": -23.5505,
    "start_longitude": -46.6333,
    "end_latitude": -23.6505,
    "end_longitude": -46.7333,
    "distance_km": 120.5,
    "duration_seconds": 9000,
    "avg_speed_kmh": 48.2,
    "max_speed_kmh": 85.0,
    "max_speed_latitude": -23.6000,
    "max_speed_longitude": -46.7000,
    "location_points_count": 180,
    
    // Detalhes adicionais
    "summary": {
      "duration_formatted": "02:30:00",
      "distance_formatted": "120.5 km",
      "avg_speed_formatted": "48.2 km/h",
      "max_speed_formatted": "85.0 km/h"
    },
    
    // Pode incluir pontos GPS do trecho (opcional)
    "location_points": [
      {
        "latitude": -23.5505,
        "longitude": -46.6333,
        "timestamp": "2024-11-19T08:00:00Z",
        "speed_kmh": 0
      },
      // ... mais pontos
    ]
  }
}
```

---

### 3. **Obter Resumo de Trechos (Incluído na Finalização)**

Ao finalizar a jornada, o endpoint já existente deve **incluir** os trechos:

```http
POST /api/v1/journeys/{journey_id}/finish

Response:
{
  "success": true,
  "data": {
    "journey": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "status": "FINISHED",
      "data_inicio": "2024-11-19T08:00:00Z",
      "data_fim": "2024-11-19T15:00:00Z",
      "km_percorridos": 322.5,
      "tempo_direcao_segundos": 21600,
      "tempo_descanso_segundos": 3600,
      "velocidade_media": 53.5,
      "velocidade_maxima": 92.0,
      
      // NOVO: Incluir trechos no response
      "segments_summary": {
        "total_segments": 3,
        "segments": [
          {
            "segment_number": 1,
            "distance_km": 120.5,
            "duration_seconds": 9000,
            "avg_speed_kmh": 48.2,
            "max_speed_kmh": 85.0
          },
          {
            "segment_number": 2,
            "distance_km": 156.8,
            "duration_seconds": 9900,
            "avg_speed_kmh": 57.0,
            "max_speed_kmh": 92.0
          },
          {
            "segment_number": 3,
            "distance_km": 45.2,
            "duration_seconds": 2700,
            "avg_speed_kmh": 60.3,
            "max_speed_kmh": 88.0
          }
        ]
      }
    }
  }
}
```

---

## 📱 Como o App irá Consumir

### 1. **Tela de Finalização da Jornada**

O app já recebe o response de finalização. Agora irá:

```dart
// Verificar se há trechos
if (journey.segmentsSummary != null && journey.segmentsSummary.isNotEmpty) {
  // Exibir seção de trechos
  _buildSegmentsList(journey.segmentsSummary);
}
```

### 2. **Nova Tela: Detalhes de Trechos**

Após finalizar, o motorista pode clicar em "Ver Trechos Detalhados":

```dart
// Fazer request para buscar trechos completos
GET /api/v1/journeys/{journey_id}/segments

// Exibir lista de trechos com:
- Número do trecho
- Horário de início e fim
- Distância percorrida
- Duração
- Velocidade média e máxima
```

---

## 🎨 Exemplo de UI no App

### Modal de Finalização (Atualizado)

```
┌─────────────────────────────────────┐
│  ✅ Jornada Finalizada!             │
│                                     │
│  📊 Resumo da Jornada               │
│  ─────────────────────────          │
│  🚗 Distância: 322.5 km             │
│  ⏱️  Tempo de Percurso: 06:00      │
│  😴 Tempo de Descanso: 01:00       │
│  📈 Velocidade Média: 53.5 km/h    │
│  ⚡ Velocidade Máxima: 92.0 km/h   │
│                                     │
│  📍 Trechos Percorridos             │
│  ─────────────────────────          │
│  ▶ Trecho 1: 120.5 km | 02:30      │
│  ▶ Trecho 2: 156.8 km | 02:45      │
│  ▶ Trecho 3: 45.2 km  | 00:45      │
│                                     │
│  [Ver Detalhes dos Trechos]        │
│  [OK]                               │
└─────────────────────────────────────┘
```

### Tela de Detalhes dos Trechos

```
┌─────────────────────────────────────┐
│  ← Trechos da Jornada               │
│                                     │
│  📅 19/11/2024                      │
│  🚛 ABC-1234                        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Trecho 1                 │   │
│  │ ⏰ 08:00 - 10:30 (02:30)   │   │
│  │ 🛣️  120.5 km                │   │
│  │ 📊 Média: 48.2 km/h        │   │
│  │ ⚡ Máxima: 85.0 km/h       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Trecho 2                 │   │
│  │ ⏰ 11:00 - 13:45 (02:45)   │   │
│  │ 🛣️  156.8 km                │   │
│  │ 📊 Média: 57.0 km/h        │   │
│  │ ⚡ Máxima: 92.0 km/h       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Trecho 3                 │   │
│  │ ⏰ 14:15 - 14:45 (00:45)   │   │
│  │ 🛣️  45.2 km                 │   │
│  │ 📊 Média: 60.3 km/h        │   │
│  │ ⚡ Máxima: 88.0 km/h       │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## 🗄️ Schema do Banco de Dados

### Tabela: `journey_segments`

```sql
CREATE TABLE journey_segments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  journey_id UUID NOT NULL REFERENCES journeys(id) ON DELETE CASCADE,
  segment_number INTEGER NOT NULL,
  
  -- Timestamps
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  
  -- Localização
  start_latitude DECIMAL(10, 8) NOT NULL,
  start_longitude DECIMAL(11, 8) NOT NULL,
  end_latitude DECIMAL(10, 8),
  end_longitude DECIMAL(11, 8),
  
  -- Métricas de percurso
  distance_km DECIMAL(10, 2) DEFAULT 0.0,
  duration_seconds INTEGER DEFAULT 0,
  
  -- Métricas de velocidade
  avg_speed_kmh DECIMAL(5, 2),
  max_speed_kmh DECIMAL(5, 2),
  max_speed_latitude DECIMAL(10, 8),
  max_speed_longitude DECIMAL(11, 8),
  
  -- Contadores
  location_points_count INTEGER DEFAULT 0,
  
  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT journey_segment_unique UNIQUE (journey_id, segment_number),
  CONSTRAINT valid_segment_number CHECK (segment_number > 0),
  CONSTRAINT valid_distance CHECK (distance_km >= 0),
  CONSTRAINT valid_duration CHECK (duration_seconds >= 0)
);

-- Índices
CREATE INDEX idx_journey_segments_journey ON journey_segments(journey_id);
CREATE INDEX idx_journey_segments_start_time ON journey_segments(start_time);
CREATE INDEX idx_journey_segments_active ON journey_segments(journey_id) WHERE end_time IS NULL;
```

---

## 🔍 Queries Úteis

### Buscar trecho ativo de uma jornada

```sql
SELECT * FROM journey_segments
WHERE journey_id = $1
  AND end_time IS NULL
LIMIT 1;
```

### Calcular métricas de um trecho

```sql
UPDATE journey_segments
SET 
  distance_km = (
    SELECT COALESCE(SUM(
      ST_Distance(
        ST_MakePoint(prev_long, prev_lat)::geography,
        ST_MakePoint(longitude, latitude)::geography
      ) / 1000
    ), 0)
    FROM location_points
    WHERE journey_id = $1
      AND timestamp >= $2  -- start_time do trecho
      AND timestamp <= COALESCE($3, NOW())  -- end_time ou agora
  ),
  duration_seconds = EXTRACT(EPOCH FROM (COALESCE(end_time, NOW()) - start_time)),
  avg_speed_kmh = (
    SELECT AVG(velocidade)
    FROM location_points
    WHERE journey_id = $1
      AND timestamp >= $2
      AND timestamp <= COALESCE($3, NOW())
  ),
  max_speed_kmh = (
    SELECT MAX(velocidade)
    FROM location_points
    WHERE journey_id = $1
      AND timestamp >= $2
      AND timestamp <= COALESCE($3, NOW())
  )
WHERE id = $4;
```

---

## 📈 Casos de Uso

### Cenário 1: Jornada com 2 Paradas

```
08:00 - Motorista inicia jornada
        → Cria Trecho 1 (ativo)

08:00 - 10:30 - Motorista dirige (Trecho 1)
                Pontos GPS sendo salvos e associados ao Trecho 1

10:30 - Motorista inicia descanso
        → Finaliza Trecho 1
        → distance_km = 120.5 km
        → duration_seconds = 9000 (2:30h)

11:00 - Motorista retoma direção
        → Cria Trecho 2 (ativo)

11:00 - 13:45 - Motorista dirige (Trecho 2)
                Pontos GPS sendo salvos e associados ao Trecho 2

13:45 - Motorista inicia descanso
        → Finaliza Trecho 2
        → distance_km = 156.8 km
        → duration_seconds = 9900 (2:45h)

14:15 - Motorista retoma direção
        → Cria Trecho 3 (ativo)

14:15 - 15:00 - Motorista dirige (Trecho 3)
                Pontos GPS sendo salvos e associados ao Trecho 3

15:00 - Motorista finaliza jornada
        → Finaliza Trecho 3
        → distance_km = 45.2 km
        → duration_seconds = 2700 (0:45h)

RESULTADO FINAL:
✅ 3 Trechos criados
✅ Total: 322.5 km em 06:00 de direção
✅ 2 paradas para descanso (01:00 total)
```

---

## ⚠️ Considerações Importantes

### 1. **Performance**

- Atualizar métricas do trecho ativo a cada ponto GPS pode ser custoso
- **Recomendação:** Atualizar métricas:
  - A cada 10 pontos GPS capturados
  - Ao finalizar o trecho
  - Ao finalizar a jornada

### 2. **Integridade de Dados**

- Garantir que apenas 1 trecho esteja ativo por jornada
- Validar que `segment_number` seja sequencial
- Não permitir deletar trechos após jornada finalizada

### 3. **Histórico**

- Manter trechos mesmo após jornada finalizada (para auditoria)
- Permitir exportar relatórios detalhados por trecho

### 4. **Cálculo de Distância**

O cálculo de distância entre pontos GPS deve usar a fórmula de **Haversine** ou **PostGIS**:

```sql
-- Exemplo com PostGIS
SELECT ST_Distance(
  ST_MakePoint(lng1, lat1)::geography,
  ST_MakePoint(lng2, lat2)::geography
) / 1000 AS distance_km;
```

---

## ✅ Checklist de Implementação

### Backend

- [ ] Criar tabela `journey_segments`
- [ ] Criar índices necessários
- [ ] Atualizar endpoint `POST /journeys` para criar primeiro trecho
- [ ] Atualizar endpoint `POST /journeys/{id}/rest/start` para finalizar trecho
- [ ] Atualizar endpoint `POST /journeys/{id}/rest/stop` para criar novo trecho
- [ ] Atualizar endpoint `POST /journeys/{id}/finish` para incluir `segments_summary`
- [ ] Criar endpoint `GET /journeys/{id}/segments`
- [ ] Criar endpoint `GET /journeys/{id}/segments/{segment_id}`
- [ ] Implementar lógica de atualização de métricas do trecho ativo
- [ ] Implementar testes unitários
- [ ] Implementar testes de integração

### App (Flutter)

- [ ] Criar modelo `JourneySegmentEntity`
- [ ] Atualizar `JourneyEntity` para incluir `segmentsSummary`
- [ ] Atualizar modal de finalização para exibir trechos
- [ ] Criar tela de detalhes dos trechos
- [ ] Implementar API service para buscar trechos
- [ ] Criar widget para exibir card de trecho
- [ ] Implementar navegação para tela de trechos

---

## 🚀 Benefícios da Funcionalidade

1. **Análise Detalhada**: Permite identificar em qual trecho o motorista teve melhor/pior performance
2. **Planejamento de Rotas**: Entender quanto tempo leva cada "perna" da jornada
3. **Segurança**: Detectar comportamentos perigosos em trechos específicos
4. **Compliance**: Validar se os descansos estão sendo feitos nos intervalos corretos
5. **Relatórios**: Gerar relatórios mais ricos para gestores

---

## 📞 Contato

Para dúvidas ou sugestões sobre esta especificação:
- **App Team**: time-app@zeca.com.br
- **Backend Team**: time-backend@zeca.com.br

---

**Documento criado em:** 19/11/2024  
**Última atualização:** 19/11/2024  
**Versão:** 1.0.0

