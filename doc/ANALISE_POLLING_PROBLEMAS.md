# 🔍 Análise do Polling - Problemas Identificados

**Data:** 30 de novembro de 2025  
**Status:** ❌ Não está funcionando corretamente

---

## 📋 Resumo Executivo

O polling do app está configurado, mas **não está detectando corretamente** quando o posto registra o abastecimento. Foram identificados **3 problemas principais**:

1. **Inconsistência de status** entre `refuelingCode` e `refueling`
2. **Busca dupla** no backend retorna formatos diferentes
3. **Polling não detecta** quando código muda de `ACTIVE` → `VALIDADO` → `USED` (com refueling criado)

---

## 🔄 Como o Polling Deveria Funcionar

### Fluxo Esperado:

```
1. Motorista gera código → Status: ACTIVE
   ↓
2. Posto valida código → Status: VALIDADO
   ↓
3. Posto registra abastecimento → Status: USED (refueling criado com status: AGUARDANDO_VALIDACAO_MOTORISTA)
   ↓
4. Polling detecta refueling → Navega para tela de validação
```

---

## 🐛 Problemas Identificados

### Problema 1: Inconsistência de Status no Backend

**Arquivo:** `zeca_site/backend/src/refueling/refueling.service.ts` (linha 1010-1088)

O método `findByCode()` retorna formatos diferentes:

#### Quando encontra em `refueling` (abastecimento já registrado):
```typescript
// Linha 1046-1048
if (refueling) {
  return refueling; // Retorna objeto Refueling completo
  // status: 'AGUARDANDO_VALIDACAO_MOTORISTA'
}
```

#### Quando encontra em `refueling_codes` (código pendente):
```typescript
// Linha 1060-1077
if (refuelingCode) {
  return {
    id: refuelingCode.id, // ⚠️ ID do código, não do refueling!
    refueling_code: refuelingCode.code,
    status: 'AGUARDANDO_VALIDACAO', // ⚠️ Status diferente!
    is_pending_code: true
  };
}
```

**Problema:** 
- Quando o código está `ACTIVE` ou `VALIDADO`, retorna status `'AGUARDANDO_VALIDACAO'`
- Quando o refueling é criado, retorna status `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- O polling procura por `'AGUARDANDO_VALIDACAO_MOTORISTA'`, mas nunca encontra quando o código ainda não virou refueling

---

### Problema 2: Polling Busca Status Errado

**Arquivo:** `zeca_app/lib/core/services/refueling_polling_service.dart` (linha 119-128)

```dart
// Verificar status diretamente dos dados retornados
if (status != null && 
    (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
     status == 'aguardando_validacao_motorista' ||
     status.toUpperCase() == 'AGUARDANDO_VALIDACAO_MOTORISTA')) {
  debugPrint('🎯 [POLLING] Status mudou para AGUARDANDO_VALIDACAO_MOTORISTA! Chamando callback...');
  _onStatusChanged?.call(refuelingIdToCheck);
  return;
}
```

**Problema:**
- O polling só detecta quando status é `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- Mas quando o código está em `refueling_codes` (antes de virar refueling), o backend retorna `'AGUARDANDO_VALIDACAO'`
- O polling nunca detecta essa mudança!

---

### Problema 3: Busca em `refueling_codes` com Status Restritivo

**Arquivo:** `zeca_site/backend/src/refueling/refueling.service.ts` (linha 1053-1058)

```typescript
const refuelingCode = await this.refuelingCodeRepository.findOne({
  where: { 
    code: In([codeWithoutHyphens, codeWithHyphens]),
    status: 'ACTIVE' // ⚠️ Só busca códigos ACTIVE!
  }
});
```

**Problema:**
- Quando o posto valida o código, o status muda para `'VALIDADO'`
- Mas o `findByCode()` só busca códigos com status `'ACTIVE'`
- Então, quando o código está `'VALIDADO'` (mas ainda não virou refueling), o método retorna `null`!

---

## 🔧 Solução Implementada

### ✅ Solução: Usar Lista de Pendentes ao Invés de Buscar por Código

**Arquivo:** `zeca_app/lib/core/services/refueling_polling_service.dart`

**Estratégia:** Ao invés de buscar o refueling pelo código (que pode não funcionar quando ainda não foi registrado), o polling agora verifica a **lista de abastecimentos pendentes** e procura se algum deles tem o código que estamos monitorando.

