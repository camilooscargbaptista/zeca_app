# 🔧 Guia Passo a Passo - Configuração de Deploy Automático

**Vamos configurar tudo juntos!** 🚀

---

## 📋 Checklist Geral

- [ ] **Parte 1:** Configurar Android (Keystore + Google Play)
- [ ] **Parte 2:** Configurar iOS (Certificado + App Store)
- [ ] **Parte 3:** Configurar Secrets no GitHub
- [ ] **Parte 4:** Testar primeiro deploy

---

## 🤖 PARTE 1: Configurar Android

### Passo 1.1: Criar Keystore (se ainda não tiver)

```bash
cd android
keytool -genkey -v -keystore app/zeca-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias zeca-key
```

**O que você precisa informar:**
- **Senha do keystore:** (anote esta senha!)
- **Senha da chave:** (pode ser a mesma)
- **Nome completo:** (seu nome)
- **Unidade organizacional:** (opcional)
- **Organização:** (ex: ZECA)
- **Cidade:** (ex: Ribeirão Preto)
- **Estado:** (ex: SP)
- **País:** (ex: BR)

**Anote:**
- ✅ Caminho do keystore: `android/app/zeca-release-key.jks`
- ✅ Senha do keystore: `_________________`
- ✅ Senha da chave: `_________________`
- ✅ Alias: `zeca-key`

---

### Passo 1.2: Codificar Keystore em Base64

```bash
# No Mac
base64 -i android/app/zeca-release-key.jks | pbcopy

# Ou salvar em arquivo para verificar
base64 -i android/app/zeca-release-key.jks > /tmp/keystore-base64.txt
cat /tmp/keystore-base64.txt
```

**Copie o conteúdo completo** (será usado no secret `ANDROID_KEYSTORE_BASE64`)

---

### Passo 1.3: Configurar Google Play Service Account

#### 3.1. Acessar Google Cloud Console

1. Acesse: https://console.cloud.google.com/
2. Faça login com a conta Google que tem acesso ao Google Play Console
3. Selecione ou crie um projeto

#### 3.2. Criar Service Account

1. Vá em **IAM & Admin → Service Accounts**
2. Clique em **"Create Service Account"**
3. Preencha:
   - **Service account name:** `github-actions-play-store`
   - **Service account ID:** (gerado automaticamente)
   - Clique em **"Create and Continue"**
4. **Role:** Selecione **"Editor"** (ou mais específico se preferir)
   - Ou use: **"Service Account User"** + permissões específicas
5. Clique em **"Continue"** e depois **"Done"**

#### 3.3. Criar e Baixar Chave JSON

1. Clique na Service Account criada
2. Vá em **"Keys" → "Add Key" → "Create new key"**
3. Tipo: **JSON**
4. Clique em **"Create"**
5. O arquivo JSON será baixado automaticamente
6. **IMPORTANTE:** Guarde este arquivo em local seguro!

#### 3.4. Conceder Acesso no Google Play Console

1. Acesse: https://play.google.com/console
2. Vá em **Settings → API access**
3. Clique em **"Link service account"**
4. Selecione a Service Account criada (`github-actions-play-store`)
5. Permissões: Selecione conforme necessário:
   - ✅ **View app information and download bulk reports**
   - ✅ **Manage production releases**
   - ✅ **Manage testing track releases**
6. Clique em **"Invite user"**

#### 3.5. Copiar JSON da Service Account

```bash
# Abrir o arquivo JSON baixado
cat ~/Downloads/[nome-do-arquivo].json | pbcopy
```

