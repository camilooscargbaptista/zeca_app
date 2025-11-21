import 'package:flutter/services.dart';

class Formatters {
  // Formatter para quilometragem
  static final TextInputFormatter kmFormatter = FilteringTextInputFormatter.digitsOnly;
  
  // Formatter para placa de veículo
  static final TextInputFormatter placaFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[A-Za-z0-9]'),
  );
  
  // Formatter para CNPJ
  static final TextInputFormatter cnpjFormatter = FilteringTextInputFormatter.digitsOnly;
  
  // Formatter para CPF
  static final TextInputFormatter cpfFormatter = FilteringTextInputFormatter.digitsOnly;
  
  // Formatter para telefone
  static final TextInputFormatter phoneFormatter = FilteringTextInputFormatter.digitsOnly;
  
  // Formatter para preço
  static final TextInputFormatter priceFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9.,]'),
  );
  
  // Formatter para quantidade
  static final TextInputFormatter quantityFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9.,]'),
  );
  
  // Formatters para formatação de strings
  static String formatCPF(String cpf) {
    // Remove todos os caracteres não numéricos
    String cleaned = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica a máscara XXX.XXX.XXX-XX
    if (cleaned.length >= 11) {
      return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6, 9)}-${cleaned.substring(9, 11)}';
    } else if (cleaned.length >= 9) {
      return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6, 9)}-${cleaned.substring(9)}';
    } else if (cleaned.length >= 6) {
      return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6)}';
    } else if (cleaned.length >= 3) {
      return '${cleaned.substring(0, 3)}.${cleaned.substring(3)}';
    }
    return cleaned;
  }
  
  static String formatCNPJ(String cnpj) {
    // Remove todos os caracteres não numéricos
    String cleaned = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica a máscara XX.XXX.XXX/XXXX-XX
    if (cleaned.length >= 14) {
      return '${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}.${cleaned.substring(5, 8)}/${cleaned.substring(8, 12)}-${cleaned.substring(12, 14)}';
    } else if (cleaned.length >= 12) {
      return '${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}.${cleaned.substring(5, 8)}/${cleaned.substring(8, 12)}-${cleaned.substring(12)}';
    } else if (cleaned.length >= 8) {
      return '${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}.${cleaned.substring(5, 8)}/${cleaned.substring(8)}';
    } else if (cleaned.length >= 5) {
      return '${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}.${cleaned.substring(5)}';
    } else if (cleaned.length >= 2) {
      return '${cleaned.substring(0, 2)}.${cleaned.substring(2)}';
    }
    return cleaned;
  }
  
  static String formatPhone(String phone) {
    // Remove todos os caracteres não numéricos
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica a máscara (XX) XXXXX-XXXX ou (XX) XXXX-XXXX
    if (cleaned.length >= 11) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 7)}-${cleaned.substring(7, 11)}';
    } else if (cleaned.length >= 10) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 6)}-${cleaned.substring(6, 10)}';
    } else if (cleaned.length >= 6) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
    } else if (cleaned.length >= 2) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2)}';
    }
    return cleaned;
  }
}