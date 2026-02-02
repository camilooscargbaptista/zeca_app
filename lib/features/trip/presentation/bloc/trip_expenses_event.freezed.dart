// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_expenses_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TripExpensesEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripExpensesEventCopyWith<$Res> {
  factory $TripExpensesEventCopyWith(
          TripExpensesEvent value, $Res Function(TripExpensesEvent) then) =
      _$TripExpensesEventCopyWithImpl<$Res, TripExpensesEvent>;
}

/// @nodoc
class _$TripExpensesEventCopyWithImpl<$Res, $Val extends TripExpensesEvent>
    implements $TripExpensesEventCopyWith<$Res> {
  _$TripExpensesEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadActiveTripImplCopyWith<$Res> {
  factory _$$LoadActiveTripImplCopyWith(_$LoadActiveTripImpl value,
          $Res Function(_$LoadActiveTripImpl) then) =
      __$$LoadActiveTripImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadActiveTripImplCopyWithImpl<$Res>
    extends _$TripExpensesEventCopyWithImpl<$Res, _$LoadActiveTripImpl>
    implements _$$LoadActiveTripImplCopyWith<$Res> {
  __$$LoadActiveTripImplCopyWithImpl(
      _$LoadActiveTripImpl _value, $Res Function(_$LoadActiveTripImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadActiveTripImpl implements LoadActiveTrip {
  const _$LoadActiveTripImpl();

  @override
  String toString() {
    return 'TripExpensesEvent.loadActiveTrip()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadActiveTripImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) {
    return loadActiveTrip();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) {
    return loadActiveTrip?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadActiveTrip != null) {
      return loadActiveTrip();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) {
    return loadActiveTrip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) {
    return loadActiveTrip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) {
    if (loadActiveTrip != null) {
      return loadActiveTrip(this);
    }
    return orElse();
  }
}

abstract class LoadActiveTrip implements TripExpensesEvent {
  const factory LoadActiveTrip() = _$LoadActiveTripImpl;
}

/// @nodoc
abstract class _$$LoadTripSummaryImplCopyWith<$Res> {
  factory _$$LoadTripSummaryImplCopyWith(_$LoadTripSummaryImpl value,
          $Res Function(_$LoadTripSummaryImpl) then) =
      __$$LoadTripSummaryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tripId});
}

/// @nodoc
class __$$LoadTripSummaryImplCopyWithImpl<$Res>
    extends _$TripExpensesEventCopyWithImpl<$Res, _$LoadTripSummaryImpl>
    implements _$$LoadTripSummaryImplCopyWith<$Res> {
  __$$LoadTripSummaryImplCopyWithImpl(
      _$LoadTripSummaryImpl _value, $Res Function(_$LoadTripSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
  }) {
    return _then(_$LoadTripSummaryImpl(
      null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadTripSummaryImpl implements LoadTripSummary {
  const _$LoadTripSummaryImpl(this.tripId);

  @override
  final String tripId;

  @override
  String toString() {
    return 'TripExpensesEvent.loadTripSummary(tripId: $tripId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadTripSummaryImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tripId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadTripSummaryImplCopyWith<_$LoadTripSummaryImpl> get copyWith =>
      __$$LoadTripSummaryImplCopyWithImpl<_$LoadTripSummaryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) {
    return loadTripSummary(tripId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) {
    return loadTripSummary?.call(tripId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadTripSummary != null) {
      return loadTripSummary(tripId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) {
    return loadTripSummary(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) {
    return loadTripSummary?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) {
    if (loadTripSummary != null) {
      return loadTripSummary(this);
    }
    return orElse();
  }
}

abstract class LoadTripSummary implements TripExpensesEvent {
  const factory LoadTripSummary(final String tripId) = _$LoadTripSummaryImpl;

  String get tripId;
  @JsonKey(ignore: true)
  _$$LoadTripSummaryImplCopyWith<_$LoadTripSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadCategoriesImplCopyWith<$Res> {
  factory _$$LoadCategoriesImplCopyWith(_$LoadCategoriesImpl value,
          $Res Function(_$LoadCategoriesImpl) then) =
      __$$LoadCategoriesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadCategoriesImplCopyWithImpl<$Res>
    extends _$TripExpensesEventCopyWithImpl<$Res, _$LoadCategoriesImpl>
    implements _$$LoadCategoriesImplCopyWith<$Res> {
  __$$LoadCategoriesImplCopyWithImpl(
      _$LoadCategoriesImpl _value, $Res Function(_$LoadCategoriesImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadCategoriesImpl implements LoadCategories {
  const _$LoadCategoriesImpl();

  @override
  String toString() {
    return 'TripExpensesEvent.loadCategories()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadCategoriesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) {
    return loadCategories();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) {
    return loadCategories?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadCategories != null) {
      return loadCategories();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) {
    return loadCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) {
    return loadCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) {
    if (loadCategories != null) {
      return loadCategories(this);
    }
    return orElse();
  }
}

abstract class LoadCategories implements TripExpensesEvent {
  const factory LoadCategories() = _$LoadCategoriesImpl;
}

/// @nodoc
abstract class _$$LoadExpensesImplCopyWith<$Res> {
  factory _$$LoadExpensesImplCopyWith(
          _$LoadExpensesImpl value, $Res Function(_$LoadExpensesImpl) then) =
      __$$LoadExpensesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tripId});
}

/// @nodoc
class __$$LoadExpensesImplCopyWithImpl<$Res>
    extends _$TripExpensesEventCopyWithImpl<$Res, _$LoadExpensesImpl>
    implements _$$LoadExpensesImplCopyWith<$Res> {
  __$$LoadExpensesImplCopyWithImpl(
      _$LoadExpensesImpl _value, $Res Function(_$LoadExpensesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
  }) {
    return _then(_$LoadExpensesImpl(
      null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadExpensesImpl implements LoadExpenses {
  const _$LoadExpensesImpl(this.tripId);

  @override
  final String tripId;

  @override
  String toString() {
    return 'TripExpensesEvent.loadExpenses(tripId: $tripId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadExpensesImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tripId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadExpensesImplCopyWith<_$LoadExpensesImpl> get copyWith =>
      __$$LoadExpensesImplCopyWithImpl<_$LoadExpensesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) {
    return loadExpenses(tripId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) {
    return loadExpenses?.call(tripId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadExpenses != null) {
      return loadExpenses(tripId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) {
    return loadExpenses(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) {
    return loadExpenses?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) {
    if (loadExpenses != null) {
      return loadExpenses(this);
    }
    return orElse();
  }
}

abstract class LoadExpenses implements TripExpensesEvent {
  const factory LoadExpenses(final String tripId) = _$LoadExpensesImpl;

  String get tripId;
  @JsonKey(ignore: true)
  _$$LoadExpensesImplCopyWith<_$LoadExpensesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateExpenseEventImplCopyWith<$Res> {
  factory _$$CreateExpenseEventImplCopyWith(_$CreateExpenseEventImpl value,
          $Res Function(_$CreateExpenseEventImpl) then) =
      __$$CreateExpenseEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String tripId,
      String categoryId,
      double amount,
      String? description,
      String? location,
      String? receiptPath});
}

/// @nodoc
class __$$CreateExpenseEventImplCopyWithImpl<$Res>
    extends _$TripExpensesEventCopyWithImpl<$Res, _$CreateExpenseEventImpl>
    implements _$$CreateExpenseEventImplCopyWith<$Res> {
  __$$CreateExpenseEventImplCopyWithImpl(_$CreateExpenseEventImpl _value,
      $Res Function(_$CreateExpenseEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? categoryId = null,
    Object? amount = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? receiptPath = freezed,
  }) {
    return _then(_$CreateExpenseEventImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      receiptPath: freezed == receiptPath
          ? _value.receiptPath
          : receiptPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CreateExpenseEventImpl implements CreateExpenseEvent {
  const _$CreateExpenseEventImpl(
      {required this.tripId,
      required this.categoryId,
      required this.amount,
      this.description,
      this.location,
      this.receiptPath});

  @override
  final String tripId;
  @override
  final String categoryId;
  @override
  final double amount;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final String? receiptPath;

  @override
  String toString() {
    return 'TripExpensesEvent.createExpense(tripId: $tripId, categoryId: $categoryId, amount: $amount, description: $description, location: $location, receiptPath: $receiptPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateExpenseEventImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.receiptPath, receiptPath) ||
                other.receiptPath == receiptPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tripId, categoryId, amount,
      description, location, receiptPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateExpenseEventImplCopyWith<_$CreateExpenseEventImpl> get copyWith =>
      __$$CreateExpenseEventImplCopyWithImpl<_$CreateExpenseEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) {
    return createExpense(
        tripId, categoryId, amount, description, location, receiptPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) {
    return createExpense?.call(
        tripId, categoryId, amount, description, location, receiptPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (createExpense != null) {
      return createExpense(
          tripId, categoryId, amount, description, location, receiptPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) {
    return createExpense(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) {
    return createExpense?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) {
    if (createExpense != null) {
      return createExpense(this);
    }
    return orElse();
  }
}

abstract class CreateExpenseEvent implements TripExpensesEvent {
  const factory CreateExpenseEvent(
      {required final String tripId,
      required final String categoryId,
      required final double amount,
      final String? description,
      final String? location,
      final String? receiptPath}) = _$CreateExpenseEventImpl;

  String get tripId;
  String get categoryId;
  double get amount;
  String? get description;
  String? get location;
  String? get receiptPath;
  @JsonKey(ignore: true)
  _$$CreateExpenseEventImplCopyWith<_$CreateExpenseEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshTripExpensesImplCopyWith<$Res> {
  factory _$$RefreshTripExpensesImplCopyWith(_$RefreshTripExpensesImpl value,
          $Res Function(_$RefreshTripExpensesImpl) then) =
      __$$RefreshTripExpensesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshTripExpensesImplCopyWithImpl<$Res>
    extends _$TripExpensesEventCopyWithImpl<$Res, _$RefreshTripExpensesImpl>
    implements _$$RefreshTripExpensesImplCopyWith<$Res> {
  __$$RefreshTripExpensesImplCopyWithImpl(_$RefreshTripExpensesImpl _value,
      $Res Function(_$RefreshTripExpensesImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RefreshTripExpensesImpl implements RefreshTripExpenses {
  const _$RefreshTripExpensesImpl();

  @override
  String toString() {
    return 'TripExpensesEvent.refresh()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTripExpensesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(String tripId) loadTripSummary,
    required TResult Function() loadCategories,
    required TResult Function(String tripId) loadExpenses,
    required TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)
        createExpense,
    required TResult Function() refresh,
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String tripId)? loadTripSummary,
    TResult? Function()? loadCategories,
    TResult? Function(String tripId)? loadExpenses,
    TResult? Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult? Function()? refresh,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String tripId)? loadTripSummary,
    TResult Function()? loadCategories,
    TResult Function(String tripId)? loadExpenses,
    TResult Function(String tripId, String categoryId, double amount,
            String? description, String? location, String? receiptPath)?
        createExpense,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(LoadTripSummary value) loadTripSummary,
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(LoadExpenses value) loadExpenses,
    required TResult Function(CreateExpenseEvent value) createExpense,
    required TResult Function(RefreshTripExpenses value) refresh,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(LoadTripSummary value)? loadTripSummary,
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(LoadExpenses value)? loadExpenses,
    TResult? Function(CreateExpenseEvent value)? createExpense,
    TResult? Function(RefreshTripExpenses value)? refresh,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(LoadTripSummary value)? loadTripSummary,
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(LoadExpenses value)? loadExpenses,
    TResult Function(CreateExpenseEvent value)? createExpense,
    TResult Function(RefreshTripExpenses value)? refresh,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(this);
    }
    return orElse();
  }
}

abstract class RefreshTripExpenses implements TripExpensesEvent {
  const factory RefreshTripExpenses() = _$RefreshTripExpensesImpl;
}
