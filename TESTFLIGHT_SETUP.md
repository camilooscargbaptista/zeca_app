# 🚀 Configuração de Upload Automático para TestFlight

## 📋 Pré-requisitos

- Conta Apple Developer ativa
- Acesso Admin ao App Store Connect
- App já criado no App Store Connect

---

## 🔑 PASSO 1: Criar API Key no App Store Connect

### 1.1 Acessar App Store Connect

1. Vá para: https://appstoreconnect.apple.com/
2. Faça login com sua conta Apple

### 1.2 Criar API Key

1. No menu superior, clique em **"Users and Access"** (Usuários e Acesso)
2. Clique na aba **"Keys"** (no topo da página)
3. Se for a primeira vez, clique em **"Request Access"** e aguarde aprovação
4. Clique no botão **"+"** ou **"Generate API Key"**
5. Preencha:
   - **Name:** `ZECA App CI/CD` (ou qualquer nome descritivo)
   - **Access:** Selecione **"Admin"** (necessário para upload)
6. Clique em **"Generate"**

### 1.3 Baixar a Chave (IMPORTANTE!)

⚠️ **ATENÇÃO:** Você só pode baixar a chave **UMA ÚNICA VEZ**!

1. Após gerar, clique em **"Download API Key"**
2. Salve o arquivo `.p8` em um local seguro (ex: `~/app_store_credentials/`)
3. **Anote os seguintes dados:**
   - **Key ID:** Aparece na lista de keys (ex: `ABC123XYZ`)
   - **Issuer ID:** Aparece no topo da página Keys (ex: `12345678-1234-1234-1234-123456789012`)

**Exemplo do arquivo baixado:** `AuthKey_ABC123XYZ.p8`

---

## 📁 PASSO 2: Organizar o Arquivo de Chave

### Opção A: Diretório dedicado (Recomendado)

```bash
# Criar diretório para credenciais
mkdir -p ~/app_store_credentials

# Mover o arquivo .p8 para lá
mv ~/Downloads/AuthKey_ABC123XYZ.p8 ~/app_store_credentials/

# Verificar
ls -la ~/app_store_credentials/
```

### Opção B: No projeto (NÃO commitar!)

```bash
# Criar diretório no projeto (já está no .gitignore)
mkdir -p credentials

# Mover o arquivo .p8
mv ~/Downloads/AuthKey_ABC123XYZ.p8 credentials/
```

---

## ⚙️ PASSO 3: Configurar o Projeto

### 3.1 Editar o arquivo `.env.appstore`

   ```bash
# Abrir o arquivo no editor
nano .env.appstore
```

### 3.2 Substituir os valores de exemplo

```bash
# ANTES (valores de exemplo):
APPSTORE_API_KEY_ID=YOUR_KEY_ID_HERE
APPSTORE_API_ISSUER_ID=YOUR_ISSUER_ID_HERE
APPSTORE_API_KEY_PATH=~/app_store_credentials/AuthKey_ABC123XYZ.p8

# DEPOIS (com seus valores reais):
APPSTORE_API_KEY_ID=ABC123XYZ
APPSTORE_API_ISSUER_ID=12345678-1234-1234-1234-123456789012
APPSTORE_API_KEY_PATH=~/app_store_credentials/AuthKey_ABC123XYZ.p8
```

### 3.3 Salvar e verificar

```bash
# Verificar se o arquivo está correto
cat .env.appstore

# Verificar se a chave existe no caminho especificado
ls -la ~/app_store_credentials/AuthKey_*.p8
```

---

## 🚀 PASSO 4: Testar Upload Automático

### 4.1 Build e Upload

```bash
# Build e upload automático
./build_testflight.sh --version 1.0.1
```

### 4.2 O que esperar

Se tudo estiver configurado corretamente, você verá:

