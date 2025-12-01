#!/bin/bash

# Script para facilitar upload na Play Store
# Abre a Play Console e mostra instruções

set -e

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

AAB_PATH="build/app/outputs/bundle/release/app-release.aab"

if [ ! -f "$AAB_PATH" ]; then
    echo -e "${YELLOW}⚠️  AAB não encontrado. Gerando build primeiro...${NC}"
    ./scripts/build-android-release.sh
fi

if [ ! -f "$AAB_PATH" ]; then
    echo -e "${RED}❌ Erro: AAB não foi gerado${NC}"
    exit 1
fi

echo -e "${BLUE}📤 Preparando upload para Google Play Store${NC}"
echo ""

# Obter informações da versão
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
VERSION_CODE=$(echo $VERSION | cut -d'+' -f2)
AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)

echo -e "${GREEN}✅ Arquivo pronto para upload:${NC}"
echo "   $AAB_PATH"
echo "   Tamanho: $AAB_SIZE"
echo "   Versão: $VERSION_NAME (build $VERSION_CODE)"
echo ""

# Abrir Play Console
echo -e "${BLUE}🌐 Abrindo Google Play Console...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    open "https://play.google.com/console/u/0/developers/4737597685833984405/app/4973701232131244565/app-dashboard?hl=pt-BR"
else
    xdg-open "https://play.google.com/console/u/0/developers/4737597685833984405/app/4973701232131244565/app-dashboard?hl=pt-BR" 2>/dev/null || echo "Acesse: https://play.google.com/console"
fi

echo ""
echo -e "${BLUE}📋 Instruções passo a passo:${NC}"
echo ""
echo "1. Na Play Console, vá em 'Produção' (ou ambiente de teste)"
echo "2. Clique em 'Criar nova versão' ou 'Criar release'"
echo "3. Na seção 'Artefatos do app', clique em 'Fazer upload'"
echo "4. Selecione ou arraste o arquivo:"
echo "   $(pwd)/$AAB_PATH"
echo ""
echo "5. Preencha as 'Notas da versão' com as mudanças desta versão"
echo "6. Revise todas as informações"
echo "7. Clique em 'Revisar release'"
echo "8. Se tudo estiver correto, clique em 'Iniciar rollout para Produção'"
echo ""

# Abrir localização do arquivo
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${BLUE}📂 Abrindo localização do arquivo...${NC}"
    open -R "$AAB_PATH"
fi

echo -e "${GREEN}✅ Pronto! Siga as instruções acima para fazer o upload.${NC}"

