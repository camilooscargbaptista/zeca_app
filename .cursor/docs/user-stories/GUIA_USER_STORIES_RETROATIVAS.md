# 📋 Guia: Criação de User Stories Retroativas

**Objetivo:** Documentar features existentes de forma pragmática e útil.

---

## 🎯 Vale a Pena? **SIM, mas com critério!**

### **✅ Benefícios:**

1. **Documentação de referência** → Novas user stories seguirão o padrão
2. **Onboarding completo** → Novos devs entendem TODAS as features
3. **Histórico de decisões** → Contexto para manutenção futura
4. **Lições aprendidas** → O que funcionou, o que não funcionou
5. **Base de conhecimento** → Consulta rápida para evolução

### **⚠️ Cuidados:**

1. **Não gastar semanas** nisso → Ser pragmático
2. **Não detalhar demais** → Foco no que é útil
3. **Não documentar trivialidades** → Só features importantes
4. **Não "inventar" informações** → Se não lembra, deixar em branco ou "desconhecido"

---

## 📊 Features a Documentar (Priorizadas)

### **🔴 Alta Prioridade (CRIAR AGORA)**

Estas são as features mais complexas e críticas. Documentá-las traz máximo valor:

| ID | Feature | Complexidade | Impacto | Estimativa |
|----|---------|--------------|---------|------------|
| **UH-001** | **Autenticação JWT + Sliding Window** | Alta | Crítico | 2h |
| **UH-002** | **Jornadas + Tracking GPS** | Muito Alta | Crítico | 3h ✅ **CRIADO** |
| **UH-003** | **Abastecimento + QR + Polling** | Alta | Crítico | 2.5h |
| **UH-004** | **OCR de Hodômetro (ML Kit)** | Alta | Alto | 2h |
| **UH-005** | **Push Notifications + Deep Links** | Média | Alto | 1.5h |

**Total:** ~11 horas → **1-2 dias de trabalho**

### **🟡 Média Prioridade (CRIAR DEPOIS)**

Features importantes mas menos complexas:

| ID | Feature | Complexidade | Impacto | Estimativa |
|----|---------|--------------|---------|------------|
| **UH-006** | **Checklist de Veículos** | Média | Médio | 1h |
| **UH-007** | **White-label (Multi-brand)** | Média | Alto | 1.5h |
| **UH-008** | **Histórico de Viagens** | Baixa | Médio | 1h |
| **UH-009** | **Telemetria (Eventos, Paradas)** | Alta | Médio | 2h |

**Total:** ~5.5 horas → **1 dia de trabalho**

### **🟢 Baixa Prioridade (OPCIONAL)**

Features simples ou que não trazem muito valor documentar retroativamente:

- Splash screen
- Telas básicas de UI
- Widgets genéricos de formulário
- Validações simples

**Recomendação:** NÃO documentar retroativamente (não vale o tempo)

---

## ⏱️ Plano de Ação Recomendado

### **Opção 1: FOCO (Recomendado)**
**Tempo:** 2-3 dias  
**Escopo:** Apenas 🔴 Alta Prioridade

✅ Cria base sólida de documentação  
✅ Cobre features críticas/complexas  
✅ Máximo ROI (retorno sobre investimento)  

```
Dia 1: UH-001, UH-002 ✅, UH-003
Dia 2: UH-004, UH-005
```

### **Opção 2: COMPLETO**
**Tempo:** 3-4 dias  
**Escopo:** 🔴 Alta + 🟡 Média Prioridade

✅ Documentação muito completa  
✅ Cobre 90% das features  
⚠️ Mais tempo investido  

```
Dia 1-2: Alta Prioridade
Dia 3-4: Média Prioridade
```

### **Opção 3: MÍNIMO**
**Tempo:** 1 dia  
**Escopo:** Apenas top 3 mais críticas

⚠️ Documentação incompleta  
✅ Rápido  
✅ Cobre o essencial  

```
UH-001: Autenticação
UH-002: Jornadas ✅
UH-003: Abastecimento
```

---

## 📝 Como Criar Cada User Story

### **Passo a Passo:**

1. **Copiar template:**
```bash
cp .cursor/docs/user-stories/TEMPLATE_RETROATIVO.md \
   .cursor/docs/user-stories/UH-XXX-nome-feature.md
```

2. **Preencher seções principais:**
   - ✅ Descrição (Como/Eu quero/Para que)
   - ✅ Valor de negócio (Por quê foi feito)
   - ✅ O que foi implementado (Checklist de features)
   - ✅ Arquitetura (Estrutura de código, packages)
   - ✅ Decisões técnicas (Principais escolhas + por quê)
   - ✅ Telas implementadas (Lista + paths)
   - ✅ Fluxos de usuário (Passo a passo)
   - ✅ Integração backend (Endpoints usados)
   - ✅ Lições aprendidas (O que funcionou/não funcionou)