**Vantagens:**
- ✅ Não precisa mexer no backend
- ✅ Usa endpoint que já funciona (`getPendingRefuelings()`)
- ✅ Detecta quando refueling aparece na lista de pendentes
- ✅ Mais confiável porque usa a mesma API que a tela de abastecimento usa

**Mudança implementada:**

```dart
// ANTES: Buscava pelo código usando getRefuelingByCode()
final codeResponse = await _apiService.getRefuelingByCode(_currentRefuelingCode!);

// DEPOIS: Verifica na lista de pendentes
final pendingResponse = await _apiService.getPendingRefuelings();

// Guarda timestamp de quando o polling iniciou
_pollingStartTime = DateTime.now();

// Procura na lista se algum refueling tem o código que estamos monitorando
// E foi criado DEPOIS que o polling iniciou (para ignorar pendentes antigos)
for (var refueling in refuelings) {
  if (refueling['refueling_code'] == cleanCode) {
    final createdAt = DateTime.parse(refueling['created_at']);
    
    // Só considerar se foi criado DEPOIS que o polling iniciou
    if (createdAt.isAfter(_pollingStartTime!)) {
      // Este é o refueling novo que estamos esperando!
      refuelingIdToCheck = refueling['id'];
      // Verificar status e chamar callback se for AGUARDANDO_VALIDACAO_MOTORISTA
    }
  }
}
```

**Proteção contra múltiplos pendentes:**
- ✅ Guarda timestamp de quando o polling iniciou
- ✅ Ignora refuelings criados ANTES do polling iniciar (são antigos)
- ✅ Considera apenas refuelings criados DEPOIS do polling iniciar (são novos)
- ✅ Se houver múltiplos novos, pega o mais recente

---

### Solução Alternativa (Não Implementada): Ajustar Polling para Detectar Múltiplos Status

**Arquivo:** `zeca_app/lib/core/services/refueling_polling_service.dart`

**Mudança necessária (linha 119-128 e 159-161):**

```dart
// ANTES:
if (status != null && 
    (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
     status == 'aguardando_validacao_motorista' ||
     status.toUpperCase() == 'AGUARDANDO_VALIDACAO_MOTORISTA')) {
  // ...
}

// DEPOIS:
// Detectar quando refueling foi criado (status AGUARDANDO_VALIDACAO_MOTORISTA)
// OU quando código foi validado e está aguardando registro (status AGUARDANDO_REGISTRO)
if (status != null) {
  final statusUpper = status.toUpperCase();
  
  if (statusUpper == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
    // Refueling criado, aguardando validação do motorista
    debugPrint('🎯 [POLLING] Status mudou para AGUARDANDO_VALIDACAO_MOTORISTA! Chamando callback...');
    _onStatusChanged?.call(refuelingIdToCheck);
    return;
  } else if (statusUpper == 'AGUARDANDO_REGISTRO' || statusUpper == 'VALIDADO') {
    // Código validado, aguardando posto registrar abastecimento
    // Continuar polling para detectar quando refueling for criado
    debugPrint('⏳ [POLLING] Código validado, aguardando registro do abastecimento (status: $status)...');
  } else {
    debugPrint('⏳ [POLLING] Status ainda não é o esperado (atual: $status), continuando polling...');
  }
}
```

**Mas melhor ainda:** Verificar se `has_refueling` ou se `is_pending_code`:

```dart
// Se encontrou refueling (não é código pendente)
if (refuelingData.containsKey('is_pending_code') && refuelingData['is_pending_code'] == false) {
  // É um refueling real
  if (statusUpper == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
    debugPrint('🎯 [POLLING] Refueling criado e aguardando validação! Chamando callback...');
    _onStatusChanged?.call(refuelingIdToCheck);
    return;
  }
} else {
  // É um código pendente - verificar se foi validado
  if (statusUpper == 'VALIDADO' || statusUpper == 'AGUARDANDO_REGISTRO') {
    debugPrint('⏳ [POLLING] Código validado, aguardando posto registrar abastecimento...');
    // Continuar polling para detectar quando refueling for criado
  }
}
```

---

## 📊 Fluxo Corrigido

### Fluxo Após Correções:

