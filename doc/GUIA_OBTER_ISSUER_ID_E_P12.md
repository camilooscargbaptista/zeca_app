# 🍎 Guia: Obter Issuer ID e Exportar Certificado P12

**Passo a passo detalhado para completar a configuração do iOS**

---

## 📋 PARTE 1: Obter Issuer ID

### Passo 1: Acessar App Store Connect

1. Abra seu navegador
2. Acesse: **https://appstoreconnect.apple.com**
3. Faça login com sua conta Apple Developer

---

### Passo 2: Navegar até Keys

1. No menu superior, clique em **"Users and Access"**
2. No menu lateral esquerdo, clique em **"Keys"**
3. Você verá uma página com duas seções:
   - **Active Keys** (chaves ativas)
   - **Inactive Keys** (chaves inativas)

---

### Passo 3: Encontrar o Issuer ID

O **Issuer ID** aparece no **topo da página**, acima da lista de keys.

**Formato:** UUID (ex: `12345678-1234-1234-1234-123456789012`)

**Onde procurar:**
- Geralmente está em uma caixa destacada no topo
- Pode estar escrito como: **"Issuer ID"** ou **"Team ID"** (mas é diferente do Team ID que você viu antes)
- Às vezes aparece como: **"API Key Issuer ID"**

**⚠️ IMPORTANTE:**
- O Issuer ID **NÃO é o mesmo** que o Developer ID (`6d176eea-5c4e-4448-9eaf-706d9f100e81`)
- O Issuer ID **NÃO é o mesmo** que o Team ID (`BRDS8JTBGH`)
- O Issuer ID é um UUID específico que aparece **apenas na página de Keys**

---

### Passo 4: Copiar o Issuer ID

1. Encontre o Issuer ID no topo da página
2. Clique para selecionar
3. Copie (Cmd+C)
4. Anote em local seguro

**Exemplo de onde pode aparecer:**
```
┌─────────────────────────────────────┐
│ API Keys                            │
│                                     │
│ Issuer ID: 12345678-1234-1234-...  │
│ [Copiar]                            │
└─────────────────────────────────────┘
```

---

## 📋 PARTE 2: Exportar Certificado P12

### Passo 1: Abrir Keychain Access

1. No Mac, pressione **Cmd + Espaço**
2. Digite: **"Keychain Access"**
3. Pressione Enter

---

### Passo 2: Encontrar o Certificado

1. No Keychain Access, certifique-se de que está vendo **"login"** no canto superior esquerdo
2. Na barra de busca (canto superior direito), digite: **"Apple Distribution"** ou **"iPhone Distribution"**
3. Procure por um certificado que tenha:
   - Nome: **"Apple Distribution: [Nome da sua organização]"**
   - Tipo: **"certificate"**
   - Status: **Válido** (não expirado)

**Dica:** Se não encontrar, tente buscar pelo nome da sua organização (ex: "GIRARDELLI" ou "ZECA")

---

### Passo 3: Verificar o Certificado

1. Clique no certificado para selecioná-lo
2. Verifique se está **válido** (não expirado)
3. Se estiver expirado, você precisará renovar no Apple Developer Portal

---

### Passo 4: Exportar como P12

1. **Clique com botão direito** no certificado
2. Selecione **"Export [nome do certificado]"**
3. Uma janela de salvamento aparecerá

**Configurações:**
- **Nome do arquivo:** `zeca-distribution-cert.p12` (ou qualquer nome)
- **Onde salvar:** Escolha **Downloads** (para facilitar)
- **Formato:** Deve estar como **"Personal Information Exchange (.p12)"**
- Clique em **"Save"**

---

### Passo 5: Definir Senha

1. Uma janela pedirá uma senha
2. **Defina uma senha forte** (anote em local seguro!)
3. Confirme a senha
4. Clique em **"OK"**

**⚠️ IMPORTANTE:**
- Esta senha será usada no secret `IOS_P12_PASSWORD`
- Guarde esta senha em local seguro
- Você precisará dela toda vez que usar o certificado

