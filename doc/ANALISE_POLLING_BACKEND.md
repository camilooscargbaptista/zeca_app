# 🔍 Análise do Polling - Como o App Busca Informações e Ajustes no Backend

**Data:** 30 de dezembro de 2025  
**Status:** 📋 Análise completa (sem alterações)

---

## 📋 Resumo Executivo

O polling no app **não está funcionando corretamente**. Esta análise detalha:
1. Como o app está buscando informações atualmente
2. Quais endpoints estão sendo chamados
3. O que o backend precisa retornar
4. Ajustes sugeridos no backend (sem implementar)

---

## 🔄 Como o Polling Funciona no App

### Fluxo Atual do Polling

O polling está implementado em `refueling_polling_service.dart` e funciona da seguinte forma:

```
1. startPolling() é chamado com:
   - refuelingId (opcional)
   - refuelingCode (opcional)
   - onStatusChanged (callback)

2. A cada 15 segundos, _checkStatus() é executado:

   a) Se tem refuelingId:
      → Chama GET /api/v1/refueling/:id
      → Verifica se status == 'AGUARDANDO_VALIDACAO_MOTORISTA'
      → Se sim, chama callback

   b) Se NÃO tem refuelingId (mas tem refuelingCode):
      → Chama GET /api/v1/refueling/by-code/:code
      → Extrai o refuelingId da resposta
      → Verifica se status == 'AGUARDANDO_VALIDACAO_MOTORISTA'
      → Se sim, chama callback
      → Se não, continua polling
```

---

## 📡 Endpoints Chamados pelo App

### 1. `GET /api/v1/refueling/by-code/:code`

**Quando é chamado:**
- Quando o app inicia o polling **sem** ter o `refuelingId`
- Apenas com o `refuelingCode` (ex: `A1B2-2024-3F7A8B9C`)

**O que o app espera receber:**
```json
{
  "id": "uuid-do-refueling",  // ⚠️ CRÍTICO: Precisa ser o ID do refueling, não do código!
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",  // ⚠️ CRÍTICO: Status do refueling
  "quantity_liters": 100.5,
  "odometer_reading": 50000,
  "pump_number": "3",
  "unit_price": 4.50,
  "total_amount": 452.25,
  "attendant_name": "João Silva",
  "notes": "Observações do posto",
  "vehicle_plate": "ABC-1234",
  "driver_cpf": "555.666.777-88",
  "driver_name": "Pedro Oliveira",
  "transporter_cnpj": "98.765.432/0001-10",
  "transporter_name": "Transportadora ABC Ltda",
  "fuel_type": "Diesel S10",
  "refueling_datetime": "2025-11-12T14:00:00Z",
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T14:30:00Z"
}
```

**Problema atual:**
- Se o backend retornar o **código** ao invés do **refueling**, o app não consegue obter o `refuelingId`
- Se o status retornado for diferente de `'AGUARDANDO_VALIDACAO_MOTORISTA'`, o polling continua indefinidamente

---

### 2. `GET /api/v1/refueling/:id`

**Quando é chamado:**
- Quando o app **já tem** o `refuelingId`
- Ou após obter o `refuelingId` do endpoint `/by-code/:code`

**O que o app espera receber:**
```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",  // ⚠️ CRÍTICO: Precisa ser este status
  "quantity_liters": 100.5,
  "odometer_reading": 50000,
  // ... outros campos ...
}
```

**Problema atual:**
- Se o status não for `'AGUARDANDO_VALIDACAO_MOTORISTA'`, o polling continua
- O app não detecta quando o refueling é criado

---

### 3. `GET /api/v1/refueling?status=AGUARDANDO_VALIDACAO_MOTORISTA`

**Quando é chamado:**
- **NÃO está sendo usado pelo polling atualmente!**
- Está disponível em `api_service.dart` como `getPendingRefuelings()`
- Poderia ser uma alternativa melhor ao polling atual

