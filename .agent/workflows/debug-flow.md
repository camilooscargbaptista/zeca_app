---
description: Como investigar bugs no app Flutter
---

# 🔍 DEBUG FLOW - ZECA APP

## Regra de Ouro
> **Entender ANTES de alterar**

## 1. Coletar Informações

- [ ] Qual erro? (mensagem, stack trace)
- [ ] Onde? (tela, feature)
- [ ] iOS ou Android? Ou ambos?
- [ ] Reproduzível?

## 2. Investigar

### Logs do App
```bash
# iOS
flutter run -d iPhone
# Ver logs no console

# Android
flutter run -d android
adb logcat | grep flutter
```

### Código
```bash
grep -r "erro" lib/ --include="*.dart"
```

### Network (se API)
- Verificar request/response
- Status code
- Payload correto?

## 3. Diagnóstico

- [ ] Entendi causa raiz?
- [ ] Correção não quebra outra coisa?
- [ ] Confirmei diagnóstico com usuário?

## 4. Corrigir

```bash
git checkout -b bugfix/descricao develop
# Implementar correção mínima
flutter analyze
flutter test
git commit -m "fix: descrição"
```

## ⚠️ NUNCA

- Alterar código "para ver se funciona"
- Mudar múltiplas coisas de uma vez
- Ignorar causa raiz
