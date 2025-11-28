# 🎯 Como Finalizar Journey Ativa e Ver Formulário

**Problema:** App está mostrando mapa ao invés do formulário de criar journey.  
**Causa:** Há uma journey ATIVA no backend sendo carregada automaticamente.

---

## ✅ **SOLUÇÃO RÁPIDA:**

### **No App iOS (Emulador):**

1. **Você já está vendo o mapa da journey ativa**
2. **Procure o botão "Finalizar" ou "Finalizar Viagem"** (botão vermelho)
3. **Clique nele**
4. **Confirme a finalização** no modal
5. **AGORA o formulário deve aparecer!**

---

## 📋 **O que o App Faz:**

```
Ao abrir tela de Jornadas:
  ↓
1. BLoC emite: LoadActiveJourney
  ↓
2. API call: GET /api/v1/journeys/active
  ↓
3a. SE retornar journey ATIVA:
    → Mostrar MAPA (journey em andamento)
    
3b. SE retornar 404 (nenhuma ativa):
    → Mostrar FORMULÁRIO (criar nova journey)
```

**Seu caso:** API retornou journey ativa → Mostrando mapa

---

## 🔧 **Alternativa: Finalizar via Backend (Banco de Dados)**

**Se não conseguir finalizar pelo app:**

1. **Conectar no banco de dados:**
```bash
psql -h [host] -U [usuario] -d zeca_db
```

2. **Encontrar journey ativa do motorista:**
```sql
SELECT 
  id, 
  driver_id, 
  placa, 
  status, 
  data_inicio, 
  data_fim,
  odometro_inicial
FROM journeys 
WHERE driver_id = 'f2a3b4c5-d6e7-f8f9-f0f1-f2f3f4f5f6f7'  -- Pedro Oliveira
  AND status = 'ACTIVE'
ORDER BY data_inicio DESC
LIMIT 1;
```

3. **Finalizar a journey:**
```sql
UPDATE journeys 
SET 
  status = 'FINISHED',
  data_fim = NOW(),
  odometro_final = odometro_inicial,  -- Mesmo valor se não dirigiu
  updated_at = NOW()
WHERE id = '{id_da_journey_encontrada}'
  AND status = 'ACTIVE';
```

4. **Reiniciar o app ou fazer pull-to-refresh**

---

## 🎯 **Após Finalizar:**

**O que deve acontecer:**

1. ✅ Journey status vira `FINISHED`
2. ✅ API `/journeys/active` retorna 404
3. ✅ App mostra **FORMULÁRIO de criar journey**
4. ✅ Você poderá preencher:
   - Placa: `ABC-1234`
   - Odômetro: `40404`
   - Destino: `Vila Tibério, Ribeirão Preto`
   - Observações: (opcional)
5. ✅ **Clicar em "Iniciar Viagem"**
6. ✅ **LOGS DE TRACKING APARECERÃO!**

---

## 📝 **Identificar Journey Ativa no App:**

**Logs atuais mostram:**
```
flutter: 🗺️ [Journey] Construindo view de jornada ativa
flutter:    - Rota disponível: false
flutter:    - Origin: (null, null)
flutter:    - Dest: (null, null)
```

**Isso confirma:**
- ✅ Journey está ATIVA
- ❌ Sem rota (journey antiga sem destino)
- ❌ Por isso não mostra formulário

---

## 🚀 **AÇÃO IMEDIATA:**

### **CAMILO, por favor:**

**1. No app iOS, procure o botão "Finalizar" e clique**

**OU**

**2. Me diga: Você vê algum botão para finalizar/parar a journey no mapa?**

**OU**

**3. Se preferir, me dê acesso ao banco para eu finalizar a journey ativa diretamente**

---

**Uma vez finalizada, o formulário aparecerá e poderemos testar! 🎯**

