#!/bin/bash

# 🚀 Script de Configuração de Deploy Automático
# Este script ajuda a configurar todos os secrets necessários

set -e

echo "🚀 Configuração de Deploy Automático - ZECA App"
echo "================================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependências
echo "🔍 Verificando dependências..."
if ! command_exists keytool; then
    echo -e "${RED}❌ keytool não encontrado. Instale o JDK.${NC}"
    exit 1
fi

if ! command_exists base64; then
    echo -e "${RED}❌ base64 não encontrado.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependências OK${NC}"
echo ""

# ============================================
# PARTE 1: ANDROID KEYSTORE
# ============================================

echo "🤖 PARTE 1: Configurar Android Keystore"
echo "----------------------------------------"

KEYSTORE_PATH="android/app/zeca-release-key.jks"

if [ -f "$KEYSTORE_PATH" ]; then
    echo -e "${GREEN}✅ Keystore já existe: $KEYSTORE_PATH${NC}"
    read -p "Deseja criar um novo? (s/N): " create_new
    if [[ ! $create_new =~ ^[Ss]$ ]]; then
        echo "Usando keystore existente."
    else
        echo "⚠️  Backup do keystore antigo..."
        mv "$KEYSTORE_PATH" "${KEYSTORE_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
        CREATE_KEYSTORE=true
    fi
else
    CREATE_KEYSTORE=true
fi

if [ "$CREATE_KEYSTORE" = true ]; then
    echo ""
    echo "📝 Criando novo keystore..."
    echo "Por favor, preencha as informações solicitadas:"
    echo ""
    
    read -p "Nome completo: " full_name
    read -p "Organização (ex: ZECA): " org
    read -p "Cidade: " city
    read -p "Estado (ex: SP): " state
    read -p "País (ex: BR): " country
    
    echo ""
    echo "🔐 Defina as senhas:"
    read -sp "Senha do keystore: " keystore_password
    echo ""
    read -sp "Senha da chave (pode ser a mesma): " key_password
    echo ""
    
    if [ -z "$key_password" ]; then
        key_password="$keystore_password"
    fi
    
    read -p "Alias da chave (padrão: zeca-key): " key_alias
    if [ -z "$key_alias" ]; then
        key_alias="zeca-key"
    fi
    
    echo ""
    echo "⏳ Criando keystore... (isso pode levar alguns segundos)"
    
    # Criar diretório se não existir
    mkdir -p android/app
    
    # Criar keystore
    keytool -genkey -v \
        -keystore "$KEYSTORE_PATH" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias "$key_alias" \
        -storepass "$keystore_password" \
        -keypass "$key_password" \
        -dname "CN=$full_name, OU=Mobile, O=$org, L=$city, ST=$state, C=$country" \
        -noprompt
    
    echo -e "${GREEN}✅ Keystore criado com sucesso!${NC}"
    echo ""
    echo "📋 Informações salvas:"
    echo "   - Keystore: $KEYSTORE_PATH"
    echo "   - Alias: $key_alias"
    echo "   - Senha do keystore: [guardada]"
    echo "   - Senha da chave: [guardada]"
    echo ""
    
    # Salvar informações em arquivo temporário (será usado depois)
    KEYSTORE_INFO_FILE="/tmp/zeca-keystore-info.txt"
    echo "KEYSTORE_PASSWORD=$keystore_password" > "$KEYSTORE_INFO_FILE"
    echo "KEY_PASSWORD=$key_password" >> "$KEYSTORE_INFO_FILE"
    echo "KEY_ALIAS=$key_alias" >> "$KEYSTORE_INFO_FILE"
    chmod 600 "$KEYSTORE_INFO_FILE"
    
    echo "💾 Informações salvas temporariamente em: $KEYSTORE_INFO_FILE"
    echo "   (Este arquivo será usado para gerar os secrets)"
else
    # Se já existe, pedir informações
    echo ""
    read -sp "Senha do keystore: " keystore_password
    echo ""
    read -sp "Senha da chave: " key_password
    echo ""
    read -p "Alias da chave: " key_alias
    
    KEYSTORE_INFO_FILE="/tmp/zeca-keystore-info.txt"
    echo "KEYSTORE_PASSWORD=$keystore_password" > "$KEYSTORE_INFO_FILE"
    echo "KEY_PASSWORD=$key_password" >> "$KEYSTORE_INFO_FILE"
    echo "KEY_ALIAS=$key_alias" >> "$KEYSTORE_INFO_FILE"
    chmod 600 "$KEYSTORE_INFO_FILE"
fi

# Gerar base64 do keystore
echo ""
echo "📦 Gerando base64 do keystore..."
KEYSTORE_BASE64=$(base64 -i "$KEYSTORE_PATH")
echo -e "${GREEN}✅ Base64 gerado!${NC}"

