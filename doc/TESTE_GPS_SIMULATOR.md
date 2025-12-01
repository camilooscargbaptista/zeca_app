# 🚗 Guia: Testar GPS Tracking no iOS Simulator

**Data:** 2025-11-28  
**Objetivo:** Simular movimento GPS para testar captura de pontos

---

## 📱 **Pré-requisitos**

1. ✅ App rodando no iPhone 15 Pro Simulator
2. ✅ Journey ativa criada
3. ✅ Console do Cursor aberto (para ver logs)

---

## 🎯 **Opção 1: Script Automático (RECOMENDADO)**

### **Passo a Passo:**

**1. No app iOS, criar nova journey:**
   - Fazer login
   - Ir para Jornadas
   - Preencher: Placa, Odômetro, Destino
   - **Clicar em "Iniciar Viagem"**
   - ⏳ **Aguardar logs de tracking aparecerem**

**2. Observar logs (Console Cursor):**
```
✅ 🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded
✅ 🚀 [Tracking] Iniciando tracking para jornada: {id}
✅ 🚀 [BG-GEO] Iniciando tracking para jornada: {id}
✅ ✅ [BG-GEO] Plugin configurado
✅ ✅ [BG-GEO] Tracking iniciado com sucesso!
```

**3. Em OUTRO terminal, rodar o script:**
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
./simulate_gps_route.sh
```

**4. O script fará:**
   - 📍 Simular 16 pontos GPS
   - ⏱️ 15 segundos entre cada ponto
   - 🚗 Rota: Centro → Vila Tibério (~3km)
   - ⏳ Duração total: ~4 minutos

**5. Observar logs durante simulação:**
```
📍 [BG-GEO Location] Recebido do plugin:
   - Lat/Lng: -21.1710, -47.8095
   - Velocidade: XX km/h
   - Em movimento: true

✅ [BG-GEO] HTTP Success: 201
   Response: {"id": "...", "journey_id": "...", ...}
```

---

## 🎯 **Opção 2: Manual via Xcode Simulator UI**

**Se o script não funcionar, você pode fazer manualmente:**

**1. No Simulator (enquanto app roda):**
   - Menu: **Features** → **Location** → **Custom Location...**
   
**2. Inserir coordenadas manualmente (uma de cada vez):**

| Ordem | Latitude | Longitude | Descrição |
|-------|----------|-----------|-----------|
| 1 | -21.170400 | -47.810300 | Início |
| 2 | -21.171000 | -47.809500 | Ponto 1 |
| 3 | -21.172000 | -47.808200 | Ponto 2 |
| 4 | -21.173000 | -47.807000 | Ponto 3 |
| 5 | -21.174000 | -47.806000 | Ponto 4 |
| 6 | -21.175000 | -47.805000 | Ponto 5 |
| 7 | -21.176000 | -47.804000 | Ponto 6 |
| 8 | -21.177000 | -47.803000 | Ponto 7 |
| 9 | -21.178000 | -47.802000 | Fim |

**3. Aguardar ~20-30 segundos entre cada mudança**

---

## 🎯 **Opção 3: GPX File (Via Xcode)**

**1. Abrir Xcode Simulator:**
```bash
open -a Simulator
```

**2. No Simulator:**
   - Menu: **Features** → **Location**
   - Selecionar: **City Run** (simulação pré-configurada)
   
**OU:**

   - Arrastar arquivo `ribeirao_preto_route.gpx` para o Simulator
   - Simulator usará essa rota automaticamente

---

## 📊 **O que Esperar**

### **Durante a Simulação:**

**Logs Esperados a Cada Ponto:**
```
📍 [BG-GEO Location] Recebido do plugin:
   - Lat/Lng: -21.XXXX, -47.XXXX
   - Velocidade: 0-60 km/h (variável)
   - Em movimento: true
   - Odômetro: XXXXm

✅ [BG-GEO] HTTP Success: 201
```

**Frequência:**
- Plugin captura a cada **30 metros** OU
- A cada **15 segundos** (o que ocorrer primeiro)

### **Após 4 Minutos:**

**No Banco de Dados:**
```sql
SELECT 
  id, 
  journey_id, 
  latitude, 
  longitude, 
  velocidade,
  timestamp,
  created_at
FROM journey_location_points 
WHERE journey_id = '{sua_journey_id}'
ORDER BY created_at DESC;
```

**Resultado Esperado:**
- ✅ **8-16 registros** (depende da captura)
- ✅ Coordenadas variando de -21.170 a -21.178
- ✅ Timestamps crescentes
- ✅ Velocidades calculadas

---

## 🐛 **Troubleshooting**

### **Problema: Script não funciona**
**Solução:**
```bash
# Verificar se device ID está correto
xcrun simctl list devices | grep "iPhone 15 Pro"

# Testar comando manual
xcrun simctl location 2E883348-A1B4-4E3C-9918-272DF8EC84DD "-21.170400,-47.810300"
```

### **Problema: Pontos não são capturados**
**Verificar:**
1. Journey foi iniciada corretamente?
2. Logs de `[BG-GEO] Tracking iniciado` apareceram?
3. Permissão de localização foi concedida?

### **Problema: HTTP 404 ainda aparece**
**Verificar:**
1. Backend está rodando?
2. Token está válido?
3. Endpoint está correto: `/api/journeys/location-point`

---

## ✅ **Checklist de Teste**

- [ ] App rodando no Simulator
- [ ] Journey criada e ativa
- [ ] Logs de tracking apareceram
- [ ] Script de GPS executado (ou manual)
- [ ] Logs de `📍 [BG-GEO Location]` apareceram
- [ ] Logs de `✅ HTTP Success: 201` apareceram
- [ ] Banco de dados consultado
- [ ] **Pontos GPS registrados** ✅

---

## 📝 **Comandos Úteis**

**Definir localização única:**
```bash
xcrun simctl location 2E883348-A1B4-4E3C-9918-272DF8EC84DD "-21.170400,-47.810300"
```

**Resetar localização:**
```bash
xcrun simctl location 2E883348-A1B4-4E3C-9918-272DF8EC84DD "none"
```

**Ver devices disponíveis:**
```bash
xcrun simctl list devices | grep "Booted"
```

---

## 🎯 **Resultado Final Esperado**

**Console:**
- ✅ Logs de tracking iniciado
- ✅ Múltiplos logs de localização recebida
- ✅ HTTP 201 para cada ponto enviado

**Banco de Dados:**
- ✅ Tabela `journey_location_points` populada
- ✅ Múltiplos registros com coordenadas da rota
- ✅ Timestamps sequenciais

**App:**
- ✅ Mapa mostrando rota percorrida
- ✅ Velocidade atualizada
- ✅ Odômetro incrementando

---

**PRONTO PARA TESTE! 🚀**

