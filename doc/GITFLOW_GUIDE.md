# 🌿 Guia Git Flow - ZECA App

## 📋 **Status Atual**

✅ **Git Flow configurado e ativo**
- **Branch de Produção:** `main`
- **Branch de Desenvolvimento:** `develop`
- **Prefixo de Features:** `feature/`
- **Prefixo de Releases:** `release/`
- **Prefixo de Hotfixes:** `hotfix/`

## 🚨 **Regra de Ouro: NUNCA commitar diretamente na `main`**

A branch `main` deve conter **apenas código estável e testado** que está em produção.

---

## 🔄 **Fluxo de Trabalho**

### **1. Iniciar uma Nova Feature**

```bash
# Sempre partir da branch develop
git checkout develop
git pull origin develop

# Criar e iniciar uma nova feature
git flow feature start nome-da-feature

# Exemplo:
git flow feature start fix-tela-branca
```

**O que acontece:**
- Cria uma branch `feature/nome-da-feature` a partir de `develop`
- Muda automaticamente para essa branch

### **2. Trabalhar na Feature**

```bash
# Fazer commits normalmente
git add .
git commit -m "Descrição da mudança"

# Continuar trabalhando...
git add .
git commit -m "Mais mudanças"
```

### **3. Finalizar a Feature**

```bash
# Finalizar a feature (merge automático em develop)
git flow feature finish nome-da-feature

# Ou finalizar e deletar a branch local
git flow feature finish nome-da-feature -d
```

**O que acontece:**
- Faz merge da feature em `develop`
- Deleta a branch da feature
- Volta para `develop`

### **4. Publicar a Feature no Remote**

```bash
# Enviar a branch para o remote
git push origin feature/nome-da-feature

# Após finalizar, atualizar develop no remote
git push origin develop
```

---

## 🚀 **Criar uma Release**

Quando `develop` está estável e pronta para produção:

```bash
# Criar release
git flow release start 1.0.0

# Trabalhar na release (correções finais, versionamento, etc.)
# Fazer commits se necessário

# Finalizar release
git flow release finish 1.0.0
```

**O que acontece:**
- Faz merge em `main` e `develop`
- Cria uma tag `1.0.0`
- Volta para `develop`

**Importante:** Após finalizar, fazer push:
```bash
git push origin main
git push origin develop
git push origin --tags
```

---

## 🔥 **Criar um Hotfix**

Para correções urgentes em produção:

```bash
# Criar hotfix a partir de main
git flow hotfix start 1.0.1

# Fazer correções
git add .
git commit -m "Correção crítica"

# Finalizar hotfix
git flow hotfix finish 1.0.1
```

**O que acontece:**
- Faz merge em `main` e `develop`
- Cria uma tag `1.0.1`
- Volta para `develop`

---

## 📝 **Comandos Úteis**

```bash
# Listar features ativas
git flow feature list

# Listar releases
git flow release list

# Listar hotfixes
git flow hotfix list

# Ver status do Git Flow
git flow version
```

---

## ⚠️ **Problema Identificado: Commits Diretos na Main**

**Commits que foram feitos diretamente na `main` (violando Git Flow):**
- `626f428` - Ocultar opções 'Iniciar Viagem' e 'Checklist'
- `9963c23` - Corrigir registro duplicado do GeocodingService
- `cb02374` - Adicionar logs de debug no router
- `4730e01` - Adicionar logs de debug
- `510748a` - Adicionar tratamento robusto de erros

**Solução Recomendada:**
1. Criar uma feature branch retroativamente
2. Mover esses commits para a feature
3. Fazer merge via Pull Request em `develop`
4. Depois fazer merge de `develop` em `main` via release

---

## ✅ **Checklist Antes de Commitar**

- [ ] Estou na branch correta? (feature/xxx, não main!)
- [ ] A branch está atualizada com develop?
- [ ] Fiz testes locais?
- [ ] O código compila sem erros?
- [ ] Commits têm mensagens descritivas?

---

## 🎯 **Próximos Passos**

1. **Criar feature branch para as correções recentes:**
   ```bash
   git flow feature start fix-tela-branca-e-ui
   ```

2. **Mover commits da main para a feature** (se necessário)

3. **Estabelecer processo de Pull Requests** no GitHub

4. **Proteger a branch `main`** no GitHub (requerer PR e aprovação)

---

**Última atualização:** $(date)