**O que o app espera receber:**
```json
{
  "data": [
    {
      "id": "uuid-do-refueling-1",
      "refueling_code": "A1B2-2024-3F7A8B9C",
      "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
      "created_at": "2025-11-12T14:00:00Z",
      // ... outros campos ...
    },
    {
      "id": "uuid-do-refueling-2",
      "refueling_code": "C3D4-2024-5G8H9I0J",
      "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
      "created_at": "2025-11-12T15:00:00Z",
      // ... outros campos ...
    }
  ],
  "total": 2,
  "page": 1,
  "limit": 100
}
```

**Vantagem:**
- Retorna **todos** os refuelings pendentes
- O app pode filtrar pelo `refueling_code` que está monitorando
- Mais confiável porque usa a mesma API que a tela de abastecimento usa

---

## 🐛 Problemas Identificados

### Problema 1: Endpoint `/by-code/:code` Pode Retornar Código ao Invés de Refueling

**Cenário:**
1. Motorista gera código → Status: `ACTIVE` (em `refueling_codes`)
2. Posto valida código → Status: `VALIDADO` (em `refueling_codes`)
3. Posto registra abastecimento → Refueling criado com status: `AGUARDANDO_VALIDACAO_MOTORISTA`

**O que acontece:**
- Se o backend buscar primeiro em `refueling_codes` e encontrar, retorna o **código** (não o refueling)
- O app recebe `id` do código, não do refueling
- Quando o app tenta buscar `/refueling/:id` com o ID do código, pode dar erro 404

**Solução sugerida no backend:**
- Buscar **primeiro** em `refueling` (tabela de abastecimentos)
- Se não encontrar, **depois** buscar em `refueling_codes`
- Se encontrar em `refueling`, retornar o refueling completo
- Se encontrar apenas em `refueling_codes`, retornar o código com flag `is_pending_code: true`

---

### Problema 2: Status Inconsistente Entre Código e Refueling

**Cenário:**
- Quando o código está em `refueling_codes` (antes de virar refueling), o status pode ser:
  - `ACTIVE` (aguardando validação do posto)
  - `VALIDADO` (aguardando posto registrar)
  - `USED` (já foi usado, refueling criado)

- Quando o refueling é criado, o status é:
  - `AGUARDANDO_VALIDACAO_MOTORISTA` (aguardando motorista validar)

**O que acontece:**
- O polling procura por `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- Mas quando o código ainda está em `refueling_codes`, o status é diferente
- O polling nunca detecta a mudança

**Solução sugerida no backend:**
- Quando o endpoint `/by-code/:code` encontrar um código com status `USED`, verificar se existe refueling associado
- Se existir, retornar o **refueling** ao invés do código
- Se não existir, retornar o código com status `USED` e flag `is_pending_code: true`

---

### Problema 3: Polling Não Usa Lista de Pendentes

**Cenário:**
- O app tem o método `getPendingRefuelings()` disponível
- Mas o polling **não está usando** este método
- Está usando `getRefuelingByCode()` que pode não funcionar corretamente

**Vantagem de usar lista de pendentes:**
- ✅ Retorna todos os refuelings pendentes de uma vez
- ✅ O app pode filtrar pelo `refueling_code` que está monitorando
- ✅ Mais confiável porque usa a mesma API que a tela de abastecimento usa
- ✅ Não depende de buscar por código (que pode retornar código ao invés de refueling)

**Solução sugerida no app (não implementar agora):**
- Modificar `_checkStatus()` para usar `getPendingRefuelings()` ao invés de `getRefuelingByCode()`
- Filtrar a lista pelo `refueling_code` que está sendo monitorado
- Quando encontrar, verificar se o status é `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- Se sim, chamar o callback

---

## 🔧 Ajustes Sugeridos no Backend

### Ajuste 1: Endpoint `GET /api/v1/refueling/by-code/:code`

**Arquivo:** `zeca_site/backend/src/refueling/refueling.service.ts`

