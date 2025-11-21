#!/bin/bash

# Script automatizado para build e upload do ZECA App para TestFlight
# Uso: ./build_testflight.sh [--skip-upload] [--version 1.0.1] [--build-number 2] [--no-version-increment]
#
# Por padrão, o script incrementa automaticamente:
# - Versão (patch): 1.0.0 -> 1.0.1
# - Build number: 1 -> 2

# NOTA: Não usamos 'set -e' para poder capturar e mostrar erros detalhados

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_UPLOAD=false
VERSION_OVERRIDE=""
BUILD_NUMBER_OVERRIDE=""
NO_VERSION_INCREMENT=false

# Parse argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-upload)
            SKIP_UPLOAD=true
            shift
            ;;
        --version)
            VERSION_OVERRIDE="$2"
            shift 2
            ;;
        --build-number)
            BUILD_NUMBER_OVERRIDE="$2"
            shift 2
            ;;
        --no-version-increment)
            NO_VERSION_INCREMENT=true
            shift
            ;;
        --help)
            echo "Uso: $0 [opções]"
            echo ""
            echo "Opções:"
            echo "  --skip-upload           Não fazer upload automático (apenas build)"
            echo "  --version X.Y.Z         Definir versão manualmente (ex: 1.0.1)"
            echo "  --build-number N        Definir build number manualmente (ex: 2)"
            echo "  --no-version-increment  Não incrementar versão automaticamente (mantém versão atual)"
            echo "  --help                  Mostrar esta ajuda"
            echo ""
            echo "Por padrão, o script incrementa automaticamente:"
            echo "  - Versão (patch): 1.0.0 -> 1.0.1"
            echo "  - Build number: 1 -> 2"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

cd "$PROJECT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}🚀 Build TestFlight - ZECA App${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Função para verificar comandos
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}❌ $1 não está instalado${NC}"
        exit 1
    fi
}

# Verificar comandos necessários
echo "📋 Verificando dependências..."
check_command "flutter"
check_command "xcodebuild"
check_command "pod"
echo -e "${GREEN}✅ Todas as dependências estão instaladas${NC}"
echo ""

# Verificar configuração da API
echo "🌐 Verificando configuração da API..."
if grep -q "_currentEnvironment = 'prod'" lib/core/config/api_config.dart; then
    echo -e "${GREEN}✅ API configurada para produção${NC}"
else
    echo -e "${YELLOW}⚠️  API não está configurada para produção!${NC}"
    read -p "Continuar mesmo assim? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi
echo ""

# Verificar versão
echo "📱 Verificando versão..."
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
VERSION_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# Extrair partes da versão (ex: 1.0.0 -> major=1, minor=0, patch=0)
MAJOR=$(echo "$VERSION_NUMBER" | cut -d'.' -f1)
MINOR=$(echo "$VERSION_NUMBER" | cut -d'.' -f2)
PATCH=$(echo "$VERSION_NUMBER" | cut -d'.' -f3)

if [ -n "$VERSION_OVERRIDE" ]; then
    VERSION_NUMBER="$VERSION_OVERRIDE"
    echo "   Versão definida manualmente: $VERSION_NUMBER"
    # Re-extrair partes se versão foi definida manualmente
    MAJOR=$(echo "$VERSION_NUMBER" | cut -d'.' -f1)
    MINOR=$(echo "$VERSION_NUMBER" | cut -d'.' -f2)
    PATCH=$(echo "$VERSION_NUMBER" | cut -d'.' -f3)
elif [ "$NO_VERSION_INCREMENT" = true ]; then
    # Manter versão atual (não incrementar)
    echo "   Versão mantida: $VERSION_NUMBER (sem incremento)"
else
    # Incrementar versão automaticamente (patch version)
    PATCH=$((PATCH + 1))
    VERSION_NUMBER="${MAJOR}.${MINOR}.${PATCH}"
    echo "   Versão incrementada automaticamente: $VERSION_NUMBER"
fi

if [ -n "$BUILD_NUMBER_OVERRIDE" ]; then
    BUILD_NUMBER="$BUILD_NUMBER_OVERRIDE"
    echo "   Build number definido manualmente: $BUILD_NUMBER"
