#!/bin/bash

# Script para limpar storage local e forçar tela de nova journey

DEVICE_ID="2E883348-A1B4-4E3C-9918-272DF8EC84DD"
BUNDLE_ID="com.zeca.app"

echo "🧹 Limpando storage local do app..."
echo ""

# Opção 1: Desinstalar app completamente (remove todo storage)
echo "1️⃣ Desinstalando app (remove storage)..."
xcrun simctl uninstall "$DEVICE_ID" "$BUNDLE_ID" 2>&1

echo "✅ App desinstalado"
echo ""
echo "📱 Agora rode o flutter run novamente:"
echo "   cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app"
echo "   export PATH=\"\$PATH:\$HOME/flutter/bin:\$HOME/development/flutter/bin\""
echo "   flutter run -d $DEVICE_ID --no-pub"
echo ""
echo "🎯 Após o app iniciar, você verá a tela de LOGIN ou tela INICIAL (sem journey ativa)"

