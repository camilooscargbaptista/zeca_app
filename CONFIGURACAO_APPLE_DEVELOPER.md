# Configuração Apple Developer - Push Notifications e App Store

## 📋 Pré-requisitos

- ✅ Conta Apple Developer aprovada
- ✅ App ID configurado
- ✅ Certificados e Provisioning Profiles

---

## 🔧 Passo 1: Configurar App ID no Apple Developer Portal

### 1.1 Acessar Apple Developer Portal
1. Acesse: https://developer.apple.com/account
2. Faça login com sua conta Apple Developer

### 1.2 Criar/Configurar App ID
1. Vá em **Certificates, Identifiers & Profiles**
2. Clique em **Identifiers**
3. Procure ou crie o App ID: `com.abasteca.zeca`
4. Clique no App ID para editar

### 1.3 Habilitar Push Notifications
1. Na seção **Capabilities**, marque **Push Notifications**
2. Clique em **Save**

### 1.4 Configurar APNs Key (Recomendado) ou Certificados
**Opção A: APNs Key (Recomendado - mais fácil)**
1. Vá em **Keys** no menu lateral
2. Clique no **+** para criar nova key
3. Nome: `Zeca App Push Notifications Key`
4. Marque **Apple Push Notifications service (APNs)**
5. Clique em **Continue** e depois **Register**
6. **IMPORTANTE:** Baixe o arquivo `.p8` - você só pode baixar uma vez!
7. Anote o **Key ID** e **Team ID**

**Opção B: Certificados APNs (Alternativa)**
1. Vá em **Certificates**
2. Crie certificado para **Apple Push Notification service SSL (Sandbox & Production)**
3. Selecione seu App ID
4. Baixe o certificado e instale no Keychain

---

## 🔧 Passo 2: Configurar Provisioning Profiles

### 2.1 Criar Provisioning Profile para Development
1. Vá em **Profiles**
2. Clique no **+** para criar novo profile
3. Selecione **iOS App Development**
4. Selecione seu App ID: `com.abasteca.zeca`
5. Selecione seus certificados
6. Selecione seus dispositivos de teste
7. Nome: `Zeca App Development`
8. Clique em **Generate** e baixe o profile

### 2.2 Criar Provisioning Profile para App Store
1. Vá em **Profiles**
2. Clique no **+** para criar novo profile
3. Selecione **App Store**
4. Selecione seu App ID: `com.abasteca.zeca`
5. Selecione seu certificado de distribuição
6. Nome: `Zeca App Store`
7. Clique em **Generate** e baixe o profile

### 2.3 Instalar Provisioning Profiles no Xcode
1. Abra o Xcode
2. Vá em **Xcode > Preferences > Accounts**
3. Selecione sua conta Apple Developer
4. Clique em **Download Manual Profiles**
5. Ou arraste os arquivos `.mobileprovision` para o Xcode

---

## 🔧 Passo 3: Configurar Firebase Console

### 3.1 Upload da APNs Key no Firebase
1. Acesse: https://console.firebase.google.com
2. Selecione o projeto: `abastecacomzeca`
3. Vá em **Project Settings > Cloud Messaging**
4. Na seção **Apple app configuration**, clique em **Upload**
5. Se usou **APNs Key**:
   - Faça upload do arquivo `.p8`
   - Informe o **Key ID**
   - Informe o **Team ID**
6. Se usou **Certificados**:
   - Faça upload do certificado `.p12`
   - Informe a senha do certificado

---

## 🔧 Passo 4: Configurar Xcode Project

### 4.1 Abrir Projeto no Xcode
```bash
cd ios
open Runner.xcworkspace
```

### 4.2 Configurar Signing & Capabilities
1. Selecione o target **Runner**
2. Vá na aba **Signing & Capabilities**
3. Selecione seu **Team** (Apple Developer)
4. Verifique se o **Bundle Identifier** está correto: `com.abasteca.zeca`
5. Clique em **+ Capability**
6. Adicione **Push Notifications**
7. Adicione **Background Modes** e marque **Remote notifications**

### 4.3 Configurar Build Configurations
1. Vá na aba **Build Settings**
2. Procure por **Code Signing Entitlements**
3. Configure para: `Runner/Runner.entitlements` (será criado no próximo passo)

---

## 🔧 Passo 5: Atualizar Código do App

### 5.1 Arquivos que serão atualizados:
- ✅ `ios/Runner/AppDelegate.swift` - Reativar push notifications
- ✅ `ios/Runner/Info.plist` - Reativar UIBackgroundModes
- ✅ `ios/Runner/Runner.entitlements` - Criar arquivo de entitlements
- ✅ `lib/core/services/firebase_service.dart` - Remover avisos de Personal Team

---

## 🔧 Passo 6: Testar Push Notifications

### 6.1 Build e Run no dispositivo físico
```bash
flutter run --release
```

### 6.2 Verificar logs
- Deve aparecer: `✅ APNS token recebido`
- Deve aparecer: `✅ Token FCM obtido`

### 6.3 Testar via Firebase Console
1. Acesse Firebase Console > Cloud Messaging
2. Clique em **Send test message**
3. Cole o FCM token do app
4. Envie uma notificação de teste

---

## 🔧 Passo 7: Preparar para App Store

### 7.1 Atualizar Version e Build Number
No arquivo `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

### 7.2 Criar Archive
1. Abra o Xcode
2. Selecione **Any iOS Device** como destino
3. Vá em **Product > Archive**
4. Aguarde o build completar

### 7.3 Upload para App Store Connect
1. No Organizer (Xcode), clique em **Distribute App**
2. Selecione **App Store Connect**
3. Siga o wizard de upload
4. Ou use: `flutter build ipa` e faça upload manual

---

## 📝 Checklist Final

- [ ] App ID criado com Push Notifications habilitado
- [ ] APNs Key ou Certificado configurado no Firebase
- [ ] Provisioning Profiles criados e instalados
- [ ] Xcode configurado com Team e Capabilities
- [ ] Código atualizado (AppDelegate, Info.plist, Entitlements)
- [ ] Push notifications testadas em dispositivo físico
- [ ] App buildado e testado
- [ ] Pronto para upload na App Store

---

## ⚠️ Troubleshooting

### Erro: "No valid 'aps-environment' entitlement"
- Verifique se `Runner.entitlements` está configurado corretamente
- Verifique se o Provisioning Profile inclui Push Notifications

### Erro: "APNS token has not been set yet"
- Certifique-se de que está testando em dispositivo físico (não simulador)
- Verifique se o Provisioning Profile está correto
- Verifique se Push Notifications está habilitado no App ID

### Erro: "Invalid credentials"
- Verifique se a APNs Key está correta no Firebase
- Verifique se o Team ID está correto

---

## 📚 Recursos Úteis

- [Apple Developer Portal](https://developer.apple.com/account)
- [Firebase Console](https://console.firebase.google.com)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Firebase Cloud Messaging iOS Setup](https://firebase.google.com/docs/cloud-messaging/ios/client)






