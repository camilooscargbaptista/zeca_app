# ⚡ Guia Rápido - Configurar Secrets no GitHub

**Você está na página certa!** Clique em **"New repository secret"** para começar.

---

## 🎯 Ordem Recomendada (9 secrets)

Configure nesta ordem para facilitar:

---

## 🍎 iOS Secrets (5)

### 1. `IOS_P12_CERTIFICATE_BASE64`
1. Clique em **"New repository secret"**
2. **Name:** `IOS_P12_CERTIFICATE_BASE64`
3. **Secret:** 
   - No terminal, execute: `cat /tmp/zeca-p12-base64.txt | pbcopy`
   - Cole o conteúdo completo (será uma string longa)
4. Clique em **"Add secret"**

---

### 2. `IOS_P12_PASSWORD`
1. Clique em **"New repository secret"**
2. **Name:** `IOS_P12_PASSWORD`
3. **Secret:** `Joao@08012011`
4. Clique em **"Add secret"**

---

### 3. `APPSTORE_ISSUER_ID`
1. Clique em **"New repository secret"**
2. **Name:** `APPSTORE_ISSUER_ID`
3. **Secret:** `6d176eea-5c4e-4448-9eaf-706d9f100e81`
4. Clique em **"Add secret"**

---

### 4. `APPSTORE_API_KEY_ID`
1. Clique em **"New repository secret"**
2. **Name:** `APPSTORE_API_KEY_ID`
3. **Secret:** `ZX75XKMJ33`
4. Clique em **"Add secret"**

---

### 5. `APPSTORE_API_PRIVATE_KEY`
1. Clique em **"New repository secret"**
2. **Name:** `APPSTORE_API_PRIVATE_KEY`
3. **Secret:**
   - No terminal, execute: `cat /tmp/zeca-p8-content.txt | pbcopy`
   - Cole o conteúdo completo (incluindo `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`)
4. Clique em **"Add secret"**

---

## 🤖 Android Secrets (4)

### 6. `ANDROID_KEYSTORE_BASE64`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEYSTORE_BASE64`
3. **Secret:**
   - No terminal, execute: `cat /tmp/zeca-keystore-base64.txt | pbcopy`
   - Cole o conteúdo completo (será uma string longa)
4. Clique em **"Add secret"**

---

### 7. `ANDROID_KEYSTORE_PASSWORD`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEYSTORE_PASSWORD`
3. **Secret:** `Joao@08012011`
4. Clique em **"Add secret"**

---

### 8. `ANDROID_KEY_PASSWORD`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEY_PASSWORD`
3. **Secret:** `Joao@08012011`
4. Clique em **"Add secret"**

---

### 9. `ANDROID_KEY_ALIAS`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEY_ALIAS`
3. **Secret:** `zeca-key`
4. Clique em **"Add secret"**

---

## ⚠️ Pendente (adicionar depois)

### 10. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
**Status:** Aguardar criação da Service Account no Google Cloud

Depois de criar, adicione:
1. Clique em **"New repository secret"**
2. **Name:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
3. **Secret:** Cole o JSON completo da Service Account
4. Clique em **"Add secret"**

---

## 💡 Dicas

### Para valores longos (base64):
1. Abra o terminal
2. Execute o comando para copiar (ex: `cat /tmp/zeca-p12-base64.txt | pbcopy`)
3. Volte para o GitHub
4. Cole no campo "Secret" (Cmd+V)

### Verificar se configurou corretamente:
- Após adicionar cada secret, ele aparecerá na lista
- Você verá o nome do secret, mas não o valor (por segurança)

### Se precisar editar depois:
- Clique no secret na lista
- Você pode atualizar o valor ou deletar

---

## ✅ Checklist

Após configurar, você deve ter:

**iOS (5):**
- [ ] `IOS_P12_CERTIFICATE_BASE64`
- [ ] `IOS_P12_PASSWORD`
- [ ] `APPSTORE_ISSUER_ID`
- [ ] `APPSTORE_API_KEY_ID`
- [ ] `APPSTORE_API_PRIVATE_KEY`

**Android (4):**
- [ ] `ANDROID_KEYSTORE_BASE64`
- [ ] `ANDROID_KEYSTORE_PASSWORD`
- [ ] `ANDROID_KEY_PASSWORD`
- [ ] `ANDROID_KEY_ALIAS`

**Pendente:**
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` (adicionar depois)

---

## 🚀 Próximo Passo

Depois de configurar os 9 secrets:

1. **Testar o deploy:**
   - Acesse: **Actions** → **Deploy Android** (ou iOS)
   - Clique em **"Run workflow"**
   - Teste com versão de teste primeiro

2. **Criar Service Account:**
   - Google Cloud Console
   - Adicionar o último secret depois

---

**Comece clicando em "New repository secret"!** 🎯

