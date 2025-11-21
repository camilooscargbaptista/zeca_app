# 📱 Como Instalar o App no iPhone sem Cabo

Quando você usa `flutter run`, o app precisa estar conectado ao Mac para funcionar. Para usar o app desconectado, você precisa instalar um build standalone.

## 🚀 Opção 1: Build Release (Mais Simples)

### Passo 1: Build do App
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
flutter build ios --release
```

### Passo 2: Abrir no Xcode
```bash
open ios/Runner.xcworkspace
```

### Passo 3: Instalar no Dispositivo

**No Xcode:**
1. Conecte o iPhone ao Mac (apenas para instalar)
2. No topo do Xcode, selecione seu iPhone como destino
3. Clique em **▶️ Run** (ou pressione `Cmd + R`)
4. Aguarde o build e instalação
5. **Depois pode desconectar** - o app continuará funcionando!

## 🚀 Opção 2: Build Profile (Para Testes)

Build Profile é mais rápido que Release e ainda permite alguns logs:

```bash
flutter build ios --profile
```

Depois siga os mesmos passos do Xcode acima.

## 🚀 Opção 3: Instalar via Xcode (Recomendado para Desenvolvimento)

### Método Completo:

1. **Abrir projeto no Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configurar Signing (se ainda não fez):**
   - Selecione o target **Runner**
   - Aba **Signing & Capabilities**
   - Marque **"Automatically manage signing"**
   - Selecione seu **Team** (Apple Developer)

3. **Selecionar dispositivo:**
   - No topo do Xcode, clique no dropdown ao lado de "Runner"
   - Selecione seu iPhone conectado

4. **Build e Instalar:**
   - Pressione `Cmd + R` ou clique em **▶️ Run**
   - Aguarde o build completar
   - O app será instalado no iPhone

5. **Desconectar:**
   - Após a instalação, você pode desconectar o cabo
   - O app continuará funcionando normalmente

## ⚠️ Importante

- **Primeira instalação:** Precisa estar conectado para instalar
- **Após instalar:** Pode desconectar e usar normalmente
- **Atualizações:** Se quiser atualizar o app, precisa conectar novamente e fazer novo build

## 🔄 Atualizar o App (quando fizer mudanças)

1. Conecte o iPhone ao Mac
2. Execute:
   ```bash
   flutter build ios --release
   ```
3. No Xcode, pressione `Cmd + R` novamente
4. O app será atualizado no dispositivo

## 📝 Notas

- O build Release é otimizado e não mostra logs de debug
- Para ver logs durante desenvolvimento, use `--profile` ao invés de `--release`
- O app instalado via Xcode funciona normalmente, mesmo desconectado
- Para distribuir para outros dispositivos, use TestFlight ou Ad-Hoc Distribution

