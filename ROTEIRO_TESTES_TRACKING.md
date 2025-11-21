# 🧪 ROTEIRO DE TESTES - Background Tracking

## 📱 **PREPARAÇÃO**

### **1. Instalar do TestFlight**
- Abrir TestFlight no iPhone
- Instalar versão mais recente do ZECA
- Aceitar todas as permissões de localização

### **2. Configurações do iPhone (CRÍTICO)**
- **Settings > ZECA > Location:** Selecionar **"Always Allow"**
- **Settings > Battery:** Desabilitar "Low Power Mode"
- **Settings > ZECA > Battery:** Selecionar **"Unrestricted"**

---

## ✅ **TESTE 1: FOREGROUND (App Aberto)**

**Objetivo:** Verificar se captura pontos com app aberto

### **Passos:**
1. Abrir app ZECA
2. Fazer login
3. Selecionar veículo (placa)
4. Ir para "Iniciar Viagem"
5. Clicar em "Iniciar Jornada"
6. **Observar notificação:** "🚛 Jornada ZECA Ativa"
7. **Andar/dirigir por 2-3 minutos** (mínimo 100 metros)
8. Voltar ao app
9. **Verificar:**
   - [ ] KM aumentou?
   - [ ] Velocidade aparece?
   - [ ] Notificação permanece ativa?

### **✅ RESULTADO ESPERADO:**
- Pontos capturados a cada 30 metros
- KM aumentando gradualmente
- Velocidade sendo mostrada
- Notificação persistente no topo

---

## ✅ **TESTE 2: BACKGROUND (App Minimizado)**

**Objetivo:** Verificar se captura pontos com app em segundo plano

### **Passos:**
1. Com jornada ativa (do teste anterior)
2. **Minimizar app** (Home button)
3. **Verificar notificação:** "🚛 Jornada ZECA Ativa" ainda aparece
4. **Andar/dirigir por 5 minutos** (mínimo 500 metros)
5. **Verificar na notificação:** Deve mostrar que está ativo
6. Abrir app novamente
7. **Verificar:**
   - [ ] KM aumentou durante background?
   - [ ] Pontos foram capturados?
   - [ ] Velocidade foi registrada?

### **✅ RESULTADO ESPERADO:**
- Pontos capturados mesmo com app minimizado
- KM aumentou durante período em background
- Notificação permaneceu ativa

---

## ✅ **TESTE 3: APP FECHADO (Mais Crítico)**

**Objetivo:** Verificar se captura pontos com app completamente fechado

### **Passos:**
1. Com jornada ativa
2. **Fechar app completamente:**
   - Swipe up
   - Swipe up novamente no card do ZECA
3. **Verificar notificação:** Deve continuar aparecendo
4. **Andar/dirigir por 10 minutos** (mínimo 1 km)
5. **NÃO ABRIR O APP** durante esse tempo
6. Após 10 minutos, abrir app
7. **Verificar:**
   - [ ] KM aumentou significativamente?
   - [ ] Pontos foram capturados?
   - [ ] Timeline de velocidade/posição está completa?

### **✅ RESULTADO ESPERADO:**
- Pontos capturados continuamente
- KM aumentou ~1 km
- Timeline sem "buracos"

---

## ✅ **TESTE 4: PAUSA/RETOMAR (Descanso)**

**Objetivo:** Verificar se pause/resume funciona

### **Passos:**
1. Com jornada ativa e em movimento
2. **Clicar em "Iniciar Descanso"**
3. **Observar:**
   - [ ] Notificação desaparece ou muda?
   - [ ] Tracking para?
4. **Andar por 2 minutos** (durante descanso)
5. Verificar que KM **NÃO aumentou**
6. **Clicar em "Encerrar Descanso"**
7. **Observar:**
   - [ ] Notificação volta?
   - [ ] Tracking retoma?
8. Andar por 2 minutos
9. Verificar que KM **aumentou** novamente

### **✅ RESULTADO ESPERADO:**
- Durante descanso: **sem captura**
- Após retomar: **captura normal**

---

## ✅ **TESTE 5: OFFLINE → ONLINE**

**Objetivo:** Verificar se sincroniza quando voltar online

### **Passos:**
1. Com jornada ativa
2. **Ativar modo avião**
3. Andar/dirigir por 5 minutos
4. Verificar KM (deve aumentar localmente)
5. **Desativar modo avião**
6. Aguardar 30 segundos
7. **Verificar:**
   - [ ] Pontos foram sincronizados automaticamente?
   - [ ] Backend recebeu os pontos?

