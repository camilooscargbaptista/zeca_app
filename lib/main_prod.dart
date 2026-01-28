import 'main.dart';
import 'core/config/flavor_config.dart';

/// Entrypoint para ambiente PRODUÇÃO
/// Use este arquivo com o scheme Runner-Prod no Xcode
void main() {
  mainCommon(Flavor.prod);
}
