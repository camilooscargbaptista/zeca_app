// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      categoryId: json['category_id'] as String,
      categoryCode: json['category_code'] as String? ?? 'OTHER',
      categoryName: json['category_name'] as String? ?? 'Outros',
      amount: const AmountConverter().fromJson(json['amount']),
      description: json['description'] as String?,
      location: json['location'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      expenseDate: json['expense_date'] == null
          ? null
          : DateTime.parse(json['expense_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'category_id': instance.categoryId,
      'category_code': instance.categoryCode,
      'category_name': instance.categoryName,
      'amount': const AmountConverter().toJson(instance.amount),
      'description': instance.description,
      'location': instance.location,
      'receipt_url': instance.receiptUrl,
      'expense_date': instance.expenseDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
