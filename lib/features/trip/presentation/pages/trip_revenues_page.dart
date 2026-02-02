import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

/// Trip Revenues Page (US-005)
/// Manage trip revenues/freights
class TripRevenuesPage extends StatefulWidget {
  const TripRevenuesPage({super.key});

  @override
  State<TripRevenuesPage> createState() => _TripRevenuesPageState();
}

class _TripRevenuesPageState extends State<TripRevenuesPage> {
  bool _isLoading = false;
  bool _showAddForm = false;
  
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  // Colors
  static const Color _primaryGreen = Color(0xFF4CAF50);

  // Mock revenues data
  final List<Map<String, dynamic>> _revenues = [
    {
      'id': '1',
      'description': 'Frete SP → RJ',
      'amount': 1500.00,
      'origin': 'São Paulo, SP',
      'destination': 'Rio de Janeiro, RJ',
      'date': '2026-02-02T10:30:00',
      'status': 'CONFIRMED',
    },
    {
      'id': '2',
      'description': 'Frete RJ → BH',
      'amount': 1000.00,
      'origin': 'Rio de Janeiro, RJ',
      'destination': 'Belo Horizonte, MG',
      'date': '2026-02-01T15:00:00',
      'status': 'PENDING',
    },
  ];

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd/MM', 'pt_BR').format(date);
  }

  double get _totalRevenue {
    return _revenues.fold(0.0, (sum, r) => sum + (r['amount'] as double));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _addRevenue() {
    if (_amountController.text.isEmpty) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() {
      _revenues.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'description': _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : 'Frete ${_originController.text} → ${_destinationController.text}',
        'amount': amount,
        'origin': _originController.text,
        'destination': _destinationController.text,
        'date': DateTime.now().toIso8601String(),
        'status': 'PENDING',
      });
      _showAddForm = false;
      _amountController.clear();
      _descriptionController.clear();
      _originController.clear();
      _destinationController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receita adicionada com sucesso!'),
        backgroundColor: _primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: _primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('Receitas / Fretes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Summary Header
          _buildSummaryHeader(),

          // Revenues List
          Expanded(
            child: _revenues.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _revenues.length + (_showAddForm ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_showAddForm && index == 0) {
                        return _buildAddForm();
                      }
                      final adjustedIndex = _showAddForm ? index - 1 : index;
                      return _buildRevenueCard(_revenues[adjustedIndex]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _showAddForm
          ? null
          : FloatingActionButton.extended(
              onPressed: () => setState(() => _showAddForm = true),
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Nova Receita'),
            ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.attach_money, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total de Receitas',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(_totalRevenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_revenues.length} frete(s)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma receita registrada',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione seus fretes para controlar seus ganhos',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_circle, color: _primaryGreen),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Nova Receita',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _showAddForm = false),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Amount
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Valor do Frete',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descrição (opcional)',
              hintText: 'Ex: Carga de grãos',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Origin / Destination
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _originController,
                  decoration: InputDecoration(
                    labelText: 'Origem',
                    hintText: 'Cidade, UF',
                    prefixIcon: const Icon(Icons.trip_origin, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destino',
                    hintText: 'Cidade, UF',
                    prefixIcon: const Icon(Icons.place, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addRevenue,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'ADICIONAR RECEITA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(Map<String, dynamic> revenue) {
    final status = revenue['status'] as String;
    final isConfirmed = status == 'CONFIRMED';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_shipping, color: _primaryGreen, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      revenue['description'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(revenue['date'] as String),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(revenue['amount'] as double),
                    style: const TextStyle(
                      color: _primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isConfirmed 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isConfirmed ? 'Confirmado' : 'Pendente',
                      style: TextStyle(
                        color: isConfirmed ? Colors.green : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (revenue['origin'] != null && (revenue['origin'] as String).isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.trip_origin, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  revenue['origin'] as String,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Icon(Icons.place, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  revenue['destination'] as String,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