else
    # Incrementar build number automaticamente
    BUILD_NUMBER=$((BUILD_NUMBER + 1))
    echo "   Build number incrementado: $BUILD_NUMBER"
fi

NEW_VERSION="${VERSION_NUMBER}+${BUILD_NUMBER}"
echo "   Versão atual: $CURRENT_VERSION"
echo "   Nova versão: $NEW_VERSION"
echo ""

# Atualizar versão no pubspec.yaml
if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
    echo "📝 Atualizando versão no pubspec.yaml..."
    sed -i '' "s/^version:.*/version: $NEW_VERSION/" pubspec.yaml
    echo -e "${GREEN}✅ Versão atualizada${NC}"
    echo ""
fi

# Limpar builds anteriores
echo "🧹 Limpando builds anteriores..."
flutter clean > /dev/null 2>&1
echo -e "${GREEN}✅ Limpeza concluída${NC}"
echo ""

# Instalar dependências Flutter
echo "📦 Instalando dependências Flutter..."
flutter pub get > /dev/null 2>&1
echo -e "${GREEN}✅ Dependências Flutter instaladas${NC}"
echo ""

# Instalar pods
echo "📦 Instalando CocoaPods..."
cd ios
echo "   Executando: pod install --repo-update"
if pod install --repo-update > /tmp/pod_install.log 2>&1; then
echo -e "${GREEN}✅ CocoaPods instalado${NC}"
else
    echo -e "${RED}❌ Erro ao instalar CocoaPods${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 ÚLTIMAS 30 LINHAS DO LOG:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    tail -30 /tmp/pod_install.log
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 Log completo em: /tmp/pod_install.log"
    echo ""
    cd ..
    exit 1
fi
cd ..
echo ""

# Verificar certificados
echo "🔐 Verificando certificados..."
CERT_COUNT=$(security find-identity -v -p codesigning | grep -c "Developer\|Distribution" || echo "0")
if [ "$CERT_COUNT" -eq "0" ]; then
    echo -e "${YELLOW}⚠️  Nenhum certificado encontrado${NC}"
    echo "   Certificados serão criados automaticamente pelo Xcode"
else
    echo -e "${GREEN}✅ $CERT_COUNT certificado(s) encontrado(s)${NC}"
fi
echo ""

# Verificar configuração do projeto
echo "🔍 Verificando configuração do projeto..."
DEVELOPMENT_TEAM=$(xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner 2>/dev/null | grep "DEVELOPMENT_TEAM" | head -1 | sed 's/.*= *//' || echo "")
BUNDLE_ID=$(xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner 2>/dev/null | grep "PRODUCT_BUNDLE_IDENTIFIER" | head -1 | sed 's/.*= *//' || echo "")

if [ -n "$DEVELOPMENT_TEAM" ]; then
    echo "   Development Team: $DEVELOPMENT_TEAM"
else
    echo -e "${YELLOW}⚠️  Development Team não configurado${NC}"
fi

if [ -n "$BUNDLE_ID" ]; then
    echo "   Bundle ID: $BUNDLE_ID"
else
    echo -e "${RED}❌ Bundle ID não encontrado${NC}"
    exit 1
fi
echo ""

# Build do iOS via Flutter
echo "🔨 Compilando e criando IPA (Release)..."
echo "   Executando: flutter build ipa --release"
echo "   Isso pode demorar alguns minutos..."
echo ""

if flutter build ipa --release > /tmp/flutter_build.log 2>&1; then
    echo -e "${GREEN}✅ IPA criado com sucesso!${NC}"
    IPA_PATH=$(find build/ios/ipa -name "*.ipa" 2>/dev/null | head -1)
    ARCHIVE_PATH=$(find build/ios/archive -name "*.xcarchive" -type d 2>/dev/null | head -1)
    
    if [ -n "$IPA_PATH" ]; then
        echo "   IPA: $IPA_PATH"
    fi
    if [ -n "$ARCHIVE_PATH" ]; then
        echo "   Archive: $ARCHIVE_PATH"
        ARCHIVE_CREATED=true
    else
        ARCHIVE_CREATED=false
    fi
