// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseBreakdownModel _$ExpenseBreakdownModelFromJson(
    Map<String, dynamic> json) {
  return _ExpenseBreakdownModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseBreakdownModel {
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_icon')
  String? get categoryIcon => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseBreakdownModelCopyWith<ExpenseBreakdownModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseBreakdownModelCopyWith<$Res> {
  factory $ExpenseBreakdownModelCopyWith(ExpenseBreakdownModel value,
          $Res Function(ExpenseBreakdownModel) then) =
      _$ExpenseBreakdownModelCopyWithImpl<$Res, ExpenseBreakdownModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'category_name') String categoryName,
      @JsonKey(name: 'category_icon') String? categoryIcon,
      double amount,
      int count,
      double percentage});
}

/// @nodoc
class _$ExpenseBreakdownModelCopyWithImpl<$Res,
        $Val extends ExpenseBreakdownModel>
    implements $ExpenseBreakdownModelCopyWith<$Res> {
  _$ExpenseBreakdownModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? amount = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIcon: freezed == categoryIcon
          ? _value.categoryIcon
          : categoryIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseBreakdownModelImplCopyWith<$Res>
    implements $ExpenseBreakdownModelCopyWith<$Res> {
  factory _$$ExpenseBreakdownModelImplCopyWith(
          _$ExpenseBreakdownModelImpl value,
          $Res Function(_$ExpenseBreakdownModelImpl) then) =
      __$$ExpenseBreakdownModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'category_name') String categoryName,
      @JsonKey(name: 'category_icon') String? categoryIcon,
      double amount,
      int count,
      double percentage});
}

