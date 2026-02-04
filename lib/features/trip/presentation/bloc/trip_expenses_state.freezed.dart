// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_expenses_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TripExpensesState {
// Loading flags
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingCategories => throw _privateConstructorUsedError;
  bool get isCreatingExpense => throw _privateConstructorUsedError;
  bool get isCreatingRevenue => throw _privateConstructorUsedError; // Data
  Trip? get activeTrip => throw _privateConstructorUsedError;
  TripSummary? get tripSummary => throw _privateConstructorUsedError;
  List<ExpenseCategoryEntity> get categories =>
      throw _privateConstructorUsedError;
  List<Expense> get expenses => throw _privateConstructorUsedError; // UI State
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get expenseCreatedSuccess => throw _privateConstructorUsedError;
  bool get revenueCreatedSuccess =>
      throw _privateConstructorUsedError; // Computed values
  double get totalExpenses => throw _privateConstructorUsedError;
  double get totalRevenues => throw _privateConstructorUsedError;
  double get netProfit => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TripExpensesStateCopyWith<TripExpensesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripExpensesStateCopyWith<$Res> {
  factory $TripExpensesStateCopyWith(
          TripExpensesState value, $Res Function(TripExpensesState) then) =
      _$TripExpensesStateCopyWithImpl<$Res, TripExpensesState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingCategories,
      bool isCreatingExpense,
      bool isCreatingRevenue,
      Trip? activeTrip,
      TripSummary? tripSummary,
      List<ExpenseCategoryEntity> categories,
      List<Expense> expenses,
      String? errorMessage,
      bool expenseCreatedSuccess,
      bool revenueCreatedSuccess,
      double totalExpenses,
      double totalRevenues,
      double netProfit});
}

/// @nodoc
class _$TripExpensesStateCopyWithImpl<$Res, $Val extends TripExpensesState>
    implements $TripExpensesStateCopyWith<$Res> {
  _$TripExpensesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingCategories = null,
    Object? isCreatingExpense = null,
    Object? isCreatingRevenue = null,
    Object? activeTrip = freezed,
    Object? tripSummary = freezed,
    Object? categories = null,
    Object? expenses = null,
    Object? errorMessage = freezed,
    Object? expenseCreatedSuccess = null,
    Object? revenueCreatedSuccess = null,
    Object? totalExpenses = null,
    Object? totalRevenues = null,
    Object? netProfit = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreatingExpense: null == isCreatingExpense
          ? _value.isCreatingExpense
          : isCreatingExpense // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreatingRevenue: null == isCreatingRevenue
          ? _value.isCreatingRevenue
          : isCreatingRevenue // ignore: cast_nullable_to_non_nullable
              as bool,
      activeTrip: freezed == activeTrip
          ? _value.activeTrip
          : activeTrip // ignore: cast_nullable_to_non_nullable
              as Trip?,
      tripSummary: freezed == tripSummary
          ? _value.tripSummary
          : tripSummary // ignore: cast_nullable_to_non_nullable
              as TripSummary?,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<ExpenseCategoryEntity>,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseCreatedSuccess: null == expenseCreatedSuccess
          ? _value.expenseCreatedSuccess
          : expenseCreatedSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      revenueCreatedSuccess: null == revenueCreatedSuccess
          ? _value.revenueCreatedSuccess
          : revenueCreatedSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripExpensesStateImplCopyWith<$Res>
    implements $TripExpensesStateCopyWith<$Res> {
  factory _$$TripExpensesStateImplCopyWith(_$TripExpensesStateImpl value,
          $Res Function(_$TripExpensesStateImpl) then) =
      __$$TripExpensesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingCategories,
      bool isCreatingExpense,
      bool isCreatingRevenue,
      Trip? activeTrip,
      TripSummary? tripSummary,
      List<ExpenseCategoryEntity> categories,
      List<Expense> expenses,
      String? errorMessage,
      bool expenseCreatedSuccess,
      bool revenueCreatedSuccess,
      double totalExpenses,
      double totalRevenues,
      double netProfit});
}

