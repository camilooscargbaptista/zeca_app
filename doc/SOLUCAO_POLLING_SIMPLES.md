# 🔧 Solução Simples para o Polling Funcionar

**Data:** 30 de dezembro de 2025

---

## 🎯 O Problema em 1 Frase

O app chama `GET /api/v1/refueling/by-code/:code` mas o backend pode retornar o **código** ao invés do **refueling**, então o app não consegue detectar quando o posto registra o abastecimento.

---

## 📋 O Que Precisa Ser Feito no Backend

### ✅ Ajuste 1: Endpoint `/by-code/:code` - Buscar PRIMEIRO em `refueling`

**Arquivo:** `zeca_site/backend/src/refueling/refueling.service.ts`  
**Método:** `findByCode()`

**O que fazer:**

1. **Buscar PRIMEIRO na tabela `refueling`** (abastecimentos registrados)
2. Se encontrar → retornar o refueling completo
3. Se NÃO encontrar → buscar na tabela `refueling_codes` (códigos pendentes)
4. Se encontrar código com status `USED` → verificar novamente se existe refueling (pode ter sido criado entre as buscas)

**Código sugerido:**

```typescript
async findByCode(code: string): Promise<Refueling | RefuelingCode | null> {
  // 1️⃣ PRIMEIRO: Buscar em refueling (abastecimentos registrados)
  const refueling = await this.refuelingRepository.findOne({
    where: { 
      refueling_code: code.replace(/-/g, ''), // Remover hífens
    },
    relations: ['vehicle', 'driver', 'transporter', 'station']
  });

  if (refueling) {
    // ✅ Encontrou refueling - retornar refueling completo
    return refueling;
  }

  // 2️⃣ SEGUNDO: Se não encontrou refueling, buscar em refueling_codes
  const codeWithoutHyphens = code.replace(/-/g, '');
  const codeWithHyphens = this.formatCodeWithHyphens(codeWithoutHyphens);
  
  const refuelingCode = await this.refuelingCodeRepository.findOne({
    where: { 
      code: In([codeWithoutHyphens, codeWithHyphens]),
      status: In(['ACTIVE', 'VALIDADO', 'USED']) // Buscar todos os status
    }
  });

  if (refuelingCode) {
    // 3️⃣ Se código está USED, verificar se existe refueling (pode ter sido criado entre as buscas)
    if (refuelingCode.status === 'USED') {
      const refuelingAfterCode = await this.refuelingRepository.findOne({
        where: { refueling_code: codeWithoutHyphens },
        relations: ['vehicle', 'driver', 'transporter', 'station']
      });
      
      if (refuelingAfterCode) {
        return refuelingAfterCode; // ✅ Retornar refueling se encontrou
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

**Por que isso resolve:**
- Quando o posto registra o abastecimento, o refueling é criado na tabela `refueling`
- O app chama `/by-code/:code` e agora encontra o refueling (não o código)
- O app recebe o `id` do refueling e o `status: 'AGUARDANDO_VALIDACAO_MOTORISTA'`
- O polling detecta e funciona! ✅

---

### ✅ Ajuste 2: Garantir que Refueling é Criado com Status Correto

**Arquivo:** `zeca_site/backend/src/refueling/refueling.service.ts`  
**Método:** `registerRefueling()` ou método que cria o refueling quando o posto registra

**O que fazer:**

Quando o posto registra o abastecimento, garantir que:
1. O refueling é criado com status `'AGUARDANDO_VALIDACAO_MOTORISTA'`
2. O código é atualizado para status `'USED'`

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

**Por que isso resolve:**
- O app procura por status `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- Se o refueling for criado com outro status, o polling nunca detecta
- Garantindo este status, o polling funciona! ✅

---

## 🔄 Fluxo Após os Ajustes

