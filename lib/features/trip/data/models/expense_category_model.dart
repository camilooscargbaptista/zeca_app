import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/expense_category.dart';

part 'expense_category_model.freezed.dart';
part 'expense_category_model.g.dart';

@freezed
class ExpenseCategoryModel with _$ExpenseCategoryModel {
  const ExpenseCategoryModel._();

  const factory ExpenseCategoryModel({
    required String id,
    required String code,
    required String name,
    String? icon,
    String? color,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ExpenseCategoryModel;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryModelFromJson(json);

  /// Convert to domain entity
  ExpenseCategoryEntity toEntity() => ExpenseCategoryEntity(
        id: id,
        code: code,
        name: name,
        icon: icon,
        color: color,
        isActive: isActive,
      );
}
