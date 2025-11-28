#!/bin/bash

# Script para simular movimento GPS no iOS Simulator
# Rota: Ribeirão Preto - Centro até Vila Tibério

DEVICE_ID="2E883348-A1B4-4E3C-9918-272DF8EC84DD"

echo "🚗 Iniciando simulação de rota GPS..."
echo "📍 Rota: Ribeirão Preto (Centro → Vila Tibério)"
echo "⏱️  Duração: ~4 minutos"
echo ""

# Array de coordenadas (lat,lon)
coordinates=(
  "-21.170400,-47.810300"  # Início
  "-21.171000,-47.809500"  # Ponto 1
  "-21.171500,-47.808800"  # Ponto 2
  "-21.172000,-47.808200"  # Ponto 3
  "-21.172500,-47.807600"  # Ponto 4
  "-21.173000,-47.807000"  # Ponto 5
  "-21.173500,-47.806500"  # Ponto 6
  "-21.174000,-47.806000"  # Ponto 7
  "-21.174500,-47.805500"  # Ponto 8
  "-21.175000,-47.805000"  # Ponto 9
  "-21.175500,-47.804500"  # Ponto 10
  "-21.176000,-47.804000"  # Ponto 11
  "-21.176500,-47.803500"  # Ponto 12
  "-21.177000,-47.803000"  # Ponto 13
  "-21.177500,-47.802500"  # Ponto 14
  "-21.178000,-47.802000"  # Fim
)

# Percorrer cada ponto com delay de 15 segundos
for i in "${!coordinates[@]}"; do
  coord="${coordinates[$i]}"
  echo "📍 Ponto $((i+1))/${#coordinates[@]}: $coord"
  xcrun simctl location "$DEVICE_ID" "$coord"
  
  # Aguardar 15 segundos antes do próximo ponto (exceto no último)
  if [ $i -lt $((${#coordinates[@]}-1)) ]; then
    echo "⏳ Aguardando 15 segundos..."
    sleep 15
  fi
done

echo ""
echo "✅ Simulação de rota concluída!"
echo "📊 Total de pontos: ${#coordinates[@]}"
echo "⏱️  Tempo total: ~$((${#coordinates[@]}*15)) segundos"

