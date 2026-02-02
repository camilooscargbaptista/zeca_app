import 'package:equatable/equatable.dart';

/// Entity representing an Expense Category
class ExpenseCategoryEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String? icon;
  final String? color;
  final bool isActive;

  const ExpenseCategoryEntity({
    required this.id,
    required this.code,
    required this.name,
    this.icon,
    this.color,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, code, name, icon, color, isActive];
}
