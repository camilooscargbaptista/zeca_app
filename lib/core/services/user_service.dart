class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _driverCpf;
  String? _transporterCnpj;
  String? _userName;
  bool _isAutonomous = false;

  /// Definir dados do usuário após login
  void setUserData({
    required String driverCpf,
    required String transporterCnpj,
    String? userName,
    bool isAutonomous = false,
  }) {
    _driverCpf = driverCpf;
    _transporterCnpj = transporterCnpj;
    _userName = userName;
    _isAutonomous = isAutonomous;
  }

  /// Obter CPF do motorista
  String? get driverCpf => _driverCpf;

  /// Obter CNPJ da transportadora
  String? get transporterCnpj => _transporterCnpj;

  /// Obter nome do usuário
  String? get userName => _userName;

  /// Verificar se é motorista autônomo
  bool get isAutonomous => _isAutonomous;

  /// Limpar dados do usuário (logout)
  void clearUserData() {
    _driverCpf = null;
    _transporterCnpj = null;
    _userName = null;
    _isAutonomous = false;
  }

  /// Verificar se usuário está logado
  /// Autônomos não precisam de transporterCnpj
  bool get isLoggedIn => _driverCpf != null && (_isAutonomous || _transporterCnpj != null);
}
