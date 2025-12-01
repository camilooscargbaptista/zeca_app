# 🤖 Instruções para Rodar no Android

## ⚠️ Problema: Flutter não está no PATH do terminal atual

Para rodar no Android, você precisa **executar manualmente** em um terminal onde o Flutter está configurado.

---

## 🚀 Opção 1: Via Terminal Integrado do Cursor (Recomendado)

### **Passo 1: Abrir Terminal Integrado**
- No Cursor, pressione: **`Cmd+J`** (ou View → Terminal)
- Certifique-se de que está no diretório do projeto

### **Passo 2: Iniciar Emulador Android**
```bash
flutter emulators --launch Pixel_3a_API_34_extension_level_7_arm64-v8a
```

Aguarde 30-45 segundos para o emulador inicializar completamente.

### **Passo 3: Configurar Localização (Ribeirão Preto)**
```bash
# Obter o ID do emulador
adb devices

# Configurar localização (usando o ID do device, ex: emulator-5554)
adb -s emulator-5554 emu geo fix -47.8103 -21.1704
```

### **Passo 4: Rodar o App**
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
flutter run --no-pub
```

Quando perguntar qual device, selecione o **Android emulator**.

---

## 🚀 Opção 2: Via Script Automatizado

### **Passo 1: Abrir Terminal com Flutter**
Abra um terminal onde Flutter está configurado (ex: iTerm, Terminal.app)

### **Passo 2: Executar Script**
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
./run_android_emulator.sh
```

---

## 🚀 Opção 3: Via Android Studio (Mais Simples!)

### **Passo 1: Abrir Projeto**
1. Abra **Android Studio**
2. File → Open
3. Selecione pasta: `/Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app`

### **Passo 2: Iniciar Emulador**
1. Clique no ícone de device no topo
2. Selecione: **Pixel_3a_API_34_extension_level_7_arm64-v8a**
3. Aguarde inicializar

### **Passo 3: Configurar Localização**
1. Com emulador aberto, clique no **"..."** (Extended controls)
2. Vá em **Location**
3. Digite:
   - **Latitude:** `-21.1704`
   - **Longitude:** `-47.8103`
4. Clique **"Send"**

### **Passo 4: Rodar App**
1. No Android Studio, clique no botão **"Run"** (triângulo verde)
2. Ou execute: `flutter run` no terminal integrado

---

## 📱 Emuladores Disponíveis

Você tem 2 emuladores:
- **iOS:** `iPhone 15 Pro` (já em uso)
- **Android:** `Pixel_3a_API_34_extension_level_7_arm64-v8a`

---

## 🔍 Verificar se Emulador Está Rodando

```bash
flutter devices
```

Deve listar algo como:
```
Pixel 3a API 34 (mobile) • emulator-5554 • android-arm64 • Android 14 (API 34)
```

---

## 🗺️ Testar Google Maps no Android

### **API Key Android**

O app já tem a API Key configurada em:
```
android/app/src/main/AndroidManifest.xml
```

Verifique se contém:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyCTlAYLa9K04yfP65Qjg83vqoXhjee5Z2Q"/>
```

### **APIs Necessárias no Google Cloud**

Certifique-se de que **"Maps SDK for Android"** está habilitado no Google Cloud Console (mesma chave que usamos para iOS).

---

## ⚡ Atalho Rápido (Se Flutter está no PATH)

```bash
# Terminal único com todos comandos
flutter emulators --launch Pixel_3a_API_34_extension_level_7_arm64-v8a && \
sleep 40 && \
adb devices && \
adb -s emulator-5554 emu geo fix -47.8103 -21.1704 && \
flutter run --no-pub
```

---

## 🎯 O Que Testar no Android

Após o app rodar:
1. ✅ Mapa carrega com tiles (ruas, prédios)?
2. ✅ Pode criar viagem com destino?
3. ✅ Rota aparece em azul?
4. ✅ Navegação tempo real funciona?
5. ✅ Card de navegação mostra instruções?

**Se tudo OK → Android está funcionando!**  
**Se mapa cinza → Precisa adicionar "Maps SDK for Android" no Google Cloud (mesma solução do iOS)**

---

**Aguardo seu feedback! 🚀**

