# 🚀 Configurar Secrets no GitHub - Guia Rápido

**Status:** Quase tudo pronto! Falta apenas 2 informações.

---

## ✅ O que já está pronto para configurar

### 🤖 ANDROID (4 de 5 prontos)

#### 1. `ANDROID_KEYSTORE_BASE64`
**Status:** ✅ Pronto  
**Valor:** `/tmp/zeca-keystore-base64.txt`

**Para copiar:**
```bash
cat /tmp/zeca-keystore-base64.txt | pbcopy
```

---

#### 2. `ANDROID_KEYSTORE_PASSWORD`
**Status:** ✅ Pronto  
**Valor:** `Joao@08012011`

---

#### 3. `ANDROID_KEY_PASSWORD`
**Status:** ✅ Pronto  
**Valor:** `Joao@08012011`

---

#### 4. `ANDROID_KEY_ALIAS`
**Status:** ✅ Pronto  
**Valor:** `zeca-key`

---

#### 5. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
**Status:** ⚠️ **PENDENTE - Precisa criar no Google Cloud Console**

**Como criar:**
1. Acesse: https://console.cloud.google.com/
2. Crie Service Account:
   - Nome: `github-actions-play-store`
   - Role: `Editor`
3. Baixe o arquivo JSON
4. Conceda acesso no Google Play Console:
   - https://play.google.com/console
   - Settings → API access → Link service account
5. Cole o JSON completo no secret

---

### 🍎 iOS (4 de 5 prontos)

#### 1. `IOS_P12_CERTIFICATE_BASE64`
**Status:** ✅ Pronto (no clipboard!)  
**Valor:** `/tmp/zeca-p12-base64.txt`

**Para copiar novamente:**
```bash
cat /tmp/zeca-p12-base64.txt | pbcopy
```

---

#### 2. `IOS_P12_PASSWORD`
**Status:** ⚠️ **Você precisa informar a senha que definiu ao exportar o P12**

**Valor:** [A senha que você definiu ao exportar o certificado]

---

#### 3. `APPSTORE_ISSUER_ID`
**Status:** ⚠️ **PENDENTE - Precisa obter no App Store Connect**

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **Users and Access → Keys**
3. O **Issuer ID** aparece no **topo da página**
4. É um UUID (formato: `12345678-1234-1234-1234-123456789012`)
5. Copie e cole no secret

**⚠️ Não confunda:**
- ❌ Developer ID: `6d176eea-5c4e-4448-9eaf-706d9f100e81` (não é este)
- ❌ Team ID: `BRDS8JTBGH` (não é este)
- ✅ **Issuer ID:** UUID que aparece na página de Keys

---

#### 4. `APPSTORE_API_KEY_ID`
**Status:** ✅ Pronto  
**Valor:** `ZX75XKMJ33`

---

#### 5. `APPSTORE_API_PRIVATE_KEY`
**Status:** ✅ Pronto  
**Valor:** `/tmp/zeca-p8-content.txt`

**Para copiar:**
```bash
cat /tmp/zeca-p8-content.txt | pbcopy
```

---

## 📋 Passo a Passo: Configurar no GitHub

### 1. Acessar Secrets

1. Abra seu repositório no GitHub
2. Vá em: **Settings** (no menu superior)
3. No menu lateral esquerdo, clique em: **Secrets and variables**
4. Clique em: **Actions**
5. Você verá a lista de secrets (se já tiver algum)

---

### 2. Adicionar Secrets do Android

#### Secret 1: `ANDROID_KEYSTORE_BASE64`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEYSTORE_BASE64`
3. **Secret:** 
   - Execute: `cat /tmp/zeca-keystore-base64.txt | pbcopy`
   - Cole o conteúdo completo (será uma string longa)
4. Clique em **"Add secret"**

#### Secret 2: `ANDROID_KEYSTORE_PASSWORD`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEYSTORE_PASSWORD`
3. **Secret:** `Joao@08012011`
4. Clique em **"Add secret"**

#### Secret 3: `ANDROID_KEY_PASSWORD`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEY_PASSWORD`
3. **Secret:** `Joao@08012011`
4. Clique em **"Add secret"**

#### Secret 4: `ANDROID_KEY_ALIAS`
1. Clique em **"New repository secret"**
2. **Name:** `ANDROID_KEY_ALIAS`
3. **Secret:** `zeca-key`
4. Clique em **"Add secret"**