**Mudança sugerida:**

```typescript
async findByCode(code: string): Promise<Refueling | RefuelingCode | null> {
  // 1. PRIMEIRO: Buscar em refueling (abastecimentos registrados)
  const refueling = await this.refuelingRepository.findOne({
    where: { 
      refueling_code: code,
      // Não filtrar por status - queremos qualquer refueling com este código
    },
    relations: ['vehicle', 'driver', 'transporter', 'station']
  });

  if (refueling) {
    // ✅ Encontrou refueling - retornar refueling completo
    return refueling;
  }

  // 2. SEGUNDO: Se não encontrou refueling, buscar em refueling_codes
  const codeWithoutHyphens = code.replace(/-/g, '');
  const codeWithHyphens = this.formatCodeWithHyphens(codeWithoutHyphens);
  
  const refuelingCode = await this.refuelingCodeRepository.findOne({
    where: { 
      code: In([codeWithoutHyphens, codeWithHyphens]),
      // ⚠️ IMPORTANTE: Buscar códigos ACTIVE, VALIDADO e USED
      status: In(['ACTIVE', 'VALIDADO', 'USED'])
    }
  });

  if (refuelingCode) {
    // ⚠️ IMPORTANTE: Se status é USED, verificar se existe refueling
    if (refuelingCode.status === 'USED') {
      // Tentar buscar refueling novamente (pode ter sido criado entre as buscas)
      const refuelingAfterCode = await this.refuelingRepository.findOne({
        where: { refueling_code: code },
        relations: ['vehicle', 'driver', 'transporter', 'station']
      });
      
      if (refuelingAfterCode) {
        return refuelingAfterCode; // Retornar refueling se encontrou
      }
    }
    
    // Retornar código com flag indicando que é código pendente
    return {
      ...refuelingCode,
      is_pending_code: true, // ⚠️ Flag para indicar que é código, não refueling
    };
  }

  return null;
}
```

**Justificativa:**
- Busca **primeiro** em `refueling` (prioridade para refuelings registrados)
- Se não encontrar, busca em `refueling_codes` (códigos pendentes)
- Se encontrar código com status `USED`, verifica novamente se existe refueling (pode ter sido criado entre as buscas)
- Retorna flag `is_pending_code: true` quando retorna código (não refueling)

---

### Ajuste 2: Endpoint `GET /api/v1/refueling?status=AGUARDANDO_VALIDACAO_MOTORISTA`

**Arquivo:** `zeca_site/backend/src/refueling/refueling.controller.ts`

**Verificar se o endpoint aceita:**
- ✅ Query parameter `status` (filtro por status)
- ✅ Query parameter `limit` (limite de resultados)
- ✅ Query parameter `sortBy` (ordenar por campo)
- ✅ Query parameter `sortOrder` (ordem: ASC ou DESC)

**Resposta esperada:**
```json
{
  "data": [
    {
      "id": "uuid",
      "refueling_code": "A1B2-2024-3F7A8B9C",
      "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
      "created_at": "2025-11-12T14:00:00Z",
      // ... outros campos ...
    }
  ],
  "total": 1,
  "page": 1,
  "limit": 100
}
```

**Campos obrigatórios na resposta:**
- ✅ `id` (UUID do refueling)
- ✅ `refueling_code` (código do abastecimento)
- ✅ `status` (status atual)
- ✅ `created_at` (timestamp de criação)

---

### Ajuste 3: Garantir que Refueling é Criado com Status Correto

**Arquivo:** `zeca_site/backend/src/refueling/refueling.service.ts`

