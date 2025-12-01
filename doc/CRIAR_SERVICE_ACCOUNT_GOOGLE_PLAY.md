# 🤖 Como Criar Service Account do Google Play

**Guia passo a passo completo**

---

## 📋 PARTE 1: Criar Service Account no Google Cloud

### Passo 1: Acessar Google Cloud Console

1. Acesse: **https://console.cloud.google.com/**
2. Faça login com a conta Google que tem acesso ao Google Play Console
3. Selecione ou crie um projeto:
   - No topo, clique no seletor de projetos
   - Se já tem um projeto, selecione
   - Se não tem, clique em **"New Project"** e crie um

---

### Passo 2: Navegar até Service Accounts

1. No menu lateral esquerdo, procure por **"IAM & Admin"**
2. Clique em **"Service Accounts"**
   - Ou acesse diretamente: https://console.cloud.google.com/iam-admin/serviceaccounts

---

### Passo 3: Criar Service Account

1. Clique no botão **"Create Service Account"** (ou **"Criar conta de serviço"**)
2. Preencha os dados:
   - **Service account name:** `github-actions-play-store`
   - **Service account ID:** (será gerado automaticamente)
   - **Description:** `Service account para deploy automático do app ZECA via GitHub Actions`
3. Clique em **"Create and Continue"**

---

### Passo 4: Atribuir Permissões

1. Na seção **"Grant this service account access to project"**:
   - **Role:** Selecione **"Editor"** (ou mais específico se preferir)
   - Ou use: **"Service Account User"** + permissões específicas
2. Clique em **"Continue"**
3. Clique em **"Done"**

---

### Passo 5: Criar e Baixar Chave JSON

1. Na lista de Service Accounts, clique na que você acabou de criar (`github-actions-play-store`)
2. Vá na aba **"Keys"** (ou **"Chaves"**)
3. Clique em **"Add Key"** → **"Create new key"**
4. Tipo: **JSON**
5. Clique em **"Create"**
6. O arquivo JSON será baixado automaticamente
7. **IMPORTANTE:** Guarde este arquivo em local seguro!

**Nome do arquivo:** Geralmente algo como `[projeto-id]-[hash].json`

---

## 📋 PARTE 2: Conceder Acesso no Google Play Console

### Passo 1: Acessar Google Play Console

1. Acesse: **https://play.google.com/console**
2. Faça login com a conta que tem acesso ao app ZECA

---

### Passo 2: Navegar até API Access

1. No menu lateral esquerdo, clique em **"Configurações"** (Settings)
2. No submenu, clique em **"API access"** (ou **"Acesso à API"**)
   - Ou acesse diretamente: https://play.google.com/console/developers/4737597685833984405/api-access

---

### Passo 3: Link Service Account

1. Na página de API Access, você verá uma seção **"Service accounts"**
2. Clique em **"Link service account"** (ou **"Vincular conta de serviço"**)
3. Uma janela/modal aparecerá

---

### Passo 4: Selecionar Service Account

1. Na janela, você verá a lista de Service Accounts disponíveis
2. Procure por: `github-actions-play-store@[projeto-id].iam.gserviceaccount.com`
3. Selecione a Service Account que você criou
4. Clique em **"Invite user"** (ou **"Convidar usuário"**)

---

### Passo 5: Configurar Permissões

Após vincular, você pode configurar as permissões:

1. Clique na Service Account vinculada
2. Configure as permissões necessárias:
   - ✅ **View app information and download bulk reports**
   - ✅ **Manage production releases**
   - ✅ **Manage testing track releases** (internal, alpha, beta)
   - ✅ **Manage testing track releases** (production) - se necessário

**Para deploy automático, você precisa de:**
- Pelo menos: **"Manage testing track releases"** (para tracks como `internal`, `alpha`, `beta`)
- Para produção: **"Manage production releases"**

---

## 📋 PARTE 3: Adicionar Secret no GitHub

### Passo 1: Copiar Conteúdo do JSON

No terminal, execute:

```bash
# Se o arquivo está em Downloads
cat ~/Downloads/[nome-do-arquivo].json | pbcopy

# Ou se você sabe o caminho exato
cat [caminho-completo]/[nome-do-arquivo].json | pbcopy
```

---

### Passo 2: Adicionar no GitHub

**Opção A: Via CLI (recomendado)**

```bash
cat ~/Downloads/[nome-do-arquivo].json | gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON
```

**Opção B: Via Web Interface**

1. Acesse: GitHub → Settings → Secrets → Actions
2. Clique em **"New repository secret"**
3. **Name:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
4. **Secret:** Cole o conteúdo completo do JSON (já está no clipboard se usou `pbcopy`)
5. Clique em **"Add secret"**

---

## ✅ Verificação

### Verificar no Google Play Console:

1. Acesse: https://play.google.com/console/developers/4737597685833984405/api-access
2. Você deve ver a Service Account listada em **"Service accounts"**
3. Verifique se as permissões estão corretas

### Verificar no GitHub:

1. Acesse: GitHub → Settings → Secrets → Actions
2. Você deve ver o secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` na lista

---

## 🎯 Resumo dos Passos

1. ✅ **Google Cloud Console** → Criar Service Account
2. ✅ **Google Cloud Console** → Baixar JSON
3. ✅ **Google Play Console** → Settings → API access → Link service account
4. ✅ **GitHub** → Adicionar secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

## 📍 URLs Diretas

- **Google Cloud Console - Service Accounts:**
  https://console.cloud.google.com/iam-admin/serviceaccounts

- **Google Play Console - API Access:**
  https://play.google.com/console/developers/4737597685833984405/api-access

---

## ⚠️ Importante

- **NUNCA** commite o arquivo JSON no Git
- **NUNCA** compartilhe o JSON publicamente
- **SEMPRE** use GitHub Secrets para armazenar
- **MANTENHA** backup seguro do arquivo JSON original

---

**Pronto para criar!** 🚀