# Salvar base64 em arquivo
BASE64_FILE="/tmp/zeca-keystore-base64.txt"
echo "$KEYSTORE_BASE64" > "$BASE64_FILE"
echo "💾 Base64 salvo em: $BASE64_FILE"
echo "   (Use este conteúdo para o secret ANDROID_KEYSTORE_BASE64)"

echo ""
echo -e "${YELLOW}📋 RESUMO - Secrets Android:${NC}"
echo "----------------------------------------"
source "$KEYSTORE_INFO_FILE"
echo "1. ANDROID_KEYSTORE_BASE64:"
echo "   Conteúdo em: $BASE64_FILE"
echo ""
echo "2. ANDROID_KEYSTORE_PASSWORD: $KEYSTORE_PASSWORD"
echo ""
echo "3. ANDROID_KEY_PASSWORD: $KEY_PASSWORD"
echo ""
echo "4. ANDROID_KEY_ALIAS: $KEY_ALIAS"
echo ""
echo "5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON:"
echo "   (Você precisa criar no Google Cloud Console)"
echo ""

# ============================================
# PARTE 2: iOS
# ============================================

echo ""
echo "🍎 PARTE 2: Configurar iOS"
echo "--------------------------"

# Verificar certificado P12
P12_FILE=$(ls ~/Downloads/*.p12 2>/dev/null | head -1)
if [ -n "$P12_FILE" ]; then
    echo -e "${GREEN}✅ Certificado P12 encontrado: $P12_FILE${NC}"
    read -sp "Senha do certificado P12: " p12_password
    echo ""
    
    # Gerar base64
    echo "📦 Gerando base64 do certificado..."
    P12_BASE64=$(base64 -i "$P12_FILE")
    P12_BASE64_FILE="/tmp/zeca-p12-base64.txt"
    echo "$P12_BASE64" > "$P12_BASE64_FILE"
    echo -e "${GREEN}✅ Base64 gerado!${NC}"
    echo "💾 Base64 salvo em: $P12_BASE64_FILE"
else
    echo -e "${YELLOW}⚠️  Certificado P12 não encontrado em Downloads${NC}"
    echo "   Exporte do Keychain Access primeiro"
    p12_password=""
    P12_BASE64_FILE=""
fi

# Verificar arquivo .p8
P8_FILE=$(ls ~/Downloads/AuthKey_*.p8 2>/dev/null | head -1)
if [ -n "$P8_FILE" ]; then
    echo -e "${GREEN}✅ Arquivo .p8 encontrado: $P8_FILE${NC}"
    P8_CONTENT=$(cat "$P8_FILE")
    P8_CONTENT_FILE="/tmp/zeca-p8-content.txt"
    echo "$P8_CONTENT" > "$P8_CONTENT_FILE"
    echo "💾 Conteúdo salvo em: $P8_CONTENT_FILE"
else
    echo -e "${YELLOW}⚠️  Arquivo .p8 não encontrado em Downloads${NC}"
    echo "   Baixe do App Store Connect primeiro"
    P8_CONTENT_FILE=""
fi

# Solicitar informações do App Store Connect
echo ""
echo "📝 Informações do App Store Connect:"
read -p "Issuer ID: " issuer_id
read -p "API Key ID: " api_key_id

echo ""
echo -e "${YELLOW}📋 RESUMO - Secrets iOS:${NC}"
echo "----------------------------------------"
if [ -n "$P12_BASE64_FILE" ]; then
    echo "1. IOS_P12_CERTIFICATE_BASE64:"
    echo "   Conteúdo em: $P12_BASE64_FILE"
    echo ""
    echo "2. IOS_P12_PASSWORD: $p12_password"
    echo ""
else
    echo "1. IOS_P12_CERTIFICATE_BASE64: [NÃO CONFIGURADO]"
    echo ""
    echo "2. IOS_P12_PASSWORD: [NÃO CONFIGURADO]"
    echo ""
fi
echo "3. APPSTORE_ISSUER_ID: $issuer_id"
echo ""
echo "4. APPSTORE_API_KEY_ID: $api_key_id"
echo ""
if [ -n "$P8_CONTENT_FILE" ]; then
    echo "5. APPSTORE_API_PRIVATE_KEY:"
    echo "   Conteúdo em: $P8_CONTENT_FILE"
else
    echo "5. APPSTORE_API_PRIVATE_KEY: [NÃO CONFIGURADO]"
fi
echo ""

# ============================================
# PARTE 3: Google Play Service Account
# ============================================

echo ""
echo "🤖 PARTE 3: Google Play Service Account"
echo "----------------------------------------"
echo ""
echo "Você precisa criar uma Service Account no Google Cloud Console."
echo ""
echo "Passos:"
echo "1. Acesse: https://console.cloud.google.com/"
echo "2. Crie uma Service Account"
echo "3. Baixe o arquivo JSON"
echo "4. Conceda acesso no Google Play Console"
echo ""
read -p "Já tem o arquivo JSON da Service Account? (s/N): " has_json

if [[ $has_json =~ ^[Ss]$ ]]; then
    read -p "Caminho do arquivo JSON: " json_file
    if [ -f "$json_file" ]; then
        JSON_CONTENT=$(cat "$json_file")
        JSON_FILE="/tmp/zeca-google-play-json.txt"
        echo "$JSON_CONTENT" > "$JSON_FILE"
        echo -e "${GREEN}✅ JSON carregado!${NC}"
        echo "💾 Conteúdo salvo em: $JSON_FILE"
        echo ""
        echo "6. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON:"
        echo "   Conteúdo em: $JSON_FILE"
    else
        echo -e "${RED}❌ Arquivo não encontrado${NC}"
    fi
else
    echo ""
    echo "📋 Quando tiver o JSON, você pode:"
    echo "   - Adicionar manualmente no GitHub Secrets"
    echo "   - Ou executar este script novamente"
fi

# ============================================
# RESUMO FINAL
# ============================================

echo ""
echo "================================================"
echo "📋 RESUMO FINAL - Todos os Secrets"
echo "================================================"
echo ""
echo -e "${GREEN}✅ ANDROID:${NC}"
echo "   1. ANDROID_KEYSTORE_BASE64 → $BASE64_FILE"
echo "   2. ANDROID_KEYSTORE_PASSWORD → $KEYSTORE_PASSWORD"
echo "   3. ANDROID_KEY_PASSWORD → $KEY_PASSWORD"
echo "   4. ANDROID_KEY_ALIAS → $KEY_ALIAS"
if [ -n "$JSON_FILE" ]; then
    echo "   5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON → $JSON_FILE"
else
    echo "   5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON → [PENDENTE]"
fi
echo ""
echo -e "${GREEN}✅ iOS:${NC}"
if [ -n "$P12_BASE64_FILE" ]; then
    echo "   1. IOS_P12_CERTIFICATE_BASE64 → $P12_BASE64_FILE"
    echo "   2. IOS_P12_PASSWORD → $p12_password"
else
    echo "   1. IOS_P12_CERTIFICATE_BASE64 → [PENDENTE]"
    echo "   2. IOS_P12_PASSWORD → [PENDENTE]"
fi
echo "   3. APPSTORE_ISSUER_ID → $issuer_id"
echo "   4. APPSTORE_API_KEY_ID → $api_key_id"
if [ -n "$P8_CONTENT_FILE" ]; then
    echo "   5. APPSTORE_API_PRIVATE_KEY → $P8_CONTENT_FILE"
else
    echo "   5. APPSTORE_API_PRIVATE_KEY → [PENDENTE]"
fi
echo ""

# Criar script para copiar para clipboard
echo "💡 Dica: Use os arquivos temporários acima para copiar os valores"
echo ""
echo "Para copiar para clipboard (Mac):"
echo "   cat $BASE64_FILE | pbcopy"
echo ""

# Limpar arquivos temporários?
echo ""
read -p "Deseja manter os arquivos temporários? (S/n): " keep_files
if [[ $keep_files =~ ^[Nn]$ ]]; then
    echo "🧹 Limpando arquivos temporários..."
    rm -f "$KEYSTORE_INFO_FILE" "$BASE64_FILE" "$P12_BASE64_FILE" "$P8_CONTENT_FILE" "$JSON_FILE" 2>/dev/null
    echo "✅ Limpeza concluída"
else
    echo ""
    echo "📁 Arquivos temporários mantidos em:"
    echo "   - $KEYSTORE_INFO_FILE"
    echo "   - $BASE64_FILE"
    [ -n "$P12_BASE64_FILE" ] && echo "   - $P12_BASE64_FILE"
    [ -n "$P8_CONTENT_FILE" ] && echo "   - $P8_CONTENT_FILE"
    [ -n "$JSON_FILE" ] && echo "   - $JSON_FILE"
    echo ""
    echo "⚠️  IMPORTANTE: Estes arquivos contêm informações sensíveis!"
    echo "   Delete-os após configurar os secrets no GitHub."
fi

echo ""
echo "================================================"
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo "================================================"
echo ""
echo "Próximos passos:"
echo "1. Acesse: GitHub → Settings → Secrets → Actions"
echo "2. Adicione cada secret usando os valores acima"
echo "3. Teste o deploy com uma versão de teste"
echo ""
echo "📚 Documentação completa:"
echo "   - doc/GUIA_CONFIGURACAO_PASSO_A_PASSO.md"
echo "   - doc/CONFIGURAR_SECRETS_GITHUB.md"
echo ""