#### Secret 5: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
**⚠️ Aguardar criação da Service Account**

---

### 3. Adicionar Secrets do iOS

#### Secret 1: `IOS_P12_CERTIFICATE_BASE64`
1. Clique em **"New repository secret"**
2. **Name:** `IOS_P12_CERTIFICATE_BASE64`
3. **Secret:** 
   - O base64 já está no clipboard!
   - Se não estiver, execute: `cat /tmp/zeca-p12-base64.txt | pbcopy`
   - Cole o conteúdo completo
4. Clique em **"Add secret"**

#### Secret 2: `IOS_P12_PASSWORD`
1. Clique em **"New repository secret"**
2. **Name:** `IOS_P12_PASSWORD`
3. **Secret:** [A senha que você definiu ao exportar o P12]
4. Clique em **"Add secret"**

#### Secret 3: `APPSTORE_ISSUER_ID`
**⚠️ Aguardar obtenção do Issuer ID**

1. Clique em **"New repository secret"**
2. **Name:** `APPSTORE_ISSUER_ID`
3. **Secret:** [Issuer ID obtido do App Store Connect]
4. Clique em **"Add secret"**

#### Secret 4: `APPSTORE_API_KEY_ID`
1. Clique em **"New repository secret"**
2. **Name:** `APPSTORE_API_KEY_ID`
3. **Secret:** `ZX75XKMJ33`
4. Clique em **"Add secret"**

#### Secret 5: `APPSTORE_API_PRIVATE_KEY`
1. Clique em **"New repository secret"**
2. **Name:** `APPSTORE_API_PRIVATE_KEY`
3. **Secret:**
   - Execute: `cat /tmp/zeca-p8-content.txt | pbcopy`
   - Cole o conteúdo completo (incluindo `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`)
4. Clique em **"Add secret"**

---

## ✅ Checklist Final

### Android (5 secrets):
- [x] `ANDROID_KEYSTORE_BASE64` - Pronto
- [x] `ANDROID_KEYSTORE_PASSWORD` - Pronto
- [x] `ANDROID_KEY_PASSWORD` - Pronto
- [x] `ANDROID_KEY_ALIAS` - Pronto
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - **PENDENTE**

### iOS (5 secrets):
- [x] `IOS_P12_CERTIFICATE_BASE64` - Pronto (no clipboard!)
- [ ] `IOS_P12_PASSWORD` - **INFORMAR SENHA**
- [ ] `APPSTORE_ISSUER_ID` - **PENDENTE**
- [x] `APPSTORE_API_KEY_ID` - Pronto
- [x] `APPSTORE_API_PRIVATE_KEY` - Pronto

---

## 🎯 O que fazer agora

### 1. Configurar os 8 secrets que já estão prontos
- 4 do Android (keystore)
- 4 do iOS (P12 base64, API Key ID, Private Key)

### 2. Obter Issuer ID
- Acesse App Store Connect → Users and Access → Keys
- Copie o Issuer ID do topo da página

### 3. Informar senha do P12
- A senha que você definiu ao exportar o certificado

### 4. Criar Service Account do Google Play
- Google Cloud Console → Criar Service Account
- Baixar JSON
- Conceder acesso no Google Play Console

---

## 💡 Dicas

### Para valores longos (base64):
- Use os arquivos em `/tmp/` para copiar
- Comando: `cat /tmp/[arquivo] | pbcopy`

### Verificar secrets configurados:
- GitHub → Settings → Secrets → Actions
- Você verá a lista de todos os secrets

### Testar depois de configurar:
- Acesse: Actions → Deploy Android (ou iOS)
- Clique em "Run workflow"
- Teste com versão de teste primeiro

---

## 📚 Arquivos de Referência

- **Valores gerados:** `doc/VALORES_SECRETS_GERADOS.md`
- **Guia completo:** `doc/GUIA_CONFIGURACAO_PASSO_A_PASSO.md`
- **Configurar secrets:** `doc/CONFIGURAR_SECRETS_GITHUB.md`

---

**Pronto para configurar!** 🚀

Você pode configurar os 8 secrets que já estão prontos agora, e depois adicionar os 2 que faltam (Issuer ID e Service Account JSON).

