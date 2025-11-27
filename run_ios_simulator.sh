#!/bin/bash

echo "🚀 Iniciando build e execução no simulador iOS..."
echo ""

# Navegar até o diretório do projeto
cd "$(dirname "$0")"

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado no PATH"
    echo ""
    echo "Por favor, configure o Flutter ou execute este script em um terminal com Flutter configurado"
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -1)"
echo ""

# Atualizar dependências
echo "📦 Instalando dependências..."
flutter pub get

# Rodar code generation (para @injectable)
echo "🔧 Gerando código de injeção de dependências..."
flutter pub run build_runner build --delete-conflicting-outputs

# Listar dispositivos disponíveis
echo ""
echo "📱 Dispositivos disponíveis:"
flutter devices
echo ""

# Abrir simulador iOS
echo "📱 Abrindo simulador iOS..."
open -a Simulator

# Aguardar simulador iniciar
echo "⏳ Aguardando simulador iniciar..."
sleep 5

# Rodar app no simulador
echo "🚀 Executando app no simulador..."
echo ""
echo "================================================"
echo "   ZECA App - UH-003 Navegação em Tempo Real"
echo "   Branch: feature/UH-003-navegacao-tempo-real"
echo "================================================"
echo ""

flutter run -d iPhone

echo ""
echo "✅ App em execução! Use 'r' para hot reload, 'q' para sair"

