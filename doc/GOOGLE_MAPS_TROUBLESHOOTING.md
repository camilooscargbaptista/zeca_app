# 🗺️ Google Maps - Troubleshooting: Tiles Não Carregam

## 🔴 Problema Confirmado

**Sintoma:** Mapa aparece apenas com fundo cinza/branco  
**Status SDK:** ✅ Funcionando (logo Google aparece)  
**Status Tiles:** ❌ Não carregam (sem ruas, prédios)

---

## 🔍 Causas Possíveis e Soluções

### **Causa 1: API Key com Restrições ⭐ MAIS PROVÁVEL**

#### **Verificar no Google Cloud Console:**

1. Acesse: https://console.cloud.google.com/apis/credentials
2. Encontre a API Key: `AIzaSyCTlAYLa9K04yfP65Qjg83vqoXhjee5Z2Q`
3. Verifique:
   - [ ] **Maps SDK for iOS** está HABILITADO?
   - [ ] **API Restrictions:** Deve estar "None" ou incluir "Maps SDK for iOS"
   - [ ] **Application restrictions:** Se houver, deve incluir o bundle ID do app
   - [ ] **Quota/Billing:** Não está excedida?

#### **APIs que devem estar HABILITADAS:**

Na seção "APIs & Services" → "Enabled APIs":
- [x] Maps SDK for iOS
- [x] Maps SDK for Android
- [x] Directions API
- [x] Places API
- [x] Geocoding API

#### **Se API Key tem restrições de IP/App:**

No campo "Application restrictions":
- Selecione "iOS apps"
- Adicione o bundle ID: `com.onepercent.zeca` (verificar no projeto)

### **Causa 2: Simulador sem Internet**

#### **Teste manual:**

1. Abra **Safari no simulador**
2. Acesse: `https://google.com`
3. **Se carregar** → Internet funciona
4. **Se não carregar** → Problema de rede

#### **Solução se sem internet:**

```bash
# Reiniciar networking do simulador
xcrun simctl shutdown 2E883348-A1B4-4E3C-9918-272DF8EC84DD
xcrun simctl boot 2E883348-A1B4-4E3C-9918-272DF8EC84DD
```

### **Causa 3: Tiles ainda carregando**

#### **Aguardar 1-2 minutos**

Às vezes as tiles demoram para carregar na primeira vez.

**Tente:**
1. No simulador, clicar em "Zoom In"
2. Aguardar 30 segundos
3. Mover o mapa arrastando
4. Ver se tiles aparecem

### **Causa 4: Bundle ID incorreto no Info.plist**

#### **Verificar configuração:**

```bash
cd ios
grep -A 5 "CFBundleIdentifier" Runner/Info.plist
```

O bundle ID deve coincidir com o configurado no Google Cloud.

---

## ✅ Solução Rápida: Verificar Restrições

### **Passo 1: Remover TODAS as restrições da API Key (temporário)**

1. Google Cloud Console → Credentials
2. Editar a API Key
3. Em "API restrictions" → Selecionar "Don't restrict key"
4. Em "Application restrictions" → Selecionar "None"
5. Salvar

⚠️ **ATENÇÃO:** Isso deixa a key aberta (não recomendado em produção)  
Apenas para testar se o problema é restrição.

### **Passo 2: Criar uma API Key Nova (TESTE)**

```bash
# No Google Cloud Console:
1. APIs & Services → Credentials
2. Create Credentials → API Key
3. Copiar a nova key
4. Testar no app
```

### **Passo 3: Verificar Billing**

Google Maps é **PAGO** (após free tier).

1. Google Cloud → Billing
2. Verificar se billing account está ativo
3. Verificar se há quota disponível

---

## 🧪 Teste Rápido de Conectividade

Adicionar no app um teste de rede:

```dart
// Adicionar em test_google_maps_page.dart
Future<void> testConnectivity() async {
  try {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/staticmap?center=-21.1704,-47.8103&zoom=14&size=400x400&key=AIzaSyCTlAYLa9K04yfP65Qjg83vqoXhjee5Z2Q')
    );
    
    if (response.statusCode == 200) {
      print('✅ API Key funciona! Tiles devem carregar.');
    } else {
      print('❌ Erro: ${response.statusCode}');
      print('   Body: ${response.body}');
    }
  } catch (e) {
    print('❌ Sem internet ou API bloqueada: $e');
  }
}
```

---

## 🎯 Ação Imediata

**CAMILO, faça isso agora:**

1. **Abra Safari no simulador**
   - Acesse `google.com`
   - Confirme se carrega

2. **Acesse Google Cloud Console**
   - https://console.cloud.google.com/apis/credentials
   - Encontre a API Key
   - Verifique se "Maps SDK for iOS" está na lista de APIs permitidas

3. **Me informe:**
   - [ ] Safari carrega Google.com?
   - [ ] API Key tem restrições?
   - [ ] Maps SDK for iOS está habilitado?

---

## 💡 Workaround Temporário

Se não conseguir resolver a API Key rapidamente, podemos usar **Flutter Map** (não precisa de API Key):

```yaml
dependencies:
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
```

Mapas do OpenStreetMap, 100% gratuito, sem API Keys.

---

**Aguardo suas respostas para prosseguir! 🔍**

