# 🤖 Automatização App Store Connect

## ❌ O que NÃO pode ser automatizado

**App Store Connect não pode ser preenchido 100% automaticamente** porque:
- Requer autenticação Apple ID
- Alguns campos precisam de revisão manual (descrição, screenshots)
- Apple não permite automação completa por segurança

## ✅ O que PODE ser automatizado

### 1. **Fastlane** (Recomendado) ⭐

**Fastlane** é a melhor ferramenta para automatizar:

#### O que Fastlane faz automaticamente:
- ✅ Captura screenshots automaticamente
- ✅ Faz upload do build para App Store Connect
- ✅ Atualiza metadados (descrição, palavras-chave)
- ✅ Gerencia versões e build numbers
- ✅ Envia para revisão automaticamente
- ✅ Gerencia certificados e provisioning profiles

#### O que ainda precisa fazer manualmente (uma vez):
- ⚠️ Primeira configuração do Fastlane
- ⚠️ Criar App no App Store Connect (primeira vez)
- ⚠️ Configurar API Key do App Store Connect

---

## 🚀 Setup Fastlane (Recomendado)

### Instalação

```bash
# Instalar Fastlane
sudo gem install fastlane

# Ou via Homebrew
brew install fastlane
```

### Inicializar no projeto

```bash
cd ios
fastlane init
```

### Configuração básica

O Fastlane criará:
- `ios/fastlane/Fastfile` - Scripts de automação
- `ios/fastlane/Appfile` - Configurações do app

---

## 📋 Script Atual vs Fastlane

### Seu script atual (`build_testflight.sh`):
- ✅ Incrementa build number
- ✅ Faz build do app
- ✅ Cria archive
- ❌ Não faz upload automático
- ❌ Não preenche App Store Connect

### Com Fastlane:
- ✅ Tudo que o script atual faz
- ✅ Upload automático para App Store Connect
- ✅ Atualização de metadados
- ✅ Envio para revisão

---

## 🛠️ Opção 1: Melhorar Script Atual

Posso melhorar seu script `build_testflight.sh` para:
1. Fazer upload automático via `xcrun altool` ou `xcrun notarytool`
2. Validar o build antes de upload
3. Gerar relatório de build

**Limitação:** Ainda precisa preencher App Store Connect manualmente.

---

## 🎯 Opção 2: Configurar Fastlane (Melhor)

Posso criar configuração completa do Fastlane que:
1. Faz build automaticamente
2. Faz upload para App Store Connect
3. Atualiza metadados (se configurado)
4. Envia para revisão (opcional)

**Vantagem:** Quase tudo automático após primeira configuração.

---

## 📝 O que precisa preencher manualmente (uma vez)

### No App Store Connect:
1. ✅ **SKU:** `zeca-app-ios`
2. ✅ **Acesso:** Acesso total
3. ✅ **Descrição do app** (posso fornecer template)
4. ✅ **Screenshots** (Fastlane pode capturar automaticamente)
5. ✅ **Palavras-chave**
6. ✅ **URLs** (suporte, privacidade)
7. ✅ **Categoria**

---

## 💡 Recomendação

**Use Fastlane** porque:
- É o padrão da indústria
- Suportado oficialmente pela Apple
- Muito mais poderoso que scripts manuais
- Pode capturar screenshots automaticamente
- Pode atualizar metadados automaticamente

---

## 🚀 Próximos Passos

### Opção A: Quer que eu configure Fastlane?
Posso criar:
- `Fastfile` completo
- `Appfile` com suas configurações
- Scripts para build e upload automático

### Opção B: Melhorar script atual?
Posso adicionar:
- Upload automático
- Validação de build
- Relatórios

---

## 📚 Recursos

- [Fastlane Docs](https://docs.fastlane.tools/)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
- [Seu script atual](../build_testflight.sh)

---

**Qual opção você prefere?**
1. Configurar Fastlane completo
2. Melhorar script atual
3. Guia manual completo (já criado em `GUIA_APP_STORE_CONNECT.md`)






