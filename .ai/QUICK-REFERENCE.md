# ⚡ QUICK REFERENCE - ZECA APP

> **Leia SEMPRE antes de desenvolver**

---

## 🚨 REGRAS DE OURO

| ❌ NUNCA | ✅ SEMPRE |
|----------|-----------|
| Hardcode API keys | Usar dotenv/config |
| print() em prod | debugPrint() ou Logger |
| Alterar core/ sem aprovar | Perguntar antes |
| Build manual | Usar scripts/ |

---

## 📁 ESTRUTURA

```
lib/
├── core/       # Infra (NÃO MEXER)
├── features/   # Módulos de negócio
├── routes/     # Navegação
└── shared/     # Componentes
```

---

## 🛠️ COMANDOS

```bash
# Rodar app
flutter run

# Build iOS
./build_testflight.sh

# Build Android
./scripts/build_android_release.sh

# Testes
flutter test

# Análise
flutter analyze
```

---

## 📚 DOCS

| Precisa de... | Leia |
|---------------|------|
| Funcionalidades prontas | `.ai/FUNCIONALIDADES-IMPLEMENTADAS.md` |
| Regras de dev | `.ai/REGRAS.md` |
| Roadmap | `ROADMAP_FUNCIONALIDADES.md` |
| Specs detalhadas | `DETALHAMENTO_FUNCIONALIDADES_PRIORITARIAS.md` |

---

## 🔗 API BACKEND

Base URL: Configurada em `core/config/`

Endpoints principais:
- `POST /auth/login`
- `GET /journeys`
- `POST /journeys`
- `POST /refueling/generate-code`
- `GET /vehicles`
- `GET /partnerships`

---

## 📱 FEATURES

| Feature | Pasta |
|---------|-------|
| Login | `features/auth/` |
| Home | `features/home/` |
| Jornadas | `features/journey/` |
| Abastecimento | `features/refueling/` |
| Checklist | `features/checklist/` |
| Odômetro | `features/odometer/` |
| Notificações | `features/notifications/` |

---

**Última atualização:** 12/12/2025
