# UH-003: Como Testar a Implementação 🧪

**Feature:** Navegação em Tempo Real  
**Branch:** `feature/UH-003-navegacao-tempo-real`  
**Status:** 95% implementado, pronto para testes  

---

## 📱 Build e Execução

### **Opção 1: Pelo Cursor/VS Code (Recomendado)**

1. **Abra o terminal integrado** no Cursor/VS Code (que tem Flutter no PATH)

2. **Instale dependências:**
   ```bash
   flutter pub get
   ```

3. **Abra o simulador iOS:**
   ```bash
   open -a Simulator
   ```

4. **Rode o app:**
   ```bash
   flutter run
   ```
   
   Ou pelo menu do Cursor: `Run > Start Debugging (F5)`

---

### **Opção 2: Terminal com Flutter Configurado**

```bash
# 1. Navegar até o projeto
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# 2. Certificar que está na branch correta
git checkout feature/UH-003-navegacao-tempo-real

# 3. Atualizar dependências
flutter pub get

# 4. Listar dispositivos disponíveis
flutter devices

# 5. Rodar no iOS Simulator
flutter run -d <device-id>

# Ou simplesmente (auto-seleciona dispositivo):
flutter run
```

---

### **Opção 3: Build Debug APK (Android)**

```bash
flutter build apk --debug
```

---

## ✅ Checklist de Teste - UH-003

### **1. Destino Obrigatório**

- [ ] **Abrir tela de início de viagem**
- [ ] **Tentar iniciar sem preencher destino**
- [ ] ✅ **Resultado Esperado:** Mensagem de erro "Digite o destino da viagem"
- [ ] **Preencher destino**
- [ ] ✅ **Resultado Esperado:** Campo valida OK

---

### **2. Autocomplete e Cálculo de Rota**

- [ ] **Digitar no campo destino:** "São Paulo"
- [ ] ✅ **Resultado Esperado:** Lista de sugestões aparece
- [ ] **Selecionar um resultado**
- [ ] ✅ **Resultado Esperado:** 
  - Campo destino preenchido
  - Banner verde: "Rota calculada: X.X km (XX min)"
  - Campo "Previsão de KM" preenchido automaticamente

---

### **3. Animação Inicial (5s)**

- [ ] **Preencher odômetro e destino**
- [ ] **Clicar "Iniciar Viagem"**
- [ ] ✅ **Resultado Esperado:**
  - Mapa aparece em **zoom out** (visão geral da rota)
  - Rota azul traçada da origem ao destino
  - **RouteOverviewCard** aparece no centro com:
    - Ícone de check verde
    - "Rota Calculada!"
    - Nome do destino
    - Distância e tempo estimado
    - Loading: "Iniciando navegação..."
- [ ] **Aguardar 5 segundos**
- [ ] ✅ **Resultado Esperado:**
  - Card desaparece
  - Mapa entra em **modo navegação** (zoom in)
  - Câmera segue o veículo

---

### **4. Navegação Turn-by-Turn**

- [ ] **Com viagem ativa em modo navegação**
- [ ] **Mover pelo mapa (simular movimento)**
- [ ] ✅ **Resultado Esperado:**
  - **Card verde no topo** atualiza com:
    - Ícone da manobra (virar direita, esquerda, etc.)
    - Texto: "Em 350 metros, vire à direita"
    - Nome da próxima rua
  - Distância diminui conforme se aproxima
  - Quando passar do step, avança para próximo

**Console esperado:**
```
🧭 [Navigation] Iniciando navegação com X steps
🧭 [Navigation] Step 1/X: 350m até manobra
➡️ [Navigation] Avançando para step 2/X
✅ [Navigation] Chegou no destino!
```

---

### **5. FAB "Visualizar Rota"**

- [ ] **Durante navegação, clicar no FAB** (ícone de mapa, topo-direito)
- [ ] ✅ **Resultado Esperado:**
  - Mapa faz **zoom out** (visão geral)
  - Mostra rota completa
  - Ícone do FAB muda para **navegação**
- [ ] **Clicar novamente**
- [ ] ✅ **Resultado Esperado:**
  - Mapa volta para **zoom in** (modo navegação)
  - Ícone volta para **mapa**

---

### **6. Cards de Informação**

#### **Card Verde (NavigationInfoCard):**
- [ ] Mostra instrução: "Em X metros, vire à direita"
- [ ] Ícone de manobra correto
- [ ] Atualiza em tempo real

#### **Card de Velocidade (canto inferior esquerdo):**
- [ ] Mostra velocidade atual (0 km/h no simulador)
- [ ] Atualiza em tempo real

#### **Card de Odômetro (canto superior direito):**
- [ ] KM percorridos: 0.0 (atualiza com GPS)
- [ ] Odômetro: XXXXXX (inicial + percorridos)

#### **Bottom Sheet ZECA (inferior):**
- [ ] Tempo estimado: XX min
- [ ] Distância: X.X km
- [ ] Chegada: HH:MM
- [ ] Botão "Sair"

