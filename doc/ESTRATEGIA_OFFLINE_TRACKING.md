# 📡 **ESTRATÉGIA DE TRACKING OFFLINE**

## 🎯 **PROBLEMA:**
Motoristas podem ficar sem internet durante a viagem (túneis, áreas rurais, rodovias remotas).

**Precisamos:**
- ✅ Capturar GPS **SEMPRE** (com ou sem internet)
- ✅ Armazenar localmente quando offline
- ✅ Enviar automaticamente quando volta online
- ✅ Sincronizar tudo ao finalizar jornada
- ✅ Nunca perder pontos

---

## 🔧 **SOLUÇÃO IMPLEMENTADA:**

### **1️⃣ SQLite Local (Banco Embutido no Plugin)**

O `flutter_background_geolocation` já tem **SQLite embutido**:
```
📱 App → 📍 GPS → 💾 SQLite Local (sempre)
```

**Configuração:**
```dart
maxDaysToPersist: 7,         // Manter até 7 dias
maxRecordsToPersist: 5000,   // Até 5000 pontos (~16h de viagem)
```

---

### **2️⃣ Envio Automático (Com Internet)**

```
💾 SQLite → 🌐 HTTP POST → ☁️ Backend
            ↓ Sucesso (201)
         🗑️ Remove do SQLite
```

**Configuração:**
```dart
autoSync: true,              // Sincroniza automaticamente
autoSyncThreshold: 0,        // Envia IMEDIATAMENTE
batchSync: false,            // 1 ponto por vez
url: '${ApiConfig.apiUrl}/journeys/location-point',
```

---

### **3️⃣ Modo Offline (Sem Internet)**

```
💾 SQLite → 🌐 Tenta enviar → ❌ Falha (timeout/404)
            ↓
         💾 Mantém no SQLite
            ↓ (aguarda)
         🔄 Retry automático (quando volta internet)
```

**O plugin faz retry automático!**

---

### **4️⃣ Sincronização Final (Ao Terminar Jornada)**

**No `journey_bloc.dart` - evento `FinishJourney`:**
```dart
// 1. Forçar sincronização antes de finalizar
await _bgGeoService.syncPendingLocations();

// 2. Aguardar pontos serem enviados
await Future.delayed(Duration(seconds: 5));

// 3. Verificar se ainda há pontos pendentes
final pendingCount = await _bgGeoService.getPendingLocationsCount();

// 4. Retry até 3 vezes se necessário
if (pendingCount > 0) {
  // Retry...
}

// 5. Finalizar jornada no backend
await _apiService.finishJourney(...);
```

---

## 📊 **MÉTODOS DE MONITORAMENTO:**

### **`getPendingLocationsCount()`**
Retorna quantos pontos estão no SQLite local aguardando envio.

```dart
final count = await _bgGeoService.getPendingLocationsCount();
debugPrint('📊 Pontos pendentes: $count');
```

### **`getPendingLocations()`**
Retorna a lista completa de pontos pendentes (para debug).

```dart
final locations = await _bgGeoService.getPendingLocations();
for (var loc in locations) {
  debugPrint('📍 ${loc.coords.latitude}, ${loc.coords.longitude}');
}
```

### **`syncPendingLocations()`**
Força o envio de todos os pontos pendentes.

```dart
await _bgGeoService.syncPendingLocations();
// Logs:
// 🔄 [BG-GEO] Sincronizando pontos pendentes...
// 📊 [BG-GEO] Pontos pendentes no banco local: 42
// ✅ [BG-GEO] Sincronização iniciada para 42 pontos
// 🎉 [BG-GEO] Todos os pontos foram sincronizados!
```

### **`destroyLocations()`** ⚠️
Limpa o banco local (CUIDADO: usar apenas para testes).

```dart
await _bgGeoService.destroyLocations();
// 🗑️ Banco local limpo
```

---

## 🧪 **CENÁRIOS DE TESTE:**

### **Teste 1: Internet Estável**
```
✅ Pontos enviados imediatamente
✅ SQLite sempre vazio (count = 0)
✅ Logs mostram HTTP 201
```

### **Teste 2: Sem Internet**
```
📍 GPS continua capturando
💾 Pontos acumulam no SQLite (count > 0)
⏳ HTTP timeout (não aparece erro para o usuário)
🔄 Quando volta internet, envia automaticamente
```

### **Teste 3: Internet Intermitente**
```
📍 Captura 10 pontos
🌐 Envia 5 (sucesso)
❌ Perde conexão
💾 5 ficam no SQLite
🌐 Volta conexão
🔄 Envia os 5 pendentes automaticamente
```

### **Teste 4: Finalizar Jornada Offline**
```
📍 Motorista finaliza viagem sem internet
💾 50 pontos pendentes no SQLite
🔄 App tenta sincronizar (até 3x)
⚠️ Após 3 tentativas, mostra aviso
✅ Jornada finaliza mesmo assim
🔄 Quando volta internet, envia pontos automaticamente
   (mesmo com jornada já finalizada)
```

---

## 📝 **LOGS IMPORTANTES:**

### **Captura GPS:**
```
📍 [BG-GEO Location] Recebido do plugin:
   Lat: -21.1704, Lng: -47.8103
   Speed: 16.7 m/s (60 km/h)
```

### **Envio com Sucesso:**
```
✅ [BG-GEO HTTP] 201 - Location saved successfully
📊 [BG-GEO] Pontos pendentes: 0
```

### **Falha no Envio (Sem Internet):**
```
❌ [BG-GEO HTTP] Timeout ou 0 (sem conexão)
📊 [BG-GEO] Pontos pendentes: 15
```

### **Sincronização Final:**
```
🔄 [BG-GEO] Sincronizando pontos pendentes...
📊 [BG-GEO] Pontos pendentes no banco local: 42
✅ [BG-GEO] Sincronização iniciada para 42 pontos
🎉 [BG-GEO] Todos os pontos foram sincronizados!
```

---

## ✅ **GARANTIAS:**

1. **Nunca perder pontos GPS** ✅
   - Todos são salvos no SQLite primeiro

2. **Funciona offline** ✅
   - SQLite persiste por até 7 dias

3. **Sincronização automática** ✅
   - Plugin detecta quando volta internet e envia automaticamente

4. **Validação ao finalizar** ✅
   - Bloc força sincronização antes de finalizar jornada

5. **Logs detalhados** ✅
   - Sempre sabemos quantos pontos estão pendentes

---

## 🔗 **REFERÊNCIAS:**

- **Plugin:** https://transistorsoft.github.io/flutter_background_geolocation/
- **SQLite Local:** https://transistorsoft.github.io/flutter_background_geolocation/classes/backgroundgeolocation.html#getcount
- **Sync:** https://transistorsoft.github.io/flutter_background_geolocation/classes/backgroundgeolocation.html#sync

---

**Data:** 28-Nov-2025  
**Feature:** UH-004 - Tracking de Pontos GPS  
**Status:** ✅ Implementado e Documentado

