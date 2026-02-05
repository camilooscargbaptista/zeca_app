---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Índice principal - SEMPRE ler antes de qualquer tarefa"
---


# 📱 ZECA App Elite Engineering System v2.0.0

> **"Eu não sei nada. Eu consulto, aprendo, verifico, e só então executo."**

---

## 🚀 Quick Start - ANTES DE QUALQUER TAREFA

```bash
# 1. Ler este índice (você está aqui ✓)
# 2. Ler PREFLIGHT obrigatório
cat .agent/guards/PREFLIGHT.md

# 3. Verificar erros passados
cat .context/LESSONS-LEARNED.md

# 4. Consultar regras de negócio
cat .context/BUSINESS-RULES.md
```

---

## 📂 Navegação Rápida

### Preciso de... → Vá para...

| Necessidade | Arquivo | Descrição |
|-------------|---------|-----------|
| 🚦 **Antes de começar** | `guards/PREFLIGHT.md` | Checklist obrigatório 6 fases |
| ❌ **Evitar erros** | `guards/ERROR-PATTERNS.md` | 25+ anti-patterns Flutter |
| ✅ **Critérios de qualidade** | `guards/QUALITY-GATES.md` | 12 quality gates |
| 📖 **Regras de negócio** | `.context/BUSINESS-RULES.md` | Regras RN-XXX ZECA |
| 📚 **Erros passados** | `.context/LESSONS-LEARNED.md` | Não repita erros |
| 🔤 **Termos do domínio** | `.context/GLOSSARY.md` | Glossário ZECA |
| ⚡ **Referência rápida** | `.context/CHEATSHEET.md` | Comandos e padrões |
| 📊 **Visualizar fluxos** | `.context/DIAGRAMS.md` | Diagramas Mermaid |

---

## 🧠 Base de Conhecimento (Brain)

| Tópico | Arquivo | Quando usar |
|--------|---------|-------------|
| 🏗️ **Arquitetura** | `brain/CLEAN-ARCHITECTURE.md` | Nova feature, estrutura |
| 🔄 **Estado** | `brain/BLOC-PATTERNS.md` | BLoC, Cubit, estados |
| 🧊 **Modelos** | `brain/FREEZED-PATTERNS.md` | Models, States, Events |
| 💉 **Injeção** | `brain/DI-PATTERNS.md` | get_it, injectable |
| 🧪 **Testes** | `brain/TESTING-GUIDE.md` | Testes unitários, widget |
| 📱 **Flutter** | `brain/FLUTTER-GUIDE.md` | Widgets, lifecycle |

---

## 👥 Time de Agentes Especializados

| Agente | Arquivo | Responsabilidade |
|--------|---------|------------------|
| 🏛️ **ARCHON** | `agents/ARCHON.md` | System Design, arquitetura |
| ⚒️ **FORGE** | `agents/FORGE.md` | Data Layer (API, Repository) |
| 🎨 **PIXEL** | `agents/PIXEL.md` | Presentation (UI, Widgets) |
| 🌊 **FLOW** | `agents/FLOW.md` | BLoC, State Management |
| 🛡️ **GUARDIAN** | `agents/GUARDIAN.md` | QA, Testes, Qualidade |

---

## 📋 Workflows

| Tarefa | Arquivo | Passos |
|--------|---------|--------|
| ✨ Nova feature | `workflows/new-feature.md` | Planejamento → Implementação |
| 🐛 Corrigir bug | `workflows/fix-bug.md` | Análise → Correção → Teste |
| 🎨 Criar mockup | `workflows/create-mock.md` | ASCII art → Aprovação |
| 🧪 Gerar testes | `workflows/generate-tests.md` | Unit → Widget → Integration |
| 👀 Code review | `workflows/code-review.md` | Checklist de revisão |
| 🔧 Refatorar | `workflows/refactoring.md` | Identificar → Melhorar |

---

## 🛡️ Skills Especializados

| Skill | Arquivo | Foco |
|-------|---------|------|
| 📝 **Dart Style** | `skills/DART-STYLE.md` | Effective Dart, convenções |
| 🧩 **Widgets** | `skills/WIDGET-PATTERNS.md` | Padrões de composição |
| ⚡ **Performance** | `skills/PERFORMANCE.md` | Otimização Flutter |

---

## 🔧 Comandos Essenciais

```bash
# Gerar código (Freezed, Retrofit, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Análise estática
flutter analyze

# Testes
flutter test

# Cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Formatar código
dart format lib/

# Build debug
flutter build apk --debug
flutter build ios --debug --no-codesign
```

---

## 📊 Stack do Projeto

| Componente | Tecnologia | Versão |
|------------|------------|--------|
| Framework | Flutter | 3.x |
| State Management | flutter_bloc | ^8.x |
| DI | get_it + injectable | latest |
| HTTP | Dio + Retrofit | latest |
| Navegação | GoRouter | latest |
| Serialização | Freezed + json_serializable | latest |
| Arquitetura | Clean Architecture | - |

---

## ⚠️ REGRAS INEGOCIÁVEIS

```
╔══════════════════════════════════════════════════════════════════════════╗
║  1. PREFLIGHT OBRIGATÓRIO antes de qualquer tarefa                       ║
║  2. CONSULTAR BRAIN antes de implementar                                 ║
║  3. MOCKUP ASCII/HTML para aprovação antes de UI                         ║
║  4. WIDGET REAL (nunca imagem PNG/JPG)                                   ║
║  5. TESTES OBRIGATÓRIOS (≥60% cobertura)                                 ║
║  6. build_runner SEMPRE após alterar Freezed                             ║
║  7. NÃO INVENTAR código - verificar se existe                            ║
║  8. NÃO QUEBRAR fluxo existente                                          ║
║  9. REGRAS RN-XXX são lei - consultar antes de implementar               ║
║  10. QUALITY GATES devem passar antes de PR                              ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 📈 Métricas de Qualidade

| Métrica | Meta | Comando |
|---------|------|---------|
| Cobertura de testes | ≥ 60% | `flutter test --coverage` |
| Warnings do analyze | 0 | `flutter analyze` |
| Erros de lint | 0 | `dart analyze` |
| Código formatado | 100% | `dart format --set-exit-if-changed lib/` |

---

## 🔗 Links Relacionados

- **Backend API:** Consultar `zeca_site` para endpoints
- **Contratos:** `.context/API-CONTRACTS.md`
- **Arquitetura geral:** `.context/ARCHITECTURE.md`

---

## 📝 Changelog

Ver `CHANGELOG.md` para histórico de versões deste sistema.

---

*ZECA App Elite Engineering System v2.0.0 - Janeiro 2026*
