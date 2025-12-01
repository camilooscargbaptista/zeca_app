# 📋 Relatório de Scripts Shell (.sh) - ZECA App

**Gerado em:** 30 de novembro de 2025  
**Total de scripts encontrados:** 14 scripts

---

## 📊 Resumo Executivo

O projeto ZECA App contém 14 scripts shell organizados em diferentes categorias funcionais:
- **Build & Deploy (iOS):** 6 scripts
- **Desenvolvimento & Debug:** 4 scripts
- **Testes & Simulação:** 3 scripts
- **Manutenção:** 1 script

---

## 🚀 Build & Deploy (iOS)

### 1. `build_testflight.sh`
**Localização:** Raiz do projeto  
**Função:** Script automatizado completo para build e upload para TestFlight  
**Características:**
- Incremento automático de versão (patch)
- Incremento automático de build number
- Suporte a argumentos (--skip-upload, --version, --build-number, --no-version-increment)
- Verificação de dependências (Flutter, Xcode, CocoaPods)
- Verificação de configuração da API (prod/dev)
- Build via `flutter build ipa` com fallback para `xcodebuild`
- Upload automático para App Store Connect via API
- Logs detalhados com cores
- Tratamento de erros robusto

### 2. `SCRIPT_TESTFLIGHT.sh`
**Localização:** Raiz do projeto  
**Função:** Script auxiliar para configuração do TestFlight  
**Características:**
- Verificação de versão no pubspec.yaml
- Verificação de configuração de API (prod/dev)
- Limpeza de builds anteriores
- Instalação de dependências
- Verificação de certificados de distribuição
- Instruções passo a passo para uso do Xcode

### 3. `setup_appstore_credentials.sh`
**Localização:** Raiz do projeto  
**Função:** Assistente interativo para configurar credenciais do App Store Connect  
**Características:**
- Interface interativa com cores
- Coleta de Key ID, Issuer ID e arquivo .p8
- Validação de arquivo .p8
- Sugestão para mover .p8 para diretório seguro
- Criação de arquivo `.env.appstore` com credenciais
- Atualização automática do `.gitignore`
- Testes de configuração

### 4. `INSTALAR_SEM_CABO_RAPIDO.sh`
**Localização:** Raiz do projeto  
**Função:** Script rápido para instalação no iPhone físico  
**Características:**
- Build release via Flutter
- Instruções para instalação via Xcode
- Permite desconectar cabo após instalação

### 5. `run_ios_simulator.sh`
**Localização:** Raiz do projeto  
**Função:** Script completo para iniciar build e execução no simulador iOS  
**Características:**
- Verificação de instalação do Flutter
- Atualização de dependências (`flutter pub get`)
- Geração de código (`build_runner`)
- Listagem de dispositivos disponíveis
- Abertura automática do Simulator
- Execução do app

### 6. `run_ios.sh`
**Localização:** Raiz do projeto  
**Função:** Script simplificado para executar app no simulador iOS específico  
**Características:**
- Device ID hardcoded (iPhone 15 Pro)
- Verificação e boot do simulador
- Execução usando `main_simple.dart`
- Abertura do Simulator.app

---

## 🐛 Desenvolvimento & Debug

### 7. `debug_android_crash.sh`
**Localização:** Raiz do projeto  
**Função:** Script para debugar crashes no Android  
**Características:**
- Limpeza de logs anteriores via adb
- Captura de logs filtrados por palavras-chave relevantes
- Filtros: flutter, zeca, FATAL, AndroidRuntime, crash, exception, error
- Output colorido

### 8. `capture_crash_logs.sh`
**Localização:** Raiz do projeto  
**Função:** Script para capturar logs completos de crash do Android  
**Características:**
- Limpeza de logs via `adb logcat -c`
- Início automático do app via `adb shell am start`
- Captura com filtros abrangentes
- Instruções para o usuário (Ctrl+C para parar)

### 9. `run_android_emulator.sh`
**Localização:** Raiz do projeto  
**Função:** Script para iniciar emulador Android e rodar o app  
**Características:**
- Verificação de instalação do Flutter
- Listagem de emuladores disponíveis
- Início automático do primeiro emulador
- Aguarda 30s para boot do emulador
- Configuração de GPS (Ribeirão Preto: -21.1704, -47.8103)
- Execução do app via `flutter run`

### 10. `CURL_PARA_BACKEND.sh`
**Localização:** Raiz do projeto  
**Função:** Script de teste para endpoint de location point  
**Características:**
- Documentação detalhada sobre problema do plugin flutter_background_geolocation
- Comparação entre formato enviado pelo plugin vs esperado pelo backend
- Teste via curl com formato correto
- Token JWT de exemplo
- Coordenadas de Ribeirão Preto
- Notas para o time de backend sobre soluções possíveis

