#!/bin/bash

# Script para criar release e triggerar deploy automático
# Uso: ./scripts/create-release.sh [version] [build_number]

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar se está no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Execute este script na raiz do projeto${NC}"
    exit 1
fi

# Ler versão atual
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
VERSION_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# Parse argumentos
if [ -n "$1" ]; then
    VERSION_NUMBER="$1"
fi

if [ -n "$2" ]; then
    BUILD_NUMBER="$2"
else
    # Incrementar build number automaticamente
    BUILD_NUMBER=$((BUILD_NUMBER + 1))
fi

NEW_VERSION="${VERSION_NUMBER}+${BUILD_NUMBER}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}🚀 Criar Release e Deploy${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Versão atual: ${YELLOW}$CURRENT_VERSION${NC}"
echo -e "Nova versão:  ${GREEN}$NEW_VERSION${NC}"
echo ""

# Confirmar
read -p "Continuar? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado."
    exit 0
fi

# Atualizar versão no pubspec.yaml
echo -e "${BLUE}📝 Atualizando versão no pubspec.yaml...${NC}"
sed -i '' "s/^version:.*/version: $NEW_VERSION/" pubspec.yaml
echo -e "${GREEN}✅ Versão atualizada${NC}"
echo ""

# Commit mudanças
echo -e "${BLUE}📦 Fazendo commit...${NC}"
git add pubspec.yaml
git commit -m "chore: atualizar versão para $NEW_VERSION" || true
echo -e "${GREEN}✅ Commit criado${NC}"
echo ""

# Criar tag
TAG="v${VERSION_NUMBER}"
echo -e "${BLUE}🏷️  Criando tag: $TAG${NC}"
git tag -a "$TAG" -m "Release $NEW_VERSION"
echo -e "${GREEN}✅ Tag criada${NC}"
echo ""

# Push
echo -e "${BLUE}📤 Fazendo push...${NC}"
read -p "Fazer push do commit e tag? (s/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    git push
    git push origin "$TAG"
    echo -e "${GREEN}✅ Push concluído${NC}"
    echo ""
    echo -e "${GREEN}🎉 Release criada com sucesso!${NC}"
    echo ""
    echo -e "📊 Acompanhe o deploy em:"
    echo -e "   ${BLUE}https://github.com/[seu-repo]/actions${NC}"
    echo ""
    echo -e "⏱️  O deploy deve iniciar em alguns segundos..."
else
    echo -e "${YELLOW}⚠️  Push não realizado. Execute manualmente:${NC}"
    echo "   git push"
    echo "   git push origin $TAG"
fi

