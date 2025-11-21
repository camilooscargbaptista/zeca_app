# 👥 Como Adicionar Testadores no TestFlight

## ✅ Status Atual
- Build **1.0.0 (2)** está **"Pronto para testar"**
- Status: **Concluído**
- Expira em: **90 dias**

## 🚀 Adicionar Testadores Internos (Imediato)

### Passo a Passo:

1. **No App Store Connect:**
   - Na aba **TestFlight**, no menu lateral esquerdo
   - Clique em **"TESTES INTERNOS"** (ou "Testadores Internos")
   - Você verá um botão **"+"** ou **"Adicionar Testadores"**

2. **Selecionar Testadores:**
   - **Opção A:** Selecionar membros da equipe Apple Developer
     - Clique nos checkboxes ao lado dos nomes
     - Máximo: Todos os membros da equipe
   
   - **Opção B:** Adicionar emails externos
     - Clique em **"Adicionar Email"**
     - Digite o email do testador
     - ⚠️ O email precisa estar associado a uma conta Apple ID

3. **Selecionar a Build:**
   - Marque a build **1.0.0 (2)**
   - Clique em **"Adicionar"** ou **"Enviar Convites"**

4. **Pronto!**
   - Os testadores receberão um email automaticamente
   - Eles podem instalar o app imediatamente

## 📧 O que os Testadores Recebem

### Email de Convite:
- Assunto: "Você foi convidado para testar [App Name]"
- Conteúdo:
  - Link para baixar o app **TestFlight** (se não tiverem)
  - Instruções de como instalar
  - Código de acesso (se necessário)

### Instruções para Testadores:

1. **Instalar TestFlight:**
   - Baixar na App Store: https://apps.apple.com/app/testflight/id899247664
   - Ou usar o link do email

2. **Aceitar Convite:**
   - Abrir o email de convite
   - Tocar no botão **"Iniciar Teste"** ou no link
   - Ou abrir o app **TestFlight** e aceitar o convite

3. **Instalar o App:**
   - Abrir o app **TestFlight**
   - Encontrar **"Abasteca com Zeca"** na lista
   - Tocar em **"Instalar"**
   - Aguardar instalação
   - O app aparecerá na tela inicial do iPhone

## 🌐 Adicionar Testadores Externos (Requer Revisão)

Se quiser adicionar pessoas que **não** fazem parte da equipe Apple Developer:

1. Na aba **TestFlight**, vá em **"Testadores Externos"**
2. Clique em **"+"** para criar um novo grupo
3. Dê um nome ao grupo (ex: "Beta Testers")
4. Adicione emails dos testadores
5. Selecione a build **1.0.0 (2)**
6. **Preencha informações obrigatórias:**
   - ✅ Descrição do que testar
   - ✅ Screenshots (pelo menos 1)
   - ✅ Política de privacidade (URL)
   - ✅ Informações de marketing
7. Clique em **"Enviar para Revisão"**
8. ⏳ Aguarde aprovação da Apple (24-48h)

## 📊 Monitorar Testes

No App Store Connect, você pode ver:
- **CONVITES:** Quantos convites foram enviados
- **INSTALAÇÕES:** Quantos testadores instalaram
- **SESSÕES:** Quantas vezes o app foi aberto
- **FALHAS:** Relatórios de crashes
- **FEEDBACK:** Comentários dos testadores

## ⚠️ Limites e Regras

### Testadores Internos:
- ✅ Disponível imediatamente
- ✅ Até 100 membros da equipe
- ✅ Não requer revisão da Apple
- ✅ Atualizações instantâneas

### Testadores Externos:
- ⏳ Requer revisão da Apple (24-48h)
- ✅ Até 10.000 testadores
- ⚠️ Requer informações completas do app
- ⚠️ Builds expiram após 90 dias

## 🔄 Atualizar Build

Quando fizer uma nova versão:

1. Faça novo build e upload
2. Aguarde processamento
3. A nova build aparecerá na lista
4. Testadores receberão notificação de atualização
5. Eles podem atualizar pelo TestFlight

## 💡 Dicas

- **Testadores Internos:** Use para testes rápidos com a equipe
- **Testadores Externos:** Use para beta público ou clientes
- **Feedback:** Incentive testadores a enviar feedback pelo TestFlight
- **Crashes:** Monitore a aba "Falhas" para ver erros reportados

## 📱 Link Direto para Testadores

Você pode compartilhar este link (após adicionar testadores):
```
https://testflight.apple.com/join/[CODIGO_DO_GRUPO]
```

O código do grupo aparece quando você cria um grupo de testadores externos.

