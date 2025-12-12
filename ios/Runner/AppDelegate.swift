import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import CoreLocation
// GoogleMaps REMOVIDO - google_maps_flutter desativado
// import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  var locationManager: CLLocationManager?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("🚀 Iniciando AppDelegate com Push Notifications")
    
    // Google Maps SDK REMOVIDO - google_maps_flutter desativado
    // if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String {
    //   GMSServices.provideAPIKey(apiKey)
    //   print("✅ Google Maps SDK inicializado com API Key")
    // } else {
    //   print("❌ GMSApiKey não encontrado no Info.plist")
    // }
    print("⚠️ Google Maps SDK desativado")
    
    // Firebase já é inicializado no Flutter (main.dart)
    // Mas precisamos configurar o delegate para push notifications
    
    // IMPORTANTE: Configurar Firebase Messaging delegate ANTES de solicitar permissões
    Messaging.messaging().delegate = self
    print("✅ Firebase Messaging delegate configurado")
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      print("✅ UNUserNotificationCenter delegate configurado")
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { [weak self] granted, error in
          if let error = error {
            print("❌ Erro ao solicitar permissão de notificação: \(error.localizedDescription)")
          } else {
            print("✅ Permissão de notificação: \(granted ? "concedida" : "negada")")
            
            // Registrar para notificações remotas APÓS permissão ser concedida
            if granted {
              DispatchQueue.main.async {
                application.registerForRemoteNotifications()
                print("📱 Registrado para notificações remotas após permissão concedida")
              }
            }
          }
        }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
      // Registrar imediatamente para iOS < 10
      application.registerForRemoteNotifications()
      print("📱 Registrado para notificações remotas (iOS < 10)")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Configurar location manager para background tracking
    setupLocationManager()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - Location Manager Setup
  private func setupLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    locationManager?.distanceFilter = 30 // 30 metros
    
    // BACKGROUND LOCATION DESATIVADO (flutter_background_geolocation removido)
    // Estas linhas causam crash sem UIBackgroundModes location no Info.plist
    // locationManager?.allowsBackgroundLocationUpdates = true
    // locationManager?.pausesLocationUpdatesAutomatically = false
    // locationManager?.showsBackgroundLocationIndicator = true
    
    print("⚠️ Location Manager configurado (foreground only)")
    
    // Verificar status de autorização e solicitar se necessário
    checkLocationAuthorization()
  }
  
  private func checkLocationAuthorization() {
    let status: CLAuthorizationStatus
    if #available(iOS 14.0, *) {
      status = locationManager?.authorizationStatus ?? .notDetermined
    } else {
      status = CLLocationManager.authorizationStatus()
    }
    
    print("📍 Status atual de localização: \(status.rawValue)")
    
    switch status {
    case .notDetermined:
      print("📍 Solicitando permissão de localização...")
      locationManager?.requestWhenInUseAuthorization()
      // Note: requestAlwaysAuthorization só pode ser chamado DEPOIS de conceder whenInUse
    case .authorizedWhenInUse:
      print("⚠️ Permissão 'When In Use' concedida")
      print("💡 Para background tracking, solicite 'Always' nas configurações")
      // Mesmo com whenInUse, vamos iniciar para que funcione em foreground
      locationManager?.startUpdatingLocation()
    case .authorizedAlways:
      print("✅ Permissão 'Always' concedida - iniciando tracking")
      locationManager?.startUpdatingLocation()
    case .denied:
      print("❌ Permissão de localização negada")
    case .restricted:
      print("❌ Permissão de localização restrita")
    @unknown default:
      print("⚠️ Status de localização desconhecido")
    }
  }
  
  // Registrar token APNS
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("✅ APNS token recebido: \(tokenString)")
    print("📦 Tamanho do token: \(deviceToken.count) bytes")
    
    // Configurar APNS token no Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    print("✅ APNS token configurado no Firebase Messaging")
    
    // Forçar atualização do FCM token após APNS ser configurado
    Messaging.messaging().token { token, error in
      if let error = error {
        print("❌ Erro ao obter FCM token após APNS: \(error.localizedDescription)")
      } else if let token = token {
        print("✅ FCM token obtido após APNS: \(token)")
      }
    }
  }
  
  // Erro ao registrar para notificações remotas
  override func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("❌ Erro ao registrar para notificações remotas: \(error.localizedDescription)")
    print("❌ Código do erro: \((error as NSError).code)")
    print("❌ Domínio do erro: \((error as NSError).domain)")
    
    // Verificar se é erro de provisioning profile
    if (error as NSError).code == 3010 {
      print("⚠️ Erro 3010: Provisioning Profile não tem Push Notifications habilitado")
      print("💡 Verifique no Apple Developer Portal se Push Notifications está habilitado no App ID")
      print("💡 Verifique se o Provisioning Profile inclui Push Notifications capability")
    }
  }
}

// Extensão para Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("📱 Token FCM recebido: \(fcmToken ?? "nil")")
    if let token = fcmToken {
      print("✅ Token FCM configurado: \(token)")
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // iOS vai chamar isso em background também quando allowsBackgroundLocationUpdates = true
    // O plugin geolocator vai capturar essas atualizações automaticamente
    if let location = locations.last {
      print("📍 [iOS Background] Localização atualizada: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    // Suporta iOS 12+
    let status: CLAuthorizationStatus
    if #available(iOS 14.0, *) {
      status = manager.authorizationStatus
    } else {
      status = CLLocationManager.authorizationStatus()
    }
    
    print("🔐 Status de autorização de localização mudou: \(status.rawValue)")
    
    switch status {
    case .authorizedAlways:
      print("✅ Permissão 'Always' concedida - rastreamento em background habilitado")
      print("📍 Iniciando rastreamento contínuo de localização...")
      manager.startUpdatingLocation()
    case .authorizedWhenInUse:
      print("⚠️ Permissão 'When In Use' concedida - rastreamento limitado ao foreground")
      print("💡 Para rastreamento em background:")
      print("   Ajustes > ZECA App > Localização > Sempre Permitir")
      manager.startUpdatingLocation()
    case .denied:
      print("❌ Permissão de localização negada")
      print("💡 Vá em Ajustes > ZECA App > Localização para habilitar")
    case .restricted:
      print("❌ Permissão de localização restrita (controle parental ou MDM)")
    case .notDetermined:
      print("⏳ Permissão de localização ainda não determinada")
      print("📍 Solicitando permissão when in use...")
      manager.requestWhenInUseAuthorization()
    @unknown default:
      print("⚠️ Status de localização desconhecido")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("❌ Erro no Location Manager: \(error.localizedDescription)")
  }
}
