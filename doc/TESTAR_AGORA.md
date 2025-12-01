# 🧪 **INSTRUÇÕES PARA TESTAR - DEPURAÇÃO**

## 📋 **O QUE FAZER:**

### **1️⃣ Reiniciar Backend** (IMPORTANTE! ⚠️)
```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_site/backend
npm run start:dev
```

### **2️⃣ No App (que já está rodando):**
1. **Finalizar** jornada atual (se houver)
2. **Iniciar** nova jornada
3. **Aguardar** 10 segundos (GPS irá capturar pontos)

### **3️⃣ Ver Logs do Backend:**

Os logs vão mostrar **EXATAMENTE** o que o app está enviando:

```
═══════════════════════════════════════════════════
🔍 [DEBUG] POST /api/journeys/location-point
═══════════════════════════════════════════════════
📦 Body recebido (RAW):
{
  "journey_id": "xxx",
  "latitude": -21.1704,
  ...
}
📊 Tipos dos campos:
   - journey_id: string xxx
   - latitude: number -21.1704
   ...
═══════════════════════════════════════════════════
```

---

## 🎯 **O QUE VAMOS DESCOBRIR:**

✅ **Qual campo está faltando?**  
✅ **Qual campo tem tipo errado?**  
✅ **O que o plugin está realmente enviando?**

---

## 📝 **DEPOIS:**

Copie os logs completos do backend e me envie!

Com isso, vou saber EXATAMENTE o que corrigir! 🎯

