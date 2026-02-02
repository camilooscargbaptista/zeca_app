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
      categoryCode: json['category_code'] as String,
      categoryName: json['category_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      location: json['location'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      expenseDate: DateTime.parse(json['expense_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'category_id': instance.categoryId,
      'category_code': instance.categoryCode,
      'category_name': instance.categoryName,
      'amount': instance.amount,
      'description': instance.description,
      'location': instance.location,
      'receipt_url': instance.receiptUrl,
      'expense_date': instance.expenseDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
