import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';

class CPFInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  
  const CPFInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: 'CPF',
      hint: '000.000.000-00',
      keyboardType: TextInputType.number,
      inputFormatters: [Formatters.cpfFormatter],
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      prefixIcon: const Icon(Icons.person_outline),
    );
  }
}
