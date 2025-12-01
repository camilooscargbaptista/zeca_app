#!/bin/bash

# 🍎 Script para Exportar Certificado P12 e Gerar Base64
# Facilita o processo de exportação do certificado iOS

set -e

echo "🍎 Exportar Certificado P12 - ZECA App"
echo "======================================="
echo ""

# Verificar certificado
echo "🔍 Procurando certificado de distribuição..."
CERT=$(security find-identity -v -p codesigning | grep "Apple Distribution" | head -1)

if [ -z "$CERT" ]; then
    echo "❌ Certificado de distribuição não encontrado!"
    echo ""
    echo "Soluções:"
    echo "1. Verifique se o certificado está instalado no Keychain"
    echo "2. Abra Keychain Access e procure por 'Apple Distribution'"
    echo "3. Se não encontrar, baixe do Apple Developer Portal"
    exit 1
fi

echo "✅ Certificado encontrado:"
echo "$CERT"
echo ""

# Extrair nome do certificado
CERT_NAME=$(echo "$CERT" | sed -E 's/.*"([^"]+)".*/\1/')
echo "📋 Nome do certificado: $CERT_NAME"
echo ""

# Solicitar senha
echo "🔐 Defina uma senha para o arquivo P12:"
read -sp "Senha: " P12_PASSWORD
echo ""
read -sp "Confirme a senha: " P12_PASSWORD_CONFIRM
echo ""

if [ "$P12_PASSWORD" != "$P12_PASSWORD_CONFIRM" ]; then
    echo "❌ Senhas não coincidem!"
    exit 1
fi

if [ -z "$P12_PASSWORD" ]; then
    echo "❌ Senha não pode ser vazia!"
    exit 1
fi

# Nome do arquivo
P12_FILE="$HOME/Downloads/zeca-distribution-cert.p12"

echo ""
echo "📦 Exportando certificado..."
echo "   Arquivo: $P12_FILE"
echo ""

# Exportar usando security (pode não funcionar se precisar de interação)
# Vamos tentar, mas se falhar, orientar o usuário
if security export -k "$CERT_NAME" -t identities -f pkcs12 -P "$P12_PASSWORD" -o "$P12_FILE" 2>/dev/null; then
    echo "✅ Certificado exportado com sucesso!"
else
    echo "⚠️  Exportação automática falhou (pode precisar de interação)"
    echo ""
    echo "📝 Por favor, exporte manualmente:"
    echo "1. Abra Keychain Access"
    echo "2. Procure por: '$CERT_NAME'"
    echo "3. Clique com botão direito → Export"
    echo "4. Salve como: $P12_FILE"
    echo "5. Defina a senha: [a senha que você digitou acima]"
    echo ""
    read -p "Pressione Enter quando terminar a exportação manual..."
    
    if [ ! -f "$P12_FILE" ]; then
        echo "❌ Arquivo não encontrado em: $P12_FILE"
        echo "   Verifique se exportou corretamente"
        exit 1
    fi
fi

# Verificar se arquivo existe
if [ ! -f "$P12_FILE" ]; then
    echo "❌ Arquivo não encontrado: $P12_FILE"
    exit 1
fi

echo ""
echo "✅ Arquivo P12 criado: $P12_FILE"
echo ""

# Gerar base64
echo "📦 Gerando base64..."
base64 -i "$P12_FILE" > /tmp/zeca-p12-base64.txt
echo "✅ Base64 gerado: /tmp/zeca-p12-base64.txt"
echo ""

# Copiar para clipboard
if command -v pbcopy >/dev/null 2>&1; then
    cat /tmp/zeca-p12-base64.txt | pbcopy
    echo "✅ Base64 copiado para clipboard!"
    echo ""
fi

# Resumo
echo "================================================"
echo "📋 RESUMO"
echo "================================================"
echo ""
echo "✅ Certificado exportado:"
echo "   📄 $P12_FILE"
echo ""
echo "✅ Base64 gerado:"
echo "   📄 /tmp/zeca-p12-base64.txt"
echo ""
echo "✅ Senha do P12:"
echo "   🔐 $P12_PASSWORD"
echo ""
echo "📝 Próximos passos:"
echo "1. O base64 já está no clipboard (se você tem pbcopy)"
echo "2. Configure no GitHub Secret: IOS_P12_CERTIFICATE_BASE64"
echo "3. Configure no GitHub Secret: IOS_P12_PASSWORD"
echo ""
echo "💡 Para copiar base64 novamente:"
echo "   cat /tmp/zeca-p12-base64.txt | pbcopy"
echo ""
echo "⚠️  IMPORTANTE: Guarde a senha do P12 em local seguro!"
echo "   Senha: $P12_PASSWORD"
echo ""

