# 📱 Como Acessar e Configurar o TestFlight

## 🚀 Passo 1: Acessar App Store Connect

1. Acesse: **https://appstoreconnect.apple.com**
2. Faça login com sua conta Apple Developer
3. Clique em **"Meus Apps"**
4. Selecione o app **"ZECA App"** (ou o nome que você deu)

## 📦 Passo 2: Aguardar Processamento

1. Clique na aba **"TestFlight"** no menu lateral
2. Você verá a build **1.0.0 (2)** na lista
3. O status será:
   - **"Processando"** (aguarde 5-30 minutos, pode levar até 1h no primeiro build)
   - **"Pronto para Testar"** (quando estiver processado)

## 👥 Passo 3: Adicionar Testadores

### Testadores Internos (Disponível Imediatamente)

1. Na aba **TestFlight**, vá em **"Testadores Internos"**
2. Clique em **"+"** ou **"Adicionar Testadores"**
3. Selecione membros da sua equipe Apple Developer
   - Ou adicione emails de pessoas que fazem parte da equipe
4. Selecione a build **1.0.0 (2)** que acabou de processar
5. Clique em **"Adicionar"**
6. Os testadores receberão um email automaticamente

### Testadores Externos (Requer Revisão da Apple)

1. Na aba **TestFlight**, vá em **"Testadores Externos"**
2. Clique em **"+"** para criar um novo grupo (ex: "Beta Testers")
3. Dê um nome ao grupo
4. Adicione emails dos testadores (máximo 10.000)
5. Selecione a build **1.0.0 (2)**
6. **IMPORTANTE:** Preencha as informações obrigatórias:
   - **Descrição do que testar:** O que os testadores devem focar
   - **Screenshots:** Pelo menos 1 screenshot do app (vários tamanhos)
   - **Política de Privacidade:** URL da política de privacidade
   - **Informações de Marketing:** Descrição do app
7. Clique em **"Enviar para Revisão"**
8. Aguarde aprovação da Apple (pode levar até 48h)

## 📧 O que os Testadores Recebem

Após adicionar testadores, eles receberão um email com:
- Link para baixar o app **TestFlight** (se não tiverem)
- Convite para testar o app ZECA
- Instruções de instalação

## 📱 Instruções para Testadores

1. **Instalar TestFlight:**
   - Baixar na App Store: https://apps.apple.com/app/testflight/id899247664

2. **Aceitar Convite:**
   - Abrir o email de convite
   - Tocar no link ou código de acesso
   - Ou abrir o app TestFlight e aceitar o convite

3. **Instalar o App:**
   - Abrir o app **TestFlight**
   - Encontrar **"ZECA App"** na lista
   - Tocar em **"Instalar"**
   - Aguardar instalação
   - O app aparecerá na tela inicial

## ⏱️ Timeline Esperado

- **Upload:** ✅ Já concluído
- **Processamento:** 5-30 minutos (até 1h no primeiro build)
- **Testadores Internos:** Disponível imediatamente após processamento
- **Testadores Externos:** 24-48h após enviar para revisão

## 🔍 Verificar Status do Processamento

1. Acesse App Store Connect
2. Vá em **"Meus Apps"** → **"ZECA App"** → **"TestFlight"**
3. Procure pela build **1.0.0 (2)**
4. O status aparecerá como:
   - ⏳ **"Processando"** - Aguarde
   - ✅ **"Pronto para Testar"** - Pode adicionar testadores
   - ❌ **"Falhou"** - Verifique os erros

## ⚠️ Problemas Comuns

**Build não aparece:**
- Aguarde alguns minutos e atualize a página
- Verifique se o upload foi concluído com sucesso

**Status "Falhou":**
- Clique na build para ver os detalhes do erro
- Verifique se há problemas com certificados ou provisioning profiles
- Faça um novo build e upload

**Testadores não recebem email:**
- Verifique se os emails estão corretos
- Verifique a pasta de spam
- Testadores internos recebem imediatamente
- Testadores externos só recebem após aprovação da Apple

## 📝 Próximos Passos

1. ✅ Upload concluído
2. ⏳ Aguardar processamento (5-30 min)
3. 👥 Adicionar testadores
4. 📧 Testadores recebem convite
5. 🎉 Começar testes!