---

### Passo 6: Verificar se o Arquivo foi Criado

1. Abra a pasta **Downloads**
2. Procure pelo arquivo `.p12` que você acabou de salvar
3. Verifique se o arquivo existe

---

### Passo 7: Gerar Base64 do P12

Abra o terminal e execute:

```bash
# Substitua [nome-do-arquivo] pelo nome real do arquivo
base64 -i ~/Downloads/zeca-distribution-cert.p12 | pbcopy
```

Ou se preferir salvar em arquivo primeiro:

```bash
base64 -i ~/Downloads/zeca-distribution-cert.p12 > /tmp/zeca-p12-base64.txt
cat /tmp/zeca-p12-base64.txt | pbcopy
```

**✅ Pronto!** O base64 está no clipboard, pronto para colar no GitHub Secret.

---

## 🔍 Troubleshooting

### Problema: Não encontro o Issuer ID na página de Keys

**Soluções:**
1. Certifique-se de que está na página correta: **Users and Access → Keys**
2. Role a página para cima - o Issuer ID pode estar no topo
3. Se ainda não encontrar, tente criar uma nova API Key - o Issuer ID pode aparecer durante o processo
4. Verifique se você tem permissões de Administrador

---

### Problema: Não encontro o certificado no Keychain

**Soluções:**
1. Verifique se está olhando no keychain correto: **"login"** (não "System")
2. Tente buscar por diferentes termos:
   - "Apple Distribution"
   - "iPhone Distribution"
   - Nome da sua organização
   - "ZECA"
   - "GIRARDELLI"
3. Verifique se o certificado não expirou
4. Se não encontrar, você pode precisar baixar do Apple Developer Portal:
   - Acesse: https://developer.apple.com/account/resources/certificates/list
   - Baixe o certificado de distribuição
   - Clique duas vezes para instalar no Keychain

---

### Problema: Erro ao exportar o certificado

**Soluções:**
1. Certifique-se de que selecionou o certificado (não a chave privada)
2. Tente exportar a chave privada também (se necessário):
   - Encontre a chave privada correspondente
   - Exporte ela também
3. Verifique se você tem permissões de administrador no Mac
4. Tente fechar e reabrir o Keychain Access

---

### Problema: Certificado expirado

**Soluções:**
1. Acesse: https://developer.apple.com/account/resources/certificates/list
2. Renove ou crie um novo certificado de distribuição
3. Baixe e instale no Keychain
4. Exporte novamente

---

## 📝 Checklist

### Issuer ID:
- [ ] Acessei App Store Connect
- [ ] Naveguei para Users and Access → Keys
- [ ] Encontrei o Issuer ID no topo da página
- [ ] Copiei o Issuer ID
- [ ] Anotei em local seguro

### Certificado P12:
- [ ] Abri Keychain Access
- [ ] Encontrei o certificado de distribuição
- [ ] Verifiquei que está válido (não expirado)
- [ ] Exportei como .p12
- [ ] Salvei em Downloads
- [ ] Defini uma senha (e anotei!)
- [ ] Gerei o base64
- [ ] Copiei para clipboard

---

## 🎯 Próximos Passos

Depois de obter o Issuer ID e exportar o P12:

1. **Anote os valores:**
   - Issuer ID: `_________________`
   - Senha do P12: `_________________`

2. **Gere o base64 do P12:**
   ```bash
   base64 -i ~/Downloads/[nome-do-arquivo].p12 | pbcopy
   ```

3. **Configure no GitHub:**
   - Acesse: GitHub → Settings → Secrets → Actions
   - Adicione:
     - `APPSTORE_ISSUER_ID` → Cole o Issuer ID
     - `IOS_P12_CERTIFICATE_BASE64` → Cole o base64 (já está no clipboard)
     - `IOS_P12_PASSWORD` → Cole a senha que você definiu

---

**Precisa de mais ajuda?** Me avise se encontrar algum problema! 🚀

