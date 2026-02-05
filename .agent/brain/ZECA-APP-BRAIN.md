---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Conhecimento central do ZECA App - SEMPRE aplicar - 8 REGRAS DE OURO"
---

# 🧠 ZECA APP BRAIN - Base de Conhecimento

> **"Conhecimento compartilhado é poder multiplicado."**

---

## 🥇🥇🥇 8 REGRAS DE OURO DO ZECA (INVIOLÁVEIS) 🥇🥇🥇

```
╔══════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                          ║
║   ESTAS REGRAS NÃO PODEM FALHAR NUNCA - SÃO INVIOLÁVEIS                                 ║
║                                                                                          ║
║   🥇 1. GIT FLOW COMPLETO                                                                ║
║      → Verificar branch + status ANTES de tudo                                           ║
║      → Stash se necessário, criar feature branch                                         ║
║      → Ao final: feature → develop → staging → main                                      ║
║      → NUNCA PULAR                                                                       ║
║                                                                                          ║
║   🥇 2. ARQUITETURA C4 (4 níveis)                                                        ║
║      → Context → Container → Component → Code                                            ║
║      → Cada nível APROVADO antes de avançar                                              ║
║      → Pular apenas se alteração muito pequena (texto, CSS)                              ║
║                                                                                          ║
║   🥇 3. BDD ANTES DE CÓDIGO                                                              ║
║      → Especificação Gherkin APROVADA antes de testes                                    ║
║      → "Se não está no BDD, não deve ser implementado"                                   ║
║      → Pular apenas se refatoração sem mudança de comportamento                          ║
║                                                                                          ║
║   🥇 4. TDD                                                                              ║
║      → Testes ANTES do código                                                            ║
║      → Pular apenas se for documentação                                                  ║
║                                                                                          ║
║   🥇 5. DIAGNÓSTICO ANTES DE CODAR                                                       ║
║      → Ler LESSONS-LEARNED, verificar código existente                                   ║
║      → Entender contexto ANTES de implementar                                            ║
║      → NUNCA PULAR                                                                       ║
║                                                                                          ║
║   🥇 6. MOCKUP ANTES DE UI                                                               ║
║      → Se tem alteração visual → mockup ASCII/HTML → APROVAÇÃO                           ║
║      → Pular apenas se não tem UI (backend only)                                         ║
║                                                                                          ║
║   🥇 7. NÃO DECIDIR SOZINHO                                                              ║
║      → Dúvida? PARAR E PERGUNTAR                                                         ║
║      → Nunca assumir, nunca inventar                                                     ║
║      → NUNCA PULAR                                                                       ║
║                                                                                          ║
║   🥇 8. QUALIDADE > VELOCIDADE                                                           ║
║      → Nunca atalhos. Fazer certo da primeira vez                                        ║
║      → NUNCA PULAR                                                                       ║
║                                                                                          ║
╚══════════════════════════════════════════════════════════════════════════════════════════╝
```

---

## 📋 FLUXO COMPLETO OBRIGATÓRIO

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              FLUXO COMPLETO DO ZECA APP                                 │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                         │
│  🥇 GIT FLOW  →  DIAGNÓSTICO  →  C4 (4 níveis)  →  BDD  →  MOCKUP  →  TDD  →  CÓDIGO  →  FECHAMENTO GIT  │
│       ↓              ↓               ↓             ↓        ↓         ↓        ↓            ↓           │
│   VERIFICAR      APROVAÇÃO       APROVAÇÃO     APROVAÇÃO APROVAÇÃO  APROVAÇÃO APROVAÇÃO   MERGE         │
│                                                                                         │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🥇 REGRA #1: GIT FLOW COMPLETO (INVIOLÁVEL)

### AÇÃO ZERO - Executar SEMPRE antes de qualquer coisa

```bash
# 1. Verificar branch atual
git branch --show-current

# 2. Verificar se tem alterações
git status
```

### Cenário A: Estou em main/staging/develop COM alterações

```bash
git stash -u -m "WIP: alterações antes de criar branch"
git checkout develop && git pull origin develop
git checkout -b feature/nome-da-tarefa
git stash pop
# Continuar trabalho
```

### Cenário B: Estou em main/staging/develop SEM alterações

