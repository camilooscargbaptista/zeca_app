# 📱 Guia: Build Android Manual para Play Store

## 🎯 Objetivo

Gerar APK/AAB assinado manualmente para upload na Google Play Store.

---

## 📋 Pré-requisitos

1. ✅ Keystore configurado: `android/app/zeca-release-key.jks`
2. ✅ Credenciais do keystore (senhas e alias)
3. ✅ Flutter instalado e configurado
4. ✅ Conta Google Play Developer ativa

---

## 🔧 Passo 1: Configurar Assinatura de Release

### 1.1 Criar arquivo `android/key.properties`

Crie o arquivo `android/key.properties` com as seguintes informações:

```properties
storePassword=SUA_SENHA_DO_KEYSTORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=zeca-key
storeFile=zeca-release-key.jks
```

**⚠️ IMPORTANTE:** Este arquivo contém informações sensíveis e NÃO deve ser commitado no Git (já está no `.gitignore`).

### 1.2 Atualizar `android/app/build.gradle`

O arquivo já deve ter a configuração de assinatura. Verifique se está assim:

```gradle
// Carregar propriedades do keystore
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... outras configurações ...
    
    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
        }
    }
}
```

---

## 🏗️ Passo 2: Verificar Versão

### 2.1 Verificar versão no `pubspec.yaml`

```yaml
version: 1.0.3+63
```

Onde:
- `1.0.3` = versionName (versão visível para usuários)
- `63` = versionCode (número interno, deve ser incrementado a cada release)

### 2.2 Incrementar versionCode (se necessário)

Se esta é uma nova versão, incremente o número após o `+`:

```yaml
version: 1.0.3+64  # Incrementar de 63 para 64
```

---

## 📦 Passo 3: Gerar AAB (App Bundle) - RECOMENDADO

A Google Play Store prefere AAB (Android App Bundle) ao invés de APK.

### 3.1 Limpar build anterior

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
flutter clean
```

### 3.2 Obter dependências

```bash
flutter pub get
```

### 3.3 Gerar AAB

```bash
flutter build appbundle --release
```

O arquivo será gerado em:
```
build/app/outputs/bundle/release/app-release.aab
```

---

## 📱 Passo 4: Gerar APK (Alternativa)

Se preferir gerar APK ao invés de AAB:

```bash
flutter build apk --release
```

O arquivo será gerado em:
```
build/app/outputs/flutter-apk/app-release.apk
```

**Nota:** A Google Play Store aceita APK, mas recomenda AAB.

---

## 📤 Passo 5: Upload na Google Play Store

### 5.1 Acessar Google Play Console

1. Acesse: https://play.google.com/console
2. Faça login com a conta do desenvolvedor
3. Selecione o app "ZECA"

### 5.2 Criar Nova Release

1. No menu lateral, vá em **"Produção"** ou **"Teste interno"** / **"Teste fechado"** / **"Teste aberto"**
2. Clique em **"Criar nova versão"** ou **"Criar release"**

### 5.3 Upload do AAB/APK

1. Na seção **"Artefatos do app"**, clique em **"Fazer upload"**
2. Selecione o arquivo:
   - `build/app/outputs/bundle/release/app-release.aab` (se gerou AAB)
   - `build/app/outputs/flutter-apk/app-release.apk` (se gerou APK)
3. Aguarde o upload e processamento

### 5.4 Preencher Informações da Release

1. **Nome da versão:** `1.0.3` (ou a versão que você definiu)
2. **Notas da versão:** Descreva as mudanças desta versão
   ```
   Exemplo:
   - Correção da tela branca no iOS
   - Ocultação das opções "Iniciar Viagem" e "Checklist"
   - Melhorias na estabilidade do app
   ```

### 5.5 Revisar e Publicar

1. Revise todas as informações
2. Clique em **"Revisar release"**
3. Se tudo estiver correto, clique em **"Iniciar rollout para Produção"** (ou o ambiente escolhido)

---

## ✅ Checklist Antes de Publicar

- [ ] Versão incrementada no `pubspec.yaml`
- [ ] `key.properties` configurado corretamente
- [ ] Build gerado com sucesso (AAB ou APK)
- [ ] AAB/APK assinado corretamente (não debug)
- [ ] Testado localmente antes do upload
- [ ] Notas da versão preenchidas
- [ ] Screenshots atualizados (se necessário)
- [ ] Políticas da Play Store atendidas

---

## 🐛 Troubleshooting

### Erro: "Keystore file not found"

**Solução:** Verifique se o arquivo `android/app/zeca-release-key.jks` existe e se o caminho em `key.properties` está correto.

### Erro: "Keystore was tampered with, or password was incorrect"

**Solução:** Verifique se as senhas em `key.properties` estão corretas.

### Erro: "Version code already used"

**Solução:** Incremente o `versionCode` no `pubspec.yaml` (número após o `+`).

### Erro: "App not signed"

**Solução:** Certifique-se de que o `build.gradle` está configurado para usar `signingConfigs.release` no buildType release.

---

## 📝 Comandos Rápidos

```bash
# Build completo (limpar + gerar AAB)
flutter clean && flutter pub get && flutter build appbundle --release

# Build APK
flutter clean && flutter pub get && flutter build apk --release

# Verificar assinatura do AAB
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

---

## 🔒 Segurança

- ⚠️ **NUNCA** commite o arquivo `android/key.properties` no Git
- ⚠️ **NUNCA** compartilhe as senhas do keystore
- ⚠️ Mantenha backup seguro do keystore (`zeca-release-key.jks`)
- ⚠️ Se perder o keystore, não poderá atualizar o app na Play Store

---

## 📚 Referências

- [Google Play Console](https://play.google.com/console)
- [Flutter - Build and release an Android app](https://docs.flutter.dev/deployment/android)
- [Android App Bundle](https://developer.android.com/guide/app-bundle)

---

**Última atualização:** 2025-01-27

