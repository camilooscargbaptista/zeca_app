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

TripSummaryModel _$TripSummaryModelFromJson(Map<String, dynamic> json) {
  return _TripSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$TripSummaryModel {
  @JsonKey(name: 'trip_id')
  String get tripId => throw _privateConstructorUsedError;
  String? get origin => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_distance_km')
  double get totalDistanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  double get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_revenues')
  double get totalRevenues => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit')
  double get netProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_margin')
  double get profitMargin => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_km')
  double get costPerKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_count')
  int get expenseCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'revenue_count')
  int get revenueCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'expenses_by_category')
  Map<String, double> get expensesByCategory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'trip_id') String tripId,
      String? origin,
      String? destination,
      @JsonKey(name: 'total_distance_km') double totalDistanceKm,
      @JsonKey(name: 'total_expenses') double totalExpenses,
      @JsonKey(name: 'total_revenues') double totalRevenues,
      @JsonKey(name: 'net_profit') double netProfit,
      @JsonKey(name: 'profit_margin') double profitMargin,
      @JsonKey(name: 'cost_per_km') double costPerKm,
      @JsonKey(name: 'expense_count') int expenseCount,
      @JsonKey(name: 'revenue_count') int revenueCount,
      @JsonKey(name: 'expenses_by_category')
      Map<String, double> expensesByCategory,
      @JsonKey(name: 'started_at') DateTime? startedAt,
      @JsonKey(name: 'ended_at') DateTime? endedAt});
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
    Object? tripId = null,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? totalDistanceKm = null,
    Object? totalExpenses = null,
    Object? totalRevenues = null,
    Object? netProfit = null,
    Object? profitMargin = null,
    Object? costPerKm = null,
    Object? expenseCount = null,
    Object? revenueCount = null,
    Object? expensesByCategory = null,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDistanceKm: null == totalDistanceKm
          ? _value.totalDistanceKm
          : totalDistanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      totalRevenues: null == totalRevenues
          ? _value.totalRevenues
          : totalRevenues // ignore: cast_nullable_to_non_nullable
              as double,
      netProfit: null == netProfit
          ? _value.netProfit
          : netProfit // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      costPerKm: null == costPerKm
          ? _value.costPerKm
          : costPerKm // ignore: cast_nullable_to_non_nullable
              as double,
      expenseCount: null == expenseCount
          ? _value.expenseCount
          : expenseCount // ignore: cast_nullable_to_non_nullable
              as int,
      revenueCount: null == revenueCount
          ? _value.revenueCount
          : revenueCount // ignore: cast_nullable_to_non_nullable
              as int,
      expensesByCategory: null == expensesByCategory
          ? _value.expensesByCategory
          : expensesByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
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
      {@JsonKey(name: 'trip_id') String tripId,
      String? origin,
      String? destination,
      @JsonKey(name: 'total_distance_km') double totalDistanceKm,
      @JsonKey(name: 'total_expenses') double totalExpenses,
      @JsonKey(name: 'total_revenues') double totalRevenues,
      @JsonKey(name: 'net_profit') double netProfit,
      @JsonKey(name: 'profit_margin') double profitMargin,
      @JsonKey(name: 'cost_per_km') double costPerKm,
      @JsonKey(name: 'expense_count') int expenseCount,
      @JsonKey(name: 'revenue_count') int revenueCount,
      @JsonKey(name: 'expenses_by_category')
      Map<String, double> expensesByCategory,
      @JsonKey(name: 'started_at') DateTime? startedAt,
      @JsonKey(name: 'ended_at') DateTime? endedAt});
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
    Object? tripId = null,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? totalDistanceKm = null,
    Object? totalExpenses = null,
    Object? totalRevenues = null,
    Object? netProfit = null,
    Object? profitMargin = null,
    Object? costPerKm = null,
    Object? expenseCount = null,
    Object? revenueCount = null,
    Object? expensesByCategory = null,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_$TripSummaryModelImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDistanceKm: null == totalDistanceKm
          ? _value.totalDistanceKm
          : totalDistanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      totalRevenues: null == totalRevenues
          ? _value.totalRevenues
          : totalRevenues // ignore: cast_nullable_to_non_nullable
              as double,
      netProfit: null == netProfit
          ? _value.netProfit
          : netProfit // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      costPerKm: null == costPerKm
          ? _value.costPerKm
          : costPerKm // ignore: cast_nullable_to_non_nullable
              as double,
      expenseCount: null == expenseCount
          ? _value.expenseCount
          : expenseCount // ignore: cast_nullable_to_non_nullable
              as int,
      revenueCount: null == revenueCount
          ? _value.revenueCount
          : revenueCount // ignore: cast_nullable_to_non_nullable
              as int,
      expensesByCategory: null == expensesByCategory
          ? _value._expensesByCategory
          : expensesByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripSummaryModelImpl extends _TripSummaryModel {
  const _$TripSummaryModelImpl(
      {@JsonKey(name: 'trip_id') required this.tripId,
      this.origin,
      this.destination,
      @JsonKey(name: 'total_distance_km') this.totalDistanceKm = 0,
      @JsonKey(name: 'total_expenses') this.totalExpenses = 0,
      @JsonKey(name: 'total_revenues') this.totalRevenues = 0,
      @JsonKey(name: 'net_profit') this.netProfit = 0,
      @JsonKey(name: 'profit_margin') this.profitMargin = 0,
      @JsonKey(name: 'cost_per_km') this.costPerKm = 0,
      @JsonKey(name: 'expense_count') this.expenseCount = 0,
      @JsonKey(name: 'revenue_count') this.revenueCount = 0,
      @JsonKey(name: 'expenses_by_category')
      final Map<String, double> expensesByCategory = const {},
      @JsonKey(name: 'started_at') this.startedAt,
      @JsonKey(name: 'ended_at') this.endedAt})
      : _expensesByCategory = expensesByCategory,
        super._();

  factory _$TripSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripSummaryModelImplFromJson(json);

  @override
  @JsonKey(name: 'trip_id')
  final String tripId;
  @override
  final String? origin;
  @override
  final String? destination;
  @override
  @JsonKey(name: 'total_distance_km')
  final double totalDistanceKm;
  @override
  @JsonKey(name: 'total_expenses')
  final double totalExpenses;
  @override
  @JsonKey(name: 'total_revenues')
  final double totalRevenues;
  @override
  @JsonKey(name: 'net_profit')
  final double netProfit;
  @override
  @JsonKey(name: 'profit_margin')
  final double profitMargin;
  @override
  @JsonKey(name: 'cost_per_km')
  final double costPerKm;
  @override
  @JsonKey(name: 'expense_count')
  final int expenseCount;
  @override
  @JsonKey(name: 'revenue_count')
  final int revenueCount;
  final Map<String, double> _expensesByCategory;
  @override
  @JsonKey(name: 'expenses_by_category')
  Map<String, double> get expensesByCategory {
    if (_expensesByCategory is EqualUnmodifiableMapView)
      return _expensesByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_expensesByCategory);
  }

  @override
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;

  @override
  String toString() {
    return 'TripSummaryModel(tripId: $tripId, origin: $origin, destination: $destination, totalDistanceKm: $totalDistanceKm, totalExpenses: $totalExpenses, totalRevenues: $totalRevenues, netProfit: $netProfit, profitMargin: $profitMargin, costPerKm: $costPerKm, expenseCount: $expenseCount, revenueCount: $revenueCount, expensesByCategory: $expensesByCategory, startedAt: $startedAt, endedAt: $endedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripSummaryModelImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.totalDistanceKm, totalDistanceKm) ||
                other.totalDistanceKm == totalDistanceKm) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.totalRevenues, totalRevenues) ||
                other.totalRevenues == totalRevenues) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.profitMargin, profitMargin) ||
                other.profitMargin == profitMargin) &&
            (identical(other.costPerKm, costPerKm) ||
                other.costPerKm == costPerKm) &&
            (identical(other.expenseCount, expenseCount) ||
                other.expenseCount == expenseCount) &&
            (identical(other.revenueCount, revenueCount) ||
                other.revenueCount == revenueCount) &&
            const DeepCollectionEquality()
                .equals(other._expensesByCategory, _expensesByCategory) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tripId,
      origin,
      destination,
      totalDistanceKm,
      totalExpenses,
      totalRevenues,
      netProfit,
      profitMargin,
      costPerKm,
      expenseCount,
      revenueCount,
      const DeepCollectionEquality().hash(_expensesByCategory),
      startedAt,
      endedAt);

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
          {@JsonKey(name: 'trip_id') required final String tripId,
          final String? origin,
          final String? destination,
          @JsonKey(name: 'total_distance_km') final double totalDistanceKm,
          @JsonKey(name: 'total_expenses') final double totalExpenses,
          @JsonKey(name: 'total_revenues') final double totalRevenues,
          @JsonKey(name: 'net_profit') final double netProfit,
          @JsonKey(name: 'profit_margin') final double profitMargin,
          @JsonKey(name: 'cost_per_km') final double costPerKm,
          @JsonKey(name: 'expense_count') final int expenseCount,
          @JsonKey(name: 'revenue_count') final int revenueCount,
          @JsonKey(name: 'expenses_by_category')
          final Map<String, double> expensesByCategory,
          @JsonKey(name: 'started_at') final DateTime? startedAt,
          @JsonKey(name: 'ended_at') final DateTime? endedAt}) =
      _$TripSummaryModelImpl;
  const _TripSummaryModel._() : super._();

  factory _TripSummaryModel.fromJson(Map<String, dynamic> json) =
      _$TripSummaryModelImpl.fromJson;

  @override
  @JsonKey(name: 'trip_id')
  String get tripId;
  @override
  String? get origin;
  @override
  String? get destination;
  @override
  @JsonKey(name: 'total_distance_km')
  double get totalDistanceKm;
  @override
  @JsonKey(name: 'total_expenses')
  double get totalExpenses;
  @override
  @JsonKey(name: 'total_revenues')
  double get totalRevenues;
  @override
  @JsonKey(name: 'net_profit')
  double get netProfit;
  @override
  @JsonKey(name: 'profit_margin')
  double get profitMargin;
  @override
  @JsonKey(name: 'cost_per_km')
  double get costPerKm;
  @override
  @JsonKey(name: 'expense_count')
  int get expenseCount;
  @override
  @JsonKey(name: 'revenue_count')
  int get revenueCount;
  @override
  @JsonKey(name: 'expenses_by_category')
  Map<String, double> get expensesByCategory;
  @override
  @JsonKey(name: 'started_at')
  DateTime? get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(ignore: true)
  _$$TripSummaryModelImplCopyWith<_$TripSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