/// @nodoc
class __$$ExpenseBreakdownModelImplCopyWithImpl<$Res>
    extends _$ExpenseBreakdownModelCopyWithImpl<$Res,
        _$ExpenseBreakdownModelImpl>
    implements _$$ExpenseBreakdownModelImplCopyWith<$Res> {
  __$$ExpenseBreakdownModelImplCopyWithImpl(_$ExpenseBreakdownModelImpl _value,
      $Res Function(_$ExpenseBreakdownModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? amount = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(_$ExpenseBreakdownModelImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIcon: freezed == categoryIcon
          ? _value.categoryIcon
          : categoryIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseBreakdownModelImpl implements _ExpenseBreakdownModel {
  const _$ExpenseBreakdownModelImpl(
      {@JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'category_name') this.categoryName = 'Outros',
      @JsonKey(name: 'category_icon') this.categoryIcon,
      this.amount = 0,
      this.count = 0,
      this.percentage = 0});

  factory _$ExpenseBreakdownModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseBreakdownModelImplFromJson(json);

  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  @JsonKey(name: 'category_icon')
  final String? categoryIcon;
  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final double percentage;

  @override
  String toString() {
    return 'ExpenseBreakdownModel(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, amount: $amount, count: $count, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseBreakdownModelImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryName,
      categoryIcon, amount, count, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseBreakdownModelImplCopyWith<_$ExpenseBreakdownModelImpl>
      get copyWith => __$$ExpenseBreakdownModelImplCopyWithImpl<
          _$ExpenseBreakdownModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseBreakdownModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseBreakdownModel implements ExpenseBreakdownModel {
  const factory _ExpenseBreakdownModel(
      {@JsonKey(name: 'category_id') required final String categoryId,
      @JsonKey(name: 'category_name') final String categoryName,
      @JsonKey(name: 'category_icon') final String? categoryIcon,
      final double amount,
      final int count,
      final double percentage}) = _$ExpenseBreakdownModelImpl;

  factory _ExpenseBreakdownModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseBreakdownModelImpl.fromJson;

  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  @JsonKey(name: 'category_icon')
  String? get categoryIcon;
  @override
  double get amount;
  @override
  int get count;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseBreakdownModelImplCopyWith<_$ExpenseBreakdownModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RevenueBreakdownModel _$RevenueBreakdownModelFromJson(
    Map<String, dynamic> json) {
  return _RevenueBreakdownModel.fromJson(json);
}

/// @nodoc
mixin _$RevenueBreakdownModel {
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'revenue_count')
  int get revenueCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_received')
  double get advanceReceived => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_amount')
  double get pendingAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RevenueBreakdownModelCopyWith<RevenueBreakdownModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueBreakdownModelCopyWith<$Res> {
  factory $RevenueBreakdownModelCopyWith(RevenueBreakdownModel value,
          $Res Function(RevenueBreakdownModel) then) =
      _$RevenueBreakdownModelCopyWithImpl<$Res, RevenueBreakdownModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'revenue_count') int revenueCount,
      @JsonKey(name: 'advance_received') double advanceReceived,
      @JsonKey(name: 'pending_amount') double pendingAmount});
}

/// @nodoc
class _$RevenueBreakdownModelCopyWithImpl<$Res,
        $Val extends RevenueBreakdownModel>
    implements $RevenueBreakdownModelCopyWith<$Res> {
  _$RevenueBreakdownModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? revenueCount = null,
    Object? advanceReceived = null,
    Object? pendingAmount = null,
  }) {
    return _then(_value.copyWith(
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      revenueCount: null == revenueCount
          ? _value.revenueCount
          : revenueCount // ignore: cast_nullable_to_non_nullable
              as int,
      advanceReceived: null == advanceReceived
          ? _value.advanceReceived
          : advanceReceived // ignore: cast_nullable_to_non_nullable
              as double,
      pendingAmount: null == pendingAmount
          ? _value.pendingAmount
          : pendingAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueBreakdownModelImplCopyWith<$Res>
    implements $RevenueBreakdownModelCopyWith<$Res> {
  factory _$$RevenueBreakdownModelImplCopyWith(
          _$RevenueBreakdownModelImpl value,
          $Res Function(_$RevenueBreakdownModelImpl) then) =
      __$$RevenueBreakdownModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'revenue_count') int revenueCount,
      @JsonKey(name: 'advance_received') double advanceReceived,
      @JsonKey(name: 'pending_amount') double pendingAmount});
}

/// @nodoc
class __$$RevenueBreakdownModelImplCopyWithImpl<$Res>
    extends _$RevenueBreakdownModelCopyWithImpl<$Res,
        _$RevenueBreakdownModelImpl>
    implements _$$RevenueBreakdownModelImplCopyWith<$Res> {
  __$$RevenueBreakdownModelImplCopyWithImpl(_$RevenueBreakdownModelImpl _value,
      $Res Function(_$RevenueBreakdownModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? revenueCount = null,
    Object? advanceReceived = null,
    Object? pendingAmount = null,
  }) {
    return _then(_$RevenueBreakdownModelImpl(
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      revenueCount: null == revenueCount
          ? _value.revenueCount
          : revenueCount // ignore: cast_nullable_to_non_nullable
              as int,
      advanceReceived: null == advanceReceived
          ? _value.advanceReceived
          : advanceReceived // ignore: cast_nullable_to_non_nullable
              as double,
      pendingAmount: null == pendingAmount
          ? _value.pendingAmount
          : pendingAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueBreakdownModelImpl implements _RevenueBreakdownModel {
  const _$RevenueBreakdownModelImpl(
      {@JsonKey(name: 'total_revenue') this.totalRevenue = 0,
      @JsonKey(name: 'revenue_count') this.revenueCount = 0,
      @JsonKey(name: 'advance_received') this.advanceReceived = 0,
      @JsonKey(name: 'pending_amount') this.pendingAmount = 0});

  factory _$RevenueBreakdownModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueBreakdownModelImplFromJson(json);

  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'revenue_count')
  final int revenueCount;
  @override
  @JsonKey(name: 'advance_received')
  final double advanceReceived;
  @override
  @JsonKey(name: 'pending_amount')
  final double pendingAmount;

  @override
  String toString() {
    return 'RevenueBreakdownModel(totalRevenue: $totalRevenue, revenueCount: $revenueCount, advanceReceived: $advanceReceived, pendingAmount: $pendingAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueBreakdownModelImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.revenueCount, revenueCount) ||
                other.revenueCount == revenueCount) &&
            (identical(other.advanceReceived, advanceReceived) ||
                other.advanceReceived == advanceReceived) &&
            (identical(other.pendingAmount, pendingAmount) ||
                other.pendingAmount == pendingAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalRevenue, revenueCount, advanceReceived, pendingAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueBreakdownModelImplCopyWith<_$RevenueBreakdownModelImpl>
      get copyWith => __$$RevenueBreakdownModelImplCopyWithImpl<
          _$RevenueBreakdownModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueBreakdownModelImplToJson(
      this,
    );
  }
}

abstract class _RevenueBreakdownModel implements RevenueBreakdownModel {
  const factory _RevenueBreakdownModel(
          {@JsonKey(name: 'total_revenue') final double totalRevenue,
          @JsonKey(name: 'revenue_count') final int revenueCount,
          @JsonKey(name: 'advance_received') final double advanceReceived,
          @JsonKey(name: 'pending_amount') final double pendingAmount}) =
      _$RevenueBreakdownModelImpl;

  factory _RevenueBreakdownModel.fromJson(Map<String, dynamic> json) =
      _$RevenueBreakdownModelImpl.fromJson;

  @override
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'revenue_count')
  int get revenueCount;
  @override
  @JsonKey(name: 'advance_received')
  double get advanceReceived;
  @override
  @JsonKey(name: 'pending_amount')
  double get pendingAmount;
  @override
  @JsonKey(ignore: true)
  _$$RevenueBreakdownModelImplCopyWith<_$RevenueBreakdownModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TripSummaryModel _$TripSummaryModelFromJson(Map<String, dynamic> json) {
  return _TripSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$TripSummaryModel {
// Identificação
  @JsonKey(name: 'reference_id')
  String get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String get referenceType => throw _privateConstructorUsedError; // Distância
  @JsonKey(name: 'distance_km')
  double get distanceKm => throw _privateConstructorUsedError; // Gastos
  @JsonKey(name: 'variable_expenses')
  double get variableExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'fixed_expenses')
  double get fixedExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  double get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_km')
  double get costPerKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'expenses_by_category')
  List<ExpenseBreakdownModel> get expensesByCategory =>
      throw _privateConstructorUsedError; // Receitas
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'revenue_breakdown')
  RevenueBreakdownModel? get revenueBreakdown =>
      throw _privateConstructorUsedError; // Resultado
  double get profit => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_margin')
  double get profitMargin => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_per_km')
  double get profitPerKm => throw _privateConstructorUsedError; // Opcionais
  @JsonKey(name: 'avg_cost_per_km')
  double? get avgCostPerKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_variation_percent')
  double? get costVariationPercent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripSummaryModelCopyWith<TripSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripSummaryModelCopyWith<$Res> {
  factory $TripSummaryModelCopyWith(
          TripSummaryModel value, $Res Function(TripSummaryModel) then) =
      _$TripSummaryModelCopyWithImpl<$Res, TripSummaryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'reference_id') String referenceId,
      @JsonKey(name: 'reference_type') String referenceType,
      @JsonKey(name: 'distance_km') double distanceKm,
      @JsonKey(name: 'variable_expenses') double variableExpenses,
      @JsonKey(name: 'fixed_expenses') double fixedExpenses,
      @JsonKey(name: 'total_expenses') double totalExpenses,
      @JsonKey(name: 'cost_per_km') double costPerKm,
      @JsonKey(name: 'expenses_by_category')
      List<ExpenseBreakdownModel> expensesByCategory,
      @JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'revenue_breakdown')
      RevenueBreakdownModel? revenueBreakdown,
      double profit,
      @JsonKey(name: 'profit_margin') double profitMargin,
      @JsonKey(name: 'profit_per_km') double profitPerKm,
      @JsonKey(name: 'avg_cost_per_km') double? avgCostPerKm,
      @JsonKey(name: 'cost_variation_percent') double? costVariationPercent});

  $RevenueBreakdownModelCopyWith<$Res>? get revenueBreakdown;
}

