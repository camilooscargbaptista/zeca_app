# ⚡ Resumo Rápido - Configuração Final

**Status atual:** Quase pronto! 🎯

---

## ✅ O que já está pronto

### Android:
- ✅ Base64 do keystore: `/tmp/zeca-keystore-base64.txt`
- ✅ Senha: `Joao@08012011`
- ✅ Alias: `zeca-key`
- ⚠️ Service Account JSON: **PENDENTE**

### iOS:
- ✅ Arquivo .p8: `/tmp/zeca-p8-content.txt`
- ✅ API Key ID: `ZX75XKMJ33` (provavelmente)
- ✅ Certificado encontrado no Keychain: **"Apple Distribution: GIRARDELLI TECNOLOGIA EIRELI"**
- ⚠️ Certificado P12: **PRECISA EXPORTAR**
- ⚠️ Issuer ID: **PRECISA OBTER**

---

## 🚀 Ações Rápidas

### 1️⃣ Exportar Certificado P12 (iOS)

**Opção A: Script automático (recomendado)**
```bash
./scripts/exportar-p12.sh
```

**Opção B: Manual**
1. Abra **Keychain Access**
2. Procure por: **"Apple Distribution: GIRARDELLI TECNOLOGIA EIRELI"**
3. Clique com botão direito → **Export**
4. Salve como: `zeca-distribution-cert.p12` em Downloads
5. Defina uma senha (anote!)
6. Gere base64:
   ```bash
   base64 -i ~/Downloads/zeca-distribution-cert.p12 | pbcopy
   ```

---

### 2️⃣ Obter Issuer ID (iOS)

1. Acesse: **https://appstoreconnect.apple.com**
2. Vá em: **Users and Access → Keys**
3. O **Issuer ID** aparece no **topo da página**
4. Copie o UUID (formato: `12345678-1234-1234-1234-123456789012`)

**⚠️ Não confunda:**
- ❌ Developer ID: `6d176eea-5c4e-4448-9eaf-706d9f100e81` (não é este)
- ❌ Team ID: `BRDS8JTBGH` (não é este)
- ✅ **Issuer ID:** UUID que aparece na página de Keys

---

### 3️⃣ Criar Service Account (Android)

1. Acesse: **https://console.cloud.google.com/**
2. Crie Service Account:
   - Nome: `github-actions-play-store`
   - Role: `Editor`
3. Baixe o arquivo JSON
4. Conceda acesso no Google Play Console:
   - https://play.google.com/console
   - Settings → API access → Link service account
5. Cole o JSON completo no secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

## 📋 Checklist Final

### Android (5 secrets):
- [x] `ANDROID_KEYSTORE_BASE64` - Pronto (`cat /tmp/zeca-keystore-base64.txt | pbcopy`)
- [x] `ANDROID_KEYSTORE_PASSWORD` - `Joao@08012011`
- [x] `ANDROID_KEY_PASSWORD` - `Joao@08012011`
- [x] `ANDROID_KEY_ALIAS` - `zeca-key`
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Criar no Google Cloud

### iOS (5 secrets):
- [ ] `IOS_P12_CERTIFICATE_BASE64` - Exportar P12 primeiro
- [ ] `IOS_P12_PASSWORD` - Definir ao exportar
- [ ] `APPSTORE_ISSUER_ID` - Obter na página de Keys
- [x] `APPSTORE_API_KEY_ID` - `ZX75XKMJ33` (provavelmente)
- [x] `APPSTORE_API_PRIVATE_KEY` - Pronto (`cat /tmp/zeca-p8-content.txt | pbcopy`)

---

## 🎯 Ordem Recomendada

1. **Exportar P12** → `./scripts/exportar-p12.sh`
2. **Obter Issuer ID** → App Store Connect → Keys
3. **Criar Service Account** → Google Cloud Console
4. **Configurar no GitHub** → Settings → Secrets → Actions

---

## 📚 Documentação Completa

- **Guia completo:** `doc/GUIA_OBTER_ISSUER_ID_E_P12.md`
- **Valores gerados:** `doc/VALORES_SECRETS_GERADOS.md`
- **Configuração de secrets:** `doc/CONFIGURAR_SECRETS_GITHUB.md`

---

**Quase lá!** Falta pouco para completar a configuração! 🚀

