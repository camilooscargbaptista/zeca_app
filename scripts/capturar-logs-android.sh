#!/bin/bash

# Script para capturar logs do Android com foco em polling e validação

echo "📱 Capturando logs do Android..."
echo "   Por favor, teste o polling e o botão 'Validar Agora' no app"
echo "   Os logs serão salvos em /tmp/zeca_android_logs.txt"
echo ""

# Limpar logcat
adb -s emulator-5554 logcat -c

# Capturar logs do Flutter e salvar em arquivo
adb -s emulator-5554 logcat | grep -E "flutter|POLLING|VALIDATION|refueling|by-code|validate|pending|404|not found|dados|error|Erro|❌|⚠️" | tee /tmp/zeca_android_logs.txt

