---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Contexto BUSINESS-RULES.md"
---


# 📋 Regras de Negócio - ZECA App

> **IMPORTANTE:** Este arquivo contém as regras de negócio do aplicativo mobile ZECA.
> Consulte ANTES de implementar qualquer funcionalidade.
> Formato: RN-XXX-NNN para rastreabilidade.

---

## 📊 Índice de Regras

| Módulo | Prefixo | Quantidade |
|--------|---------|------------|
| Jornada | RN-JRN | 8 |
| Abastecimento | RN-ABT | 12 |
| Pagamento | RN-PAG | 6 |
| Veículo | RN-VEI | 5 |
| Motorista | RN-MOT | 5 |
| Posto | RN-POS | 4 |
| Notificação | RN-NOT | 4 |

**Total: 44 regras**

---

## 🎯 Visão Geral do App

O ZECA App é o aplicativo mobile usado por **motoristas** para realizar abastecimentos com desconto em postos parceiros.

### Tipos de Usuário

| Tipo | Descrição | Pagamento |
|------|-----------|-----------|
| **Driver Frota** | Motorista vinculado a transportadora | Fatura mensal |
| **Driver Autônomo** | Motorista independente | PIX instantâneo |

### Fluxo de Abastecimento (Visão Geral)

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO MOTORISTA FROTA                        │
├─────────────────────────────────────────────────────────────────┤
│  Login → Selecionar Veículo → Buscar Posto → Gerar Código →    │
│  → Posto Valida → Abastece → Registra Litros → Confirma →      │
│  → Sucesso (fatura para empresa)                                │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   FLUXO MOTORISTA AUTÔNOMO                      │
├─────────────────────────────────────────────────────────────────┤
│  Login → Selecionar Veículo → Buscar Posto → Gerar Código →    │
│  → Posto Valida → Abastece → Registra Litros → QR Code PIX →   │
│  → Paga PIX → Confirmação Automática → Sucesso                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛣️ RN-JRN - Jornada

### RN-JRN-001: Jornada Única Ativa
**Descrição:** Motorista pode ter apenas UMA jornada ativa por vez.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | Backend + App |
| Mensagem | "Você já possui uma jornada ativa" |

```dart
// Validação
if (driver.hasActiveJourney) {
  throw BusinessException('Você já possui uma jornada ativa');
}
```

---

### RN-JRN-002: Checklist Obrigatório
**Descrição:** Motorista deve completar checklist antes de iniciar jornada.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | App |
| Mensagem | "Complete o checklist antes de iniciar" |

---

### RN-JRN-003: Veículo Obrigatório
**Descrição:** Jornada deve ter veículo vinculado.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | App |
| Mensagem | "Selecione um veículo para iniciar" |

---

### RN-JRN-004: Km Inicial Obrigatório
**Descrição:** Registrar odômetro ao iniciar jornada.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Validação | App |
| Mensagem | "Registre o km inicial do veículo" |

---

### RN-JRN-005: Km Final >= Km Inicial
**Descrição:** Odômetro final deve ser maior ou igual ao inicial.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Validação | App + Backend |
| Mensagem | "Km final não pode ser menor que inicial" |

---

### RN-JRN-006: Pausar Permite Retomar
**Descrição:** Jornada pausada pode ser retomada.

| Campo | Valor |
|-------|-------|
| Severidade | 🟢 DESEJÁVEL |
| Estados | ACTIVE ↔ PAUSED |

---

### RN-JRN-007: Jornada Ativa para Abastecer (Frota)
**Descrição:** Motorista de frota precisa de jornada ativa para abastecer.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO (Frota) |
| Validação | App + Backend |
| Exceção | Motorista autônomo não precisa |

---

### RN-JRN-008: Encerramento Registra Dados
**Descrição:** Ao encerrar, registrar km final e hora.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Dados | endOdometer, endedAt |

---

## ⛽ RN-ABT - Abastecimento

### RN-ABT-001: Código 16 Caracteres
**Descrição:** Código de abastecimento tem formato fixo.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Formato | `ZECA[YYYY][A-Z0-9]{8}` |
| Exemplo | ZECA2025AB12CD34 |

---

