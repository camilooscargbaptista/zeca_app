#!/bin/bash

echo ""
echo "📱 ════════════════════════════════════════════════════════════════"
echo "   ZECA APP ELITE ENGINEERING SYSTEM v1.0"
echo "   Flutter • Clean Architecture • BLoC"
echo "════════════════════════════════════════════════════════════════ 📱"
echo ""

if [ ! -f ".agent/CHIEF-ARCHITECT.md" ]; then
    echo "❌ Execute do diretório raiz do projeto Flutter"
    exit 1
fi

echo "✅ Estrutura .agent/ encontrada"
echo ""

echo "🧠 BRAIN (Base de Conhecimento)"
echo "───────────────────────────────"
for file in .agent/brain/*.md; do
    [ -f "$file" ] && echo "   ✅ $(basename $file)"
done
echo ""

echo "👥 AGENTES"
echo "──────────"
for file in .agent/agents/*.md; do
    [ -f "$file" ] && echo "   ✅ $(basename $file .md)"
done
echo ""

echo "📋 CHECKLISTS"
echo "─────────────"
for file in .agent/checklists/*.md; do
    [ -f "$file" ] && echo "   ✅ $(basename $file)"
done
echo ""

echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📖 COMO USAR:"
echo ""
echo "   ANTES de qualquer código:"
echo ""
echo "   1. cat .agent/brain/LESSONS-LEARNED.md"
echo "   2. cat .agent/brain/CLEAN-ARCHITECTURE.md"
echo "   3. cat .agent/brain/FLUTTER-GUIDE.md"
echo "   4. Buscar feature similar (auth é referência)"
echo "   5. SÓ ENTÃO implementar"
echo ""
echo "   🚨 REGRA DE OURO:"
echo "   'Eu não sei nada. Eu consulto, aprendo, verifico, e só então executo.'"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "🔧 COMANDOS ÚTEIS:"
echo ""
echo "   # Gerar código Freezed/Retrofit"
echo "   dart run build_runner build --delete-conflicting-outputs"
echo ""
echo "   # Analisar código"
echo "   flutter analyze"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "✅ SISTEMA PRONTO!"
echo ""
