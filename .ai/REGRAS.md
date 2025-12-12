# 🎯 REGRAS DE DESENVOLVIMENTO - ZECA APP

> **Flutter Mobile App - Motorista**
>
> Última atualização: 12/12/2025

---

## 🚨 REGRAS DE OURO

### 1. NUNCA alterar código sem verificar
```
❌ Modificar services, providers, models existentes
❌ Mudar lógica de autenticação/token
❌ Alterar fluxos de jornada/abastecimento

✅ ANTES: Verificar uso atual, testar impacto
✅ SEMPRE: Perguntar ao usuário antes
```

### 2. NUNCA hardcode
```dart
// ❌ PROIBIDO
const apiUrl = 'https://api.zeca.com';
const googleMapsKey = 'AIza...';

// ✅ CORRETO
final apiUrl = AppConfig.apiUrl;
final googleMapsKey = dotenv.env['GOOGLE_MAPS_KEY'];
```

### 3. SEMPRE usar scripts para build
```bash
# Ver scripts disponíveis
ls scripts/

# iOS
./scripts/build_ios.sh

# Android
./scripts/build_android.sh
```

### 4. Banco de dados - SEMPRE migrations
```
❌ NUNCA alterar banco diretamente
✅ SEMPRE via migrations no backend
```

---

## 🏗️ ARQUITETURA

### Estrutura de Pastas
```
lib/
├── core/           # Infraestrutura (NÃO ALTERAR SEM APROVAÇÃO)
├── features/       # Módulos de negócio
│   └── [feature]/
│       ├── data/       # Repository, API calls
│       ├── domain/     # Models, entities
│       └── presentation/ # Widgets, screens
├── routes/         # Navegação
└── shared/         # Componentes reutilizáveis
```

### Padrões
- **State Management:** Provider/Riverpod
- **DI:** GetIt
- **HTTP:** Dio com interceptors
- **Navegação:** go_router

---

## 🔐 SEGURANÇA

### Token de Autenticação
```dart
// Token JWT armazenado com segurança
// Refresh automático via interceptor
// NUNCA expor em logs
```

### Token de Abastecimento
```
✅ Único (UUID + timestamp)
✅ Expirável (10 minutos)
✅ Uso único
✅ Vinculado a veículo + posto + motorista
```

---

## 📱 TESTES

```bash
# Rodar testes
flutter test

# Coverage
flutter test --coverage
```

---

## 🚀 BUILD & DEPLOY

### iOS (TestFlight)
```bash
./build_testflight.sh
```

### Android (Play Store)
```bash
./scripts/build_android_release.sh
```

---

## 📋 CHECKLIST PRÉ-COMMIT

- [ ] `flutter analyze` sem erros
- [ ] `flutter test` passando
- [ ] Testado em iOS E Android
- [ ] Sem prints/debugPrint em prod
- [ ] Sem hardcoded keys

---

## 📚 DOCS RELACIONADOS

| Doc | Descrição |
|-----|-----------|
| `FUNCIONALIDADES-IMPLEMENTADAS.md` | O que já temos |
| `../ROADMAP_FUNCIONALIDADES.md` | Próximas features |
| `../DETALHAMENTO_FUNCIONALIDADES_PRIORITARIAS.md` | Specs detalhadas |
