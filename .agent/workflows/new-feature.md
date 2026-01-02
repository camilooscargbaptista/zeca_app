---
description: Criar nova funcionalidade completa seguindo Clean Architecture + BLoC
---

# /new-feature - Nova Funcionalidade Flutter

## Pré-requisitos

Antes de começar, verificar se entendeu a demanda:
- Qual é a funcionalidade?
- Quem vai usar? (motorista, frotista, atendente)
- Tem interface visual?
- Precisa de API? Qual endpoint?
- Precisa de persistência local?

---

## Steps

### 1. Diagnóstico Obrigatório

```bash
# Ler lições aprendidas
cat .context/LESSONS-LEARNED.md

# Verificar arquitetura
cat .context/ARCHITECTURE.md

# Verificar contratos de API
cat .context/API-CONTRACTS.md

# Verificar regras de negócio
cat .context/BUSINESS-RULES.md
```

### 2. Verificar Estrutura Existente

```bash
# Features existentes
ls -la lib/features/

# Verificar se feature já existe
find lib -name "*[termo]*" -type d

# BLoCs existentes
find lib -name "*_bloc.dart" | head -10

# Models existentes
find lib -name "*_model.dart" | head -10

# Verificar DI (injection)
cat lib/injection.dart 2>/dev/null || cat lib/core/di/*.dart 2>/dev/null | head -30
```

### 3. Gerar User Story

```markdown
## US-XXX: [Título da Feature]

**COMO** [persona: motorista/frotista/atendente]
**QUERO** [ação desejada]
**PARA** [benefício esperado]

### Critérios de Aceite:
- [ ] CA1: [critério mensurável]
- [ ] CA2: [critério mensurável]
- [ ] CA3: [critério mensurável]

### Regras de Negócio:
- RN01: [regra]
- RN02: [regra]
```

**AGUARDAR APROVAÇÃO DA USER STORY**

### 4. Quebrar em Tasks

```markdown
## TASK-001: [Domain] Criar Entity e Repository Interface
**Camada:** Domain
**Arquivos:**
- lib/features/[nome]/domain/entities/[nome].dart
- lib/features/[nome]/domain/repositories/[nome]_repository.dart

## TASK-002: [Domain] Criar UseCases
**Camada:** Domain
**Dependência:** TASK-001
**Arquivos:**
- lib/features/[nome]/domain/usecases/get_[nome].dart
- lib/features/[nome]/domain/usecases/create_[nome].dart

## TASK-003: [Data] Criar Model e DataSource
**Camada:** Data
**Dependência:** TASK-001
**Arquivos:**
- lib/features/[nome]/data/models/[nome]_model.dart
- lib/features/[nome]/data/datasources/[nome]_remote_datasource.dart

## TASK-004: [Data] Criar Repository Implementation
**Camada:** Data
**Dependência:** TASK-002, TASK-003
**Arquivos:**
- lib/features/[nome]/data/repositories/[nome]_repository_impl.dart

## TASK-005: [Presentation] Criar Mockup ASCII
**Camada:** Presentation
**Arquivos:**
- (mostrar no chat para aprovação)

## TASK-006: [Presentation] Criar BLoC
**Camada:** Presentation
**Dependência:** TASK-002, TASK-005 (aprovação)
**Arquivos:**
- lib/features/[nome]/presentation/bloc/[nome]_bloc.dart
- lib/features/[nome]/presentation/bloc/[nome]_event.dart
- lib/features/[nome]/presentation/bloc/[nome]_state.dart

## TASK-007: [Presentation] Criar Page e Widgets
**Camada:** Presentation
**Dependência:** TASK-005 (aprovação), TASK-006
**Arquivos:**
- lib/features/[nome]/presentation/pages/[nome]_page.dart
- lib/features/[nome]/presentation/widgets/[nome]_widget.dart

## TASK-008: [DI] Registrar no Injection
**Dependência:** TASK-004, TASK-006
**Arquivos:**
- lib/injection.dart (ou equivalente)

## TASK-009: [QA] Criar Testes
**Dependência:** Todas anteriores
**Arquivos:**
- test/features/[nome]/...
```

### 5. Criar Mockup ASCII (se houver UI)

```
┌─────────────────────────────────────────┐
│ ←  [Título da Tela]                     │
├─────────────────────────────────────────┤
│                                         │
│   [Conteúdo principal]                  │
│                                         │
│   ┌─────────────────────────────────┐   │
│   │  Card/Lista/Form                │   │
│   └─────────────────────────────────┘   │
│                                         │
│   ┌─────────────────────────────────┐   │
│   │       BOTÃO PRIMÁRIO            │   │
│   └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘

Estados:
- Loading: Spinner centralizado
- Error: Mensagem + botão "Tentar novamente"
- Empty: Ilustração + mensagem
- Success: Conteúdo acima
```

**AGUARDAR APROVAÇÃO DO MOCKUP**

### 6. Implementar Domain Layer

```dart
// 1. Entity
// lib/features/[nome]/domain/entities/[nome].dart

// 2. Repository Interface
// lib/features/[nome]/domain/repositories/[nome]_repository.dart

// 3. UseCases
// lib/features/[nome]/domain/usecases/get_[nome].dart
```

### 7. Implementar Data Layer

```dart
// 1. Model (com Freezed)
// lib/features/[nome]/data/models/[nome]_model.dart

// 2. Rodar build_runner
dart run build_runner build --delete-conflicting-outputs

// 3. DataSource
// lib/features/[nome]/data/datasources/[nome]_remote_datasource.dart

// 4. Repository Implementation
// lib/features/[nome]/data/repositories/[nome]_repository_impl.dart
```

### 8. Implementar Presentation Layer

```dart
// 1. BLoC (Event, State, Bloc)
// lib/features/[nome]/presentation/bloc/

// 2. Page
// lib/features/[nome]/presentation/pages/[nome]_page.dart

// 3. Widgets
// lib/features/[nome]/presentation/widgets/
```

### 9. Registrar no DI

```dart
// lib/injection.dart
// Registrar: DataSource, Repository, UseCase, BLoC
```

### 10. Criar Testes

```bash
# Criar testes para cada camada
# test/features/[nome]/data/...
# test/features/[nome]/domain/...
# test/features/[nome]/presentation/...

# Rodar testes
flutter test

# Verificar cobertura
flutter test --coverage
```

### 11. Validação Final

```bash
# Análise estática
flutter analyze

# Testes
flutter test

# Build (verificar se compila)
flutter build apk --debug
```

---

## Checklist Final

```
□ User Story aprovada
□ Tasks definidas
□ Mockup ASCII aprovado (se UI)
□ Domain Layer implementado
□ Data Layer implementado
□ build_runner executado
□ Presentation Layer implementado
□ DI configurado
□ Testes criados e passando
□ Cobertura ≥60%
□ flutter analyze sem warnings
□ Testado no emulador/dispositivo
```
