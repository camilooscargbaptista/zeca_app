# 🚗 Implementação CarPlay & Android Auto - ZECA App

**Objetivo:** Permitir que motoristas usem o app ZECA na tela multimídia do carro  
**Data:** 30 de novembro de 2025  
**Status:** 📝 Planejamento

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [CarPlay (iOS)](#carplay-ios)
3. [Android Auto](#android-auto)
4. [Funcionalidades Recomendadas](#funcionalidades-recomendadas)
5. [Restrições e Limitações](#restrições-e-limitações)
6. [Roadmap de Implementação](#roadmap-de-implementação)

---

## 🎯 Visão Geral

### O que é possível?

**CarPlay** e **Android Auto** permitem que apps específicos sejam espelhados/executados na tela do carro, mas com **restrições importantes** de segurança.

### ⚠️ IMPORTANTE: Categorias Permitidas

Apple e Google **NÃO** permitem todos os tipos de apps. Categorias permitidas:

#### ✅ Categorias Aprovadas:
1. **Navegação** - Apps de mapas e direções
2. **Áudio** - Música, podcasts, audiobooks
3. **Mensagens** - Comunicação (com limitações)
4. **VoIP** - Chamadas de voz
5. **Carregamento EV** - Estações de carregamento elétrico
6. **Estacionamento** - Encontrar e pagar estacionamento
7. **Quick Food Ordering** - Pedidos rápidos de comida

#### ❌ NÃO Permitido (sem aprovação especial):
- Apps genéricos de negócios
- Apps de produtividade
- Apps de rastreamento de frotas (nosso caso!)
- Apps de gerenciamento

### 🎯 Nossa Situação - ZECA App

O ZECA é um **app de rastreamento de jornadas e abastecimento**. Para usar CarPlay/Android Auto, precisamos:

**Opção 1: Categoria Navegação** ✅ RECOMENDADO
- Focar no **tracking GPS em tempo real**
- Mostrar **rota da jornada** no mapa
- Informações de **próximos postos de abastecimento**
- Isso se enquadra como "navegação auxiliar"

**Opção 2: Solicitar Aprovação Especial** ⚠️ DIFÍCIL
- Aplicar para categoria especial de "Fleet Management"
- Requer justificativa de segurança
- Aprovação pode levar meses
- Sem garantia de aprovação

---

## 📱 CarPlay (iOS)

### Passo 1: Configuração Inicial

#### 1.1. Adicionar Entitlement

Criar arquivo: `ios/Runner/Runner.entitlements`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Entitlements existentes... -->
    
    <!-- CarPlay Entitlement -->
    <key>com.apple.developer.carplay-navigation</key>
    <true/>
</dict>
</plist>
```

#### 1.2. Atualizar Info.plist

Adicionar ao `ios/Runner/Info.plist`:

```xml
<!-- CarPlay Configuration -->
<key>UIApplicationSceneManifest</key>
<dict>
    <key>UISceneConfigurations</key>
    <dict>
        <!-- Configuração existente do app -->
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>UISceneConfigurationName</key>
                <string>Default Configuration</string>
                <key>UISceneDelegateClassName</key>
                <string>SceneDelegate</string>
            </dict>
        </array>
        
        <!-- CarPlay Scene -->
        <key>CPTemplateApplicationSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>UISceneConfigurationName</key>
                <string>CarPlay Configuration</string>
                <key>UISceneDelegateClassName</key>
                <string>CarPlaySceneDelegate</string>
            </dict>
        </array>
    </dict>
</dict>

<!-- Background Modes (já existe, adicionar 'external-accessory') -->
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
    <string>location</string>
    <string>fetch</string>
    <string>processing</string>
    <string>external-accessory</string> <!-- NOVO -->
</array>

<!-- CarPlay Audio (se for usar áudio) -->
<key>UISupportedExternalAccessoryProtocols</key>
<array>
    <string>com.apple.carplay</string>
</array>
```

#### 1.3. Criar CarPlaySceneDelegate

Arquivo: `ios/Runner/CarPlaySceneDelegate.swift`

```swift
import UIKit
import CarPlay

@available(iOS 13.0, *)
class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var window: CPWindow?
    
    // MARK: - Scene Lifecycle
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = interfaceController
        self.window = templateApplicationScene.carWindow
        
        // Configurar tela inicial do CarPlay
        setupCarPlayInterface()
    }
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = nil
    }
    
    // MARK: - Setup
    
    private func setupCarPlayInterface() {
        guard let interfaceController = interfaceController else { return }
        
        // Template de Navegação (Map)
        let mapTemplate = createMapTemplate()
        
        // Definir como root template
        interfaceController.setRootTemplate(mapTemplate, animated: true)
    }
    
    private func createMapTemplate() -> CPMapTemplate {
        let mapTemplate = CPMapTemplate()
        mapTemplate.showPanningInterface(animated: false)
        
        // Botões de ação
        let startJourneyButton = CPBarButton(
            title: "Iniciar Jornada"
        ) { [weak self] _ in
            self?.startJourney()
        }
        
        let nearbyStationsButton = CPBarButton(
            title: "Postos Próximos"
        ) { [weak self] _ in
            self?.showNearbyStations()
        }
        
        mapTemplate.leadingNavigationBarButtons = [startJourneyButton]
        mapTemplate.trailingNavigationBarButtons = [nearbyStationsButton]
        
        return mapTemplate
    }
    
    // MARK: - Actions
    
    private func startJourney() {
        // Chamar método channel para Flutter
        let flutterVC = (UIApplication.shared.delegate as? AppDelegate)?.window??.rootViewController as? FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.zeca.app/carplay",
            binaryMessenger: flutterVC!.binaryMessenger
        )
        
        channel.invokeMethod("startJourney", arguments: nil)
    }
    
    private func showNearbyStations() {
        // Mostrar lista de postos próximos
        let listTemplate = createStationsList()
        interfaceController?.pushTemplate(listTemplate, animated: true)
    }
    
    private func createStationsList() -> CPListTemplate {
        // TODO: Buscar postos do Flutter
        let items = [
            CPListItem(text: "Posto Shell - 2.5 km", detailText: "R$ 5,89/L"),
            CPListItem(text: "Posto Ipiranga - 4.1 km", detailText: "R$ 5,79/L"),
            CPListItem(text: "Posto BR - 5.8 km", detailText: "R$ 5,95/L"),
        ]
        
        let section = CPListSection(items: items)
        let listTemplate = CPListTemplate(title: "Postos Próximos", sections: [section])
        
        return listTemplate
    }
}
```

#### 1.4. Atualizar AppDelegate

Arquivo: `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter
import CarPlay

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private var carPlayChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        
        // Canal de comunicação com Flutter
        carPlayChannel = FlutterMethodChannel(
            name: "com.zeca.app/carplay",
            binaryMessenger: controller.binaryMessenger
        )
        
        carPlayChannel?.setMethodCallHandler { [weak self] (call, result) in
            self?.handleCarPlayMethod(call: call, result: result)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func handleCarPlayMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateJourneyStatus":
            if let args = call.arguments as? [String: Any],
               let isActive = args["isActive"] as? Bool {
                // Atualizar UI do CarPlay
                result(true)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
            }
            
        case "updateLocation":
            if let args = call.arguments as? [String: Any],
               let lat = args["latitude"] as? Double,
               let lng = args["longitude"] as? Double {
                // Atualizar mapa do CarPlay
                result(true)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
```

---

### Passo 2: Lado Flutter

#### 2.1. Criar CarPlay Service

Arquivo: `lib/core/services/carplay_service.dart`

```dart
import 'package:flutter/services.dart';

class CarPlayService {
  static const MethodChannel _channel = MethodChannel('com.zeca.app/carplay');
  
  /// Verifica se está conectado ao CarPlay
  Future<bool> isCarPlayConnected() async {
    try {
      final bool? connected = await _channel.invokeMethod('isConnected');
      return connected ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Notifica CarPlay sobre início de jornada
  Future<void> updateJourneyStatus({required bool isActive}) async {
    try {
      await _channel.invokeMethod('updateJourneyStatus', {
        'isActive': isActive,
      });
    } catch (e) {
      print('Erro ao atualizar status de jornada no CarPlay: $e');
    }
  }
  
  /// Atualiza localização no mapa do CarPlay
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _channel.invokeMethod('updateLocation', {
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      print('Erro ao atualizar localização no CarPlay: $e');
    }
  }
  
  /// Envia lista de postos próximos para CarPlay
  Future<void> updateNearbyStations(List<Map<String, dynamic>> stations) async {
    try {
      await _channel.invokeMethod('updateNearbyStations', {
        'stations': stations,
      });
    } catch (e) {
      print('Erro ao atualizar postos no CarPlay: $e');
    }
  }
  
  /// Listener para comandos do CarPlay
  void setCarPlayMethodCallHandler(
    Future<dynamic> Function(MethodCall call) handler
  ) {
    _channel.setMethodCallHandler(handler);
  }
}
```

#### 2.2. Integrar no Journey Tracking

```dart
// Em tracking_bloc.dart ou onde gerencia a jornada

class JourneyTrackingBloc extends Bloc<JourneyEvent, JourneyState> {
  final CarPlayService _carPlayService;
  
  JourneyTrackingBloc(this._carPlayService) : super(JourneyInitial()) {
    // Configurar listener de comandos do CarPlay
    _setupCarPlayListener();
    
    // Handlers normais...
  }
  
  void _setupCarPlayListener() {
    _carPlayService.setCarPlayMethodCallHandler((call) async {
      switch (call.method) {
        case 'startJourney':
          add(StartJourneyEvent());
          break;
        case 'stopJourney':
          add(StopJourneyEvent());
          break;
        case 'showNearbyStations':
          add(LoadNearbyStationsEvent());
          break;
      }
    });
  }
  
  Future<void> _onLocationUpdated(
    LocationUpdatedEvent event,
    Emitter<JourneyState> emit,
  ) async {
    // Lógica normal...
    
    // Atualizar CarPlay
    await _carPlayService.updateLocation(
      latitude: event.latitude,
      longitude: event.longitude,
    );
  }
  
  Future<void> _onJourneyStarted(
    JourneyStartedEvent event,
    Emitter<JourneyState> emit,
  ) async {
    // Lógica normal...
    
    // Notificar CarPlay
    await _carPlayService.updateJourneyStatus(isActive: true);
  }
}
```

---

## 🤖 Android Auto

### Passo 1: Configuração Inicial

#### 1.1. Adicionar Dependências

Arquivo: `android/app/build.gradle`

```gradle
dependencies {
    // Dependências existentes...
    
    // Android Auto
    implementation 'androidx.car.app:app:1.4.0'
    implementation 'androidx.car.app:app-automotive:1.4.0'
}
```

#### 1.2. Atualizar AndroidManifest.xml

```xml
<manifest>
    <!-- Permissões existentes... -->
    
    <!-- Android Auto -->
    <uses-feature
        android:name="android.hardware.type.automotive"
        android:required="false" />
    
    <application>
        <!-- Activities existentes... -->
        
        <!-- Android Auto Car App Service -->
        <service
            android:name=".ZecaCarAppService"
            android:exported="true"
            android:foregroundServiceType="location">
            <intent-filter>
                <action android:name="androidx.car.app.CarAppService" />
                <category android:name="androidx.car.app.category.NAVIGATION" />
            </intent-filter>
        </service>
        
        <!-- Metadata -->
        <meta-data
            android:name="androidx.car.app.minCarApiLevel"
            android:value="1" />
    </application>
</manifest>
```

#### 1.3. Criar CarAppService

Arquivo: `android/app/src/main/kotlin/com/zeca/app/ZecaCarAppService.kt`

```kotlin
package com.zeca.app

import android.content.Intent
import androidx.car.app.CarAppService
import androidx.car.app.Screen
import androidx.car.app.Session
import androidx.car.app.validation.HostValidator

class ZecaCarAppService : CarAppService() {
    
    override fun createHostValidator(): HostValidator {
        return HostValidator.ALLOW_ALL_HOSTS_VALIDATOR
    }
    
    override fun onCreateSession(): Session {
        return ZecaCarSession()
    }
}

class ZecaCarSession : Session() {
    
    override fun onCreateScreen(intent: Intent): Screen {
        return ZecaMapScreen(carContext)
    }
}
```

#### 1.4. Criar Map Screen

Arquivo: `android/app/src/main/kotlin/com/zeca/app/ZecaMapScreen.kt`

```kotlin
package com.zeca.app

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.*
import androidx.car.app.navigation.model.NavigationTemplate

class ZecaMapScreen(carContext: CarContext) : Screen(carContext) {
    
    override fun onGetTemplate(): Template {
        return NavigationTemplate.Builder()
            .setActionStrip(createActionStrip())
            .setMapActionStrip(createMapActionStrip())
            .build()
    }
    
    private fun createActionStrip(): ActionStrip {
        return ActionStrip.Builder()
            .addAction(
                Action.Builder()
                    .setTitle("Iniciar Jornada")
                    .setOnClickListener {
                        startJourney()
                    }
                    .build()
            )
            .build()
    }
    
    private fun createMapActionStrip(): ActionStrip {
        return ActionStrip.Builder()
            .addAction(
                Action.Builder()
                    .setIcon(CarIcon.APP_ICON)
                    .setOnClickListener {
                        showNearbyStations()
                    }
                    .build()
            )
            .build()
    }
    
    private fun startJourney() {
        // Chamar Flutter via Method Channel
        // TODO: Implementar comunicação com Flutter
    }
    
    private fun showNearbyStations() {
        screenManager.push(StationsListScreen(carContext))
    }
}
```

---

## 🎯 Funcionalidades Recomendadas

### Funcionalidades Essenciais (MVP)

1. **Visualização de Jornada Ativa** ✅
   - Mapa mostrando rota atual
   - Status: "Em viagem" / "Parado"
   - Quilometragem percorrida

2. **Botão Iniciar/Finalizar Jornada** ✅
   - Um botão grande e seguro
   - Confirmação por voz (opcional)

3. **Postos Próximos** ✅
   - Lista de postos em até 10 km
   - Preço do combustível
   - Distância

4. **Informações de Jornada** ✅
   - Tempo decorrido
   - KM percorridos
   - Próximo ponto de parada

### Funcionalidades Avançadas (Fase 2)

5. **Notificações por Voz** 🔊
   - "Você está próximo de um posto parceiro"
   - "Jornada registrada com sucesso"

6. **Integração com Assistente** 🎤
   - "Ei Siri/Google, iniciar jornada no ZECA"
   - "Ei Siri/Google, mostrar postos próximos"

7. **Alertas de Manutenção** ⚠️
   - "Atenção: próxima revisão em 500 km"
   - "Veículo com checklist pendente"

---

## ⚠️ Restrições e Limitações

### Limitações de Interface

#### CarPlay:
- **Máximo 2 níveis de navegação**
- **Sem teclado** (apenas listas e botões)
- **Sem gestos complexos** (swipe, pinch)
- **Templates pré-definidos** (não pode customizar demais)
- **Botões grandes** (mínimo 44x44 pontos)

#### Android Auto:
- **Templates limitados** (Navigation, List, Grid)
- **Máximo 6 itens por lista** (para segurança)
- **Sem vídeo ou imagens complexas**
- **Sem entrada de texto livre**
- **API restritiva** para evitar distração

### Limitações de Aprovação

1. **Apple CarPlay:**
   - Requer **entitlement especial** da Apple
   - Processo de aprovação: **2-4 semanas**
   - Pode exigir demonstração do uso seguro
   - Categoria "Navigation" é mais fácil de aprovar

2. **Android Auto:**
   - Requer **review manual** do Google
   - Testes de **segurança ao dirigir**
   - Deve seguir **Driver Distraction Guidelines**
   - Aprovação: **1-3 semanas**

---

## 📅 Roadmap de Implementação

### Fase 1: Preparação (1-2 semanas)

- [ ] Criar especificação detalhada das telas
- [ ] Definir fluxo de usuário para CarPlay/Android Auto
- [ ] Preparar assets (ícones específicos para carro)
- [ ] Solicitar entitlements necessários

### Fase 2: Desenvolvimento iOS (2-3 semanas)

- [ ] Configurar CarPlay no Xcode
- [ ] Implementar CarPlaySceneDelegate
- [ ] Criar templates de navegação
- [ ] Integrar com Flutter via Method Channels
- [ ] Testar em simulador do CarPlay
- [ ] Testar em carro real (se disponível)

### Fase 3: Desenvolvimento Android (2-3 semanas)

- [ ] Adicionar dependências Android Auto
- [ ] Criar CarAppService
- [ ] Implementar telas de navegação
- [ ] Integrar com Flutter
- [ ] Testar em Desktop Head Unit (DHU)
- [ ] Testar em carro real (se disponível)

### Fase 4: Testes e Aprovação (2-4 semanas)

- [ ] Testes de usabilidade em diferentes veículos
- [ ] Testes de segurança (Driver Distraction)
- [ ] Submeter para review da Apple
- [ ] Submeter para review do Google
- [ ] Correções baseadas em feedback
- [ ] Aprovação final

### Fase 5: Lançamento (1 semana)

- [ ] Deploy em produção (TestFlight primeiro)
- [ ] Monitorar crashes específicos de CarPlay/Auto
- [ ] Coletar feedback de usuários
- [ ] Iterações de melhoria

---

## 🧪 Como Testar

### Testar CarPlay sem Carro

1. **Simulador do Xcode:**
   ```bash
   # No Xcode
   I/O → External Displays → CarPlay
   ```

2. **Dongle CarPlay:**
   - Comprar dongle USB de CarPlay (~$50)
   - Conectar ao Mac
   - Testar em ambiente real

### Testar Android Auto sem Carro

1. **Desktop Head Unit (DHU):**
   ```bash
   # Instalar DHU
   cd $ANDROID_SDK/extras/google/auto/
   ./desktop-head-unit
   
   # Conectar dispositivo Android via USB
   # O DHU simula o display do carro
   ```

2. **App Android Auto:**
   - Instalar app "Android Auto" no celular
   - Modo desenvolvedor: permite testar sem carro
   - Settings → About → Tap version 10 times

---

## 📚 Recursos Úteis

### Documentação Oficial

- [CarPlay - Apple Developer](https://developer.apple.com/carplay/)
- [Android Auto - Google Developer](https://developer.android.com/training/cars)
- [CarPlay Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/carplay)
- [Android Auto Design Guidelines](https://developer.android.com/training/cars/navigation)

### Plugins Flutter (Opcionais)

Não há plugins Flutter oficiais maduros para CarPlay/Android Auto ainda. A implementação precisa ser **nativa** com comunicação via **Method Channels**.

---

## 💰 Custos Estimados

### Desenvolvimento
- **Desenvolvimento iOS CarPlay:** 80-120 horas
- **Desenvolvimento Android Auto:** 60-100 horas
- **Testes e Certificação:** 40-60 horas
- **Total:** ~180-280 horas

### Hardware para Testes
- **Dongle CarPlay:** ~$50-100
- **Android Auto DHU:** Grátis (software)
- **Teste em carro real:** Variável (aluguel ou parceria)

---

## ⚡ Início Rápido

### Para começar AGORA:

1. **Decisão estratégica:**
   - Definir se vale a pena o investimento
   - ZECA tem público que dirigir regularmente? ✅ Sim!
   - ROI justifica 200+ horas de dev?

2. **Solicitar entitlements:**
   - Apple: App Store Connect → Certificates → Entitlements
   - Google: Play Console → Advanced Settings

3. **Criar POC simples:**
   - Uma tela com botão "Iniciar Jornada"
   - Teste no simulador
   - Validar viabilidade técnica

---

## 🎯 Conclusão

### ✅ Recomendação

**SIM**, vale a pena implementar CarPlay/Android Auto para o ZECA porque:

1. **Segurança:** Motoristas não precisam pegar celular enquanto dirigem
2. **UX Superior:** Interface otimizada para uso no carro
3. **Diferencial Competitivo:** Poucos apps de frota têm isso
4. **Adequação ao uso:** App é usado principalmente durante direção

### 📋 Próximos Passos

1. Aprovar roadmap com stakeholders
2. Solicitar entitlements Apple/Google (fazer primeiro!)
3. Criar POC para validação técnica
4. Desenvolver MVP com funcionalidades essenciais
5. Testar extensivamente antes de submeter

---

**Criado em:** 30/11/2025  
**Autor:** AI Assistant  
**Status:** 📝 Aguardando aprovação para iniciar desenvolvimento

