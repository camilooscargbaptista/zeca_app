# 📍 UH-004: Correção do Envio de Pontos GPS para Backend

**Status:** 📋 **PLANEJADA**  
**Prioridade:** 🔴 **ALTA** (bloqueia rastreamento no frota)  
**Estimativa:** 2 horas  
**Depende de:** UH-003 (concluída)

---

## 📝 História de Usuário

**Como** gerente de frota  
**Quero** visualizar a rota percorrida pelos motoristas em tempo real no sistema web  
**Para** monitorar viagens, validar rotas e identificar desvios

---

## 🐛 Problema Identificado

### **Sintoma:**
- Pontos GPS são capturados localmente no app ✅
- Pontos **NÃO** chegam ao backend ❌
- Erro 404 ao tentar enviar

### **Causa Raiz:**
URL duplicada na configuração do `flutter_background_geolocation`:

**URL Atual (ERRADA):**
```
/api/v1/api/v1/journeys/{journeyId}/locations
         ^^^^^^^^ DUPLICADO!
```

**URL Esperada (CORRETA):**
```
/api/v1/journeys/{journeyId}/locations
```

### **Onde ocorre:**
**Arquivo:** `lib/core/services/background_geolocation_service.dart`  
**Linha:** 113

```dart
url: '${ApiConfig.apiUrl}/api/v1/journeys/$journeyId/locations',
//    ^^^^^^^^^^^^^^^^ já contém /api/v1
//                     ^^^^^^^^ duplicado!
```

### **Logs do Erro:**
```
❌ [BG-GEO] HTTP Error: 404
   path: "/api/v1/api/v1/journeys/b2c46e68-.../locations"
   message: "Cannot POST /api/v1/api/v1/journeys/.../locations"
```

---

## ✅ Solução Proposta

### **Correção:**

```dart
// ❌ ANTES (errado):
url: '${ApiConfig.apiUrl}/api/v1/journeys/$journeyId/locations',

// ✅ DEPOIS (correto):
url: '${ApiConfig.apiUrl}/journeys/$journeyId/locations',
//   remove o /api/v1 duplicado ^^^^
```

### **Validação:**

Após correção, verificar logs:
```
✅ [BG-GEO] HTTP Success: 201
   Response: {"id": "...", "journey_id": "...", "created_at": "..."}
```

---

## 🎯 Critérios de Aceite

### **Funcional:**
- [ ] Pontos GPS são enviados ao backend sem erro 404
- [ ] Backend responde com status 201 (Created)
- [ ] Pontos aparecem no sistema web do frota
- [ ] Rota é traçada corretamente no mapa do frota

### **Técnico:**
- [ ] URL não está duplicada
- [ ] Logs mostram `HTTP Success: 201`
- [ ] `autoSync` funciona corretamente (a cada 5 pontos)
- [ ] `batchSync` envia lotes sem erro

### **Performance:**
- [ ] Pontos são enviados em lotes (máx 50)
- [ ] Não há reenvio desnecessário de pontos já sincronizados
- [ ] SQLite local limpa pontos antigos (>7 dias)

---

## 🧪 Casos de Teste

### **Teste 1: Envio Básico**
1. Iniciar viagem no app
2. Dirigir por 1-2 minutos (capturar 5+ pontos)
3. Verificar logs: `✅ HTTP Success: 201`
4. Abrir sistema web do frota
5. Validar que a rota aparece no mapa

### **Teste 2: Sincronização em Lote**
1. Iniciar viagem
2. Dirigir por 5 minutos (capturar 50+ pontos)
3. Verificar que pontos são enviados em lotes de 50
4. Validar performance (não trava app)

### **Teste 3: Recuperação de Falha**
1. Desligar WiFi/dados no device
2. Dirigir por 2 minutos (pontos ficam locais)
3. Religar WiFi/dados
4. Verificar que pontos pendentes são sincronizados

### **Teste 4: Limpeza de Cache**
1. Manter pontos locais por 8 dias
2. Verificar que pontos >7 dias são removidos do SQLite

---

## 📋 Tasks de Implementação

### **1. Correção da URL** (30min)
- [x] Identificar local da duplicação
- [ ] Remover `/api/v1` duplicado
- [ ] Testar localmente
- [ ] Verificar logs

### **2. Validação no Backend** (30min)
- [ ] Confirmar que endpoint `/api/v1/journeys/:id/locations` existe
- [ ] Verificar autenticação (JWT)
- [ ] Testar com Postman/cURL
- [ ] Validar response schema

### **3. Teste Integrado** (1h)
- [ ] Build no iOS
- [ ] Build no Android
- [ ] Iniciar viagem real
- [ ] Verificar sincronização
- [ ] Validar no sistema web

---

## 🔗 Dependências

### **Backend:**
- ✅ Endpoint `POST /api/v1/journeys/:id/locations` implementado
- ✅ Autenticação JWT funcional
- ✅ Sistema web com mapa de rastreamento

### **App:**
- ✅ `flutter_background_geolocation` configurado
- ✅ GPS capturando pontos localmente
- ✅ Token JWT disponível

---

## 📊 Impacto

### **Sem a correção:**
- ❌ Gerente de frota não vê rotas em tempo real
- ❌ Impossível validar se motorista seguiu rota
- ❌ Dados GPS ficam apenas no device
- ❌ Perda de dados se app for desinstalado

### **Com a correção:**
- ✅ Rastreamento em tempo real
- ✅ Histórico de rotas
- ✅ Validação de desvios
- ✅ Backup de dados no servidor

---

## 🚀 Estratégia de Rollout

### **Fase 1: Correção e Teste** (Dev)
1. Aplicar correção
2. Testar em 2 devices (iOS + Android)
3. Validar com backend de dev

### **Fase 2: Validação** (Staging)
1. Deploy em staging
2. Teste com 3 motoristas piloto
3. Monitorar logs por 1 dia

### **Fase 3: Produção**
1. Deploy via Firebase/TestFlight
2. Rollout gradual (10% → 50% → 100%)
3. Monitorar dashboards

---

## 📚 Documentação Relacionada

- `BACKEND_API_LOCATIONS.md` - Especificação do endpoint
- `IMPLEMENTACAO_BACKGROUND_GEO_COMPLETA.md` - Configuração do plugin
- `TELEMETRIA_APP_SPECIFICATION.md` - Especificação geral de telemetria

---

## ✅ Definition of Done

- [ ] Código corrigido e testado
- [ ] Logs mostram HTTP 201 (não mais 404)
- [ ] Pontos aparecem no sistema web
- [ ] Testes passam em iOS e Android
- [ ] Code review aprovado
- [ ] Documentação atualizada
- [ ] Merged na `main`

---

**Criado em:** 2025-11-27  
**Descoberto durante:** UH-003 - Navegação Tempo Real  
**Análise por:** AI Assistant

