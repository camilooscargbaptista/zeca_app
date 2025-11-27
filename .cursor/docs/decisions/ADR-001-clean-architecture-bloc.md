# ADR-001: Usar Clean Architecture + BLoC Pattern

## Status
✅ **Aceito** (Implementado desde o início do projeto)

## Contexto
Precisávamos escolher uma arquitetura escalável e um padrão de gerenciamento de estado para o app Flutter. As principais opções consideradas foram:

### **Arquitetura:**
1. **Clean Architecture** - Separação em camadas (data/domain/presentation)
2. **MVVM** - Model-View-ViewModel
3. **MVC** - Model-View-Controller (Flutter tradicional)

### **State Management:**
1. **BLoC** (Business Logic Component) - flutter_bloc
2. **Provider** - Simples mas menos escalável
3. **Riverpod** - Moderno mas menos adoção
4. **GetX** - All-in-one mas opinativo demais

## Decisão
**Escolhemos Clean Architecture + BLoC Pattern**

---

## Justificativa

### **Por que Clean Architecture:**

✅ **Vantagens:**
- **Separação de responsabilidades clara**:
  - `data/` - Tudo relacionado a dados (APIs, local storage)
  - `domain/` - Regras de negócio puras (independente de framework)
  - `presentation/` - UI + State management
  
- **Testabilidade excepcional**:
  - Domain layer testável sem dependências externas
  - Mock de repositórios facilmente
  - Testes unitários rápidos

- **Independência de frameworks**:
  - Domain não conhece Flutter
  - Fácil migrar para outro framework (improvável mas possível)
  
- **Escalabilidade**:
  - Estrutura clara para features grandes
  - Novos desenvolvedores entendem rapidamente
  
- **Manutenibilidade**:
  - Mudanças em APIs não afetam domain
  - Mudanças em UI não afetam domain
  - Single Responsibility Principle

### **Por que BLoC:**

✅ **Vantagens:**
- **Previsibilidade**:
  - Fluxo unidirecional (Event → State)
  - Fácil debug (todas as mudanças são events)
  
- **Separação UI ↔ Logic**:
  - BLoC não conhece widgets
  - Widgets só disparam events e ouvem states
  
- **Testabilidade**:
  - `bloc_test` package facilita testes
  - Mock de dependencies simples
  
- **Reatividade**:
  - Streams nativos (Dart)
  - RxDart integrado
  
- **Padrão oficial Google**:
  - Documentação extensa
  - Grande comunidade
  - Atualizado constantemente
  
- **Escala bem**:
  - Features isoladas
  - BLoCs podem se comunicar via streams

### **Por que NÃO Provider:**
- ⚠️ Menos estruturado para apps grandes
- ⚠️ Mistura fácil de UI e lógica
- ⚠️ Dificulta testes complexos

### **Por que NÃO Riverpod:**
- ⚠️ Menor adoção (na época da decisão)
- ⚠️ API ainda mudando muito
- ⚠️ Menos exemplos e tutoriais

### **Por que NÃO GetX:**
- ⚠️ Muito opinativo (mistura state + navigation + DI)
- ⚠️ "Magic" demais (dificulta debug)
- ⚠️ Menos alinhado com boas práticas Flutter

---

## Consequências

### **Positivas:**

✅ **Código organizado e previsível**
- Cada developer sabe onde colocar código
- Features isoladas, fácil trabalhar em paralelo

✅ **Testes robustos**
- Domain testável 100% sem mock
- BLoCs testáveis com bloc_test
- Cobertura alta alcançável

✅ **Manutenção facilitada**
- Mudanças localizadas
- Refatoração segura
- Onboarding de novos devs rápido

✅ **Escalabilidade**
- App cresceu de 3 para 10+ features sem problemas
- Estrutura se mantém clara

✅ **Integração com backend**
- Repositories abstraem APIs
- Fácil trocar implementação (mock ↔ real)

### **Negativas/Trade-offs:**

