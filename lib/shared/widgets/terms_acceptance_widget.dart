import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget de checkbox para aceite de Termos de Uso e Política de Privacidade
/// com links clicáveis que abrem no navegador externo.
class TermsAcceptanceCheckbox extends StatelessWidget {
  /// Se o checkbox está marcado
  final bool value;
  
  /// Callback quando o valor muda
  final ValueChanged<bool?>? onChanged;
  
  /// URLs das páginas legais
  static const String termsUrl = 'https://www.abastecacomzeca.com.br/termos-uso';
  static const String privacyUrl = 'https://www.abastecacomzeca.com.br/politica-privacidade';

  const TermsAcceptanceCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  /// Abre uma URL no navegador externo
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('❌ Não foi possível abrir a URL: $url');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged?.call(!value),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Li e aceito os '),
                  TextSpan(
                    text: 'Termos de Uso',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _openUrl(termsUrl),
                  ),
                  const TextSpan(text: ' e a '),
                  TextSpan(
                    text: 'Política de Privacidade',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _openUrl(privacyUrl),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget de aceite simples com apenas texto (sem checkbox)
/// para exibir em telas que já possuem checkbox separado
class TermsAcceptanceText extends StatelessWidget {
  const TermsAcceptanceText({Key? key}) : super(key: key);

  /// URLs das páginas legais
  static const String termsUrl = 'https://www.abastecacomzeca.com.br/termos-uso';
  static const String privacyUrl = 'https://www.abastecacomzeca.com.br/politica-privacidade';

  /// Abre uma URL no navegador externo
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('❌ Não foi possível abrir a URL: $url');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          height: 1.4,
        ),
        children: [
          const TextSpan(text: 'Ao continuar, você concorda com os '),
          TextSpan(
            text: 'Termos de Uso',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openUrl(termsUrl),
          ),
          const TextSpan(text: ' e a '),
          TextSpan(
            text: 'Política de Privacidade',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openUrl(privacyUrl),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