```bash
git checkout develop && git pull origin develop
git checkout -b feature/nome-da-tarefa
# AGORA pode trabalhar
```

### Cenário C: Estou em feature/* ou fix/*

```
✅ Continuar trabalho normalmente
→ Ao final, executar FLUXO DE FECHAMENTO
```

### FLUXO DE FECHAMENTO (ao terminar implementação)

```bash
# 1. Garantir tudo commitado
git add . && git commit -m "feat(scope): finalização"
git push origin feature/nome-tarefa

# 2. Merge para develop
git checkout develop && git pull origin develop
git merge feature/nome-tarefa --no-ff
git push origin develop

# 3. Merge para staging
git checkout staging && git pull origin staging
git merge develop --no-ff
git push origin staging

# 4. Merge para main
git checkout main && git pull origin main
git merge staging --no-ff
git push origin main

# 5. Voltar para develop e limpar
git checkout develop
git branch -d feature/nome-tarefa
git push origin --delete feature/nome-tarefa
```

---

## 📂 ESTRUTURA DO BRAIN

| Arquivo | Conteúdo | Quando Consultar |
|---------|----------|------------------|
| **LESSONS-LEARNED.md** | Erros → Regras | ⭐ SEMPRE (primeiro!) |
| **FLUTTER-GUIDE.md** | Guia completo Flutter | Criar qualquer código |
| **CLEAN-ARCHITECTURE.md** | Arquitetura do projeto | Criar nova feature |
| **BLOC-PATTERNS.md** | Padrões de BLoC | Criar/modificar BLoC |

---

## 🥇 REGRA #5: DIAGNÓSTICO OBRIGATÓRIO

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🧠 EU NÃO SEI NADA. EU CONSULTO O BRAIN.                      ║
║                                                                  ║
║   Antes de TUDO → LESSONS-LEARNED.md                            ║
║   Nova feature → CLEAN-ARCHITECTURE.md                          ║
║   Código Dart → FLUTTER-GUIDE.md                                ║
║   Estado/BLoC → BLOC-PATTERNS.md                                ║
║                                                                  ║
║   SE NÃO ENCONTRO → BUSCO FEATURE SIMILAR (auth é referência)   ║
║   SE NÃO SEI → NÃO INVENTO                                      ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🔍 FEATURE DE REFERÊNCIA

A feature `auth` é a mais completa e bem estruturada. Use como referência:

```bash
# Ver estrutura
find lib/features/auth -type f -name "*.dart" | grep -v ".freezed\|.g.dart"

# Copiar estrutura para nova feature
cp -r lib/features/auth lib/features/nova_feature
```

---

## 🔧 COMANDOS ESSENCIAIS

```bash
# 🥇 Git Flow (SEMPRE PRIMEIRO!)
git branch --show-current && git status

# Gerar código Freezed/Retrofit
dart run build_runner build --delete-conflicting-outputs

# Analisar código
flutter analyze

# Rodar testes
flutter test
```

---

## ✅ CHECKLIST FINAL (8 Regras de Ouro)

```
□ 🥇 #1 Git Flow: Branch correta verificada (não é main/staging/develop)
□ 🥇 #1 Git Flow: Se tinha alterações em branch errada, fez stash e moveu
□ 🥇 #2 C4: Arquitetura 4 níveis criada e APROVADA
□ 🥇 #3 BDD: Especificação Gherkin criada e APROVADA
□ 🥇 #4 TDD: Testes criados ANTES do código
□ 🥇 #5 Diagnóstico: LESSONS-LEARNED lido, código existente verificado
□ 🥇 #6 Mockup: Mockup ASCII criado e APROVADO (se UI)
□ 🥇 #7 Não decidir sozinho: Todas as dúvidas perguntadas
□ 🥇 #8 Qualidade: Sem atalhos, feito certo da primeira vez
□ `dart run build_runner build` executado
□ `flutter analyze` sem erros
□ `flutter test` passando
□ Cobertura ≥60%
□ Testado no device/emulador
□ Fluxo existente não quebrou
□ 🥇 #1 Git Flow: Fechamento completo (feature→develop→staging→main)
□ LESSONS-LEARNED.md atualizado (se aprendeu algo)
```

---

**🥇 REGRA MÁXIMA: Se tiver dúvida, PARA e PERGUNTA. Qualidade > Velocidade.**