/// @nodoc
class _$TripSummaryModelCopyWithImpl<$Res, $Val extends TripSummaryModel>
    implements $TripSummaryModelCopyWith<$Res> {
  _$TripSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referenceId = null,
    Object? referenceType = null,
    Object? distanceKm = null,
    Object? variableExpenses = null,
    Object? fixedExpenses = null,
    Object? totalExpenses = null,
    Object? costPerKm = null,
    Object? expensesByCategory = null,
    Object? totalRevenue = null,
    Object? revenueBreakdown = freezed,
    Object? profit = null,
    Object? profitMargin = null,
    Object? profitPerKm = null,
    Object? avgCostPerKm = freezed,
    Object? costVariationPercent = freezed,
  }) {
    return _then(_value.copyWith(
      referenceId: null == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceType: null == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      variableExpenses: null == variableExpenses
          ? _value.variableExpenses
          : variableExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      fixedExpenses: null == fixedExpenses
          ? _value.fixedExpenses
          : fixedExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      costPerKm: null == costPerKm
          ? _value.costPerKm
          : costPerKm // ignore: cast_nullable_to_non_nullable
              as double,
      expensesByCategory: null == expensesByCategory
          ? _value.expensesByCategory
          : expensesByCategory // ignore: cast_nullable_to_non_nullable
              as List<ExpenseBreakdownModel>,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      revenueBreakdown: freezed == revenueBreakdown
          ? _value.revenueBreakdown
          : revenueBreakdown // ignore: cast_nullable_to_non_nullable
              as RevenueBreakdownModel?,
      profit: null == profit
          ? _value.profit
          : profit // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      profitPerKm: null == profitPerKm
          ? _value.profitPerKm
          : profitPerKm // ignore: cast_nullable_to_non_nullable
              as double,
      avgCostPerKm: freezed == avgCostPerKm
          ? _value.avgCostPerKm
          : avgCostPerKm // ignore: cast_nullable_to_non_nullable
              as double?,
      costVariationPercent: freezed == costVariationPercent
          ? _value.costVariationPercent
          : costVariationPercent // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RevenueBreakdownModelCopyWith<$Res>? get revenueBreakdown {
    if (_value.revenueBreakdown == null) {
      return null;
    }

    return $RevenueBreakdownModelCopyWith<$Res>(_value.revenueBreakdown!,
        (value) {
      return _then(_value.copyWith(revenueBreakdown: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripSummaryModelImplCopyWith<$Res>
    implements $TripSummaryModelCopyWith<$Res> {
  factory _$$TripSummaryModelImplCopyWith(_$TripSummaryModelImpl value,
          $Res Function(_$TripSummaryModelImpl) then) =
      __$$TripSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'reference_id') String referenceId,
      @JsonKey(name: 'reference_type') String referenceType,
      @JsonKey(name: 'distance_km') double distanceKm,
      @JsonKey(name: 'variable_expenses') double variableExpenses,
      @JsonKey(name: 'fixed_expenses') double fixedExpenses,
      @JsonKey(name: 'total_expenses') double totalExpenses,
      @JsonKey(name: 'cost_per_km') double costPerKm,
      @JsonKey(name: 'expenses_by_category')
      List<ExpenseBreakdownModel> expensesByCategory,
      @JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'revenue_breakdown')
      RevenueBreakdownModel? revenueBreakdown,
      double profit,
      @JsonKey(name: 'profit_margin') double profitMargin,
      @JsonKey(name: 'profit_per_km') double profitPerKm,
      @JsonKey(name: 'avg_cost_per_km') double? avgCostPerKm,
      @JsonKey(name: 'cost_variation_percent') double? costVariationPercent});

  @override
  $RevenueBreakdownModelCopyWith<$Res>? get revenueBreakdown;
}

/// @nodoc
class __$$TripSummaryModelImplCopyWithImpl<$Res>
    extends _$TripSummaryModelCopyWithImpl<$Res, _$TripSummaryModelImpl>
    implements _$$TripSummaryModelImplCopyWith<$Res> {
  __$$TripSummaryModelImplCopyWithImpl(_$TripSummaryModelImpl _value,
      $Res Function(_$TripSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referenceId = null,
    Object? referenceType = null,
    Object? distanceKm = null,
    Object? variableExpenses = null,
    Object? fixedExpenses = null,
    Object? totalExpenses = null,
    Object? costPerKm = null,
    Object? expensesByCategory = null,
    Object? totalRevenue = null,
    Object? revenueBreakdown = freezed,
    Object? profit = null,
    Object? profitMargin = null,
    Object? profitPerKm = null,
    Object? avgCostPerKm = freezed,
    Object? costVariationPercent = freezed,
  }) {
    return _then(_$TripSummaryModelImpl(
      referenceId: null == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceType: null == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      variableExpenses: null == variableExpenses
          ? _value.variableExpenses
          : variableExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      fixedExpenses: null == fixedExpenses
          ? _value.fixedExpenses
          : fixedExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      costPerKm: null == costPerKm
          ? _value.costPerKm
          : costPerKm // ignore: cast_nullable_to_non_nullable
              as double,
      expensesByCategory: null == expensesByCategory
          ? _value._expensesByCategory
          : expensesByCategory // ignore: cast_nullable_to_non_nullable
              as List<ExpenseBreakdownModel>,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      revenueBreakdown: freezed == revenueBreakdown
          ? _value.revenueBreakdown
          : revenueBreakdown // ignore: cast_nullable_to_non_nullable
              as RevenueBreakdownModel?,
      profit: null == profit
          ? _value.profit
          : profit // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      profitPerKm: null == profitPerKm
          ? _value.profitPerKm
          : profitPerKm // ignore: cast_nullable_to_non_nullable
              as double,
      avgCostPerKm: freezed == avgCostPerKm
          ? _value.avgCostPerKm
          : avgCostPerKm // ignore: cast_nullable_to_non_nullable
              as double?,
      costVariationPercent: freezed == costVariationPercent
          ? _value.costVariationPercent
          : costVariationPercent // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripSummaryModelImpl extends _TripSummaryModel {
  const _$TripSummaryModelImpl(
      {@JsonKey(name: 'reference_id') required this.referenceId,
      @JsonKey(name: 'reference_type') this.referenceType = 'TRIP',
      @JsonKey(name: 'distance_km') this.distanceKm = 0,
      @JsonKey(name: 'variable_expenses') this.variableExpenses = 0,
      @JsonKey(name: 'fixed_expenses') this.fixedExpenses = 0,
      @JsonKey(name: 'total_expenses') this.totalExpenses = 0,
      @JsonKey(name: 'cost_per_km') this.costPerKm = 0,
      @JsonKey(name: 'expenses_by_category')
      final List<ExpenseBreakdownModel> expensesByCategory = const [],
      @JsonKey(name: 'total_revenue') this.totalRevenue = 0,
      @JsonKey(name: 'revenue_breakdown') this.revenueBreakdown,
      this.profit = 0,
      @JsonKey(name: 'profit_margin') this.profitMargin = 0,
      @JsonKey(name: 'profit_per_km') this.profitPerKm = 0,
      @JsonKey(name: 'avg_cost_per_km') this.avgCostPerKm,
      @JsonKey(name: 'cost_variation_percent') this.costVariationPercent})
      : _expensesByCategory = expensesByCategory,
        super._();

  factory _$TripSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripSummaryModelImplFromJson(json);

// Identificação
  @override
  @JsonKey(name: 'reference_id')
  final String referenceId;
  @override
  @JsonKey(name: 'reference_type')
  final String referenceType;
// Distância
  @override
  @JsonKey(name: 'distance_km')
  final double distanceKm;
// Gastos
  @override
  @JsonKey(name: 'variable_expenses')
  final double variableExpenses;
  @override
  @JsonKey(name: 'fixed_expenses')
  final double fixedExpenses;
  @override
  @JsonKey(name: 'total_expenses')
  final double totalExpenses;
  @override
  @JsonKey(name: 'cost_per_km')
  final double costPerKm;
  final List<ExpenseBreakdownModel> _expensesByCategory;
  @override
  @JsonKey(name: 'expenses_by_category')
  List<ExpenseBreakdownModel> get expensesByCategory {
    if (_expensesByCategory is EqualUnmodifiableListView)
      return _expensesByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expensesByCategory);
  }

// Receitas
  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'revenue_breakdown')
  final RevenueBreakdownModel? revenueBreakdown;
// Resultado
  @override
  @JsonKey()
  final double profit;
  @override
  @JsonKey(name: 'profit_margin')
  final double profitMargin;
  @override
  @JsonKey(name: 'profit_per_km')
  final double profitPerKm;
// Opcionais
  @override
  @JsonKey(name: 'avg_cost_per_km')
  final double? avgCostPerKm;
  @override
  @JsonKey(name: 'cost_variation_percent')
  final double? costVariationPercent;

  @override
  String toString() {
    return 'TripSummaryModel(referenceId: $referenceId, referenceType: $referenceType, distanceKm: $distanceKm, variableExpenses: $variableExpenses, fixedExpenses: $fixedExpenses, totalExpenses: $totalExpenses, costPerKm: $costPerKm, expensesByCategory: $expensesByCategory, totalRevenue: $totalRevenue, revenueBreakdown: $revenueBreakdown, profit: $profit, profitMargin: $profitMargin, profitPerKm: $profitPerKm, avgCostPerKm: $avgCostPerKm, costVariationPercent: $costVariationPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripSummaryModelImpl &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.variableExpenses, variableExpenses) ||
                other.variableExpenses == variableExpenses) &&
            (identical(other.fixedExpenses, fixedExpenses) ||
                other.fixedExpenses == fixedExpenses) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.costPerKm, costPerKm) ||
                other.costPerKm == costPerKm) &&
            const DeepCollectionEquality()
                .equals(other._expensesByCategory, _expensesByCategory) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.revenueBreakdown, revenueBreakdown) ||
                other.revenueBreakdown == revenueBreakdown) &&
            (identical(other.profit, profit) || other.profit == profit) &&
            (identical(other.profitMargin, profitMargin) ||
                other.profitMargin == profitMargin) &&
            (identical(other.profitPerKm, profitPerKm) ||
                other.profitPerKm == profitPerKm) &&
            (identical(other.avgCostPerKm, avgCostPerKm) ||
                other.avgCostPerKm == avgCostPerKm) &&
            (identical(other.costVariationPercent, costVariationPercent) ||
                other.costVariationPercent == costVariationPercent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      referenceId,
      referenceType,
      distanceKm,
      variableExpenses,
      fixedExpenses,
      totalExpenses,
      costPerKm,
      const DeepCollectionEquality().hash(_expensesByCategory),
      totalRevenue,
      revenueBreakdown,
      profit,
      profitMargin,
      profitPerKm,
      avgCostPerKm,
      costVariationPercent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripSummaryModelImplCopyWith<_$TripSummaryModelImpl> get copyWith =>
      __$$TripSummaryModelImplCopyWithImpl<_$TripSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _TripSummaryModel extends TripSummaryModel {
  const factory _TripSummaryModel(
      {@JsonKey(name: 'reference_id') required final String referenceId,
      @JsonKey(name: 'reference_type') final String referenceType,
      @JsonKey(name: 'distance_km') final double distanceKm,
      @JsonKey(name: 'variable_expenses') final double variableExpenses,
      @JsonKey(name: 'fixed_expenses') final double fixedExpenses,
      @JsonKey(name: 'total_expenses') final double totalExpenses,
      @JsonKey(name: 'cost_per_km') final double costPerKm,
      @JsonKey(name: 'expenses_by_category')
      final List<ExpenseBreakdownModel> expensesByCategory,
      @JsonKey(name: 'total_revenue') final double totalRevenue,
      @JsonKey(name: 'revenue_breakdown')
      final RevenueBreakdownModel? revenueBreakdown,
      final double profit,
      @JsonKey(name: 'profit_margin') final double profitMargin,
      @JsonKey(name: 'profit_per_km') final double profitPerKm,
      @JsonKey(name: 'avg_cost_per_km') final double? avgCostPerKm,
      @JsonKey(name: 'cost_variation_percent')
      final double? costVariationPercent}) = _$TripSummaryModelImpl;
  const _TripSummaryModel._() : super._();

  factory _TripSummaryModel.fromJson(Map<String, dynamic> json) =
      _$TripSummaryModelImpl.fromJson;

  @override // Identificação
  @JsonKey(name: 'reference_id')
  String get referenceId;
  @override
  @JsonKey(name: 'reference_type')
  String get referenceType;
  @override // Distância
  @JsonKey(name: 'distance_km')
  double get distanceKm;
  @override // Gastos
  @JsonKey(name: 'variable_expenses')
  double get variableExpenses;
  @override
  @JsonKey(name: 'fixed_expenses')
  double get fixedExpenses;
  @override
  @JsonKey(name: 'total_expenses')
  double get totalExpenses;
  @override
  @JsonKey(name: 'cost_per_km')
  double get costPerKm;
  @override
  @JsonKey(name: 'expenses_by_category')
  List<ExpenseBreakdownModel> get expensesByCategory;
  @override // Receitas
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'revenue_breakdown')
  RevenueBreakdownModel? get revenueBreakdown;
  @override // Resultado
  double get profit;
  @override
  @JsonKey(name: 'profit_margin')
  double get profitMargin;
  @override
  @JsonKey(name: 'profit_per_km')
  double get profitPerKm;
  @override // Opcionais
  @JsonKey(name: 'avg_cost_per_km')
  double? get avgCostPerKm;
  @override
  @JsonKey(name: 'cost_variation_percent')
  double? get costVariationPercent;
  @override
  @JsonKey(ignore: true)
  _$$TripSummaryModelImplCopyWith<_$TripSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