---

## 🧪 Testes & Simulação

### 11. `simulate_gps_route.sh`
**Localização:** Raiz do projeto  
**Função:** Simular movimento GPS no iOS Simulator  
**Características:**
- Rota predefinida: Ribeirão Preto (Centro → Vila Tibério)
- 16 pontos de coordenadas
- Intervalo de 15 segundos entre pontos
- Duração total: ~4 minutos
- Uso de `xcrun simctl location` para definir GPS
- Device ID hardcoded

### 12. `limpar_journey_storage.sh`
**Localização:** Raiz do projeto  
**Função:** Limpar storage local e forçar tela de nova journey  
**Características:**
- Desinstalação completa do app via `xcrun simctl uninstall`
- Remove todo storage local
- Instruções para reinstalar com `flutter run`
- Device ID hardcoded (iPhone 15 Pro)

### 13. `ios/Flutter/flutter_export_environment.sh`
**Localização:** `ios/Flutter/`  
**Função:** Script gerado automaticamente pelo Flutter  
**Características:**
- Exporta variáveis de ambiente para build iOS
- Gerado automaticamente, não deve ser editado manualmente
- Contém paths do Flutter SDK, Dart SDK, etc.

---

## 🔧 Manutenção

### 14. `clean_pods.sh`
**Localização:** Raiz do projeto  
**Função:** Limpeza completa de CocoaPods e reinstalação  
**Características:**
- Remoção de Pods/ e Podfile.lock
- Limpeza de cache local (`~/Library/Caches/CocoaPods`)
- Atualização do repositório do CocoaPods
- Reinstalação do zero via `pod install`
- Tratamento de erros com sugestões de solução

---

## 📈 Análise por Categoria

### Device IDs Hardcoded
Os seguintes scripts contêm device IDs específicos que podem precisar ser atualizados:
- `simulate_gps_route.sh`: `2E883348-A1B4-4E3C-9918-272DF8EC84DD`
- `limpar_journey_storage.sh`: `2E883348-A1B4-4E3C-9918-272DF8EC84DD`
- `run_ios.sh`: `2E883348-A1B4-4E3C-9918-272DF8EC84DD`

### Coordenadas GPS
Scripts que usam coordenadas de Ribeirão Preto:
- `CURL_PARA_BACKEND.sh`: -21.1704, -47.8103
- `simulate_gps_route.sh`: Rota com 16 pontos na região
- `run_android_emulator.sh`: -21.1704, -47.8103

### Scripts com Cores e UX
Scripts com output colorido para melhor experiência:
- `build_testflight.sh`
- `setup_appstore_credentials.sh`
- `clean_pods.sh`
- `debug_android_crash.sh`
- `capture_crash_logs.sh`

---

## 💡 Recomendações

### 1. **Padronização de Device ID**
- Considerar criar variável de ambiente ou arquivo de config para device IDs
- Permitir override via argumento de linha de comando

### 2. **Consolidação de Scripts Android/iOS**
- `run_android_emulator.sh` e `run_ios_simulator.sh` poderiam ser unificados
- Criar um script `run_app.sh` que detecta plataforma e chama o apropriado

### 3. **Documentação**
- Criar README.md na raiz explicando cada script
- Adicionar examples de uso em comentários

### 4. **Segurança**
- Scripts que manipulam credenciais (setup_appstore_credentials.sh) estão bem implementados
- Verificar se `.env.appstore` está sempre no `.gitignore`

### 5. **Logs**
- Padronizar localização de logs (atualmente em `/tmp/`)
- Considerar criar diretório `logs/` no projeto

---

## 🎯 Scripts Mais Importantes

### Para Desenvolvedores:
1. `run_ios_simulator.sh` - Desenvolvimento diário iOS
2. `run_android_emulator.sh` - Desenvolvimento diário Android
3. `simulate_gps_route.sh` - Testes de tracking GPS

### Para Deploy:
1. `build_testflight.sh` - Build e upload automatizado
2. `setup_appstore_credentials.sh` - Configuração inicial

### Para Debug:
1. `debug_android_crash.sh` - Debug de crashes Android
2. `CURL_PARA_BACKEND.sh` - Teste de API de location

### Para Manutenção:
1. `clean_pods.sh` - Resolver problemas com CocoaPods
2. `limpar_journey_storage.sh` - Limpar storage para testes

---

## 📝 Notas Finais

- Todos os scripts estão bem documentados com comentários
- A maioria tem tratamento de erros adequado
- Scripts de build são robustos e production-ready
- Bom uso de cores e feedback visual
- Scripts interativos têm boa UX (setup_appstore_credentials.sh)

**Última atualização:** 30/11/2025

