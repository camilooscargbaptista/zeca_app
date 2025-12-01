#!/bin/bash

# 🍎 Gerar Base64 do Certificado P12

echo "🍎 Gerar Base64 do Certificado P12"
echo "===================================="
echo ""

# Procurar arquivo P12
P12_FILE=""

# Verificar em diferentes locais
if [ -f "$HOME/Documentos/camilo/ZECA/keys/zeca-distribution-cert.p12" ]; then
    P12_FILE="$HOME/Documentos/camilo/ZECA/keys/zeca-distribution-cert.p12"
elif [ -f "$HOME/Downloads/zeca-distribution-cert.p12" ]; then
    P12_FILE="$HOME/Downloads/zeca-distribution-cert.p12"
else
    echo "🔍 Procurando arquivo P12..."
    P12_FILE=$(find ~/Downloads ~/Documentos -name "*.p12" -type f 2>/dev/null | head -1)
fi

if [ -z "$P12_FILE" ] || [ ! -f "$P12_FILE" ]; then
    echo "❌ Arquivo P12 não encontrado!"
    echo ""
    echo "Por favor, informe o caminho do arquivo:"
    read -p "Caminho do arquivo .p12: " P12_FILE
    
    if [ ! -f "$P12_FILE" ]; then
        echo "❌ Arquivo não encontrado: $P12_FILE"
        exit 1
    fi
fi

echo "✅ Arquivo encontrado: $P12_FILE"
echo ""

# Verificar tamanho
FILE_SIZE=$(ls -lh "$P12_FILE" | awk '{print $5}')
echo "📏 Tamanho do arquivo: $FILE_SIZE"
echo ""

# Gerar base64
echo "📦 Gerando base64..."
base64 -i "$P12_FILE" > /tmp/zeca-p12-base64.txt

if [ $? -eq 0 ]; then
    echo "✅ Base64 gerado: /tmp/zeca-p12-base64.txt"
    echo ""
    
    # Mostrar tamanho do base64
    BASE64_SIZE=$(wc -c < /tmp/zeca-p12-base64.txt)
    echo "📏 Tamanho do base64: $BASE64_SIZE bytes"
    echo ""
    
    # Copiar para clipboard
    if command -v pbcopy >/dev/null 2>&1; then
        cat /tmp/zeca-p12-base64.txt | pbcopy
        echo "✅ Base64 copiado para clipboard!"
        echo ""
    fi
    
    echo "================================================"
    echo "📋 RESUMO"
    echo "================================================"
    echo ""
    echo "✅ Arquivo P12: $P12_FILE"
    echo "✅ Base64 gerado: /tmp/zeca-p12-base64.txt"
    echo ""
    echo "📝 Próximos passos:"
    echo "1. O base64 já está no clipboard (se você tem pbcopy)"
    echo "2. Configure no GitHub Secret: IOS_P12_CERTIFICATE_BASE64"
    echo "3. Informe a senha do P12 no secret: IOS_P12_PASSWORD"
    echo ""
    echo "💡 Para copiar base64 novamente:"
    echo "   cat /tmp/zeca-p12-base64.txt | pbcopy"
    echo ""
else
    echo "❌ Erro ao gerar base64"
    exit 1
fi

