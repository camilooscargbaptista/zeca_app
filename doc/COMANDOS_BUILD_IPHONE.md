# 📱 Comandos para Build no iPhone Físico

## ✅ Pré-requisitos

Antes de fazer o build, certifique-se de que:

1. **iPhone está conectado via cabo USB** ao MacBook
2. **iPhone está desbloqueado** (tela principal visível)
3. **Developer Mode está ativado** no iPhone:
   - Configurações → Privacidade e Segurança → Modo de Desenvolvedor → Ativar
   - Se não aparecer, conecte o iPhone e tente fazer o build uma vez, depois reinicie o iPhone
4. **Confiança no computador**: Quando conectar, o iPhone deve perguntar "Confiar neste computador?" → Clique em "Confiar"

---

## 🔍 1. Verificar Dispositivos Conectados

```bash
# Listar todos os dispositivos iOS (físicos e simuladores)
xcrun xctrace list devices

# Ou via Flutter
flutter devices

# Verificar apenas dispositivos físicos conectados
xcrun xctrace list devices | grep -E "iPhone.*\([0-9]+\.[0-9]+\)"
```

---

## 🚀 2. Build e Deploy no iPhone (Método Recomendado)

### Opção A: Usando Flutter diretamente

```bash
# Navegar para o diretório do projeto
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# Listar dispositivos e identificar o ID do seu iPhone
flutter devices

# Fazer build e rodar no iPhone (usando o ID do dispositivo)
flutter run -d <DEVICE_ID> --target lib/main_simple.dart

# Exemplo com ID específico:
flutter run -d "00008120-001C30102232201E" --target lib/main_simple.dart

# Ou usando o nome do dispositivo:
flutter run -d "iPhone camilo" --target lib/main_simple.dart
```

### Opção B: Build Release para instalação

```bash
# Build em modo release (mais rápido para testar)
flutter build ios --release

# Depois instalar via Xcode ou:
open ios/Runner.xcworkspace
# No Xcode: Product → Destination → Selecione seu iPhone → Product → Run
```

### Opção C: Via Xcode (Mais Controle)

```bash
# Abrir o projeto no Xcode
open ios/Runner.xcworkspace

# No Xcode:
# 1. Selecione seu iPhone no dropdown de dispositivos (topo da tela)
# 2. Product → Run (ou Cmd+R)
# 3. Aguarde o build e instalação
```

---

## 🔧 3. Comandos Úteis para Troubleshooting

### Verificar se o dispositivo está confiável

```bash
# Listar dispositivos confiáveis
idevice_id -l

# Se não tiver idevice_id instalado:
brew install libimobiledevice
```

### Limpar build anterior

```bash
# Limpar build do Flutter
flutter clean

# Limpar pods
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

### Verificar certificados e signing

```bash
# Ver certificados instalados
security find-identity -v -p codesigning

# Verificar configuração do projeto
cd ios
xcodebuild -showBuildSettings -workspace Runner.xcworkspace -scheme Runner | grep -E "DEVELOPMENT_TEAM|PRODUCT_BUNDLE_IDENTIFIER"
```

### Reinstalar dependências

```bash
# Atualizar dependências Flutter
flutter pub get

# Reinstalar pods iOS
cd ios
pod deintegrate
pod install
cd ..
```

---

## 📋 4. Sequência Completa de Comandos

```bash
# 1. Ir para o diretório do projeto
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# 2. Verificar dispositivos conectados
flutter devices

# 3. Limpar builds anteriores (opcional, se tiver problemas)
flutter clean

# 4. Obter dependências
flutter pub get

# 5. Instalar/atualizar pods iOS
cd ios
pod install
cd ..

# 6. Fazer build e rodar no iPhone
flutter run -d "iPhone camilo" --target lib/main_simple.dart

# OU para build release:
flutter build ios --release
# Depois abrir Xcode e instalar manualmente
open ios/Runner.xcworkspace
```

---

## ⚠️ Problemas Comuns e Soluções

### Erro: "Device was unable to connect"
- ✅ Certifique-se que o iPhone está **desbloqueado**
- ✅ Verifique se o **Developer Mode** está ativado
- ✅ Desconecte e reconecte o cabo USB
- ✅ Tente uma porta USB diferente

### Erro: "No devices found"
- ✅ Verifique se o iPhone aparece em: `xcrun xctrace list devices`
- ✅ Se aparecer, use o ID diretamente: `flutter run -d <ID>`

### Erro de Signing/Certificado
- ✅ Abra o Xcode: `open ios/Runner.xcworkspace`
- ✅ Vá em Runner → Signing & Capabilities
- ✅ Marque "Automatically manage signing"
- ✅ Selecione seu Team

### Erro: "Developer Mode required"
- ✅ No iPhone: Configurações → Privacidade e Segurança → Modo de Desenvolvedor
- ✅ Ative o modo e reinicie o iPhone

---

## 🎯 Comando Rápido (Copy & Paste)

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app && flutter devices && flutter run -d "iPhone camilo" --target lib/main_simple.dart
```

---

## 📝 Notas

- O primeiro build pode demorar **5-10 minutos**
- Builds subsequentes são mais rápidos (incremental)
- Use `--release` para builds de produção (mais otimizado)
- Use `--debug` (padrão) para desenvolvimento (hot reload funciona)











