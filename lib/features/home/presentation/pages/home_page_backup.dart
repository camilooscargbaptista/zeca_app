import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_api_service.dart';

class HomePageSimple extends StatefulWidget {
  const HomePageSimple({Key? key}) : super(key: key);

  @override
  State<HomePageSimple> createState() => _HomePageSimpleState();
}

class _HomePageSimpleState extends State<HomePageSimple> {
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _cnpjPostoController = TextEditingController();
  String _selectedFuel = 'Diesel';
  bool _abastecerArla = false;
  List<Map<String, dynamic>> _refuelingHistory = [];
  bool _isLoading = false;
  
  // Dados do usuário logado
  Map<String, dynamic>? _userData;
  
  // Estados do fluxo
  bool _vehicleSearched = false;
  bool _vehicleConfirmed = false;
  Map<String, dynamic>? _vehicleData;
  Map<String, dynamic>? _stationData;
  List<String> _availableFuels = [];
  bool _isStationValidated = false;

  @override
  void initState() {
    super.initState();
    _loadRefuelingHistory();
    _loadUserData();
  }

  void _loadUserData() {
    // Simular dados do usuário logado (em produção viria do storage ou contexto)
    setState(() {
      _userData = {
        'nome': 'João Silva',
        'cpf': '123.456.789-00',
        'empresa': 'Transportadora ABC Ltda',
        'cnpj': '12.345.678/0001-90',
        'telefone': '(11) 99999-9999',
        'email': 'joao.silva@empresa.com',
      };
    });
  }

  @override
  void dispose() {
    _placaController.dispose();
    _kmController.dispose();
    _cnpjPostoController.dispose();
    super.dispose();
  }

