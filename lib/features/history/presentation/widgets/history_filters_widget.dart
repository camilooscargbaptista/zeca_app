import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/refueling_history_entity.dart';

/// Widget colapsável para filtros do histórico
class HistoryFiltersWidget extends StatefulWidget {
  final HistoryFiltersEntity currentFilters;
  final List<String> availablePlates;
  final Function(HistoryFiltersEntity) onApply;
  final VoidCallback onClear;

  const HistoryFiltersWidget({
    Key? key,
    required this.currentFilters,
    required this.availablePlates,
    required this.onApply,
    required this.onClear,
  }) : super(key: key);

  @override
  State<HistoryFiltersWidget> createState() => _HistoryFiltersWidgetState();
}

class _HistoryFiltersWidgetState extends State<HistoryFiltersWidget> {
  bool _isExpanded = false;
  late String? _selectedPlate;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedPlate = widget.currentFilters.vehiclePlate;
    _startDate = widget.currentFilters.startDate;
    _endDate = widget.currentFilters.endDate;
  }

  @override
  void didUpdateWidget(HistoryFiltersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentFilters != widget.currentFilters) {
      _selectedPlate = widget.currentFilters.vehiclePlate;
      _startDate = widget.currentFilters.startDate;
      _endDate = widget.currentFilters.endDate;
    }
  }

  void _applyFilters() {
    widget.onApply(HistoryFiltersEntity(
      vehiclePlate: _selectedPlate,
      startDate: _startDate,
      endDate: _endDate,
    ));
    setState(() => _isExpanded = false);
  }

  void _clearFilters() {
    setState(() {
      _selectedPlate = null;
      _startDate = null;
      _endDate = null;
    });
    widget.onClear();
    setState(() => _isExpanded = false);
  }

  Future<void> _selectDate(bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now().subtract(const Duration(days: 30)))
        : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Ajustar end date se necessário
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final hasActiveFilters = widget.currentFilters.hasFilters;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header colapsável
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 20,
                    color: hasActiveFilters ? AppColors.zecaBlue : AppColors.grey600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: hasActiveFilters ? AppColors.zecaBlue : AppColors.grey700,
                    ),
                  ),
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.zecaBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Ativo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.zecaBlue,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.grey600,
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo expandido
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtro de placa
                  Text(
                    'Veículo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedPlate,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.grey300),
                      ),
                    ),
                    hint: const Text('Todos os veículos'),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Todos os veículos'),
                      ),
                      ...widget.availablePlates.map((plate) => DropdownMenuItem(
                            value: plate,
                            child: Text(plate),
                          )),
                    ],
                    onChanged: (value) => setState(() => _selectedPlate = value),
                  ),
                  const SizedBox(height: 16),

                  // Filtro de período
                  Text(
                    'Período',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: AppColors.grey600),
                                const SizedBox(width: 8),
                                Text(
                                  _startDate != null ? dateFormat.format(_startDate!) : 'Início',
                                  style: TextStyle(
                                    color: _startDate != null ? AppColors.grey800 : AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('até', style: TextStyle(color: AppColors.grey600)),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: AppColors.grey600),
                                const SizedBox(width: 8),
                                Text(
                                  _endDate != null ? dateFormat.format(_endDate!) : 'Fim',
                                  style: TextStyle(
                                    color: _endDate != null ? AppColors.grey800 : AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: AppColors.grey400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Limpar',
                            style: TextStyle(color: AppColors.grey600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.zecaBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Aplicar Filtros',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