**Cole o conteúdo completo** (será usado no secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`)

---

## 🍎 PARTE 2: Configurar iOS

### Passo 2.1: Exportar Certificado do Keychain

1. Abra **Keychain Access** (no Mac)
2. Procure por seu certificado de distribuição
   - Procure por: **"Apple Distribution"** ou **"iPhone Distribution"**
   - Ou pelo nome da sua organização
3. Clique com botão direito no certificado
4. Selecione **"Export"**
5. Nome: `certificado.p12`
6. Formato: **Personal Information Exchange (.p12)**
7. Defina uma senha (anote esta senha!)
8. Salve em local seguro

**Anote:**
- ✅ Caminho do certificado: `_________________`
- ✅ Senha do P12: `_________________`

---

### Passo 2.2: Codificar Certificado em Base64

```bash
base64 -i certificado.p12 | pbcopy
```

**Copie o conteúdo completo** (será usado no secret `IOS_P12_CERTIFICATE_BASE64`)

---

### Passo 2.3: Obter Credenciais do App Store Connect

#### 3.1. Acessar App Store Connect

1. Acesse: https://appstoreconnect.apple.com
2. Faça login com sua conta Apple Developer

#### 3.2. Obter Issuer ID

1. Vá em **Users and Access → Keys**
2. O **Issuer ID** aparece no topo da página
3. Formato: UUID (ex: `12345678-1234-1234-1234-123456789012`)
4. **Copie este valor**

**Anote:**
- ✅ Issuer ID: `_________________`

---

#### 3.3. Criar API Key (se ainda não tiver)

1. Ainda em **Users and Access → Keys**
2. Clique em **"Generate API Key"** (ou use uma existente)
3. Preencha:
   - **Name:** `GitHub Actions`
   - **Access:** Selecione **"App Manager"** ou **"Admin"**
4. Clique em **"Generate"**
5. **IMPORTANTE:** Baixe o arquivo `.p8` imediatamente (só pode baixar uma vez!)

**Anote:**
- ✅ Key ID: `_________________` (aparece na lista)
- ✅ Arquivo .p8 baixado: `AuthKey_XXXXX.p8`

---

#### 3.4. Copiar Conteúdo do Arquivo .p8

```bash
# Abrir o arquivo .p8 baixado
cat ~/Downloads/AuthKey_*.p8 | pbcopy
```

**Cole o conteúdo completo** (incluindo `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`)

Será usado no secret `APPSTORE_API_PRIVATE_KEY`

---

## 🔐 PARTE 3: Configurar Secrets no GitHub

### Passo 3.1: Acessar Secrets

1. Acesse seu repositório no GitHub
2. Vá em: **Settings → Secrets and variables → Actions**
3. Clique em **"New repository secret"**

---

### Passo 3.2: Adicionar Secrets do Android

#### Secret 1: `ANDROID_KEYSTORE_BASE64`
- **Name:** `ANDROID_KEYSTORE_BASE64`
- **Secret:** Cole o conteúdo base64 do keystore (do Passo 1.2)
- Clique em **"Add secret"**

#### Secret 2: `ANDROID_KEYSTORE_PASSWORD`
- **Name:** `ANDROID_KEYSTORE_PASSWORD`
- **Secret:** Senha do keystore (do Passo 1.1)
- Clique em **"Add secret"**

#### Secret 3: `ANDROID_KEY_PASSWORD`
- **Name:** `ANDROID_KEY_PASSWORD`
- **Secret:** Senha da chave (do Passo 1.1)
- Clique em **"Add secret"**

#### Secret 4: `ANDROID_KEY_ALIAS`
- **Name:** `ANDROID_KEY_ALIAS`
- **Secret:** `zeca-key` (ou o alias que você usou)
- Clique em **"Add secret"**

#### Secret 5: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- **Name:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- **Secret:** Cole o conteúdo completo do JSON (do Passo 1.3.5)
- **IMPORTANTE:** Cole o JSON completo, incluindo `{` e `}`
- Clique em **"Add secret"**

---

### Passo 3.3: Adicionar Secrets do iOS

#### Secret 6: `IOS_P12_CERTIFICATE_BASE64`
- **Name:** `IOS_P12_CERTIFICATE_BASE64`
- **Secret:** Cole o conteúdo base64 do certificado (do Passo 2.2)
- Clique em **"Add secret"**

#### Secret 7: `IOS_P12_PASSWORD`
- **Name:** `IOS_P12_PASSWORD`
- **Secret:** Senha do certificado P12 (do Passo 2.1)
- Clique em **"Add secret"**

#### Secret 8: `APPSTORE_ISSUER_ID`
- **Name:** `APPSTORE_ISSUER_ID`
- **Secret:** Issuer ID (do Passo 2.3.2)
- Clique em **"Add secret"**

#### Secret 9: `APPSTORE_API_KEY_ID`
- **Name:** `APPSTORE_API_KEY_ID`
- **Secret:** Key ID (do Passo 2.3.3)
- Clique em **"Add secret"**

#### Secret 10: `APPSTORE_API_PRIVATE_KEY`
- **Name:** `APPSTORE_API_PRIVATE_KEY`
- **Secret:** Conteúdo completo do arquivo .p8 (do Passo 2.3.4)
- **IMPORTANTE:** Inclua as linhas `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`
- Clique em **"Add secret"**

---

## ✅ Verificar Secrets Configurados

Você deve ter **10 secrets** configurados:

**Android (5):**
- ✅ ANDROID_KEYSTORE_BASE64
- ✅ ANDROID_KEYSTORE_PASSWORD
- ✅ ANDROID_KEY_PASSWORD
- ✅ ANDROID_KEY_ALIAS
- ✅ GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

**iOS (5):**
- ✅ IOS_P12_CERTIFICATE_BASE64
- ✅ IOS_P12_PASSWORD
- ✅ APPSTORE_ISSUER_ID
- ✅ APPSTORE_API_KEY_ID
- ✅ APPSTORE_API_PRIVATE_KEY

---

## 🧪 PARTE 4: Testar Primeiro Deploy

### Opção A: Testar Apenas Android

1. Acesse: **Actions → Deploy Android - Google Play Store**
2. Clique em **"Run workflow"**
3. Preencha:
   - **Version:** `1.0.0` (ou versão de teste)
   - **Build number:** `1`
   - **Track:** `internal`
4. Clique em **"Run workflow"**
5. Acompanhe os logs em tempo real

**O que deve acontecer:**
- ✅ Build do AAB
- ✅ Upload para Google Play
- ✅ Aparecer na track `internal` em 10-30 minutos

---

### Opção B: Testar Apenas iOS

1. Acesse: **Actions → Deploy iOS - App Store Connect**
2. Clique em **"Run workflow"**
3. Preencha:
   - **Version:** `1.0.0` (ou versão de teste)
   - **Build number:** `1`
   - **Skip upload:** `false`
4. Clique em **"Run workflow"**
5. Acompanhe os logs em tempo real

**O que deve acontecer:**
- ✅ Build do IPA
- ✅ Upload para App Store Connect
- ✅ Aparecer no TestFlight em 10-30 minutos

---

### Opção C: Testar Ambos

1. Acesse: **Actions → Deploy Completo - Android + iOS**
2. Clique em **"Run workflow"**
3. Preencha os dados
4. Execute

---

## 🔍 Verificar se Funcionou

### Android:
1. Acesse: https://play.google.com/console
2. Vá em: **Testes internos** (ou track escolhida)
3. Verifique se o build aparece na lista

### iOS:
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **TestFlight → Builds**
3. Verifique se o build aparece na lista

---

## ❌ Troubleshooting

### Erro: "Keystore not found"
- Verifique se o secret `ANDROID_KEYSTORE_BASE64` está correto
- Tente gerar o base64 novamente

### Erro: "Certificate not found"
- Verifique se o secret `IOS_P12_CERTIFICATE_BASE64` está correto
- Verifique se o certificado não expirou

### Erro: "Google Play upload failed"
- Verifique se a Service Account tem permissões corretas
- Verifique se o JSON está completo (com `{` e `}`)

### Erro: "App Store upload failed"
- Verifique se a API Key tem permissões corretas
- Verifique se o Issuer ID está correto
- Verifique se o arquivo .p8 está completo

---

## 📝 Checklist Final

Antes de fazer deploy em produção:

- [ ] Todos os 10 secrets configurados
- [ ] Teste com Android `internal` funcionou
- [ ] Teste com iOS TestFlight funcionou
- [ ] Keystore e certificados em backup seguro
- [ ] Documentação de senhas em local seguro
- [ ] App configurado nas stores (Google Play + App Store Connect)

---

## 🎉 Pronto!

Agora você pode fazer deploy automático! Basta criar uma tag:

```bash
./scripts/create-release.sh 1.0.4
```

Ou manualmente:
```bash
git tag v1.0.4
git push origin v1.0.4
```

---

**Precisa de ajuda em algum passo específico?** Me avise! 🚀

