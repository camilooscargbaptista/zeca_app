#!/bin/bash

# Script para limpar completamente CocoaPods e reinstalar
# Útil quando há problemas de cache corrompido

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo -e "${YELLOW}🧹 Limpeza Completa de CocoaPods${NC}"
echo ""

echo "📦 Removendo Pods e Podfile.lock..."
cd ios
rm -rf Pods Podfile.lock
echo -e "${GREEN}✅ Pods removidos${NC}"
echo ""

echo "🗑️  Limpando cache local do CocoaPods..."
rm -rf ~/Library/Caches/CocoaPods
echo -e "${GREEN}✅ Cache local limpo${NC}"
echo ""

echo "🔄 Atualizando repositório do CocoaPods..."
if pod repo update; then
    echo -e "${GREEN}✅ Repositório atualizado${NC}"
else
    echo -e "${YELLOW}⚠️  Erro ao atualizar repositório, continuando...${NC}"
fi
echo ""

echo "📦 Instalando CocoaPods do zero..."
if pod install; then
    echo -e "${GREEN}✅ CocoaPods instalado com sucesso!${NC}"
    echo ""
    echo -e "${GREEN}🎉 Pronto! Agora você pode rodar o build normalmente.${NC}"
else
    echo -e "${RED}❌ Erro ao instalar CocoaPods${NC}"
    echo ""
    echo "Possíveis soluções:"
    echo "1. Verificar versão do Ruby: ruby --version"
    echo "2. Atualizar CocoaPods: sudo gem install cocoapods"
    echo "3. Verificar permissões: ls -la Podfile"
    exit 1
fi

cd ..

