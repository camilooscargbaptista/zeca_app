# 🐛 UH-003 - Problemas Pendentes

## 📋 Situação Atual

O app roda, o mapa aparece, mas há **2 problemas críticos**:

### **1. ❌ Mapa Sem Detalhes**
**Sintoma:** Mapa aparece muito básico, sem nomes de ruas, prédios, detalhes visuais completos do Google Maps.

**O que aparece:**
- ✅ Linha azul (polyline da rota)
- ✅ Marcador verde (origem)
- ✅ Fundo de mapa básico
- ❌ Sem nomes de ruas
- ❌ Sem prédios 3D
- ❌ Sem detalhes visuais

**Possíveis causas:**
1. **Google Maps SDK não inicializando corretamente no iOS**
   - API Key pode não estar sendo reconhecida
   - SDK pode não estar carregando tiles
   
2. **Configuração do `GoogleMap` widget**
   - Pode precisar de mais tempo para carregar
   - Zoom inicial pode estar muito distante
   
3. **Permissões/Configurações faltando**
   - Info.plist pode precisar de mais configurações
   - Podfile pode precisar de ajustes

### **2. ❌ Câmera Não Segue o Veículo**
**Sintoma:** Mapa fica estático, câmera não acompanha movimento.

**O que acontece:**
- ✅ Localização GPS atualiza (vemos nos logs)
- ✅ `_currentLocation` é atualizada a cada 10m
- ✅ `RouteMapView` recebe `currentPosition`
- ❌ `didUpdateWidget` NÃO está sendo chamado
- ❌ Câmera fica parada

**Causa identificada:** `didUpdateWidget` não é chamado porque a **referência de `LatLng` não muda**, mesmo com coordenadas diferentes.

## 🔧 Soluções Propostas

### **Solução 1: Mapa Sem Detalhes - Verificar API Key**

**Testar manualmente:**
```bash
# Ver se Google Maps SDK inicializa
tail -f /tmp/flutter_build.log | grep "Google Maps SDK\|GMSApiKey"
```

**Se não aparecer "✅ Google Maps SDK inicializado":**
1. Verificar `ios/Runner/Info.plist` linha 81
2. Confirmar que chave é válida
3. Verificar no Google Cloud Console se APIs estão ativadas:
   - Maps SDK for iOS ✅
   - Directions API ✅
   - Places API ✅
   - Geocoding API ✅

**Adicionar mais configurações no Info.plist:**
```xml
<key>GMSServices</key>
<dict>
  <key>APIKey</key>
  <string>AIzaSyCTlAYLa9K04yfP65Qjg83vqoXhjee5Z2Q</string>
</dict>
```

### **Solução 2: Câmera Não Segue - Forçar Atualização**

**Problema:** `LatLng` é uma classe com `==` baseado em referência, não em valor.

**Correção:** Usar `Key` ou forçar rebuild explicitamente.

#### **Opção A: Adicionar Key ao RouteMapView**

```dart
RouteMapView(
  key: ValueKey('${_currentLocation?.latitude}_${_currentLocation?.longitude}'),
  // ... resto dos parâmetros
)
```

Isso força Flutter a reconstruir o widget quando a posição muda.

#### **Opção B: Criar método para atualizar câmera diretamente**

```dart
// Em journey_page.dart
GoogleMapController? _mapController;

void _updateMapCamera() {
  if (_mapController != null && _currentLocation != null) {
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          zoom: 18.0,
          tilt: 55.0,
        ),
      ),
    );
  }
}

// Chamar em _startLocationTracking:
_locationSubscription = Geolocator.getPositionStream(...).listen((position) {
  setState(() {
    _currentLocation = position;
  });
  
  _updateMapCamera(); // 🆕 Atualizar câmera diretamente
});
```

#### **Opção C: Usar StreamBuilder**

```dart
// Em _buildActiveJourneyView:
StreamBuilder<Position>(
  stream: Geolocator.getPositionStream(...),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return RouteMapView(
        currentPosition: LatLng(
          snapshot.data!.latitude,
          snapshot.data!.longitude,
        ),
        // ...
      );
    }
    return RouteMapView(...); // Fallback
  },
)
```

### **Solução 3: Modo Debug - Simplificado**

Para testar se o problema é de configuração do Maps, criar um mapa minimal:

```dart
// Test: simple_map_test.dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(-21.1704, -47.8103),
    zoom: 15.0,
  ),
  mapType: MapType.normal,
  myLocationEnabled: true,
  onMapCreated: (controller) {
    print('✅ Mapa criado!');
  },
)
```

Se este mapa mostrar detalhes → problema é no `RouteMapView`  
Se este mapa NÃO mostrar detalhes → problema é na configuração do SDK

## 📝 Checklist de Debug

### **Para o Mapa Sem Detalhes:**
- [ ] Verificar logs: "Google Maps SDK inicializado"
- [ ] Confirmar API Key no Info.plist
- [ ] Verificar APIs habilitadas no Google Cloud
- [ ] Testar com mapa simplificado
- [ ] Verificar conexão de internet do simulador
- [ ] Limpar build: `flutter clean && flutter pub get`

### **Para Câmera Não Seguindo:**
- [ ] Confirmar logs: "Posição atualizada"
- [ ] Verificar se `didUpdateWidget` é chamado
- [ ] Implementar Opção A (ValueKey)
- [ ] OU implementar Opção B (atualização direta)
- [ ] OU implementar Opção C (StreamBuilder)
- [ ] Testar atualização manual da câmera

## 🎯 Prioridade

**CRÍTICO:**
1. ✅ Mapa aparece (resolvido)
2. 🟡 Mapa com detalhes (pendente)
3. 🟡 Câmera seguindo (pendente)

**IMPORTANTE:**
4. Seta do veículo customizada
5. Rotação do mapa (bearing)
6. Card de navegação melhorado

## 💡 Recomendação Imediata

**Implementar Opção A (mais simples):**

```dart
// Em journey_page.dart, linha ~950
RouteMapView(
  key: ValueKey('map_${_currentLocation?.latitude ?? 0}_${_currentLocation?.longitude ?? 0}'),
  originLat: _routeOriginLat!,
  originLng: _routeOriginLng!,
  destLat: _routeDestLat!,
  destLng: _routeDestLng!,
  polyline: _routePolyline,
  destinationName: _routeDestinationName,
  isNavigationMode: _isNavigationMode,
  currentPosition: _currentLocation != null 
      ? LatLng(_currentLocation!.latitude, _currentLocation!.longitude)
      : null,
),
```

Isso força Flutter a recriar o `RouteMapView` toda vez que a posição muda, garantindo que `didUpdateWidget` seja chamado.

---

**Status:** 🔴 **BLOQUEADO** - Precisa correção antes de continuar

