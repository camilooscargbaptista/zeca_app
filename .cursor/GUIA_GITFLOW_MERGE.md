# 🔀 Guia: Merge para Main (Gitflow)

**Situação Atual:**
- Branch: `feature/odometer-ocr-mlkit`
- Status: Mudanças não commitadas + `.cursor/` nova pasta
- Objetivo: Levar tudo para `main`

---

## 📋 Plano de Ação

### **Fase 1: Limpar e Organizar** ✅

1. **Adicionar arquivos de build ao .gitignore**
2. **Commitar estrutura .cursor/**
3. **Commitar mudanças importantes**

### **Fase 2: Merge para Main** ✅

4. **Atualizar main local**
5. **Merge da feature branch**
6. **Push para origin/main**

### **Fase 3: Limpeza** ✅

7. **Deletar feature branch (local e remota)**
8. **Verificar que tudo está OK**

---

## 🛠️ Comandos a Executar

### **1. Atualizar .gitignore (ignorar arquivos de build)**

Adicionar ao `.gitignore`:
```
# Gradle (Android)
android/.gradle/
android/build/
android/app/build/
android/local.properties

# iOS
ios/Pods/
ios/Podfile.lock
ios/.symlinks/
ios/Flutter/.last_build_id

# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/

# IDE
.idea/
.vscode/
*.iml
*.ipr
*.iws
```

### **2. Limpar mudanças de build (não commitar)**

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# Restaurar arquivos de build que não devem ir pro git
git restore android/.gradle/
git restore android/local.properties
git restore ios/Podfile.lock
git restore pubspec.lock
git restore android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java

# OU se preferir, adicionar eles ao .gitignore e depois fazer clean
git clean -fd android/.gradle/
```

### **3. Adicionar mudanças importantes**

```bash
# Adicionar estrutura .cursor/ (IMPORTANTE!)
git add .cursor/

# Adicionar scripts e checklists atualizados
git add CHECKLIST_TESTFLIGHT.md
git add SCRIPT_TESTFLIGHT.sh

# Adicionar .gitignore atualizado (se modificou)
git add .gitignore

# Adicionar mudanças em build.gradle se relevantes
# (Revisar antes! Pode ser só versão atualizada)
git add android/app/build.gradle
```

### **4. Commit das mudanças**

```bash
git commit -m "docs: adiciona estrutura .cursor/ com documentação completa do projeto

- Cria estrutura .cursor/ seguindo padrão do zeca_site
- Adiciona README.md principal com guia de uso
- Documenta arquitetura Flutter (Clean Architecture + BLoC)
- Cria 4 ADRs (Architecture Decision Records)
  - ADR-001: Clean Architecture + BLoC
  - ADR-002: GetIt + Injectable
  - ADR-003: flutter_background_geolocation
  - ADR-004: Google ML Kit OCR
- Adiciona padrões de código Flutter/Dart
- Move especificações técnicas para .cursor/docs/specifications/
- Cria templates de user stories (normal + retroativo)
- Adiciona exemplo de user story retroativa (Jornadas GPS)
- Adiciona guia para criação de user stories retroativas
- Atualiza scripts e checklists de TestFlight"
```

### **5. Push da feature branch**

```bash
# Push das mudanças para a feature branch
git push origin feature/odometer-ocr-mlkit
```

### **6. Atualizar main local com remota**

```bash
# Ir para main
git checkout main

# Atualizar main com remota
git pull origin main
```

### **7. Merge da feature branch para main**

```bash
# Estando em main, fazer merge da feature
git merge feature/odometer-ocr-mlkit --no-ff

# --no-ff: Cria commit de merge (boas práticas Gitflow)
```

**Se houver conflitos:**
```bash
# Resolver conflitos manualmente
# Editar arquivos conflitantes
# Depois:
git add .
git commit -m "merge: resolve conflitos entre feature/odometer-ocr-mlkit e main"
```

### **8. Push para origin/main**

```bash
git push origin main
```

### **9. Deletar feature branch (opcional mas recomendado)**

```bash
# Deletar local
git branch -d feature/odometer-ocr-mlkit

# Deletar remota
git push origin --delete feature/odometer-ocr-mlkit
```

### **10. Verificar que está tudo OK**

```bash
# Ver branches
git branch -a

# Ver últimos commits
git log --oneline -10

# Verificar que .cursor/ está lá
ls -la .cursor/
```

---

## 🔄 Gitflow Completo (Para Referência)

```
main (produção)
  ↑
  └── merge ← feature/odometer-ocr-mlkit
                └── commits ← trabalho atual
```

**Futuras features:**
```bash
# 1. Criar branch a partir da main
git checkout main
git pull origin main
git checkout -b feature/nome-nova-feature

# 2. Trabalhar...
git add .
git commit -m "feat: descrição"

# 3. Push
git push origin feature/nome-nova-feature

# 4. Merge para main (quando pronto)
git checkout main
git pull origin main
git merge feature/nome-nova-feature --no-ff
git push origin main

# 5. Deletar feature branch
git branch -d feature/nome-nova-feature
git push origin --delete feature/nome-nova-feature
```

---

## ⚠️ Boas Práticas

### **Antes de Merge para Main:**

- [ ] Código compila sem erros
- [ ] Testes passando
- [ ] Linter OK (sem warnings)
- [ ] .gitignore atualizado (não commitar builds)
- [ ] Commit messages descritivos
- [ ] Feature testada em iOS + Android

### **Commits:**

✅ **BOM:**
```
feat: adiciona estrutura .cursor/ com documentação
fix: corrige crash no mapa
docs: atualiza README com instruções
refactor: melhora estrutura de código OCR
```

❌ **RUIM:**
```
update
fix
changes
wip
```

### **Convenções:**

- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `docs:` - Apenas documentação
- `refactor:` - Refatoração
- `test:` - Testes
- `chore:` - Manutenção/configuração
- `build:` - Build configs

---

## 📊 Checklist de Merge

### **Antes:**
- [ ] Commit das mudanças importantes
- [ ] Ignorar arquivos de build
- [ ] Push da feature branch
- [ ] Main atualizada localmente

### **Durante:**
- [ ] Merge sem conflitos (ou conflitos resolvidos)
- [ ] Commit de merge criado

### **Depois:**
- [ ] Push para origin/main
- [ ] Verificar que .cursor/ está em main
- [ ] Deletar feature branch (opcional)
- [ ] CI/CD passou (se houver)

---

## 🎯 Resumo Executivo

**Comandos essenciais (copiar e colar):**

```bash
# 1. Limpar builds
git restore android/.gradle/ android/local.properties ios/Podfile.lock pubspec.lock

# 2. Adicionar mudanças importantes
git add .cursor/ CHECKLIST_TESTFLIGHT.md SCRIPT_TESTFLIGHT.sh .gitignore

# 3. Commit
git commit -m "docs: adiciona estrutura .cursor/ com documentação completa"

# 4. Push feature
git push origin feature/odometer-ocr-mlkit

# 5. Ir para main
git checkout main
git pull origin main

# 6. Merge
git merge feature/odometer-ocr-mlkit --no-ff

# 7. Push main
git push origin main

# 8. Cleanup (opcional)
git branch -d feature/odometer-ocr-mlkit
git push origin --delete feature/odometer-ocr-mlkit

# 9. Verificar
git log --oneline -5
ls -la .cursor/
```

---

## ✅ Sucesso!

Após executar esses passos:
- ✅ Estrutura `.cursor/` estará na branch `main`
- ✅ Toda documentação disponível para o time
- ✅ Feature branch limpa (deletada)
- ✅ Gitflow seguido corretamente

---

**Criado em:** 27/11/2025  
**Próxima ação:** Executar comandos acima 🚀

