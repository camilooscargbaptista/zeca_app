// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseCategoryModelImpl _$$ExpenseCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseCategoryModelImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ExpenseCategoryModelImplToJson(
        _$ExpenseCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'parent_id': instance.parentId,
      'icon': instance.icon,
      'color': instance.color,
      'is_active': instance.isActive,
    };
