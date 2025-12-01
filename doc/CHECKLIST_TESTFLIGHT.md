# ✅ Checklist TestFlight - ZECA App

## Status Atual ✅
- [x] API configurada para produção
- [x] Bundle ID: `com.abasteca.zeca`
- [x] Development Team: `GVU2F35AMK`
- [x] Versão: `1.0.0+1`
- [x] Projeto aberto no Xcode

## 🔧 Passos no Xcode (FAÇA AGORA)

### 1. Configurar Signing
- [ ] No Xcode, selecione o target **"Runner"** no navegador à esquerda
- [ ] Clique na aba **"Signing & Capabilities"**
- [ ] Marque **"Automatically manage signing"**
- [ ] No dropdown **"Team"**, selecione sua equipe (deve aparecer o Team ID: GVU2F35AMK)
- [ ] Verifique se o **Bundle Identifier** está como `com.abasteca.zeca`
- [ ] Se aparecer algum erro, clique em **"Try Again"** ou **"Download Profile"**

### 2. Selecionar Device para Build
- [ ] No topo do Xcode, clique no dropdown ao lado de "Runner"
- [ ] Selecione **"Any iOS Device"** (não selecione simulador)

### 3. Gerar Archive
- [ ] Vá em **Product** → **Archive**
- [ ] Aguarde o build completar (pode demorar alguns minutos)
- [ ] Quando terminar, a janela **"Organizer"** abrirá automaticamente

### 4. Fazer Upload para App Store Connect
- [ ] Na janela Organizer, selecione o archive criado
- [ ] Clique em **"Distribute App"**
- [ ] Escolha **"App Store Connect"** → **Next**
- [ ] Escolha **"Upload"** → **Next**
- [ ] Marque **"Include bitcode for iOS content"** (se aparecer)
- [ ] Selecione **"Automatically manage signing"** → **Next**
- [ ] Revise as opções → **Upload**
- [ ] Aguarde o upload completar

## 🌐 Passos no App Store Connect

### 1. Criar App (se não existe)
- [ ] Acesse: https://appstoreconnect.apple.com
- [ ] Login com sua conta Apple Developer
- [ ] Vá em **"Meus Apps"**
- [ ] Clique em **"+"** → **"Novo App"**
- [ ] Preencha:
  - **Plataforma:** iOS
  - **Nome:** ZECA App
  - **Idioma Principal:** Português (Brasil)
  - **Bundle ID:** Selecione `com.abasteca.zeca`
  - **SKU:** `zeca-app-001` (ou outro identificador único)

### 2. Aguardar Processamento
- [ ] Vá em **"TestFlight"** no menu lateral
- [ ] Aguarde o build aparecer (pode levar 5-30 minutos)
- [ ] Status mudará de **"Processando"** para **"Pronto para Testar"**

### 3. Configurar TestFlight
- [ ] Quando o build estiver pronto, clique nele
- [ ] Adicione informações do teste (opcional)
- [ ] Configure grupos de testadores:
  - **Testadores Internos:** Membros da equipe (recebem imediatamente)
  - **Testadores Externos:** Requer revisão da Apple (até 48h)

## 📝 Informações Necessárias para Testadores Externos

Se quiser adicionar testadores externos, você precisará:
- [ ] Screenshots do app (mínimo 1 por tamanho de tela)
- [ ] Descrição do que testar
- [ ] Informações de contato
- [ ] Política de privacidade (URL) - **OBRIGATÓRIO**

## ⚠️ Troubleshooting

### Erro: "No signing certificate found"
**Solução:** No Xcode, vá em Signing & Capabilities e clique em "Try Again"

### Erro: "Provisioning profile not found"
**Solução:** Marque e desmarque "Automatically manage signing"

### Build não aparece no App Store Connect
**Aguarde:** Pode levar até 1 hora para processar o primeiro build

### Erro de upload
**Verifique:** 
- Conexão com internet estável
- Você está logado com a conta correta no Xcode
- O app já foi criado no App Store Connect

## 🚀 Comandos Úteis

```bash
# Verificar certificados
security find-identity -v -p codesigning

# Limpar e rebuildar
flutter clean
flutter pub get
cd ios && pod install && cd ..

# Ver versão atual
grep "^version:" pubspec.yaml
```

---

**Próximo passo:** Configure o signing no Xcode agora! 🎯
















