import 'main.dart';
import 'core/config/flavor_config.dart';

/// Entrypoint para ambiente STAGING
/// Use este arquivo com o scheme Runner-Staging no Xcode
void main() {
  mainCommon(Flavor.staging);
}