/// @nodoc
class __$$TripExpensesStateImplCopyWithImpl<$Res>
    extends _$TripExpensesStateCopyWithImpl<$Res, _$TripExpensesStateImpl>
    implements _$$TripExpensesStateImplCopyWith<$Res> {
  __$$TripExpensesStateImplCopyWithImpl(_$TripExpensesStateImpl _value,
      $Res Function(_$TripExpensesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingCategories = null,
    Object? isCreatingExpense = null,
    Object? isCreatingRevenue = null,
    Object? activeTrip = freezed,
    Object? tripSummary = freezed,
    Object? categories = null,
    Object? expenses = null,
    Object? errorMessage = freezed,
    Object? expenseCreatedSuccess = null,
    Object? revenueCreatedSuccess = null,
    Object? totalExpenses = null,
    Object? totalRevenues = null,
    Object? netProfit = null,
  }) {
    return _then(_$TripExpensesStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreatingExpense: null == isCreatingExpense
          ? _value.isCreatingExpense
          : isCreatingExpense // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreatingRevenue: null == isCreatingRevenue
          ? _value.isCreatingRevenue
          : isCreatingRevenue // ignore: cast_nullable_to_non_nullable
              as bool,
      activeTrip: freezed == activeTrip
          ? _value.activeTrip
          : activeTrip // ignore: cast_nullable_to_non_nullable
              as Trip?,
      tripSummary: freezed == tripSummary
          ? _value.tripSummary
          : tripSummary // ignore: cast_nullable_to_non_nullable
              as TripSummary?,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<ExpenseCategoryEntity>,
      expenses: null == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseCreatedSuccess: null == expenseCreatedSuccess
          ? _value.expenseCreatedSuccess
          : expenseCreatedSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      revenueCreatedSuccess: null == revenueCreatedSuccess
          ? _value.revenueCreatedSuccess
          : revenueCreatedSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc

class _$TripExpensesStateImpl implements _TripExpensesState {
  const _$TripExpensesStateImpl(
      {this.isLoading = false,
      this.isLoadingCategories = false,
      this.isCreatingExpense = false,
      this.isCreatingRevenue = false,
      this.activeTrip,
      this.tripSummary,
      final List<ExpenseCategoryEntity> categories = const [],
      final List<Expense> expenses = const [],
      this.errorMessage,
      this.expenseCreatedSuccess = false,
      this.revenueCreatedSuccess = false,
      this.totalExpenses = 0.0,
      this.totalRevenues = 0.0,
      this.netProfit = 0.0})
      : _categories = categories,
        _expenses = expenses;

// Loading flags
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingCategories;
  @override
  @JsonKey()
  final bool isCreatingExpense;
  @override
  @JsonKey()
  final bool isCreatingRevenue;
// Data
  @override
  final Trip? activeTrip;
  @override
  final TripSummary? tripSummary;
  final List<ExpenseCategoryEntity> _categories;
  @override
  @JsonKey()
  List<ExpenseCategoryEntity> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<Expense> _expenses;
  @override
  @JsonKey()
  List<Expense> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

// UI State
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool expenseCreatedSuccess;
  @override
  @JsonKey()
  final bool revenueCreatedSuccess;
// Computed values
  @override
  @JsonKey()
  final double totalExpenses;
  @override
  @JsonKey()
  final double totalRevenues;
  @override
  @JsonKey()
  final double netProfit;

  @override
  String toString() {
    return 'TripExpensesState(isLoading: $isLoading, isLoadingCategories: $isLoadingCategories, isCreatingExpense: $isCreatingExpense, isCreatingRevenue: $isCreatingRevenue, activeTrip: $activeTrip, tripSummary: $tripSummary, categories: $categories, expenses: $expenses, errorMessage: $errorMessage, expenseCreatedSuccess: $expenseCreatedSuccess, revenueCreatedSuccess: $revenueCreatedSuccess, totalExpenses: $totalExpenses, totalRevenues: $totalRevenues, netProfit: $netProfit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripExpensesStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.isCreatingExpense, isCreatingExpense) ||
                other.isCreatingExpense == isCreatingExpense) &&
            (identical(other.isCreatingRevenue, isCreatingRevenue) ||
                other.isCreatingRevenue == isCreatingRevenue) &&
            (identical(other.activeTrip, activeTrip) ||
                other.activeTrip == activeTrip) &&
            (identical(other.tripSummary, tripSummary) ||
                other.tripSummary == tripSummary) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.expenseCreatedSuccess, expenseCreatedSuccess) ||
                other.expenseCreatedSuccess == expenseCreatedSuccess) &&
            (identical(other.revenueCreatedSuccess, revenueCreatedSuccess) ||
                other.revenueCreatedSuccess == revenueCreatedSuccess) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.totalRevenues, totalRevenues) ||
                other.totalRevenues == totalRevenues) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isLoadingCategories,
      isCreatingExpense,
      isCreatingRevenue,
      activeTrip,
      tripSummary,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_expenses),
      errorMessage,
      expenseCreatedSuccess,
      revenueCreatedSuccess,
      totalExpenses,
      totalRevenues,
      netProfit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripExpensesStateImplCopyWith<_$TripExpensesStateImpl> get copyWith =>
      __$$TripExpensesStateImplCopyWithImpl<_$TripExpensesStateImpl>(
          this, _$identity);
}

abstract class _TripExpensesState implements TripExpensesState {
  const factory _TripExpensesState(
      {final bool isLoading,
      final bool isLoadingCategories,
      final bool isCreatingExpense,
      final bool isCreatingRevenue,
      final Trip? activeTrip,
      final TripSummary? tripSummary,
      final List<ExpenseCategoryEntity> categories,
      final List<Expense> expenses,
      final String? errorMessage,
      final bool expenseCreatedSuccess,
      final bool revenueCreatedSuccess,
      final double totalExpenses,
      final double totalRevenues,
      final double netProfit}) = _$TripExpensesStateImpl;

  @override // Loading flags
  bool get isLoading;
  @override
  bool get isLoadingCategories;
  @override
  bool get isCreatingExpense;
  @override
  bool get isCreatingRevenue;
  @override // Data
  Trip? get activeTrip;
  @override
  TripSummary? get tripSummary;
  @override
  List<ExpenseCategoryEntity> get categories;
  @override
  List<Expense> get expenses;
  @override // UI State
  String? get errorMessage;
  @override
  bool get expenseCreatedSuccess;
  @override
  bool get revenueCreatedSuccess;
  @override // Computed values
  double get totalExpenses;
  @override
  double get totalRevenues;
  @override
  double get netProfit;
  @override
  @JsonKey(ignore: true)
  _$$TripExpensesStateImplCopyWith<_$TripExpensesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
