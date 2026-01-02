# ZECA App - Regras de Negócio

> **IMPORTANTE:** Consulte este arquivo para entender as regras do negócio ZECA.
> Regras compartilhadas com o backend (zeca_site).

---

## Visão Geral do App

O ZECA App é o aplicativo mobile usado por **motoristas** para realizar abastecimentos com desconto em postos parceiros.

### Usuários do App

| Tipo | Descrição | Funcionalidades |
|------|-----------|-----------------|
| **DRIVER (Frota)** | Motorista vinculado a uma empresa | Gerar código, abastecer, histórico |
| **DRIVER (Autônomo)** | Motorista independente | Gerar código, pagar PIX, histórico |
| **FLEET** | Gestor de frota | Dashboard, relatórios, gerenciar motoristas |

---

## Fluxo de Abastecimento

### Fluxo Motorista de Frota

```
1. Motorista abre app e faz login (CPF + senha)
2. Seleciona veículo (se tiver mais de um)
3. Busca posto próximo ou seleciona da lista
4. Gera CÓDIGO DE ABASTECIMENTO
5. Mostra código para atendente do posto
6. Atendente valida código no sistema do posto
7. Atendente abastece o veículo
8. Atendente registra litros abastecidos
9. App mostra notificação de conclusão
10. Motorista CONFIRMA abastecimento no app
11. Sistema registra para faturamento da frota
```

### Fluxo Motorista Autônomo (PIX)

```
1. Motorista abre app e faz login (CPF + senha)
2. Seleciona veículo
3. Busca posto próximo
4. Gera CÓDIGO DE ABASTECIMENTO
5. Mostra código para atendente
6. Atendente valida e abastece
7. Atendente registra litros
8. App recebe notificação via WebSocket
9. App mostra QR Code PIX
10. Motorista paga PIX
11. Sistema confirma automaticamente
12. App mostra tela de SUCESSO com economia
```

---

## Código de Abastecimento

### Formato

- 16 caracteres alfanuméricos
- Padrão: `ZECA` + `AAAA` (ano) + 8 caracteres aleatórios
- Exemplo: `ZECA2025AB12CD34`

### Estados do Código

| Estado | Descrição | Ação no App |
|--------|-----------|-------------|
| `PENDING` | Código gerado, aguardando validação | Mostrar código + timer |
| `VALIDATED` | Posto validou o código | Mostrar "Em atendimento" |
| `IN_PROGRESS` | Abastecimento em andamento | Mostrar progresso |
| `AWAITING_PAYMENT` | Aguardando PIX (autônomo) | Mostrar QR Code |
| `COMPLETED` | Finalizado com sucesso | Mostrar tela de sucesso |
| `CANCELLED` | Cancelado | Voltar para início |
| `EXPIRED` | Tempo expirado (60 min) | Mostrar erro + nova tentativa |

### Validade

- **60 minutos** após geração
- Timer visível no app
- Alerta quando faltar 10 minutos
- Pode cancelar antes de validar

---

## Preços e Economia

### Cálculo

```dart
// Economia por litro
final economiaLitro = precoBomba - precoZeca;

// Economia total
final economiaTotal = economiaLitro * litrosAbastecidos;

// Valor pago
final valorPago = precoZeca * litrosAbastecidos;
```

### Exemplo

```
Preço Bomba: R$ 6,49/L
Preço ZECA:  R$ 5,89/L
Litros:      50L

Economia/L:  R$ 0,60
Economia:    R$ 30,00
Valor Pago:  R$ 294,50
```

### Exibição no App

- **Sempre mostrar economia** (destaque em verde)
- Comparativo: "Você pagaria R$ X, pagou R$ Y"
- Acumulado mensal de economia no dashboard

---

## Veículos

### Regras

- Motorista pode ter **múltiplos veículos** vinculados
- Deve selecionar veículo **antes** de gerar código
- Combustível do código deve ser **compatível** com veículo

### Compatibilidade de Combustível

