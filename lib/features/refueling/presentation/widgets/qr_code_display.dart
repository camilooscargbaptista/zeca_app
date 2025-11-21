import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/refueling_code_entity.dart';
import '../../../../core/config/flavor_config.dart';

class QRCodeDisplay extends StatelessWidget {
  final RefuelingCodeEntity refuelingCode;
  final VoidCallback? onShare;
  final VoidCallback? onRefresh;

  const QRCodeDisplay({
    Key? key,
    required this.refuelingCode,
    this.onShare,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cabeçalho
            Row(
              children: [
                Icon(
                  Icons.qr_code,
                  color: FlavorConfig.instance.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código de Abastecimento',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        refuelingCode.codigo,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: FlavorConfig.instance.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRefresh != null)
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Atualizar',
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // QR Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: refuelingCode.qrCode,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Informações do veículo
            _buildInfoCard(
              context,
              'Veículo',
              '${refuelingCode.veiculo.marca} ${refuelingCode.veiculo.modelo}',
              refuelingCode.veiculo.placa,
              Icons.directions_car,
            ),
            const SizedBox(height: 16),

            // Informações do posto
            _buildInfoCard(
              context,
              'Posto',
              refuelingCode.posto.nome,
              refuelingCode.posto.cnpj,
              Icons.local_gas_station,
            ),
            const SizedBox(height: 16),

            // Dados do abastecimento
            _buildRefuelingData(context),
            const SizedBox(height: 24),

            // Validade
            _buildValidityInfo(context),
            const SizedBox(height: 24),

            // Botões de ação
            Row(
              children: [
                if (onShare != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShare,
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar'),
                    ),
                  ),
                if (onShare != null) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar finalização do abastecimento
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Finalizar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlavorConfig.instance.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String subtitle,
    String detail,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: FlavorConfig.instance.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefuelingData(BuildContext context) {
    final data = refuelingCode.dadosAbastecimento;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlavorConfig.instance.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlavorConfig.instance.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados do Abastecimento',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: FlavorConfig.instance.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDataItem(
                  context,
                  'Combustível',
                  data.combustivel.toUpperCase(),
                ),
              ),
              Expanded(
                child: _buildDataItem(
                  context,
                  'Preço/L',
                  'R\$ ${data.precoLitro.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDataItem(
                  context,
                  'Qtd. Máx.',
                  '${data.quantidadeMaxima.toStringAsFixed(1)}L',
                ),
              ),
              Expanded(
                child: _buildDataItem(
                  context,
                  'Valor Máx.',
                  'R\$ ${data.valorMaximo.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          if (data.abastecerArla) ...[
            const SizedBox(height: 8),
            _buildDataItem(
              context,
              'ARLA 32',
              data.precoArla != null 
                  ? 'R\$ ${data.precoArla!.toStringAsFixed(2)}/L'
                  : 'Incluído',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildValidityInfo(BuildContext context) {
    final validade = refuelingCode.validade;
    final isExpiringSoon = validade.tempoRestanteMinutos < 30;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isExpiringSoon ? Colors.orange[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpiringSoon ? Colors.orange[200]! : Colors.green[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExpiringSoon ? Icons.warning : Icons.schedule,
            color: isExpiringSoon ? Colors.orange[700] : Colors.green[700],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Validade',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isExpiringSoon ? Colors.orange[700] : Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatValidity(validade.tempoRestanteMinutos),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isExpiringSoon ? Colors.orange[700] : Colors.green[700],
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

  String _formatValidity(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}min' : '${hours}h';
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      return remainingHours > 0 ? '${days}d ${remainingHours}h' : '${days}d';
    }
  }
}
