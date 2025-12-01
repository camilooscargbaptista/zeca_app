# 🏆 REGRAS DE OURO DO DESENVOLVIMENTO - ZECA App

> **⚠️ ATENÇÃO: Estas são REGRAS DE OURO e DEVEM ser seguidas SEMPRE. Não há exceções.**

---

## 🌿 REGRA DE OURO #1: GIT FLOW OBRIGATÓRIO

### ❌ **NUNCA, JAMAIS, EM HIPÓTESE ALGUMA:**

- ❌ Commitar diretamente na branch `main`
- ❌ Commitar diretamente na branch `develop`
- ❌ Fazer push direto para `main` ou `develop`
- ❌ Trabalhar diretamente em `main` ou `develop`

### ✅ **SEMPRE:**

1. **Para qualquer mudança, criar uma feature branch:**
   ```bash
   git checkout develop
   git pull origin develop
   git flow feature start nome-da-feature
   ```

2. **Trabalhar APENAS na feature branch:**
   ```bash
   # Fazer commits normalmente na feature branch
   git add .
   git commit -m "Descrição clara da mudança"
   ```

3. **Finalizar a feature e fazer merge em develop:**
   ```bash
   git flow feature finish nome-da-feature
   git push origin develop
   ```

4. **Para produção, criar uma release:**
   ```bash
   git flow release start 1.0.0
   # Trabalhar na release se necessário
   git flow release finish 1.0.0
   git push origin main
   git push origin develop
   git push origin --tags
   ```

### 📋 **Estrutura de Branches:**

```
main (produção) ← apenas código estável e testado
  ↑
  | (via release)
  |
develop (desenvolvimento) ← integração de features
  ↑
  | (via feature finish)
  |
feature/nome-da-feature ← trabalho ativo
```

---

## 🔒 REGRA DE OURO #2: PROTEÇÃO DE BRANCHES

### **Branches Protegidas (não aceitam push direto):**

- `main` - **SOMENTE via Pull Request + Code Review + Aprovação**
- `develop` - **SOMENTE via Pull Request ou `git flow feature finish`**

### **Processo de Pull Request:**

1. Criar feature branch
2. Fazer commits e push da feature
3. Criar Pull Request no GitHub:
   - **De:** `feature/nome-da-feature`
   - **Para:** `develop` (ou `main` se for release)
4. Aguardar Code Review e aprovação
5. Merge via GitHub (não fazer merge local)

---

## ✅ REGRA DE OURO #3: QUALIDADE DE CÓDIGO

### **Antes de Commitar:**

- [ ] Código compila sem erros
- [ ] Testes locais passaram
- [ ] Não há warnings críticos
- [ ] Código segue o padrão do projeto
- [ ] Mensagem de commit é clara e descritiva

### **Formato de Commits:**

```
tipo: Descrição curta (máx 50 caracteres)

Descrição detalhada (opcional, se necessário)
- O que foi feito
- Por que foi feito
- Impacto da mudança
```

**Tipos aceitos:**
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação (não afeta código)
- `refactor:` Refatoração
- `test:` Testes
- `chore:` Manutenção (build, dependências, etc.)

**Exemplos:**
```
feat: Adicionar modal de esqueci a senha
fix: Corrigir tela branca no iOS
docs: Atualizar guia de Git Flow
refactor: Melhorar tratamento de erros na inicialização
```

---

## 🚨 REGRA DE OURO #4: NUNCA QUEBRAR O BUILD

### **Antes de Fazer Push:**

1. **Sempre testar localmente:**
   ```bash
   flutter clean
   flutter pub get
   flutter analyze
   flutter test
   flutter run
   ```

2. **Verificar se não quebra outras features:**
   - Fazer merge de `develop` na sua feature antes de finalizar
   - Resolver conflitos se houver

3. **Não commitar código quebrado:**
   - Se algo não funciona, commitar em WIP (Work In Progress)
   - Marcar com `[WIP]` no início da mensagem

---

## 📝 REGRA DE OURO #5: DOCUMENTAÇÃO

### **Sempre Documentar:**

- ✅ Features complexas → criar doc em `doc/`
- ✅ Mudanças de API → atualizar documentação
- ✅ Configurações importantes → documentar
- ✅ Decisões arquiteturais → documentar em `doc/ARQUITETURA.md`

### **Estrutura de Documentação:**

```
doc/
├── INDEX.md (índice geral)
├── GITFLOW_GUIDE.md (guia Git Flow)
├── REGRAS_DE_OURO_DESENVOLVIMENTO.md (este arquivo)
└── [outros docs específicos]
```

---

## 🔄 REGRA DE OURO #6: ATUALIZAÇÃO CONSTANTE

### **Sempre Manter Atualizado:**

1. **Antes de começar trabalho:**
   ```bash
   git checkout develop
   git pull origin develop
   ```

2. **Durante o trabalho:**
   - Fazer rebase/merge de `develop` regularmente
   - Não deixar feature branch muito desatualizada

3. **Antes de finalizar feature:**
   ```bash
   git checkout feature/nome-da-feature
   git merge develop  # ou git rebase develop
   ```

---

## 🎯 REGRA DE OURO #7: COMUNICAÇÃO

### **Sempre Comunicar:**

- ✅ Mudanças quebram compatibilidade → avisar no PR
- ✅ Features grandes → discutir antes de implementar
- ✅ Problemas encontrados → documentar e comunicar
- ✅ Dependências novas → justificar no PR

---

## ⚠️ EXCEÇÕES (RARAS E JUSTIFICADAS)

### **Única Exceção Aceitável:**

**Hotfixes críticos de produção** podem ser feitos diretamente via:
```bash
git flow hotfix start 1.0.1
# Correção urgente
git flow hotfix finish 1.0.1
```

**Mas mesmo assim:**
- Deve ter Pull Request
- Deve ter Code Review
- Deve ser justificado

---

## 📊 CHECKLIST ANTES DE QUALQUER COMMIT

Antes de fazer **QUALQUER** commit, verificar:

- [ ] Estou na branch correta? (feature/xxx, NÃO main ou develop!)
- [ ] Branch está atualizada com develop?
- [ ] Código compila sem erros?
- [ ] Testei localmente?
- [ ] Mensagem de commit segue o padrão?
- [ ] Não estou quebrando nada existente?
- [ ] Documentação atualizada (se necessário)?

---

## 🎓 RECURSOS

- **Guia Completo Git Flow:** `doc/GITFLOW_GUIDE.md`
- **Índice de Documentação:** `doc/INDEX.md`

---

## 🚫 VIOLAÇÕES

**Violar estas regras resulta em:**
- ❌ Rejeição do Pull Request
- ❌ Necessidade de refatoração
- ❌ Possível rollback do código

**Lembre-se:** Estas regras existem para proteger o código e facilitar o trabalho em equipe.

---

## 📅 Última Atualização

**Data:** 2025-01-27  
**Versão:** 1.0  
**Status:** ✅ ATIVO - REGRA DE OURO

---

> **"A disciplina de hoje é a qualidade de amanhã."**