else
    echo -e "${RED}❌ Build Flutter falhou!${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 ERROS DO BUILD:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    # Mostrar linhas com "error:" ou "failed"
    grep -i "error\|failed\|exception" /tmp/flutter_build.log | tail -20
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📋 ÚLTIMAS 30 LINHAS DO LOG COMPLETO:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    tail -30 /tmp/flutter_build.log
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 Log completo em: /tmp/flutter_build.log"
    echo ""
    echo "🔧 Tentando via Xcode diretamente..."
    ARCHIVE_CREATED=false
    IPA_PATH=""
fi
echo ""

# Criar Archive via xcodebuild (se o Flutter não criou)
if [ "$ARCHIVE_CREATED" = false ]; then
    echo "📦 Criando Archive via Xcode..."
    cd ios
    
    # Verificar se há workspace
    if [ ! -f "Runner.xcworkspace/contents.xcworkspacedata" ]; then
        echo -e "${RED}❌ Runner.xcworkspace não encontrado${NC}"
        exit 1
    fi
    
    ARCHIVE_PATH="$PROJECT_DIR/build/ios/archive/Runner.xcarchive"
    mkdir -p "$(dirname "$ARCHIVE_PATH")"
    
    echo "   Criando archive (isso pode demorar alguns minutos)..."
    echo "   Executando: xcodebuild clean archive..."
    echo ""
    
    if xcodebuild clean archive \
        -workspace Runner.xcworkspace \
        -scheme Runner \
        -configuration Release \
        -destination "generic/platform=iOS" \
        -archivePath "$ARCHIVE_PATH" \
        > /tmp/xcode_archive.log 2>&1; then
        echo -e "${GREEN}✅ Archive criado com sucesso${NC}"
        echo "   Localização: $ARCHIVE_PATH"
        ARCHIVE_CREATED=true
    else
        echo -e "${RED}❌ Erro ao criar archive via Xcode${NC}"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📋 ERROS DO XCODE:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        grep -i "error\|failed\|exception" /tmp/xcode_archive.log | tail -20
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "📋 ÚLTIMAS 30 LINHAS DO LOG COMPLETO:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        tail -30 /tmp/xcode_archive.log
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "💡 Log completo em: /tmp/xcode_archive.log"
        echo ""
        echo "🔧 Você pode criar manualmente no Xcode"
        echo ""
        echo -e "${RED}❌ BUILD FALHOU - Corrija os erros acima e tente novamente${NC}"
        echo ""
        cd ..
        exit 1
    fi
    
    cd ..
    echo ""
fi

