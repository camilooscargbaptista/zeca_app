import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/common/custom_toast.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/formatters.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/refueling_form_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    // Verificar status de autenticação
    context.read<VehicleBloc>().add(LoadUserInfo());
  }
  
  @override
  void dispose() {
    _placaController.dispose();
    _kmController.dispose();
    super.dispose();
  }
  
  void _onSearchVehicle() {
    if (_formKey.currentState?.validate() ?? false) {
      final placa = _placaController.text.toUpperCase();
      context.read<VehicleBloc>().add(SearchVehicle(placa));
    }
  }
  
  void _onGenerateRefuelingCode() {
    // TODO: Implementar geração de código de abastecimento
    CustomToast.showInfo(context, 'Funcionalidade em desenvolvimento');
  }
  
  void _onLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlavorConfig.instance.appName),
        actions: [
          IconButton(
            onPressed: _onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<VehicleBloc>(
            create: (context) => getIt<VehicleBloc>(),
          ),
          BlocProvider<RefuelingFormBloc>(
            create: (context) => getIt<RefuelingFormBloc>(),
          ),
        ],
        child: BlocConsumer<VehicleBloc, VehicleState>(
          listener: (context, state) {
            if (state is VehicleError) {
              CustomToast.showError(context, state.message);
            } else if (state is VehicleLoaded) {
              CustomToast.showSuccess(context, 'Veículo encontrado!');
            }
          },
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is VehicleLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bem-vindo!',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sistema de Abastecimento Corporativo',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Vehicle Search Section
                    Text(
                      'Buscar Veículo',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _placaController,
                            label: 'Placa do Veículo',
                            hint: 'Ex: ABC1234 ou ABC1D23',
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [Formatters.placaFormatter],
                            validator: Validators.validatePlaca,
                            onFieldSubmitted: (_) => _onSearchVehicle(),
                          ),
                          const SizedBox(height: 16),
                          
                          if (state is VehicleLoaded) ...[
                            // Vehicle Info Card
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.directions_car,
                                          color: FlavorConfig.instance.primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Veículo Encontrado',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Placa: ${state.vehicle.placa}',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Modelo: ${state.vehicle.modelo}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      'Marca: ${state.vehicle.marca}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      'Último KM: ${state.vehicle.ultimoKm}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // KM Input
                            CustomTextField(
                              controller: _kmController,
                              label: 'KM Atual',
                              hint: 'Digite o KM atual do veículo',
                              keyboardType: TextInputType.number,
                              inputFormatters: [Formatters.kmFormatter],
                              validator: (value) => Validators.validateKM(value, state.vehicle.ultimoKm),
                            ),
                            const SizedBox(height: 24),
                            
                            // Generate Code Button
                            CustomButton(
                              text: 'Gerar Código de Abastecimento',
                              onPressed: _onGenerateRefuelingCode,
                              isFullWidth: true,
                              icon: Icons.qr_code,
                            ),
                          ] else ...[
                            // Search Button
                            CustomButton(
                              text: 'Buscar Veículo',
                              onPressed: _onSearchVehicle,
                              isFullWidth: true,
                              icon: Icons.search,
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Quick Actions
                    Text(
                      'Ações Rápidas',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () => context.go('/history'),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 32,
                                      color: FlavorConfig.instance.primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Histórico',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () => context.go('/profile'),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 32,
                                      color: FlavorConfig.instance.primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Perfil',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