```
📤 Upload para App Store Connect...

📁 Carregando credenciais de .env.appstore...
🔑 Credenciais encontradas:
   Key ID: ABC123XYZ
   Issuer ID: 12345678-1234-1234-1234-123456789012
   Key Path: /Users/seu-usuario/app_store_credentials/AuthKey_ABC123XYZ.p8

📤 Fazendo upload do IPA...
   IPA: build/ios/ipa/zeca_app.ipa

[Upload progress...]

✅ Upload concluído com sucesso!

📝 Próximos passos:
   1. Acesse App Store Connect
   2. Aguarde processamento (10-30 minutos)
   3. Configure TestFlight após processamento
```

---

## 🔍 PASSO 5: Verificar no App Store Connect

### 5.1 Acessar TestFlight

1. Vá para: https://appstoreconnect.apple.com/
2. Selecione seu app (ZECA)
3. Clique em **"TestFlight"** no menu lateral

### 5.2 Aguardar Processamento

- O build aparecerá como **"Processing"** (Processando)
- Aguarde 10-30 minutos
- Você receberá um email quando estiver pronto

### 5.3 Configurar Testers

Após o processamento:

1. Clique no build
2. Adicione uma descrição do que mudou
3. Em **"Testers"**, adicione:
   - **Internal Testers:** Sua equipe (até 100 pessoas)
   - **External Testers:** Beta testers externos

---

## 🛠️ Troubleshooting

### Erro: "Authentication credentials are missing or invalid"

**Causa:** Key ID, Issuer ID ou caminho do .p8 incorretos

**Solução:**
```bash
# Verificar valores em .env.appstore
cat .env.appstore

# Verificar se arquivo .p8 existe
ls -la ~/app_store_credentials/AuthKey_*.p8
```

### Erro: "Asset validation failed"

**Causa:** Bundle ID, versão ou configuração do app

**Solução:**
- Verifique se o Bundle ID no Xcode corresponde ao do App Store Connect
- Verifique se a versão é maior que a última enviada
- Verifique se o app está configurado corretamente no App Store Connect

### Erro: "Could not find credentials"

**Causa:** Arquivo .env.appstore não encontrado

**Solução:**
```bash
# Verificar se arquivo existe
ls -la .env.appstore

# Se não existir, criar
cat > .env.appstore << 'EOF'
APPSTORE_API_KEY_ID=SEU_KEY_ID
APPSTORE_API_ISSUER_ID=SEU_ISSUER_ID
APPSTORE_API_KEY_PATH=~/app_store_credentials/AuthKey_XXX.p8
EOF
```

---

## 🔒 Segurança

### ⚠️ NUNCA commitar credenciais no Git!

O arquivo `.env.appstore` e os arquivos `.p8` **NÃO devem ser commitados**.

Verifique se estão no `.gitignore`:

```bash
# Verificar .gitignore
grep -E "\.env\.appstore|\.p8" .gitignore

# Se não estiver, adicionar:
echo ".env.appstore" >> .gitignore
echo "*.p8" >> .gitignore
```

### 🔑 Backup das Credenciais

1. Faça backup do arquivo `.p8` em local seguro (1Password, LastPass, etc.)
2. Guarde o Key ID e Issuer ID
3. Se perder o `.p8`, você terá que:
   - Revogar a key antiga no App Store Connect
   - Gerar uma nova key
   - Atualizar `.env.appstore`

---

## 📝 Comandos Úteis

### Build sem upload (apenas criar IPA)

```bash
./build_testflight.sh --skip-upload --version 1.0.1
```

### Build mantendo a mesma versão

```bash
./build_testflight.sh --no-version-increment
```

### Build com versão e build number específicos

```bash
./build_testflight.sh --version 1.0.2 --build-number 25
```

---

## 🎉 Pronto!

Agora você pode fazer builds e uploads automáticos para TestFlight com um único comando:

```bash
./build_testflight.sh --version 1.0.1
```

O script vai:
1. ✅ Incrementar a versão automaticamente
2. ✅ Limpar builds anteriores
3. ✅ Instalar dependências
4. ✅ Criar o IPA
5. ✅ Fazer upload para App Store Connect
6. ✅ Notificar quando estiver pronto

**Economiza 15-20 minutos por release!** 🚀
