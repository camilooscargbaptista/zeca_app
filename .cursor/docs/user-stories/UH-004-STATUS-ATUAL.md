# 📊 UH-004: Status Atual - Correção em Andamento

**Data:** 2025-11-28  
**Status:** 🔄 **EM CORREÇÃO**

---

## ⚠️ Problema Encontrado Durante Teste

**Erro no App:**
```
BG Geo Template Error
You have an error in your locationTemplate:
"Unknown template variable 'extras.journey_id'"
```

**Screenshot:** Fornecido pelo Camilo

---

## 🔍 Root Cause

O plugin `flutter_background_geolocation` **NÃO suporta** a variável `extras.journey_id` no `locationTemplate`.

**Código Problemático:**
```dart
extras: {
  'journey_id': journeyId,
},

locationTemplate: '{"journey_id":"<%= extras.journey_id %>", ...}'
//                                    ^^^^^^^^^^^^^^^^ NÃO FUNCIONA!
```

---

## ✅ Correção Aplicada

**Simplificação:** Usar apenas `params` (o plugin adiciona automaticamente ao body)

**Código Corrigido:**
```dart
params: {
  'journey_id': journeyId,  // Plugin adiciona ao body automaticamente
},

httpRootProperty: '.',  // Formato JSON correto
// locationTemplate removido - plugin usa formato padrão
```

**Como funciona:**
1. Plugin captura coordenadas GPS
2. Adiciona campos padrão: `latitude`, `longitude`, `speed`, `timestamp`
3. Adiciona campos de `params` ao body: `journey_id`
4. Envia POST para `/api/journeys/location-point`

**Body final esperado:**
```json
{
  "latitude": -21.1704,
  "longitude": -47.8103,
  "speed": 0.0,
  "timestamp": "2025-11-28T...",
  "journey_id": "ad0be7a1-..."
}
```

---

## 🔧 Ações Realizadas

1. **Removido:** `extras` e `locationTemplate`
2. **Mantido:** `params` com `journey_id`
3. **App desinstalado:** Cache do plugin limpo
4. **Rebuild realizado:** Nova versão instalada
5. **Commit:** `84fb8a1`
6. **Push:** Branch atualizada

---

## 📱 Status do Build

**iPhone 15 Pro:**
- ✅ App buildado
- ✅ Rodando
- ✅ Journey ativa carregada: `ad0be7a1-0859-48e9-88fb-e69f2e22bf4f`

**Logs Observados:**
```
flutter: ✅ Dados da rota salvos para jornada: ad0be7a1-...
flutter: 🗺️ [Journey] Construindo view de jornada ativa
```

**Logs AINDA NÃO OBSERVADOS:**
```
❌ 🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded
❌ 🚀 [Tracking] Iniciando tracking para jornada
❌ 🚀 [BG-GEO] Iniciando tracking para jornada
```

---

## 🎯 Próximos Passos

### **Teste Necessário - CAMILO:**

**A journey atual (`ad0be7a1...`) foi carregada do storage, não criada agora.**

**Para ver os logs de tracking, é necessário:**

1. **Finalizar journey atual:**
   - Clicar em "Finalizar"
   - Confirmar

2. **Criar NOVA journey:**
   - Preencher dados
   - Clicar em "Iniciar Viagem"

3. **Observar logs no console:**
   - Logs de `🔍 [JourneyBloc]` devem aparecer
   - Logs de `🚀 [Tracking]` devem aparecer
   - Logs de `🚀 [BG-GEO]` devem aparecer
   - **NÃO deve ter erro de template** ✅

4. **Aguardar captura de pontos:**
   - `📍 [BG-GEO Location] Recebido do plugin`
   - `✅ [BG-GEO] HTTP Success: 201`

5. **Validar banco de dados:**
   ```sql
   SELECT * FROM journey_location_points 
   WHERE journey_id = '{nova_journey_id}'
   ORDER BY created_at DESC;
   ```

---

## 🐛 Problemas Identificados (Total: 3)

| # | Problema | Status |
|---|----------|--------|
| 1 | Endpoint backend incorreto (`/locations` vs `/location-point`) | ✅ CORRIGIDO |
| 2 | Race condition (tracking depois de emit) | ✅ CORRIGIDO |
| 3 | Template variable `extras.journey_id` não suportado | ✅ CORRIGIDO |

---

## 📝 Commits

| Commit | Descrição |
|--------|-----------|
| `c34529a` | Adicionar logs de debug |
| `8a3874e` | Corrigir endpoint `/location-point` |
| `2c67cab` | Corrigir race condition |
| `84fb8a1` | Remover locationTemplate com erro |

**Branch:** `feature/UH-003-navegacao-tempo-real`

---

## ⏳ Aguardando

**CAMILO:**
1. Finalizar journey atual
2. Criar NOVA journey
3. Observar logs de tracking
4. Reportar resultado

**Tempo estimado:** 5 minutos

---

## 🎯 Resultado Esperado

**Sem erro de template:** ✅  
**Tracking inicia:** ✅  
**Pontos capturados:** ✅  
**HTTP 201:** ✅  
**Registros no banco:** ✅

---

**App rodando, aguardando teste com NOVA journey!** 🔄

