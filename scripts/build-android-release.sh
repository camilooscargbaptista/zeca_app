#!/bin/bash

# Script automatizado para build Android release
# Faz o máximo possível automaticamente

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Build Android Release - ZECA App${NC}"
echo "=========================================="
echo ""

# Verificar se está no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Erro: Execute este script na raiz do projeto Flutter${NC}"
    exit 1
fi

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Erro: Flutter não está instalado ou não está no PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Ambiente verificado${NC}"
echo ""

# Verificar versão atual
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
VERSION_CODE=$(echo $VERSION | cut -d'+' -f2)

echo -e "${BLUE}📦 Versão atual:${NC} $VERSION_NAME (build $VERSION_CODE)"
echo ""

# Verificar se key.properties existe
KEY_PROPERTIES="android/key.properties"
KEYSTORE="android/app/zeca-release-key.jks"

if [ ! -f "$KEY_PROPERTIES" ]; then
    echo -e "${YELLOW}⚠️  Arquivo key.properties não encontrado${NC}"
    echo ""
    
    if [ ! -f "$KEYSTORE" ]; then
        echo -e "${RED}❌ Erro: Keystore não encontrado em $KEYSTORE${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📝 Criando key.properties...${NC}"
    echo ""
    
    # Tentar recuperar do GitHub Secrets (se possível)
    if command -v gh &> /dev/null; then
        echo -e "${BLUE}🔐 Tentando recuperar credenciais do GitHub Secrets...${NC}"
        
        # Verificar se está autenticado
        if gh auth status &> /dev/null; then
            STORE_PASSWORD=$(gh secret get ANDROID_KEYSTORE_PASSWORD 2>/dev/null || echo "")
            KEY_PASSWORD=$(gh secret get ANDROID_KEY_PASSWORD 2>/dev/null || echo "")
            KEY_ALIAS=$(gh secret get ANDROID_KEY_ALIAS 2>/dev/null || echo "zeca-key")
            
            if [ ! -z "$STORE_PASSWORD" ] && [ ! -z "$KEY_PASSWORD" ]; then
                echo -e "${GREEN}✅ Credenciais recuperadas do GitHub Secrets${NC}"
                cat > "$KEY_PROPERTIES" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=${KEY_ALIAS:-zeca-key}
storeFile=zeca-release-key.jks
EOF
                echo -e "${GREEN}✅ key.properties criado automaticamente${NC}"
            else
                echo -e "${YELLOW}⚠️  Não foi possível recuperar do GitHub. Usando script interativo...${NC}"
                ./scripts/criar-key-properties.sh
            fi
        else
            echo -e "${YELLOW}⚠️  GitHub CLI não autenticado. Usando script interativo...${NC}"
            ./scripts/criar-key-properties.sh
        fi
    else
        echo -e "${YELLOW}⚠️  GitHub CLI não disponível. Usando script interativo...${NC}"
        ./scripts/criar-key-properties.sh
    fi
    
    echo ""
else
    echo -e "${GREEN}✅ key.properties encontrado${NC}"
fi

# Verificar se keystore existe
if [ ! -f "$KEYSTORE" ]; then
    echo -e "${RED}❌ Erro: Keystore não encontrado em $KEYSTORE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Keystore encontrado${NC}"
echo ""

# Limpar build anterior
echo -e "${BLUE}🧹 Limpando build anterior...${NC}"
flutter clean
echo ""

# Obter dependências
echo -e "${BLUE}📦 Obtendo dependências...${NC}"
flutter pub get
echo ""

# Verificar se há erros
echo -e "${BLUE}🔍 Verificando código...${NC}"
if ! flutter analyze --no-fatal-infos 2>&1 | grep -q "No issues found"; then
    echo -e "${YELLOW}⚠️  Avisos encontrados no código (continuando mesmo assim)...${NC}"
fi
echo ""

# Gerar AAB
echo -e "${BLUE}🏗️  Gerando Android App Bundle (AAB)...${NC}"
echo ""

# Executar build (pode mostrar aviso sobre símbolos de debug, mas não é fatal)
flutter build appbundle --release 2>&1 | tee /tmp/flutter_build.log

# Verificar se o AAB foi gerado (mesmo com avisos)
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"

if [ -f "$AAB_PATH" ]; then
        AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
        echo ""
        echo -e "${GREEN}✅ Build concluído com sucesso!${NC}"
        echo ""
        echo -e "${BLUE}📦 Arquivo gerado:${NC}"
        echo "   $AAB_PATH"
        echo "   Tamanho: $AAB_SIZE"
        echo ""
        echo -e "${BLUE}📋 Informações da versão:${NC}"
        echo "   Version Name: $VERSION_NAME"
        echo "   Version Code: $VERSION_CODE"
        echo ""
        echo -e "${GREEN}🎯 Próximos passos:${NC}"
        echo ""
        echo "1. Acesse: https://play.google.com/console"
        echo "2. Selecione o app 'ZECA'"
        echo "3. Vá em 'Produção' (ou ambiente de teste)"
        echo "4. Clique em 'Criar nova versão'"
        echo "5. Faça upload do arquivo:"
        echo "   $(pwd)/$AAB_PATH"
        echo ""
        echo -e "${BLUE}💡 Dica: Você pode arrastar o arquivo diretamente para o navegador${NC}"
        echo ""
        
        # Tentar abrir o arquivo no Finder (macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "${BLUE}📂 Abrindo localização do arquivo no Finder...${NC}"
            open -R "$AAB_PATH"
        fi
        
        exit 0
else
    echo -e "${YELLOW}⚠️  AAB não encontrado. Verificando logs...${NC}"
    echo ""
    
    # Verificar se o erro foi apenas sobre símbolos de debug
    if grep -q "failed to strip debug symbols" /tmp/flutter_build.log 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Aviso sobre símbolos de debug detectado${NC}"
        echo "   Este aviso geralmente não impede o build."
        echo "   Verificando se há outros erros..."
        echo ""
        
        # Verificar se há erros reais
        if grep -i "error\|failed\|exception" /tmp/flutter_build.log | grep -v "failed to strip" | head -5; then
            echo -e "${RED}❌ Erros encontrados no build. Verifique os logs acima.${NC}"
            exit 1
        else
            echo -e "${YELLOW}⚠️  Apenas avisos sobre símbolos de debug. Tentando localizar AAB...${NC}"
            # Tentar encontrar AAB em outros locais possíveis
            ALTERNATIVE_AAB=$(find build -name "*.aab" -type f 2>/dev/null | head -1)
            if [ ! -z "$ALTERNATIVE_AAB" ]; then
                echo -e "${GREEN}✅ AAB encontrado em: $ALTERNATIVE_AAB${NC}"
                AAB_PATH="$ALTERNATIVE_AAB"
                # Continuar com o fluxo normal
            else
                echo -e "${RED}❌ AAB não foi gerado. Verifique os logs completos em /tmp/flutter_build.log${NC}"
                exit 1
            fi
        fi
    else
        echo -e "${RED}❌ Erro ao gerar build. Verifique os logs em /tmp/flutter_build.log${NC}"
        tail -30 /tmp/flutter_build.log
        exit 1
    fi
fi