### RN-ABT-002: Validade 60 Minutos
**Descrição:** Código expira em 60 minutos.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Timer | Mostrar countdown |
| Alerta | 10 min antes de expirar |

---

### RN-ABT-003: Cancelamento Antes de Validar
**Descrição:** Motorista pode cancelar código antes do posto validar.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Estados | Apenas PENDING |

---

### RN-ABT-004: Combustível Compatível
**Descrição:** Combustível deve ser compatível com veículo.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | App + Backend |

**Compatibilidade:**
| Tipo Veículo | Pode Abastecer |
|--------------|----------------|
| GASOLINE | Apenas Gasolina |
| ETHANOL | Apenas Etanol |
| DIESEL | Apenas Diesel |
| FLEX | Gasolina OU Etanol |

---

### RN-ABT-005: Litros Positivos
**Descrição:** Quantidade de litros deve ser > 0.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | Backend |
| Mensagem | "Quantidade inválida" |

---

### RN-ABT-006: Limite de Tanque (Alerta)
**Descrição:** Alertar se litros > capacidade do tanque.

| Campo | Valor |
|-------|-------|
| Severidade | 🟢 DESEJÁVEL |
| Tipo | Alerta, não bloqueio |

---

### RN-ABT-007: Foto Odômetro (Recomendado)
**Descrição:** Solicitar foto do odômetro.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Obrigatório | Configurável por frota |

---

### RN-ABT-008: Preço ZECA < Preço Bomba
**Descrição:** Preço ZECA sempre menor que bomba.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Exibição | Sempre mostrar economia |

```dart
// Cálculo de economia
final savings = (pricePump - priceZeca) * liters;
```

---

### RN-ABT-009: Estados Válidos
**Descrição:** Transições de estado válidas.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | Backend |

**Máquina de Estados:**
```
PENDING → VALIDATED, CANCELLED, EXPIRED
VALIDATED → IN_PROGRESS, CANCELLED
IN_PROGRESS → AWAITING_PAYMENT (autônomo), COMPLETED (frota)
AWAITING_PAYMENT → COMPLETED, EXPIRED
```

---

### RN-ABT-010: Confirmação do Motorista (Frota)
**Descrição:** Motorista de frota deve confirmar abastecimento.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Timeout | 24h para confirmar |

---

### RN-ABT-011: Limite Diário
**Descrição:** Respeitar limite diário definido pela frota.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO (Frota) |
| Validação | Backend |
| Mensagem | "Limite diário excedido" |

---

### RN-ABT-012: Um Código por Vez
**Descrição:** Motorista não pode ter dois códigos pendentes.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | App + Backend |
| Mensagem | "Você já possui um código ativo" |

---

## 💳 RN-PAG - Pagamento

### RN-PAG-001: PIX para Autônomo
**Descrição:** Motorista autônomo paga via PIX.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Método | PIX Copia e Cola / QR Code |

---

### RN-PAG-002: Validade PIX 30 Minutos
**Descrição:** QR Code PIX expira em 30 minutos.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Timer | Mostrar countdown |

---

### RN-PAG-003: Confirmação Automática
**Descrição:** Pagamento confirmado automaticamente via webhook.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Fallback | Polling a cada 10s |

---

### RN-PAG-004: Fatura Mensal (Frota)
**Descrição:** Motorista de frota não paga no app.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Fluxo | Abastece → Confirma → Fim |

---

### RN-PAG-005: Retry de PIX
**Descrição:** Permitir gerar novo PIX se expirado.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Limite | 3 tentativas |

---

### RN-PAG-006: Mostrar Economia
**Descrição:** Sempre mostrar economia na tela de sucesso.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Exibição | Destaque em verde |

---

## 🚗 RN-VEI - Veículo

### RN-VEI-001: Veículo Vinculado ao Motorista
**Descrição:** Motorista só vê veículos vinculados a ele.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | Backend |

---

### RN-VEI-002: Placa Formato Brasileiro
**Descrição:** Placa deve ser válida (Mercosul ou antiga).

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Formatos | ABC-1234, ABC1D23 |

---

### RN-VEI-003: Tipo Combustível Obrigatório
**Descrição:** Veículo deve ter tipo de combustível definido.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Tipos | GASOLINE, ETHANOL, DIESEL, FLEX |

---

