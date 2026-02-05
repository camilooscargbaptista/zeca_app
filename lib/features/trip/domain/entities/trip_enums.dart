/// Trip Expense Categories
enum ExpenseCategory {
  fuel('FUEL', 'Combustível', '⛽'),
  toll('TOLL', 'Pedágio', '🛣️'),
  food('FOOD', 'Alimentação', '🍽️'),
  lodging('LODGING', 'Hospedagem', '🏨'),
  maintenance('MAINTENANCE', 'Manutenção', '🔧'),
  other('OTHER', 'Outros', '📦');

  final String code;
  final String label;
  final String icon;

  const ExpenseCategory(this.code, this.label, this.icon);

  static ExpenseCategory fromCode(String code) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ExpenseCategory.other,
    );
  }
}

/// Trip Status
enum TripStatus {
  active('ACTIVE', 'Ativa'),
  paused('PAUSED', 'Pausada'),
  completed('COMPLETED', 'Finalizada'),
  cancelled('CANCELLED', 'Cancelada');

  final String code;
  final String label;

  const TripStatus(this.code, this.label);

  static TripStatus fromCode(String code) {
    return TripStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => TripStatus.active,
    );
  }
}

/// Revenue Status
enum RevenueStatus {
  pending('PENDING', 'Pendente'),
  paid('PAID', 'Pago');

  final String code;
  final String label;

  const RevenueStatus(this.code, this.label);

  static RevenueStatus fromCode(String code) {
    return RevenueStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => RevenueStatus.pending,
    );
  }
}
