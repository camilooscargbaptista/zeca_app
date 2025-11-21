import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_api_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';

class HistoryPageSimple extends StatefulWidget {
  const HistoryPageSimple({Key? key}) : super(key: key);

  @override
  State<HistoryPageSimple> createState() => _HistoryPageSimpleState();
}

class _HistoryPageSimpleState extends State<HistoryPageSimple> {
  List<Map<String, dynamic>> _refuelingHistory = [];
  bool _isLoading = true;
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;
  Map<String, dynamic> _monthlyStats = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await MockApiService.getRefuelingHistory(
        dataInicio: DateTime(_currentYear, _currentMonth, 1),
        dataFim: DateTime(_currentYear, _currentMonth + 1, 0),
      );

      if (response['success'] == true) {
        setState(() {
          _refuelingHistory = List<Map<String, dynamic>>.from(response['data']['history']);
          _monthlyStats = response['data'];
          _isLoading = false;
        });
      } else {
        _showError('Erro ao carregar histórico', response['message'] ?? 'Erro desconhecido');
      }
    } catch (e) {
      _showError('Erro ao carregar histórico', e.toString());
    }
  }

  void _showError(String title, String message) {
    ErrorDialog.show(
      context,
      title: title,
      message: message,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }

  void _previousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
    _loadHistory();
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Abastecimentos'),
        backgroundColor: AppColors.zecaBlue,
        foregroundColor: AppColors.zecaWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Header com navegação de mês
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppColors.grey50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Column(
                  children: [
                    Text(
                      _getMonthName(_currentMonth),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentYear.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // Estatísticas do mês
          if (_monthlyStats.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Resumo do Mês',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Abastecimentos',
                            '${_monthlyStats['total_abastecimentos'] ?? 0}',
                            Icons.local_gas_station,
                            AppColors.zecaBlue,
                          ),
                          _buildStatCard(
                            'Total Litros',
                            '${_monthlyStats['total_litros']?.toStringAsFixed(0) ?? '0'}L',
                            Icons.water_drop,
                            AppColors.zecaGreen,
                          ),
                          _buildStatCard(
                            'Valor Total',
                            'R\$ ${_monthlyStats['total_valor']?.toStringAsFixed(2) ?? '0,00'}',
                            Icons.attach_money,
                            AppColors.zecaOrange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Lista de abastecimentos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _refuelingHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_gas_station_outlined,
                              size: 64,
                              color: AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum abastecimento encontrado',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.grey600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'para ${_getMonthName(_currentMonth)} de $_currentYear',
                              style: TextStyle(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _refuelingHistory.length,
                        itemBuilder: (context, index) {
                          final item = _refuelingHistory[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.local_gas_station,
                                color: AppColors.zecaBlue,
                                size: 24,
                              ),
                              title: Text(
                                item['veiculo'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${item['combustivel']} - ${item['quantidade']} - ${item['valor']}'),
                                  Text(
                                    'Posto: ${item['posto']}',
                                    style: TextStyle(
                                      color: AppColors.grey600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Código: ${item['codigo']}',
                                    style: TextStyle(
                                      color: AppColors.zecaGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item['data'],
                                    style: TextStyle(
                                      color: AppColors.grey600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    item['hora'] ?? '',
                                    style: TextStyle(
                                      color: AppColors.grey400,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }
}
