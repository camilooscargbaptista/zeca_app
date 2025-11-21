# 🔔 Como Corrigir Erro de Notificações Push (Erro 3000)

O erro 3000 indica que o `aps-environment` não está sendo reconhecido. Isso geralmente acontece porque:

1. O arquivo `Runner.entitlements` não está sendo referenciado no projeto Xcode
2. O Provisioning Profile não tem Push Notifications habilitado
3. O `aps-environment` está como `production` quando deveria ser `development` para testes

## 🔧 Solução Passo a Passo

### Passo 1: Verificar se o Entitlements está no Projeto

1. Abra o Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. No **Project Navigator** (painel esquerdo), verifique se o arquivo `Runner.entitlements` aparece na pasta **Runner**

3. Se **NÃO aparecer**:
   - Clique com botão direito na pasta **Runner**
   - Selecione **"Add Files to Runner..."**
   - Navegue até `ios/Runner/Runner.entitlements`
   - Marque:
     - ✅ **Copy items if needed**
     - ✅ **Add to targets: Runner**
   - Clique em **Add**

### Passo 2: Configurar Code Signing Entitlements

1. No Xcode, selecione o projeto **Runner** no Project Navigator
2. Selecione o target **Runner**
3. Vá na aba **Build Settings**
4. Procure por **"Code Signing Entitlements"** (use a busca)
5. Configure para: `Runner/Runner.entitlements`
   - Deve estar configurado para **Debug**, **Release** e **Profile**

### Passo 3: Configurar Signing & Capabilities

1. Selecione o target **Runner**
2. Vá na aba **Signing & Capabilities**
3. Verifique se está configurado:
   - ✅ **Team**: Seu Apple Developer Team
   - ✅ **Bundle Identifier**: `com.abasteca.zeca`
   - ✅ **Automatically manage signing**: Marcado

4. Adicione as Capabilities:
   - Clique em **+ Capability**
   - Adicione **Push Notifications**
   - Clique em **+ Capability** novamente
   - Adicione **Background Modes**
   - Marque **Remote notifications**

### Passo 4: Verificar aps-environment

O arquivo `Runner.entitlements` já foi atualizado para usar `development` (apropriado para testes locais).

Para **produção/TestFlight**, você precisará mudar para `production` depois.

### Passo 5: Limpar e Rebuild

1. No Xcode: **Product** → **Clean Build Folder** (ou `Cmd + Shift + K`)
2. Feche o Xcode
3. No terminal:
   ```bash
   cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
   flutter clean
   flutter pub get
   flutter build ios --release
   ```
4. Abra o Xcode novamente e instale no dispositivo

## ⚠️ Importante: Provisioning Profile

O erro 3000 também pode ocorrer se o **Provisioning Profile** não tiver Push Notifications habilitado.

### Verificar no Apple Developer Portal:

1. Acesse: https://developer.apple.com/account
2. Vá em **Certificates, Identifiers & Profiles**
3. Selecione **Identifiers** → **App IDs**
4. Encontre `com.abasteca.zeca`
5. Verifique se **Push Notifications** está marcado
6. Se não estiver:
   - Clique em **Edit**
   - Marque **Push Notifications**
   - Salve
   - **IMPORTANTE**: Você precisará gerar um novo Provisioning Profile

### Gerar Novo Provisioning Profile:

1. No Apple Developer Portal, vá em **Profiles**
2. Selecione seu profile de desenvolvimento
3. Clique em **Edit**
4. Verifique se **Push Notifications** está selecionado
5. Salve e baixe o novo profile
6. No Xcode: **Preferences** → **Accounts** → Selecione sua conta → **Download Manual Profiles**

## 🧪 Testar

Após fazer as correções:

1. Rebuild o app
2. Instale no dispositivo
3. Verifique os logs - deve aparecer:
   - ✅ APNS token recebido
   - ✅ Token FCM obtido

## 📝 Notas

- **Development**: Use `development` para testes locais
- **Production**: Use `production` para TestFlight/App Store
- O Xcode pode criar/atualizar o `Runner.entitlements` automaticamente quando você adiciona capabilities
- Sempre limpe o build após mudanças nos entitlements