| Tipo Veículo | Pode Abastecer |
|--------------|----------------|
| GASOLINE | Apenas Gasolina |
| ETHANOL | Apenas Etanol |
| DIESEL | Apenas Diesel |
| FLEX | Gasolina OU Etanol |

### Validações

- Se veículo não é FLEX, só mostrar combustível compatível
- Alerta se tentar mais que capacidade do tanque
- Registrar odômetro (opcional, mas recomendado)

---

## Postos

### Busca

- Ordenar por **proximidade** (se GPS disponível)
- Mostrar **preço ZECA** (não preço bomba)
- Indicar **distância** em km
- Filtrar por combustível disponível

### Informações Exibidas

- Nome do posto
- Endereço completo
- Preços por combustível
- Distância
- Horário de funcionamento (se disponível)

---

## Pagamento (Autônomo)

### PIX

- QR Code gerado após abastecimento
- Validade: **30 minutos**
- Confirmação **automática** via webhook
- Fallback: verificação manual a cada 10s

### Estados do Pagamento

| Estado | Ação no App |
|--------|-------------|
| `PENDING` | Mostrar QR Code + timer |
| `PROCESSING` | Mostrar "Verificando..." |
| `COMPLETED` | Tela de sucesso |
| `FAILED` | Erro + nova tentativa |
| `EXPIRED` | Gerar novo QR Code |

---

## Notificações (WebSocket)

### Eventos que o App escuta

| Evento | Quando | Ação |
|--------|--------|------|
| `refueling_validated` | Posto validou código | Atualizar status |
| `refueling_completed` | Posto finalizou | Mostrar resumo (Frota) ou PIX (Autônomo) |
| `autonomous_payment_confirmed` | PIX confirmado | Tela de sucesso |

### Conexão

- Conectar após login
- Sala: `driver:{userId}`
- Reconectar automaticamente se desconectar
- Manter conexão enquanto app em foreground

---

## Limites (Definidos pela Frota)

### Por Motorista

- Limite diário de valor (R$)
- Limite diário de litros
- Limite por abastecimento
- Combustíveis permitidos

### Comportamento no App

- Verificar limites **antes** de gerar código
- Mostrar limite restante
- Bloquear se exceder
- Mostrar mensagem clara do motivo

---

## Histórico

### Filtros

- Por período (data início/fim)
- Por status
- Por veículo

### Dados Exibidos

- Data/hora
- Posto
- Veículo
- Combustível
- Litros
- Valor pago
- Economia
- Status

### Resumo

- Total de abastecimentos
- Total de litros
- Total gasto
- Total economizado

---

## Segurança

### Autenticação

- Login: CPF + senha
- Token JWT (24h)
- Refresh token (7 dias)
- Bloqueio após 5 tentativas erradas

### Dados Sensíveis

- Tokens em **secure storage**
- Não logar dados sensíveis
- Limpar dados no logout

### Biometria (Futuro)

- Face ID / Touch ID opcional
- Apenas para desbloqueio rápido
- Não substitui login inicial

---

## Offline

### Comportamento

- Mostrar último estado conhecido
- Indicar claramente "Sem conexão"
- Bloquear ações que precisam de API
- Reconectar automaticamente

### Cache

- Lista de veículos
- Lista de postos favoritos
- Histórico recente (últimos 20)

---

## Tratamento de Erros

### Mensagens Amigáveis

| Erro Técnico | Mensagem para Usuário |
|--------------|----------------------|
| 401 Unauthorized | "Sessão expirada. Faça login novamente." |
| 404 Not Found | "Não encontrado. Tente novamente." |
| 500 Server Error | "Erro no servidor. Tente em alguns minutos." |
| Network Error | "Sem conexão. Verifique sua internet." |
| Timeout | "Conexão lenta. Tente novamente." |

### Retry

- Mostrar botão "Tentar novamente"
- Não fazer retry automático infinito
- Máximo 3 tentativas automáticas
