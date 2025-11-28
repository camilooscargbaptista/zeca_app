# 🐛 UH-004: Problema - Background Geolocation Não Inicia

**Data:** 2025-11-28  
**Status:** 🔍 **EM INVESTIGAÇÃO**  
**Gravidade:** 🔴 **CRÍTICA** - Pontos GPS não são enviados para backend

---

## 🎯 Sintoma Relatado

**Camilo:**
> "a jornada foi criada e esta ativa, porem nao tem ponto nenhum registrado...deveria registrar o ponto inicial, ao iniciar a jornada...e registrar a cada 15 seg ou 100m, nao?"

**Validação no Banco de Dados:**
- ✅ Journey criada: `71c49674-fc17-49d8-9927-03f63cef53e9`
- ✅ Status: `ACTIVE`
- ❌ **Pontos GPS: 0 registros**

---

## 🔍 Investigação Inicial

### **1. Verificação do Código**

**Backend Geolocation Service:**
```dart
// lib/core/services/background_geolocation_service.dart:64
Future<void> startTracking(String journeyId) async {
  // Linha 77: debugPrint('🚀 [BG-GEO] Iniciando tracking...')
  // Linha 87-170: Configuração completa do plugin
  // Linha 177: await bg.BackgroundGeolocation.start();
  // Linha 180: debugPrint('✅ [BG-GEO] Tracking iniciado com sucesso!')
}
```

**Journey BLoC:**
```dart
// lib/features/journey/presentation/bloc/journey_bloc.dart:154
await _startTracking(journey); // Deveria ser chamado após criar journey

// Linha 480-541: Método _startTracking
_isTracking = true;
bg.BackgroundGeolocation.onLocation((location) => { ... });
await _bgGeoService.startTracking(journey.id);
```

**Journey Page:**
```dart
// lib/features/journey/presentation/pages/journey_page.dart:886
context.read<JourneyBloc>().add(
  StartJourney(/* ... */),
); // ✅ Chama BLoC corretamente
```

### **2. Análise dos Logs**

**Logs Esperados (NÃO encontrados):**
```
❌ 🚀 [Tracking] Iniciando tracking para jornada: {id}
❌ 🚀 [BG-GEO] Iniciando tracking para jornada: {id}
❌ ✅ [BG-GEO] Plugin configurado
❌ ✅ [BG-GEO] Tracking iniciado com sucesso!
❌ 📍 [BG-GEO Location] Recebido do plugin
```

**Logs Encontrados:**
```
✅ ✅ Dados da rota salvos para jornada: 71c49674-fc17...
✅ ✅ [Journey] Dados da rota salvos após jornada ser iniciada/carregada
✅ 🗺️ [Journey] Construindo view de jornada ativa
```

**Conclusão:**
- Journey foi criada ✅
- Rota foi salva ✅
- **Background Geolocation NÃO foi iniciado** ❌

---

## 💡 Hipóteses

### **Hipótese 1: `_startTracking` não está sendo chamado**
**Probabilidade:** 🔴 **ALTA**

**Evidência:**
- Nenhum log de `[Tracking]` ou `[BG-GEO]` encontrado
- O método `_startTracking` deveria imprimir logs na linha 487

**Causa Possível:**
- Evento `StartJourney` não está sendo processado corretamente
- Ou `_startTracking` está falhando antes do primeiro `debugPrint`
- Ou há erro silencioso no `try/catch`

### **Hipótese 2: Journey carregada do storage, não criada**
**Probabilidade:** 🟡 **MÉDIA**

**Evidência:**
- Journey já existia quando app foi reiniciado
- Logs mostram "Dados da rota salvos" repetidamente (rebuild de UI)
- Não há log de "Journey iniciada" ou "API call success"

**Causa Possível:**
- App carregou journey existente do storage local
- Evento `LoadActiveJourney` pode ter lógica diferente
- `_startTracking` pode não ter sido chamado ao carregar do storage

### **Hipótese 3: Erro silencioso no `try/catch`**
**Probabilidade:** 🟡 **MÉDIA**

**Causa Possível:**
- `_startTracking` é chamado mas falha imediatamente
- `catch (e)` captura erro mas não o registra em log
- Ou `rethrow` não está funcionando

---

## 🔧 Ações de Debug Aplicadas

### **1. Logs Adicionados**

**Commit:** `c34529a`

```dart
// journey_bloc.dart:_startTracking (linha 480)
debugPrint('🔍 [Tracking] _startTracking CHAMADO para journey: ${journey.id}');
debugPrint('🔍 [Tracking] _isTracking atual: $_isTracking');

// journey_bloc.dart:_onStartJourney (linha 156)
debugPrint('🔍 [JourneyBloc] Prestes a chamar _startTracking após StartJourney');
await _startTracking(journey);
debugPrint('🔍 [JourneyBloc] _startTracking retornou após StartJourney');

// journey_bloc.dart:_onLoadActiveJourney (linhas 67 e 87)
debugPrint('🔍 [JourneyBloc] Prestes a chamar _startTracking após LoadActiveJourney');
await _startTracking(journey);
debugPrint('🔍 [JourneyBloc] _startTracking retornou após LoadActiveJourney');
```

### **2. Build Reiniciado**
- iOS Simulator reiniciado com código atualizado
- ❌ Logs de debug (`🔍`) NÃO aparecem ainda
- Journey existente foi carregada (71c49674...)

---

## 🎯 Próximos Passos

### **Teste Necessário:**

**CAMILO, por favor:**

1. **Finalizar a journey atual no app**
   - Clicar em "Finalizar Viagem"
   - Confirmar

2. **Iniciar uma NOVA journey**
   - Preencher placa, odômetro, destino
   - Clicar em "Iniciar Viagem"

3. **Observar os logs no console do Cursor**
   - Procurar por logs com `🔍 [JourneyBloc]`
   - Procurar por logs com `🚀 [Tracking]`
   - Procurar por logs com `🚀 [BG-GEO]`

4. **Reportar o que aparece**

---

## 📊 Status Atual

| Item | Status |
|------|--------|
| URL Backend corrigida | ✅ |
| Código de tracking existe | ✅ |
| Logs de debug adicionados | ✅ |
| iOS build rodando | ✅ |
| Journey ativa | ✅ |
| **Background Geolocation iniciado** | ❌ |
| **Pontos GPS no banco** | ❌ |

---

## ⏳ Aguardando

**Camilo finalizar journey atual e iniciar nova para ver logs de debug.**

Uma vez que identifiquemos onde o `_startTracking` está falhando, podemos corrigir e validar.

