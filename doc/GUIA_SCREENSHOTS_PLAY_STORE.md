# 📸 Guia: Capturar Screenshots para Google Play Store

## 📱 Emulador em Execução

**Status:** ✅ Emulador Android iniciado  
**Device:** Pixel 3a API 34 (emulator-5554)  
**App:** ZECA rodando

---

## 📋 Requisitos de Screenshots

### **Tamanhos Obrigatórios:**

1. **Telefone (Phone):**
   - Mínimo: 2 screenshots
   - Recomendado: 4-8 screenshots
   - Tamanho: 320px - 3840px de altura
   - Proporção: 16:9 ou 9:16

2. **Tablet (7"):**
   - Opcional, mas recomendado
   - Tamanho: 320px - 3840px de altura
   - Proporção: 16:9 ou 9:16

3. **Tablet (10"):**
   - Opcional
   - Tamanho: 320px - 3840px de altura
   - Proporção: 16:9 ou 9:16

---

## 🎯 Telas Recomendadas para Screenshots

### **Prioridade Alta (Obrigatórias):**

1. **Tela de Login**
   - Mostra autenticação segura
   - Interface limpa e profissional

2. **Tela Inicial / Home**
   - Mostra o card de veículo ativo
   - Opção de "Abastecimento" em destaque

3. **Geração de Código QR**
   - Mostra o QR code gerado
   - Botão "Finalizar" visível

4. **Tela de Aguardando Validação**
   - Mostra o processo de validação
   - Status em tempo real

### **Prioridade Média (Recomendadas):**

5. **Histórico de Abastecimentos**
   - Lista de abastecimentos
   - Filtros e busca

6. **Detalhes do Abastecimento**
   - Informações completas
   - Status e dados do veículo

---

## 📸 Como Capturar Screenshots

### **Método 1: Android Studio / Emulador**

1. No emulador, navegue até a tela desejada
2. Clique no ícone de câmera na barra lateral do emulador
3. Ou use: `Ctrl + S` (Windows/Linux) ou `Cmd + S` (Mac)
4. O screenshot será salvo automaticamente

### **Método 2: Via ADB (Terminal)**

```bash
# Capturar screenshot
adb -s emulator-5554 exec-out screencap -p > screenshot_$(date +%Y%m%d_%H%M%S).png

# Ou usando o comando do Flutter
flutter screenshot
```

### **Método 3: Ferramenta de Captura do Sistema**

- **macOS:** `Cmd + Shift + 4` (selecionar área) ou `Cmd + Shift + 3` (tela inteira)
- **Windows:** `Win + Shift + S` (ferramenta de recorte)
- **Linux:** Depende da distribuição (geralmente `Print Screen`)

---

## 🎨 Dicas para Screenshots Profissionais

### **Antes de Capturar:**

- ✅ Remova notificações do sistema
- ✅ Configure o emulador em modo claro (light mode)
- ✅ Certifique-se de que o app está em estado "limpo"
- ✅ Use dados de exemplo realistas
- ✅ Evite informações sensíveis (senhas, tokens, etc.)

### **Edição (Opcional):**

- Adicione bordas ou frames do dispositivo (opcional)
- Ajuste brilho/contraste se necessário
- Adicione texto explicativo (se permitido pela Google)
- Mantenha a proporção original

### **Organização:**

Crie uma pasta para organizar:
```
screenshots/
├── phone/
│   ├── 1_login.png
│   ├── 2_home.png
│   ├── 3_qr_code.png
│   └── 4_validation.png
└── tablet/ (opcional)
```

---

## 📐 Tamanhos Específicos Recomendados

### **Phone Screenshots:**
- **Resolução:** 1080x1920 pixels (Full HD)
- **Proporção:** 9:16 (portrait)
- **Formato:** PNG ou JPEG

### **Tablet Screenshots:**
- **7" Tablet:** 1200x1920 pixels
- **10" Tablet:** 1600x2560 pixels

---

## 🚀 Comandos Úteis

### **Verificar dispositivo conectado:**
```bash
flutter devices
```

### **Capturar screenshot via Flutter:**
```bash
flutter screenshot screenshot.png
```

### **Capturar screenshot via ADB:**
```bash
adb -s emulator-5554 exec-out screencap -p > screenshot.png
```

### **Reiniciar app no emulador:**
```bash
flutter run -d emulator-5554
```

---

## ✅ Checklist de Screenshots

- [ ] Tela de Login
- [ ] Tela Inicial / Home
- [ ] Geração de Código QR
- [ ] Tela de Aguardando Validação
- [ ] Histórico de Abastecimentos (opcional)
- [ ] Detalhes do Abastecimento (opcional)
- [ ] Screenshots em formato correto (PNG/JPEG)
- [ ] Tamanhos dentro dos limites (320px - 3840px)
- [ ] Sem informações sensíveis
- [ ] Interface limpa e profissional

---

## 📤 Upload na Play Store

1. Acesse: https://play.google.com/console
2. Selecione o app "ZECA"
3. Vá em "Presença na loja" > "Gráficos do app"
4. Faça upload dos screenshots na seção "Telefone"
5. Opcionalmente, adicione screenshots para tablets

---

**Última atualização:** 2025-01-27

