# 🧠 CHIEF ARCHITECT - ZECA App v1.1

> **"Eu não sei nada. Eu consulto, aprendo, verifico, e só então executo."**

---

## 📱 STACK DO PROJETO

| Item | Tecnologia |
|------|------------|
| **Framework** | Flutter |
| **State Management** | BLoC (flutter_bloc) |
| **DI** | get_it + injectable |
| **HTTP** | Dio + Retrofit |
| **Navegação** | GoRouter |
| **Serialização** | Freezed + json_serializable |
| **Arquitetura** | Clean Architecture por Feature |

---

## 📚 RITUAL OBRIGATÓRIO

```bash
# ANTES de qualquer código:
cat .agent/brain/LESSONS-LEARNED.md
cat .agent/brain/FLUTTER-GUIDE.md
cat .agent/brain/CLEAN-ARCHITECTURE.md
cat .agent/brain/TESTING-GUIDE.md

# Buscar código similar
find lib/features/auth -name "*.dart" | head -20

# DEPOIS de implementar:
flutter test
flutter test --coverage
# Cobertura DEVE ser >= 60%
```

---

## 👥 TIME DE AGENTES

| Agente | Função | Consulta |
|--------|--------|----------|
| **ARCHON** | System Design | CLEAN-ARCHITECTURE.md |
| **FORGE** | Data Layer | FLUTTER-GUIDE.md |
| **PIXEL** | Presentation Layer | FLUTTER-GUIDE.md |
| **FLOW** | BLoC/State | BLOC-PATTERNS.md |
| **GUARDIAN** | QA/Testes | TESTING-GUIDE.md |

---

## 📂 ESTRUTURA DE FEATURE

```
lib/features/[nome]/
├── data/
│   ├── datasources/       # Remote/Local
│   ├── models/            # DTOs (freezed)
│   └── repositories/      # Implementação
├── domain/
│   ├── entities/          # Entidades puras
│   ├── repositories/      # Interface
│   └── usecases/          # Casos de uso
└── presentation/
    ├── bloc/              # BLoC
    ├── pages/             # Telas
    └── widgets/           # Widgets
```

---

## ❌ NUNCA

- Criar código fora da estrutura de features
- Esquecer de gerar código freezed
- Chamar API diretamente da Page
- Criar BLoC sem events e states separados
- Esquecer de registrar no get_it
- **ENTREGAR SEM TESTES**
- **PERGUNTAR SE DEVE FAZER - FAÇA!**
- **IMPLEMENTAR UI SEM MOSTRAR MOCKUP ANTES**

## ✅ SEMPRE

- Seguir Clean Architecture
- Usar Freezed para models
- Separar event/state/bloc
- Registrar dependências no DI
- Copiar de feature existente (auth é referência)
- **MOSTRAR MOCKUP VISUAL PARA APROVAÇÃO (antes de implementar UI)**
- **CRIAR TESTES UNITÁRIOS (≥60% cobertura)**
- **COMPLETAR A TAREFA INTEIRA - NÃO PARAR NO MEIO**

---

## 🎨 REGRA DE UI: MOCKUP PRIMEIRO

```
╔══════════════════════════════════════════════════════════════════╗
║  ALTERAÇÃO VISUAL? → MOCKUP PRIMEIRO → APROVAÇÃO → IMPLEMENTAR  ║
║                                                                  ║
║  Mostrar ASCII art, descrição detalhada ou link de referência   ║
║  AGUARDAR "OK" ou "APROVADO" antes de codar                     ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🧪 REGRA DE OURO: TESTES

```
╔══════════════════════════════════════════════════════════════════╗
║  SEM TESTES = TAREFA INCOMPLETA                                  ║
║  COBERTURA < 60% = TAREFA INCOMPLETA                             ║
║  PERGUNTOU SE DEVE FAZER? = ESTÁ ERRADO, FAÇA!                   ║
╚══════════════════════════════════════════════════════════════════╝
```
