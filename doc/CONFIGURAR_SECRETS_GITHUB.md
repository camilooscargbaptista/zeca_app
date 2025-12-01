# 🔐 Como Configurar Secrets no GitHub

**Objetivo:** Configurar todos os secrets necessários para deploy automático

---

## 📍 Onde Configurar

1. Acesse seu repositório no GitHub
2. Vá em: **Settings → Secrets and variables → Actions**
3. Clique em **"New repository secret"**

---

## 🤖 Secrets para Android

### 1. `ANDROID_KEYSTORE_BASE64`

**Descrição:** Keystore codificado em base64

**Como gerar:**
```bash
# No Mac/Linux
base64 -i android/app/zeca-release-key.jks | pbcopy

# Ou salvar em arquivo
base64 -i android/app/zeca-release-key.jks > keystore-base64.txt
```

**Importante:** Cole o conteúdo completo (sem quebras de linha extras)

---

### 2. `ANDROID_KEYSTORE_PASSWORD`

**Descrição:** Senha do keystore

**Exemplo:** `MinhaSenh@123`

**Dica:** Use uma senha forte e guarde em local seguro

---

### 3. `ANDROID_KEY_PASSWORD`

**Descrição:** Senha da chave (pode ser a mesma do keystore)

**Exemplo:** `MinhaSenh@123`

---

### 4. `ANDROID_KEY_ALIAS`

**Descrição:** Alias da chave no keystore

**Exemplo:** `zeca-key`

**Como verificar:**
```bash
keytool -list -v -keystore android/app/zeca-release-key.jks
```

---

### 5. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

**Descrição:** JSON completo da Service Account do Google Play

**Como obter:**

1. **Acesse Google Cloud Console:**
   - https://console.cloud.google.com/

2. **Criar Service Account:**
   - Vá em **IAM & Admin → Service Accounts**
   - Clique em **"Create Service Account"**
   - Nome: `github-actions-play-store`
   - Clique em **"Create and Continue"**
   - Role: `Editor` (ou mais específico se preferir)
   - Clique em **"Done"**

3. **Criar e baixar chave:**
   - Clique na Service Account criada
   - Vá em **"Keys" → "Add Key" → "Create new key"**
   - Tipo: **JSON**
   - Clique em **"Create"**
   - O arquivo JSON será baixado

4. **Conceder acesso no Google Play:**
   - Acesse: https://play.google.com/console
   - Vá em **Settings → API access**
   - Clique em **"Link service account"**
   - Selecione a Service Account criada
   - Permissões: **Release to production tracks** (ou conforme necessário)
   - Clique em **"Invite user"**

5. **Copiar JSON:**
   ```bash
   # Abrir o arquivo JSON baixado
   cat service-account-key.json | pbcopy
   ```
   
   Cole o conteúdo completo no secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

## 🍎 Secrets para iOS

### 1. `IOS_P12_CERTIFICATE_BASE64`

**Descrição:** Certificado P12 codificado em base64

**Como gerar:**

1. **Exportar certificado do Keychain:**
   - Abra **Keychain Access**
   - Encontre seu certificado de distribuição
   - Clique com botão direito → **"Export"**
   - Formato: **Personal Information Exchange (.p12)**
   - Salve como `certificado.p12`
   - Defina uma senha

2. **Codificar em base64:**
   ```bash
   base64 -i certificado.p12 | pbcopy
   ```

   Cole o conteúdo no secret

---

### 2. `IOS_P12_PASSWORD`

**Descrição:** Senha do certificado P12

**Exemplo:** `MinhaSenh@123`

---

### 3. `APPSTORE_ISSUER_ID`

**Descrição:** Issuer ID do App Store Connect

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em **Users and Access → Keys**
3. O **Issuer ID** aparece no topo da página
4. Formato: UUID (ex: `12345678-1234-1234-1234-123456789012`)

---

### 4. `APPSTORE_API_KEY_ID`

**Descrição:** Key ID da API Key

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em **Users and Access → Keys**
3. Clique em **"Generate API Key"** (se ainda não tiver)
4. Nome: `GitHub Actions`
5. Acesso: **App Manager** ou **Admin**
6. Clique em **"Generate"**
7. Anote o **Key ID** (ex: `ABC123XYZ`)

---

### 5. `APPSTORE_API_PRIVATE_KEY`

**Descrição:** Conteúdo completo do arquivo `.p8`

**Como obter:**
1. Após criar a API Key, baixe o arquivo `.p8`
2. Nome padrão: `AuthKey_XXXXX.p8`
3. Copiar conteúdo:
   ```bash
   cat AuthKey_XXXXX.p8 | pbcopy
   ```
4. Cole o conteúdo completo no secret (incluindo `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`)

---

## ✅ Checklist de Configuração

### Android:
- [ ] `ANDROID_KEYSTORE_BASE64` configurado
- [ ] `ANDROID_KEYSTORE_PASSWORD` configurado
- [ ] `ANDROID_KEY_PASSWORD` configurado
- [ ] `ANDROID_KEY_ALIAS` configurado
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` configurado
- [ ] Service Account tem acesso no Google Play Console

### iOS:
- [ ] `IOS_P12_CERTIFICATE_BASE64` configurado
- [ ] `IOS_P12_PASSWORD` configurado
- [ ] `APPSTORE_ISSUER_ID` configurado
- [ ] `APPSTORE_API_KEY_ID` configurado
- [ ] `APPSTORE_API_PRIVATE_KEY` configurado
- [ ] API Key tem permissões corretas

---

## 🧪 Testar Configuração

### Testar Android:
1. Acesse: **Actions → Deploy Android**
2. Clique em **"Run workflow"**
3. Preencha:
   - Version: `1.0.0`
   - Build number: `1`
   - Track: `internal`
4. Execute e verifique se funciona

### Testar iOS:
1. Acesse: **Actions → Deploy iOS**
2. Clique em **"Run workflow"**
3. Preencha:
   - Version: `1.0.0`
   - Build number: `1`
   - Skip upload: `false`
4. Execute e verifique se funciona

---

## 🔒 Segurança

### ⚠️ IMPORTANTE:

- **NUNCA** commite secrets no código
- **NUNCA** compartilhe secrets publicamente
- **SEMPRE** use GitHub Secrets
- **MANTENHA** backups seguros dos certificados/keystores
- **ROTACIONE** secrets periodicamente

### Backup Seguro:

```bash
# Criar diretório de backup seguro
mkdir -p ~/backups/zeca-secrets

# Backup Android
cp android/app/zeca-release-key.jks ~/backups/zeca-secrets/
echo "Senha do keystore: [sua senha]" > ~/backups/zeca-secrets/android-credentials.txt

# Backup iOS
cp certificado.p12 ~/backups/zeca-secrets/
cp AuthKey_*.p8 ~/backups/zeca-secrets/
echo "Senha P12: [sua senha]" > ~/backups/zeca-secrets/ios-credentials.txt

# Proteger backup
chmod 600 ~/backups/zeca-secrets/*
```

---

## 📚 Recursos

- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Google Play Service Account](https://developers.google.com/android-publisher/getting_started)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)

---

**Criado em:** 30/11/2025

