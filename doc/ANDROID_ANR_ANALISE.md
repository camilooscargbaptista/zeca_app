# 🐛 Análise: Android ANR (App Not Responding)

## 📊 Problema Identificado

**Sintoma:** App travou com mensagem "ZECA App isn't responding"

### **Sequência de Eventos:**

1. ✅ Usuário digitou destino: "Rua Dois de Julho, 694"
2. ✅ Places API retornou resultados (5 lugares)
3. ✅ Detalhes do lugar obtidos: `(-21.1698963, -47.8250198)`
4. ✅ Permissão de localização concedida
5. 📍 App tentou obter posição atual
6. ❌ **TRAVAMENTO após 4+ segundos**

### **Logs Críticos:**

```
I/flutter: 📍 Obtendo posição atual...
D/EGL_emulation: app_time_stats: avg=2399.60ms min=404.03ms max=4395.18ms
I/com.zeca.app: Wrote stack traces to tombstoned
```

---

## 🔍 Causa Raiz

**Timeout ao obter localização GPS no emulador Android.**

### **Por que acontece:**

1. **Emulador vs Device Real:**
   - Emuladores Android têm GPS simulado
   - Pode ser mais lento ou não responder imediatamente
   - iOS Simulator responde mais rápido

2. **Localização Configurada vs Obtida:**
   - `adb emu geo fix` configura coordenadas fixas
   - Mas o app usa `geolocator` que pode não receber resposta rápida

3. **UI Thread Bloqueada:**
   - Se `getCurrentPosition()` está sendo chamado de forma síncrona
   - Bloqueia a UI thread por mais de 5s
   - Android mata o app (ANR)

---

## ✅ Soluções Propostas

### **Solução 1: Timeout Menor no Geolocator**

Atualmente, o timeout padrão pode ser muito longo.

**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

```dart
// Adicionar timeout explícito
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
  timeLimit: Duration(seconds: 3), // ⭐ TIMEOUT DE 3s
);
```

### **Solução 2: Loading State com Timeout**

Adicionar indicador de loading e timeout:

```dart
Future<Position?> _getPositionWithTimeout() async {
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(
      Duration(seconds: 3),
      onTimeout: () {
        // Usar localização do emulador ou última conhecida
        return _getLastKnownOrDefault();
      },
    );
  } catch (e) {
    debugPrint('❌ Erro ao obter posição: $e');
    return _getLastKnownOrDefault();
  }
}

Future<Position> _getLastKnownOrDefault() async {
  try {
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) return lastKnown;
  } catch (e) {
    debugPrint('⚠️ Sem última posição conhecida');
  }
  
  // Fallback: Ribeirão Preto (emulador)
  return Position(
    latitude: -21.1704,
    longitude: -47.8103,
    timestamp: DateTime.now(),
    accuracy: 10.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
}
```

### **Solução 3: Usar Background Geolocation**

O `flutter_background_geolocation` já está configurado e é mais robusto:

```dart
// Em vez de Geolocator.getCurrentPosition()
final location = await bg.BackgroundGeolocation.getCurrentPosition(
  timeout: 3, // segundos
  maximumAge: 5000, // aceitar cache de 5s
);
```

---

## 🚀 Solução Imediata (Workaround)

Para testar no emulador sem travar:

### **Opção A: Usar Device Físico**

Devices físicos têm GPS real e respondem mais rápido.

```bash
# Conectar device Android via USB
adb devices

# Rodar no device
flutter run -d <DEVICE_ID>
```

### **Opção B: Configurar GPS Mock no Emulador**

1. Abrir emulador Android
2. Clicar em **"..." (Extended Controls)**
3. Ir em **"Location"**
4. Ativar **"GPS signal"**
5. Definir coordenadas: **Lat: -21.1704, Long: -47.8103**
6. Clicar em **"Send"**

### **Opção C: Pular Validação de Localização**

Temporariamente, comentar a verificação de localização:

```dart
// Comentar temporariamente para teste:
// final position = await Geolocator.getCurrentPosition(...);

// Usar coordenadas fixas do emulador:
final position = Position(
  latitude: -21.1704,
  longitude: -47.8103,
  timestamp: DateTime.now(),
  // ...
);
```

---

## 🎯 Implementação Recomendada

**Prioridade ALTA:** Adicionar timeout de 3s com fallback

```dart
Future<Position> _getSafePosition() async {
  try {
    // Tenta obter posição atual com timeout
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(
      Duration(seconds: 3),
      onTimeout: () async {
        debugPrint('⏱️ Timeout ao obter GPS, usando fallback...');
        
        // Tentar última posição conhecida
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          debugPrint('✅ Usando última posição conhecida');
          return last;
        }
        
        // Fallback final: coordenadas do emulador
        debugPrint('⚠️ Usando coordenadas padrão (Ribeirão Preto)');
        return Position(
          latitude: -21.1704,
          longitude: -47.8103,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      },
    );
    
    debugPrint('✅ Posição obtida: ${position.latitude}, ${position.longitude}');
    return position;
    
  } catch (e) {
    debugPrint('❌ Erro ao obter posição: $e');
    // Retornar posição padrão
    return Position(
      latitude: -21.1704,
      longitude: -47.8103,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }
}
```

---

##  📱 Diferenças iOS vs Android

| Aspecto | iOS | Android |
|---------|-----|---------|
| GPS Simulado | Rápido (~100ms) | Lento (2-4s) |
| ANR Timeout | Mais tolerante | 5s (mata app) |
| Background GPS | Funciona bem | Funciona bem |
| Permissões | Mais simples | Mais complexas |

---

## ✅ Próximos Passos

1. ✅ Implementar timeout de 3s com fallback
2. ⏳ Testar no Android novamente
3. ⏳ Se ainda travar → usar device físico
4. ⏳ Documentar comportamento esperado

---

**Status:** 🔴 **Bloqueado no Android (ANR)**  
**Workaround:** Implementar timeout + fallback para localização

