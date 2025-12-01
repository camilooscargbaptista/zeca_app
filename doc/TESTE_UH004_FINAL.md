# 🧪 **TESTE FINAL - UH-004**

**Data:** 28-Nov-2025  
**Hora:** 11:30  
**Status:** ✅ Pronto para testar

---

## ✅ **PROBLEMAS CORRIGIDOS:**

1. ❌ **Token Expirado (401)** → ✅ Sistema de listeners implementado
2. ❌ **TokenManagerService não registrado no DI** → ✅ Registrado em injection.dart
3. ❌ **Métodos inexistentes no plugin** → ✅ Removidos `getCount()` e `getLocations()`

---

## 📋 **INSTRUÇÕES PARA TESTE:**

### **1. Fazer Login** 👤
- **Usuário:** pedro.oliveira
- **Senha:** (sua senha)

### **2. Iniciar Nova Jornada** 🚗
- **Odômetro:** 12345
- **Destino:** Shopping Iguatemi Ribeirão (ou qualquer lugar)
- **Observações:** "Teste UH-004 - Tracking Final"
- **Clicar:** "Iniciar Viagem"

### **3. Aguardar Logs** 📊
Após iniciar a jornada, você deve ver nos logs:

```
🚀 [BG-GEO] Iniciando tracking para jornada: XXXXX
🔑 [BG-GEO] Usando token para tracking...
✅ TokenManager: Listener adicionado (total: 1)
✅ [BG-GEO] Plugin configurado
✅ [BG-GEO] Tracking iniciado com sucesso!
```

E depois (a cada 30 metros de movimento):

```
📍 [BG-GEO] Localização capturada:
   - Lat/Lng: -21.xxx, -47.xxx
   - Velocidade: XX.X km/h

🌐 [BG-GEO HTTP] ✅ SUCCESS
📊 Status Code: 201
```

### **4. O Que Observar** 👀

#### ✅ **Sucesso (Status 201):**
```
🌐 [BG-GEO HTTP] ✅ SUCCESS
📊 Status Code: 201
```
**Significa:** Pontos estão sendo enviados e salvos no backend!

#### ❌ **Erro 401 (não deve mais aparecer!):**
```
🌐 [BG-GEO HTTP] ❌ ERROR
📊 Status Code: 401
```
**Se aparecer:** Problema com renovação de token (não deveria mais acontecer)

#### ⚠️ **Nenhum log HTTP:**
**Se não aparecer nada:** Tracking não iniciou ou não está capturando GPS

---

## 🔍 **PRÓXIMOS PASSOS APÓS TESTE:**

### **Se Status 201 (✅ Sucesso):**
1. Deixar rodando por 1-2 minutos
2. Verificar se múltiplos pontos são enviados
3. **Validar no banco de dados** se os pontos foram salvos
4. ✅ **UH-004 CONCLUÍDA!**

### **Se Status 401 (❌ Token expirado):**
1. Verificar se `TokenManagerService` está renovando token
2. Verificar se listener está sendo chamado
3. Adicionar mais logs

### **Se Nenhum Log HTTP (⚠️ Não capturando):**
1. Verificar se GPS está configurado no simulador
2. Verificar se permissões foram concedidas
3. Tentar mover o GPS manualmente

---

## 📡 **SIMULAR MOVIMENTO GPS:**

Após iniciar a jornada, simular caminhada:

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app
./simulate_gps_route.sh
```

Isso vai mover o GPS ao longo de uma rota, gerando pontos a cada 30 metros.

---

## 🎯 **CRITÉRIO DE SUCESSO:**

✅ Status 201 nos logs HTTP  
✅ Múltiplos pontos enviados (1 a cada 30m)  
✅ Pontos salvos no banco de dados  
✅ Token renovado automaticamente (se necessário)  
✅ Nenhum erro 401

---

**BOM TESTE! 🚀**

