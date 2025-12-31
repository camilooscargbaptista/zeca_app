# 📱 ZECA APP ELITE ENGINEERING SYSTEM v1.4

> **"Eu não sei nada. Eu consulto, aprendo, verifico, e só então executo."**

---

## 📂 Estrutura

```
.agent/
├── CHIEF-ARCHITECT.md      # 🧠 Comandante - Regras principais
├── ORCHESTRATOR.md         # 🎯 Coordenador - Workflow de agentes
├── README.md               # 📖 Este arquivo
│
├── brain/                  # 🧠 Base de conhecimento
│   ├── ZECA-APP-BRAIN.md   # Índice do conhecimento
│   ├── LESSONS-LEARNED.md  # ⭐ Erros → Regras
│   ├── FLUTTER-GUIDE.md    # Guia completo Flutter
│   ├── CLEAN-ARCHITECTURE.md # Arquitetura
│   ├── BLOC-PATTERNS.md    # Padrões BLoC
│   └── TESTING-GUIDE.md    # Guia de testes
│
├── agents/                 # 👥 Time de elite
│   ├── ARCHON.md          # System Design
│   ├── FORGE.md           # Data Layer
│   ├── PIXEL.md           # Presentation
│   ├── FLOW.md            # BLoC/State
│   └── GUARDIAN.md        # QA/Testes
│
├── checklists/            # ✅ Checklists
│   └── FEATURE-CHECKLIST.md
│
└── scripts/
    └── setup.sh           # Verificação
```

---

## 🚀 Stack do Projeto

| Item | Tecnologia |
|------|------------|
| Framework | Flutter |
| State | BLoC (flutter_bloc) |
| DI | get_it + injectable |
| HTTP | Dio + Retrofit |
| Navegação | GoRouter |
| Serialização | Freezed |
| Arquitetura | Clean Architecture |

---

## ⚠️ REGRAS INEGOCIÁVEIS

```
╔══════════════════════════════════════════════════════════════════╗
║  1. CONSULTAR BRAIN antes de qualquer ação                      ║
║  2. MOCKUP ASCII para aprovação antes de implementar UI         ║
║  3. WIDGET REAL (nunca imagem PNG/JPG)                          ║
║  4. TESTES OBRIGATÓRIOS (≥60% cobertura)                        ║
║  5. NÃO PERGUNTAR - FAZER!                                      ║
║  6. NÃO QUEBRAR fluxo existente                                 ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🎯 Instalação

```bash
# Extrair na raiz do projeto Flutter
unzip zeca-app-agents-v1.4.zip

# Dar permissão ao script
chmod +x .agent/scripts/setup.sh

# Verificar instalação
.agent/scripts/setup.sh

# Commitar
git add .agent/
git commit -m "feat: ZECA App Elite Engineering v1.4"
```

---

## 📖 Uso

### Prompt para nova feature:
```
Antes de implementar, siga o ritual:
1. cat .agent/brain/LESSONS-LEARNED.md
2. cat .agent/ORCHESTRATOR.md
3. cat .agent/brain/CLEAN-ARCHITECTURE.md
4. cat .agent/brain/FLUTTER-GUIDE.md
5. find lib/features/auth -type f -name "*.dart" | head -20

Tarefa: Criar feature [nome] com [descrição]
```

---

## 🔧 Comandos Essenciais

```bash
# Gerar código Freezed/Retrofit
dart run build_runner build --delete-conflicting-outputs

# Analisar código
flutter analyze

# Testes
flutter test

# Cobertura
flutter test --coverage

# Build
flutter build apk --debug
```
