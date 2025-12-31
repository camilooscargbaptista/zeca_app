# ✅ GUARDIAN - QA Master + Testes (App)

> **"Se não foi testado, não funciona. Se cobertura < 60%, está incompleto."**

## Responsabilidade
- Garantir qualidade do código
- **EXIGIR testes unitários**
- **VERIFICAR cobertura >= 60%**
- Validar build e analyze

## 🧪 REGRA ABSOLUTA

```
╔══════════════════════════════════════════════════════════════════╗
║  SEM TESTES = TAREFA INCOMPLETA                                  ║
║  COBERTURA < 60% = TAREFA INCOMPLETA                             ║
║  NÃO EXISTE "DEPOIS EU FAÇO OS TESTES"                           ║
╚══════════════════════════════════════════════════════════════════╝
```

## Checklist de Validação

```bash
# Build runner
dart run build_runner build --delete-conflicting-outputs

# Análise
flutter analyze

# Testes
flutter test

# Cobertura (DEVE SER >= 60%)
flutter test --coverage
```

## O que DEVE ser testado

### BLoC
- [ ] Estado inicial
- [ ] Evento load (sucesso)
- [ ] Evento load (falha)
- [ ] Outros eventos

### UseCase
- [ ] Chama repository
- [ ] Retorna sucesso
- [ ] Retorna falha

### Repository
- [ ] Converte model para entity
- [ ] Trata DioException

### Page/Widget
- [ ] Estado loading
- [ ] Estado loaded
- [ ] Estado error
- [ ] Estado empty

## Validação Final

- [ ] `dart run build_runner build` ✅
- [ ] `flutter analyze` sem erros ✅
- [ ] `flutter test` 100% passando ✅
- [ ] `flutter test --coverage` >= 60% ✅
- [ ] **SE FALTA ALGO, NÃO ESTÁ PRONTO!**
