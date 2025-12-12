---
description: Checklist obrigatório ANTES de iniciar desenvolvimento no app
---

# 📋 PRE-DEV CHECKLIST - ZECA APP

Execute ANTES de escrever qualquer código.

## 1. Entendimento

- [ ] Li o requisito completo
- [ ] Listei dúvidas
- [ ] Perguntei e recebi respostas
- [ ] Expliquei o que entendi e recebi OK

## 2. Verificação de Código

```bash
# Buscar implementações similares
grep -r "termo" lib/ --include="*.dart"
```

- [ ] Busquei features similares
- [ ] Entendi padrões do projeto
- [ ] Verifiquei services existentes

## 3. Verificação de API

- [ ] Endpoint existe no backend?
- [ ] DTO/response está documentado?
- [ ] Precisa criar algo no backend primeiro?

## 4. Proposta

ANTES de codar:
- [ ] Escrevi proposta resumida
- [ ] Listei arquivos a criar/modificar
- [ ] Usuário aprovou

## 5. Executar

```bash
# Criar branch
git checkout -b feature/nome develop

# Implementar
# ...

# Testar
flutter analyze
flutter test

# Build
./scripts/build_ios.sh  # ou android
```

- [ ] Testei em emulador iOS
- [ ] Testei em emulador Android
- [ ] Commit + Push
