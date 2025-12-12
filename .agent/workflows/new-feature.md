---
description: Fluxo para implementar nova feature no app
---

# 🚀 NEW FEATURE - ZECA APP

## Fase 1: Preparação

```bash
git checkout develop && git pull
git checkout -b feature/nome develop
```

## Fase 2: Backend (se necessário)

**Verificar no `zeca_site`:**
- [ ] Endpoint existe?
- [ ] DTO está pronto?
- [ ] Swagger documentado?

Se não, implementar primeiro no backend.

## Fase 3: App Flutter

### 3.1 Model/Entity
```dart
// lib/features/[feature]/domain/
class NomeModel {
  // ...
}
```

### 3.2 Repository/Service
```dart
// lib/features/[feature]/data/
class NomeRepository {
  final Dio _dio;
  // ...
}
```

### 3.3 Provider (se usar Provider)
```dart
// lib/features/[feature]/presentation/
class NomeProvider extends ChangeNotifier {
  // ...
}
```

### 3.4 Screens/Widgets
```dart
// lib/features/[feature]/presentation/
class NomeScreen extends StatelessWidget {
  // ...
}
```

## Fase 4: Testes

// turbo
```bash
flutter analyze
flutter test
```

## Fase 5: Build & Test Manual

```bash
# iOS
flutter run -d iPhone

# Android
flutter run -d android
```

- [ ] Testei navegação
- [ ] Testei casos de erro
- [ ] Testei offline (se aplicável)

## Fase 6: Finalização

// turbo
```bash
git add .
git commit -m "feat: descrição"
git push origin feature/nome
```

- [ ] Criar PR: feature → develop
