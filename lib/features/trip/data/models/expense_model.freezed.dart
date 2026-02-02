// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'trip_id')
  String get tripId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_code')
  String get categoryCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_date')
  DateTime get expenseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
          ExpenseModel value, $Res Function(ExpenseModel) then) =
      _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'trip_id') String tripId,
      @JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'category_code') String categoryCode,
      @JsonKey(name: 'category_name') String categoryName,
      double amount,
      String? description,
      String? location,
      @JsonKey(name: 'receipt_url') String? receiptUrl,
      @JsonKey(name: 'expense_date') DateTime expenseDate,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? categoryId = null,
    Object? categoryCode = null,
    Object? categoryName = null,
    Object? amount = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? receiptUrl = freezed,
    Object? expenseDate = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryCode: null == categoryCode
          ? _value.categoryCode
          : categoryCode // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
          _$ExpenseModelImpl value, $Res Function(_$ExpenseModelImpl) then) =
      __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'trip_id') String tripId,
      @JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'category_code') String categoryCode,
      @JsonKey(name: 'category_name') String categoryName,
      double amount,
      String? description,
      String? location,
      @JsonKey(name: 'receipt_url') String? receiptUrl,
      @JsonKey(name: 'expense_date') DateTime expenseDate,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
      _$ExpenseModelImpl _value, $Res Function(_$ExpenseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? categoryId = null,
    Object? categoryCode = null,
    Object? categoryName = null,
    Object? amount = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? receiptUrl = freezed,
    Object? expenseDate = null,
    Object? createdAt = null,
  }) {
    return _then(_$ExpenseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryCode: null == categoryCode
          ? _value.categoryCode
          : categoryCode // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseModelImpl extends _ExpenseModel {
  const _$ExpenseModelImpl(
      {required this.id,
      @JsonKey(name: 'trip_id') required this.tripId,
      @JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'category_code') required this.categoryCode,
      @JsonKey(name: 'category_name') required this.categoryName,
      required this.amount,
      this.description,
      this.location,
      @JsonKey(name: 'receipt_url') this.receiptUrl,
      @JsonKey(name: 'expense_date') required this.expenseDate,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'trip_id')
  final String tripId;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'category_code')
  final String categoryCode;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  final double amount;
  @override
  final String? description;
  @override
  final String? location;
  @override
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;
  @override
  @JsonKey(name: 'expense_date')
  final DateTime expenseDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, tripId: $tripId, categoryId: $categoryId, categoryCode: $categoryCode, categoryName: $categoryName, amount: $amount, description: $description, location: $location, receiptUrl: $receiptUrl, expenseDate: $expenseDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryCode, categoryCode) ||
                other.categoryCode == categoryCode) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tripId,
      categoryId,
      categoryCode,
      categoryName,
      amount,
      description,
      location,
      receiptUrl,
      expenseDate,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseModel extends ExpenseModel {
  const factory _ExpenseModel(
          {required final String id,
          @JsonKey(name: 'trip_id') required final String tripId,
          @JsonKey(name: 'category_id') required final String categoryId,
          @JsonKey(name: 'category_code') required final String categoryCode,
          @JsonKey(name: 'category_name') required final String categoryName,
          required final double amount,
          final String? description,
          final String? location,
          @JsonKey(name: 'receipt_url') final String? receiptUrl,
          @JsonKey(name: 'expense_date') required final DateTime expenseDate,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$ExpenseModelImpl;
  const _ExpenseModel._() : super._();

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'trip_id')
  String get tripId;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'category_code')
  String get categoryCode;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  double get amount;
  @override
  String? get description;
  @override
  String? get location;
  @override
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl;
  @override
  @JsonKey(name: 'expense_date')
  DateTime get expenseDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
