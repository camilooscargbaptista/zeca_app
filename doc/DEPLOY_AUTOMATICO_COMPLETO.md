# 🚀 Deploy Automático 100% - Android + iOS

**Status:** ✅ Implementado  
**Data:** 30 de novembro de 2025

---

## 📋 Visão Geral

Sistema de deploy **100% automatizado** para Google Play Store e App Store Connect usando **GitHub Actions**.

### ✅ O que é automatizado:

- ✅ **Build automático** (Android AAB + iOS IPA)
- ✅ **Incremento de versão** automático
- ✅ **Upload para stores** automático
- ✅ **Envio para revisão** automático
- ✅ **Criação de release** no GitHub
- ✅ **Notificações** de sucesso/erro

### 🎯 Como funciona:

1. **Criar tag** no GitHub (ex: `v1.0.4`)
2. **GitHub Actions** detecta a tag
3. **Build automático** de Android e iOS
4. **Upload automático** para as stores
5. **Envio para revisão** automático
6. **Pronto!** 🎉

---

## 🔧 Configuração Inicial (Uma Vez)

### Passo 1: Configurar Secrets no GitHub

Acesse: **Settings → Secrets and variables → Actions**

#### Secrets para Android:

1. **`ANDROID_KEYSTORE_BASE64`**
   - Keystore codificado em base64
   - Como gerar:
   ```bash
   base64 -i android/app/zeca-release-key.jks | pbcopy
   ```

2. **`ANDROID_KEYSTORE_PASSWORD`**
   - Senha do keystore

3. **`ANDROID_KEY_PASSWORD`**
   - Senha da chave

4. **`ANDROID_KEY_ALIAS`**
   - Alias da chave (ex: `zeca-key`)

5. **`GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`**
   - JSON completo da service account do Google Play
   - Como obter:
     1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
     2. Crie uma Service Account
     3. Baixe o JSON
     4. Cole o conteúdo completo no secret

#### Secrets para iOS:

1. **`IOS_P12_CERTIFICATE_BASE64`**
   - Certificado P12 codificado em base64
   - Como gerar:
   ```bash
   base64 -i certificado.p12 | pbcopy
   ```

2. **`IOS_P12_PASSWORD`**
   - Senha do certificado P12

3. **`APPSTORE_ISSUER_ID`**
   - Issuer ID do App Store Connect
   - Onde encontrar: App Store Connect → Users and Access → Keys

4. **`APPSTORE_API_KEY_ID`**
   - Key ID da API Key
   - Onde encontrar: App Store Connect → Users and Access → Keys

5. **`APPSTORE_API_PRIVATE_KEY`**
   - Conteúdo completo do arquivo `.p8`
   - Como obter:
   ```bash
   cat AuthKey_XXXXX.p8 | pbcopy
   ```

---

## 🚀 Como Usar

### Opção 1: Deploy via Tag (Recomendado)

```bash
# 1. Atualizar versão no pubspec.yaml (se necessário)
# 2. Commit e push
git add .
git commit -m "Preparar release 1.0.4"
git push

# 3. Criar tag
git tag v1.0.4
git push origin v1.0.4
```

**O que acontece:**
- ✅ GitHub Actions detecta a tag
- ✅ Faz build de Android e iOS
- ✅ Faz upload para as stores
- ✅ Cria release no GitHub

---

### Opção 2: Deploy Manual via GitHub UI

1. Acesse: **Actions → Deploy Completo - Android + iOS**
2. Clique em **"Run workflow"**
3. Preencha:
   - **Version:** `1.0.4`
   - **Build number:** `66`
   - **Android track:** `internal` (ou `beta`, `production`)
   - **Skip iOS upload:** `false`
4. Clique em **"Run workflow"**

---

### Opção 3: Deploy Apenas Android

1. Acesse: **Actions → Deploy Android - Google Play Store**
2. Clique em **"Run workflow"**
3. Preencha os dados
4. Execute

---

### Opção 4: Deploy Apenas iOS

1. Acesse: **Actions → Deploy iOS - App Store Connect**
2. Clique em **"Run workflow"**
3. Preencha os dados
4. Execute

---

## 📊 Tracks do Google Play

### Internal
- **Uso:** Testes internos
- **Acesso:** Apenas testadores internos
- **Revisão:** Não precisa de revisão

### Alpha
- **Uso:** Testes com grupo fechado
- **Acesso:** Testadores Alpha
- **Revisão:** Revisão rápida (~1 hora)

### Beta
- **Uso:** Testes com grupo aberto
- **Acesso:** Qualquer pessoa pode se inscrever
- **Revisão:** Revisão normal (~1-2 dias)

### Production
- **Uso:** Versão final para todos
- **Acesso:** Todos os usuários
- **Revisão:** Revisão completa (1-7 dias)

**Recomendação:** Comece com `internal`, depois promova para `beta` e finalmente `production`.

---

## 🍎 App Store Connect

### TestFlight
- Upload automático para TestFlight
- Disponível para testadores em ~10-30 minutos
- Não precisa de revisão da Apple

