#!/bin/bash

# Script rápido para instalar app no iPhone sem precisar manter cabo conectado

echo "🚀 Iniciando build e instalação do app..."
echo ""

# 1. Build Release
echo "📦 Fazendo build Release..."
flutter build ios --release

if [ $? -ne 0 ]; then
    echo "❌ Erro no build. Verifique os erros acima."
    exit 1
fi

echo ""
echo "✅ Build concluído!"
echo ""
echo "📱 Próximos passos:"
echo "1. Abra o Xcode:"
echo "   open ios/Runner.xcworkspace"
echo ""
echo "2. No Xcode:"
echo "   - Conecte seu iPhone ao Mac"
echo "   - Selecione seu iPhone como destino (topo do Xcode)"
echo "   - Pressione Cmd + R para instalar"
echo ""
echo "3. Após instalar, você pode desconectar o cabo!"
echo "   O app continuará funcionando normalmente."
echo ""
