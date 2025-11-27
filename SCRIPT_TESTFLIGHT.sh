#!/bin/bash

# Script para ajudar na configuração do TestFlight

echo "🚀 Configurando TestFlight para ZECA App"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Verificar versão
echo "📱 Verificando versão atual..."
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')
echo "   Versão atual: $VERSION"
echo ""

# 2. Verificar se está usando ambiente de produção
echo "🌐 Verificando configuração da API..."
if grep -q "_currentEnvironment = 'prod'" lib/core/config/api_config.dart; then
    echo -e "   ${GREEN}✅ API configurada para produção${NC}"
else
    echo -e "   ${YELLOW}⚠️  API não está configurada para produção${NC}"
    echo "   Abra lib/core/config/api_config.dart e altere _currentEnvironment para 'prod'"
fi
echo ""

# 3. Limpar build anterior
echo "🧹 Limpando builds anteriores..."
flutter clean > /dev/null 2>&1
echo "   ✅ Limpeza concluída"
echo ""

# 4. Instalar dependências
echo "📦 Instalando dependências..."
flutter pub get > /dev/null 2>&1
echo "   ✅ Dependências instaladas"
echo ""

# 5. Verificar certificados
echo "🔐 Verificando certificados..."
if security find-identity -v -p codesigning | grep -q "Distribution\|App Store"; then
    echo -e "   ${GREEN}✅ Certificado de distribuição encontrado${NC}"
else
    echo -e "   ${YELLOW}⚠️  Certificado de distribuição não encontrado${NC}"
    echo "   O Xcode criará automaticamente ao configurar o signing"
fi
echo ""

# 6. Instruções finais
echo "=========================================="
echo "📋 Próximos passos:"
echo ""
echo "1. No Xcode (que abriu agora):"
echo "   - Selecione o target 'Runner'"
echo "   - Vá em 'Signing & Capabilities'"
echo "   - Marque 'Automatically manage signing'"
echo "   - Selecione seu Team (GVU2F35AMK)"
echo ""
echo "2. Para gerar o Archive:"
echo "   - Product → Destination → Any iOS Device"
echo "   - Product → Archive"
echo ""
echo "3. Após o Archive:"
echo "   - Clique em 'Distribute App'"
echo "   - Escolha 'App Store Connect'"
echo "   - Siga o assistente de upload"
echo ""
echo "4. No App Store Connect:"
echo "   - Acesse: https://appstoreconnect.apple.com"
echo "   - Crie o app se ainda não existir"
echo "   - Configure TestFlight após o upload"
echo ""
echo "=========================================="
















