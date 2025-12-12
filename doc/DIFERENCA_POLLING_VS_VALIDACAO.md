# 🔄 Diferença entre Polling e Validação

**Data:** 30 de dezembro de 2025

---

## ❌ NÃO são a mesma API!

O **polling** e a **validação** usam APIs **diferentes** e têm **propósitos diferentes**:

---

## 🔍 POLLING (Apenas Lê o Status)

### Propósito:
- **Monitorar** quando o posto registra o abastecimento
- **Detectar** quando o status muda para `AGUARDANDO_VALIDACAO_MOTORISTA`
- **Navegar** automaticamente para tela de validação

### APIs Usadas:

#### 1. `GET /api/v1/refueling/by-code/:code`
- **Método:** GET (leitura)
- **Quando:** Quando o app não tem `refuelingId` (apenas código)
- **O que faz:** Busca refueling pelo código
- **O que espera:** Refueling com `status: 'AGUARDANDO_VALIDACAO_MOTORISTA'`

#### 2. `GET /api/v1/refueling/:id`
- **Método:** GET (leitura)
- **Quando:** Quando o app já tem `refuelingId`
- **O que faz:** Busca status do refueling
- **O que espera:** Refueling com `status: 'AGUARDANDO_VALIDACAO_MOTORISTA'`

### Características:
- ✅ **Apenas leitura** (não altera nada)
- ✅ **Chamada periódica** (a cada 15 segundos)
- ✅ **Automática** (sem interação do usuário)
- ✅ **Detecta mudança** de status

---

## ✅ VALIDAÇÃO (Altera o Status)

### Propósito:
- **Confirmar** que o motorista validou os dados do abastecimento
- **Alterar** o status de `AGUARDANDO_VALIDACAO_MOTORISTA` para `VALIDADO`
- **Salvar** localização e dados da validação

### API Usada:

#### `POST /api/v1/refueling/:id/validate`
- **Método:** POST (escrita)
- **Quando:** Quando o motorista clica em "Validar Agora"
- **O que faz:** Valida o abastecimento (altera status)
- **O que envia:**
  ```json
  {
    "device": "iPhone 15 Pro",
    "latitude": -23.5505199,
    "longitude": -46.6333094,
    "address": "Rua Exemplo, 123"
  }
  ```
- **O que espera:** Refueling atualizado com `status: 'VALIDADO'`

### Características:
- ✅ **Altera dados** (muda status)
- ✅ **Chamada única** (quando usuário clica)
- ✅ **Manual** (requer interação do usuário)
- ✅ **Salva validação** (localização, data/hora, motorista)

---

## 📊 Comparação Visual

| Característica | Polling | Validação |
|----------------|---------|-----------|
| **Método HTTP** | GET | POST |
| **Propósito** | Ler status | Alterar status |
| **Quando** | Automaticamente (a cada 15s) | Quando usuário clica |
| **O que faz** | Monitora mudanças | Confirma validação |
| **Altera dados?** | ❌ Não | ✅ Sim |
| **Interação** | Automática | Manual |
| **Status inicial** | `AGUARDANDO_VALIDACAO_MOTORISTA` | `AGUARDANDO_VALIDACAO_MOTORISTA` |
| **Status final** | Detecta `AGUARDANDO_VALIDACAO_MOTORISTA` | Muda para `VALIDADO` |

---

## 🔄 Fluxo Completo

```
1. Motorista gera código
   ↓
2. Posto registra abastecimento
   → Refueling criado com status: AGUARDANDO_VALIDACAO_MOTORISTA
   ↓
3. POLLING detecta (GET /refueling/:id)
   → Status: AGUARDANDO_VALIDACAO_MOTORISTA ✅
   → App navega para tela de validação
   ↓
4. Motorista clica "Validar Agora"
   → POST /refueling/:id/validate
   → Backend altera status para: VALIDADO ✅
   ↓
5. App recebe resposta
   → Status: VALIDADO ✅
   → App mostra mensagem de sucesso
   → App navega para home
```

---

## 📝 Resumo

### Polling:
- **APIs:** `GET /refueling/by-code/:code` e `GET /refueling/:id`
- **Ação:** Ler status
- **Automático:** Sim
- **Altera dados:** Não

### Validação:
- **API:** `POST /refueling/:id/validate`
- **Ação:** Alterar status
- **Automático:** Não (manual)
- **Altera dados:** Sim

---

## ✅ Conclusão

**NÃO são a mesma API!**

- **Polling** = **GET** (leitura) - monitora mudanças
- **Validação** = **POST** (escrita) - confirma validação

São APIs **complementares**:
1. Polling **detecta** quando há abastecimento pendente
2. Validação **confirma** que o motorista validou

