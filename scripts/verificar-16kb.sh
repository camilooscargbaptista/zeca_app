#!/bin/bash

# Script para verificar alinhamento ELF de bibliotecas nativas (16 KB)
# Baseado no script Windows fornecido, adaptado para macOS/Linux
# Uso: ./scripts/verificar-16kb.sh [caminho_do_aab]

set -e

AAB_PATH="${1:-build/app/outputs/bundle/release/app-release.aab}"
OUTPUT_FILE="relatorio_alinhamento.txt"

# ------------------- CONFIGURAÇÃO NECESSÁRIA -------------------
# Tentar encontrar llvm-readelf no NDK instalado
# macOS/Linux: ~/Library/Android/sdk/ndk/<VERSION>/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-readelf
# Linux: ~/Android/Sdk/ndk/<VERSION>/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-readelf

NDK_VERSION="27.0.12077973"  # Ajuste se necessário

# Tentar diferentes caminhos possíveis
POSSIBLE_PATHS=(
    "$HOME/Library/Android/sdk/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-readelf"
    "$HOME/Library/Android/sdk/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/darwin-arm64/bin/llvm-readelf"
    "$HOME/Android/Sdk/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-readelf"
    "$ANDROID_HOME/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-readelf"
    "$ANDROID_HOME/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-readelf"
    "/usr/local/bin/llvm-readelf"
    "/usr/bin/llvm-readelf"
    "llvm-readelf"  # Se estiver no PATH
)

READELF=""
for path in "${POSSIBLE_PATHS[@]}"; do
    if command -v "$path" &> /dev/null || [ -f "$path" ]; then
        READELF="$path"
        break
    fi
done

# Se não encontrou llvm-readelf, tentar readelf padrão
if [ -z "$READELF" ]; then
    if command -v readelf &> /dev/null; then
        READELF="readelf"
    fi
fi

if [ -z "$READELF" ]; then
    echo "❌ Erro: llvm-readelf ou readelf não encontrado"
    echo ""
    echo "💡 Instale o Android NDK ou binutils:"
    echo "   macOS: brew install binutils"
    echo "   Linux: sudo apt-get install binutils"
    echo ""
    echo "   Ou ajuste o caminho do NDK no script"
    exit 1
fi

echo "✅ Usando: $READELF"
echo ""

# Verificar se o AAB existe
if [ ! -f "$AAB_PATH" ]; then
    echo "❌ AAB não encontrado: $AAB_PATH"
    exit 1
fi

echo "🔍 Verificando alinhamento ELF de bibliotecas nativas..."
echo "📦 AAB: $AAB_PATH"
echo "📄 Relatório será salvo em: $OUTPUT_FILE"
echo ""

# Criar diretório temporário
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Extrair AAB
echo "📂 Extraindo AAB..."
unzip -q "$AAB_PATH" -d "$TEMP_DIR"

# Definir caminho das bibliotecas (priorizar arm64-v8a, mas verificar todas)
LIB_PATHS=(
    "$TEMP_DIR/base/lib/arm64-v8a"
    "$TEMP_DIR/base/lib/armeabi-v7a"
    "$TEMP_DIR/base/lib/x86_64"
    "$TEMP_DIR/base/lib/x86"
)

# Inicializar contadores
INCOMPATIBLE_COUNT=0
COMPATIBLE_COUNT=0
TOTAL_COUNT=0

# Criar arquivo de relatório
{
    echo "============================================================="
    echo "RELATÓRIO DE ALINHAMENTO ELF - COMPATIBILIDADE 16 KB"
    echo "============================================================="
    echo "Data: $(date)"
    echo "AAB: $AAB_PATH"
    echo "Ferramenta: $READELF"
    echo ""
} > "$OUTPUT_FILE"

