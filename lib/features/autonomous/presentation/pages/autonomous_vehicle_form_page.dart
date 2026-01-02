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

  final _odometerController = TextEditingController();
  Set<String> _selectedFuelTypes = {'DIESEL_S10'}; // Múltiplos combustíveis
  bool _hasArla = false; // Checkbox para ARLA (diesel)
  bool _isLoading = false;
  bool _isLoadingPlate = false;
  Timer? _debounceTimer;

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
    'Scania',
    'Volvo',
    'Mercedes-Benz',
    'DAF',
    'Iveco',
    'Volkswagen',
    'MAN',
    'Ford',
    'Chevrolet',
    'Fiat',
    'Toyota',
    'Honda',
    'Hyundai',
    'Renault',
    'Nissan',
    'Kia',
    'Peugeot',
    'Citroën',
    'Jeep',
    'Mitsubishi',
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
    // Mock data para edição
    _plateController.text = 'ABC-1234';
    _brandController.text = 'Scania';
    _modelController.text = 'R450';
    _yearController.text = '2022';

    _odometerController.text = '245320';
    setState(() {
      _selectedFuelTypes = {};
      _hasArla = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  /// Consulta a placa na API e preenche os campos automaticamente
  void _onPlateChanged(String value) {
    // Não buscar se estiver editando
    if (_isEditing) return;

    // Cancelar debounce anterior
    _debounceTimer?.cancel();

    // Extrair apenas letras e números
    final plate = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Só buscar se tiver 7 caracteres válidos
    if (plate.length != 7) return;

    // Validar formato (antigo ou Mercosul)
    if (!RegExp(r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$').hasMatch(plate)) return;

    // Debounce 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _lookupPlate(plate);
    });
  }

  Future<void> _lookupPlate(String plate) async {
    setState(() => _isLoadingPlate = true);

    try {
      final apiService = ApiService();
      final response = await apiService.get('/vehicles/plate/$plate');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        // Auto-preencher marca (se existir na lista)
        final brand = data['brand']?.toString() ?? '';
        final normalizedBrand = _normalizeBrand(brand);
        if (_brands.contains(normalizedBrand)) {
          _brandController.text = normalizedBrand;
        }

        // Auto-preencher modelo
        if (data['model'] != null) {
          _modelController.text = data['model'].toString();
        }

        // Auto-preencher ano
        if (data['year'] != null) {
          _yearController.text = data['year'].toString();
        }

        // Auto-preencher combustível
        final fuelType = data['fuelType']?.toString().toUpperCase() ?? '';
        setState(() {
          _selectedFuelTypes = _mapFuelType(fuelType);
        });
      }
      // Se erro, silencioso - usuário preenche manual
    } catch (e) {
      // Silencioso - usuário preenche manual
      debugPrint('[PlateAutoFill] Erro: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPlate = false);
      }
    }
  }

  /// Normaliza o nome da marca para corresponder à lista _brands
  String _normalizeBrand(String brand) {
    final upper = brand.toUpperCase().trim();

    // Mapeamento de variações comuns
    const brandMap = {
      'VW': 'Volkswagen',
      'VOLKSWAGEN': 'Volkswagen',
      'MB': 'Mercedes-Benz',
      'MERCEDES BENZ': 'Mercedes-Benz',
      'MERCEDES-BENZ': 'Mercedes-Benz',
      'SCANIA': 'Scania',
      'VOLVO': 'Volvo',
      'DAF': 'DAF',
      'IVECO': 'Iveco',
      'MAN': 'MAN',
      'FORD': 'Ford',
      'CHEVROLET': 'Chevrolet',
      'GM': 'Chevrolet',
      'FIAT': 'Fiat',
      'TOYOTA': 'Toyota',
      'HONDA': 'Honda',
      'HYUNDAI': 'Hyundai',
      'RENAULT': 'Renault',
      'NISSAN': 'Nissan',
      'KIA': 'Kia',
      'PEUGEOT': 'Peugeot',
      'CITROËN': 'Citroën',
      'CITROEN': 'Citroën',
      'JEEP': 'Jeep',
      'MITSUBISHI': 'Mitsubishi',
    };

    return brandMap[upper] ?? brand;
  }

  /// Mapeia o fuelType da API para os valores do formulário
  Set<String> _mapFuelType(String fuelType) {
    final normalized = fuelType.toUpperCase();

    if (normalized.contains('FLEX') ||
        normalized.contains('ALCOOL') && normalized.contains('GASOLINA') ||
        normalized == 'ALCOOL / GASOLINA') {
      return {'GASOLINA', 'ETANOL'};
    }
    if (normalized == 'GASOLINA') {
      return {'GASOLINA'};
    }
    if (normalized == 'ALCOOL' || normalized == 'ETANOL') {
      return {'ETANOL'};
    }
    if (normalized.contains('DIESEL')) {
      return {'DIESEL_S10'};
    }

    // Default: não altera (retorna vazio para manter seleção atual)
    return _selectedFuelTypes;
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final apiService = ApiService();
        
        final vehicleData = {
          'plate': _plateController.text.toUpperCase().replaceAll('-', ''),
          'brand': _brandController.text,
          'model': _modelController.text,
          'year': int.tryParse(_yearController.text) ?? DateTime.now().year,
          'fuel_types': _selectedFuelTypes.toList(), // Array de combustíveis
          'fuel_type': _selectedFuelTypes.first, // Para compatibilidade
          'has_arla': _hasArla, // Se usa ARLA

          'odometer': int.tryParse(_odometerController.text) ?? 0,
        };

        Map<String, dynamic> response;
        
        if (_isEditing) {
          // Atualizar veículo existente
          response = await apiService.put('/autonomous/vehicles/${widget.vehicleId}', data: vehicleData);
        } else {
          // Criar novo veículo
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
              SnackBar(
                content: Text(response['error'] ?? 'Erro ao salvar veículo'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          // Extrair mensagem de erro do backend se disponível
          String errorMessage = 'Erro ao salvar veículo';
          if (e.toString().contains('DioException')) {
            // Tentar extrair mensagem do response
            final errorStr = e.toString();
            if (errorStr.contains('Placa já cadastrada')) {
              errorMessage = 'Esta placa já está cadastrada no sistema';
            } else if (errorStr.contains('Limite de')) {
              errorMessage = 'Você atingiu o limite de veículos permitidos';
            } else if (errorStr.contains('message')) {
              // Tentar extrair a mensagem JSON
              final match = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(errorStr);
              if (match != null) {
                errorMessage = match.group(1) ?? errorMessage;
              }
            }
          } else {
            errorMessage = 'Erro de conexão. Verifique sua internet.';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String? _validatePlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Placa é obrigatória';
    }
    final plate = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (plate.length != 7) {
      return 'Placa inválida';
    }
    // Placa antiga ou Mercosul
    if (!RegExp(r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$').hasMatch(plate)) {
      return 'Placa inválida. Use ABC-1234 ou ABC1A23';
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
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
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDBEAFE), Color(0xFFE0E7FF)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: primaryColor, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cadastre seu veículo para começar a abastecer. Você pode ter até 3 veículos.',
                            style: TextStyle(
                              fontSize: 13,
                              color: primaryColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dados do Veículo Section
                  _buildSection(
                    icon: Icons.local_shipping,
                    title: 'Dados do Veículo',
                    children: [
                      // Placa
                      _buildLabel('Placa', required: true),
                      TextFormField(
                        controller: _plateController,
                        inputFormatters: [_plateMaskFormatter],
                        textCapitalization: TextCapitalization.characters,
                        enabled: !_isEditing,
                        validator: _validatePlate,
                        onChanged: _onPlateChanged,
                        decoration: _inputDecoration('ABC-1234').copyWith(
                          suffixIcon: _isLoadingPlate
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          'Formato: ABC-1234 ou ABC1D23 (Mercosul)',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Marca e Ano
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
                                  items: _brands.map((brand) {
                                    return DropdownMenuItem(
                                      value: brand,
                                      child: Text(brand, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _brandController.text = value ?? '');
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Obrigatório';
                                    }
                                    return null;
                                  },
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  decoration: _inputDecoration('2022'),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final year = int.tryParse(value);
                                      if (year == null || year < 1990 || year > DateTime.now().year + 1) {
                                        return 'Inválido';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Modelo
                      _buildLabel('Modelo'),
                      TextFormField(
                        controller: _modelController,
                        decoration: _inputDecoration('Ex: R450, FH 540, Actros'),
                      ),

                    ],
                  ),
                  const SizedBox(height: 16),

                  // Combustível Section
                  _buildSection(
                    icon: Icons.local_gas_station,
                    title: 'Combustível Utilizado',
                    children: [
                      const Text(
                        'Selecione todos os combustíveis que o veículo utiliza:',
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
                                  // Não permitir deselecionar se for o único
                                  if (_selectedFuelTypes.length > 1) {
                                    _selectedFuelTypes.remove(fuel['value']);
                                  }
                                } else {
                                  _selectedFuelTypes.add(fuel['value']);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? primaryColor.withOpacity(0.1)
                                    : Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Icon(
                                        fuel['icon'],
                                        color: isSelected ? primaryColor : const Color(0xFF94A3B8),
                                        size: 20,
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          right: -8,
                                          top: -4,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: primaryColor,
                                            size: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    fuel['label'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? primaryColor : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      // Checkbox ARLA - aparece se diesel estiver selecionado
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
                                onChanged: (value) => setState(() => _hasArla = value ?? false),
                                activeColor: primaryColor,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _hasArla = !_hasArla),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Veículo utiliza ARLA 32',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF92400E),
                                        ),
                                      ),
                                      const Text(
                                        'Marque se o veículo possui tanque de ARLA',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFB45309),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Odômetro Section
                  _buildSection(
                    icon: Icons.speed,
                    title: 'Odômetro Atual',
                    children: [
                      _buildLabel('Quilometragem atual'),
                      TextFormField(
                        controller: _odometerController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration('Ex: 150000'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          'Informe a quilometragem atual do veículo em km',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 18),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
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
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
          children: required
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: FlavorConfig.instance.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
