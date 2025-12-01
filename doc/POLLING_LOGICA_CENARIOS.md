# 🔍 Lógica do Polling - Análise de Cenários

**Data:** 30 de novembro de 2025  
**Objetivo:** Documentar a lógica do polling e validar todos os cenários possíveis

---

## 📋 Lógica Atual do Polling

### Passo a Passo:

1. **Polling inicia** com código específico (ex: `ABC-1234`)
2. **Guarda timestamp** de quando iniciou (`_pollingStartTime`)
3. **Busca lista de pendentes** via `getPendingRefuelings()`
4. **Filtra por código** - só considera refuelings com o código que está monitorando
5. **Filtra por timestamp** - só considera refuelings criados DEPOIS que o polling iniciou
6. **Se houver múltiplos** com o mesmo código (improvável), pega o mais recente
7. **Verifica status** - se for `AGUARDANDO_VALIDACAO_MOTORISTA`, chama callback

---

## 🎯 Cenários de Teste

### Cenário 1: Motorista com 2 Pendentes Antigos + Novo Abastecimento

**Situação:**
- Motorista tem 2 pendentes antigos:
  - Refueling #1: código `ABC-1111`, criado ontem 14:00
  - Refueling #2: código `ABC-2222`, criado ontem 15:00
- Motorista gera novo código `ABC-1234` hoje 10:00
- Polling inicia hoje 10:00 monitorando `ABC-1234`
- Posto valida código `ABC-1234` hoje 10:05
- Posto registra abastecimento hoje 10:10 (cria refueling com código `ABC-1234`)
- Polling verifica hoje 10:15

**Lista de pendentes retornada:**
```json
[
  { "id": "ref-1", "refueling_code": "ABC-1111", "created_at": "2025-11-29T14:00:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" },
  { "id": "ref-2", "refueling_code": "ABC-2222", "created_at": "2025-11-29T15:00:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" },
  { "id": "ref-3", "refueling_code": "ABC-1234", "created_at": "2025-11-30T10:10:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" }
]
```

**Lógica do polling:**
1. ✅ Filtra por código: `ABC-1234` → Encontra apenas `ref-3`
2. ✅ Verifica timestamp: `2025-11-30T10:10:00Z` é depois de `2025-11-30T10:00:00Z` → ✅ Válido
3. ✅ Verifica status: `AGUARDANDO_VALIDACAO_MOTORISTA` → ✅ Correto
4. ✅ Chama callback com `ref-3`

**Resultado:** ✅ **CORRETO** - Pega o refueling correto (ABC-1234)

---

### Cenário 2: Motorista com 2 Pendentes Antigos, Novo Ainda Não Registrado

**Situação:**
- Motorista tem 2 pendentes antigos:
  - Refueling #1: código `ABC-1111`, criado ontem 14:00
  - Refueling #2: código `ABC-2222`, criado ontem 15:00
- Motorista gera novo código `ABC-1234` hoje 10:00
- Polling inicia hoje 10:00 monitorando `ABC-1234`
- Posto valida código `ABC-1234` hoje 10:05
- Posto **AINDA NÃO** registrou o abastecimento
- Polling verifica hoje 10:15

**Lista de pendentes retornada:**
```json
[
  { "id": "ref-1", "refueling_code": "ABC-1111", "created_at": "2025-11-29T14:00:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" },
  { "id": "ref-2", "refueling_code": "ABC-2222", "created_at": "2025-11-29T15:00:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" }
]
```

**Lógica do polling:**
1. ✅ Filtra por código: `ABC-1234` → **NÃO encontra nada** (ainda não foi registrado)
2. ⏳ Continua polling (aguardando refueling aparecer na lista)

**Resultado:** ✅ **CORRETO** - Não pega nenhum dos antigos, continua aguardando

---

### Cenário 3: Múltiplos Refuelings com Mesmo Código (Edge Case)

**Situação:**
- Por algum bug/erro, há 2 refuelings com o mesmo código `ABC-1234`:
  - Refueling #1: código `ABC-1234`, criado ontem 14:00 (antigo, bug)
  - Refueling #2: código `ABC-1234`, criado hoje 10:10 (novo, correto)
- Polling inicia hoje 10:00 monitorando `ABC-1234`
- Polling verifica hoje 10:15