# Verificar cada caminho de biblioteca
for LIB_PATH in "${LIB_PATHS[@]}"; do
    if [ ! -d "$LIB_PATH" ]; then
        continue
    fi
    
    ABI=$(basename "$LIB_PATH")
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📚 Verificando bibliotecas em: $ABI"
    echo ""
    
    {
        echo ""
        echo "============================================================="
        echo "ABI: $ABI"
        echo "============================================================="
    } >> "$OUTPUT_FILE"
    
    # Encontrar todas as bibliotecas .so neste diretório
    SO_FILES=$(find "$LIB_PATH" -name "*.so" | sort)
    
    if [ -z "$SO_FILES" ]; then
        continue
    fi
    
    # Analisar cada biblioteca
    for SO_FILE in $SO_FILES; do
        FILENAME=$(basename "$SO_FILE")
        ((TOTAL_COUNT++))
        
        echo "🔍 Analisando: $FILENAME"
        
        {
            echo ""
            echo "============================================================="
            echo "Analisando: $FILENAME"
            echo "============================================================="
        } >> "$OUTPUT_FILE"
        
        # Verificar se é um arquivo ELF válido
        if ! file "$SO_FILE" | grep -q "ELF"; then
            echo "   ⚠️  Não é um arquivo ELF válido"
            {
                echo "AVISO: Não é um arquivo ELF válido"
            } >> "$OUTPUT_FILE"
            continue
        fi
        
        # Obter informações de alinhamento usando readelf
        if "$READELF" -l "$SO_FILE" > /tmp/readelf_output.txt 2>&1; then
            # Extrair linhas LOAD e adicionar ao relatório
            grep "LOAD" /tmp/readelf_output.txt >> "$OUTPUT_FILE"
            
            # Verificar alinhamento (última coluna da linha LOAD)
            ALIGNMENT=$(grep "LOAD" /tmp/readelf_output.txt | awk '{print $NF}' | head -1)
            
            if [ -n "$ALIGNMENT" ]; then
                # Converter hexadecimal para decimal
                if [[ "$ALIGNMENT" =~ ^0x ]]; then
                    ALIGNMENT_DEC=$(printf "%d" "$ALIGNMENT" 2>/dev/null || echo "0")
                else
                    ALIGNMENT_DEC=$(printf "%d" "0x$ALIGNMENT" 2>/dev/null || echo "0")
                fi
                
                # 16 KB = 16384 bytes
                if [ "$ALIGNMENT_DEC" -ge 16384 ]; then
                    echo "   ✅ Compatível (alinhamento: $ALIGNMENT = ${ALIGNMENT_DEC} bytes)"
                    ((COMPATIBLE_COUNT++))
                    {
                        echo "STATUS: ✅ COMPATÍVEL"
                        echo "Alinhamento: $ALIGNMENT ($ALIGNMENT_DEC bytes) >= 16384 bytes (16 KB)"
                    } >> "$OUTPUT_FILE"
                else
                    echo "   ❌ INCOMPATÍVEL (alinhamento: $ALIGNMENT = ${ALIGNMENT_DEC} bytes)"
                    ((INCOMPATIBLE_COUNT++))
                    {
                        echo "STATUS: ❌ INCOMPATÍVEL"
                        echo "Alinhamento: $ALIGNMENT ($ALIGNMENT_DEC bytes) < 16384 bytes (16 KB)"
                    } >> "$OUTPUT_FILE"
                fi
            else
                echo "   ⚠️  Não foi possível determinar alinhamento"
                {
                    echo "STATUS: ⚠️  INDETERMINADO"
                } >> "$OUTPUT_FILE"
            fi
        else
            echo "   ⚠️  Erro ao executar readelf"
            {
                echo "ERRO: Falha ao executar readelf"
                cat /tmp/readelf_output.txt
            } >> "$OUTPUT_FILE"
        fi
    done
done

# Resumo final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESUMO:"
echo "   📦 Total de bibliotecas: $TOTAL_COUNT"
echo "   ✅ Compatíveis: $COMPATIBLE_COUNT"
echo "   ❌ Incompatíveis: $INCOMPATIBLE_COUNT"
echo ""

{
    echo ""
    echo "============================================================="
    echo "RESUMO FINAL"
    echo "============================================================="
    echo "Total de bibliotecas analisadas: $TOTAL_COUNT"
    echo "Bibliotecas compatíveis (>= 16 KB): $COMPATIBLE_COUNT"
    echo "Bibliotecas incompatíveis (< 16 KB): $INCOMPATIBLE_COUNT"
    echo ""
} >> "$OUTPUT_FILE"

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
    echo ""
    echo "📄 Relatório completo salvo em: $OUTPUT_FILE"
    exit 1
else
    echo "✅ Todas as bibliotecas são compatíveis com 16 KB!"
    echo ""
    echo "📄 Relatório completo salvo em: $OUTPUT_FILE"
    exit 0
fi

