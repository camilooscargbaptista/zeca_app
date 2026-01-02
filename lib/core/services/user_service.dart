class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _driverCpf;
  String? _transporterCnpj;
  String? _userName;

  /// Definir dados do usuário após login
  void setUserData({
    required String driverCpf,
    required String transporterCnpj,
    String? userName,
  }) {
    _driverCpf = driverCpf;
    _transporterCnpj = transporterCnpj;
    _userName = userName;
  }

  /// Obter CPF do motorista
  String? get driverCpf => _driverCpf;

  /// Obter CNPJ da transportadora
  String? get transporterCnpj => _transporterCnpj;

  /// Obter nome do usuário
  String? get userName => _userName;

  /// Limpar dados do usuário (logout)
  void clearUserData() {
    _driverCpf = null;
    _transporterCnpj = null;
    _userName = null;
  }

  /// Verificar se usuário está logado
  bool get isLoggedIn => _driverCpf != null && _transporterCnpj != null;
}
