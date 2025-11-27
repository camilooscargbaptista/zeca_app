# 🐛 Debug Google Maps - Análise Completa

## 🔍 Investigação Atual

### **Situação:**
- ✅ App builda com sucesso (Xcode build done)
- ✅ App sincroniza com device
- ✅ DI inicializa corretamente
- ❌ App crasha logo após init (Lost connection to device)
- ❌ Sem stack trace ou erro explícito nos logs

### **Tentativas Realizadas:**

1. **RouteMapView completo** → Crash
2. **RouteMapView + ValueKey** → Crash por Impeller
3. **RouteMapView + controle direto** → Crash
4. **RouteMapViewMinimal** → Crash (mesmo sem animações)

### **Conclusão:**
O problema **NÃO é** a complexidade do código de navegação.  
O problema é **algo mais fundamental** com o Google Maps.

---

## 🎯 Próximos Passos de Debug

### **Teste 1: Verificar se o Google Maps funciona ISOLADAMENTE**

Criar uma página de teste mínima:

```dart
// lib/test_google_maps_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestGoogleMapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Google Maps')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-21.1704, -47.8103),
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
          print('✅ MAPA CRIADO COM SUCESSO!');
        },
      ),
    );
  }
}
```

**Se funcionar:** Problema está na integração com `journey_page.dart`  
**Se não funcionar:** Problema é config do Google Maps SDK no iOS

### **Teste 2: Verificar Permissões de Localização**

O crash pode ser por permissões. Verificar `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Necessário para rastrear sua localização durante a viagem</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Necessário para rastrear em background</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Necessário para rastreamento contínuo</string>
```

### **Teste 3: Verificar Dependências**

O problema pode ser incompatibilidade entre packages:

```bash
flutter pub outdated
flutter pub upgrade --major-versions
```

Especificamente verificar:
- `google_maps_flutter`: versão atual
- Compatibilidade com iOS 17
- Conflitos com outros plugins

### **Teste 4: Verificar Console do Xcode**

Rodar diretamente pelo Xcode para ver logs nativos:

```bash
open ios/Runner.xcworkspace
```

Executar no Xcode e ver console nativo.

---

## 💡 Hipóteses

### **Hipótese 1: Problema com myLocationEnabled**

`myLocationEnabled: true` requer permissões específicas. Pode crashar se:
- Permissão não concedida
- Core Location não inicializado
- Conflito com outro plugin de location

**Teste:**
```dart
GoogleMap(
  initialCameraPosition: ...,
  myLocationEnabled: false, // 🧪 TESTAR SEM
)
```

### **Hipótese 2: Problema com API Key**

Mesmo com API Key configurada, pode haver:
- Restrições na chave (só permite web, não iOS)
- Quota excedida
- Billing não configurado no Google Cloud

**Verificar:**
- Google Cloud Console → Credentials
- Verificar se há restrições
- Ver se billing está ativo

### **Hipótese 3: Problema com Polyline**

Decodificação de polyline pode crashar se:
- String vazia/inválida
- Formato corrompido
- Loop infinito na decodificação

**Teste:**
```dart
GoogleMap(
  // ... sem polylines
  polylines: {}, // 🧪 TESTAR SEM
)
```

### **Hipótese 4: Problema com Build do Google Maps SDK**

O SDK pode não estar sendo linkado corretamente:

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

---

## 🔬 Debug Sistemático - Passo a Passo

### **Fase 1: Isolar o Google Maps**

1. Comentar TODO o código de `journey_page.dart`
2. Substituir por uma tela simples com Google Maps
3. Ver se renderiza
4. Se sim → problema é na integração
5. Se não → problema é no SDK

### **Fase 2: Testar sem myLocation**

1. Remover `myLocationEnabled: true`
2. Ver se ainda crasha
3. Se não crashar → problema é permissões/Core Location

### **Fase 3: Testar sem Polyline**

1. Remover polyline completamente
2. Ver se ainda crasha
3. Se não crashar → problema é decodificação

### **Fase 4: Testar sem Marcadores**

1. Remover todos markers
2. Ver se ainda crasha
3. Se não crashar → problema é ícones/assets

---

## 📱 Teste Alternativo: Flutter Map

Se Google Maps continuar crashando, tentar `flutter_map`:

```yaml
dependencies:
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
```

```dart
FlutterMap(
  options: MapOptions(
    initialCenter: LatLng(-21.1704, -47.8103),
    initialZoom: 15.0,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
    PolylineLayer(
      polylines: [
        Polyline(
          points: routePoints,
          color: Colors.blue,
          strokeWidth: 5,
        ),
      ],
    ),
  ],
)
```

**Vantagens:**
- Mais leve
- Mais estável
- Sem API Keys
- Offline capable

---

## 🎯 Decisão Necessária

**Camilo, preciso saber:**

1. Você quer que eu continue debug do Google Maps? (pode levar mais 4-6h)
2. Ou prefere que eu implemente com `flutter_map`? (2-3h, mais estável)

**Flutter Map** seria uma solução mais rápida e estável, sem depender do Google Maps SDK.

---

**Status:** 🔴 **BLOQUEADO** - Crash silencioso impossibilita progresso com Google Maps

