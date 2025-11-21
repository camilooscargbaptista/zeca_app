# 🚀 Script de Build Automatizado para TestFlight

## Uso Rápido

```bash
# Build completo com upload manual
./build_testflight.sh

# Apenas build (sem abrir Xcode para upload)
./build_testflight.sh --skip-upload

# Definir versão manualmente
./build_testflight.sh --version 1.0.1

# Definir build number manualmente
./build_testflight.sh --build-number 5

# Combinar opções
./build_testflight.sh --version 1.0.2 --build-number 10
```

## O que o Script Faz

1. ✅ **Verifica dependências** (Flutter, Xcode, CocoaPods)
2. ✅ **Verifica configuração da API** (deve estar em produção)
3. ✅ **Atualiza versão automaticamente** (incrementa build number)
4. ✅ **Limpa builds anteriores**
5. ✅ **Instala dependências** (Flutter e CocoaPods)
6. ✅ **Verifica certificados**
7. ✅ **Compila o app** (Flutter Release)
8. ✅ **Cria Archive** (.xcarchive)
9. ✅ **Abre Xcode Organizer** para upload manual

## Requisitos

- ✅ Flutter instalado
- ✅ Xcode instalado
- ✅ CocoaPods instalado
- ✅ Conta Apple Developer ativa
- ✅ Projeto configurado no Xcode (signing)

## Configuração Inicial (Uma Vez)

### 1. Configurar Signing no Xcode

```bash
open ios/Runner.xcworkspace
```

No Xcode:
- Target "Runner" → "Signing & Capabilities"
- Marque "Automatically manage signing"
- Selecione seu Team

### 2. Criar App no App Store Connect

1. Acesse: https://appstoreconnect.apple.com
2. Vá em "Meus Apps" → "+" → "Novo App"
3. Preencha:
   - Bundle ID: `com.abasteca.zeca`
   - Nome: ZECA App
   - Plataforma: iOS

## Upload Automático (Opcional)

Para automatizar o upload, você precisa criar uma API Key no App Store Connect:

1. App Store Connect → Users and Access → Keys
2. Crie uma nova key
3. Baixe o arquivo `.p8`
4. Configure no script ou use:

```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/archive/ZECA.xcarchive/Products/Applications/Runner.app \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_API_ISSUER
```

## Estrutura de Versões

O script usa o formato: `VERSION+BUILD_NUMBER`

- **Version:** Versão do app (ex: 1.0.1)
- **Build Number:** Número incremental (ex: 1, 2, 3...)

Exemplo: `1.0.1+5` significa versão 1.0.1, build 5

## Troubleshooting

### Erro: "No signing certificate"
```bash
# Verificar certificados
security find-identity -v -p codesigning

# Configurar no Xcode
open ios/Runner.xcworkspace
```

### Erro: "Provisioning profile not found"
No Xcode, marque e desmarque "Automatically manage signing"

### Erro: "Archive failed"
```bash
# Ver log detalhado
cat /tmp/xcode_archive.log

# Limpar e tentar novamente
flutter clean
./build_testflight.sh
```

### Build não aparece no App Store Connect
- Aguarde 5-30 minutos para processamento
- Verifique se o app foi criado no App Store Connect
- Verifique se o Bundle ID está correto

## Exemplos de Uso

### Build para TestFlight (normal)
```bash
./build_testflight.sh
```

### Build sem abrir Xcode
```bash
./build_testflight.sh --skip-upload
```

### Nova versão (major)
```bash
./build_testflight.sh --version 2.0.0 --build-number 1
```

### Hotfix (mesma versão, novo build)
```bash
./build_testflight.sh --build-number 10
```

## Fluxo Completo

1. Execute o script:
   ```bash
   ./build_testflight.sh
   ```

2. No Xcode Organizer (abre automaticamente):
   - Selecione o archive
   - "Distribute App" → "App Store Connect"
   - Siga o assistente

3. No App Store Connect:
   - Aguarde processamento (5-30 min)
   - Configure TestFlight
   - Adicione testadores

## Logs

O script salva logs em:
- `/tmp/xcode_archive.log` - Log do xcodebuild

Para ver logs detalhados do Flutter, remova `> /dev/null 2>&1` do script.













