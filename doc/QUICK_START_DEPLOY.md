# ⚡ Quick Start - Deploy Automático

**Guia rápido para fazer deploy em 5 minutos**

---

## 🚀 Deploy Rápido (3 passos)

### 1. Configurar Secrets (Uma vez)

Acesse: **GitHub → Settings → Secrets → Actions**

Configure os secrets conforme `CONFIGURAR_SECRETS_GITHUB.md`

---

### 2. Criar Release

```bash
# Opção A: Usar script automático
./scripts/create-release.sh 1.0.4

# Opção B: Manual
git tag v1.0.4
git push origin v1.0.4
```

---

### 3. Aguardar

- ✅ GitHub Actions faz build automaticamente
- ✅ Upload para stores automaticamente
- ✅ Apps disponíveis em 10-30 minutos

---

## 📱 Deploy Manual (via GitHub UI)

1. Acesse: **Actions → Deploy Completo - Android + iOS**
2. Clique: **"Run workflow"**
3. Preencha:
   - Version: `1.0.4`
   - Build number: `66`
   - Android track: `internal`
4. Execute

---

## ✅ Verificar Status

- **GitHub Actions:** https://github.com/[seu-repo]/actions
- **Google Play:** https://play.google.com/console
- **App Store:** https://appstoreconnect.apple.com

---

**Pronto!** 🎉

