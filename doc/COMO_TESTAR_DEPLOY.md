# 🧪 Como Testar o Deploy Automático

**Guia para testar os workflows de deploy**

---

## 🎯 Opções de Teste

### Opção 1: Testar via GitHub Web Interface (Recomendado)

#### Testar Android:

1. Acesse: **GitHub → Actions**
2. No menu lateral, clique em **"🚀 Deploy Android - Google Play Store"**
3. Clique em **"Run workflow"** (botão no canto superior direito)
4. Preencha os dados:
   - **Version:** `1.0.0` (versão de teste)
   - **Build number:** `1`
   - **Track:** `internal` (recomendado para teste)
5. Clique em **"Run workflow"**
6. Acompanhe os logs em tempo real

---

#### Testar iOS:

1. Acesse: **GitHub → Actions**
2. No menu lateral, clique em **"🍎 Deploy iOS - App Store Connect"**
3. Clique em **"Run workflow"**
4. Preencha os dados:
   - **Version:** `1.0.0` (versão de teste)
   - **Build number:** `1`
   - **Skip upload:** `false` (para fazer upload real)
5. Clique em **"Run workflow"**
6. Acompanhe os logs em tempo real

---

### Opção 2: Testar via GitHub CLI

#### Testar Android:

```bash
gh workflow run "🚀 Deploy Android - Google Play Store" \
  -f version=1.0.0 \
  -f build_number=1 \
  -f track=internal
```

#### Testar iOS:

```bash
gh workflow run "🍎 Deploy iOS - App Store Connect" \
  -f version=1.0.0 \
  -f build_number=1 \
  -f skip_upload=false
```

---

### Opção 3: Criar Tag (Deploy Automático)

Se você criar uma tag, o deploy será executado automaticamente:

```bash
# Criar tag
git tag v1.0.0
git push origin v1.0.0

# Ou usar o script
./scripts/create-release.sh 1.0.0
```

---

## 📋 O que Esperar

### Durante o Build:

1. ✅ Setup do Flutter
2. ✅ Instalação de dependências
3. ✅ Build do app (AAB para Android, IPA para iOS)
4. ✅ Assinatura do app
5. ✅ Upload para a store

### Tempo Estimado:

- **Android:** 10-15 minutos
- **iOS:** 15-20 minutos

---

## 🔍 Verificar Resultados

### Android:

1. **No GitHub Actions:**
   - Verifique se o workflow completou com sucesso (✓ verde)
   - Veja os logs para identificar problemas

2. **No Google Play Console:**
   - Acesse: https://play.google.com/console
   - Vá em: **Testes internos** (ou track escolhida)
   - Verifique se o build aparece na lista

---

### iOS:

1. **No GitHub Actions:**
   - Verifique se o workflow completou com sucesso (✓ verde)
   - Veja os logs para identificar problemas

2. **No App Store Connect:**
   - Acesse: https://appstoreconnect.apple.com
   - Vá em: **TestFlight → Builds**
   - Verifique se o build aparece na lista

---

## ⚠️ Troubleshooting

### Erro: "Keystore not found"
- Verifique se o secret `ANDROID_KEYSTORE_BASE64` está configurado
- Verifique se o base64 está correto

### Erro: "Certificate not found"
- Verifique se o secret `IOS_P12_CERTIFICATE_BASE64` está configurado
- Verifique se o certificado não expirou

### Erro: "Google Play upload failed"
- Verifique se a Service Account está vinculada no Google Play Console
- Verifique se a Service Account tem permissões corretas
- Verifique se o JSON está correto

### Erro: "App Store upload failed"
- Verifique se a API Key tem permissões corretas
- Verifique se o Issuer ID está correto
- Verifique se o arquivo .p8 está completo

---

## 🎯 Recomendação para Primeiro Teste

1. **Teste Android primeiro** (é mais rápido)
2. **Use track `internal`** (não afeta produção)
3. **Use versão de teste** (ex: 1.0.0)
4. **Acompanhe os logs** em tempo real
5. **Verifique se o build aparece** na store

---

## ✅ Checklist de Teste

- [ ] Workflow executado com sucesso
- [ ] Build completado sem erros
- [ ] App assinado corretamente
- [ ] Upload para store realizado
- [ ] Build aparece na store (Android: Testes internos, iOS: TestFlight)

---

**Pronto para testar!** 🚀

