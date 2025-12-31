# 📱 Análise Completa do App Flutter - ZECA

## RESUMO EXECUTIVO

| Item | Valor |
|------|-------|
| **Total de arquivos .dart** | 231 |
| **State Management** | **BLOC** (flutter_bloc) |
| **Cliente HTTP** | **Dio** |
| **Navegação** | **GoRouter** |
| **Serialização** | **Freezed** + json_serializable |
| **Nomenclatura arquivos** | snake_case |
| **Nomenclatura telas** | Page (27 pages) |
| **Arquitetura** | **Clean Architecture por Feature** |
| **DI** | get_it + injectable |
| **Total de arquivos .md** | ~160 (muitos duplicados) |

---

## 1. Estrutura de Pastas

```
lib/
├── core/                    # Núcleo compartilhado
│   ├── config/             # Configurações e ambiente
│   ├── constants/          # Constantes
│   ├── di/                 # Dependency Injection (get_it)
│   ├── errors/             # Tratamento de erros
│   ├── mock/               # Mock para testes
│   ├── network/            # Configuração Dio
│   ├── services/           # Services compartilhados (16 arquivos)
│   ├── theme/              # Temas e estilos
│   └── utils/              # Utilitários
│
├── features/               # Features isoladas (Clean Architecture)
│   ├── auth/               # Autenticação
│   ├── autonomous/         # Autônomo
│   ├── checklist/          # Checklist
│   ├── history/            # Histórico
│   ├── home/               # Home
│   ├── journey/            # Jornada
│   ├── journey_start/      # Início de jornada
│   ├── notifications/      # Notificações
│   ├── odometer/           # Odômetro/OCR
│   ├── refueling/          # Abastecimento
│   └── splash/             # Splash screen
│
├── routes/                 # Configuração GoRouter
│
└── shared/                 # Widgets compartilhados
    ├── mixins/
    └── widgets/
        ├── buttons/
        ├── common/
        ├── dialogs/
        ├── inputs/
        ├── loading/
        └── permissions/
```

---

## 2. Estrutura de Cada Feature (Clean Architecture)

```
features/[feature]/
├── data/
│   ├── datasources/       # Remote/Local data sources
│   ├── models/            # DTOs (com .freezed.dart/.g.dart)
│   └── repositories/      # Implementação do repository
│
├── domain/
│   ├── entities/          # Entidades de domínio
│   ├── repositories/      # Interface do repository
│   └── usecases/          # Casos de uso
│
└── presentation/
    ├── bloc/              # BLoC (events, states, bloc)
    ├── pages/             # Telas/Pages
    └── widgets/           # Widgets específicos da feature
```

---

## 3. Stack Técnica

### State Management - BLOC
- 43 arquivos usando flutter_bloc
- Cada feature tem seu próprio bloc em `presentation/bloc/`

### Cliente HTTP - Dio
- 19 arquivos usando Dio
- Configuração em `core/network/`
- Usa retrofit para geração de código

### Navegação - GoRouter
- 30 arquivos usando GoRouter
- Configuração em `routes/`

### Serialização - Freezed
- Models usam `@freezed` e `@JsonSerializable`
- Arquivos gerados: `.freezed.dart` e `.g.dart`

---

## 4. Features Existentes

| Feature | Descrição |
|---------|-----------|
| **auth** | Login, cadastro, autenticação |
| **autonomous** | Fluxo de autônomo (cadastro, veículos) |
| **checklist** | Checklist de veículo |
| **history** | Histórico de operações |
| **home** | Tela principal |
| **journey** | Jornada de viagem |
| **journey_start** | Início de jornada |
| **notifications** | Push notifications |
| **odometer** | OCR de odômetro |
| **refueling** | Abastecimento |
| **splash** | Splash screen |

---

## 5. Dependências Principais

```yaml
# State Management
flutter_bloc: ^8.1.3

# DI
get_it: ^7.6.4
injectable: ^2.3.2

# Network
dio: ^5.3.3
retrofit: ^4.0.3

# Navigation
go_router: ^12.1.1

# Serialização
freezed_annotation: ^2.4.1
json_annotation: ^4.8.1

# Local Storage
hive_flutter: ^1.1.0
flutter_secure_storage: ^9.0.0

# Camera/OCR
google_mlkit_text_recognition: ^0.15.0

# Firebase
firebase_messaging: ^15.1.7

# QR Code
qr_flutter: ^4.1.0
mobile_scanner: ^7.0.0
```

---

## 6. Padrões de Código

### Nomenclatura
- **Arquivos:** snake_case (ex: `login_page.dart`)
- **Classes:** PascalCase (ex: `LoginPage`)
- **Variáveis:** camelCase (ex: `userName`)

### Exemplo de Feature - Auth

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_local_datasource.dart
│   │   ├── auth_remote_datasource.dart
│   │   └── user_remote_datasource.dart
│   ├── models/
│   │   ├── login_response_model.dart
│   │   ├── login_response_model.freezed.dart
│   │   ├── login_response_model.g.dart
│   │   ├── user_model.dart
│   │   ├── user_model.freezed.dart
│   │   └── user_model.g.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       └── refresh_token_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    ├── pages/
    │   └── login_page.dart
    └── widgets/
        └── login_form.dart
```

---

## 7. Recomendações

### Limpeza de Arquivos .md
| Pasta | Qtd | Ação |
|-------|-----|------|
| Raiz (`./`) | 37 | Mover para /doc |
| `./doc/` | 111 | Manter |
| `./docs/` | 3 | Mover para /doc |

### Próximos Passos
1. Criar estrutura `.agent/` customizada para Flutter
2. Organizar documentação em `/doc`
3. Remover arquivos duplicados