3. **Preencher seções opcionais:**
   - Testes (se houver)
   - Métricas (se souber)
   - Problemas conhecidos (se houver)

4. **Revisar:**
   - Informações corretas?
   - Links funcionando?
   - Útil para alguém novo no projeto?

**Tempo médio:** 1-3 horas por user story (dependendo da complexidade)

---

## 🎯 Exemplo de User Story Retroativa

Veja o exemplo já criado:

→ [UH-002: Jornadas com Tracking GPS](./UH-002-jornadas-tracking-gps.md)

Este exemplo mostra:
- ✅ Como estruturar a informação
- ✅ Nível de detalhe adequado
- ✅ Seções mais importantes
- ✅ Lições aprendidas valiosas

---

## 📊 ROI (Retorno sobre Investimento)

### **Investimento:**
- **Opção 1 (Foco):** 2-3 dias
- **Opção 2 (Completo):** 3-4 dias
- **Opção 3 (Mínimo):** 1 dia

### **Retorno:**
- **Onboarding de novo dev:** Redução de 3-5 dias → 1-2 dias
- **Manutenção de features:** Contexto imediato vs 2-4h pesquisando código
- **Evolução de features:** Entender decisões anteriores vs refazer do zero
- **Documentação de referência:** Padrão claro para novas features

**Exemplo:**
- Se 1 novo dev usar a documentação → Economiza ~4 dias
- Se evitar 1 refatoração desnecessária → Economiza ~3 dias
- Se acelerar 2 manutenções → Economiza ~6h

**Total economizado:** ~5-6 dias  
**Investimento:** 2-3 dias  
**ROI:** ~200% ✅ Vale muito a pena!

---

## ✅ Checklist de Execução

### **Antes de Começar:**
- [ ] Decidir escopo (Opção 1, 2 ou 3)
- [ ] Reservar tempo no calendário
- [ ] Revisar código das features para refrescar memória
- [ ] Ter template retroativo (`TEMPLATE_RETROATIVO.md`)

### **Durante a Criação:**
- [ ] Seguir ordem de prioridade
- [ ] Não passar mais de 3h por user story
- [ ] Focar em informações úteis (não perfeição)
- [ ] Deixar "desconhecido" se não lembrar (não inventar)

### **Depois de Criar:**
- [ ] Revisar links e paths
- [ ] Validar se é útil (pedir feedback de outro dev)
- [ ] Atualizar índice de user stories (se houver)

---

## 🎬 Começar Agora?

### **Recomendação: SIM! Começar com Opção 1 (Foco)**

**Por quê:**
1. Documentação é investimento que se paga sozinho
2. Features complexas PRECISAM de contexto documentado
3. Onboarding de novos devs fica 3x mais rápido
4. Lições aprendidas são valiosas para futuras features

**Próximo passo:**
```bash
# 1. Já temos UH-002 criado ✅
# 2. Próximo: UH-001 (Autenticação)

cp .cursor/docs/user-stories/TEMPLATE_RETROATIVO.md \
   .cursor/docs/user-stories/UH-001-autenticacao-jwt.md

# Editar e preencher...
```

---

## 📅 Cronograma Sugerido

### **Semana 1:**
- [x] Segunda: UH-002 (Jornadas) ✅ CRIADO
- [ ] Terça: UH-001 (Autenticação)
- [ ] Quarta: UH-003 (Abastecimento)

### **Semana 2:**
- [ ] Segunda: UH-004 (OCR)
- [ ] Terça: UH-005 (Push Notifications)
- [ ] Quarta: Revisão geral

**Total:** ~2 semanas (part-time) ou 3 dias (full-time)

---

## 🎯 Meta

**Ter documentação completa das 5 features mais críticas até:** [Data alvo]

**Status Atual:**
- [x] UH-002: Jornadas ✅
- [ ] UH-001: Autenticação
- [ ] UH-003: Abastecimento
- [ ] UH-004: OCR
- [ ] UH-005: Push Notifications

**Progresso:** 20% (1/5)

---

## 🤝 Precisa de Ajuda?

- **Template:** `.cursor/docs/user-stories/TEMPLATE_RETROATIVO.md`
- **Exemplo:** `.cursor/docs/user-stories/UH-002-jornadas-tracking-gps.md`
- **Dúvidas:** Consultar arquitetura (`.cursor/docs/architecture/`)

---

**Criado em:** 27/11/2025  
**Versão:** 1.0  
**Próxima revisão:** Após concluir 5 user stories