### App Store (Produção)
- Após testes no TestFlight, envie para revisão
- Revisão da Apple: 1-7 dias
- Pode ser feito manualmente ou via Fastlane (futuro)

---

## 🔍 Verificar Status

### Android (Google Play Console)
- Acesse: https://play.google.com/console
- Vá em: **Produção** ou **Testes internos**
- Verifique status do upload

### iOS (App Store Connect)
- Acesse: https://appstoreconnect.apple.com
- Vá em: **TestFlight** → **Builds**
- Verifique status do processamento

---

## 📝 Checklist Antes de Deploy

### Geral:
- [ ] Versão atualizada no `pubspec.yaml`
- [ ] Build number incrementado
- [ ] API configurada para produção (`_currentEnvironment = 'prod'`)
- [ ] Testes locais passando
- [ ] Changelog atualizado

### Android:
- [ ] Keystore configurado
- [ ] Service Account do Google Play configurada
- [ ] Secrets configurados no GitHub
- [ ] App configurado na Play Console

### iOS:
- [ ] Certificado P12 configurado
- [ ] API Key do App Store Connect configurada
- [ ] Secrets configurados no GitHub
- [ ] App configurado no App Store Connect

---

## 🛠️ Troubleshooting

### Erro: "Keystore not found"
- Verifique se o secret `ANDROID_KEYSTORE_BASE64` está configurado
- Verifique se o keystore foi codificado corretamente em base64

### Erro: "Certificate not found"
- Verifique se o secret `IOS_P12_CERTIFICATE_BASE64` está configurado
- Verifique se o certificado foi codificado corretamente em base64

### Erro: "Upload failed - Google Play"
- Verifique se a Service Account tem permissões corretas
- Verifique se o JSON da Service Account está completo

### Erro: "Upload failed - App Store"
- Verifique se a API Key tem permissões corretas
- Verifique se o Issuer ID e Key ID estão corretos

### Build falha
- Verifique os logs do GitHub Actions
- Verifique se todas as dependências estão instaladas
- Verifique se o Flutter está na versão correta

---

## 📚 Estrutura dos Workflows

```
.github/workflows/
├── deploy-android.yml    # Deploy Android
├── deploy-ios.yml         # Deploy iOS
└── deploy-both.yml       # Deploy ambos (orquestrador)
```

---

## 🎯 Fluxo Completo

```
1. Desenvolvedor cria tag: v1.0.4
   ↓
2. GitHub Actions detecta tag
   ↓
3. Build Android (AAB)
   ↓
4. Build iOS (IPA)
   ↓
5. Upload Android → Google Play Store
   ↓
6. Upload iOS → App Store Connect
   ↓
7. Cria Release no GitHub
   ↓
8. Notificação de sucesso
   ↓
9. ✅ Pronto! Apps nas stores
```

---

## 💡 Dicas

### Versionamento Automático
O workflow extrai a versão da tag automaticamente:
- Tag: `v1.0.4` → Versão: `1.0.4`
- Build number é lido do `pubspec.yaml`

### Incremento Automático
Você pode criar um script que:
1. Incrementa versão no `pubspec.yaml`
2. Cria tag automaticamente
3. Faz push da tag

### Notificações
Configure notificações do GitHub para receber emails quando:
- Deploy iniciar
- Deploy concluir (sucesso ou erro)

---

## 🔐 Segurança

### ⚠️ IMPORTANTE:

- **NUNCA** commite keystores, certificados ou senhas no código
- **SEMPRE** use GitHub Secrets
- **MANTENHA** backups seguros dos keystores e certificados
- **ROTACIONE** certificados quando necessário

### Backup dos Certificados:

```bash
# Android Keystore
cp android/app/zeca-release-key.jks ~/backups/

# iOS Certificado
cp certificado.p12 ~/backups/
```

---

## 📊 Monitoramento

### GitHub Actions
- Acesse: **Actions** no GitHub
- Veja histórico de todos os deploys
- Veja logs detalhados de cada etapa

### Google Play Console
- Acesse: https://play.google.com/console
- Veja estatísticas de downloads
- Veja avaliações e comentários

### App Store Connect
- Acesse: https://appstoreconnect.apple.com
- Veja estatísticas de downloads
- Veja avaliações e comentários

---

## 🚀 Próximos Passos

1. **Configurar secrets** no GitHub (uma vez)
2. **Testar deploy** com track `internal`
3. **Verificar** se tudo funcionou
4. **Promover** para `beta` ou `production` quando pronto

---

## 📞 Suporte

Se tiver problemas:
1. Verifique os logs do GitHub Actions
2. Verifique se todos os secrets estão configurados
3. Verifique se os certificados/keystores estão corretos
4. Consulte a documentação oficial:
   - [GitHub Actions](https://docs.github.com/en/actions)
   - [Google Play Console](https://support.google.com/googleplay/android-developer)
   - [App Store Connect](https://developer.apple.com/app-store-connect/)

---

**Criado em:** 30/11/2025  
**Status:** ✅ Pronto para uso