⚠️ **Boilerplate inicial**
- Mais arquivos por feature (entities, models, repos, blocs)
- Setup inicial mais demorado
- **Mitigação:** Templates e snippets VS Code

⚠️ **Curva de aprendizado**
- Desenvolvedores novos em Flutter precisam aprender:
  - Clean Architecture
  - BLoC pattern
  - Either (dartz) para error handling
- **Mitigação:** Documentação interna + pair programming

⚠️ **Over-engineering para telas simples**
- Telas muito simples têm muitos arquivos
- **Mitigação:** Para telas triviais, podemos usar StatefulWidget direto

---

## Implementação

### **Estrutura de Feature:**

```dart
lib/features/refueling/
├── data/
│   ├── datasources/
│   │   ├── refueling_remote_datasource.dart  // API calls
│   │   └── refueling_local_datasource.dart   // Cache local
│   ├── models/
│   │   └── refueling_model.dart              // DTO (JSON ↔ Dart)
│   └── repositories/
│       └── refueling_repository_impl.dart     // Implementação
│
├── domain/
│   ├── entities/
│   │   └── refueling_entity.dart              // Business object
│   ├── repositories/
│   │   └── refueling_repository.dart          // Interface
│   └── usecases/
│       ├── validate_refueling.dart            // Caso de uso
│       └── get_refueling_by_code.dart
│
└── presentation/
    ├── bloc/
    │   ├── refueling_bloc.dart                // Lógica
    │   ├── refueling_event.dart               // Events
    │   └── refueling_state.dart               // States
    ├── pages/
    │   └── refueling_validation_page.dart     // Tela
    └── widgets/
        └── refueling_card.dart                // Widgets
```

### **Exemplo de Fluxo:**

```dart
// 1. USER clica em "Validar" no widget
onPressed: () {
  context.read<RefuelingBloc>().add(
    ValidateRefueling(refuelingId: '123'),
  );
}

// 2. BLoC recebe event
on<ValidateRefueling>((event, emit) async {
  emit(RefuelingLoading());
  
  // 3. BLoC chama UseCase
  final result = await validateRefuelingUseCase.execute(
    refuelingId: event.refuelingId,
  );
  
  // 4. UseCase chama Repository
  // 5. Repository chama DataSource
  // 6. DataSource faz request HTTP (Dio)
  
  // 7. Result volta (Either<Failure, Success>)
  result.fold(
    (failure) => emit(RefuelingError(failure.message)),
    (success) => emit(RefuelingValidated()),
  );
});

// 8. Widget reage ao novo state
BlocBuilder<RefuelingBloc, RefuelingState>(
  builder: (context, state) {
    if (state is RefuelingLoading) return LoadingWidget();
    if (state is RefuelingError) return ErrorWidget(state.message);
    if (state is RefuelingValidated) return SuccessWidget();
    return Container();
  },
)
```

---

## Alternativas Futuras

Se surgir necessidade de mudança:

1. **Adicionar Riverpod em paralelo** para features específicas (ex: cache global)
2. **Migrar BLoCs críticos para Cubit** (simplificação quando não precisa de events complexos)
3. **Adicionar Redux** para state global complexo (improvável)

---

## Métricas de Sucesso

Após 6 meses de uso:

✅ **Testabilidade:** Cobertura de testes 75%+ em domain layer  
✅ **Escalabilidade:** 10+ features sem degradação de estrutura  
✅ **Onboarding:** Novos devs produtivos em 1 semana  
✅ **Bugs:** Menos bugs relacionados a state management  
✅ **Performance:** Nenhum problema de performance relacionado a BLoC  

---

## Referências

- [Flutter BLoC Official Documentation](https://bloclibrary.dev)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Reso Coder - Flutter Clean Architecture Tutorial](https://resocoder.com/flutter-clean-architecture-tdd/)

---

**Data da Decisão:** Início do projeto (2024)  
**Revisado em:** 27/11/2025  
**Próxima revisão:** Quando houver mudanças significativas no Flutter ou BLoC  
**Status:** ✅ Validado - Funcionando muito bem

