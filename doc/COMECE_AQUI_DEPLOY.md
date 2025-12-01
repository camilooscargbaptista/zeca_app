# 🚀 Comece Aqui - Deploy Automático

**Bem-vindo!** Este é o ponto de partida para configurar o deploy automático.

---

## ⚡ Início Rápido (3 passos)

### 1️⃣ Execute o Script de Configuração

```bash
./scripts/setup-deploy.sh
```

Este script interativo vai:
- ✅ Criar o keystore Android (se necessário)
- ✅ Gerar base64 dos certificados
- ✅ Organizar todas as informações
- ✅ Criar arquivos temporários com os valores

---

### 2️⃣ Configure os Secrets no GitHub

1. Acesse: **GitHub → Settings → Secrets → Actions**
2. Adicione os 10 secrets conforme o script indicar
3. Use os arquivos temporários gerados para copiar os valores

**Guia detalhado:** [CONFIGURAR_SECRETS_GITHUB.md](./CONFIGURAR_SECRETS_GITHUB.md)

---

### 3️⃣ Teste o Deploy

1. Acesse: **Actions → Deploy Android** (ou iOS)
2. Clique em **"Run workflow"**
3. Preencha os dados e execute
4. Aguarde 10-30 minutos

---

## 📚 Documentação Completa

### Para Configurar (Leia nesta ordem):

1. **[GUIA_CONFIGURACAO_PASSO_A_PASSO.md](./GUIA_CONFIGURACAO_PASSO_A_PASSO.md)** ⭐
   - Guia passo a passo completo
   - Explica cada secret em detalhes
   - Inclui screenshots e exemplos

2. **[CONFIGURAR_SECRETS_GITHUB.md](./CONFIGURAR_SECRETS_GITHUB.md)**
   - Referência rápida dos secrets
   - Como obter cada credencial

3. **[DEPLOY_AUTOMATICO_COMPLETO.md](./DEPLOY_AUTOMATICO_COMPLETO.md)**
   - Visão geral do sistema
   - Como funciona o CI/CD
   - Troubleshooting

---

## 🎯 O que você precisa ter

### Android:
- [ ] Keystore (será criado pelo script)
- [ ] Service Account do Google Play (criar no Google Cloud)

### iOS:
- [x] Certificado P12 (você já tem!)
- [x] Arquivo .p8 (você já tem!)
- [ ] Issuer ID do App Store Connect
- [ ] API Key ID do App Store Connect

---

## 🆘 Precisa de Ajuda?

1. **Execute o script:** `./scripts/setup-deploy.sh`
2. **Leia o guia:** [GUIA_CONFIGURACAO_PASSO_A_PASSO.md](./GUIA_CONFIGURACAO_PASSO_A_PASSO.md)
3. **Verifique os arquivos temporários** gerados pelo script

---

## ✅ Checklist Rápido

- [ ] Executei `./scripts/setup-deploy.sh`
- [ ] Criei o keystore Android (se necessário)
- [ ] Tenho o JSON da Service Account do Google Play
- [ ] Configurei os 5 secrets do Android no GitHub
- [ ] Configurei os 5 secrets do iOS no GitHub
- [ ] Testei o deploy Android (track `internal`)
- [ ] Testei o deploy iOS (TestFlight)

---

**Pronto para começar?** Execute:

```bash
./scripts/setup-deploy.sh
```

🚀

