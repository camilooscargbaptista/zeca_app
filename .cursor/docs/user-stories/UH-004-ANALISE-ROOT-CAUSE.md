# 🔍 UH-004: Análise Root Cause - Por que `_startTracking` não é chamado?

**Data:** 2025-11-28  
**Status:** 🔍 **ANALISANDO**

---

## 🎯 Problema Principal

`_startTracking` **NÃO é chamado** quando uma journey é criada, resultando em:
- ❌ Nenhum ponto GPS capturado
- ❌ Nenhum dado de rota enviado ao backend
- ❌ Background Geolocation não inicia

---

## 📋 Logs Analisados

### **O que DEVERIA aparecer:**
```
🔍 [JourneyBloc] Prestes a chamar _startTracking após StartJourney
🔍 [Tracking] _startTracking CHAMADO para journey: {id}
🚀 [Tracking] Iniciando tracking para jornada: {id}
🚀 [BG-GEO] Iniciando tracking para jornada: {id}
✅ [BG-GEO] Plugin configurado
✅ [BG-GEO] Tracking iniciado com sucesso!
```

### **O que realmente apareceu:**
```
flutter: ✅ Dados da rota salvos para jornada: 71c49674-fc17...
flutter: ✅ [Journey] Dados da rota salvos após jornada ser iniciada/carregada
flutter: 🗺️ [Journey] Construindo view de jornada ativa
(repetido várias vezes - rebuild de UI)
```

**Conclusão:** Nenhum log de tracking foi gerado! ❌

---

## 🔍 Hipóteses e Análise

### **Hipótese 1: Journey foi carregada do storage, não criada** ✅ **PROVÁVEL**

**Evidência:**
1. Logs mostram apenas "Dados da rota salvos" (ação de UI)
2. Não há logs de API call `POST /journeys/start`
3. Não há logs de `StartJourney` event sendo processado
4. Journey já existia no banco quando testamos

**Fluxo Normal (quando journey é CRIADA):**
```dart
// journey_page.dart:886
context.read<JourneyBloc>().add(StartJourney(...));
  ↓
// journey_bloc.dart:98 - _onStartJourney
emit(JourneyLoading());
  ↓
response = await _apiService.startJourney(...);
  ↓
emit(JourneyLoaded(...));
  ↓
// journey_bloc.dart:156
await _startTracking(journey);  // ✅ DEVERIA SER CHAMADO AQUI
```

**Fluxo quando journey é CARREGADA do storage:**
```dart
// journey_page.dart - initState ou BlocListener
context.read<JourneyBloc>().add(LoadActiveJourney());
  ↓
// journey_bloc.dart:48 - _onLoadActiveJourney
localJourney = _storageService.getActiveJourney();
  ↓
if (localJourney != null) {
  emit(JourneyLoaded(...));
    ↓
  await _startTracking(journey);  // ✅ DEVERIA SER CHAMADO AQUI TAMBÉM
}
```

**O que pode ter acontecido:**
- Journey foi criada em sessão anterior
- App foi reiniciado/rebuilded
- `LoadActiveJourney` carregou journey do storage
- **MAS** `await _startTracking` pode ter falhado silenciosamente

### **Hipótese 2: Erro silencioso no `try/catch`** 🟡 **POSSÍVEL**

```dart
// journey_bloc.dart:480
Future<void> _startTracking(JourneyEntity journey) async {
  try {
    debugPrint('🔍 [Tracking] _startTracking CHAMADO...');  // ❌ NÃO APARECEU!
    // ...
  } catch (e) {
    debugPrint('❌ [Tracking] Erro ao iniciar: $e');  // ❌ NÃO APARECEU TAMBÉM!
    _isTracking = false;
    rethrow;
  }
}
```

**Se o primeiro `debugPrint` NÃO apareceu, significa que:**
- O método `_startTracking` **NÃO foi executado de forma alguma**
- OU há um problema com `await` antes do método ser chamado

### **Hipótese 3: `await` em evento do BLoC não está funcionando** 🔴 **PROVÁVEL**

```dart
// journey_bloc.dart:156
await _startTracking(journey);  // Dentro de um event handler
```

**Problema:** BLoC event handlers são `Future<void>`, mas o `await` pode não estar sendo respeitado se:
- O evento foi adicionado mas não processado antes do app mudar de estado
- Há um race condition entre `emit(JourneyLoaded)` e `_startTracking`
- O listener na UI intercepta `JourneyLoaded` e causa rebuild antes de `_startTracking` terminar

---

## 🐛 Bug Encontrado: Race Condition!

**Código Atual:**
```dart
// journey_bloc.dart:145-156
emit(JourneyLoaded(
  journey: journey,
  tempoDecorridoSegundos: 0,
  kmPercorridos: 0.0,
));

// Iniciar renovação automática de token durante a jornada
_tokenManager.startAutoRefresh();

debugPrint('🔍 [JourneyBloc] Prestes a chamar _startTracking após StartJourney');
await _startTracking(journey);
debugPrint('🔍 [JourneyBloc] _startTracking retornou após StartJourney');
```

**Problema:**
1. `emit(JourneyLoaded)` é chamado **IMEDIATAMENTE**
2. UI recebe `JourneyLoaded` e navega/rebuild
3. `_startTracking` é chamado **DEPOIS**, mas pode ser tarde demais
4. Se o widget foi destruído/recriado, o tracking pode não iniciar

**Solução:** Chamar `_startTracking` **ANTES** de `emit(JourneyLoaded)`

---

## 🔧 Correção Proposta

### **Opção 1: Iniciar tracking ANTES de emitir estado** ✅ **RECOMENDADO**

```dart
// ANTES de emit(JourneyLoaded)
debugPrint('🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded');
await _startTracking(journey);
debugPrint('🔍 [JourneyBloc] Tracking iniciado, agora emitindo JourneyLoaded');

// DEPOIS do tracking ter iniciado
emit(JourneyLoaded(...));
```

**Vantagens:**
- Garante que tracking está ativo quando UI é atualizada
- Elimina race condition
- Logs de tracking aparecem ANTES de UI rebuild

### **Opção 2: Adicionar callback após emit** 🟡 **ALTERNATIVA**

```dart
emit(JourneyLoaded(...));

// Usar addPostFrameCallback para garantir que tracking inicia
WidgetsBinding.instance.addPostFrameCallback((_) {
  _startTracking(journey);
});
```

**Desvantagens:**
- Menos confiável
- Tracking pode iniciar tarde
- Pontos iniciais podem ser perdidos

---

## 🎯 Ação Corretiva

**Implementar Opção 1:**
- Mover `await _startTracking(journey)` para **ANTES** de `emit(JourneyLoaded)`
- Em **TODOS** os lugares onde `JourneyLoaded` é emitido:
  1. `_onStartJourney` (linha 145)
  2. `_onLoadActiveJourney` - local storage (linha 58)
  3. `_onLoadActiveJourney` - backend (linha 78)

---

## 📊 Impacto Esperado

**Antes:**
- ❌ Tracking não inicia
- ❌ Nenhum ponto GPS
- ❌ 0 registros no banco

**Depois:**
- ✅ Tracking inicia imediatamente
- ✅ Ponto inicial capturado
- ✅ Pontos a cada 30m ou 15s
- ✅ Rota completa no banco

---

## ⏳ Status

**Correção:** ⏳ **PENDENTE**  
**Teste:** ⏳ **AGUARDANDO CORREÇÃO**  
**Validação:** ⏳ **AGUARDANDO TESTE**

