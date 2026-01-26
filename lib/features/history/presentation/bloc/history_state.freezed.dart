// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HistoryState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message, HistoryFiltersEntity? filters)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message, HistoryFiltersEntity? filters)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message, HistoryFiltersEntity? filters)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HistoryInitial value) initial,
    required TResult Function(HistoryLoading value) loading,
    required TResult Function(HistoryLoaded value) loaded,
    required TResult Function(HistoryError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HistoryInitial value)? initial,
    TResult? Function(HistoryLoading value)? loading,
    TResult? Function(HistoryLoaded value)? loaded,
    TResult? Function(HistoryError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HistoryInitial value)? initial,
    TResult Function(HistoryLoading value)? loading,
    TResult Function(HistoryLoaded value)? loaded,
    TResult Function(HistoryError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) then) =
      _$HistoryStateCopyWithImpl<$Res, HistoryState>;
}

/// @nodoc
class _$HistoryStateCopyWithImpl<$Res, $Val extends HistoryState>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$HistoryInitialImplCopyWith<$Res> {
  factory _$$HistoryInitialImplCopyWith(_$HistoryInitialImpl value,
          $Res Function(_$HistoryInitialImpl) then) =
      __$$HistoryInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HistoryInitialImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryInitialImpl>
    implements _$$HistoryInitialImplCopyWith<$Res> {
  __$$HistoryInitialImplCopyWithImpl(
      _$HistoryInitialImpl _value, $Res Function(_$HistoryInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HistoryInitialImpl extends HistoryInitial {
  const _$HistoryInitialImpl() : super._();

  @override
  String toString() {
    return 'HistoryState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HistoryInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message, HistoryFiltersEntity? filters)
        error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message, HistoryFiltersEntity? filters)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message, HistoryFiltersEntity? filters)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HistoryInitial value) initial,
    required TResult Function(HistoryLoading value) loading,
    required TResult Function(HistoryLoaded value) loaded,
    required TResult Function(HistoryError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HistoryInitial value)? initial,
    TResult? Function(HistoryLoading value)? loading,
    TResult? Function(HistoryLoaded value)? loaded,
    TResult? Function(HistoryError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HistoryInitial value)? initial,
    TResult Function(HistoryLoading value)? loading,
    TResult Function(HistoryLoaded value)? loaded,
    TResult Function(HistoryError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class HistoryInitial extends HistoryState {
  const factory HistoryInitial() = _$HistoryInitialImpl;
  const HistoryInitial._() : super._();
}

/// @nodoc
abstract class _$$HistoryLoadingImplCopyWith<$Res> {
  factory _$$HistoryLoadingImplCopyWith(_$HistoryLoadingImpl value,
          $Res Function(_$HistoryLoadingImpl) then) =
      __$$HistoryLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HistoryLoadingImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryLoadingImpl>
    implements _$$HistoryLoadingImplCopyWith<$Res> {
  __$$HistoryLoadingImplCopyWithImpl(
      _$HistoryLoadingImpl _value, $Res Function(_$HistoryLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HistoryLoadingImpl extends HistoryLoading {
  const _$HistoryLoadingImpl() : super._();

  @override
  String toString() {
    return 'HistoryState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HistoryLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message, HistoryFiltersEntity? filters)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message, HistoryFiltersEntity? filters)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message, HistoryFiltersEntity? filters)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HistoryInitial value) initial,
    required TResult Function(HistoryLoading value) loading,
    required TResult Function(HistoryLoaded value) loaded,
    required TResult Function(HistoryError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HistoryInitial value)? initial,
    TResult? Function(HistoryLoading value)? loading,
    TResult? Function(HistoryLoaded value)? loaded,
    TResult? Function(HistoryError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HistoryInitial value)? initial,
    TResult Function(HistoryLoading value)? loading,
    TResult Function(HistoryLoaded value)? loaded,
    TResult Function(HistoryError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HistoryLoading extends HistoryState {
  const factory HistoryLoading() = _$HistoryLoadingImpl;
  const HistoryLoading._() : super._();
}

/// @nodoc
abstract class _$$HistoryLoadedImplCopyWith<$Res> {
  factory _$$HistoryLoadedImplCopyWith(
          _$HistoryLoadedImpl value, $Res Function(_$HistoryLoadedImpl) then) =
      __$$HistoryLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<RefuelingHistoryEntity> refuelings,
      HistorySummaryEntity summary,
      HistoryFiltersEntity filters,
      int currentPage,
      int total,
      bool hasMore,
      bool isLoadingMore});
}

/// @nodoc
class __$$HistoryLoadedImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryLoadedImpl>
    implements _$$HistoryLoadedImplCopyWith<$Res> {
  __$$HistoryLoadedImplCopyWithImpl(
      _$HistoryLoadedImpl _value, $Res Function(_$HistoryLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refuelings = null,
    Object? summary = null,
    Object? filters = null,
    Object? currentPage = null,
    Object? total = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_$HistoryLoadedImpl(
      refuelings: null == refuelings
          ? _value._refuelings
          : refuelings // ignore: cast_nullable_to_non_nullable
              as List<RefuelingHistoryEntity>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as HistorySummaryEntity,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as HistoryFiltersEntity,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HistoryLoadedImpl extends HistoryLoaded {
  const _$HistoryLoadedImpl(
      {required final List<RefuelingHistoryEntity> refuelings,
      required this.summary,
      required this.filters,
      required this.currentPage,
      required this.total,
      required this.hasMore,
      this.isLoadingMore = false})
      : _refuelings = refuelings,
        super._();

  final List<RefuelingHistoryEntity> _refuelings;
  @override
  List<RefuelingHistoryEntity> get refuelings {
    if (_refuelings is EqualUnmodifiableListView) return _refuelings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_refuelings);
  }

  @override
  final HistorySummaryEntity summary;
  @override
  final HistoryFiltersEntity filters;
  @override
  final int currentPage;
  @override
  final int total;
  @override
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'HistoryState.loaded(refuelings: $refuelings, summary: $summary, filters: $filters, currentPage: $currentPage, total: $total, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._refuelings, _refuelings) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_refuelings),
      summary,
      filters,
      currentPage,
      total,
      hasMore,
      isLoadingMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryLoadedImplCopyWith<_$HistoryLoadedImpl> get copyWith =>
      __$$HistoryLoadedImplCopyWithImpl<_$HistoryLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message, HistoryFiltersEntity? filters)
        error,
  }) {
    return loaded(refuelings, summary, filters, currentPage, total, hasMore,
        isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message, HistoryFiltersEntity? filters)? error,
  }) {
    return loaded?.call(refuelings, summary, filters, currentPage, total,
        hasMore, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message, HistoryFiltersEntity? filters)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(refuelings, summary, filters, currentPage, total, hasMore,
          isLoadingMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HistoryInitial value) initial,
    required TResult Function(HistoryLoading value) loading,
    required TResult Function(HistoryLoaded value) loaded,
    required TResult Function(HistoryError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HistoryInitial value)? initial,
    TResult? Function(HistoryLoading value)? loading,
    TResult? Function(HistoryLoaded value)? loaded,
    TResult? Function(HistoryError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HistoryInitial value)? initial,
    TResult Function(HistoryLoading value)? loading,
    TResult Function(HistoryLoaded value)? loaded,
    TResult Function(HistoryError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class HistoryLoaded extends HistoryState {
  const factory HistoryLoaded(
      {required final List<RefuelingHistoryEntity> refuelings,
      required final HistorySummaryEntity summary,
      required final HistoryFiltersEntity filters,
      required final int currentPage,
      required final int total,
      required final bool hasMore,
      final bool isLoadingMore}) = _$HistoryLoadedImpl;
  const HistoryLoaded._() : super._();

  List<RefuelingHistoryEntity> get refuelings;
  HistorySummaryEntity get summary;
  HistoryFiltersEntity get filters;
  int get currentPage;
  int get total;
  bool get hasMore;
  bool get isLoadingMore;
  @JsonKey(ignore: true)
  _$$HistoryLoadedImplCopyWith<_$HistoryLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HistoryErrorImplCopyWith<$Res> {
  factory _$$HistoryErrorImplCopyWith(
          _$HistoryErrorImpl value, $Res Function(_$HistoryErrorImpl) then) =
      __$$HistoryErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, HistoryFiltersEntity? filters});
}

/// @nodoc
class __$$HistoryErrorImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryErrorImpl>
    implements _$$HistoryErrorImplCopyWith<$Res> {
  __$$HistoryErrorImplCopyWithImpl(
      _$HistoryErrorImpl _value, $Res Function(_$HistoryErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? filters = freezed,
  }) {
    return _then(_$HistoryErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      filters: freezed == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as HistoryFiltersEntity?,
    ));
  }
}

/// @nodoc

class _$HistoryErrorImpl extends HistoryError {
  const _$HistoryErrorImpl({required this.message, this.filters}) : super._();

  @override
  final String message;
  @override
  final HistoryFiltersEntity? filters;

  @override
  String toString() {
    return 'HistoryState.error(message: $message, filters: $filters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.filters, filters) || other.filters == filters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, filters);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryErrorImplCopyWith<_$HistoryErrorImpl> get copyWith =>
      __$$HistoryErrorImplCopyWithImpl<_$HistoryErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message, HistoryFiltersEntity? filters)
        error,
  }) {
    return error(message, filters);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message, HistoryFiltersEntity? filters)? error,
  }) {
    return error?.call(message, filters);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<RefuelingHistoryEntity> refuelings,
            HistorySummaryEntity summary,
            HistoryFiltersEntity filters,
            int currentPage,
            int total,
            bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message, HistoryFiltersEntity? filters)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, filters);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HistoryInitial value) initial,
    required TResult Function(HistoryLoading value) loading,
    required TResult Function(HistoryLoaded value) loaded,
    required TResult Function(HistoryError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HistoryInitial value)? initial,
    TResult? Function(HistoryLoading value)? loading,
    TResult? Function(HistoryLoaded value)? loaded,
    TResult? Function(HistoryError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HistoryInitial value)? initial,
    TResult Function(HistoryLoading value)? loading,
    TResult Function(HistoryLoaded value)? loaded,
    TResult Function(HistoryError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HistoryError extends HistoryState {
  const factory HistoryError(
      {required final String message,
      final HistoryFiltersEntity? filters}) = _$HistoryErrorImpl;
  const HistoryError._() : super._();

  String get message;
  HistoryFiltersEntity? get filters;
  @JsonKey(ignore: true)
  _$$HistoryErrorImplCopyWith<_$HistoryErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