### **✅ RESULTADO ESPERADO:**
- Pontos salvos localmente enquanto offline
- Auto-sync quando volta online

---

## ✅ **TESTE 6: FINALIZAR JORNADA**

**Objetivo:** Verificar se sincroniza tudo antes de finalizar

### **Passos:**
1. Com jornada ativa e pontos capturados
2. **Clicar em "Finalizar Jornada"**
3. Informar odômetro final
4. Confirmar
5. **Observar:**
   - [ ] Mostra "sincronizando pontos pendentes"?
   - [ ] Notificação desaparece?
   - [ ] Jornada finaliza com sucesso?
6. **Verificar no backend:**
   - [ ] Todos os pontos foram recebidos?
   - [ ] KM total está correto?
   - [ ] Timeline está completa?

### **✅ RESULTADO ESPERADO:**
- Todos os pontos sincronizados antes de finalizar
- Notificação desaparece
- Backend tem todos os dados

---

## 🐛 **PROBLEMAS COMUNS E SOLUÇÕES**

### **❌ "Não está capturando pontos"**
**Soluções:**
1. Verificar permissões: Settings > ZECA > Location = "Always"
2. Verificar GPS: Settings > Privacy > Location Services = ON
3. Verificar bateria: Não usar "Low Power Mode"
4. Verificar notificação: Deve aparecer quando jornada ativa

### **❌ "Para quando minimizo o app"**
**Soluções:**
1. iOS: Verificar permissão "Always Allow"
2. iOS: Desabilitar "Low Power Mode"
3. iOS: Settings > ZECA > Background App Refresh = ON
4. Verificar notificação persiste

### **❌ "Para quando fecho o app"**
**Soluções:**
1. Verificar se notificação continua ativa
2. Se notificação desapareceu = tracking parou
3. Verificar Background Modes no Info.plist (já configurado)
4. Pode ser otimização do iOS - normal em alguns casos

### **❌ "Pontos não sincronizam"**
**Soluções:**
1. Verificar conexão com internet
2. Verificar token JWT não expirou
3. Verificar backend está recebendo (403/401/500)
4. Forçar sync: Reabrir app

---

## 📊 **CHECKLIST FINAL**

Após todos os testes, validar:

- [ ] **Foreground tracking:** ✅ Funciona
- [ ] **Background tracking:** ✅ Funciona (minimizado)
- [ ] **App fechado:** ✅ ou ⚠️ (pode ter limitações do iOS)
- [ ] **Pause/Resume:** ✅ Funciona
- [ ] **Offline → Online:** ✅ Sincroniza automaticamente
- [ ] **Finalizar jornada:** ✅ Sincroniza tudo antes de finalizar
- [ ] **Bateria:** 🔋 Consumo aceitável (< 15% em 1h de viagem)
- [ ] **Notificação:** ✅ Aparece e persiste durante tracking
- [ ] **Backend:** ✅ Recebe todos os pontos

---

## 🎯 **CRITÉRIOS DE SUCESSO**

### **✅ MÍNIMO ACEITÁVEL:**
- Tracking em **foreground**: 100% funcional
- Tracking em **background** (minimizado): 90% funcional
- Tracking com **app fechado**: 70% funcional (iOS é restritivo)
- **Auto-sync**: 100% funcional
- **Persistência local**: 100% funcional

### **⚠️ LIMITAÇÕES CONHECIDAS DO iOS:**
1. **Low Power Mode:** Tracking pode parar
2. **App fechado há muito tempo:** iOS pode matar o processo
3. **Bateria < 20%:** iOS pode pausar background tasks
4. **Muitos apps em background:** iOS prioriza outros apps

---

## 📞 **REPORTE DE BUGS**

Se encontrar problemas, anotar:

1. **O que aconteceu?** (ex: "parou de capturar após 5 min")
2. **Quando?** (ex: "quando minimizei o app")
3. **Quanto tempo?** (ex: "estava em background por 10 min")
4. **Bateria?** (ex: "estava em 50%")
5. **Low Power Mode?** (Sim/Não)
6. **Notificação?** (Apareceu? Desapareceu?)
7. **Última localização capturada?** (timestamp)

---

## 🚀 **BOA SORTE NOS TESTES!**

**Data de criação:** 2025-11-19  
**Versão:** 1.0  
**Status:** ✅ Pronto para testar

