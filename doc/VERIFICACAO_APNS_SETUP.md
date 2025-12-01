# Verificação de Setup APNS - Push Notifications

## 🔍 Checklist de Verificação

### 1. ✅ AppDelegate.swift
- [x] Importa `FirebaseMessaging` e `UserNotifications`
- [x] Configura `Messaging.messaging().delegate = self`
- [x] Configura `UNUserNotificationCenter.current().delegate = self`
- [x] Chama `application.registerForRemoteNotifications()`
- [x] Implementa `didRegisterForRemoteNotificationsWithDeviceToken`
- [x] Configura `Messaging.messaging().apnsToken = deviceToken`

### 2. ✅ Runner.entitlements
- [x] Arquivo existe em `ios/Runner/Runner.entitlements`
- [x] Contém `aps-environment` com valor `production` ou `development`
- [ ] **VERIFICAR:** Arquivo está adicionado ao projeto Xcode
- [ ] **VERIFICAR:** Code Signing Entitlements aponta para `Runner/Runner.entitlements`

### 3. ✅ Info.plist
- [x] `UIBackgroundModes` com `remote-notification`
- [x] `FirebaseAppDelegateProxyEnabled` = `false`

### 4. ⚠️ Xcode Project (VERIFICAR MANUALMENTE)

#### 4.1 Adicionar Runner.entitlements ao Projeto
1. Abrir `ios/Runner.xcworkspace` no Xcode
2. No Project Navigator, clicar com botão direito em `Runner`
3. Selecionar "Add Files to Runner..."
4. Navegar até `ios/Runner/Runner.entitlements`
5. Marcar "Copy items if needed" e "Add to targets: Runner"
6. Clicar "Add"

#### 4.2 Configurar Code Signing Entitlements
1. Selecionar projeto "Runner" no Project Navigator
2. Selecionar target "Runner"
3. Aba "Build Settings"
4. Buscar por "Code Signing Entitlements"
5. Configurar para: `Runner/Runner.entitlements` (nas 3 configurações: Debug, Release, Profile)

#### 4.3 Verificar Signing & Capabilities
1. Selecionar target "Runner"
2. Aba "Signing & Capabilities"
3. Verificar se "Push Notifications" está listado
4. Verificar se "Background Modes" está listado com "Remote notifications" marcado
5. Se não estiverem, clicar "+ Capability" e adicionar

### 5. ⚠️ Apple Developer Portal (VERIFICAR)

#### 5.1 App ID
- [ ] App ID `com.abasteca.zeca` criado
- [ ] Push Notifications capability habilitada
- [ ] Status: "Enabled" ou "Configurable"

#### 5.2 Provisioning Profile
- [ ] Provisioning Profile criado para Development
- [ ] Provisioning Profile criado para App Store/Distribution
- [ ] Ambos incluem Push Notifications capability
- [ ] Profiles instalados no Xcode (Xcode > Preferences > Accounts > Download Manual Profiles)

#### 5.3 Certificados
- [ ] Certificado de Desenvolvimento válido
- [ ] Certificado de Distribuição válido (se for publicar)
- [ ] Certificados instalados no Keychain

### 6. ⚠️ Firebase Console (VERIFICAR)

#### 6.1 APNs Configuration
- [ ] APNs Key ou Certificado configurado
- [ ] Key ID e Team ID corretos
- [ ] Status: "Active" ou "Valid"

---

## 🐛 Troubleshooting

### Problema: APNS token não está sendo configurado

#### Verificação 1: Logs do AppDelegate
Verifique nos logs do Xcode se aparecem:
- `✅ APNS token recebido: ...`
- `✅ APNS token configurado no Firebase Messaging`

**Se NÃO aparecer:**
- Provisioning Profile não tem Push Notifications
- Entitlements não está configurado no Xcode
- Certificado não suporta Push Notifications

#### Verificação 2: Xcode Build Settings
```bash
# Abrir projeto no Xcode
open ios/Runner.xcworkspace

# Verificar:
# 1. Target Runner > Build Settings > Code Signing Entitlements
#    Deve ser: Runner/Runner.entitlements
# 2. Target Runner > Signing & Capabilities
#    Deve ter: Push Notifications e Background Modes
```

#### Verificação 3: Provisioning Profile
1. Xcode > Preferences > Accounts
2. Selecionar sua conta
3. Clicar em "Download Manual Profiles"
4. Verificar se o profile tem Push Notifications

#### Verificação 4: Testar no Dispositivo Físico
- **Simulador NÃO suporta Push Notifications**
- Deve testar em dispositivo físico iOS
- Dispositivo deve estar conectado e confiável

---

## 🔧 Comandos Úteis

### Verificar Entitlements do App
```bash
# Após build, verificar entitlements do app
codesign -d --entitlements - ios/build/ios/iphoneos/Runner.app
```

### Verificar Provisioning Profile
```bash
# Listar provisioning profiles
ls ~/Library/MobileDevice/Provisioning\ Profiles/
```

### Limpar e Rebuild
```bash
# Limpar build
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter pub get

# Rebuild
flutter build ios --release
```

---

## 📝 Próximos Passos

1. **Verificar no Xcode:**
   - [ ] Runner.entitlements adicionado ao projeto
   - [ ] Code Signing Entitlements configurado
   - [ ] Signing & Capabilities com Push Notifications

2. **Verificar Provisioning Profile:**
   - [ ] Download manual profiles no Xcode
   - [ ] Profile tem Push Notifications habilitado

3. **Testar em Dispositivo Físico:**
   - [ ] Conectar iPhone/iPad
   - [ ] Selecionar dispositivo no Xcode
   - [ ] Build e Run
   - [ ] Verificar logs do AppDelegate

4. **Verificar Logs:**
   - [ ] `✅ APNS token recebido` deve aparecer
   - [ ] `✅ FCM token obtido` deve aparecer

---

## ⚠️ Erros Comuns

### Erro: "APNS token has not been set yet"
**Causa:** AppDelegate não está configurando o token ou entitlements não está correto
**Solução:** Verificar checklist acima

### Erro: "No valid 'aps-environment' entitlement"
**Causa:** Entitlements não está no projeto ou Code Signing Entitlements não está configurado
**Solução:** Adicionar entitlements ao projeto e configurar Build Settings

### Erro: "Provisioning profile doesn't support Push Notifications"
**Causa:** Provisioning Profile não tem Push Notifications capability
**Solução:** Criar novo profile com Push Notifications no Apple Developer Portal

---

## 🎯 Teste Rápido

1. Abrir projeto no Xcode: `open ios/Runner.xcworkspace`
2. Selecionar dispositivo físico iOS
3. Build e Run (Cmd + R)
4. Verificar logs do console:
   - Deve aparecer: `✅ APNS token recebido`
   - Deve aparecer: `✅ FCM token obtido`

Se aparecer, está funcionando! 🎉

