#!/bin/bash

echo "🔍 Verificando alinhamento 16KB do ZECA..."
echo ""

# Criar diretório temporário
rm -rf /tmp/aab_check
mkdir -p /tmp/aab_check

# Extrair o AAB
echo "📦 Extraindo AAB..."
unzip -q -o build/app/outputs/bundle/release/app-release.aab -d /tmp/aab_check

# Detectar llvm-objdump
if command -v /opt/homebrew/opt/llvm/bin/llvm-objdump &> /dev/null; then
    OBJDUMP="/opt/homebrew/opt/llvm/bin/llvm-objdump"
elif command -v llvm-objdump &> /dev/null; then
    OBJDUMP="llvm-objdump"
else
    echo "❌ llvm-objdump não encontrado. Instale com: brew install llvm"
    exit 1
fi

echo "🔧 Usando: $OBJDUMP"
echo ""
echo "=========================================="
echo "Verificando bibliotecas arm64-v8a:"
echo "=========================================="

PROBLEMAS=0

for so in /tmp/aab_check/base/lib/arm64-v8a/*.so; do
    NOME=$(basename "$so")
    ALINHAMENTO=$($OBJDUMP -p "$so" 2>/dev/null | grep LOAD | head -1 | grep -oE "2\*\*[0-9]+")
    
    if echo "$ALINHAMENTO" | grep -q "2\*\*14"; then
        echo "✅ $NOME - OK (16KB)"
    elif echo "$ALINHAMENTO" | grep -q "2\*\*12"; then
        echo "❌ $NOME - PROBLEMA (4KB)"
        PROBLEMAS=$((PROBLEMAS + 1))
    else
        echo "⚠️  $NOME - Alinhamento: $ALINHAMENTO"
    fi
done

echo ""
echo "=========================================="
if [ $PROBLEMAS -eq 0 ]; then
    echo "✅ Todas as bibliotecas estão alinhadas a 16KB!"
else
    echo "❌ $PROBLEMAS biblioteca(s) com problema de alinhamento"
fi
echo "=========================================="

# Limpar
rm -rf /tmp/aab_check