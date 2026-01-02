import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/services/api_service.dart';

class AutonomousVehicleFormPage extends StatefulWidget {
  final String? vehicleId;

  const AutonomousVehicleFormPage({Key? key, this.vehicleId}) : super(key: key);

  @override
  State<AutonomousVehicleFormPage> createState() => _AutonomousVehicleFormPageState();
}

class _AutonomousVehicleFormPageState extends State<AutonomousVehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _odometerController = TextEditingController();

  Set<String> _selectedFuelTypes = {};
  bool _hasArla = false;
  bool _isLoading = false;
  bool _isLoadingPlate = false;
  Timer? _debounceTimer;

  // Estado da consulta de placa
  bool _plateLookupDone = false;
  bool _plateLookupSuccess = false;
  Map<String, dynamic>? _vehicleData;

  bool get _isEditing => widget.vehicleId != null;

  final _plateMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA-#N##',
    filter: {
      "A": RegExp(r'[A-Za-z]'),
      "#": RegExp(r'[0-9]'),
      "N": RegExp(r'[A-Za-z0-9]'),
    },
    type: MaskAutoCompletionType.lazy,
  );

  final List<Map<String, dynamic>> _fuelTypes = [
    {'value': 'DIESEL_S10', 'label': 'Diesel S10', 'icon': Icons.local_gas_station},
    {'value': 'DIESEL_S500', 'label': 'Diesel S500', 'icon': Icons.local_gas_station},
    {'value': 'GASOLINA', 'label': 'Gasolina', 'icon': Icons.whatshot},
    {'value': 'ETANOL', 'label': 'Etanol', 'icon': Icons.eco},
  ];

  final List<String> _brands = [
    'Scania', 'Volvo', 'Mercedes-Benz', 'DAF', 'Iveco', 'Volkswagen', 'MAN',
    'Ford', 'Chevrolet', 'Fiat', 'Toyota', 'Honda', 'Hyundai', 'Renault',
    'Nissan', 'Kia', 'Peugeot', 'Citroën', 'Jeep', 'Mitsubishi',
    'BMW', 'Audi', 'Land Rover', 'Porsche', 'Jaguar', 'Subaru', 'Suzuki',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadVehicle();
    }
  }

  void _loadVehicle() {
    // TODO: Carregar dados do veículo da API
    _plateController.text = 'ABC-1234';
    _brandController.text = 'Scania';
    _modelController.text = 'R450';
    _yearController.text = '2022';
    _odometerController.text = '245320';
    setState(() {
      _selectedFuelTypes = {'DIESEL_S10'};
      _hasArla = false;
      _plateLookupDone = true;
      _plateLookupSuccess = true;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  void _onPlateChanged(String value) {
    if (_isEditing) return;

    _debounceTimer?.cancel();

    // Reset estado se placa mudar
    if (_plateLookupDone) {
      setState(() {
        _plateLookupDone = false;
        _plateLookupSuccess = false;
        _vehicleData = null;
        _brandController.clear();
        _modelController.clear();
        _yearController.clear();
        _colorController.clear();
        _selectedFuelTypes = {};
      });
    }

    final plate = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (plate.length != 7) return;
    if (!RegExp(r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$').hasMatch(plate)) return;

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _lookupPlate(plate);
    });
  }

  Future<void> _lookupPlate(String plate) async {
    setState(() => _isLoadingPlate = true);

    try {
      final apiService = ApiService();
      final response = await apiService.get('/vehicles/plate/$plate');

      debugPrint('[PlateAutoFill] Response success: ${response['success']}');\n\n      // IMPORTANT: Check ONLY success == true, not data presence\n      if (response['success'] == true) {\n        // ApiService wraps API response in {'success': true, 'data': API_RESPONSE}\n        // API returns: {'success': true, 'data': {vehicle_info}}\n        // So we need response['data']['data'] for actual vehicle data\n        final apiResponse = response['data'];\n        final apiSuccess = apiResponse['success'] == true;\n        final vehicleData = apiResponse['data'];\n        \n        debugPrint('[PlateAutoFill] API success: $apiSuccess, vehicleData: $vehicleData');\n        \n        if (apiSuccess && vehicleData != null) {\n          final brand = _normalizeBrand(vehicleData['brand']?.toString() ?? '');\n          final model = vehicleData['model']?.toString() ?? '';\n          final year = vehicleData['year']?.toString() ?? '';\n          final color = vehicleData['color']?.toString() ?? '';\n          final fuelType = vehicleData['fuelType']?.toString().toUpperCase() ?? '';\n\n          debugPrint('[PlateAutoFill] Data: brand=$brand, model=$model, year=$year, fuel=$fuelType');\n\n          setState(() {\n            _plateLookupDone = true;\n            _plateLookupSuccess = true;\n            _vehicleData = {\n              'brand': brand,\n              'model': model,\n              'year': year,\n              'color': color,\n              'fuelType': fuelType,\n            };\n            \n            // Preencher controllers para salvar - usar valor da API diretamente\n            _brandController.text = brand;\n            _modelController.text = model;\n            _yearController.text = year;\n            _colorController.text = color;\n            \n            // Mapear combustível\n            _selectedFuelTypes = _mapFuelType(fuelType);\n            debugPrint('[PlateAutoFill] Selected fuels: $_selectedFuelTypes');\n          });\n        } else {\n          // API retornou sucesso no HTTP mas falha no payload\n          setState(() {\n            _plateLookupDone = true;\n            _plateLookupSuccess = false;\n          });\n        }
      } else {
        // Falha na consulta - mostrar campos manuais
        setState(() {
          _plateLookupDone = true;
          _plateLookupSuccess = false;
        });
      }
    } catch (e) {
      debugPrint('[PlateAutoFill] Erro: $e');
      setState(() {
        _plateLookupDone = true;
        _plateLookupSuccess = false;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingPlate = false);
      }
    }
  }

  String _normalizeBrand(String brand) {
    final upper = brand.toUpperCase().trim();
    const brandMap = {
      'VW': 'Volkswagen', 'VOLKSWAGEN': 'Volkswagen',
      'MB': 'Mercedes-Benz', 'MERCEDES BENZ': 'Mercedes-Benz', 'MERCEDES-BENZ': 'Mercedes-Benz',
      'SCANIA': 'Scania', 'VOLVO': 'Volvo', 'DAF': 'DAF', 'IVECO': 'Iveco', 'MAN': 'MAN',
      'FORD': 'Ford', 'CHEVROLET': 'Chevrolet', 'GM': 'Chevrolet', 'FIAT': 'Fiat',
      'TOYOTA': 'Toyota', 'HONDA': 'Honda', 'HYUNDAI': 'Hyundai', 'RENAULT': 'Renault',
      'NISSAN': 'Nissan', 'KIA': 'Kia', 'PEUGEOT': 'Peugeot',
      'CITROËN': 'Citroën', 'CITROEN': 'Citroën', 'JEEP': 'Jeep', 'MITSUBISHI': 'Mitsubishi',
      'BMW': 'BMW', 'AUDI': 'Audi', 'LAND ROVER': 'Land Rover', 'PORSCHE': 'Porsche',
      'JAGUAR': 'Jaguar', 'SUBARU': 'Subaru', 'SUZUKI': 'Suzuki',
    };
    return brandMap[upper] ?? brand;
  }

  Set<String> _mapFuelType(String fuelType) {
    final normalized = fuelType.toUpperCase();
    if (normalized.contains('FLEX') || 
        (normalized.contains('ALCOOL') && normalized.contains('GASOLINA')) ||
        normalized == 'ALCOOL / GASOLINA') {
      return {'GASOLINA', 'ETANOL'};
    }
    if (normalized == 'GASOLINA') return {'GASOLINA'};
    if (normalized == 'ALCOOL' || normalized == 'ETANOL') return {'ETANOL'};
    if (normalized.contains('DIESEL')) return {'DIESEL_S10'};
    return {};
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validar combustível
      if (_selectedFuelTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione pelo menos um combustível'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final apiService = ApiService();
        
        final vehicleData = {
          'plate': _plateController.text.toUpperCase().replaceAll('-', ''),
          'brand': _brandController.text,
          'model': _modelController.text,
          'year': int.tryParse(_yearController.text) ?? DateTime.now().year,
          'color': _colorController.text,
          'fuel_types': _selectedFuelTypes.toList(),
          'fuel_type': _selectedFuelTypes.first,
          'has_arla': _hasArla,
          'odometer': int.tryParse(_odometerController.text) ?? 0,
        };

        Map<String, dynamic> response;
        
        if (_isEditing) {
          response = await apiService.put('/autonomous/vehicles/${widget.vehicleId}', data: vehicleData);
        } else {
          response = await apiService.post('/autonomous/vehicles', data: vehicleData);
        }

        setState(() => _isLoading = false);

        if (mounted) {
          if (response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isEditing ? 'Veículo atualizado!' : 'Veículo cadastrado!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/autonomous/journey-start');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['error'] ?? 'Erro ao salvar'), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  String? _validatePlate(String? value) {
    if (value == null || value.isEmpty) return 'Placa é obrigatória';
    final plate = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (plate.length != 7) return 'Placa inválida';
    if (!RegExp(r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$').hasMatch(plate)) {
      return 'Placa inválida';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlavorConfig.instance.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Editar Veículo' : 'Novo Veículo',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Info card
                  _buildInfoCard(primaryColor),
                  const SizedBox(height: 20),

                  // Placa Section
                  _buildPlateSection(primaryColor),
                  const SizedBox(height: 16),

                  // Dados do veículo (condicional)
                  if (_plateLookupDone) ...[
                    if (_plateLookupSuccess)
                      _buildVehicleDataCard(primaryColor)
                    else
                      _buildManualFieldsSection(primaryColor),
                    const SizedBox(height: 16),
                  ],

                  // Combustível (sempre visível após lookup)
                  if (_plateLookupDone) ...[
                    _buildFuelSection(primaryColor),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Bottom bar (só mostra após lookup)
          if (_plateLookupDone)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _onSave,
                  icon: const Icon(Icons.check),
                  label: Text(_isEditing ? 'Salvar Alterações' : 'Cadastrar Veículo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFE0E7FF)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: primaryColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Digite a placa do veículo para buscar automaticamente os dados.',
              style: TextStyle(fontSize: 13, color: primaryColor, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateSection(Color primaryColor) {
    return _buildSection(
      icon: Icons.local_shipping,
      title: 'Placa do Veículo',
      children: [
        _buildLabel('Placa', required: true),
        TextFormField(
          controller: _plateController,
          inputFormatters: [_plateMaskFormatter],
          textCapitalization: TextCapitalization.characters,
          enabled: !_isEditing,
          validator: _validatePlate,
          onChanged: _onPlateChanged,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          decoration: _inputDecoration('ABC-1234').copyWith(
            suffixIcon: _isLoadingPlate
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 6, left: 4),
          child: Text('Formato: ABC-1234 ou ABC1D23 (Mercosul)', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ),
      ],
    );
  }

  Widget _buildVehicleDataCard(Color primaryColor) {
    final brand = _vehicleData?['brand'] ?? '';
    final model = _vehicleData?['model'] ?? '';
    final year = _vehicleData?['year'] ?? '';
    final color = _vehicleData?['color'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Veículo identificado!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$brand $model',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              if (year.isNotEmpty) _buildChip(Icons.calendar_today, 'Ano: $year'),
              if (color.isNotEmpty) _buildChip(Icons.palette, 'Cor: $color'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF6B7280)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
        ],
      ),
    );
  }

  Widget _buildManualFieldsSection(Color primaryColor) {
    return _buildSection(
      icon: Icons.edit,
      title: 'Preencha os dados',
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber, color: Color(0xFFD97706), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Não foi possível identificar automaticamente. Preencha manualmente.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                ),
              ),
            ],
          ),
        ),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Marca', required: true),
                  DropdownButtonFormField<String>(
                    value: _brandController.text.isEmpty ? null : _brandController.text,
                    decoration: _inputDecoration('Selecione'),
                    isExpanded: true,
                    items: _brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (v) => setState(() => _brandController.text = v ?? ''),
                    validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Ano'),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    decoration: _inputDecoration('2022'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        _buildLabel('Modelo'),
        TextFormField(
          controller: _modelController,
          decoration: _inputDecoration('Ex: Crossfox 1.6'),
        ),
      ],
    );
  }

  Widget _buildFuelSection(Color primaryColor) {
    return _buildSection(
      icon: Icons.local_gas_station,
      title: 'Combustível',
      children: [
        const Text(
          'Selecione os combustíveis que o veículo utiliza:',
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.8,
          children: _fuelTypes.map((fuel) {
            final isSelected = _selectedFuelTypes.contains(fuel['value']);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFuelTypes.remove(fuel['value']);
                  } else {
                    _selectedFuelTypes.add(fuel['value']);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelected ? primaryColor : const Color(0xFFE2E8F0), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Icon(fuel['icon'], color: isSelected ? primaryColor : const Color(0xFF94A3B8), size: 20),
                        if (isSelected)
                          Positioned(right: -8, top: -4, child: Icon(Icons.check_circle, color: primaryColor, size: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fuel['label'],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? primaryColor : const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        
        // ARLA checkbox
        if (_selectedFuelTypes.contains('DIESEL_S10') || _selectedFuelTypes.contains('DIESEL_S500')) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _hasArla,
                  onChanged: (v) => setState(() => _hasArla = v ?? false),
                  activeColor: primaryColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _hasArla = !_hasArla),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Veículo utiliza ARLA 32', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF92400E))),
                        Text('Marque se o veículo possui tanque de ARLA', style: TextStyle(fontSize: 11, color: Color(0xFFB45309))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 18),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
          children: required ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: FlavorConfig.instance.primaryColor, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }
}