### RN-VEI-004: Capacidade do Tanque
**Descrição:** Registrar capacidade do tanque.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Uso | Alerta de quantidade |

---

### RN-VEI-005: Veículo Ativo
**Descrição:** Só pode usar veículos ativos.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | App + Backend |

---

## 👤 RN-MOT - Motorista

### RN-MOT-001: Login com CPF
**Descrição:** Autenticação com CPF + senha.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Formato | CPF válido (11 dígitos) |

---

### RN-MOT-002: Bloqueio Após 5 Tentativas
**Descrição:** Bloquear após 5 tentativas erradas.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Desbloqueio | Via suporte |

---

### RN-MOT-003: Motorista Ativo
**Descrição:** Só motoristas ativos podem acessar.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | Backend |

---

### RN-MOT-004: Token JWT 24h
**Descrição:** Token de acesso válido por 24 horas.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Refresh Token | 7 dias |

---

### RN-MOT-005: Dados em Secure Storage
**Descrição:** Tokens e dados sensíveis em secure storage.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Package | flutter_secure_storage |

---

## ⛽ RN-POS - Posto

### RN-POS-001: Ordenar por Proximidade
**Descrição:** Lista de postos ordenada por distância.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Requer | GPS ativo |

---

### RN-POS-002: Mostrar Preço ZECA
**Descrição:** Exibir preço ZECA, não preço bomba.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Destaque | Economia vs bomba |

---

### RN-POS-003: Filtrar por Combustível
**Descrição:** Filtrar postos por combustível disponível.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Default | Combustível do veículo |

---

### RN-POS-004: Posto Ativo
**Descrição:** Só mostrar postos ativos.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Validação | Backend |

---

## 🔔 RN-NOT - Notificação

### RN-NOT-001: WebSocket para Updates
**Descrição:** Usar WebSocket para atualizações em tempo real.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Sala | `driver:{userId}` |

---

### RN-NOT-002: Reconexão Automática
**Descrição:** Reconectar WebSocket automaticamente.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Delay | 5 segundos |

---

### RN-NOT-003: Push Notification
**Descrição:** Enviar push para eventos importantes.

| Campo | Valor |
|-------|-------|
| Severidade | 🟡 IMPORTANTE |
| Eventos | Código validado, Pagamento confirmado |

---

### RN-NOT-004: Manter Conexão em Foreground
**Descrição:** WebSocket ativo enquanto app em foreground.

| Campo | Valor |
|-------|-------|
| Severidade | 🔴 CRÍTICO |
| Background | Desconectar para economia de bateria |

---

## 📊 Resumo de Severidade

| Severidade | Quantidade | Ação |
|------------|------------|------|
| 🔴 CRÍTICO | 28 | Bloqueia funcionalidade |
| 🟡 IMPORTANTE | 13 | Deve ser implementado |
| 🟢 DESEJÁVEL | 3 | Melhora experiência |

---

## 🚨 Tratamento de Erros

| Erro Técnico | Código | Mensagem para Usuário |
|--------------|--------|----------------------|
| 401 Unauthorized | AUTH_EXPIRED | "Sessão expirada. Faça login novamente." |
| 403 Forbidden | ACCESS_DENIED | "Acesso negado." |
| 404 Not Found | NOT_FOUND | "Não encontrado. Tente novamente." |
| 409 Conflict | CONFLICT | "Operação em conflito. Tente novamente." |
| 422 Validation | VALIDATION | Mensagem específica do campo |
| 429 Rate Limit | RATE_LIMIT | "Muitas requisições. Aguarde um momento." |
| 500 Server Error | SERVER_ERROR | "Erro no servidor. Tente em alguns minutos." |
| Network Error | NETWORK | "Sem conexão. Verifique sua internet." |
| Timeout | TIMEOUT | "Conexão lenta. Tente novamente." |

---

## 🔍 Consulta Rápida

```bash
# Buscar regras por módulo
cat .context/BUSINESS-RULES.md | grep "RN-ABT"

# Buscar regras críticas
cat .context/BUSINESS-RULES.md | grep "🔴 CRÍTICO"

# Buscar por termo
cat .context/BUSINESS-RULES.md | grep -i "pagamento"
```

---

*Business Rules v2.0.0 - Janeiro 2026*
