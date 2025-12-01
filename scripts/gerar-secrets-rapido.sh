#!/bin/bash

# 🚀 Script Rápido para Gerar Valores dos Secrets
# Usa a senha informada pelo usuário

set -e

KEYSTORE_PASSWORD="Joao@08012011"
KEY_PASSWORD="Joao@08012011"  # Mesma senha
KEY_ALIAS="zeca-key"
KEYSTORE_PATH="android/app/zeca-release-key.jks"

echo "🚀 Gerando valores para GitHub Secrets"
echo "======================================="
echo ""

# Verificar keystore
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "❌ Keystore não encontrado: $KEYSTORE_PATH"
    exit 1
fi

echo "✅ Keystore encontrado"
echo ""

# Gerar base64 do keystore
echo "📦 Gerando base64 do keystore..."
base64 -i "$KEYSTORE_PATH" > /tmp/zeca-keystore-base64.txt
echo "✅ Base64 gerado: /tmp/zeca-keystore-base64.txt"
echo ""

# Verificar e gerar base64 do P12
P12_FILE=$(ls ~/Downloads/*.p12 2>/dev/null | head -1)
if [ -n "$P12_FILE" ]; then
    echo "✅ Certificado P12 encontrado: $P12_FILE"
    echo "📦 Gerando base64..."
    base64 -i "$P12_FILE" > /tmp/zeca-p12-base64.txt
    echo "✅ Base64 do P12 gerado: /tmp/zeca-p12-base64.txt"
    echo ""
    echo "⚠️  Você precisa informar a senha do certificado P12"
    read -sp "Senha do certificado P12: " P12_PASSWORD
    echo ""
else
    echo "⚠️  Certificado P12 não encontrado em Downloads"
    P12_PASSWORD=""
fi

# Verificar e copiar .p8
P8_FILE=$(ls ~/Downloads/AuthKey_*.p8 2>/dev/null | head -1)
if [ -n "$P8_FILE" ]; then
    echo "✅ Arquivo .p8 encontrado: $P8_FILE"
    cat "$P8_FILE" > /tmp/zeca-p8-content.txt
    echo "✅ Conteúdo do .p8 copiado: /tmp/zeca-p8-content.txt"
    echo ""
else
    echo "⚠️  Arquivo .p8 não encontrado em Downloads"
    echo ""
fi

# Solicitar informações do App Store Connect
echo "📝 Informações do App Store Connect:"
read -p "Issuer ID: " ISSUER_ID
read -p "API Key ID: " API_KEY_ID
echo ""

# Verificar Service Account JSON
echo "📝 Google Play Service Account:"
read -p "Caminho do arquivo JSON da Service Account (ou Enter para pular): " json_file
if [ -n "$json_file" ] && [ -f "$json_file" ]; then
    cp "$json_file" /tmp/zeca-google-play-json.txt
    echo "✅ JSON copiado: /tmp/zeca-google-play-json.txt"
else
    echo "⚠️  JSON não fornecido (você pode adicionar depois)"
fi

echo ""
echo "================================================"
echo "📋 RESUMO - Valores para GitHub Secrets"
echo "================================================"
echo ""
echo "🤖 ANDROID:"
echo ""
echo "1. ANDROID_KEYSTORE_BASE64"
echo "   📄 Arquivo: /tmp/zeca-keystore-base64.txt"
echo "   💡 Para copiar: cat /tmp/zeca-keystore-base64.txt | pbcopy"
echo ""
echo "2. ANDROID_KEYSTORE_PASSWORD"
echo "   🔐 $KEYSTORE_PASSWORD"
echo ""
echo "3. ANDROID_KEY_PASSWORD"
echo "   🔐 $KEY_PASSWORD"
echo ""
echo "4. ANDROID_KEY_ALIAS"
echo "   🏷️  $KEY_ALIAS"
echo ""

if [ -f "/tmp/zeca-google-play-json.txt" ]; then
    echo "5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"
    echo "   📄 Arquivo: /tmp/zeca-google-play-json.txt"
    echo "   💡 Para copiar: cat /tmp/zeca-google-play-json.txt | pbcopy"
else
    echo "5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"
    echo "   ⚠️  [PENDENTE - Crie no Google Cloud Console]"
fi

echo ""
echo "🍎 iOS:"
echo ""

if [ -f "/tmp/zeca-p12-base64.txt" ]; then
    echo "1. IOS_P12_CERTIFICATE_BASE64"
    echo "   📄 Arquivo: /tmp/zeca-p12-base64.txt"
    echo "   💡 Para copiar: cat /tmp/zeca-p12-base64.txt | pbcopy"
    echo ""
    echo "2. IOS_P12_PASSWORD"
    echo "   🔐 $P12_PASSWORD"
    echo ""
else
    echo "1. IOS_P12_CERTIFICATE_BASE64: [PENDENTE]"
    echo ""
    echo "2. IOS_P12_PASSWORD: [PENDENTE]"
    echo ""
fi

echo "3. APPSTORE_ISSUER_ID"
echo "   🆔 $ISSUER_ID"
echo ""
echo "4. APPSTORE_API_KEY_ID"
echo "   🔑 $API_KEY_ID"
echo ""

if [ -f "/tmp/zeca-p8-content.txt" ]; then
    echo "5. APPSTORE_API_PRIVATE_KEY"
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

