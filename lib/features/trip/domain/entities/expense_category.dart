import 'package:equatable/equatable.dart';

/// Entity representing an Expense Category
class ExpenseCategoryEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String? parentId;
  final String? icon;
  final String? color;
  final bool isActive;

  const ExpenseCategoryEntity({
    required this.id,
    required this.code,
    required this.name,
    this.parentId,
    this.icon,
    this.color,
    this.isActive = true,
  });

  /// True se é uma categoria pai (sem parentId)
  bool get isParent => parentId == null;

  /// True se é uma categoria filha (tem parentId)
  bool get isChild => parentId != null;

  @override
  List<Object?> get props => [id, code, name, parentId, icon, color, isActive];
}
