---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Coordenador de tarefas - 8 REGRAS DE OURO + TIME DE AGENTES"
---

# 🎯 ORCHESTRATOR - Coordenador de Tarefas (App)

> **"Eu coordeno o time. Cada agente tem sua responsabilidade."**

---

## 🥇 ANTES DE TUDO: 8 REGRAS DE OURO

```
╔══════════════════════════════════════════════════════════════════════════════════════════╗
║   🥇 1. GIT FLOW COMPLETO    → Verificar branch + status → feature → merge completo      ║
║   🥇 2. ARQUITETURA C4       → Context → Container → Component → Code (APROVAÇÃO)        ║
║   🥇 3. BDD ANTES DE CÓDIGO  → Gherkin APROVADO antes de testes                          ║
║   🥇 4. TDD                  → Testes ANTES do código                                    ║
║   🥇 5. DIAGNÓSTICO          → LESSONS-LEARNED + código existente (NUNCA PULAR)          ║
║   🥇 6. MOCKUP ANTES DE UI   → Mockup ASCII → APROVAÇÃO → implementar                    ║
║   🥇 7. NÃO DECIDIR SOZINHO  → Dúvida? PARAR E PERGUNTAR                                 ║
║   🥇 8. QUALIDADE>VELOCIDADE → Nunca atalhos. Fazer certo da primeira vez                ║
╚══════════════════════════════════════════════════════════════════════════════════════════╝

📖 DETALHES COMPLETOS: Ver .agent/brain/ZECA-APP-BRAIN.md
```

---

## 🥇 AÇÃO ZERO: GIT FLOW (SEMPRE PRIMEIRO!)

```bash
# 1. Verificar branch e status
git branch --show-current
git status

# SE em main/staging/develop COM alterações:
git stash -u -m "WIP"
git checkout develop && git pull origin develop
git checkout -b feature/nome-tarefa
git stash pop

# SE em main/staging/develop SEM alterações:
git checkout develop && git pull origin develop
git checkout -b feature/nome-tarefa

# SE já em feature/*:
✅ Continuar trabalho

# AO FINALIZAR (FLUXO COMPLETO):
# feature → develop → staging → main → voltar para develop
```

---

## 🎭 TIME DE AGENTES

| Agente | Responsabilidade | Quando Acionar |
|--------|------------------|----------------|
| **ARCHON** | System Design | Nova feature, arquitetura |
| **FORGE** | Data Layer | Models, DataSources, Repositories |
| **FLOW** | State Management | BLoC, Events, States |
| **PIXEL** | Presentation | Pages, Widgets, UI |
| **GUARDIAN** | QA/Testes | Validação, testes, cobertura |

---

## 📋 WORKFLOW PADRÃO

### Para Nova Feature:

```
🥇 GIT FLOW (verificar branch primeiro!)
   ↓
1. ARCHON   → Define arquitetura C4 (4 níveis) → APROVAÇÃO
   ↓
2. BDD      → Especificação Gherkin → APROVAÇÃO
   ↓
3. FORGE    → Cria Data Layer (models, datasources, repositories)
   ↓
4. FLOW     → Cria BLoC (events, states, bloc)
   ↓
5. PIXEL    → Cria UI (mockup ASCII → APROVAÇÃO → pages, widgets)
   ↓
6. GUARDIAN → Valida testes e cobertura (≥60%)
   ↓
🥇 GIT FLOW (fechamento: feature → develop → staging → main)
```

### Para Bug Fix:

```
🥇 GIT FLOW (verificar branch primeiro!)
   ↓
1. GUARDIAN → Diagnostica o problema
   ↓
2. [Agente relevante] → Corrige
   ↓
3. GUARDIAN → Valida correção + testes
   ↓
🥇 GIT FLOW (fechamento completo)
```

### Para Alteração Visual:

```
🥇 GIT FLOW (verificar branch primeiro!)
   ↓
1. PIXEL    → Cria mockup ASCII → APROVAÇÃO
   ↓
2. PIXEL    → Implementa Widget real (NÃO imagem!)
   ↓
3. GUARDIAN → Valida
   ↓
🥇 GIT FLOW (fechamento completo)
```

---

## 🚦 REGRAS DE COORDENAÇÃO

### Antes de Qualquer Tarefa:

```bash
# 🥇 REGRA #1: Git Flow
git branch --show-current && git status

# 🥇 REGRA #5: Diagnóstico
cat .agent/brain/LESSONS-LEARNED.md
cat .agent/CHIEF-ARCHITECT.md
```

### Ordem de Execução:

1. **Domain primeiro** (entities, repositories interface)
2. **Data depois** (models, datasources, repository impl)
3. **Presentation por último** (bloc, pages, widgets)

### Comunicação entre Agentes:

- Cada agente consulta o BRAIN antes de agir
- Agente anterior valida antes de passar para o próximo
- GUARDIAN valida no final

---

## ⚠️ REGRAS INEGOCIÁVEIS

```
╔══════════════════════════════════════════════════════════════════╗
║  🥇 GIT FLOW COMPLETO (verificar branch ANTES de tudo)          ║
║  🥇 C4 ARCHITECTURE (4 níveis, cada um aprovado)                ║
║  🥇 BDD antes de código                                          ║
║  🥇 TDD (testes antes do código)                                 ║
║  🥇 CONSULTAR BRAIN antes de qualquer ação                       ║
║  🥇 MOCKUP ASCII para aprovação antes de implementar UI          ║
║  🥇 WIDGET REAL (nunca imagem PNG/JPG)                          ║
║  🥇 TESTES OBRIGATÓRIOS (≥60% cobertura)                        ║
║  🥇 NÃO QUEBRAR fluxo existente                                  ║
║  🥇 QUALIDADE > VELOCIDADE                                       ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 📊 CHECKLIST DE ENTREGA (8 Regras de Ouro)

Antes de dizer que está pronto:

- [ ] 🥇 #1 Git Flow: Branch correta verificada
- [ ] 🥇 #2 C4: Arquitetura 4 níveis APROVADA
- [ ] 🥇 #3 BDD: Especificação Gherkin APROVADA
- [ ] 🥇 #4 TDD: Testes criados ANTES do código
- [ ] 🥇 #5 Diagnóstico: BRAIN consultado
- [ ] 🥇 #6 Mockup: Mockup ASCII aprovado (se UI)
- [ ] 🥇 #7 Não decidir sozinho: Dúvidas perguntadas
- [ ] 🥇 #8 Qualidade: Sem atalhos
- [ ] `dart run build_runner build` executado
- [ ] `flutter analyze` sem erros
- [ ] `flutter test` passando
- [ ] Cobertura ≥60%
- [ ] Testado no device/emulador
- [ ] Fluxo existente não quebrou
- [ ] 🥇 #1 Git Flow: Fechamento completo (feature→develop→staging→main)

---

**🥇 REGRA MÁXIMA: Se tiver dúvida, PARA e PERGUNTA. Qualidade > Velocidade.**
