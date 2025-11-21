import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../bloc/refueling_form_bloc.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/formatters.dart';

class RefuelingFormSection extends StatefulWidget {
  final VehicleEntity vehicle;
  final VoidCallback? onGenerateCode;

  const RefuelingFormSection({
    Key? key,
    required this.vehicle,
    this.onGenerateCode,
  }) : super(key: key);

  @override
  State<RefuelingFormSection> createState() => _RefuelingFormSectionState();
}

class _RefuelingFormSectionState extends State<RefuelingFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _kmController = TextEditingController();
  String _selectedFuel = 'diesel';
  bool _abastecerArla = false;

  @override
  void initState() {
    super.initState();
    _kmController.text = widget.vehicle.ultimoKm.toString();
  }

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }

  void _onGenerateCode() {
    if (_formKey.currentState?.validate() ?? false) {
      final km = int.tryParse(_kmController.text.replaceAll('.', '')) ?? 0;
      
      context.read<RefuelingFormBloc>().add(
        UpdateRefuelingData(
          veiculoId: widget.vehicle.id,
          veiculoPlaca: widget.vehicle.placa,
          kmAtual: km,
          combustivel: _selectedFuel,
          abastecerArla: _abastecerArla,
        ),
      );

      widget.onGenerateCode?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dados do Abastecimento',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // KM Atual
              CustomTextField(
                controller: _kmController,
                label: 'KM Atual',
                hint: 'Digite o KM atual do veículo',
                keyboardType: TextInputType.number,
                inputFormatters: [Formatters.kmFormatter],
                validator: (value) => Validators.validateKM(value, widget.vehicle.ultimoKm),
                onChanged: (value) {
                  final km = int.tryParse(value.replaceAll('.', '')) ?? 0;
                  context.read<RefuelingFormBloc>().add(UpdateKm(km));
                },
              ),
              const SizedBox(height: 16),

              // Tipo de Combustível
              Text(
                'Tipo de Combustível',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.vehicle.combustiveis.map((combustivel) {
                  final isSelected = _selectedFuel == combustivel;
                  return FilterChip(
                    label: Text(combustivel.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFuel = combustivel;
                        });
                        context.read<RefuelingFormBloc>().add(
                          SelectFuelType(combustivel),
                        );
                      }
                    },
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Abastecer ARLA
              CheckboxListTile(
                title: const Text('Abastecer ARLA 32'),
                subtitle: const Text('Aditivo para redução de emissões'),
                value: _abastecerArla,
                onChanged: (value) {
                  setState(() {
                    _abastecerArla = value ?? false;
                  });
                  context.read<RefuelingFormBloc>().add(
                    ToggleArla(_abastecerArla),
                  );
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // Botão Gerar Código
              CustomButton(
                text: 'Gerar Código de Abastecimento',
                onPressed: _onGenerateCode,
                isFullWidth: true,
                icon: Icons.qr_code,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
