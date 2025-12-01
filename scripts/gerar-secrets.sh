#!/bin/bash

# 🚀 Script para Gerar Valores dos Secrets
# Execute este script após criar o keystore

set -e

echo "🚀 Gerando valores para GitHub Secrets"
echo "======================================="
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ============================================
# ANDROID KEYSTORE
# ============================================

KEYSTORE_PATH="android/app/zeca-release-key.jks"

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "❌ Keystore não encontrado: $KEYSTORE_PATH"
    echo "   Execute primeiro: cd android && keytool -genkey -v -keystore app/zeca-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias zeca-key"
    exit 1
fi

echo -e "${GREEN}✅ Keystore encontrado${NC}"
echo ""

# Gerar base64
echo "📦 Gerando base64 do keystore..."
base64 -i "$KEYSTORE_PATH" > /tmp/zeca-keystore-base64.txt
echo -e "${GREEN}✅ Base64 gerado!${NC}"
echo "   Arquivo: /tmp/zeca-keystore-base64.txt"
echo ""

# Solicitar informações do keystore
echo "📝 Informações do Keystore:"
read -sp "Senha do keystore: " KEYSTORE_PASSWORD
echo ""
read -sp "Senha da chave (pode ser a mesma): " KEY_PASSWORD
echo ""
if [ -z "$KEY_PASSWORD" ]; then
    KEY_PASSWORD="$KEYSTORE_PASSWORD"
fi
read -p "Alias da chave (padrão: zeca-key): " KEY_ALIAS
if [ -z "$KEY_ALIAS" ]; then
    KEY_ALIAS="zeca-key"
fi

echo ""

# ============================================
# iOS CERTIFICADO P12
# ============================================

P12_FILE=$(ls ~/Downloads/*.p12 2>/dev/null | head -1)

if [ -n "$P12_FILE" ]; then
    echo -e "${GREEN}✅ Certificado P12 encontrado: $P12_FILE${NC}"
    echo "📦 Gerando base64..."
    base64 -i "$P12_FILE" > /tmp/zeca-p12-base64.txt
    echo -e "${GREEN}✅ Base64 do P12 gerado!${NC}"
    echo "   Arquivo: /tmp/zeca-p12-base64.txt"
    echo ""
    read -sp "Senha do certificado P12: " P12_PASSWORD
    echo ""
else
    echo -e "${YELLOW}⚠️  Certificado P12 não encontrado em Downloads${NC}"
    P12_PASSWORD=""
fi

# ============================================
# iOS ARQUIVO .p8
# ============================================

P8_FILE=$(ls ~/Downloads/AuthKey_*.p8 2>/dev/null | head -1)

if [ -n "$P8_FILE" ]; then
    echo -e "${GREEN}✅ Arquivo .p8 encontrado: $P8_FILE${NC}"
    cat "$P8_FILE" > /tmp/zeca-p8-content.txt
    echo -e "${GREEN}✅ Conteúdo do .p8 copiado!${NC}"
    echo "   Arquivo: /tmp/zeca-p8-content.txt"
    echo ""
else
    echo -e "${YELLOW}⚠️  Arquivo .p8 não encontrado em Downloads${NC}"
    echo ""
fi

# ============================================
# APP STORE CONNECT
# ============================================

echo "📝 Informações do App Store Connect:"
read -p "Issuer ID: " ISSUER_ID
read -p "API Key ID: " API_KEY_ID
echo ""

# ============================================
# GOOGLE PLAY SERVICE ACCOUNT
# ============================================

echo "📝 Google Play Service Account:"
read -p "Já tem o arquivo JSON da Service Account? (s/N): " has_json

if [[ $has_json =~ ^[Ss]$ ]]; then
    read -p "Caminho do arquivo JSON: " json_file
    if [ -f "$json_file" ]; then
        cp "$json_file" /tmp/zeca-google-play-json.txt
        echo -e "${GREEN}✅ JSON copiado!${NC}"
        echo "   Arquivo: /tmp/zeca-google-play-json.txt"
    else
        echo "❌ Arquivo não encontrado"
    fi
fi

echo ""

# ============================================
# RESUMO
# ============================================

echo "================================================"
echo "📋 RESUMO - Valores para GitHub Secrets"
echo "================================================"
echo ""
echo -e "${GREEN}🤖 ANDROID:${NC}"
echo ""
echo "1. ANDROID_KEYSTORE_BASE64:"
echo "   📄 Arquivo: /tmp/zeca-keystore-base64.txt"
echo "   💡 Para copiar: cat /tmp/zeca-keystore-base64.txt | pbcopy"
echo ""
echo "2. ANDROID_KEYSTORE_PASSWORD:"
echo "   🔐 $KEYSTORE_PASSWORD"
echo ""
echo "3. ANDROID_KEY_PASSWORD:"
echo "   🔐 $KEY_PASSWORD"
echo ""
echo "4. ANDROID_KEY_ALIAS:"
echo "   🏷️  $KEY_ALIAS"
echo ""

if [ -f "/tmp/zeca-google-play-json.txt" ]; then
    echo "5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON:"
    echo "   📄 Arquivo: /tmp/zeca-google-play-json.txt"
    echo "   💡 Para copiar: cat /tmp/zeca-google-play-json.txt | pbcopy"
else
    echo "5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON:"
    echo "   ⚠️  [PENDENTE - Crie no Google Cloud Console]"
fi

echo ""
echo -e "${GREEN}🍎 iOS:${NC}"
echo ""

if [ -f "/tmp/zeca-p12-base64.txt" ]; then
    echo "1. IOS_P12_CERTIFICATE_BASE64:"
    echo "   📄 Arquivo: /tmp/zeca-p12-base64.txt"
    echo "   💡 Para copiar: cat /tmp/zeca-p12-base64.txt | pbcopy"
    echo ""
    echo "2. IOS_P12_PASSWORD:"
    echo "   🔐 $P12_PASSWORD"
    echo ""
else
    echo "1. IOS_P12_CERTIFICATE_BASE64: [PENDENTE]"
    echo ""
    echo "2. IOS_P12_PASSWORD: [PENDENTE]"
    echo ""
fi

echo "3. APPSTORE_ISSUER_ID:"
echo "   🆔 $ISSUER_ID"
echo ""
echo "4. APPSTORE_API_KEY_ID:"
echo "   🔑 $API_KEY_ID"
echo ""

if [ -f "/tmp/zeca-p8-content.txt" ]; then
    echo "5. APPSTORE_API_PRIVATE_KEY:"
    echo "   📄 Arquivo: /tmp/zeca-p8-content.txt"
    echo "   💡 Para copiar: cat /tmp/zeca-p8-content.txt | pbcopy"
else
    echo "5. APPSTORE_API_PRIVATE_KEY: [PENDENTE]"
fi

echo ""
echo "================================================"
echo ""
echo "📝 Próximos passos:"
echo "1. Acesse: GitHub → Settings → Secrets → Actions"
echo "2. Adicione cada secret usando os valores acima"
echo "3. Use os arquivos em /tmp/ para copiar valores longos"
echo ""
echo "💡 Dica: Para copiar para clipboard (Mac):"
echo "   cat /tmp/zeca-keystore-base64.txt | pbcopy"
echo ""
echo "⚠️  IMPORTANTE: Os arquivos em /tmp/ contêm informações sensíveis!"
echo "   Delete-os após configurar os secrets no GitHub."
echo ""

