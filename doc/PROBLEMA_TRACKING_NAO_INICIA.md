# 🔴 PROBLEMA CRÍTICO: Tracking Nunca Inicia

**Data:** 2025-11-28  
**Journey ID:** `0e23f344-26f3-4797-b4c1-a9d9b0346cad`

---

## ❌ **PROBLEMA:**

**Background Geolocation NUNCA é iniciado**, mesmo após:
1. ✅ Código corrigido (race condition)
2. ✅ Endpoint correto
3. ✅ Nova journey criada
4. ✅ App rebuilded múltiplas vezes

**Resultado:** 0 pontos GPS salvos no banco

---

## 📊 **EVIDÊNCIAS:**

### **Logs Ausentes:**
```
❌ 🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded
❌ 🚀 [Tracking] Iniciando tracking para jornada
❌ 🚀 [BG-GEO] Iniciando tracking para jornada
❌ ✅ [BG-GEO] Plugin configurado
❌ 📍 [BG-GEO Location] Recebido do plugin
❌ ✅ HTTP Success: 201
```

### **Logs Presentes:**
```
✅ 📍 [Navigation] Nova posição: -21.174, -47.806
✅ 🗺️ [Journey] Construindo view de jornada ativa
✅ ✅ Dados da rota salvos para jornada: 0e23f344...
```

**Conclusão:** GPS simula está funcionando, app detecta posição, **MAS tracking nunca inicia**.

---

## 🔍 **ROOT CAUSE PROVÁVEL:**

### **Hot Reload/Rebuild não aplicou mudanças críticas**

Mudanças que fizemos:
```dart
// ANTES (código antigo ainda rodando?):
emit(JourneyLoaded(...));     // ← UI atualiza
await _startTracking(journey); // ← Nunca executa (perdido)

// DEPOIS (código correto commitado):
await _startTracking(journey); // ← PRIMEIRO
emit(JourneyLoaded(...));      // ← DEPOIS
```

**Problema:** App pode estar com código antigo em cache!

---

## ✅ **SOLUÇÃO DEFINITIVA:**

### **1. BUILD LIMPO COMPLETO**

```bash
# 1. Parar tudo
pkill -f "flutter run"

# 2. Limpar completamente
flutter clean
cd ios && pod deintegrate && pod install && cd ..

# 3. Desinstalar app do simulador
xcrun simctl uninstall 2E883348-A1B4-4E3C-9918-272DF8EC84DD com.zeca.app

# 4. Build fresco
flutter run -d 2E883348-A1B4-4E3C-9918-272DF8EC84DD
```

### **2. Validar Código Fonte**

Verificar se arquivo realmente tem:
```dart
// journey_bloc.dart - _onStartJourney (linha ~145-156)
await _startTracking(journey);  // ← Esta linha DEVE estar ANTES de emit
emit(JourneyLoaded(...));
```

---

## 🎯 **TESTE DEFINITIVO:**

Após build limpo:

1. **Login**
2. **Criar NOVA journey**
3. **Console DEVE mostrar:**
```
✅ 🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded
✅ 🚀 [Tracking] Iniciando tracking para jornada: {id}
✅ 🚀 [BG-GEO] Iniciando tracking para jornada: {id}
✅ ✅ [BG-GEO] Plugin configurado
✅ ✅ [BG-GEO] Tracking iniciado com sucesso!
```

4. **Simular GPS**
5. **Logs DEVEM mostrar:**
```
✅ 📍 [BG-GEO Location] Recebido do plugin: lat, lon, speed
✅ ✅ [BG-GEO] HTTP Success: 201
```

6. **Banco DEVE ter registros:**
```sql
SELECT COUNT(*) FROM journey_location_points 
WHERE journey_id = '{nova_journey_id}';
-- Resultado: > 0
```

---

## ⚠️ **ALTERNATIVA: Verificar se correção foi mesmo aplicada**

É possível que a correção do race condition NÃO tenha sido aplicada corretamente ou foi revertida.

Vou verificar o arquivo atual:
```bash
grep -A10 "emit(JourneyLoaded" lib/features/journey/presentation/bloc/journey_bloc.dart
```

Se `await _startTracking` estiver DEPOIS de `emit`, precisamos corrigir novamente!

---

## 📝 **PRÓXIMA AÇÃO:**

**CAMILO:** Preciso fazer um **build completamente limpo** para garantir que o código correto está rodando.

Isso levará ~2-3 minutos mas garantirá que tudo funcione.

**Posso prosseguir com flutter clean + rebuild?**

