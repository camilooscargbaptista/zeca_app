#!/bin/bash

# 🚀 Script para Configurar Todos os Secrets no GitHub Automaticamente
# Usa GitHub CLI (gh) para configurar os secrets

set -e

echo "🚀 Configurar Secrets no GitHub - Automático"
echo "=============================================="
echo ""

# Verificar se gh está instalado
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) não está instalado!"
    echo ""
    echo "Instale com:"
    echo "  brew install gh"
    echo ""
    exit 1
fi

# Verificar autenticação - testar se consegue acessar o repositório
echo "🔐 Verificando autenticação..."
if gh repo view &>/dev/null; then
    echo "✅ Autenticado no GitHub CLI"
else
    echo "⚠️  Você precisa autenticar no GitHub CLI primeiro!"
    echo ""
    echo "Execute:"
    echo "  gh auth login"
    echo ""
    echo "Ou se preferir, configure manualmente no GitHub."
    exit 1
fi
echo ""

# Verificar se estamos no repositório correto
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [ -z "$REPO" ]; then
    echo "⚠️  Não foi possível detectar o repositório atual"
    echo "   Certifique-se de estar no diretório do repositório Git"
    exit 1
fi

echo "📦 Repositório: $REPO"
echo ""

# Verificar se os arquivos existem
echo "🔍 Verificando arquivos necessários..."

MISSING_FILES=0

if [ ! -f "/tmp/zeca-p12-base64.txt" ]; then
    echo "❌ Arquivo não encontrado: /tmp/zeca-p12-base64.txt"
    MISSING_FILES=1
fi

if [ ! -f "/tmp/zeca-keystore-base64.txt" ]; then
    echo "❌ Arquivo não encontrado: /tmp/zeca-keystore-base64.txt"
    MISSING_FILES=1
fi

if [ ! -f "/tmp/zeca-p8-content.txt" ]; then
    echo "❌ Arquivo não encontrado: /tmp/zeca-p8-content.txt"
    MISSING_FILES=1
fi

if [ $MISSING_FILES -eq 1 ]; then
    echo ""
    echo "⚠️  Alguns arquivos estão faltando!"
    echo "   Execute os scripts de geração primeiro."
    exit 1
fi

echo "✅ Todos os arquivos encontrados"
echo ""

# Confirmar antes de continuar
echo "⚠️  ATENÇÃO: Este script vai configurar os seguintes secrets:"
echo ""
echo "iOS (5):"
echo "  - IOS_P12_CERTIFICATE_BASE64"
echo "  - IOS_P12_PASSWORD"
echo "  - APPSTORE_ISSUER_ID"
echo "  - APPSTORE_API_KEY_ID"
echo "  - APPSTORE_API_PRIVATE_KEY"
echo ""
echo "Android (4):"
echo "  - ANDROID_KEYSTORE_BASE64"
echo "  - ANDROID_KEYSTORE_PASSWORD"
echo "  - ANDROID_KEY_PASSWORD"
echo "  - ANDROID_KEY_ALIAS"
echo ""
read -p "Continuar? (s/N): " confirm

if [[ ! $confirm =~ ^[Ss]$ ]]; then
    echo "❌ Cancelado pelo usuário"
    exit 0
fi

echo ""
echo "📦 Configurando secrets..."
echo ""

# iOS Secrets
echo "🍎 Configurando secrets do iOS..."

# 1. IOS_P12_CERTIFICATE_BASE64
echo "   [1/5] IOS_P12_CERTIFICATE_BASE64..."
gh secret set IOS_P12_CERTIFICATE_BASE64 < /tmp/zeca-p12-base64.txt
echo "      ✅ Configurado"

# 2. IOS_P12_PASSWORD
echo "   [2/5] IOS_P12_PASSWORD..."
echo -n "Joao@08012011" | gh secret set IOS_P12_PASSWORD
echo "      ✅ Configurado"

# 3. APPSTORE_ISSUER_ID
echo "   [3/5] APPSTORE_ISSUER_ID..."
echo -n "6d176eea-5c4e-4448-9eaf-706d9f100e81" | gh secret set APPSTORE_ISSUER_ID
echo "      ✅ Configurado"

# 4. APPSTORE_API_KEY_ID
echo "   [4/5] APPSTORE_API_KEY_ID..."
echo -n "ZX75XKMJ33" | gh secret set APPSTORE_API_KEY_ID
echo "      ✅ Configurado"

# 5. APPSTORE_API_PRIVATE_KEY
echo "   [5/5] APPSTORE_API_PRIVATE_KEY..."
gh secret set APPSTORE_API_PRIVATE_KEY < /tmp/zeca-p8-content.txt
echo "      ✅ Configurado"

echo ""

# Android Secrets
echo "🤖 Configurando secrets do Android..."

# 1. ANDROID_KEYSTORE_BASE64
echo "   [1/4] ANDROID_KEYSTORE_BASE64..."
gh secret set ANDROID_KEYSTORE_BASE64 < /tmp/zeca-keystore-base64.txt
echo "      ✅ Configurado"

# 2. ANDROID_KEYSTORE_PASSWORD
echo "   [2/4] ANDROID_KEYSTORE_PASSWORD..."
echo -n "Joao@08012011" | gh secret set ANDROID_KEYSTORE_PASSWORD
echo "      ✅ Configurado"

# 3. ANDROID_KEY_PASSWORD
echo "   [3/4] ANDROID_KEY_PASSWORD..."
echo -n "Joao@08012011" | gh secret set ANDROID_KEY_PASSWORD
echo "      ✅ Configurado"

# 4. ANDROID_KEY_ALIAS
echo "   [4/4] ANDROID_KEY_ALIAS..."
echo -n "zeca-key" | gh secret set ANDROID_KEY_ALIAS
echo "      ✅ Configurado"

echo ""
echo "================================================"
echo "✅ Todos os secrets foram configurados!"
echo "================================================"
echo ""
echo "📋 Secrets configurados:"
echo ""
echo "iOS (5):"
echo "  ✅ IOS_P12_CERTIFICATE_BASE64"
echo "  ✅ IOS_P12_PASSWORD"
echo "  ✅ APPSTORE_ISSUER_ID"
echo "  ✅ APPSTORE_API_KEY_ID"
echo "  ✅ APPSTORE_API_PRIVATE_KEY"
echo ""
echo "Android (4):"
echo "  ✅ ANDROID_KEYSTORE_BASE64"
echo "  ✅ ANDROID_KEYSTORE_PASSWORD"
echo "  ✅ ANDROID_KEY_PASSWORD"
echo "  ✅ ANDROID_KEY_ALIAS"
echo ""
echo "⚠️  Pendente:"
echo "  ⏳ GOOGLE_PLAY_SERVICE_ACCOUNT_JSON (adicionar depois)"
echo ""
echo "🎯 Próximos passos:"
echo "1. Verificar no GitHub: Settings → Secrets → Actions"
echo "2. Criar Service Account do Google Play"
echo "3. Adicionar o último secret: GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"
echo "4. Testar o deploy!"
echo ""

