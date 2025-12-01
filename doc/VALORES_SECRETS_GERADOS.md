# 🔐 Valores dos Secrets - Gerados

**Data:** 30/11/2025  
**Status:** Em configuração

---

## ✅ O que já foi gerado

### Android:
- ✅ Base64 do keystore: `/tmp/zeca-keystore-base64.txt`
- ✅ Senha do keystore: `Joao@08012011`
- ✅ Senha da chave: `Joao@08012011`
- ✅ Alias: `zeca-key`
- ✅ Arquivo .p8 copiado: `/tmp/zeca-p8-content.txt`

### iOS:
- ✅ Arquivo .p8 copiado: `/tmp/zeca-p8-content.txt`
- ⚠️ Certificado P12 não encontrado em Downloads (precisa exportar do Keychain)

### Informações da Conta Apple:
- **Team ID:** `BRDS8JTBGH`
- **Developer ID:** `6d176eea-5c4e-4448-9eaf-706d9f100e81`
- **Função:** Administrador

---

## 📝 Secrets para Configurar no GitHub

### 🤖 ANDROID (5 secrets)

#### 1. `ANDROID_KEYSTORE_BASE64`
**Valor:** Já gerado em `/tmp/zeca-keystore-base64.txt`

**Para copiar:**
```bash
cat /tmp/zeca-keystore-base64.txt | pbcopy
```

---

#### 2. `ANDROID_KEYSTORE_PASSWORD`
**Valor:** `Joao@08012011`

---

#### 3. `ANDROID_KEY_PASSWORD`
**Valor:** `Joao@08012011`

---

#### 4. `ANDROID_KEY_ALIAS`
**Valor:** `zeca-key`

---

#### 5. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
**Status:** ⚠️ **PENDENTE**

**Como criar:**
1. Acesse: https://console.cloud.google.com/
2. Crie Service Account:
   - Nome: `github-actions-play-store`
   - Role: `Editor`
3. Baixe o arquivo JSON
4. Conceda acesso no Google Play Console
5. Cole o JSON completo no secret

---

### 🍎 iOS (5 secrets)

#### 1. `IOS_P12_CERTIFICATE_BASE64`
**Status:** ⚠️ **PENDENTE - Precisa exportar do Keychain**

**Como fazer:**
1. Abra **Keychain Access**
2. Encontre o certificado de distribuição
3. Clique com botão direito → **Export**
4. Formato: **Personal Information Exchange (.p12)**
5. Defina uma senha
6. Depois gere base64:
   ```bash
   base64 -i ~/Downloads/certificado.p12 | pbcopy
   ```

---

#### 2. `IOS_P12_PASSWORD`
**Valor:** [Senha que você definir ao exportar o P12]

---

#### 3. `APPSTORE_ISSUER_ID`
**Status:** ⚠️ **PENDENTE - Precisa obter**

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **Users and Access → Keys**
3. O **Issuer ID** aparece no topo da página
4. **NÃO é o Developer ID!** É um UUID diferente que aparece na seção de Keys

**Nota:** O Developer ID que você tem (`6d176eea-5c4e-4448-9eaf-706d9f100e81`) é diferente do Issuer ID. O Issuer ID aparece especificamente na página de **Keys**.

---

#### 4. `APPSTORE_API_KEY_ID`
**Status:** ⚠️ **PENDENTE - Precisa obter ou criar**

**Como obter:**
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **Users and Access → Keys**
3. Se já tem uma API Key, anote o **Key ID** (ex: `ZX75XKMJ33`)
4. Se não tem, crie uma:
   - Clique em **"Generate API Key"**
   - Nome: `GitHub Actions`
   - Acesso: **App Manager** ou **Admin**
   - Anote o **Key ID**

**Nota:** Vejo que você tem o arquivo `AuthKey_ZX75XKMJ33.p8`, então o **Key ID** provavelmente é: `ZX75XKMJ33`

---

#### 5. `APPSTORE_API_PRIVATE_KEY`
**Valor:** Já copiado em `/tmp/zeca-p8-content.txt`

**Para copiar:**
```bash
cat /tmp/zeca-p8-content.txt | pbcopy
```

**Ou o arquivo original:**
```bash
cat ~/Downloads/AuthKey_ZX75XKMJ33.p8 | pbcopy
```

---

## 🎯 Próximos Passos

### 1. Obter Issuer ID
1. Acesse: https://appstoreconnect.apple.com
2. Vá em: **Users and Access → Keys**
3. O **Issuer ID** aparece no topo (é um UUID, diferente do Developer ID)

### 2. Exportar Certificado P12
1. Abra **Keychain Access**
2. Exporte o certificado de distribuição como .p12
3. Gere o base64

### 3. Criar Service Account do Google Play
1. Acesse Google Cloud Console
2. Crie a Service Account
3. Baixe o JSON

### 4. Configurar no GitHub
1. Acesse: GitHub → Settings → Secrets → Actions
2. Adicione os 10 secrets

---

## 📋 Checklist Final

### Android:
- [x] Base64 do keystore gerado
- [x] Senha do keystore: `Joao@08012011`
- [x] Senha da chave: `Joao@08012011`
- [x] Alias: `zeca-key`
- [ ] Service Account JSON (criar)

### iOS:
- [ ] Certificado P12 exportado e base64 gerado
- [ ] Senha do P12 (definir ao exportar)
- [ ] Issuer ID obtido
- [x] API Key ID: `ZX75XKMJ33` (provavelmente)
- [x] Arquivo .p8 copiado

---

## 💡 Comandos Úteis

### Copiar valores para clipboard:
```bash
# Base64 do keystore
cat /tmp/zeca-keystore-base64.txt | pbcopy

# Conteúdo do .p8
cat /tmp/zeca-p8-content.txt | pbcopy

# Base64 do P12 (depois de exportar)
base64 -i ~/Downloads/certificado.p12 | pbcopy
```

---

**Arquivos temporários em:** `/tmp/zeca-*`  
**⚠️ Delete-os após configurar os secrets no GitHub!**

