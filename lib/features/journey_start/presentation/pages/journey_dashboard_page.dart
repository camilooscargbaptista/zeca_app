import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../core/di/injection.dart';
// Efficiency imports
import '../../../efficiency/presentation/bloc/efficiency_bloc.dart';
import '../../../efficiency/presentation/bloc/efficiency_event.dart';
import '../../../efficiency/presentation/bloc/efficiency_state.dart';
import '../../../efficiency/data/repositories/efficiency_repository.dart';
// Bottom Nav
import '../widgets/home_bottom_nav.dart';
// Trip Module
import '../../../home/presentation/bloc/trip_home_bloc.dart';
import '../../../home/presentation/widgets/trip_status_card.dart';


/// Home V3 Redesign - JourneyDashboardPage
/// 
/// Layout Order:
/// 1. Header (Logo + Menu + Notifications)
/// 2. Vehicle Bar (Green)
/// 3. CTA Abastecer
/// 4. Economy Card (Green full-width)
/// 5. Efficiency Grid (2x2)
/// 6. Quick Actions (Horizontal bar)
/// 7. Last Refueling Card
/// 8. ZECA Club ("Em Breve")
/// 9. Bottom Nav (with FAB)
class JourneyDashboardPage extends StatefulWidget {
  const JourneyDashboardPage({Key? key}) : super(key: key);

  @override
  State<JourneyDashboardPage> createState() => _JourneyDashboardPageState();
}

