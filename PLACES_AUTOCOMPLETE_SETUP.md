# 🗺️ Configuração: Autocomplete de Cidades e Cálculo de Rotas

## 📋 O que foi implementado

### 1. **Autocomplete de Cidades no Campo Destino**
- Campo de destino agora possui autocomplete inteligente
- Busca cidades/lugares enquanto o usuário digita
- Mostra sugestões em tempo real
- Restrito ao Brasil (`country:br`)
- Filtrado para cidades (`types: (cities)`)

### 2. **Cálculo Automático de Rota e KM**
- Ao selecionar um destino, o sistema:
  1. Obtém a localização GPS atual do dispositivo
  2. Calcula a rota até o destino selecionado
  3. Preenche automaticamente o campo "Previsão de KM"
  4. Mostra notificação com distância e tempo estimado

## 🔧 Arquivos Criados

### Serviços
- `lib/core/services/places_service.dart` - Busca de lugares (Google Places API)
- `lib/core/services/directions_service.dart` - Cálculo de rotas (Google Directions API)

### Widgets
- `lib/shared/widgets/places_autocomplete_field.dart` - Campo de texto com autocomplete

### Integração
- `lib/features/journey/presentation/pages/journey_page.dart` - Integrado o autocomplete e cálculo de rota

## ⚙️ Configuração Necessária

### 1. Habilitar APIs no Google Cloud Console

Acesse: https://console.cloud.google.com/

1. **Selecionar o projeto**: `abastecacomzeca`
2. **Habilitar as seguintes APIs**:
   - ✅ **Places API** (para autocomplete)
   - ✅ **Directions API** (para cálculo de rotas)
   - ✅ **Geocoding API** (opcional, mas recomendado)

**Como habilitar:**
- Vá em "APIs & Services" > "Library"
- Procure por "Places API" e clique em "Enable"
- Procure por "Directions API" e clique em "Enable"

### 2. Configurar API Key

⚠️ **IMPORTANTE**: A API key NÃO deve estar exposta no código.

**Configuração segura:**
1. Crie o arquivo `lib/core/config/api_keys.local.dart` (não commitado)
2. Ou configure a variável de ambiente `GOOGLE_MAPS_API_KEY`
3. Para Android/iOS, substitua `GOOGLE_MAPS_API_KEY_PLACEHOLDER` nos arquivos nativos

**Localização no código:**
- `lib/core/config/api_keys.dart` - Gerenciador de chaves
- `lib/core/services/places_service.dart` - Usa ApiKeys.googleMapsApiKey
- `lib/core/services/directions_service.dart` - Usa ApiKeys.googleMapsApiKey
- `android/app/src/main/AndroidManifest.xml` - Substituir placeholder
- `ios/Runner/Info.plist` - Substituir placeholder

**Recomendações de segurança:**

1. **Configurar restrições da API Key**:
   - Vá em "APIs & Services" > "Credentials"
   - Encontre sua chave de API
   - Clique em "Edit" e configure:
   
2. **Application restrictions**: 
   - Android: Adicionar package name `com.abasteca.zeca` e SHA-1
   - iOS: Adicionar bundle ID `com.abasteca.zeca`
   
3. **API restrictions**: 
   - Selecionar apenas: Places API, Directions API, Geocoding API

### 3. Configurar Billing (se necessário)

As APIs do Google Maps têm um **free tier generoso**:
- **Places API**: 1.000 requisições/dia grátis
- **Directions API**: 2.500 requisições/dia grátis

Se exceder, será necessário configurar billing no Google Cloud Console.

## 📱 Como Funciona

### Fluxo do Usuário:

1. **Usuário digita no campo "Destino"**
   - Após 300ms de pausa, busca lugares
   - Mostra lista de sugestões abaixo do campo

2. **Usuário seleciona um destino**
   - Campo é preenchido com o nome do lugar
   - Sistema obtém coordenadas do lugar
   - Solicita permissão de GPS (se necessário)

3. **Sistema calcula rota automaticamente**
   - Obtém localização GPS atual
   - Calcula rota até o destino
   - Preenche campo "Previsão de KM"
   - Mostra notificação: "Rota calculada: X km (Y min)"

### Tratamento de Erros:

- **GPS não disponível**: Mostra mensagem pedindo para verificar permissões
- **Rota não encontrada**: Permite digitar KM manualmente
- **Erro na API**: Mostra mensagem de erro, permite continuar manualmente

## 🧪 Testes

### Testar Autocomplete:
1. Abrir tela de iniciar viagem
2. Clicar no campo "Destino"
3. Digitar "São Paulo"
4. Verificar se aparecem sugestões

### Testar Cálculo de Rota:
1. Selecionar um destino do autocomplete
2. Verificar se aparece indicador de "Calculando rota..."
3. Verificar se o campo "Previsão de KM" é preenchido automaticamente
4. Verificar notificação com distância e tempo

## 📊 Monitoramento

### Verificar uso das APIs:
- Google Cloud Console > "APIs & Services" > "Dashboard"
- Verificar métricas de:
  - Places API (requests)
  - Directions API (requests)

### Logs no App:
- Buscar por `[Places]` e `[Directions]` nos logs do Flutter
- Verificar erros de API ou GPS

## 🔒 Segurança

⚠️ **IMPORTANTE**: A API key NÃO deve estar exposta no código.

**Solução implementada:**
1. ✅ Chave movida para `ApiKeys` (lê de variável de ambiente ou arquivo local)
2. ✅ Arquivos sensíveis adicionados ao `.gitignore`
3. ⚠️ **Ação necessária**: Substituir placeholders nos arquivos nativos antes de fazer build
4. **Recomendado**: Usar restrições de API Key no Google Cloud Console
5. **Para produção**: Considerar usar proxy backend para esconder a chave completamente

## 📝 Notas

- O autocomplete tem debounce de 300ms para evitar muitas requisições
- A busca é limitada ao Brasil (`country:br`)
- Apenas cidades são retornadas (`types: (cities)`)
- O cálculo de rota usa modo "driving" (carro)
- A distância é sempre em KM (sistema métrico)

