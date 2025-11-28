#!/bin/bash

# ═══════════════════════════════════════════════════════════
# 🧪 CURL - Teste Endpoint Location Point
# ═══════════════════════════════════════════════════════════
# Este é o formato EXATO que o app está enviando (aproximado)
# Baseado nos erros de validação recebidos
# ═══════════════════════════════════════════════════════════

# 🔑 Token (substitua com um token válido)
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmMmEzYjRjNS1kNmU3LWY4ZjktZjBmMS1mMmYzZjRmNWY2ZjciLCJ1c2VybmFtZSI6InBlZHJvLm9saXZlaXJhIiwidHlwZSI6ImRyaXZlciIsInJvbGUiOiJNT1RPUklTVEEiLCJwcm9maWxlIjoiQVBQX01PVE9SSVNUQSIsImlzX2RyaXZlciI6dHJ1ZSwiY2FuX2FjY2Vzc19wb3J0YWwiOnRydWUsImNhbl9hY2Nlc3NfYXBwIjp0cnVlLCJjb21wYW55X2lkIjoiMGM3YTA2ZDctMThjMy00YzM0LWE3OGEtZDhmYTIxOWYyYjlmIiwiY29tcGFueV90eXBlIjoiRlJPVEEiLCJjb21wYW55X2NucGoiOiI5OC43NjUuNDMyLzAwMDEtMTAiLCJpYXQiOjE3NjQyOTQxMjAsImV4cCI6MTc2NDMwMTMyMH0.COLE_SEU_TOKEN_VALIDO_AQUI"

# 🎯 ID da Jornada
JOURNEY_ID="ef912076-3ee4-46b9-ad72-99ebdeed1171"

# 📍 Coordenadas
LATITUDE=-21.1704
LONGITUDE=-47.8103
VELOCIDADE=16.7  # m/s (plugin envia em m/s, não km/h!)

# ⏰ Timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

echo "═══════════════════════════════════════════════════════════"
echo "🧪 TESTE ENDPOINT - Location Point"
echo "═══════════════════════════════════════════════════════════"
echo "📡 URL: https://www.abastecacomzeca.com.br/api/v1/journeys/location-point"
echo "📍 Method: POST"
echo "🔑 Token: ${TOKEN:0:50}..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# ─────────────────────────────────────────────────────────────
# O QUE O APP ESTÁ ENVIANDO AGORA (ERRADO - plugin ignora template)
# ─────────────────────────────────────────────────────────────
echo "❌ O QUE O PLUGIN ESTÁ ENVIANDO (ERRADO):"
echo ""
cat << 'JSON1'
{
  "uuid": "abc123...",
  "odometer": 1234.5,
  "extras": {},
  "mock": false,
  "age": 123,
  "timestampMeta": {},
  "event": "motionchange",
  "battery": {"level": 0.9, "is_charging": true},
  "coords": {
    "latitude": -21.1704,
    "longitude": -47.8103,
    "accuracy": 10,
    "altitude": 500,
    "speed": 16.7,
    "heading": 180
  },
  "is_moving": true,
  "activity": {"type": "in_vehicle", "confidence": 100},
  "journey_id": ""
}
JSON1
echo ""
echo "⚠️  Backend rejeita com 400: campos extras não permitidos!"
echo ""
echo "─────────────────────────────────────────────────────────────"
echo ""

# ─────────────────────────────────────────────────────────────
# O QUE O BACKEND ESPERA RECEBER
# ─────────────────────────────────────────────────────────────
echo "✅ O QUE O BACKEND ESPERA RECEBER:"
echo ""
cat << JSON2
{
  "journey_id": "$JOURNEY_ID",
  "latitude": $LATITUDE,
  "longitude": $LONGITUDE,
  "velocidade": $VELOCIDADE,
  "timestamp": "$TIMESTAMP"
}
JSON2
echo ""
echo "─────────────────────────────────────────────────────────────"
echo ""
echo "🚀 Testando com o formato CORRETO..."
echo ""

# ─────────────────────────────────────────────────────────────
# CURL COM O FORMATO CORRETO
# ─────────────────────────────────────────────────────────────
curl -X POST "https://www.abastecacomzeca.com.br/api/v1/journeys/location-point" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "x-device-id: ios-simulator-test" \
  -d "{
    \"journey_id\": \"$JOURNEY_ID\",
    \"latitude\": $LATITUDE,
    \"longitude\": $LONGITUDE,
    \"velocidade\": $VELOCIDADE,
    \"timestamp\": \"$TIMESTAMP\"
  }" \
  -w "\n\n📊 HTTP Status: %{http_code}\n⏱️  Time: %{time_total}s\n" \
  -s | jq . 2>/dev/null || cat

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "📝 NOTAS PARA O TIME DE BACKEND:"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "1. O plugin flutter_background_geolocation está IGNORANDO"
echo "   o locationTemplate e enviando todos os campos internos."
echo ""
echo "2. Campos que o plugin envia (e backend rejeita):"
echo "   - uuid, odometer, extras, mock, age"
echo "   - timestampMeta, event, battery"
echo "   - coords (objeto com latitude, longitude, etc)"
echo "   - is_moving, activity"
echo ""
echo "3. O plugin envia latitude/longitude dentro de 'coords'"
echo "   e não no nível raiz do JSON."
echo ""
echo "4. 'velocidade' vem como 'speed' em m/s (não km/h!)"
echo ""
echo "5. SOLUÇÕES POSSÍVEIS:"
echo "   a) Backend aceitar formato do plugin e mapear campos"
echo "   b) Backend ter endpoint alternativo para o plugin"
echo "   c) App usar HTTP manual ao invés do plugin"
echo ""
echo "═══════════════════════════════════════════════════════════"

