import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/odometer_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../bloc/journey_bloc.dart';
import '../bloc/journey_event.dart';
import '../bloc/journey_state.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/location_service.dart';
import '../../data/services/journey_storage_service.dart';
import '../../domain/entities/journey_entity.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({Key? key}) : super(key: key);

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  final _odometroController = TextEditingController();
  final _destinoController = TextEditingController();
  final _previsaoKmController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Formatter para odômetro (formato brasileiro: 123.456,789)
  final _odometroFormatter = OdometerFormatter();

  // Dados do veículo e usuário (carregados do storage)
  String? _placa;
  String? _nomeMotorista;
  String? _nomeTransportadora;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
    // Carregar jornada ativa ao iniciar
    context.read<JourneyBloc>().add(const LoadActiveJourney());
  }

  Future<void> _loadVehicleData() async {
    final storageService = getIt<StorageService>();
    final vehicleData = await storageService.getJourneyVehicleData();
    final userData = storageService.getUserData();
    
    setState(() {
      _placa = vehicleData?['placa'] ?? '';
      _nomeMotorista = userData?['motorista']?['nome'] ?? userData?['nome'] ?? '';
      _nomeTransportadora = userData?['transportadora']?['nome'] ?? '';
    });
  }

  @override
  void dispose() {
    _odometroController.dispose();
    _destinoController.dispose();
    _previsaoKmController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  String _formatarTempo(int segundos) {
    final horas = segundos ~/ 3600;
    final minutos = (segundos % 3600) ~/ 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
  }

  /// Converte DateTime para horário do Brasil (GMT-3)
  /// Sempre converte para GMT-3, independente da configuração do dispositivo
  DateTime _toBrazilTime(DateTime dateTime) {
    // Sempre trabalhar com UTC como referência
    final utcTime = dateTime.isUtc ? dateTime : dateTime.toUtc();
    // Subtrair 3 horas do UTC para obter GMT-3 (horário do Brasil)
    return utcTime.subtract(const Duration(hours: 3));
  }

  String _formatBrazilTime(DateTime dateTime) {
    final brazilTime = _toBrazilTime(dateTime);
    return '${brazilTime.hour.toString().padLeft(2, '0')}:${brazilTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatBrazilDate(DateTime dateTime) {
    final brazilTime = _toBrazilTime(dateTime);
    return '${brazilTime.day}/${brazilTime.month}/${brazilTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zecaBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
            context.go('/journey-dashboard');
            },
          tooltip: 'Voltar',
        ),
        title: const Text(
          'Viagem',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<JourneyBloc, JourneyState>(
        listener: (context, state) {
          if (state is JourneyError) {
            ErrorDialog.show(
              context,
              title: 'Erro',
              message: state.message,
            );
          } else if (state is JourneyFinished) {
            _showFinishDialog(state.journey);
          }
        },
        builder: (context, state) {
          if (state is JourneyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JourneyLoaded) {
            return _buildActiveJourneyView(state);
          }

          if (state is JourneyFinished) {
            return _buildFinishedJourneyView(state.journey);
          }

          return _buildStartJourneyView();
        },
      ),
    );
  }

  Widget _buildStartJourneyView() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping,
                            size: 32,
                            color: AppColors.zecaBlue,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Iniciar Viagem',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatBrazilDate(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Card Informativo (Placa, Motorista, Transportadora)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.zecaBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.zecaBlue.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Placa
                            Row(
                              children: [
                                const Icon(Icons.directions_car, size: 20, color: AppColors.zecaBlue),
                                const SizedBox(width: 8),
                                Text(
                                  'Veículo: ${_placa ?? 'Carregando...'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (_nomeMotorista != null && _nomeMotorista!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Motorista: $_nomeMotorista',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_nomeTransportadora != null && _nomeTransportadora!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.business, size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Transportadora: $_nomeTransportadora',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo Odômetro (OBRIGATÓRIO)
                      TextFormField(
                        controller: _odometroController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [_odometroFormatter],
                        decoration: InputDecoration(
                          labelText: 'Odômetro Inicial (km) *',
                          hintText: '0,000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.speed, color: AppColors.zecaBlue),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.trim().isEmpty) {
                            return 'Digite o odômetro inicial';
                          }
                          final odometro = OdometerFormatter.parseFormattedValue(value);
                          if (odometro <= 0) {
                            return 'Odômetro deve ser maior que zero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Destino (OPCIONAL)
                      TextFormField(
                        controller: _destinoController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Destino (opcional)',
                          hintText: 'Ex: São Paulo - SP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Previsão de KM (OPCIONAL)
                      TextFormField(
                        controller: _previsaoKmController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: 'Previsão de KM (opcional)',
                          hintText: 'Ex: 500',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.route, color: Colors.grey),
                          suffixText: 'km',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Observações (OPCIONAL)
                      TextFormField(
                        controller: _observacoesController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Observações (opcional)',
                          hintText: 'Notas sobre a viagem...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.notes, color: Colors.grey),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botão Iniciar
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (_placa == null || _placa!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erro ao carregar dados do veículo'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            final odometro = OdometerFormatter.parseFormattedValue(
                              _odometroController.text,
                            );
                            
                            // Obter valores dos campos opcionais
                            final destino = _destinoController.text.trim();
                            final previsaoKmText = _previsaoKmController.text.trim();
                            final previsaoKm = previsaoKmText.isNotEmpty 
                                ? int.tryParse(previsaoKmText) 
                                : null;
                            final observacoes = _observacoesController.text.trim();
                            
                            context.read<JourneyBloc>().add(
                                  StartJourney(
                                    placa: _placa!,
                                    odometroInicial: odometro,
                                    destino: destino.isNotEmpty ? destino : null,
                                    previsaoKm: previsaoKm,
                                    observacoes: observacoes.isNotEmpty ? observacoes : null,
                                  ),
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.zecaBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Iniciar Viagem',
                              style: TextStyle(
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
          ),
        ),
      ),
    );
  }

  Widget _buildActiveJourneyView(JourneyLoaded state) {
    final journey = state.journey;
    final tempoFormatado = _formatarTempo(state.tempoDecorridoSegundos);
    final kmFormatado = state.kmPercorridos.toStringAsFixed(1);
    final odometroFinal = journey.odometroInicial + state.kmPercorridos.round();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.zecaBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jornada',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatBrazilDate(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _formatBrazilTime(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Conteúdo Principal
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 24.0,
                    bottom: 24.0 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Informações do Veículo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Placa',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    journey.placa,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Odômetro Inicial',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${OdometerFormatter.formatValue(journey.odometroInicial)} km',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cronômetro Principal
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.zecaBlue.withOpacity(0.1),
                              AppColors.zecaBlue.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Tempo de Direção',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tempoFormatado,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.zecaBlue,
                                fontFeatures: [const FontFeature.tabularFigures()],
                              ),
                            ),
                            if (state.emDescanso) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.coffee, size: 16, color: Colors.orange[700]),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Em Descanso',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Dados da Jornada
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Início',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatBrazilDate(journey.dataInicio),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatBrazilTime(journey.dataInicio),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.zecaBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Km Percorridos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    kmFormatado,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Botões de Controle
                      if (!state.emDescanso)
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<JourneyBloc>().add(
                                  const ToggleRest(isStartingRest: true),
                                );
                          },
                          icon: const Icon(Icons.pause),
                          label: const Text('Iniciar Descanso'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<JourneyBloc>().add(
                                  const ToggleRest(isStartingRest: false),
                                );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Retomar Direção'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.zecaBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showFinishConfirmation();
                        },
                        icon: const Icon(Icons.stop),
                        label: const Text('Finalizar Jornada'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Mantenha-se seguro nas estradas 🚛',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.zecaBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedJourneyView(JourneyEntity journey) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.zecaBlue,
            AppColors.zecaBlue.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jornada Finalizada!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    const SizedBox(height: 8),
                  const Text(
                    'Resumo da Jornada',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Distância percorrida
                  _buildInfoRow(
                    icon: Icons.route,
                    label: 'Distância Percorrida',
                    value: '${journey.kmPercorridos.toStringAsFixed(1)} km',
                  ),
                  const Divider(height: 24),
                  
                  // Tempo de percurso
                  _buildInfoRow(
                    icon: Icons.timer,
                    label: 'Tempo de Percurso',
                    value: journey.formattedTempoDirecao,
                  ),
                  const Divider(height: 24),
                  
                  // Tempo de descanso
                  _buildInfoRow(
                    icon: Icons.hotel,
                    label: 'Tempo de Descanso',
                    value: journey.formattedTempoDescanso,
                  ),
                  
                  // Velocidades (somente se disponíveis)
                  if (journey.velocidadeMedia != null || journey.velocidadeMaxima != null) ...[
                    const Divider(height: 24),
                    const Text(
                      'Velocidades',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.zecaBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (journey.velocidadeMedia != null)
                    _buildInfoRow(
                      icon: Icons.speed,
                      label: 'Velocidade Média',
                      value: '${journey.velocidadeMedia!.toStringAsFixed(1)} km/h',
                      isCompact: true,
                    ),
                  
                  if (journey.velocidadeMaxima != null) ...[
                    if (journey.velocidadeMedia != null) const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.speed,
                      label: 'Velocidade Máxima',
                      value: '${journey.velocidadeMaxima!.toStringAsFixed(1)} km/h',
                      isCompact: true,
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.read<JourneyBloc>().add(const LoadActiveJourney());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.zecaBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      'Voltar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFinishConfirmation() {
    // Obter o bloc e o estado antes de abrir o diálogo para garantir acesso
    final journeyBloc = context.read<JourneyBloc>();
    final currentState = journeyBloc.state;
    
    if (currentState is! JourneyLoaded) {
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'Não é possível finalizar a jornada no estado atual',
      );
      return;
    }
    
    // Calcular odômetro final
    final journey = currentState.journey;
    final odometroFinal = journey.odometroInicial + currentState.kmPercorridos.round();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finalizar Jornada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deseja finalizar a jornada do dia?'),
            const SizedBox(height: 8),
            Text('Odômetro Final: ${OdometerFormatter.formatValue(odometroFinal)} km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              journeyBloc.add(FinishJourney(odometroFinal: odometroFinal));
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }


  void _showFinishDialog(JourneyEntity journey) {
    // Obter o bloc antes de abrir o diálogo para garantir acesso
    final journeyBloc = context.read<JourneyBloc>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Jornada Finalizada'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Text(
                'Resumo da Jornada',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zecaBlue,
                ),
              ),
              const SizedBox(height: 16),
              
              // Distância percorrida
              _buildInfoRow(
                icon: Icons.route,
                label: 'Distância Percorrida',
                value: '${journey.kmPercorridos.toStringAsFixed(1)} km',
              ),
              const Divider(height: 24),
              
              // Tempo de percurso
              _buildInfoRow(
                icon: Icons.timer,
                label: 'Tempo de Percurso',
                value: journey.formattedTempoDirecao,
              ),
              const Divider(height: 24),
              
              // Tempo de descanso
              _buildInfoRow(
                icon: Icons.hotel,
                label: 'Tempo de Descanso',
                value: journey.formattedTempoDescanso,
              ),
              
              // Velocidades (somente se disponíveis)
              if (journey.velocidadeMedia != null || journey.velocidadeMaxima != null) ...[
                const Divider(height: 24),
                const Text(
                  'Velocidades',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.zecaBlue,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
            if (journey.velocidadeMedia != null)
                _buildInfoRow(
                  icon: Icons.speed,
                  label: 'Velocidade Média',
                  value: '${journey.velocidadeMedia!.toStringAsFixed(1)} km/h',
                  isCompact: true,
                ),
              
              if (journey.velocidadeMaxima != null) ...[
                if (journey.velocidadeMedia != null) const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.speed,
                  label: 'Velocidade Máxima',
                  value: '${journey.velocidadeMaxima!.toStringAsFixed(1)} km/h',
                  isCompact: true,
                ),
              ],
              
              // NOVO: Seção de trechos (se disponível)
              if (journey.segmentsSummary != null && journey.segmentsSummary!.isNotEmpty) ...[
                const Divider(height: 32),
                _buildSegmentsSummary(journey.segmentsSummary!),
          ],
            ],
          ),
        ),
        actions: [
          // Botão "Ver Detalhes dos Trechos" (se houver trechos)
          if (journey.segmentsSummary != null && journey.segmentsSummary!.isNotEmpty)
          TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.push('/journey-segments/${journey.id}');
              },
              child: const Text('Ver Detalhes'),
            ),
          
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              journeyBloc.add(const LoadActiveJourney());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zecaBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentsSummary(List<dynamic> segments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.timeline, size: 20, color: AppColors.zecaBlue),
            const SizedBox(width: 8),
            const Text(
              'Trechos Percorridos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.zecaBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Lista de trechos (compacta)
        ...segments.map((segment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                // Número do trecho
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.zecaBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '${segment.segmentNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.zecaBlue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Info do trecho
                Expanded(
                  child: Text(
                    '${segment.formattedDistance} | ${segment.formattedDuration}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                
                // Velocidade média
                if (segment.avgSpeedKmh != null)
                  Text(
                    segment.formattedAvgSpeed,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isCompact = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isCompact ? 18 : 24,
          color: AppColors.zecaBlue.withOpacity(0.7),
        ),
        SizedBox(width: isCompact ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isCompact ? 15 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

