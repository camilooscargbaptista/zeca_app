# 🚀 Primeiro Teste do Deploy - Passo a Passo

**Antes de testar, os workflows precisam estar no GitHub!**

---

## 📋 Passo 1: Adicionar Workflows ao Git

Execute no terminal:

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# Adicionar workflows
git add .github/workflows/

# Fazer commit
git commit -m "Add deploy workflows for Android and iOS"

# Enviar para GitHub
git push
```

---

## 📋 Passo 2: Aguardar Workflows Aparecerem

Após o push:
1. Aguarde alguns segundos
2. Acesse: **GitHub → Actions**
3. Você deve ver os workflows listados:
   - 🚀 Deploy Android - Google Play Store
   - 🍎 Deploy iOS - App Store Connect
   - 🚀 Deploy Completo - Android + iOS

---

## 📋 Passo 3: Testar Deploy Android

### Via Web Interface (Recomendado):

1. Acesse: **GitHub → Actions**
2. Clique em **"🚀 Deploy Android - Google Play Store"**
3. Clique em **"Run workflow"** (canto superior direito)
4. Preencha:
   - **Version:** `1.0.0`
   - **Build number:** `1`
   - **Track:** `internal`
5. Clique em **"Run workflow"**
6. Acompanhe os logs

---

### Via CLI (Depois do push):

```bash
gh workflow run deploy-android.yml \
  -f version=1.0.0 \
  -f build_number=1 \
  -f track=internal
```

---

## 📋 Passo 4: Acompanhar o Deploy

### No GitHub Actions:

1. Clique no workflow em execução
2. Veja os logs em tempo real
3. Verifique cada step:
   - ✅ Setup Flutter
   - ✅ Build AAB
   - ✅ Assinatura
   - ✅ Upload para Google Play

### Tempo Estimado: 10-15 minutos

---

## 📋 Passo 5: Verificar Resultado

### No Google Play Console:

1. Acesse: https://play.google.com/console
2. Vá em: **Testes internos** (ou track escolhida)
3. Verifique se o build aparece na lista
4. Status deve ser: **"Em processamento"** ou **"Pronto"**

---

## ⚠️ Possíveis Problemas

### Workflow não aparece:
- Verifique se fez push dos workflows
- Aguarde alguns segundos após o push
- Recarregue a página do GitHub

### Erro de autenticação:
- Verifique se todos os secrets estão configurados
- Verifique se a Service Account está vinculada no Google Play Console

### Erro de build:
- Verifique os logs no GitHub Actions
- Verifique se o Flutter está configurado corretamente
- Verifique se as dependências estão corretas

---

## ✅ Checklist

- [ ] Workflows commitados e enviados para GitHub
- [ ] Workflows aparecem em Actions
- [ ] Teste executado com sucesso
- [ ] Build completado
- [ ] Upload realizado
- [ ] Build aparece no Google Play Console

---

## 🎯 Próximos Passos Após Teste Bem-Sucedido

1. **Testar iOS** (se quiser)
2. **Vincular Service Account** no Google Play Console (se ainda não fez)
3. **Fazer deploy de produção** quando estiver pronto

---

**Execute o commit e push primeiro, depois teste!** 🚀

