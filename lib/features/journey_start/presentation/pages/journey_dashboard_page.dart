import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../core/di/injection.dart';


class JourneyDashboardPage extends StatefulWidget {
  const JourneyDashboardPage({Key? key}) : super(key: key);

  @override
  State<JourneyDashboardPage> createState() => _JourneyDashboardPageState();
}

class _JourneyDashboardPageState extends State<JourneyDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Map<String, dynamic>? _vehicleData;
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _error;

  // Colors from design
  static const Color _zecaBlue = Color(0xFF1565C0);
  static const Color _zecaBlueDark = Color(0xFF0D47A1);
  static const Color _zecaGreen = Color(0xFF43A047);
  static const Color _zecaOrange = Color(0xFFFF9800);
  static const Color _zecaPurple = Color(0xFF7E57C2);
  static const Color _zecaGold = Color(0xFFFFD700);
  static const Color _bgGray = Color(0xFFF5F5F5);

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
      
      setState(() {
        _vehicleData = vehicleData;
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
      debugPrint('📥 Response type: ${response.runtimeType}');
      debugPrint('📥 Response: $response');
      
      // Handle different possible response structures
      Map<String, dynamic>? data;
      
      if (response is Map<String, dynamic>) {
        // Check if response has success/data structure
        if (response['success'] == true && response['data'] != null) {
          final innerData = response['data'];
          // Check if data itself has another data wrapper
          if (innerData is Map<String, dynamic> && innerData['economy'] != null) {
            data = innerData;
          } else if (innerData is Map<String, dynamic> && innerData['data'] != null) {
            data = innerData['data'];
          }
        } else if (response['economy'] != null) {
          // Response is directly the data
          data = response;
        }
      }
      
      debugPrint('📊 Extracted data: $data');
      
      if (data != null) {
        debugPrint('✅ Economy: ${data['economy']}');
        debugPrint('✅ Last refueling: ${data['last_refueling']}');
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      } else {
        debugPrint('⚠️ Could not extract dashboard data from response');
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
              backgroundColor: _zecaGreen,
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
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inDays == 0) {
        return 'Hoje às ${DateFormat('HH:mm').format(date)}';
      } else if (diff.inDays == 1) {
        return 'Ontem às ${DateFormat('HH:mm').format(date)}';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} dias atrás';
      }
      return DateFormat('dd/MM').format(date);
    } catch (e) {
      return '';
    }
  }

  String _getMonthName() {
    const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return months[DateTime.now().month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgGray,
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header with Vehicle Card
                SliverToBoxAdapter(child: _buildHeader()),
                
                // Content
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 100 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // CTA Abastecer
                      _buildRefuelCTA(),
                      const SizedBox(height: 14),
                      
                      // Economy Card
                      _buildEconomyCard(),
                      const SizedBox(height: 14),
                      
                      // Quick Actions
                      // Quick Actions
                      _buildSectionTitle('Acesso Rápido'),
                      const SizedBox(height: 10),
                      _buildQuickActions(),
                      const SizedBox(height: 14),
                      
                      // ZECA Club
                      _buildZecaClubCard(),
                      const SizedBox(height: 14),
                      
                      // Last Refueling
                      _buildLastRefuelingCard(),
                    ]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _zecaBlue,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const Text(
                    'ZECA - Jornada Ativa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.power_settings_new, color: Colors.white),
                    onPressed: _finishJourney,
                  ),
                ],
              ),
            ),
            
            // Vehicle Card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: _buildVehicleCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard() {
    final plate = _vehicleData?['placa'] ?? _vehicleData?['plate'] ?? 'N/A';
    final model = _vehicleData?['modelo'] ?? _vehicleData?['model'] ?? '';
    final brand = _vehicleData?['marca'] ?? _vehicleData?['brand'] ?? '';
    final fuelType = _vehicleData?['tipoCombustivel'] ?? _vehicleData?['fuel_type'] ?? '';
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_shipping, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '$brand $model${fuelType.isNotEmpty ? ' • $fuelType' : ''}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _zecaGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text(
                  'ATIVA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefuelCTA() {
    return GestureDetector(
      onTap: () => context.go('/home'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_zecaBlue, _zecaBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _zecaBlue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.local_gas_station, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Abastecer Agora',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Encontre um posto e abasteça',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEconomyCard() {
    final economy = _dashboardData?['economy'];
    final savings = economy?['savings_this_month'] ?? 0;
    final totalRefuelings = economy?['total_refuelings'] ?? 0;
    final avgConsumption = economy?['avg_consumption'];
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_zecaGreen, const Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.savings, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua Economia • ${_getMonthName()}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
          Row(
            children: [
              _buildEconomyStat(totalRefuelings.toString(), 'Abast.'),
              const SizedBox(width: 16),
              _buildEconomyStat(
                avgConsumption != null ? avgConsumption.toString() : '-',
                'Km/L',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEconomyStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF757575),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(child: _buildActionItem(Icons.assignment, 'Checklist', _zecaOrange, badge: 3)),
        const SizedBox(width: 10),
        Expanded(child: _buildActionItem(Icons.receipt_long, 'Histórico', _zecaPurple, onTap: () => context.push('/refueling-history'))),
        const SizedBox(width: 10),
        Expanded(child: _buildActionItem(Icons.location_on, 'Postos', _zecaGreen, onTap: () => context.push('/nearby-stations'))),
        const SizedBox(width: 10),
        Expanded(child: _buildActionItem(Icons.directions_car, 'Veículos', _zecaBlue)),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, {int? badge, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.red,
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
      ),
    );
  }

  Widget _buildZecaClubCard() {
    // Placeholder - "Em breve"
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_zecaPurple, const Color(0xFF9C27B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.workspace_premium, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'ZECA Club',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'EM BREVE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _zecaPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: _zecaPurple.withOpacity(0.7), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Acumule pontos e cashback!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _zecaPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastRefuelingCard() {
    final lastRefueling = _dashboardData?['last_refueling'];
    
    if (lastRefueling == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  'Último Abastecimento',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum abastecimento registrado',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.grey[600], size: 16),
              const SizedBox(width: 8),
              Text(
                'Último Abastecimento',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
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
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_gas_station, color: _zecaBlue),
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
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '$date${fuelType.isNotEmpty ? ' • $fuelType' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
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
                      color: Color(0xFF212121),
                    ),
                  ),
                  Text(
                    '${liters.toStringAsFixed(0)}L',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
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

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Início', isActive: true),
              _buildNavItem(Icons.local_gas_station, 'Abastecer', onTap: () => context.go('/home')),
              _buildNavItem(Icons.workspace_premium, 'Club'),
              _buildNavItem(Icons.person, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) {
    final color = isActive ? _zecaBlue : Colors.grey[600];
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // REMOVIDO: _buildDrawer() - Agora usa AppDrawer unificado (lib/shared/widgets/app_drawer.dart)
}