```
1. Motorista gera código
   → Status: ACTIVE (em refueling_codes)
   → App chama GET /by-code/:code
   → Backend retorna código com is_pending_code: true
   → Polling continua...

2. Posto valida código
   → Status: VALIDADO (em refueling_codes)
   → App chama GET /by-code/:code
   → Backend retorna código com is_pending_code: true
   → Polling continua...

3. Posto registra abastecimento
   → Backend cria refueling com status: AGUARDANDO_VALIDACAO_MOTORISTA ✅
   → Backend atualiza código para status: USED ✅
   → App chama GET /by-code/:code
   → Backend busca PRIMEIRO em refueling ✅
   → Backend encontra refueling e retorna ✅
   → App recebe id do refueling e status: AGUARDANDO_VALIDACAO_MOTORISTA ✅
   → Polling detecta! ✅
   → App navega para tela de validação ✅
```

---

## ✅ Checklist de Verificação

### No Backend:

- [ ] **Endpoint `/by-code/:code` busca PRIMEIRO em `refueling`**
  - Verificar se o método `findByCode()` busca primeiro em `refuelingRepository`
  - Se não encontrar, então busca em `refuelingCodeRepository`

- [ ] **Refueling é criado com status `'AGUARDANDO_VALIDACAO_MOTORISTA'`**
  - Verificar método que cria refueling quando posto registra
  - Garantir que status é `AGUARDANDO_VALIDACAO_MOTORISTA` (não outro)

- [ ] **Código é atualizado para `'USED'` após criar refueling**
  - Verificar se código é atualizado após criar refueling
  - Garantir que status é `USED`

---

## 🧪 Como Testar

### Teste 1: Verificar se `/by-code/:code` retorna refueling quando existe

```bash
# 1. Gerar código no app
# 2. Posto valida e registra abastecimento
# 3. Chamar endpoint:
GET /api/v1/refueling/by-code/A1B2-2024-3F7A8B9C

# Deve retornar:
{
  "id": "uuid-do-refueling",  // ✅ ID do refueling, não do código
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",  // ✅ Status correto
  // ... outros campos do refueling
}
```

### Teste 2: Verificar se refueling é criado com status correto

```bash
# 1. Posto registra abastecimento
# 2. Verificar no banco de dados:
SELECT id, refueling_code, status FROM refueling WHERE refueling_code = 'A1B2-2024-3F7A8B9C';

# Deve retornar:
# status = 'AGUARDANDO_VALIDACAO_MOTORISTA' ✅
```

---

## 📝 Resumo em 3 Pontos

1. **Buscar PRIMEIRO em `refueling`** no endpoint `/by-code/:code`
   - Se encontrar refueling → retornar refueling
   - Se não encontrar → buscar em `refueling_codes`

2. **Criar refueling com status `'AGUARDANDO_VALIDACAO_MOTORISTA'`**
   - Quando o posto registra o abastecimento
   - Este é o status que o app procura

3. **Atualizar código para `'USED'` após criar refueling**
   - Para indicar que o código foi usado
   - E que agora existe um refueling associado

---

## 🎯 Resultado Esperado

Após esses ajustes:
- ✅ O app consegue obter o `refuelingId` quando chama `/by-code/:code`
- ✅ O app detecta quando status é `'AGUARDANDO_VALIDACAO_MOTORISTA'`
- ✅ O polling funciona corretamente
- ✅ O app navega para tela de validação quando o posto registra

---

## 📚 Arquivos do Backend que Precisam Ser Ajustados

1. **`zeca_site/backend/src/refueling/refueling.service.ts`**
   - Método `findByCode()` - buscar primeiro em `refueling`
   - Método que cria refueling - garantir status correto

2. **`zeca_site/backend/src/refueling/refueling.controller.ts`**
   - Verificar se endpoint `/by-code/:code` chama o método correto

---

## ❓ Dúvidas Frequentes

**P: Por que buscar primeiro em `refueling`?**  
R: Porque quando o posto registra, o refueling é criado. Se buscarmos primeiro em `refueling_codes`, podemos retornar o código antigo ao invés do refueling novo.

**P: Por que o status precisa ser `'AGUARDANDO_VALIDACAO_MOTORISTA'`?**  
R: Porque o app procura especificamente por este status. Se for outro, o polling nunca detecta.

**P: E se o código ainda não virou refueling?**  
R: Se não encontrar refueling, busca em `refueling_codes` e retorna o código com flag `is_pending_code: true`. O app continua fazendo polling até encontrar o refueling.

