# 🔐 Configuração de API Keys - ZECA App

> **IMPORTANTE**: Nunca commitar API keys no repositório!

---

## 📱 Android

### Configurar API Key

Adicione ao arquivo `android/local.properties`:

```properties
# Google Maps API Key (NÃO COMMITAR)
GOOGLE_MAPS_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXX
```

O `local.properties` já está no `.gitignore`.

### Como funciona

1. `local.properties` contém a key
2. `build.gradle` lê e injeta via `manifestPlaceholders`
3. `AndroidManifest.xml` usa `${GOOGLE_MAPS_API_KEY}`

---

## 🍎 iOS

### Configurar API Key

1. Abra o projeto no Xcode
2. Vá em **Runner > Build Settings**
3. Adicione uma variável customizada:
   - Nome: `GOOGLE_MAPS_API_KEY`
   - Valor: `AIzaSyXXXXXXXXXXXXXXXXXXXXXX`

Ou via CLI:

```bash
xcodebuild build -configuration Release \
  GOOGLE_MAPS_API_KEY="AIzaSyXXXXXXXXXXXXXXXXXXXXXX"
```

### Como funciona

1. Xcode Build Settings contém a key
2. `Info.plist` usa `$(GOOGLE_MAPS_API_KEY)`

---

## 🔑 Obtendo API Keys

1. Acesse [Google Cloud Console](https://console.cloud.google.com)
2. Projeto: `zeca-app` (ou seu projeto)
3. APIs & Services > Credentials
4. Copie a chave para uso local

---

## ⚠️ Segurança

- ✅ API keys em `local.properties` (Android)
- ✅ API keys em Build Settings (iOS)
- ❌ NUNCA hardcode no código
- ❌ NUNCA commitar no git
- ✅ Restringir keys no Google Cloud Console
