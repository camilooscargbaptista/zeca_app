# Instruções para Configurar Entitlements no Xcode

## 📋 Passo a Passo

### 1. Abrir Projeto no Xcode
```bash
cd ios
open Runner.xcworkspace
```

### 2. Adicionar Runner.entitlements ao Projeto

1. No **Project Navigator** (painel esquerdo), clique com botão direito na pasta **Runner**
2. Selecione **Add Files to "Runner"...**
3. Navegue até `ios/Runner/Runner.entitlements`
4. Marque as opções:
   - ✅ **Copy items if needed** (se necessário)
   - ✅ **Add to targets: Runner**
5. Clique em **Add**

### 3. Configurar Code Signing Entitlements

1. Selecione o projeto **Runner** no Project Navigator
2. Selecione o target **Runner**
3. Vá na aba **Build Settings**
4. Procure por **Code Signing Entitlements**
5. Configure para: `Runner/Runner.entitlements` (nas 3 configurações: Debug, Release, Profile)

**OU** faça via interface:

1. Selecione o target **Runner**
2. Vá na aba **Signing & Capabilities**
3. Clique em **+ Capability**
4. Adicione **Push Notifications** (se ainda não estiver)
5. Adicione **Background Modes** e marque **Remote notifications**

O Xcode automaticamente criará/atualizará o arquivo `Runner.entitlements` com as configurações corretas.

### 4. Verificar Configurações

1. Abra o arquivo `Runner.entitlements` no Xcode
2. Deve conter:
   ```xml
   <key>aps-environment</key>
   <string>production</string>
   ```
   (ou `development` para desenvolvimento)

### 5. Configurar Signing

1. Na aba **Signing & Capabilities**
2. Selecione seu **Team** (Apple Developer)
3. Verifique se o **Bundle Identifier** está correto: `com.abasteca.zeca`
4. O Xcode deve automaticamente selecionar o Provisioning Profile correto

### 6. Build e Teste

1. Conecte um dispositivo físico iOS
2. Selecione o dispositivo como destino
3. Pressione **Cmd + R** para buildar e rodar
4. Verifique os logs no console do Xcode:
   - Deve aparecer: `✅ APNS token recebido`
   - Deve aparecer: `✅ Token FCM obtido`

---

## ⚠️ Notas Importantes

- **aps-environment**: Use `development` para desenvolvimento/testes e `production` para App Store
- O Xcode pode automaticamente alternar entre `development` e `production` baseado no tipo de build
- Certifique-se de que o Provisioning Profile inclui Push Notifications capability






