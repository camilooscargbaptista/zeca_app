# 🗺️ APIs do Google Maps Necessárias

## ✅ APIs Obrigatórias para o App Funcionar

### Para o Mapa Mostrar Ruas e Nomes:

1. **Maps SDK for Android** ⚠️ **ESSENCIAL**
   - Renderiza o mapa no Android
   - Mostra ruas, nomes, edifícios
   - Status: Deve estar **ENABLED** (habilitada)

2. **Maps SDK for iOS** ⚠️ **ESSENCIAL**
   - Renderiza o mapa no iOS
   - Mostra ruas, nomes, edifícios
   - Status: Deve estar **ENABLED** (habilitada)

### Para Funcionalidades de Navegação:

3. **Places API** ✅
   - Autocomplete de endereços
   - Busca de lugares
   - Status: Deve estar **ENABLED**

4. **Directions API** ✅
   - Cálculo de rotas
   - Tempo e distância
   - Status: Deve estar **ENABLED**

5. **Geocoding API** ✅
   - Conversão de coordenadas para endereços
   - Obter nome da rua atual
   - Status: Deve estar **ENABLED**

## 🔍 Como Verificar no Google Cloud Console

1. Acesse: https://console.cloud.google.com/apis/library
2. Selecione o projeto: `abastecacomzeca`
3. Procure por cada API acima
4. Verifique se o status é **"ENABLED"** (não "Disable")

## ⚠️ Problema Comum: Mapa Sem Ruas

Se o mapa não mostra ruas, verifique:

1. ✅ **Maps SDK for Android** está habilitada?
2. ✅ **Maps SDK for iOS** está habilitada?
3. ✅ API Key tem permissão para essas APIs?
4. ✅ API Key está configurada corretamente no app?

## 📝 APIs Opcionais (Futuro)

- **Maps 3D SDK** - Para mapas 3D (opcional)
- **Navigation SDK** - Para navegação avançada (opcional)
- **Route Optimization API** - Para otimização de rotas (opcional)
- **Weather API** - Para dados meteorológicos (opcional)

