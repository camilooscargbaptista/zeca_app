# 🧪 Guia de Teste - Push Notifications com Deep Links

## 📱 Como Testar Push Notifications

### **✅ Método Recomendado: Firebase Console**

**Este é o método mais fácil e recomendado para testar push notifications.**

1. **Acesse o Firebase Console:**
   - Vá para: https://console.firebase.google.com
   - Selecione o projeto: `abastecacomzeca`

2. **Navegue até Cloud Messaging:**
   - Menu lateral → **Engage** → **Cloud Messaging**
   - Clique em **"Send test message"** (ou **"Nova notificação"** → **"Enviar mensagem de teste"**)

3. **Obter o Token FCM do dispositivo:**
   - Execute o app: `flutter run`
   - No console/logs, procure por: `📱 Token FCM obtido: [TOKEN]`
   - Copie o token completo

4. **Configure a notificação de teste:**
   - **Token FCM:** Cole o token copiado dos logs
   - **Título:** `Validação Pendente`
   - **Texto:** `Dados do abastecimento aguardando sua validação`
   
5. **Adicione dados customizados (OBRIGATÓRIO para deep link):**
   - Role até a seção **"Dados adicionais"** ou **"Additional options"**
   - Clique em **"Adicionar campo personalizado"** ou **"Add custom key"**
   - Adicione os seguintes campos:
     ```
     Chave: type
     Valor: refueling_validation_pending
     
     Chave: refueling_id
     Valor: [ID_DO_ABASTECIMENTO_AQUI] (ex: 550e8400-e29b-41d4-a716-446655440000)
     ```
   
6. **Enviar:**
   - Clique em **"Testar"** ou **"Send test"**
   - A notificação deve chegar no dispositivo em alguns segundos

---

### **Método Alternativo: Via Terminal (cURL)**

**Use apenas se precisar de mais controle ou automação.**

```bash
# Substitua:
# - YOUR_SERVER_KEY: Chave do servidor do Firebase (encontre em Firebase Console > Project Settings > Cloud Messaging)
# - DEVICE_TOKEN: Token FCM do dispositivo
# - REFUELING_ID: ID do abastecimento para testar

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_TOKEN",
    "notification": {
      "title": "Validação Pendente",
      "body": "Dados do abastecimento aguardando sua validação"
    },
    "data": {
      "type": "refueling_validation_pending",
      "refueling_id": "REFUELING_ID"
    }
  }'
```

---

### **💡 Dica: Token FCM nos Logs**

O token FCM é exibido automaticamente nos logs quando o app inicia:

```bash
flutter run
```

Procure por esta linha no console:
```
📱 Token FCM obtido: [TOKEN_AQUI]
```

**O token também é registrado automaticamente no backend** quando o usuário está logado.

---

## 🔗 Testar Deep Links

### **Teste 1: Deep Link via Push Notification**

1. Envie uma push notification com os dados:
   ```json
   {
     "type": "refueling_validation_pending",
     "refueling_id": "uuid-do-abastecimento"
   }
   ```

2. **Cenários de teste:**
   - ✅ App em foreground → Deve processar e navegar
   - ✅ App em background → Tocar na notificação → Deve navegar
   - ✅ App fechado → Abrir pela notificação → Deve navegar

### **Teste 2: Deep Link via URL (Android)**

```bash
# No terminal do Android (via ADB)
adb shell am start -a android.intent.action.VIEW \
  -d "zeca://refueling-validation/REFUELING_ID" \
  com.zeca.app
```

### **Teste 3: Deep Link via URL (iOS)**

```bash
# No terminal do Mac
xcrun simctl openurl booted "zeca://refueling-validation/REFUELING_ID"
```

---

## 📋 Checklist de Testes

### **Permissões:**
- [ ] App solicita permissão de notificação ao iniciar
- [ ] Permissão concedida → Token FCM obtido
- [ ] Token registrado no backend (verificar logs)

### **Push Notifications:**
- [ ] Notificação chega quando app está em foreground
- [ ] Notificação chega quando app está em background
- [ ] Notificação chega quando app está fechado
- [ ] Tocar na notificação abre o app e navega

### **Deep Links:**
- [ ] Deep link navega para `/refueling-validation/{id}` corretamente
- [ ] Dados são carregados na tela de validação
- [ ] Funciona quando app está aberto
- [ ] Funciona quando app está fechado

### **Integração:**
- [ ] Polling continua funcionando como backup
- [ ] Push notification e polling trabalham juntos
- [ ] Não há navegação duplicada

---

## 🐛 Debug

### **Ver logs no console:**
```bash
# Android
flutter run
# Ou
adb logcat | grep -i firebase

# iOS
flutter run
# Ou no Xcode: Window > Devices and Simulators > View Device Logs
```

### **Logs importantes para procurar:**
- `📱 Token FCM obtido:` - Token foi gerado
- `✅ Token FCM registrado no backend:` - Token foi enviado ao backend
- `📨 Notificação recebida em foreground:` - Push chegou
- `🔗 Deep link: Navegar para validação:` - Deep link processado
- `❌ Erro ao...` - Qualquer erro

---

## 🔧 Exemplo de Payload Completo

```json
{
  "notification": {
    "title": "Validação Pendente",
    "body": "Dados do abastecimento aguardando sua validação"
  },
  "data": {
    "type": "refueling_validation_pending",
    "refueling_id": "550e8400-e29b-41d4-a716-446655440000",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  },
  "to": "DEVICE_TOKEN_FCM"
}
```

---

## 📝 Notas Importantes

1. **Token FCM muda:**
   - Quando app é reinstalado
   - Quando dados do app são limpos
   - O token é atualizado automaticamente

2. **Permissões iOS:**
   - Primeira vez precisa solicitar permissão
   - Usuário pode negar → App não receberá notificações

3. **Android:**
   - Android 13+ precisa de permissão `POST_NOTIFICATIONS`
   - Já está configurado no AndroidManifest

4. **Deep Links:**
   - URLs customizadas (`zeca://`) precisam ser configuradas no AndroidManifest e Info.plist
   - Por enquanto, deep links funcionam via dados da push notification

---

## 🚀 Próximos Passos

Para configurar deep links via URL customizada (`zeca://`), será necessário:

1. **Android:** Adicionar intent-filter no AndroidManifest
2. **iOS:** Configurar URL Scheme no Info.plist
3. **Flutter:** Usar pacote `uni_links` ou `app_links`

Por enquanto, os deep links funcionam via dados da push notification, que é suficiente para o fluxo atual.