# Verificar se realmente conseguiu criar algo
if [ "$ARCHIVE_CREATED" = false ] && [ -z "$IPA_PATH" ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}❌ BUILD FALHOU COMPLETAMENTE${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Nenhum IPA ou Archive foi criado."
    echo ""
    echo "📋 Verifique os erros acima e:"
    echo "   1. Corrija os erros no código"
    echo "   2. Execute o script novamente"
    echo "   3. Ou crie manualmente no Xcode"
    echo ""
    echo "📂 Abrindo Xcode para correção manual..."
    open ios/Runner.xcworkspace
    echo ""
    exit 1
fi

# Abrir Organizer do Xcode ou arquivo
if [ "$ARCHIVE_CREATED" = true ] && [ -d "$ARCHIVE_PATH" ]; then
    echo "📂 Abrindo Xcode Organizer com o archive..."
    open "$ARCHIVE_PATH"
elif [ -n "$IPA_PATH" ] && [ -f "$IPA_PATH" ]; then
    echo "📂 IPA criado em: $IPA_PATH"
    echo "   Para upload, use Xcode ou Transporter"
else
    echo "📂 Abrindo Xcode para criar archive manualmente..."
    open ios/Runner.xcworkspace
fi
echo ""
echo -e "${GREEN}✅ Pronto para upload${NC}"
echo ""

# Upload para App Store Connect (se não for skip)
if [ "$SKIP_UPLOAD" = false ]; then
    echo "📤 Upload para App Store Connect..."
    echo ""
    
    # Tentar carregar credenciais do arquivo .env.appstore
    if [ -f ".env.appstore" ]; then
        echo "📁 Carregando credenciais de .env.appstore..."
        source .env.appstore
        
        if [ -n "$APPSTORE_API_KEY_ID" ] && [ -n "$APPSTORE_API_ISSUER_ID" ] && [ -n "$APPSTORE_API_KEY_PATH" ]; then
            # Expandir ~
            APPSTORE_API_KEY_PATH="${APPSTORE_API_KEY_PATH/#\~/$HOME}"
            
            if [ ! -f "$APPSTORE_API_KEY_PATH" ]; then
                echo -e "${RED}❌ Arquivo de chave não encontrado: $APPSTORE_API_KEY_PATH${NC}"
                echo ""
                echo "Verifique se o caminho está correto no arquivo .env.appstore"
                echo ""
                exit 1
            fi
            
            echo "🔑 Credenciais encontradas:"
            echo "   Key ID: $APPSTORE_API_KEY_ID"
            echo "   Issuer ID: $APPSTORE_API_ISSUER_ID"
            echo "   Key Path: $APPSTORE_API_KEY_PATH"
            echo ""
            
            # Verificar se IPA existe
            if [ -z "$IPA_PATH" ] || [ ! -f "$IPA_PATH" ]; then
                echo -e "${RED}❌ IPA não encontrado para upload${NC}"
                echo ""
                exit 1
            fi
            
            echo "📤 Fazendo upload do IPA..."
            echo "   IPA: $IPA_PATH"
            echo ""
            
            # Upload usando xcrun altool (Transporter CLI)
            # NOTA: altool está deprecated, mas ainda funciona. 
            # No futuro, usar: xcrun notarytool
            if xcrun altool --upload-app \
                --type ios \
                --file "$IPA_PATH" \
                --apiKey "$APPSTORE_API_KEY_ID" \
                --apiIssuer "$APPSTORE_API_ISSUER_ID" \
                2>&1 | tee /tmp/appstore_upload.log; then
                echo ""
                echo -e "${GREEN}✅ Upload concluído com sucesso!${NC}"
                echo ""
                echo "📝 Próximos passos:"
                echo "   1. Acesse App Store Connect"
                echo "   2. Aguarde processamento (10-30 minutos)"
                echo "   3. Configure TestFlight após processamento"
                echo ""
            else
                echo ""
                echo -e "${RED}❌ Erro no upload${NC}"
                echo ""
                echo "Verifique o log: /tmp/appstore_upload.log"
                echo ""
                exit 1
            fi
        else
            echo -e "${YELLOW}⚠️  Credenciais incompletas em .env.appstore${NC}"
            echo ""
            echo "Configure o arquivo .env.appstore com:"
            echo "  APPSTORE_API_KEY_ID"
            echo "  APPSTORE_API_ISSUER_ID"
            echo "  APPSTORE_API_KEY_PATH"
            echo ""
            echo "Upload manual via Xcode..."
            echo ""
        fi
    else
        echo -e "${YELLOW}⚠️  Arquivo .env.appstore não encontrado${NC}"
        echo ""
        echo "Para configurar upload automático:"
        echo ""
        echo "1. Crie o arquivo .env.appstore com:"
    echo ""
        echo "   APPSTORE_API_KEY_ID=YOUR_KEY_ID"
        echo "   APPSTORE_API_ISSUER_ID=YOUR_ISSUER_ID"
        echo "   APPSTORE_API_KEY_PATH=~/path/to/AuthKey_XXX.p8"
    echo ""
        echo "2. Obtenha credenciais em:"
        echo "   https://appstoreconnect.apple.com/ > Users and Access > Keys"
    echo ""
        echo "Por enquanto, upload manual via Xcode..."
    echo ""
    fi
else
    echo -e "${YELLOW}ℹ️  Upload ignorado (--skip-upload)${NC}"
    echo ""
fi

# Resumo
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ Build concluído com sucesso!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "📋 Resumo:"
echo "   Versão: $NEW_VERSION"
echo "   Bundle ID: $BUNDLE_ID"
echo "   Archive: $ARCHIVE_PATH"
echo ""
echo "📝 Próximos passos:"
echo "   1. No Xcode Organizer, faça o upload"
echo "   2. Acesse App Store Connect"
echo "   3. Configure TestFlight após processamento"
echo ""
echo -e "${GREEN}🎉 Pronto!${NC}"

