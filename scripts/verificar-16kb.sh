#!/bin/bash

# Script para verificar alinhamento ELF de bibliotecas nativas (16 KB)
# Uso: ./scripts/verificar-16kb.sh [caminho_do_aab]

set -e

AAB_PATH="${1:-build/app/outputs/bundle/release/app-release.aab}"

if [ ! -f "$AAB_PATH" ]; then
    echo "❌ AAB não encontrado: $AAB_PATH"
    exit 1
fi

echo "🔍 Verificando alinhamento ELF de bibliotecas nativas..."
echo "📦 AAB: $AAB_PATH"
echo ""

# Criar diretório temporário
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Extrair AAB
echo "📂 Extraindo AAB..."
unzip -q "$AAB_PATH" -d "$TEMP_DIR"

# Encontrar todas as bibliotecas .so
echo ""
echo "📚 Bibliotecas nativas encontradas:"
echo ""

SO_FILES=$(find "$TEMP_DIR" -name "*.so" | sort)

if [ -z "$SO_FILES" ]; then
    echo "❌ Nenhuma biblioteca .so encontrada"
    exit 1
fi

INCOMPATIBLE_COUNT=0
COMPATIBLE_COUNT=0

for SO_FILE in $SO_FILES; do
    RELATIVE_PATH=${SO_FILE#$TEMP_DIR/}
    
    # Verificar alinhamento ELF usando readelf (se disponível)
    if command -v readelf &> /dev/null; then
        # Verificar se o arquivo é um ELF válido
        if file "$SO_FILE" | grep -q "ELF"; then
            # Verificar alinhamento de segmentos LOAD
            ALIGNMENT=$(readelf -l "$SO_FILE" 2>/dev/null | grep -E "^\s*LOAD" | awk '{print $NF}' | head -1)
            
            if [ -n "$ALIGNMENT" ]; then
                # Converter para decimal e verificar se é >= 16384 (16 KB)
                ALIGNMENT_DEC=$(echo "$ALIGNMENT" | sed 's/0x//' | tr '[:lower:]' '[:upper:]')
                ALIGNMENT_DEC=$(echo "ibase=16; $ALIGNMENT_DEC" | bc 2>/dev/null || echo "0")
                
                if [ "$ALIGNMENT_DEC" -ge 16384 ]; then
                    echo "✅ $RELATIVE_PATH (alinhamento: $ALIGNMENT = ${ALIGNMENT_DEC} bytes)"
                    ((COMPATIBLE_COUNT++))
                else
                    echo "❌ $RELATIVE_PATH (alinhamento: $ALIGNMENT = ${ALIGNMENT_DEC} bytes) - INCOMPATÍVEL"
                    ((INCOMPATIBLE_COUNT++))
                fi
            else
                echo "⚠️  $RELATIVE_PATH (não foi possível verificar alinhamento)"
            fi
        else
            echo "⚠️  $RELATIVE_PATH (não é um arquivo ELF válido)"
        fi
    else
        # Se readelf não estiver disponível, apenas listar
        echo "📄 $RELATIVE_PATH"
        echo "   ⚠️  readelf não disponível - instale binutils para verificar alinhamento"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESUMO:"
echo "   ✅ Compatíveis: $COMPATIBLE_COUNT"
echo "   ❌ Incompatíveis: $INCOMPATIBLE_COUNT"
echo ""

if [ "$INCOMPATIBLE_COUNT" -gt 0 ]; then
    echo "⚠️  ATENÇÃO: $INCOMPATIBLE_COUNT biblioteca(s) incompatível(is) encontrada(s)"
    echo ""
    echo "💡 SOLUÇÕES:"
    echo "   1. Atualize os plugins Flutter para versões mais recentes"
    echo "   2. Verifique se os plugins suportam 16 KB:"
    echo "      - flutter_background_geolocation"
    echo "      - google_mlkit_text_recognition"
    echo "      - google_maps_flutter"
    echo "   3. Entre em contato com os mantenedores dos plugins"
    echo "   4. Considere usar forks atualizados dos plugins"
    exit 1
else
    echo "✅ Todas as bibliotecas são compatíveis com 16 KB!"
    exit 0
fi

