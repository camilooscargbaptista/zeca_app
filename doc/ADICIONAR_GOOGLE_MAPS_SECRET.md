# 🔑 Como Adicionar GOOGLE_MAPS_API_KEY no GitHub

## 📋 Duas Formas de Fazer

---

## 🚀 Opção 1: Via GitHub CLI (Automático - Recomendado)

### **Passo 1: Verificar se está autenticado**

```bash
gh auth status
```

Se não estiver autenticado:

```bash
gh auth login
```

### **Passo 2: Adicionar o secret**

```bash
# Substitua SUA_CHAVE_AQUI pela sua chave real do Google Maps
gh secret set GOOGLE_MAPS_API_KEY --body "SUA_CHAVE_AQUI"
```

**Exemplo:**
```bash
gh secret set GOOGLE_MAPS_API_KEY --body "AIzaSyB1234567890abcdefghijklmnopqrstuvwxyz"
```

### **Passo 3: Verificar se foi adicionado**

```bash
gh secret list
```

Você deve ver `GOOGLE_MAPS_API_KEY` na lista.

---

## 🌐 Opção 2: Via Interface Web do GitHub (Manual)

### **Passo 1: Acessar Secrets do Repositório**

1. Abra o repositório no GitHub: `https://github.com/camilooscargbaptista/zeca_app`
2. Clique em **Settings** (Configurações)
3. No menu lateral esquerdo, clique em **Secrets and variables** → **Actions**

### **Passo 2: Adicionar Novo Secret**

1. Clique no botão **New repository secret**
2. **Name:** Digite `GOOGLE_MAPS_API_KEY`
3. **Secret:** Cole sua chave da API do Google Maps
4. Clique em **Add secret**

### **Passo 3: Verificar**

Você deve ver `GOOGLE_MAPS_API_KEY` na lista de secrets.

---

## 🔍 Como Obter a Chave do Google Maps

Se você não tem a chave ainda:

1. Acesse: https://console.cloud.google.com/
2. Selecione o projeto correto
3. Vá em **APIs & Services** → **Credentials**
4. Procure pela chave **Maps Platform API Key**
5. Clique para ver os detalhes
6. Copie a chave

---

## ✅ Verificar se Funcionou

Após adicionar o secret, teste o deploy:

1. Vá em **Actions** no GitHub
2. Execute o workflow `deploy-android` ou `deploy-both`
3. O build deve usar a chave automaticamente

---

## 📝 Nota Importante

- A chave deve ter as seguintes APIs habilitadas:
  - ✅ Maps SDK for Android
  - ✅ Maps SDK for iOS
  - ✅ Directions API
  - ✅ Places API
  - ✅ Geocoding API

---

## 🆘 Problemas?

Se o build ainda falhar com erro de API key:

1. Verifique se o secret foi adicionado corretamente
2. Verifique se a chave está ativa no Google Cloud Console
3. Verifique se as APIs necessárias estão habilitadas
4. Aguarde alguns minutos após adicionar o secret (pode levar tempo para propagar)

