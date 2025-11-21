import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';

class Validators {
  // CPF
  static bool isValidCPF(String cpf) {
    return CPFValidator.isValid(cpf);
  }
  
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    final cpfClean = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpfClean.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    
    if (!CPFValidator.isValid(cpfClean)) {
      return 'CPF inválido';
    }
    
    return null;
  }
  
  // CNPJ
  static bool isValidCNPJ(String cnpj) {
    return CNPJValidator.isValid(cnpj);
  }
  
  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }
    
    final cnpjClean = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cnpjClean.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    
    if (!CNPJValidator.isValid(cnpjClean)) {
      return 'CNPJ inválido';
    }
    
    return null;
  }
  
  // Placa (formato antigo e Mercosul)
  static bool isValidPlaca(String placa) {
    // Formato antigo: ABC-1234
    final oldFormat = RegExp(r'^[A-Z]{3}-\d{4}$');
    // Formato Mercosul: ABC1D23
    final mercosulFormat = RegExp(r'^[A-Z]{3}\d[A-Z0-9]\d{2}$');
    
    return oldFormat.hasMatch(placa) || mercosulFormat.hasMatch(placa);
  }
  
  static String? validatePlaca(String? value) {
    if (value == null || value.isEmpty) {
      return 'Placa é obrigatória';
    }
    
    if (!isValidPlaca(value)) {
      return 'Placa inválida';
    }
    
    return null;
  }
  
  // KM (validação específica para abastecimento)
  static String? validateKM(String? value, int lastKM) {
    if (value == null || value.isEmpty) {
      return 'KM é obrigatório';
    }
    
    final km = int.tryParse(value);
    if (km == null) {
      return 'KM inválido';
    }
    
    if (km <= lastKM) {
      return 'KM deve ser maior que o último registrado ($lastKM)';
    }
    
    if (km - lastKM > 5000) {
      return 'Diferença de KM muito grande (> 5000km)';
    }
    
    return null;
  }
  
  // Quantidade de combustível
  static String? validateFuelQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantidade é obrigatória';
    }
    
    final quantity = double.tryParse(value.replaceAll(',', '.'));
    if (quantity == null) {
      return 'Quantidade inválida';
    }
    
    if (quantity <= 0) {
      return 'Quantidade deve ser maior que zero';
    }
    
    if (quantity > 200) {
      return 'Quantidade muito alta (máximo 200L)';
    }
    
    return null;
  }
  
  // Preço por litro
  static String? validatePricePerLiter(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preço é obrigatório';
    }
    
    final price = double.tryParse(value.replaceAll(',', '.'));
    if (price == null) {
      return 'Preço inválido';
    }
    
    if (price <= 0) {
      return 'Preço deve ser maior que zero';
    }
    
    if (price > 20) {
      return 'Preço muito alto (máximo R\$ 20,00)';
    }
    
    return null;
  }
  
  // Required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
  
  // Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  // Telefone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    final phoneClean = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (phoneClean.length < 10 || phoneClean.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }
}