  Future<void> _loadRefuelingHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await MockApiService.getRefuelingHistory();
      if (response['success'] == true) {
        setState(() {
          _refuelingHistory = List<Map<String, dynamic>>.from(response['data']['history']);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchVehicle() async {
    if (_placaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite a placa do veículo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await MockApiService.searchVehicles(_placaController.text);
      if (response['success'] == true && response['data']['vehicles'].isNotEmpty) {
        final vehicle = response['data']['vehicles'][0];
        setState(() {
          _vehicleData = vehicle;
          _vehicleSearched = true;
          _vehicleConfirmed = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veículo não encontrado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar veículo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmVehicle() {
    if (_vehicleData != null) {
      setState(() {
        _vehicleConfirmed = true;
        _availableFuels = _vehicleData!['tiposCombustivel'] ?? ['Diesel'];
        _selectedFuel = _availableFuels.first;
        _kmController.text = _vehicleData!['kmAtual']?.toString() ?? '';
      });
    }
  }

  void _cancelVehicle() {
    setState(() {
      _vehicleSearched = false;
      _vehicleConfirmed = false;
      _vehicleData = null;
      _availableFuels = [];
      _isStationValidated = false;
      _stationData = null;
      _placaController.clear();
      _kmController.clear();
      _cnpjPostoController.clear();
    });
  }

  Future<void> _validateStation() async {
    if (_cnpjPostoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite o CNPJ do posto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular validação do posto
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _stationData = {
          'nome': 'Posto Ipiranga Centro',
          'endereco': 'Rua das Flores, 123',
          'cidade': 'São Paulo - SP',
          'preco': 5.89,
          'cnpj': _cnpjPostoController.text,
        };
        _isStationValidated = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao validar posto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZECA - Abastecimento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implementar notificações
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notificações em desenvolvimento'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de Boas-vindas com dados do cliente
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_userData != null) ...[
                      Text(
                        _userData!['nome'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('CPF: ${_userData!['cpf']}'),
                      Text('Empresa: ${_userData!['empresa']}'),
                      Text('CNPJ: ${_userData!['cnpj']}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Card de Busca de Veículo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.directions_car, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Veículo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Placa e Botão Buscar (só aparece se não confirmou)
                    if (!_vehicleConfirmed) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _placaController,
                              decoration: const InputDecoration(
                                labelText: 'Placa',
                                hintText: 'ABC-1234',
                                border: OutlineInputBorder(),
                              ),
                              enabled: !_vehicleSearched,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _vehicleSearched ? null : _searchVehicle,
                            child: const Text('Buscar'),
                          ),
                        ],
                      ),
                    ],
                    
                    // Dados do veículo encontrado
                    if (_vehicleSearched && _vehicleData != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_vehicleData!['marca']} ${_vehicleData!['modelo']} ${_vehicleData!['ano']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Combustível: ${_vehicleData!['tipoCombustivel']}'),
                              Text('Último KM: ${_vehicleData!['kmAtual']}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!_vehicleConfirmed) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancelVehicle,
                                child: const Text('Cancelar'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _confirmVehicle,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Confirmar'),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Botão Trocar Veículo quando confirmado
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _cancelVehicle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Trocar Veículo'),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            
            // Card de Dados do Abastecimento (só aparece após confirmar veículo)
            if (_vehicleConfirmed) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.local_gas_station, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Abastecimento',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Campo KM Atual
                      TextFormField(
                        controller: _kmController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'KM Atual',
                          hintText: 'Digite o KM atual',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite a quilometragem atual';
                          }
                          return null;
                        },
                      ),
                      if (_vehicleData != null)
                        Text(
                          'Último KM: ${_vehicleData!['kmAtual']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      const SizedBox(height: 16),
                      
                      // Campo Tipo de Combustível
                      if (_availableFuels.length > 1)
                        DropdownButtonFormField<String>(
                          value: _selectedFuel,
                          decoration: const InputDecoration(
                            labelText: 'Combustível',
                            border: OutlineInputBorder(),
                          ),
                          items: _availableFuels.map((String fuel) {
                            return DropdownMenuItem<String>(
                              value: fuel,
                              child: Text(fuel),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFuel = newValue!;
                            });
                          },
                        )
                      else
                        TextFormField(
                          initialValue: _selectedFuel,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Combustível',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      const SizedBox(height: 16),
                      
                      // Checkbox ARLA 32 (só se for Diesel)
                      if (_selectedFuel == 'Diesel')
                        Row(
                          children: [
                            Checkbox(
                              value: _abastecerArla,
                              onChanged: (bool? value) {
                                setState(() {
                                  _abastecerArla = value ?? false;
                                });
                              },
                            ),
                            const Text('Abastecer ARLA 32'),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
            
            // Card de CNPJ do Posto (só aparece após confirmar veículo)
            if (_vehicleConfirmed) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CNPJ do Posto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Campo CNPJ e Botão Validar
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cnpjPostoController,
                              decoration: const InputDecoration(
                                labelText: 'CNPJ do Posto',
                                hintText: '00.000.000/0000-00',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isStationValidated ? null : _validateStation,
                            child: const Text('Validar'),
                          ),
                        ],
                      ),
                      
                      // Dados do posto validado
                      if (_isStationValidated && _stationData != null) ...[
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.green[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.local_gas_station, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Text(
                                      _stationData!['nome'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(_stationData!['endereco']),
                                Text(_stationData!['cidade']),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.green[300]!, Colors.green[600]!],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Valor do Combustível',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'R\$ ${_stationData!['preco']}/L',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            // Botão Gerar Código (só aparece quando tudo estiver preenchido)
            if (_vehicleConfirmed && _isStationValidated) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleGenerateCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Gerando...'),
                      ],
                    )
                  : const Text(
                      'GERAR CÓDIGO DE ABASTECIMENTO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ],
            const SizedBox(height: 24),
            
            // Card de Histórico
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Histórico Recente',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_refuelingHistory.isEmpty)
                      const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('Nenhum abastecimento encontrado'),
                        subtitle: Text('Seus abastecimentos aparecerão aqui'),
                      )
                    else
                      ..._refuelingHistory.take(3).map((item) => Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.local_gas_station),
                            title: Text('Abastecimento - ${item['veiculo']}'),
                            subtitle: Text('${item['combustivel']} - ${item['quantidade']} - ${item['valor']}'),
                            trailing: Text(item['data']),
                          ),
                          if (item != _refuelingHistory.take(3).last)
                            const Divider(),
                        ],
                      )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGenerateCode() async {
    if (!_vehicleConfirmed || _kmController.text.isEmpty || !_isStationValidated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todas as etapas: confirme o veículo, preencha o KM e valide o posto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Gerar código de abastecimento
      final codeResponse = await MockApiService.generateRefuelingCode(
        veiculoId: _vehicleData!['id'],
        postoId: _stationData!['cnpj'],
        tipoCombustivel: _selectedFuel,
        quantidade: 100.0, // Quantidade padrão
        kmAtual: int.tryParse(_kmController.text) ?? 0,
        abastecerArla: _abastecerArla,
        observacoes: 'Abastecimento via app ZECA',
      );

      if (codeResponse['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        
        // Navegar para página de código
        context.go('/refueling-code');
      } else {
        throw Exception('Erro ao gerar código');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
