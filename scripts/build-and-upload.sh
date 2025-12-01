#!/bin/bash

# Script completo: Build + Preparação para Upload
# Faz tudo automaticamente

set -e

echo "🚀 Build e Upload Android - Processo Completo"
echo "=============================================="
echo ""

# Executar build
./scripts/build-android-release.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Preparar upload
./scripts/upload-play-store.sh

