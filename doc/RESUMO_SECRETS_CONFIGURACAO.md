# 🔐 Resumo - Secrets para Configurar no GitHub

**Data:** 30/11/2025  
**Keystore criado com sucesso!** ✅

---

## 🤖 ANDROID - Secrets (5 secrets)

### 1. `ANDROID_KEYSTORE_BASE64`

**Como gerar:**
```bash
base64 -i android/app/zeca-release-key.jks | pbcopy
```

Ou salvar em arquivo:
```bash
base64 -i android/app/zeca-release-key.jks > /tmp/keystore-base64.txt
cat /tmp/keystore-base64.txt | pbcopy
```

**Valor:** Cole o conteúdo completo (será uma string longa em base64)

---

### 2. `ANDROID_KEYSTORE_PASSWORD`

**Valor:** `Joao@08012011`

---

### 3. `ANDROID_KEY_PASSWORD`

**Valor:** `Joao@08012011`

---

### 4. `ANDROID_KEY_ALIAS`

**Valor:** `zeca-key`

---

### 5. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

**Status:** ⚠️ **PENDENTE - Precisa criar no Google Cloud Console**

**Como obter:**

1. Acesse: https://console.cloud.google.com/
2. Crie uma Service Account:
   - Nome: `github-actions-play-store`
   - Role: `Editor`
3. Baixe o arquivo JSON
4. Conceda acesso no Google Play Console:
   - https://play.google.com/console
   - Settings → API access → Link service account
5. Cole o conteúdo completo do JSON no secret

---

## 🍎 iOS - Secrets (5 secrets)

### 1. `IOS_P12_CERTIFICATE_BASE64`

**Como gerar:**
```bash
# Encontre o arquivo P12 em Downloads
base64 -i ~/Downloads/[nome-do-arquivo].p12 | pbcopy
```

**Valor:** Cole o conteúdo completo (será uma string longa em base64)

---

### 2. `IOS_P12_PASSWORD`

**Valor:** [Você precisa informar a senha do certificado P12]

---

### 3. `APPSTORE_ISSUER_ID`

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **Users and Access → Keys**
3. O **Issuer ID** aparece no topo da página
4. Formato: UUID (ex: `12345678-1234-1234-1234-123456789012`)

**Valor:** [Cole o Issuer ID aqui]

---

### 4. `APPSTORE_API_KEY_ID`

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **Users and Access → Keys**
3. Se já tem uma API Key, anote o **Key ID**
4. Se não tem, crie uma:
   - Clique em **"Generate API Key"**
   - Nome: `GitHub Actions`
   - Acesso: **App Manager** ou **Admin**
   - Anote o **Key ID** (ex: `ABC123XYZ`)

**Valor:** [Cole o Key ID aqui]

---

### 5. `APPSTORE_API_PRIVATE_KEY`

**Como obter:**
1. Após criar a API Key, baixe o arquivo `.p8`
2. Nome padrão: `AuthKey_XXXXX.p8`
3. Copiar conteúdo:
   ```bash
   cat ~/Downloads/AuthKey_*.p8 | pbcopy
   ```

**Valor:** Cole o conteúdo completo (incluindo `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`)

---

## 📋 Checklist de Configuração

### Android:
- [ ] `ANDROID_KEYSTORE_BASE64` - Gerar base64 e copiar
- [ ] `ANDROID_KEYSTORE_PASSWORD` - `Joao@08012011`
- [ ] `ANDROID_KEY_PASSWORD` - `Joao@08012011`
- [ ] `ANDROID_KEY_ALIAS` - `zeca-key`
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Criar no Google Cloud

### iOS:
- [ ] `IOS_P12_CERTIFICATE_BASE64` - Gerar base64 do P12
- [ ] `IOS_P12_PASSWORD` - [Sua senha do P12]
- [ ] `APPSTORE_ISSUER_ID` - Obter do App Store Connect
- [ ] `APPSTORE_API_KEY_ID` - Obter do App Store Connect
- [ ] `APPSTORE_API_PRIVATE_KEY` - Copiar conteúdo do .p8

---

## 🚀 Como Configurar no GitHub

1. Acesse seu repositório no GitHub
2. Vá em: **Settings → Secrets and variables → Actions**
3. Clique em **"New repository secret"**
4. Para cada secret:
   - **Name:** Nome do secret (ex: `ANDROID_KEYSTORE_PASSWORD`)
   - **Secret:** Valor do secret
   - Clique em **"Add secret"**

---

## 💡 Dicas

### Para valores longos (base64):
```bash
# Gerar e copiar direto para clipboard
base64 -i android/app/zeca-release-key.jks | pbcopy

# Ou salvar em arquivo primeiro
base64 -i android/app/zeca-release-key.jks > /tmp/keystore-base64.txt
cat /tmp/keystore-base64.txt | pbcopy
```

### Para verificar se o keystore está correto:
```bash
keytool -list -v -keystore android/app/zeca-release-key.jks
# Digite a senha quando solicitado
```

---

## ⚠️ Segurança

- **NUNCA** commite o keystore ou certificados no Git
- **NUNCA** compartilhe as senhas publicamente
- **SEMPRE** use GitHub Secrets para valores sensíveis
- **MANTENHA** backups seguros dos arquivos originais

---

**Próximo passo:** Execute o script `./scripts/gerar-secrets-rapido.sh` para gerar todos os valores automaticamente!

