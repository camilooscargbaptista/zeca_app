#!/bin/bash

# Script interativo para configurar credenciais do App Store Connect

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}🔑 Configuração de Credenciais${NC}"
echo -e "${BLUE}   App Store Connect${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Este assistente vai ajudar você a configurar"
echo "o upload automático para TestFlight."
echo ""
echo -e "${YELLOW}⚠️  Você precisará ter:${NC}"
echo "   1. API Key criada no App Store Connect"
echo "   2. Arquivo .p8 baixado"
echo "   3. Key ID e Issuer ID anotados"
echo ""
read -p "Pressione ENTER para continuar..."
echo ""

# ============================================
# PASSO 1: Key ID
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}PASSO 1: Key ID${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Onde encontrar:"
echo "  https://appstoreconnect.apple.com/"
echo "  > Users and Access > Keys"
echo ""
echo -e "O Key ID aparece na lista (ex: ${YELLOW}ABC123XYZ${NC})"
echo ""
read -p "Digite seu Key ID: " KEY_ID
echo ""

if [ -z "$KEY_ID" ]; then
    echo -e "${RED}❌ Key ID é obrigatório!${NC}"
    exit 1
fi

# ============================================
# PASSO 2: Issuer ID
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}PASSO 2: Issuer ID${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Onde encontrar:"
echo "  https://appstoreconnect.apple.com/"
echo "  > Users and Access > Keys (no topo da página)"
echo ""
echo -e "O Issuer ID é um UUID longo (ex: ${YELLOW}12345678-1234-1234-1234-123456789012${NC})"
echo ""
read -p "Digite seu Issuer ID: " ISSUER_ID
echo ""

if [ -z "$ISSUER_ID" ]; then
    echo -e "${RED}❌ Issuer ID é obrigatório!${NC}"
    exit 1
fi

# ============================================
# PASSO 3: Caminho do arquivo .p8
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}PASSO 3: Arquivo .p8${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "O arquivo .p8 foi baixado do App Store Connect"
echo -e "(nome padrão: ${YELLOW}AuthKey_${KEY_ID}.p8${NC})"
echo ""
echo "Opções:"
echo "  1. Digitar caminho completo"
echo "  2. Arrastar arquivo para o terminal"
echo ""
read -p "Caminho do arquivo .p8: " P8_PATH
echo ""

# Remover aspas e espaços extras
P8_PATH=$(echo "$P8_PATH" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed "s/^['\"]//;s/['\"]$//")

# Expandir ~ para $HOME
P8_PATH="${P8_PATH/#\~/$HOME}"

if [ ! -f "$P8_PATH" ]; then
    echo -e "${RED}❌ Arquivo não encontrado: $P8_PATH${NC}"
    echo ""
    echo "Verifique se o caminho está correto e tente novamente."
    exit 1
fi

echo -e "${GREEN}✅ Arquivo encontrado: $P8_PATH${NC}"
echo ""

# Sugerir mover para local seguro
echo -e "${YELLOW}💡 Recomendação de Segurança${NC}"
echo ""
echo "É recomendado mover o arquivo .p8 para um diretório dedicado:"
echo -e "  ${YELLOW}~/app_store_credentials/${NC}"
echo ""
read -p "Deseja mover o arquivo para lá? (s/N): " MOVE_FILE
echo ""

FINAL_P8_PATH="$P8_PATH"

if [ "$MOVE_FILE" = "s" ] || [ "$MOVE_FILE" = "S" ]; then
    CREDENTIALS_DIR="$HOME/app_store_credentials"
    mkdir -p "$CREDENTIALS_DIR"
    
    P8_FILENAME=$(basename "$P8_PATH")
    NEW_P8_PATH="$CREDENTIALS_DIR/$P8_FILENAME"
    
    cp "$P8_PATH" "$NEW_P8_PATH"
    
    if [ -f "$NEW_P8_PATH" ]; then
        echo -e "${GREEN}✅ Arquivo copiado para: $NEW_P8_PATH${NC}"
        echo ""
        FINAL_P8_PATH="~/app_store_credentials/$P8_FILENAME"
    else
        echo -e "${RED}❌ Erro ao copiar arquivo${NC}"
        exit 1
    fi
fi

# ============================================
# PASSO 4: Salvar configuração
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}PASSO 4: Salvando configuração${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Resumo da configuração:"
echo ""
echo -e "  Key ID:     ${GREEN}$KEY_ID${NC}"
echo -e "  Issuer ID:  ${GREEN}$ISSUER_ID${NC}"
echo -e "  Arquivo:    ${GREEN}$FINAL_P8_PATH${NC}"
echo ""
read -p "Salvar configuração? (S/n): " CONFIRM
echo ""

if [ "$CONFIRM" = "n" ] || [ "$CONFIRM" = "N" ]; then
    echo "Configuração cancelada."
    exit 0
fi

# Criar arquivo .env.appstore
cat > .env.appstore << EOF
# Configuração para upload automático no App Store Connect
# NÃO COMMITAR ESTE ARQUIVO NO GIT!
# Gerado em: $(date)

# API Key do App Store Connect
# Como obter: https://appstoreconnect.apple.com/ > Users and Access > Keys
APPSTORE_API_KEY_ID=$KEY_ID
APPSTORE_API_ISSUER_ID=$ISSUER_ID

# Caminho para o arquivo .p8 da API Key
# Baixe em: App Store Connect > Users and Access > Keys > Download
APPSTORE_API_KEY_PATH=$FINAL_P8_PATH

# Bundle ID do app (deixe vazio para usar o do projeto)
APPSTORE_BUNDLE_ID=com.abasteca.zeca
EOF

if [ -f ".env.appstore" ]; then
    echo -e "${GREEN}✅ Configuração salva em: .env.appstore${NC}"
    echo ""
else
    echo -e "${RED}❌ Erro ao salvar configuração${NC}"
    exit 1
fi

# Verificar .gitignore
if ! grep -q "\.env\.appstore" .gitignore 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Adicionando .env.appstore ao .gitignore...${NC}"
    echo "" >> .gitignore
    echo "# App Store Connect credentials (NUNCA commitar!)" >> .gitignore
    echo ".env.appstore" >> .gitignore
    echo "*.p8" >> .gitignore
    echo ""
fi

# ============================================
# PASSO 5: Testar configuração
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}PASSO 5: Testando configuração${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Verificando se tudo está correto..."
echo ""

# Carregar .env.appstore
source .env.appstore

# Expandir ~ no caminho
TEST_P8_PATH="${APPSTORE_API_KEY_PATH/#\~/$HOME}"

# Verificar valores
ERROR=0

if [ -z "$APPSTORE_API_KEY_ID" ]; then
    echo -e "${RED}❌ APPSTORE_API_KEY_ID não definido${NC}"
    ERROR=1
else
    echo -e "${GREEN}✅ Key ID configurado${NC}"
fi

if [ -z "$APPSTORE_API_ISSUER_ID" ]; then
    echo -e "${RED}❌ APPSTORE_API_ISSUER_ID não definido${NC}"
    ERROR=1
else
    echo -e "${GREEN}✅ Issuer ID configurado${NC}"
fi

if [ -z "$APPSTORE_API_KEY_PATH" ]; then
    echo -e "${RED}❌ APPSTORE_API_KEY_PATH não definido${NC}"
    ERROR=1
elif [ ! -f "$TEST_P8_PATH" ]; then
    echo -e "${RED}❌ Arquivo .p8 não encontrado: $TEST_P8_PATH${NC}"
    ERROR=1
else
    echo -e "${GREEN}✅ Arquivo .p8 encontrado${NC}"
fi

echo ""

if [ $ERROR -eq 1 ]; then
    echo -e "${RED}❌ Configuração inválida!${NC}"
    echo ""
    echo "Corrija os erros e tente novamente."
    exit 1
fi

# ============================================
# SUCESSO!
# ============================================
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Configuração concluída com sucesso!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Agora você pode fazer builds e uploads automáticos com:"
echo ""
echo -e "  ${BLUE}./build_testflight.sh --version 1.0.1${NC}"
echo ""
echo "O script vai:"
echo "  1. Incrementar a versão automaticamente"
echo "  2. Criar o IPA"
echo "  3. Fazer upload para App Store Connect"
echo "  4. Notificar quando estiver pronto"
echo ""
echo -e "${YELLOW}💡 Dica:${NC} Confira o guia completo em:"
echo -e "   ${BLUE}TESTFLIGHT_SETUP.md${NC}"
echo ""
echo "🎉 Pronto para começar!"
echo ""