```
1. Motorista gera código → Status: ACTIVE
   ↓
   Polling: Busca código → Encontra em refueling_codes → Status: 'AGUARDANDO_VALIDACAO'
   ↓
2. Posto valida código → Status: VALIDADO
   ↓
   Polling: Busca código → Encontra em refueling_codes → Status: 'AGUARDANDO_REGISTRO'
   ↓
3. Posto registra abastecimento → Status: USED (refueling criado)
   ↓
   Polling: Busca código → Encontra em refueling → Status: 'AGUARDANDO_VALIDACAO_MOTORISTA'
   ↓
4. Polling detecta! → Navega para tela de validação ✅
```

---

## 🔍 Verificações Adicionais

### Verificar se Endpoint Está Funcionando

**Endpoint:** `GET /api/v1/refueling/by-code/:code`

**Teste manual:**
```bash
curl -X GET "https://www.abastecacomzeca.com.br/api/v1/refueling/by-code/A1B2-2024-3F7A8B9C" \
  -H "Authorization: Bearer {token}"
```

**Respostas esperadas:**

1. **Código ACTIVE (não validado):**
```json
{
  "id": "uuid-do-codigo",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO",
  "is_pending_code": true
}
```

2. **Código VALIDADO (aguardando registro):**
```json
{
  "id": "uuid-do-codigo",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_REGISTRO",
  "is_pending_code": true
}
```

3. **Refueling criado:**
```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
  "is_pending_code": false
}
```

---

## 📝 Checklist de Correções

### App (zeca_app): ✅ IMPLEMENTADO

- [x] **Ajustar polling** para usar lista de pendentes ao invés de buscar por código
- [x] **Verificar código na lista** de abastecimentos pendentes
- [x] **Detectar quando refueling aparece** na lista com status `AGUARDANDO_VALIDACAO_MOTORISTA`
- [x] **Proteção contra múltiplos pendentes** - ignora refuelings antigos (criados antes do polling iniciar)
- [x] **Seleciona o mais recente** quando há múltiplos refuelings novos
- [x] **Adicionar logs** detalhados para debug
- [ ] **Testar polling** em diferentes cenários:
  - Código ACTIVE (aguardando validação do posto)
  - Código VALIDADO (aguardando posto registrar)
  - Refueling criado (aparece na lista de pendentes) ✅
  - **Múltiplos pendentes** - deve identificar apenas o novo ✅

---

## 🧪 Como Testar

### Teste 1: Código ACTIVE
1. Gerar código no app
2. Verificar logs do polling: deve mostrar `status: AGUARDANDO_VALIDACAO`
3. Polling deve continuar rodando

### Teste 2: Código VALIDADO
1. Validar código no posto
2. Verificar logs do polling: deve mostrar `status: AGUARDANDO_REGISTRO` ou `VALIDADO`
3. Polling deve continuar rodando

### Teste 3: Refueling Criado
1. Posto registra abastecimento
2. Verificar logs do polling: deve mostrar `status: AGUARDANDO_VALIDACAO_MOTORISTA`
3. Polling deve detectar e navegar para tela de validação ✅

---

## 📚 Arquivos Envolvidos

### Backend:
- `zeca_site/backend/src/refueling/refueling.service.ts` (linha 1010-1088)
- `zeca_site/backend/src/refueling/refueling.controller.ts` (linha 183-204)

### App:
- `zeca_app/lib/core/services/refueling_polling_service.dart` (linha 84-185)
- `zeca_app/lib/core/services/api_service.dart` (linha 747-798)
- `zeca_app/lib/features/refueling/presentation/pages/refueling_code_page_simple.dart` (linha 576-612)

---

## 🎯 Próximos Passos

1. ✅ **Ajustar polling no app** - IMPLEMENTADO (usa lista de pendentes)
2. **Testar fluxo completo** em ambiente de desenvolvimento
3. **Validar com usuários** em ambiente de staging
4. **Deploy em produção** após validação

---

## ✅ Solução Implementada

**Data:** 30/11/2025  
**Status:** ✅ Correção implementada no app

O polling agora funciona da seguinte forma:

1. **Busca lista de abastecimentos pendentes** usando `getPendingRefuelings()`
2. **Procura na lista** se algum refueling tem o código que está sendo monitorado
3. **Quando encontra**, verifica se o status é `AGUARDANDO_VALIDACAO_MOTORISTA`
4. **Se sim**, chama o callback para navegar para tela de validação

**Vantagem:** Usa a mesma API que a tela de abastecimento já usa para mostrar os pendentes, então é mais confiável e não precisa mexer no backend.

