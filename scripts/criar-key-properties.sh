#!/bin/bash

# Script para criar arquivo key.properties para build Android

echo "🔐 Configuração de Assinatura Android - key.properties"
echo "=================================================="
echo ""

# Verificar se keystore existe
if [ ! -f "android/app/zeca-release-key.jks" ]; then
    echo "❌ Erro: Keystore não encontrado em android/app/zeca-release-key.jks"
    exit 1
fi

echo "✅ Keystore encontrado: android/app/zeca-release-key.jks"
echo ""

# Solicitar informações
read -sp "🔑 Senha do keystore (storePassword): " STORE_PASSWORD
echo ""
read -sp "🔑 Senha da chave (keyPassword): " KEY_PASSWORD
echo ""
read -p "📝 Alias da chave (keyAlias) [zeca-key]: " KEY_ALIAS
KEY_ALIAS=${KEY_ALIAS:-zeca-key}

# Criar arquivo key.properties
cat > android/key.properties << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=zeca-release-key.jks
EOF

echo ""
echo "✅ Arquivo android/key.properties criado com sucesso!"
echo ""
echo "⚠️  IMPORTANTE: Este arquivo contém informações sensíveis."
echo "   Ele já está no .gitignore e NÃO será commitado."
echo ""

