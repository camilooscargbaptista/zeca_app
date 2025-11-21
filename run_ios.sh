#!/bin/bash

# Script para executar o app ZECA no simulador iOS
echo "🚀 Iniciando ZECA App no simulador iOS..."

# Verificar se o simulador está rodando
SIMULATOR_ID="2E883348-A1B4-4E3C-9918-272DF8EC84DD"
SIMULATOR_NAME="iPhone 15 Pro"

echo "📱 Verificando simulador $SIMULATOR_NAME..."

# Verificar se o simulador está bootado
if xcrun simctl list devices | grep -q "$SIMULATOR_ID.*Booted"; then
    echo "✅ Simulador $SIMULATOR_NAME está rodando"
else
    echo "🔄 Iniciando simulador $SIMULATOR_NAME..."
    xcrun simctl boot "$SIMULATOR_ID"
    sleep 5
fi

# Abrir o simulador
echo "📱 Abrindo simulador..."
open -a Simulator

# Aguardar o simulador carregar
sleep 3

# Executar o Flutter
echo "🚀 Executando Flutter app..."
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
flutter run -d "$SIMULATOR_ID" --target lib/main_simple.dart
