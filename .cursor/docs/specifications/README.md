# 📋 Especificações Técnicas - ZECA App

Esta pasta contém especificações detalhadas de implementação de features do app mobile.

---

## 📄 Documentos Disponíveis

### **Core Features**

| Documento | Descrição | Status |
|-----------|-----------|--------|
| [TELEMETRIA_APP_SPECIFICATION.md](./TELEMETRIA_APP_SPECIFICATION.md) | Especificação completa da telemetria (eventos, paradas, GPS) | ✅ Implementado |
| [JOURNEY_START_IMPLEMENTATION.md](./JOURNEY_START_IMPLEMENTATION.md) | Implementação de início de jornada | ✅ Implementado |
| [BACKEND_TRECHOS_JORNADA.md](./BACKEND_TRECHOS_JORNADA.md) | Integração de trechos de jornada com backend | ✅ Implementado |
| [IMPLEMENTACAO_BACKGROUND_GEO_COMPLETA.md](./IMPLEMENTACAO_BACKGROUND_GEO_COMPLETA.md) | Tracking GPS em background | ✅ Implementado |

### **Refueling (Abastecimento)**

| Documento | Descrição | Status |
|-----------|-----------|--------|
| [BACKEND_POLLING_IMPLEMENTATION.md](./BACKEND_POLLING_IMPLEMENTATION.md) | Polling para buscar dados de abastecimento | ✅ Implementado |
| [VALIDACAO_REFUELING_ID.md](./VALIDACAO_REFUELING_ID.md) | Validação de abastecimento pelo motorista | ✅ Implementado |

### **OCR & Computer Vision**

| Documento | Descrição | Status |
|-----------|-----------|--------|
| [ODOMETER_OCR_IMPROVEMENTS.md](./ODOMETER_OCR_IMPROVEMENTS.md) | Melhorias no OCR de hodômetro | ✅ Implementado |

### **Push Notifications**

| Documento | Descrição | Status |
|-----------|-----------|--------|
| [TESTE_PUSH_NOTIFICATIONS.md](./TESTE_PUSH_NOTIFICATIONS.md) | Testes e configuração de push notifications | ✅ Implementado |

---

## 📝 Como Usar Esta Pasta

### **Ao criar nova feature:**

1. **Escrever especificação detalhada** nesta pasta
2. Incluir:
   - Objetivo da feature
   - Requisitos funcionais
   - Requisitos técnicos
   - Fluxos de usuário
   - Endpoints da API necessários
   - Estrutura de dados
   - Casos de teste

### **Template de Especificação:**

```markdown
# [Nome da Feature]

## 📝 Objetivo
[O que esta feature faz]

## 🎯 Requisitos Funcionais
- [ ] RF-1: Descrição
- [ ] RF-2: Descrição

## 🔧 Requisitos Técnicos
### Flutter:
- Packages necessários
- Permissões necessárias

### Backend:
- Endpoints necessários
- Estrutura de dados

## 👤 Fluxos de Usuário
1. Passo 1
2. Passo 2

## 📊 Estrutura de Dados
```dart
// Models
```

## 🧪 Casos de Teste
- [ ] Teste 1
- [ ] Teste 2

## 📖 Referências
- Links úteis
```

---

## 🔄 Relacionamento com Outras Pastas

### **.cursor/docs/architecture/**
→ Especificações aqui devem seguir a arquitetura definida

### **.cursor/docs/patterns/**
→ Especificações devem seguir os padrões de código

### **.cursor/activities/**
→ Implementações de especificações ficam nas activities

---

**Organizado em:** 27/11/2025  
**Versão:** 1.0.0

