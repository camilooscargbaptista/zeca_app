# 📝 **UH-005: Correção Tracking GPS - HTTP Manual**

**Data Criação:** 28-Nov-2025  
**Prioridade:** 🔴 CRÍTICA  
**Status:** 📋 Planejamento  
**Relacionada:** UH-004 (Tracking GPS)  

---

## 🎯 **OBJETIVO**

Corrigir o envio de pontos GPS para o backend, removendo a dependência do HTTP nativo do plugin `flutter_background_geolocation` e implementando envio manual via Dio.

---

## 📖 **CONTEXTO**

### **Problema Atual:**
O plugin `flutter_background_geolocation` está configurado para enviar dados automaticamente via HTTP (`url` config), mas envia **TODOS os seus campos internos** (uuid, odometer, coords, battery, etc), que o backend **rejeita com 400 Bad Request**.

```json
❌ Plugin envia:
{
  "uuid": "...",
  "coords": { "latitude": -21.1704, "speed": 16.7 },
  "battery": {...},
  "is_moving": true
}

✅ Backend espera:
{
  "journey_id": "uuid",
  "latitude": -21.1704,
  "longitude": -47.8103,
  "velocidade": 60.12,
  "timestamp": "2025-11-28..."
}
```

### **Tentativas Anteriores:**
- ❌ `locationTemplate`: Plugin ignora completamente
- ❌ Modificar backend: Time de backend não pode/deve se adaptar ao plugin
- ✅ **Solução proposta:** HTTP manual (guia do backend)

---

## 👤 **HISTÓRIA DE USUÁRIO**

**Como** motorista  
**Eu quero** que meus pontos GPS sejam enviados corretamente para o backend durante a jornada  
**Para que** minha rota seja rastreada e registrada no sistema

---

## ✅ **CRITÉRIOS DE ACEITE**

### **1. Captura de Localização**
- [ ] Plugin captura pontos GPS a cada 30 metros
- [ ] Plugin funciona em background (app minimizado)
- [ ] Plugin funciona mesmo com app fechado

### **2. Transformação de Dados**
- [ ] Dados do plugin são transformados para formato da API
- [ ] `speed` (m/s) é convertido para `velocidade` (km/h)
- [ ] `journey_id` é incluído em cada ponto
- [ ] Apenas campos necessários são enviados

### **3. Envio para Backend**
- [ ] Pontos são enviados via Dio (HTTP manual)
- [ ] Token JWT é incluído automaticamente
- [ ] Backend retorna **201 Created** (não 400)
- [ ] Erros são tratados sem parar tracking

### **4. Persistência e Retry**
- [ ] Se offline, pontos são enfileirados localmente
- [ ] Quando volta online, pontos são enviados
- [ ] Dio retry policy funciona corretamente

### **5. Validação**
- [ ] Pontos aparecem no banco de dados
- [ ] Mapa do admin mostra rota da jornada
- [ ] Logs mostram envios bem-sucedidos

---

## 🔍 **ANÁLISE DO EXISTENTE**

### **O que JÁ temos:**

#### ✅ **1. Estrutura Base**
```dart
// lib/core/services/background_geolocation_service.dart
- ✅ Classe singleton
- ✅ Listeners configurados (onLocation, onMotionChange, etc)
- ✅ Método startTracking(journeyId)
- ✅ Método stopTracking()
- ✅ Integração com TokenManager
```

#### ✅ **2. Dependências**
```
- ✅ flutter_background_geolocation (plugin)
- ✅ Dio (HTTP client)
- ✅ ApiService (já existe)
- ✅ StorageService (token)
- ✅ GetIt (DI)
```

#### ✅ **3. Fluxo de Jornada**
```dart
// lib/features/journey/presentation/bloc/journey_bloc.dart
- ✅ StartJourney event chama _startTracking()
- ✅ FinishJourney event chama _stopTracking()
- ✅ Integração com BackgroundGeolocationService
```

### **O que precisa MUDAR:**

#### ❌ **1. Config do Plugin**
```dart
// REMOVER (linhas 158-174):
url: '${ApiConfig.apiUrl}/journeys/location-point',  // ❌
locationTemplate: '...',  // ❌
headers: {...},  // ❌
```

#### ✨ **2. ADICIONAR métodos:**
```dart
// NOVO:
- _transformLocationToApi()  // Transformar dados
- _sendLocationPoint()        // Enviar via Dio
```

#### 🔄 **3. ATUALIZAR listener:**
```dart
// MODIFICAR:
void _onLocation(bg.Location location) {
  // ... logs existentes ...
  _sendLocationPoint(location);  // ✨ ADICIONAR esta linha
}
```

---

## 📊 **GAP ANALYSIS**

