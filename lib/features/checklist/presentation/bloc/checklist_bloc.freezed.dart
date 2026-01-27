// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChecklistEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistEventCopyWith<$Res> {
  factory $ChecklistEventCopyWith(
          ChecklistEvent value, $Res Function(ChecklistEvent) then) =
      _$ChecklistEventCopyWithImpl<$Res, ChecklistEvent>;
}

/// @nodoc
class _$ChecklistEventCopyWithImpl<$Res, $Val extends ChecklistEvent>
    implements $ChecklistEventCopyWith<$Res> {
  _$ChecklistEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadDataImplCopyWith<$Res> {
  factory _$$LoadDataImplCopyWith(
          _$LoadDataImpl value, $Res Function(_$LoadDataImpl) then) =
      __$$LoadDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadDataImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$LoadDataImpl>
    implements _$$LoadDataImplCopyWith<$Res> {
  __$$LoadDataImplCopyWithImpl(
      _$LoadDataImpl _value, $Res Function(_$LoadDataImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadDataImpl implements _LoadData {
  const _$LoadDataImpl();

  @override
  String toString() {
    return 'ChecklistEvent.loadData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return loadData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return loadData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (loadData != null) {
      return loadData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return loadData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return loadData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (loadData != null) {
      return loadData(this);
    }
    return orElse();
  }
}

abstract class _LoadData implements ChecklistEvent {
  const factory _LoadData() = _$LoadDataImpl;
}

/// @nodoc
abstract class _$$VehicleLoadedImplCopyWith<$Res> {
  factory _$$VehicleLoadedImplCopyWith(
          _$VehicleLoadedImpl value, $Res Function(_$VehicleLoadedImpl) then) =
      __$$VehicleLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> vehicleData});
}

/// @nodoc
class __$$VehicleLoadedImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$VehicleLoadedImpl>
    implements _$$VehicleLoadedImplCopyWith<$Res> {
  __$$VehicleLoadedImplCopyWithImpl(
      _$VehicleLoadedImpl _value, $Res Function(_$VehicleLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleData = null,
  }) {
    return _then(_$VehicleLoadedImpl(
      null == vehicleData
          ? _value._vehicleData
          : vehicleData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$VehicleLoadedImpl implements _VehicleLoaded {
  const _$VehicleLoadedImpl(final Map<String, dynamic> vehicleData)
      : _vehicleData = vehicleData;

  final Map<String, dynamic> _vehicleData;
  @override
  Map<String, dynamic> get vehicleData {
    if (_vehicleData is EqualUnmodifiableMapView) return _vehicleData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_vehicleData);
  }

  @override
  String toString() {
    return 'ChecklistEvent.vehicleLoaded(vehicleData: $vehicleData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._vehicleData, _vehicleData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_vehicleData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleLoadedImplCopyWith<_$VehicleLoadedImpl> get copyWith =>
      __$$VehicleLoadedImplCopyWithImpl<_$VehicleLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return vehicleLoaded(vehicleData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return vehicleLoaded?.call(vehicleData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (vehicleLoaded != null) {
      return vehicleLoaded(vehicleData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return vehicleLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return vehicleLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (vehicleLoaded != null) {
      return vehicleLoaded(this);
    }
    return orElse();
  }
}

abstract class _VehicleLoaded implements ChecklistEvent {
  const factory _VehicleLoaded(final Map<String, dynamic> vehicleData) =
      _$VehicleLoadedImpl;

  Map<String, dynamic> get vehicleData;
  @JsonKey(ignore: true)
  _$$VehicleLoadedImplCopyWith<_$VehicleLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChecklistLoadedImplCopyWith<$Res> {
  factory _$$ChecklistLoadedImplCopyWith(_$ChecklistLoadedImpl value,
          $Res Function(_$ChecklistLoadedImpl) then) =
      __$$ChecklistLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> checklistData});
}

/// @nodoc
class __$$ChecklistLoadedImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$ChecklistLoadedImpl>
    implements _$$ChecklistLoadedImplCopyWith<$Res> {
  __$$ChecklistLoadedImplCopyWithImpl(
      _$ChecklistLoadedImpl _value, $Res Function(_$ChecklistLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checklistData = null,
  }) {
    return _then(_$ChecklistLoadedImpl(
      null == checklistData
          ? _value._checklistData
          : checklistData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$ChecklistLoadedImpl implements _ChecklistLoaded {
  const _$ChecklistLoadedImpl(final Map<String, dynamic> checklistData)
      : _checklistData = checklistData;

  final Map<String, dynamic> _checklistData;
  @override
  Map<String, dynamic> get checklistData {
    if (_checklistData is EqualUnmodifiableMapView) return _checklistData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_checklistData);
  }

  @override
  String toString() {
    return 'ChecklistEvent.checklistLoaded(checklistData: $checklistData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._checklistData, _checklistData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_checklistData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistLoadedImplCopyWith<_$ChecklistLoadedImpl> get copyWith =>
      __$$ChecklistLoadedImplCopyWithImpl<_$ChecklistLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return checklistLoaded(checklistData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return checklistLoaded?.call(checklistData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (checklistLoaded != null) {
      return checklistLoaded(checklistData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return checklistLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return checklistLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (checklistLoaded != null) {
      return checklistLoaded(this);
    }
    return orElse();
  }
}

abstract class _ChecklistLoaded implements ChecklistEvent {
  const factory _ChecklistLoaded(final Map<String, dynamic> checklistData) =
      _$ChecklistLoadedImpl;

  Map<String, dynamic> get checklistData;
  @JsonKey(ignore: true)
  _$$ChecklistLoadedImplCopyWith<_$ChecklistLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadFailedImplCopyWith<$Res> {
  factory _$$LoadFailedImplCopyWith(
          _$LoadFailedImpl value, $Res Function(_$LoadFailedImpl) then) =
      __$$LoadFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$LoadFailedImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$LoadFailedImpl>
    implements _$$LoadFailedImplCopyWith<$Res> {
  __$$LoadFailedImplCopyWithImpl(
      _$LoadFailedImpl _value, $Res Function(_$LoadFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$LoadFailedImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadFailedImpl implements _LoadFailed {
  const _$LoadFailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ChecklistEvent.loadFailed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadFailedImplCopyWith<_$LoadFailedImpl> get copyWith =>
      __$$LoadFailedImplCopyWithImpl<_$LoadFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return loadFailed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return loadFailed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (loadFailed != null) {
      return loadFailed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return loadFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return loadFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (loadFailed != null) {
      return loadFailed(this);
    }
    return orElse();
  }
}

abstract class _LoadFailed implements ChecklistEvent {
  const factory _LoadFailed(final String message) = _$LoadFailedImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$LoadFailedImplCopyWith<_$LoadFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnswerItemImplCopyWith<$Res> {
  factory _$$AnswerItemImplCopyWith(
          _$AnswerItemImpl value, $Res Function(_$AnswerItemImpl) then) =
      __$$AnswerItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String itemId, String value, bool isConforming, String? notes});
}

/// @nodoc
class __$$AnswerItemImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$AnswerItemImpl>
    implements _$$AnswerItemImplCopyWith<$Res> {
  __$$AnswerItemImplCopyWithImpl(
      _$AnswerItemImpl _value, $Res Function(_$AnswerItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? value = null,
    Object? isConforming = null,
    Object? notes = freezed,
  }) {
    return _then(_$AnswerItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      isConforming: null == isConforming
          ? _value.isConforming
          : isConforming // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AnswerItemImpl implements _AnswerItem {
  const _$AnswerItemImpl(
      {required this.itemId,
      required this.value,
      this.isConforming = true,
      this.notes});

  @override
  final String itemId;
  @override
  final String value;
  @override
  @JsonKey()
  final bool isConforming;
  @override
  final String? notes;

  @override
  String toString() {
    return 'ChecklistEvent.answerItem(itemId: $itemId, value: $value, isConforming: $isConforming, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.isConforming, isConforming) ||
                other.isConforming == isConforming) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, itemId, value, isConforming, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerItemImplCopyWith<_$AnswerItemImpl> get copyWith =>
      __$$AnswerItemImplCopyWithImpl<_$AnswerItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return answerItem(itemId, value, isConforming, notes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return answerItem?.call(itemId, value, isConforming, notes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (answerItem != null) {
      return answerItem(itemId, value, isConforming, notes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return answerItem(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return answerItem?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (answerItem != null) {
      return answerItem(this);
    }
    return orElse();
  }
}

abstract class _AnswerItem implements ChecklistEvent {
  const factory _AnswerItem(
      {required final String itemId,
      required final String value,
      final bool isConforming,
      final String? notes}) = _$AnswerItemImpl;

  String get itemId;
  String get value;
  bool get isConforming;
  String? get notes;
  @JsonKey(ignore: true)
  _$$AnswerItemImplCopyWith<_$AnswerItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartSavingImplCopyWith<$Res> {
  factory _$$StartSavingImplCopyWith(
          _$StartSavingImpl value, $Res Function(_$StartSavingImpl) then) =
      __$$StartSavingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartSavingImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$StartSavingImpl>
    implements _$$StartSavingImplCopyWith<$Res> {
  __$$StartSavingImplCopyWithImpl(
      _$StartSavingImpl _value, $Res Function(_$StartSavingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$StartSavingImpl implements _StartSaving {
  const _$StartSavingImpl();

  @override
  String toString() {
    return 'ChecklistEvent.startSaving()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartSavingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return startSaving();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return startSaving?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (startSaving != null) {
      return startSaving();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return startSaving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return startSaving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (startSaving != null) {
      return startSaving(this);
    }
    return orElse();
  }
}

abstract class _StartSaving implements ChecklistEvent {
  const factory _StartSaving() = _$StartSavingImpl;
}

/// @nodoc
abstract class _$$ExecutionStartedImplCopyWith<$Res> {
  factory _$$ExecutionStartedImplCopyWith(_$ExecutionStartedImpl value,
          $Res Function(_$ExecutionStartedImpl) then) =
      __$$ExecutionStartedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String executionId});
}

/// @nodoc
class __$$ExecutionStartedImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$ExecutionStartedImpl>
    implements _$$ExecutionStartedImplCopyWith<$Res> {
  __$$ExecutionStartedImplCopyWithImpl(_$ExecutionStartedImpl _value,
      $Res Function(_$ExecutionStartedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? executionId = null,
  }) {
    return _then(_$ExecutionStartedImpl(
      null == executionId
          ? _value.executionId
          : executionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExecutionStartedImpl implements _ExecutionStarted {
  const _$ExecutionStartedImpl(this.executionId);

  @override
  final String executionId;

  @override
  String toString() {
    return 'ChecklistEvent.executionStarted(executionId: $executionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExecutionStartedImpl &&
            (identical(other.executionId, executionId) ||
                other.executionId == executionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, executionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExecutionStartedImplCopyWith<_$ExecutionStartedImpl> get copyWith =>
      __$$ExecutionStartedImplCopyWithImpl<_$ExecutionStartedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return executionStarted(executionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return executionStarted?.call(executionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (executionStarted != null) {
      return executionStarted(executionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return executionStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return executionStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (executionStarted != null) {
      return executionStarted(this);
    }
    return orElse();
  }
}

abstract class _ExecutionStarted implements ChecklistEvent {
  const factory _ExecutionStarted(final String executionId) =
      _$ExecutionStartedImpl;

  String get executionId;
  @JsonKey(ignore: true)
  _$$ExecutionStartedImplCopyWith<_$ExecutionStartedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveCompletedImplCopyWith<$Res> {
  factory _$$SaveCompletedImplCopyWith(
          _$SaveCompletedImpl value, $Res Function(_$SaveCompletedImpl) then) =
      __$$SaveCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SaveCompletedImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$SaveCompletedImpl>
    implements _$$SaveCompletedImplCopyWith<$Res> {
  __$$SaveCompletedImplCopyWithImpl(
      _$SaveCompletedImpl _value, $Res Function(_$SaveCompletedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SaveCompletedImpl implements _SaveCompleted {
  const _$SaveCompletedImpl();

  @override
  String toString() {
    return 'ChecklistEvent.saveCompleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SaveCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return saveCompleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return saveCompleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (saveCompleted != null) {
      return saveCompleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return saveCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return saveCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (saveCompleted != null) {
      return saveCompleted(this);
    }
    return orElse();
  }
}

abstract class _SaveCompleted implements ChecklistEvent {
  const factory _SaveCompleted() = _$SaveCompletedImpl;
}

/// @nodoc
abstract class _$$SaveFailedImplCopyWith<$Res> {
  factory _$$SaveFailedImplCopyWith(
          _$SaveFailedImpl value, $Res Function(_$SaveFailedImpl) then) =
      __$$SaveFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SaveFailedImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$SaveFailedImpl>
    implements _$$SaveFailedImplCopyWith<$Res> {
  __$$SaveFailedImplCopyWithImpl(
      _$SaveFailedImpl _value, $Res Function(_$SaveFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SaveFailedImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SaveFailedImpl implements _SaveFailed {
  const _$SaveFailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ChecklistEvent.saveFailed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveFailedImplCopyWith<_$SaveFailedImpl> get copyWith =>
      __$$SaveFailedImplCopyWithImpl<_$SaveFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return saveFailed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return saveFailed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (saveFailed != null) {
      return saveFailed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return saveFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return saveFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (saveFailed != null) {
      return saveFailed(this);
    }
    return orElse();
  }
}

abstract class _SaveFailed implements ChecklistEvent {
  const factory _SaveFailed(final String message) = _$SaveFailedImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SaveFailedImplCopyWith<_$SaveFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearErrorImplCopyWith<$Res> {
  factory _$$ClearErrorImplCopyWith(
          _$ClearErrorImpl value, $Res Function(_$ClearErrorImpl) then) =
      __$$ClearErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearErrorImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$ClearErrorImpl>
    implements _$$ClearErrorImplCopyWith<$Res> {
  __$$ClearErrorImplCopyWithImpl(
      _$ClearErrorImpl _value, $Res Function(_$ClearErrorImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClearErrorImpl implements _ClearError {
  const _$ClearErrorImpl();

  @override
  String toString() {
    return 'ChecklistEvent.clearError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return clearError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return clearError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return clearError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return clearError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError(this);
    }
    return orElse();
  }
}

abstract class _ClearError implements ChecklistEvent {
  const factory _ClearError() = _$ClearErrorImpl;
}

/// @nodoc
abstract class _$$ResetImplCopyWith<$Res> {
  factory _$$ResetImplCopyWith(
          _$ResetImpl value, $Res Function(_$ResetImpl) then) =
      __$$ResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetImplCopyWithImpl<$Res>
    extends _$ChecklistEventCopyWithImpl<$Res, _$ResetImpl>
    implements _$$ResetImplCopyWith<$Res> {
  __$$ResetImplCopyWithImpl(
      _$ResetImpl _value, $Res Function(_$ResetImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ResetImpl implements _Reset {
  const _$ResetImpl();

  @override
  String toString() {
    return 'ChecklistEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadData,
    required TResult Function(Map<String, dynamic> vehicleData) vehicleLoaded,
    required TResult Function(Map<String, dynamic> checklistData)
        checklistLoaded,
    required TResult Function(String message) loadFailed,
    required TResult Function(
            String itemId, String value, bool isConforming, String? notes)
        answerItem,
    required TResult Function() startSaving,
    required TResult Function(String executionId) executionStarted,
    required TResult Function() saveCompleted,
    required TResult Function(String message) saveFailed,
    required TResult Function() clearError,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadData,
    TResult? Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult? Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult? Function(String message)? loadFailed,
    TResult? Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult? Function()? startSaving,
    TResult? Function(String executionId)? executionStarted,
    TResult? Function()? saveCompleted,
    TResult? Function(String message)? saveFailed,
    TResult? Function()? clearError,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadData,
    TResult Function(Map<String, dynamic> vehicleData)? vehicleLoaded,
    TResult Function(Map<String, dynamic> checklistData)? checklistLoaded,
    TResult Function(String message)? loadFailed,
    TResult Function(
            String itemId, String value, bool isConforming, String? notes)?
        answerItem,
    TResult Function()? startSaving,
    TResult Function(String executionId)? executionStarted,
    TResult Function()? saveCompleted,
    TResult Function(String message)? saveFailed,
    TResult Function()? clearError,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadData value) loadData,
    required TResult Function(_VehicleLoaded value) vehicleLoaded,
    required TResult Function(_ChecklistLoaded value) checklistLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_AnswerItem value) answerItem,
    required TResult Function(_StartSaving value) startSaving,
    required TResult Function(_ExecutionStarted value) executionStarted,
    required TResult Function(_SaveCompleted value) saveCompleted,
    required TResult Function(_SaveFailed value) saveFailed,
    required TResult Function(_ClearError value) clearError,
    required TResult Function(_Reset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadData value)? loadData,
    TResult? Function(_VehicleLoaded value)? vehicleLoaded,
    TResult? Function(_ChecklistLoaded value)? checklistLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_AnswerItem value)? answerItem,
    TResult? Function(_StartSaving value)? startSaving,
    TResult? Function(_ExecutionStarted value)? executionStarted,
    TResult? Function(_SaveCompleted value)? saveCompleted,
    TResult? Function(_SaveFailed value)? saveFailed,
    TResult? Function(_ClearError value)? clearError,
    TResult? Function(_Reset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadData value)? loadData,
    TResult Function(_VehicleLoaded value)? vehicleLoaded,
    TResult Function(_ChecklistLoaded value)? checklistLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_AnswerItem value)? answerItem,
    TResult Function(_StartSaving value)? startSaving,
    TResult Function(_ExecutionStarted value)? executionStarted,
    TResult Function(_SaveCompleted value)? saveCompleted,
    TResult Function(_SaveFailed value)? saveFailed,
    TResult Function(_ClearError value)? clearError,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _Reset implements ChecklistEvent {
  const factory _Reset() = _$ResetImpl;
}

/// @nodoc
mixin _$ChecklistState {
// Estado de carregamento
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError; // Dados
  Map<String, dynamic>? get vehicleData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get checklistData => throw _privateConstructorUsedError;
  String? get executionId =>
      throw _privateConstructorUsedError; // Mapa de respostas: item_id -> {value, is_conforming, notes}
  Map<String, Map<String, dynamic>> get responses =>
      throw _privateConstructorUsedError; // Erro
  bool get hasError => throw _privateConstructorUsedError;
  String? get errorMessage =>
      throw _privateConstructorUsedError; // Sucesso de salvamento
  bool get saveSuccess => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChecklistStateCopyWith<ChecklistState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistStateCopyWith<$Res> {
  factory $ChecklistStateCopyWith(
          ChecklistState value, $Res Function(ChecklistState) then) =
      _$ChecklistStateCopyWithImpl<$Res, ChecklistState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isSaving,
      Map<String, dynamic>? vehicleData,
      Map<String, dynamic>? checklistData,
      String? executionId,
      Map<String, Map<String, dynamic>> responses,
      bool hasError,
      String? errorMessage,
      bool saveSuccess});
}

/// @nodoc
class _$ChecklistStateCopyWithImpl<$Res, $Val extends ChecklistState>
    implements $ChecklistStateCopyWith<$Res> {
  _$ChecklistStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSaving = null,
    Object? vehicleData = freezed,
    Object? checklistData = freezed,
    Object? executionId = freezed,
    Object? responses = null,
    Object? hasError = null,
    Object? errorMessage = freezed,
    Object? saveSuccess = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      vehicleData: freezed == vehicleData
          ? _value.vehicleData
          : vehicleData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      checklistData: freezed == checklistData
          ? _value.checklistData
          : checklistData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      executionId: freezed == executionId
          ? _value.executionId
          : executionId // ignore: cast_nullable_to_non_nullable
              as String?,
      responses: null == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, dynamic>>,
      hasError: null == hasError
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      saveSuccess: null == saveSuccess
          ? _value.saveSuccess
          : saveSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChecklistStateImplCopyWith<$Res>
    implements $ChecklistStateCopyWith<$Res> {
  factory _$$ChecklistStateImplCopyWith(_$ChecklistStateImpl value,
          $Res Function(_$ChecklistStateImpl) then) =
      __$$ChecklistStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isSaving,
      Map<String, dynamic>? vehicleData,
      Map<String, dynamic>? checklistData,
      String? executionId,
      Map<String, Map<String, dynamic>> responses,
      bool hasError,
      String? errorMessage,
      bool saveSuccess});
}

/// @nodoc
class __$$ChecklistStateImplCopyWithImpl<$Res>
    extends _$ChecklistStateCopyWithImpl<$Res, _$ChecklistStateImpl>
    implements _$$ChecklistStateImplCopyWith<$Res> {
  __$$ChecklistStateImplCopyWithImpl(
      _$ChecklistStateImpl _value, $Res Function(_$ChecklistStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSaving = null,
    Object? vehicleData = freezed,
    Object? checklistData = freezed,
    Object? executionId = freezed,
    Object? responses = null,
    Object? hasError = null,
    Object? errorMessage = freezed,
    Object? saveSuccess = null,
  }) {
    return _then(_$ChecklistStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      vehicleData: freezed == vehicleData
          ? _value._vehicleData
          : vehicleData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      checklistData: freezed == checklistData
          ? _value._checklistData
          : checklistData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      executionId: freezed == executionId
          ? _value.executionId
          : executionId // ignore: cast_nullable_to_non_nullable
              as String?,
      responses: null == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, dynamic>>,
      hasError: null == hasError
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      saveSuccess: null == saveSuccess
          ? _value.saveSuccess
          : saveSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ChecklistStateImpl implements _ChecklistState {
  const _$ChecklistStateImpl(
      {this.isLoading = true,
      this.isSaving = false,
      final Map<String, dynamic>? vehicleData = null,
      final Map<String, dynamic>? checklistData = null,
      this.executionId = null,
      final Map<String, Map<String, dynamic>> responses = const {},
      this.hasError = false,
      this.errorMessage = null,
      this.saveSuccess = false})
      : _vehicleData = vehicleData,
        _checklistData = checklistData,
        _responses = responses;

// Estado de carregamento
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
// Dados
  final Map<String, dynamic>? _vehicleData;
// Dados
  @override
  @JsonKey()
  Map<String, dynamic>? get vehicleData {
    final value = _vehicleData;
    if (value == null) return null;
    if (_vehicleData is EqualUnmodifiableMapView) return _vehicleData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _checklistData;
  @override
  @JsonKey()
  Map<String, dynamic>? get checklistData {
    final value = _checklistData;
    if (value == null) return null;
    if (_checklistData is EqualUnmodifiableMapView) return _checklistData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String? executionId;
// Mapa de respostas: item_id -> {value, is_conforming, notes}
  final Map<String, Map<String, dynamic>> _responses;
// Mapa de respostas: item_id -> {value, is_conforming, notes}
  @override
  @JsonKey()
  Map<String, Map<String, dynamic>> get responses {
    if (_responses is EqualUnmodifiableMapView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_responses);
  }

// Erro
  @override
  @JsonKey()
  final bool hasError;
  @override
  @JsonKey()
  final String? errorMessage;
// Sucesso de salvamento
  @override
  @JsonKey()
  final bool saveSuccess;

  @override
  String toString() {
    return 'ChecklistState(isLoading: $isLoading, isSaving: $isSaving, vehicleData: $vehicleData, checklistData: $checklistData, executionId: $executionId, responses: $responses, hasError: $hasError, errorMessage: $errorMessage, saveSuccess: $saveSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            const DeepCollectionEquality()
                .equals(other._vehicleData, _vehicleData) &&
            const DeepCollectionEquality()
                .equals(other._checklistData, _checklistData) &&
            (identical(other.executionId, executionId) ||
                other.executionId == executionId) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.saveSuccess, saveSuccess) ||
                other.saveSuccess == saveSuccess));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isSaving,
      const DeepCollectionEquality().hash(_vehicleData),
      const DeepCollectionEquality().hash(_checklistData),
      executionId,
      const DeepCollectionEquality().hash(_responses),
      hasError,
      errorMessage,
      saveSuccess);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistStateImplCopyWith<_$ChecklistStateImpl> get copyWith =>
      __$$ChecklistStateImplCopyWithImpl<_$ChecklistStateImpl>(
          this, _$identity);
}

abstract class _ChecklistState implements ChecklistState {
  const factory _ChecklistState(
      {final bool isLoading,
      final bool isSaving,
      final Map<String, dynamic>? vehicleData,
      final Map<String, dynamic>? checklistData,
      final String? executionId,
      final Map<String, Map<String, dynamic>> responses,
      final bool hasError,
      final String? errorMessage,
      final bool saveSuccess}) = _$ChecklistStateImpl;

  @override // Estado de carregamento
  bool get isLoading;
  @override
  bool get isSaving;
  @override // Dados
  Map<String, dynamic>? get vehicleData;
  @override
  Map<String, dynamic>? get checklistData;
  @override
  String? get executionId;
  @override // Mapa de respostas: item_id -> {value, is_conforming, notes}
  Map<String, Map<String, dynamic>> get responses;
  @override // Erro
  bool get hasError;
  @override
  String? get errorMessage;
  @override // Sucesso de salvamento
  bool get saveSuccess;
  @override
  @JsonKey(ignore: true)
  _$$ChecklistStateImplCopyWith<_$ChecklistStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
