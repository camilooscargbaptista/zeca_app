# 📱 Instruções de Build - UH-003

## 🚀 Como Rodar no Simulador iOS

### **Método 1: Script Automático (Mais Fácil)**

No seu terminal **com Flutter configurado** (iTerm, Terminal.app, ou terminal do Cursor):

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# Executar script
./run_ios_simulator.sh
```

O script faz automaticamente:
1. ✅ flutter pub get
2. ✅ build_runner (code generation)
3. ✅ Abre simulador
4. ✅ Executa flutter run

---

### **Método 2: Manual Passo-a-Passo**

```bash
# 1. Navegar até o projeto
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# 2. Checkout da branch
git checkout feature/UH-003-navegacao-tempo-real

# 3. Instalar dependências
flutter pub get

# 4. Gerar código de DI (injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Abrir simulador
open -a Simulator

# 6. Rodar app
flutter run
```

---

### **Método 3: Pelo Cursor IDE**

1. **Abrir terminal integrado** no Cursor: `Terminal > New Terminal`
2. Executar:
   ```bash
   flutter pub get
   flutter run
   ```
3. Ou simplesmente: **F5** (Start Debugging)

---

## 🤖 Como Rodar no Emulador Android

```bash
# 1. Listar emuladores
emulator -list-avds

# 2. Iniciar emulador (exemplo)
emulator -avd Pixel_5_API_33 &

# 3. Aguardar iniciar (30s)

# 4. Rodar app
flutter run
```

---

## ✅ Checklist Pós-Build

Após o app iniciar:

- [ ] **Login** com suas credenciais
- [ ] **Navegar para "Iniciar Viagem"**
- [ ] **Testar destino obrigatório:**
  - Tentar iniciar sem destino → deve dar erro ✅
- [ ] **Preencher destino:**
  - Digitar "São Paulo"
  - Selecionar da lista
  - Ver banner verde: "Rota calculada" ✅
- [ ] **Iniciar viagem:**
  - Ver animação 5s (zoom out) ✅
  - Depois entrar em modo navegação ✅
- [ ] **Testar FAB** (topo-direito):
  - Clicar para alternar zoom ✅
- [ ] **Ver card verde:**
  - Deve mostrar instrução ✅
  - Ícone de manobra ✅

---

## 🐛 Troubleshooting

### **Erro: NavigationService not registered**

```bash
# Rodar code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### **Erro: Google Maps API Key**

Verificar `lib/core/config/api_keys.dart`:
- Places API habilitada
- Directions API habilitada

### **Erro: Build Failed**

```bash
# Limpar e reconstruir
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 📊 O Que Esperar

### **Console Logs:**
```
🗺️ [Directions] Calculando rota COM steps...
✅ [Directions] Rota calculada: 8.3 km, 20 min, 15 steps
✅ [Journey] 15 steps carregados no NavigationService
🎬 [Journey] Iniciando animação inicial (5s overview)
✅ [Journey] Animação concluída, entrando em modo navegação
🧭 [Navigation] Iniciando navegação com 15 steps
🧭 [Navigation] Step 1/15: 350m até manobra
```

### **UI Esperada:**
- Destino obrigatório (validação) ✅
- Banner verde "Rota calculada" ✅
- Animação 5s com card overlay ✅
- FAB topo-direito ✅
- Card verde com instruções ✅

---

**Arquivo criado:** `run_ios_simulator.sh`  
**Execute:** `./run_ios_simulator.sh` em terminal com Flutter!

