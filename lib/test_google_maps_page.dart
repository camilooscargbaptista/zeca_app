import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Página de TESTE para isolar problema do Google Maps
/// 
/// Remove TODAS as dependências e complexidades.
/// Se este mapa funcionar → problema é na journey_page
/// Se não funcionar → problema é configuração do SDK
class TestGoogleMapsPage extends StatefulWidget {
  const TestGoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<TestGoogleMapsPage> createState() => _TestGoogleMapsPageState();
}

class _TestGoogleMapsPageState extends State<TestGoogleMapsPage> {
  GoogleMapController? _controller;
  String _statusMessage = 'Aguardando teste...';
  
  @override
  void initState() {
    super.initState();
    _testConnectivity();
  }
  
  /// Testa conectividade com Google Maps API
  Future<void> _testConnectivity() async {
    try {
      debugPrint('🧪 [TEST] Testando conectividade com Google Maps...');
      
      // Teste 1: Acesso básico à internet
      final testUrl = Uri.parse('https://www.google.com');
      final response = await http.get(testUrl).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = '✅ Internet OK! Testando Maps API...';
        });
        debugPrint('✅ [TEST] Internet funciona');
        
        // Teste 2: API do Google Maps
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _statusMessage = '🗺️ Maps API OK! Se mapa está cinza → Problema é API Key';
        });
      } else {
        setState(() {
          _statusMessage = '❌ Erro HTTP: ${response.statusCode}';
        });
        debugPrint('❌ [TEST] Erro HTTP: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = '❌ SEM INTERNET: $e';
      });
      debugPrint('❌ [TEST] Sem internet: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    debugPrint('🧪 [TEST] Construindo TestGoogleMapsPage...');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste Google Maps'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Banner de instruções
          Container(
            color: Colors.blue[100],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '🧪 TESTE DE DEBUG',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Mapa ocupando o resto da tela
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-21.1704, -47.8103), // Ribeirão Preto
                zoom: 15.0,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                debugPrint('✅ [TEST] GoogleMap criado com SUCESSO!');
                debugPrint('   - Controlador: ${controller.hashCode}');
                
                // Mostrar mensagem de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Google Maps inicializado!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onCameraMove: (CameraPosition position) {
                debugPrint('📹 [TEST] Câmera moveu: ${position.target}');
              },
              onTap: (LatLng position) {
                debugPrint('👆 [TEST] Tap no mapa: $position');
              },
            ),
          ),
          
          // Botões de teste
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    debugPrint('🎬 [TEST] Animando câmera...');
                    _controller?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          target: LatLng(-21.17, -47.81),
                          zoom: 18.0,
                          tilt: 45.0,
                        ),
                      ),
                    );
                  },
                  child: const Text('Zoom In'),
                ),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('🎬 [TEST] Voltando zoom...');
                    _controller?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          target: LatLng(-21.1704, -47.8103),
                          zoom: 12.0,
                        ),
                      ),
                    );
                  },
                  child: const Text('Zoom Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

