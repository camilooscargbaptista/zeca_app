# Guia de Configuração do App ID no Apple Developer Portal

## 📋 Passo a Passo para Registrar o App ID

### 1. **Description (Descrição)**
```
Zeca App - Abastecimento
```
ou
```
Zeca App
```

**Regras:**
- Não usar caracteres especiais como @, &, *, "
- Pode usar letras, números e espaços

---

### 2. **Bundle ID**

#### Selecionar: **Explicit** (já está selecionado)

#### Digitar no campo:
```
com.abasteca.zeca
```

**Formato:** `com.dominio.nomeapp`
- ✅ Correto: `com.abasteca.zeca`
- ❌ Errado: `com.abasteca.zeca.*` (não pode ter asterisco)

---

### 3. **Capabilities (Capacidades) - OBRIGATÓRIAS**

Você precisa marcar **APENAS** estas capabilities:

#### ✅ **Push Notifications**
- **Nome:** Push Notifications
- **Ícone:** Parece um sino ou notificação
- **Por quê:** Necessário para enviar notificações push ao motorista

#### ✅ **Background Modes** (se aparecer separado)
- **Nome:** Background Modes
- **Ícone:** Pode ter um ícone de fundo/background
- **Por quê:** Necessário para receber notificações em background
- **Sub-opções:** Marcar "Remote notifications"

---

### 4. **Capabilities NÃO Necessárias (NÃO MARCAR)**

❌ **NÃO marque** outras capabilities como:
- Apple Pay
- In-App Purchase
- Game Center
- HealthKit
- HomeKit
- etc.

**Regra:** Marque apenas o que você realmente precisa!

---

## 🔍 Como Encontrar Push Notifications

1. **Procure na lista** por "Push Notifications"
   - Pode estar em ordem alfabética
   - Use Ctrl+F (Cmd+F no Mac) para buscar "Push"

2. **Ou procure por "Notifications"**
   - Pode aparecer como "Push Notifications" ou apenas "Notifications"

3. **Ícone:** Geralmente é um sino 🔔 ou um ícone de notificação

---

## 📝 Checklist Antes de Continuar

- [ ] Description preenchida: `Zeca App` ou `Zeca App - Abastecimento`
- [ ] Bundle ID: `com.abasteca.zeca` (Explicit)
- [ ] Push Notifications marcada ✅
- [ ] Background Modes marcada ✅ (se aparecer separado)
- [ ] Nenhuma outra capability marcada

---

## ⚠️ Importante

1. **Bundle ID é único:** Uma vez criado, não pode ser alterado facilmente
2. **Capabilities podem ser adicionadas depois:** Se esquecer alguma, pode editar depois
3. **Continue só quando:** Tiver marcado Push Notifications e preenchido tudo corretamente

---

## 🎯 Próximos Passos Após Criar o App ID

1. ✅ App ID criado com Push Notifications
2. ⏭️ Criar APNs Key ou Certificado
3. ⏭️ Criar Provisioning Profiles
4. ⏭️ Configurar no Firebase Console
5. ⏭️ Configurar no Xcode

---

## 💡 Dica

Se não encontrar "Push Notifications" na lista:
- Verifique se está na aba correta (Capabilities, não App Services)
- Role a página para baixo (a lista é longa)
- Use a busca do navegador (Ctrl+F / Cmd+F)

