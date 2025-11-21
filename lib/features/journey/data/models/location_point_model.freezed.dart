// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_point_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationPointModel _$LocationPointModelFromJson(Map<String, dynamic> json) {
  return _LocationPointModel.fromJson(json);
}

/// @nodoc
mixin _$LocationPointModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'journey_id')
  String get journeyId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get velocidade => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get sincronizado => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationPointModelCopyWith<LocationPointModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationPointModelCopyWith<$Res> {
  factory $LocationPointModelCopyWith(
          LocationPointModel value, $Res Function(LocationPointModel) then) =
      _$LocationPointModelCopyWithImpl<$Res, LocationPointModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'journey_id') String journeyId,
      double latitude,
      double longitude,
      double velocidade,
      DateTime timestamp,
      bool sincronizado,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$LocationPointModelCopyWithImpl<$Res, $Val extends LocationPointModel>
    implements $LocationPointModelCopyWith<$Res> {
  _$LocationPointModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journeyId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? velocidade = null,
    Object? timestamp = null,
    Object? sincronizado = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      journeyId: null == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      velocidade: null == velocidade
          ? _value.velocidade
          : velocidade // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sincronizado: null == sincronizado
          ? _value.sincronizado
          : sincronizado // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationPointModelImplCopyWith<$Res>
    implements $LocationPointModelCopyWith<$Res> {
  factory _$$LocationPointModelImplCopyWith(_$LocationPointModelImpl value,
          $Res Function(_$LocationPointModelImpl) then) =
      __$$LocationPointModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'journey_id') String journeyId,
      double latitude,
      double longitude,
      double velocidade,
      DateTime timestamp,
      bool sincronizado,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$LocationPointModelImplCopyWithImpl<$Res>
    extends _$LocationPointModelCopyWithImpl<$Res, _$LocationPointModelImpl>
    implements _$$LocationPointModelImplCopyWith<$Res> {
  __$$LocationPointModelImplCopyWithImpl(_$LocationPointModelImpl _value,
      $Res Function(_$LocationPointModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journeyId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? velocidade = null,
    Object? timestamp = null,
    Object? sincronizado = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$LocationPointModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      journeyId: null == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      velocidade: null == velocidade
          ? _value.velocidade
          : velocidade // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sincronizado: null == sincronizado
          ? _value.sincronizado
          : sincronizado // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationPointModelImpl extends _LocationPointModel {
  const _$LocationPointModelImpl(
      {required this.id,
      @JsonKey(name: 'journey_id') required this.journeyId,
      required this.latitude,
      required this.longitude,
      required this.velocidade,
      required this.timestamp,
      this.sincronizado = false,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$LocationPointModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationPointModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'journey_id')
  final String journeyId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double velocidade;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool sincronizado;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'LocationPointModel(id: $id, journeyId: $journeyId, latitude: $latitude, longitude: $longitude, velocidade: $velocidade, timestamp: $timestamp, sincronizado: $sincronizado, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationPointModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.journeyId, journeyId) ||
                other.journeyId == journeyId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.velocidade, velocidade) ||
                other.velocidade == velocidade) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.sincronizado, sincronizado) ||
                other.sincronizado == sincronizado) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, journeyId, latitude,
      longitude, velocidade, timestamp, sincronizado, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationPointModelImplCopyWith<_$LocationPointModelImpl> get copyWith =>
      __$$LocationPointModelImplCopyWithImpl<_$LocationPointModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationPointModelImplToJson(
      this,
    );
  }
}

abstract class _LocationPointModel extends LocationPointModel {
  const factory _LocationPointModel(
          {required final String id,
          @JsonKey(name: 'journey_id') required final String journeyId,
          required final double latitude,
          required final double longitude,
          required final double velocidade,
          required final DateTime timestamp,
          final bool sincronizado,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$LocationPointModelImpl;
  const _LocationPointModel._() : super._();

  factory _LocationPointModel.fromJson(Map<String, dynamic> json) =
      _$LocationPointModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'journey_id')
  String get journeyId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get velocidade;
  @override
  DateTime get timestamp;
  @override
  bool get sincronizado;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$LocationPointModelImplCopyWith<_$LocationPointModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
