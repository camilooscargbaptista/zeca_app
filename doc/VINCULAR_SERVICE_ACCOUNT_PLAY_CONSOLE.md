# 🔗 Onde Vincular Service Account no Google Play Console

**Você já baixou o JSON! Agora precisa:**

1. ✅ **Adicionar o secret no GitHub** (OBRIGATÓRIO)
2. ⚠️ **Vincular no Google Play Console** (pode ser feito depois, mas é necessário)

---

## 📋 PARTE 1: Adicionar Secret no GitHub (FAÇA ISSO AGORA)

### Opção A: Via CLI (Recomendado)

1. Encontre o arquivo JSON baixado (geralmente em `~/Downloads/`)
2. No terminal, execute:

```bash
# Substitua [nome-do-arquivo] pelo nome real do arquivo
cat ~/Downloads/[nome-do-arquivo].json | gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON
```

**Exemplo:**
```bash
cat ~/Downloads/abastecacomzeca-479001-abc123.json | gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON
```

---

### Opção B: Via Web Interface

1. Acesse: **GitHub → Settings → Secrets → Actions**
2. Clique em **"New repository secret"**
3. **Name:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
4. **Secret:** 
   - Abra o arquivo JSON baixado
   - Copie TODO o conteúdo (incluindo `{` e `}`)
   - Cole no campo Secret
5. Clique em **"Add secret"**

---

## 📋 PARTE 2: Vincular no Google Play Console (Pode Fazer Depois)

**⚠️ IMPORTANTE:** A vinculação no Google Play Console é necessária para o deploy funcionar, mas pode ser feita depois de adicionar o secret no GitHub.

---

### Como Encontrar a Página de API Access

A URL direta pode não funcionar. Siga pelo menu:

1. **Acesse:** https://play.google.com/console
2. **No menu lateral esquerdo:**
   - Procure por **"Configurações"** (Settings) - ícone de engrenagem ⚙️
   - Ou **"Users and permissions"** (Usuários e permissões)
3. **Dentro de Configurações:**
   - Procure por **"API access"** ou **"Acesso à API"**
   - Pode estar em uma subseção

---

### Se Não Encontrar "API Access"

**Alternativas:**

1. **Procure por:**
   - "Developer account" (Conta de desenvolvedor)
   - "Account access" (Acesso à conta)
   - "API settings" (Configurações de API)

2. **Ou tente estas URLs (após fazer login):**
   - https://play.google.com/console/u/0/developers/[seu-id]/settings/api-access
   - https://play.google.com/console/settings/api-access

---

### Como Vincular (Quando Encontrar a Página)

1. Na página de **API Access**, procure a seção **"Service accounts"**
2. Clique em **"Link service account"** (Vincular conta de serviço)
3. Uma janela/modal aparecerá
4. **Selecione a Service Account** que você criou:
   - Nome: `github-actions-play-store@[projeto-id].iam.gserviceaccount.com`
5. Clique em **"Invite user"** ou **"Convidar usuário"**

---

### Configurar Permissões

Após vincular, configure as permissões:

1. Clique na Service Account vinculada
2. Configure as permissões:
   - ✅ **View app information and download bulk reports**
   - ✅ **Manage production releases** (se quiser deploy em produção)
   - ✅ **Manage testing track releases** (para tracks como `internal`, `alpha`, `beta`)

**Para deploy automático, você precisa de pelo menos:**
- **"Manage testing track releases"** (para tracks de teste)

---

## ✅ Checklist

- [ ] JSON da Service Account baixado
- [ ] Secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` adicionado no GitHub
- [ ] Service Account vinculada no Google Play Console (pode fazer depois)
- [ ] Permissões configuradas no Google Play Console

---

## 🎯 Ordem Recomendada

1. **AGORA:** Adicione o secret no GitHub (via CLI ou web)
2. **DEPOIS:** Vincule no Google Play Console (quando encontrar a página)
3. **DEPOIS:** Configure as permissões

---

## 💡 Dica

**Se não conseguir encontrar a página de API Access agora:**
- Adicione o secret no GitHub primeiro
- A vinculação no Google Play Console pode ser feita depois
- O deploy só funcionará após vincular, mas você pode testar a configuração primeiro

---

**Próximo passo:** Adicione o secret no GitHub agora! 🚀

