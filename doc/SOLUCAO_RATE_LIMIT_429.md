# Solução para Erro 429 (Rate Limit) e Perda de Validação

## 🚨 Problema Identificado

1. **Erro 429 (Too Many Requests):** Rate limiting do backend
2. **Falha ao renovar token:** Quando recebe 429 no refresh token
3. **Risco de perder validação:** Se precisar fazer login novamente, perde o contexto da validação pendente

---

## ✅ Soluções Implementadas

### 1. **Tratamento de Erro 429 com Retry e Backoff Exponencial**

**Arquivo:** `lib/core/services/api_service.dart`

**O que faz:**
- Detecta erro 429 automaticamente
- Faz retry com backoff exponencial (2s, 4s, 8s)
- Máximo de 3 tentativas
- Não limpa tokens se for rate limit temporário

**Código:**
```dart
// Tratar erro 429 (Too Many Requests) com retry com backoff exponencial
if (error.response?.statusCode == 429) {
  // Máximo de 3 tentativas com backoff exponencial
  // Backoff: 2s, 4s, 8s
  // Retry automático da requisição
}
```

### 2. **Refresh Token com Retry para 429**

**Arquivo:** `lib/core/services/api_service.dart`

**O que faz:**
- Quando recebe 401, tenta refresh token
- Se refresh token receber 429, faz retry com backoff
- Não limpa tokens se for rate limit temporário
- Mantém tokens para tentar novamente depois

**Código:**
```dart
// Tentar refresh token com retry para 429
// Não limpa tokens se for rate limit temporário
```

### 3. **Salvar Estado de Validação Pendente**

**Arquivo:** `lib/core/services/pending_validation_storage.dart` (NOVO)

**O que faz:**
- Salva `refuelingId`, `refuelingCode`, `vehicleData`, `stationData`
- Persiste em `SharedPreferences`
- Válido por 24 horas
- Pode ser recuperado após login

**Métodos:**
- `savePendingValidation()` - Salvar estado
- `getPendingValidation()` - Recuperar estado
- `clearPendingValidation()` - Limpar após validação
- `hasPendingValidation()` - Verificar se há pendente

### 4. **Recuperar Validação Após Login**

**Arquivo:** `lib/features/refueling/presentation/pages/refueling_waiting_page.dart`

**O que faz:**
- Salva estado automaticamente quando entra na tela de aguardando
- Limpa estado após validação bem-sucedida
- Estado persiste mesmo se app fechar

---

## 🔄 Fluxo Completo

### Cenário 1: Rate Limit Durante Validação

1. Motorista tenta validar → Erro 429
2. App faz retry automático (2s, 4s, 8s)
3. Se sucesso → Validação completa
4. Se falhar após 3 tentativas → Mostra erro, mas **não perde estado**

### Cenário 2: Token Expira + Rate Limit no Refresh

1. Token expira → Erro 401
2. Tenta refresh token → Erro 429
3. App faz retry do refresh (2s, 4s, 8s)
4. Se sucesso → Continua validação
5. Se falhar → **Estado salvo**, pode recuperar após login

### Cenário 3: Precisa Fazer Login Novamente

1. Token expira e refresh falha → Precisa login
2. Estado de validação **já está salvo**
3. Após login → Verifica se há validação pendente
4. Se houver → Navega automaticamente para tela de aguardando
5. Motorista pode continuar validação

---

## 📋 Próximos Passos (A Implementar)

### 1. Recuperar Validação Após Login

**Onde:** Após login bem-sucedido

**Código necessário:**
```dart
// Após login bem-sucedido
final pendingValidation = await PendingValidationStorage.getPendingValidation();
if (pendingValidation != null) {
  // Navegar para tela de aguardando com dados salvos
  context.go('/refueling-waiting', extra: {
    'refueling_id': pendingValidation['refuelingId'],
    'refueling_code': pendingValidation['refuelingCode'],
    'vehicle_data': pendingValidation['vehicleData'],
    'station_data': pendingValidation['stationData'],
  });
} else {
  // Navegar para home normalmente
  context.go('/home');
}
```

### 2. Verificar na Splash/Home

**Onde:** `splash_page.dart` ou `home_page_simple.dart`

**Código necessário:**
```dart
// Ao iniciar app, verificar se há validação pendente
final hasPending = await PendingValidationStorage.hasPendingValidation();
if (hasPending) {
  // Mostrar notificação ou banner
  // "Você tem uma validação pendente. Continuar?"
}
```

---

## 🛠️ Melhorias Futuras

### 1. Refresh Token Proativo
- Renovar token antes de expirar (ex: 5 minutos antes)
- Evita necessidade de refresh durante operações críticas

### 2. Queue de Requisições
- Fila de requisições para evitar muitos requests simultâneos
- Processar uma por vez durante rate limit

### 3. Notificação de Rate Limit
- Mostrar mensagem ao usuário: "Muitas requisições. Aguarde alguns segundos..."
- Botão "Tentar novamente" após delay

### 4. Cache de Dados de Validação
- Salvar dados completos do abastecimento localmente
- Mostrar mesmo sem conexão

---

## 📊 Status da Implementação

- [x] Tratamento de erro 429 com retry
- [x] Refresh token com retry para 429
- [x] Salvar estado de validação pendente
- [x] Limpar estado após validação
- [ ] Recuperar validação após login (PRÓXIMO)
- [ ] Verificar validação pendente na splash/home
- [ ] Refresh token proativo
- [ ] Notificação de rate limit ao usuário

---

## 🧪 Como Testar

### Teste 1: Rate Limit Durante Validação
1. Tentar validar abastecimento
2. Simular erro 429 (ou esperar rate limit real)
3. Verificar logs: deve fazer retry automático
4. Verificar se validação completa após retry

### Teste 2: Token Expira + Rate Limit
1. Esperar token expirar
2. Tentar validar → Erro 401
3. Refresh token recebe 429
4. Verificar logs: deve fazer retry do refresh
5. Verificar se estado foi salvo

### Teste 3: Recuperar Após Login
1. Fazer logout durante validação pendente
2. Fazer login novamente
3. Verificar se navega para tela de aguardando automaticamente
4. Verificar se dados estão corretos

---

## 💡 Recomendações Backend

### Ajustar Rate Limits
- Aumentar limite para endpoints críticos (validação, refresh token)
- Usar rate limit diferente para refresh token (mais permissivo)

### Headers de Rate Limit
- Retornar `X-RateLimit-Remaining` e `X-RateLimit-Reset`
- App pode usar para mostrar tempo de espera

### Refresh Token Mais Tolerante
- Refresh token não deve ter rate limit tão restritivo
- Ou usar rate limit por IP, não por token






