#!/bin/bash

# Script para debugar crash do app Android

echo "🔍 Capturando logs do Android..."
echo ""
echo "1. Limpando logs anteriores..."
adb logcat -c

echo ""
echo "2. Iniciando captura de logs..."
echo "   (Pressione Ctrl+C para parar após o crash)"
echo ""

# Capturar logs do Flutter e erros
adb logcat | grep -E "flutter|zeca|FATAL|AndroidRuntime|crash|exception|error|Error" --color=always