**Lista de pendentes retornada:**
```json
[
  { "id": "ref-1", "refueling_code": "ABC-1234", "created_at": "2025-11-29T14:00:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" },
  { "id": "ref-2", "refueling_code": "ABC-1234", "created_at": "2025-11-30T10:10:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" }
]
```

**Lógica do polling:**
1. ✅ Filtra por código: `ABC-1234` → Encontra ambos (`ref-1` e `ref-2`)
2. ✅ Verifica timestamp de `ref-1`: `2025-11-29T14:00:00Z` é ANTES de `2025-11-30T10:00:00Z` → ❌ Ignora
3. ✅ Verifica timestamp de `ref-2`: `2025-11-30T10:10:00Z` é DEPOIS de `2025-11-30T10:00:00Z` → ✅ Válido
4. ✅ Seleciona `ref-2` (mais recente e criado depois do polling)
5. ✅ Verifica status: `AGUARDANDO_VALIDACAO_MOTORISTA` → ✅ Correto
6. ✅ Chama callback com `ref-2`

**Resultado:** ✅ **CORRETO** - Pega o refueling novo, ignora o antigo

---

### Cenário 4: Código Único (Cenário Normal)

**Situação:**
- Código é único no banco (constraint `unique: true`)
- Motorista gera código `ABC-1234` hoje 10:00
- Polling inicia hoje 10:00 monitorando `ABC-1234`
- Posto registra abastecimento hoje 10:10
- Polling verifica hoje 10:15

**Lista de pendentes retornada:**
```json
[
  { "id": "ref-3", "refueling_code": "ABC-1234", "created_at": "2025-11-30T10:10:00Z", "status": "AGUARDANDO_VALIDACAO_MOTORISTA" }
]
```

**Lógica do polling:**
1. ✅ Filtra por código: `ABC-1234` → Encontra `ref-3`
2. ✅ Verifica timestamp: `2025-11-30T10:10:00Z` é depois de `2025-11-30T10:00:00Z` → ✅ Válido
3. ✅ Verifica status: `AGUARDANDO_VALIDACAO_MOTORISTA` → ✅ Correto
4. ✅ Chama callback com `ref-3`

**Resultado:** ✅ **CORRETO** - Funciona perfeitamente

---

## ✅ Validação da Lógica

### Filtros Aplicados (em ordem):

1. **Filtro por código** (linha 138):
   ```dart
   if (refuelingCodeClean == cleanCode) {
     // Só considera refuelings com o código que está monitorando
   }
   ```
   ✅ **Garante:** Não pega refuelings de outros códigos

2. **Filtro por timestamp** (linha 150):
   ```dart
   if (createdAt.isAfter(_pollingStartTime!)) {
     // Só considera refuelings criados DEPOIS que o polling iniciou
   }
   ```
   ✅ **Garante:** Não pega refuelings antigos (mesmo que tenham o código correto)

3. **Seleção do mais recente** (linha 153):
   ```dart
   if (newestCreatedAt == null || createdAt.isAfter(newestCreatedAt)) {
     matchingRefueling = refuelingMap;
     newestCreatedAt = createdAt;
   }
   ```
   ✅ **Garante:** Se houver múltiplos novos, pega o mais recente

---

## 🎯 Conclusão

A lógica atual está **CORRETA** para todos os cenários:

✅ **Cenário 1:** Pega o refueling correto (filtra por código + timestamp)  
✅ **Cenário 2:** Não pega nenhum dos antigos (filtra por código, não encontra)  
✅ **Cenário 3:** Pega o novo, ignora o antigo (filtra por código + timestamp)  
✅ **Cenário 4:** Funciona normalmente (código único)

### Proteções Implementadas:

1. ✅ **Filtro por código** - Garante que só considera o código que está monitorando
2. ✅ **Filtro por timestamp** - Garante que ignora refuelings antigos
3. ✅ **Seleção do mais recente** - Garante que se houver múltiplos, pega o mais novo

---

## 💡 Possível Melhoria (Opcional)

Se quiser adicionar uma camada extra de segurança, podemos também verificar se o refueling tem o mesmo `vehicle_plate` e `driver_cpf` do código que está sendo monitorado. Mas isso é redundante porque o código já é único e já filtra por código.

---

**Status:** ✅ Lógica validada e correta para todos os cenários

