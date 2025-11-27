#!/bin/bash

# Script para iniciar emulador Android e rodar o app ZECA
# Autor: AI Assistant
# Data: 2025-11-27

set -e  # Parar se houver erro

echo "🤖 =========================================="
echo "🤖 ZECA APP - Android Emulator"
echo "🤖 =========================================="
echo ""

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado no PATH!"
    echo ""
    echo "Por favor, adicione Flutter ao PATH ou execute:"
    echo "export PATH=\"\$PATH:\$HOME/flutter/bin\""
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -1)"
echo ""

# Passo 1: Listar emuladores disponíveis
echo "📱 Listando emuladores Android disponíveis..."
flutter emulators
echo ""

# Passo 2: Perguntar qual emulador usar (ou usar o primeiro)
echo "🚀 Iniciando emulador Android..."
echo "   (Se houver múltiplos, o primeiro será usado)"
echo ""

# Obter lista de emuladores
EMULATORS=$(flutter emulators | grep "•" | awk '{print $2}')
FIRST_EMULATOR=$(echo "$EMULATORS" | head -1)

if [ -z "$FIRST_EMULATOR" ]; then
    echo "❌ Nenhum emulador Android encontrado!"
    echo ""
    echo "Crie um usando Android Studio:"
    echo "Tools → Device Manager → Create Device"
    exit 1
fi

echo "📱 Usando emulador: $FIRST_EMULATOR"

# Passo 3: Iniciar emulador
flutter emulators --launch "$FIRST_EMULATOR" &
EMULATOR_PID=$!

echo "⏳ Aguardando emulador inicializar (30s)..."
sleep 30

# Passo 4: Verificar se emulador está online
echo ""
echo "🔍 Verificando devices disponíveis..."
flutter devices

# Passo 5: Configurar localização (Ribeirão Preto)
echo ""
echo "📍 Configurando localização: Ribeirão Preto (-21.1704, -47.8103)..."

# Encontrar o emulator device ID
ANDROID_DEVICE_ID=$(flutter devices | grep "emulator" | awk '{print $5}' | tr -d '•' | head -1)

if [ ! -z "$ANDROID_DEVICE_ID" ]; then
    echo "   Device ID: $ANDROID_DEVICE_ID"
    
    # Configurar localização via adb
    if command -v adb &> /dev/null; then
        echo "   Usando adb para configurar GPS..."
        adb -s "$ANDROID_DEVICE_ID" emu geo fix -47.8103 -21.1704
        echo "   ✅ Localização configurada!"
    else
        echo "   ⚠️  adb não encontrado, localização não configurada"
    fi
else
    echo "   ⚠️  Não foi possível encontrar device ID automaticamente"
fi

# Passo 6: Rodar app
echo ""
echo "🚀 Iniciando build e instalação do app..."
echo "   (Isso pode levar 2-3 minutos na primeira vez)"
echo ""

flutter run --no-pub

# Cleanup
echo ""
echo "✅ App rodando no Android!"
echo ""
echo "Comandos úteis:"
echo "  r  - Hot reload"
echo "  R  - Hot restart"
echo "  q  - Quit"