**Verificar:**
- Quando o posto registra o abastecimento, o refueling deve ser criado com status `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- O código deve ser atualizado para status `'USED'`

**Código sugerido:**
```typescript
async registerRefueling(registerDto: RegisterRefuelingDto): Promise<Refueling> {
  // 1. Buscar código
  const code = await this.refuelingCodeRepository.findOne({
    where: { code: registerDto.code }
  });

  if (!code) {
    throw new NotFoundException('Código não encontrado');
  }

  // 2. Criar refueling com status AGUARDANDO_VALIDACAO_MOTORISTA
  const refueling = await this.refuelingRepository.create({
    ...registerDto,
    status: RefuelingStatus.AGUARDANDO_VALIDACAO_MOTORISTA, // ⚠️ CRÍTICO
    refueling_code: code.code,
    refueling_code_id: code.id,
  });

  await this.refuelingRepository.save(refueling);

  // 3. Atualizar código para USED
  code.status = RefuelingCodeStatus.USED;
  await this.refuelingCodeRepository.save(code);

  return refueling;
}
```

---

## 📊 Fluxo Esperado Após Ajustes

```
1. Motorista gera código
   → Status: ACTIVE (em refueling_codes)
   → Polling: GET /by-code/:code → Retorna código com is_pending_code: true

2. Posto valida código
   → Status: VALIDADO (em refueling_codes)
   → Polling: GET /by-code/:code → Retorna código com is_pending_code: true

3. Posto registra abastecimento
   → Refueling criado com status: AGUARDANDO_VALIDACAO_MOTORISTA
   → Código atualizado para status: USED
   → Polling: GET /by-code/:code → Retorna REFUELING (não código!)
   → Polling detecta status AGUARDANDO_VALIDACAO_MOTORISTA ✅
   → App navega para tela de validação ✅
```

---

## ✅ Checklist de Verificações no Backend

### Endpoint `/by-code/:code`:
- [ ] Busca **primeiro** em `refueling` (tabela de abastecimentos)
- [ ] Se não encontrar, busca em `refueling_codes`
- [ ] Se encontrar código com status `USED`, verifica novamente se existe refueling
- [ ] Retorna flag `is_pending_code: true` quando retorna código (não refueling)
- [ ] Retorna refueling completo quando encontra refueling

### Endpoint `/refueling?status=...`:
- [ ] Aceita query parameter `status`
- [ ] Aceita query parameter `limit`
- [ ] Aceita query parameter `sortBy`
- [ ] Aceita query parameter `sortOrder`
- [ ] Retorna lista de refuelings com campos obrigatórios:
  - `id`
  - `refueling_code`
  - `status`
  - `created_at`

### Criação de Refueling:
- [ ] Refueling é criado com status `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- [ ] Código é atualizado para status `'USED'` após criar refueling

---

## 🎯 Próximos Passos

1. **Verificar backend:**
   - Confirmar se o endpoint `/by-code/:code` busca primeiro em `refueling`
   - Confirmar se o endpoint `/refueling?status=...` retorna os campos necessários
   - Confirmar se refueling é criado com status correto

2. **Testar polling:**
   - Testar com código ACTIVE
   - Testar com código VALIDADO
   - Testar após refueling ser criado

3. **Considerar alternativa:**
   - Avaliar se é melhor modificar o polling para usar `getPendingRefuelings()` ao invés de `getRefuelingByCode()`

---

## 📚 Arquivos Envolvidos

### Backend:
- `zeca_site/backend/src/refueling/refueling.service.ts` (método `findByCode`)
- `zeca_site/backend/src/refueling/refueling.controller.ts` (endpoint `/by-code/:code`)
- `zeca_site/backend/src/refueling/refueling.controller.ts` (endpoint `GET /refueling`)

### App:
- `zeca_app/lib/core/services/refueling_polling_service.dart` (polling service)
- `zeca_app/lib/core/services/api_service.dart` (API service)
- `zeca_app/lib/features/refueling/presentation/pages/refueling_waiting_page.dart` (tela de aguardando)

---

## 📝 Notas Finais

- **Não alterar nada no app agora** - apenas análise
- **Focar em ajustes no backend** para que o polling funcione corretamente
- **Considerar usar lista de pendentes** como alternativa mais confiável no futuro

