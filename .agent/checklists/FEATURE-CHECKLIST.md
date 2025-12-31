# ✅ Feature Checklist - ZECA App

## Antes de Começar
- [ ] Consultei LESSONS-LEARNED.md
- [ ] Consultei CLEAN-ARCHITECTURE.md
- [ ] Consultei TESTING-GUIDE.md
- [ ] Encontrei feature similar (auth é referência)

---

## 🎨 MOCKUP (OBRIGATÓRIO ANTES DE IMPLEMENTAR UI)
- [ ] Criei mockup ASCII ou descrição visual
- [ ] Mostrei para aprovação
- [ ] Recebi "OK" ou "Aprovado"
- [ ] **SÓ ENTÃO comecei a implementar UI**

---

## Domain Layer (primeiro!)
- [ ] Criar `domain/entities/nome_entity.dart`
- [ ] Criar `domain/repositories/nome_repository.dart` (interface)
- [ ] Criar `domain/usecases/get_nome_usecase.dart`
- [ ] Criar outros usecases necessários

---

## Data Layer
- [ ] Criar `data/models/nome_model.dart` com @freezed
- [ ] Criar `data/datasources/nome_remote_datasource.dart` com @RestApi
- [ ] Criar `data/repositories/nome_repository_impl.dart`
- [ ] Implementar toEntity() no model
- [ ] Tratar erros com Either

---

## Presentation Layer
- [ ] Criar `presentation/bloc/nome_event.dart` com @freezed
- [ ] Criar `presentation/bloc/nome_state.dart` com @freezed
- [ ] Criar `presentation/bloc/nome_bloc.dart` com @injectable
- [ ] Criar `presentation/pages/nome_page.dart`
- [ ] Criar widgets específicos se necessário

---

## Integração
- [ ] Adicionar rota no GoRouter
- [ ] Rodar `dart run build_runner build`
- [ ] Verificar DI gerado

---

## 🧪 TESTES (OBRIGATÓRIO - META: 60%)

### UseCase Tests
- [ ] Criar `test/.../usecases/get_nome_usecase_test.dart`
- [ ] Teste chama repository
- [ ] Teste retorna sucesso
- [ ] Teste retorna falha

### Repository Tests
- [ ] Criar `test/.../repositories/nome_repository_impl_test.dart`
- [ ] Teste converte model para entity
- [ ] Teste trata DioException

### BLoC Tests
- [ ] Criar `test/.../bloc/nome_bloc_test.dart`
- [ ] Teste estado inicial
- [ ] Teste loadRequested sucesso
- [ ] Teste loadRequested falha

### Page/Widget Tests
- [ ] Criar `test/.../pages/nome_page_test.dart`
- [ ] Teste estado loading
- [ ] Teste estado loaded
- [ ] Teste estado error

---

## Validação Final (TODOS OBRIGATÓRIOS)

- [ ] `dart run build_runner build` ✅
- [ ] `flutter analyze` sem erros ✅
- [ ] `flutter test` 100% passando ✅
- [ ] `flutter test --coverage` >= 60% ✅
- [ ] Testar fluxo no device/emulador ✅

---

## ⚠️ REGRAS

```
ALTERAÇÃO VISUAL? → MOCKUP PRIMEIRO → APROVAÇÃO → IMPLEMENTAR
SEM TESTES = TAREFA INCOMPLETA
COBERTURA < 60% = TAREFA INCOMPLETA
NÃO PERGUNTE SE DEVE FAZER - FAÇA!
```