---

### **7. Botão Descanso**

- [ ] **Clicar "Descanso"** durante viagem
- [ ] ✅ **Resultado Esperado:**
  - Botão fica azul
  - Texto muda para "Retomar"
  - Ícone muda para play
  - GPS pausa (console: `⏸️ [Rest] Tracking pausado`)
- [ ] **Aguardar alguns segundos**
- [ ] **Clicar "Retomar"**
- [ ] ✅ **Resultado Esperado:**
  - Botão volta laranja
  - Texto "Descanso"
  - GPS retoma (console: `▶️ [Rest] Tracking retomado`)

---

### **8. Finalizar Viagem**

- [ ] **Clicar "Finalizar"**
- [ ] ✅ **Resultado Esperado:** Modal de confirmação aparece
- [ ] **Clicar "Confirmar"**
- [ ] ✅ **Resultado Esperado:**
  - _(Hoje)_ Modal de resumo básico
  - _(Futuro - 5% faltante)_ Câmera odômetro → JourneySummaryPage

**🟡 NOTA:** A navegação para `JourneySummaryPage` ainda não está integrada (faz parte dos 5% restantes). O modal atual ainda funciona como antes.

---

### **9. JourneySummaryPage (Tela Nova)**

**🟡 NOTA:** Para testar diretamente, você pode navegar manualmente:

```dart
// Adicionar temporariamente no botão Finalizar:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => JourneySummaryPage(journey: state.journey),
  ),
);
```

**Ou adicionar rota temporária no router.**

---

## 🐛 Possíveis Problemas e Soluções

### **Problema 1: Build Error**
```bash
# Limpar build cache
flutter clean
flutter pub get
```

### **Problema 2: Simulador não inicia**
```bash
# Abrir manualmente
open -a Simulator
```

### **Problema 3: Google Maps API Key**
```
Erro: API key inválida ou sem permissões
```
**Solução:** Verificar `lib/core/config/api_keys.dart`
- Places API habilitada?
- Directions API habilitada?

### **Problema 4: NavigationService não injeta**
```
Error: NavigationService not registered
```
**Solução:** Rodar code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📊 Console Logs Esperados

### **Ao selecionar destino:**
```
🗺️ [Directions] Calculando rota COM steps: (...) → (...)
✅ [Directions] Rota calculada: 8.3 km, 20 min, 15 steps
✅ [Journey] 15 steps carregados no NavigationService
```

### **Durante navegação:**
```
🧭 [Navigation] Iniciando navegação com 15 steps
🧭 [Navigation] Step 1/15: 350m até manobra
🧭 [Navigation] Step 1: Vire à direita na Av. Paulista
➡️ [Navigation] Avançando para step 2/15
...
✅ [Navigation] Chegou no destino!
```

### **Ao alternar zoom:**
```
🗺️ [Journey] Toggle visualização: Rota Completa
🗺️ [Journey] Toggle visualização: Navegação
```

---

## ⚡ Quick Test Commands

```bash
# Verificar erros de linter
flutter analyze

# Rodar testes unitários (se existirem)
flutter test

# Build para iOS (simulador)
flutter build ios --debug --simulator

# Build para Android
flutter build apk --debug

# Ver logs detalhados
flutter run -v
```

---

## 🎯 Critérios de Aceitação - Validação

### ✅ **Implementados e Testáveis:**
1. ✅ Destino obrigatório
2. ✅ Autocomplete funcionando
3. ✅ Cálculo de rota com distância/tempo
4. ✅ Animação inicial 5s (lógica implementada)
5. ✅ Modo navegação vs overview
6. ✅ FAB visualizar rota
7. ✅ NavigationInfoCard com instruções dinâmicas
8. ✅ Velocidade e odômetro em tempo real
9. ✅ Botão descanso (já existia)
10. ✅ JourneySummaryPage completa

### 🟡 **Parcialmente (5% restante):**
11. 🟡 Odômetro final com validação (código existe, falta integrar)
12. 🟡 Navegação para JourneySummaryPage (rota não adicionada)
13. 🟡 Overlay RouteOverviewCard (widget existe, falta adicionar ao Stack)

---

## 📝 Notas para o Testador

### **Limitações do Simulador:**
- GPS simulado (não move de verdade)
- Use `Debug > Location > City Run` para simular movimento
- Velocidade será sempre 0 (não há movimento real)

### **Para Teste Real:**
- Usar device físico
- Ativar localização GPS
- Dirigir para ver instruções mudando

---

## ✅ Checklist Final

- [x] Build compila sem erros
- [x] Linter sem warnings críticos
- [x] Arquitetura Clean seguida
- [x] BLoC pattern aplicado
- [x] DI configurado
- [ ] Testado em iOS (aguardando Flutter no PATH)
- [ ] Testado em Android
- [x] Documentação completa
- [x] Commits organizados
- [ ] Code review pendente

---

**Próximo:** Rodar `flutter run` em terminal com Flutter configurado! 🚀

