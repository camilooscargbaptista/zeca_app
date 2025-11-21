# 🚀 Guia Rápido: Publicar no TestFlight

## ⚡ Passo a Passo Rápido

### 1️⃣ Verificar/Criar App no App Store Connect

1. Acesse: https://appstoreconnect.apple.com
2. Faça login com sua conta Apple Developer
3. Vá em **"Meus Apps"**
4. Se o app **não existe**:
   - Clique em **"+"** → **"Novo App"**
   - Preencha:
     - **Plataforma:** iOS
     - **Nome:** ZECA App
     - **Idioma Principal:** Português (Brasil)
     - **Bundle ID:** Selecione `com.abasteca.zeca`
     - **SKU:** `zeca-app-001` (ou outro identificador único)
   - Clique em **"Criar"**

### 2️⃣ Preparar o Build

**Opção A: Usar o Script Automatizado (Recomendado)**
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
./build_testflight.sh
```

**Opção B: Manual**
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# Limpar builds anteriores
flutter clean

# Build do IPA
flutter build ipa --release

# Abrir Xcode para fazer Archive
open ios/Runner.xcworkspace
```

### 3️⃣ Criar Archive no Xcode

1. No Xcode, selecione **"Any iOS Device"** como destino (não simulador)
2. Vá em **Product** → **Archive**
3. Aguarde o build completar (pode levar alguns minutos)
4. A janela **Organizer** abrirá automaticamente

### 4️⃣ Fazer Upload para App Store Connect

1. Na janela **Organizer**, selecione o archive criado
2. Clique em **"Distribute App"**
3. Escolha **"App Store Connect"** → **Next**
4. Escolha **"Upload"** → **Next**
5. Selecione **"Automatically manage signing"** → **Next**
6. Revise as informações → **Upload**
7. Aguarde o upload completar (pode levar alguns minutos)

### 5️⃣ Aguardar Processamento

1. Acesse: https://appstoreconnect.apple.com
2. Vá em **"Meus Apps"** → Selecione **"ZECA App"**
3. Clique na aba **"TestFlight"**
4. Aguarde o processamento (5-30 minutos, pode levar até 1h no primeiro build)
5. O status mudará de **"Processando"** para **"Pronto para Testar"**

### 6️⃣ Adicionar Testadores

**Testadores Internos (Imediato):**
1. Na aba **TestFlight**, vá em **"Testadores Internos"**
2. Clique em **"+"** para adicionar testadores
3. Selecione membros da equipe ou adicione emails
4. Selecione a build processada
5. Clique em **"Adicionar"**
6. Os testadores receberão um email com instruções

**Testadores Externos (Requer Revisão):**
1. Na aba **TestFlight**, vá em **"Testadores Externos"**
2. Crie um grupo (ex: "Beta Testers")
3. Adicione emails dos testadores
4. Selecione a build
5. **IMPORTANTE:** Preencha as informações obrigatórias:
   - Descrição do que testar
   - Screenshots (pelo menos 1)
   - Política de privacidade (URL)
6. Clique em **"Enviar para Revisão"**
7. Aguarde aprovação da Apple (até 48h)

## 📱 Instruções para Testadores

Os testadores receberão um email com:
1. Link para baixar o app **TestFlight** (se não tiver)
2. Convite para testar o app
3. Código de acesso (se necessário)

Após instalar o TestFlight:
1. Abra o app **TestFlight**
2. Aceite o convite
3. Toque em **"Instalar"** no app ZECA
4. O app será instalado e estará pronto para uso

## ⚠️ Checklist Antes de Publicar

- [ ] Versão atualizada no `pubspec.yaml` (ex: `1.0.1+2`)
- [ ] Build number incrementado (deve ser único e crescente)
- [ ] `aps-environment` configurado como `production` (já feito ✅)
- [ ] App criado no App Store Connect
- [ ] Certificados e provisioning profiles configurados no Xcode
- [ ] Build feito com sucesso
- [ ] Upload concluído sem erros

## 🔧 Comandos Úteis

```bash
# Ver versão atual
cat pubspec.yaml | grep version

# Incrementar build number manualmente
flutter build ipa --release --build-number=2

# Verificar certificados
security find-identity -v -p codesigning

# Limpar tudo e rebuild
flutter clean
cd ios && pod deintegrate && pod install && cd ..
flutter build ipa --release
```

## 📝 Notas Importantes

1. **Versão:** Sempre incremente o build number antes de cada upload
2. **Primeiro Build:** Pode demorar até 1h para processar
3. **Testadores Externos:** Requer revisão da Apple (até 48h)
4. **Testadores Internos:** Disponível imediatamente após processamento
5. **Expiração:** Builds expiram após 90 dias de inatividade

## 🐛 Troubleshooting

**Erro: "No valid 'aps-environment' entitlement"**
- ✅ Já corrigido: `aps-environment` está como `production`

**Erro: "Provisioning profile doesn't include Push Notifications"**
- Verifique no Apple Developer Portal se Push Notifications está habilitado no App ID
- Regenerar provisioning profile no Xcode

**Erro: "Invalid Bundle"**
- Verifique se o Bundle ID está correto: `com.abasteca.zeca`
- Verifique se o app existe no App Store Connect

**Upload falha:**
- Verifique conexão com internet
- Verifique credenciais do App Store Connect
- Tente novamente após alguns minutos

## 🎯 Próximos Passos Após TestFlight

1. Coletar feedback dos testadores
2. Corrigir bugs encontrados
3. Fazer novo build com correções
4. Repetir processo de upload
5. Quando estiver pronto, enviar para App Store