class _JourneyDashboardPageState extends State<JourneyDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Map<String, dynamic>? _vehicleData;
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _efficiencyData;
  bool _isLoading = true;
  String? _error;
  bool _isAutonomous = false; // RN-VEIC-001: Veículos só para autônomos

  // Colors from design V3 - ZECA Brand Colors
  static const Color _primaryBlue = Color(0xFF2A70C0);    // Azul ZECA (logo)
  static const Color _primaryBlueDark = Color(0xFF1E3A5F); // Azul escuro
  static const Color _zecaGreenCap = Color(0xFF3DAA5C);   // Verde do boné
  static const Color _zecaGreenDark = Color(0xFF2E8B47);  // Verde escuro
  static const Color _accentPurple = Color(0xFF7C3AED);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _textPrimary = Color(0xFF111827);
  static const Color _textSecondary = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final storageService = getIt<StorageService>();
      final vehicleData = await storageService.getJourneyVehicleData();
      
      if (vehicleData == null || vehicleData.isEmpty) {
        if (mounted) {
          context.go('/journey-start');
        }
        return;
      }
      
      // Verificar se usuário é autônomo
      final userData = storageService.getUserData();
      final companyType = userData?['company']?['type'] as String?;
      final isAuto = userData?['is_autonomous'] == true ||
                     userData?['isAutonomous'] == true ||
                     companyType == 'AUTONOMO';
      
      setState(() {
        _vehicleData = vehicleData;
        _isAutonomous = isAuto;
      });

      // Fetch dashboard summary from API
      await _fetchDashboardSummary();
      
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar dados: $e');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchDashboardSummary() async {
    try {
      final apiService = ApiService();
      // Pegar placa do veículo para filtrar economia e último abastecimento
      final plate = _vehicleData?['placa'] ?? _vehicleData?['plate'] ?? '';
      final queryParam = plate.isNotEmpty ? '?plate=$plate' : '';
      debugPrint('🔄 Chamando GET /drivers/dashboard-summary$queryParam...');
      final response = await apiService.get('/drivers/dashboard-summary$queryParam');
      
      // Handle different possible response structures
      Map<String, dynamic>? data;
      
      if (response is Map<String, dynamic>) {
        if (response['success'] == true && response['data'] != null) {
          final innerData = response['data'];
          if (innerData is Map<String, dynamic> && innerData['economy'] != null) {
            data = innerData;
          } else if (innerData is Map<String, dynamic> && innerData['data'] != null) {
            data = innerData['data'];
          }
        } else if (response['economy'] != null) {
          data = response;
        }
      }
      
      if (data != null) {
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Erro ao carregar dashboard: $e');
      debugPrint('Stack: $stackTrace');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _finishJourney() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.power_settings_new, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Finalizar Jornada'),
          ],
        ),
        content: const Text(
          'Tem certeza que deseja finalizar esta jornada?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Finalizar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final storageService = getIt<StorageService>();
        await storageService.clearJourneyVehicleData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Jornada finalizada com sucesso!'),
              backgroundColor: _zecaGreenCap,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          context.go('/journey-start');
        }
      } catch (e) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao finalizar jornada: $e',
        );
      }
    }
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return 'R\$0,00';
    final number = value is num ? value : double.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2).format(number);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd/MM').format(date);
    } catch (e) {
      return '';
    }
  }

  String _getMonthName() {
    const months = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 
                    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
    return months[DateTime.now().month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgLight,
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header + Vehicle Bar
                SliverToBoxAdapter(child: _buildHeaderSection()),
                
                // Content
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: 100 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Trip Status Card (Iniciar Viagem / Em Andamento)
                      BlocProvider(
                        create: (_) => getIt<TripHomeBloc>()..add(const LoadActiveTrip()),
                        child: TripStatusCard(
                          vehicleId: _vehicleData?['id']?.toString() ?? '',
                          vehiclePlate: _vehicleData?['placa']?.toString() ?? _vehicleData?['plate']?.toString() ?? '',
                          vehicleModel: _vehicleData?['modelo']?.toString() ?? _vehicleData?['model']?.toString(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Economy Card (Green full-width)
                      _buildEconomyCard(),
                      const SizedBox(height: 16),
                      
                      // Efficiency Grid (2x2)
                      _buildEfficiencyGrid(),
                      const SizedBox(height: 16),
                      
                      // Quick Actions
                      _buildQuickActions(),
                      const SizedBox(height: 16),
                      
                      // Last Refueling
                      _buildLastRefuelingCard(),
                    ]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: HomeBottomNav(
        isAutonomous: _isAutonomous,
        currentIndex: 0,
        onRefuelTap: () => context.go('/home'),
      ),
    );
  }

  /// Header Section: Logo + Menu + Notifications + Vehicle Bar
  Widget _buildHeaderSection() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF374151), size: 26),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  
                  // Logo
                  Text(
                    'zeca',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _primaryBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  // TODO: Descomentar quando implementar notificações
                  // Notifications - OMITIDO (não implementado)
                  /*
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Color(0xFF374151), size: 26),
                        onPressed: () {
                          // TODO: Open notifications
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  */
                  const SizedBox(width: 48), // Placeholder
                ],
              ),
            ),
            
            // Vehicle Bar
            _buildVehicleBar(),
          ],
        ),
      ),
    );
  }

  /// Green Vehicle Bar with plate, status and finish button
  Widget _buildVehicleBar() {
    final plate = _vehicleData?['placa'] ?? _vehicleData?['plate'] ?? 'N/A';
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Plate
          Text(
            plate,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          
          // Status
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Ativo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Finish Journey button
          GestureDetector(
            onTap: _finishJourney,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.power_settings_new, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Finalizar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CTA Abastecer Agora
  Widget _buildRefuelCTA() {
    return GestureDetector(
      onTap: () => context.go('/home'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primaryBlue, _primaryBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.local_gas_station, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Abastecer Agora',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  /// Economy Card - COMPACT horizontal layout with ZECA green
  Widget _buildEconomyCard() {
    final economy = _dashboardData?['economy'];
    final savings = economy?['savings_this_month'] ?? 0;
    final totalRefuelings = economy?['total_refuelings'] ?? 0;
    final avgConsumption = economy?['avg_consumption'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_zecaGreenCap, _zecaGreenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Left: Icon + Value
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.savings, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua Economia • ${_getMonthName()}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                  ),
                ),
                Text(
                  _formatCurrency(savings),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          // Right: Stats
          Row(
            children: [
              _buildCompactStat(
                totalRefuelings.toString(),
                'Abast.',
              ),
              const SizedBox(width: 16),
              _buildCompactStat(
                avgConsumption != null ? avgConsumption.toStringAsFixed(1) : '-',
                'Km/L',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildEconomyStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencyGrid() {
    return BlocProvider(
      create: (context) => EfficiencyBloc(
        repository: EfficiencyRepository(),
      )..add(const LoadEfficiencySummary()),
      child: BlocBuilder<EfficiencyBloc, EfficiencyState>(
        builder: (context, state) {
          double? currentEfficiency;
          double? trend;
          
          if (state is EfficiencySummaryLoaded) {
            currentEfficiency = state.summary.personalAvgKmL;
            trend = state.summary.deviationFromFleetPercent;
          }
          
          return Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.speed,
                  iconColor: _primaryBlue,
                  iconBgColor: const Color(0xFFDBEAFE),
                  label: 'Eficiência Atual',
                  value: currentEfficiency != null 
                      ? currentEfficiency.toStringAsFixed(1) 
                      : '-',
                  unit: 'km/L',
                  meta: currentEfficiency != null && currentEfficiency > 2.8 
                      ? '⚡ Acima da média!' 
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // ZECA Club Card (substitui Tendência)
              Expanded(
                child: _buildZecaClubCompact(),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    String? unit,
    String? meta,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? _textPrimary,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
              ],
            ],
          ),
          if (meta != null) ...[
            const SizedBox(height: 4),
            Text(
              meta,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// ZECA Club Card - Compact version to fit in grid
  Widget _buildZecaClubCompact() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'EM BREVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'ZECA Club',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Benefícios exclusivos',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Actions - Horizontal bar with icons
  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // TODO: Descomentar quando implementar checklist
          // Checklist - OMITIDO (não implementado)
          /*
          _buildQuickActionItem(
            icon: Icons.assignment,
            label: 'Checklist',
            color: _primaryBlue,
            bgColor: const Color(0xFFDBEAFE),
            badge: 3,
            onTap: () {
              // TODO: Navigate to checklist
            },
          ),
          */
          _buildQuickActionItem(
            icon: Icons.history,
            label: 'Histórico',
            color: _accentPurple,
            bgColor: const Color(0xFFEDE9FE),
            onTap: () => context.push('/history'),
          ),
          _buildQuickActionItem(
            icon: Icons.location_on,
            label: 'Postos',
            color: _zecaGreenCap,
            bgColor: const Color(0xFFD1FAE5),
            onTap: () => context.push('/nearby-stations'),
          ),
          _buildQuickActionItem(
            icon: _isAutonomous ? Icons.directions_car : Icons.receipt_long,
            label: _isAutonomous ? 'Veículos' : 'Gastos',
            color: _isAutonomous ? _primaryBlue : const Color(0xFFEF4444),
            bgColor: _isAutonomous ? const Color(0xFFDBEAFE) : const Color(0xFFFEE2E2),
            onTap: () {
              if (_isAutonomous) {
                context.push('/autonomous/vehicles');
              } else {
                context.push('/trip-expenses');
              }
            },
          ),


        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    int? badge,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  if (badge != null)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            badge.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Last Refueling Card
  Widget _buildLastRefuelingCard() {
    final lastRefueling = _dashboardData?['last_refueling'];
    
    if (lastRefueling == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: _textSecondary, size: 14),
            const SizedBox(width: 8),
            Text(
              'Nenhum abastecimento registrado',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final stationName = lastRefueling['station_name'] ?? 'Posto';
    final totalValue = lastRefueling['total_value'] ?? 0;
    final liters = lastRefueling['liters'] ?? 0;
    final fuelType = lastRefueling['fuel_type'] ?? '';
    final date = _formatDate(lastRefueling['date']);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: _textSecondary, size: 14),
              const SizedBox(width: 8),
              Text(
                'Último Abastecimento',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_gas_station, color: _primaryBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stationName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      '$date${fuelType.isNotEmpty ? ' • $fuelType' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(totalValue),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    '${(liters is num ? liters : 0).toStringAsFixed(0)}L',
                    style: TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
