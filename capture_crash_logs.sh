#!/bin/bash

# Script para capturar logs de crash do app Android

echo "🔍 Capturando logs do Android..."
echo ""

# Limpar logs anteriores
echo "1. Limpando logs anteriores..."
adb logcat -c

echo ""
echo "2. Iniciando captura de logs..."
echo "   O app será iniciado automaticamente..."
echo "   Pressione Ctrl+C para parar após ver o crash"
echo ""

# Iniciar o app
adb shell am start -n com.zeca.app/com.zeca.app.MainActivity

# Aguardar um pouco
sleep 2

# Capturar logs relevantes
adb logcat | grep -E "flutter|zeca|FATAL|AndroidRuntime|crash|exception|error|Error|E/|W/|I/flutter" --color=always