| **Componente** | **Status Atual** | **Status Desejado** | **Esforço** |
|----------------|------------------|---------------------|-------------|
| Plugin Config | ❌ Com `url` | ✅ SEM `url` | 🟢 Baixo |
| Transformação | ❌ Inexistente | ✅ Implementada | 🟢 Baixo |
| Envio HTTP | ❌ Plugin (quebrado) | ✅ Dio manual | 🟡 Médio |
| Listener | ⚠️ Parcial | ✅ Completo | 🟢 Baixo |
| Retry Policy | ❌ Inexistente | ✅ Implementado | 🟡 Médio |
| Testes | ❌ Inexistente | ✅ Testado | 🟢 Baixo |

**Esforço Total Estimado:** 🟡 **3-4 horas**

**Complexidade:** 🟢 **BAIXA** (80% já existe, só ajustar)

---

## 📋 **TASKS**

### **FASE 1: Preparação** (30 min)
- [ ] **TASK-1:** Ler guia de implementação do backend
- [ ] **TASK-2:** Revisar código existente
- [ ] **TASK-3:** Criar branch: `feature/UH-005-http-manual-tracking`

### **FASE 2: Refatoração** (1h 30min)
- [ ] **TASK-4:** Remover `url`, `locationTemplate`, `headers` da config
- [ ] **TASK-5:** Criar método `_transformLocationToApi()`
- [ ] **TASK-6:** Criar método `_sendLocationPoint()` com Dio
- [ ] **TASK-7:** Atualizar listener `_onLocation()`
- [ ] **TASK-8:** Adicionar tratamento de erros robusto

### **FASE 3: Testes** (1h)
- [ ] **TASK-9:** Build e instalar no simulador
- [ ] **TASK-10:** Iniciar jornada e verificar logs
- [ ] **TASK-11:** Validar: Backend retorna 201 (não 400)
- [ ] **TASK-12:** Validar: Pontos no banco de dados
- [ ] **TASK-13:** Testar em background (app minimizado)
- [ ] **TASK-14:** Testar offline/online

### **FASE 4: Finalização** (30 min)
- [ ] **TASK-15:** Atualizar documentação
- [ ] **TASK-16:** Commit e push
- [ ] **TASK-17:** Merge para main (via Gitflow)

---

## 🧪 **CASOS DE TESTE**

### **TC-1: Envio bem-sucedido**
```
DADO que iniciei uma jornada
QUANDO o GPS captura um ponto
ENTÃO o ponto é transformado corretamente
E é enviado via Dio
E backend retorna 201
E log mostra "✅ Ponto enviado com sucesso"
```

### **TC-2: Conversão de velocidade**
```
DADO que GPS captura speed = 16.7 m/s
QUANDO transforma para API
ENTÃO velocidade = 60.12 km/h (16.7 * 3.6)
```

### **TC-3: Sem journey_id**
```
DADO que tracking não foi iniciado
QUANDO GPS captura um ponto
ENTÃO ponto NÃO é enviado
E log mostra "⚠️ Journey ID não definido"
```

### **TC-4: Token expirado**
```
DADO que token JWT expirou
QUANDO tenta enviar ponto
ENTÃO TokenManager renova token
E requisição é retentada
E ponto é enviado com sucesso
```

### **TC-5: Offline**
```
DADO que estou sem internet
QUANDO GPS captura pontos
ENTÃO pontos são enfileirados localmente (Dio retry)
E quando volta online
ENTÃO pontos são enviados automaticamente
```

---

## 📚 **REFERÊNCIAS**

- **Guia de Implementação:** `zeca_site/.cursor/docs/mobile/GUIA-IMPLEMENTACAO-TRACKING-GPS.md`
- **UH-004:** `UH-004-tracking-pontos-backend.md`
- **Plugin Docs:** https://github.com/transistorsoft/flutter_background_geolocation
- **Backend API:** Swagger em `https://www.abastecacomzeca.com.br/api/docs`

---

## 🎯 **DEFINITION OF DONE**

- [ ] Plugin **NÃO** usa `url` (config limpa)
- [ ] Dados transformados **manualmente** via `_transformLocationToApi()`
- [ ] Envio via **Dio** (não plugin HTTP)
- [ ] Conversão **m/s → km/h** funcionando
- [ ] Token JWT **incluído** automaticamente
- [ ] Backend retorna **201** (não 400)
- [ ] Pontos **salvos no banco**
- [ ] Mapa do admin **mostra rota**
- [ ] Logs **claros e detalhados**
- [ ] Testes **passando**
- [ ] Código **commitado e pushed**
- [ ] Documentação **atualizada**

---

## ✅ **APROVAÇÃO**

- [ ] **Code Review:** Pendente
- [ ] **QA:** Pendente
- [ ] **Tech Lead:** Pendente
- [ ] **Deploy:** Pendente

---

**Criado por:** AI Assistant  
**Baseado em:** Guia do Backend Team  
**Versão:** 1.0

