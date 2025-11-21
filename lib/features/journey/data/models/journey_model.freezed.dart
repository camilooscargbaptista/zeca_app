// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JourneyModel _$JourneyModelFromJson(Map<String, dynamic> json) {
  return _JourneyModel.fromJson(json);
}

/// @nodoc
mixin _$JourneyModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  String get driverId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  String get vehicleId => throw _privateConstructorUsedError;
  String get placa => throw _privateConstructorUsedError;
  @JsonKey(name: 'odometro_inicial')
  int get odometroInicial => throw _privateConstructorUsedError;
  String? get destino => throw _privateConstructorUsedError;
  @JsonKey(name: 'previsao_km')
  int? get previsaoKm => throw _privateConstructorUsedError;
  String? get observacoes => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_inicio')
  DateTime get dataInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_fim')
  DateTime? get dataFim => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'tempo_direcao_segundos')
  int get tempoDirecaoSegundos => throw _privateConstructorUsedError;
  @JsonKey(name: 'tempo_descanso_segundos')
  int get tempoDescansoSegundos => throw _privateConstructorUsedError;
  @JsonKey(name: 'km_percorridos')
  double get kmPercorridos => throw _privateConstructorUsedError;
  @JsonKey(name: 'velocidade_media')
  double? get velocidadeMedia => throw _privateConstructorUsedError;
  @JsonKey(name: 'velocidade_maxima')
  double? get velocidadeMaxima => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat_velocidade_maxima')
  double? get latVelocidadeMaxima => throw _privateConstructorUsedError;
  @JsonKey(name: 'long_velocidade_maxima')
  double? get longVelocidadeMaxima => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'segments_summary')
  List<Map<String, dynamic>>? get segmentsSummaryJson =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JourneyModelCopyWith<JourneyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JourneyModelCopyWith<$Res> {
  factory $JourneyModelCopyWith(
          JourneyModel value, $Res Function(JourneyModel) then) =
      _$JourneyModelCopyWithImpl<$Res, JourneyModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'driver_id') String driverId,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      String placa,
      @JsonKey(name: 'odometro_inicial') int odometroInicial,
      String? destino,
      @JsonKey(name: 'previsao_km') int? previsaoKm,
      String? observacoes,
      @JsonKey(name: 'data_inicio') DateTime dataInicio,
      @JsonKey(name: 'data_fim') DateTime? dataFim,
      String status,
      @JsonKey(name: 'tempo_direcao_segundos') int tempoDirecaoSegundos,
      @JsonKey(name: 'tempo_descanso_segundos') int tempoDescansoSegundos,
      @JsonKey(name: 'km_percorridos') double kmPercorridos,
      @JsonKey(name: 'velocidade_media') double? velocidadeMedia,
      @JsonKey(name: 'velocidade_maxima') double? velocidadeMaxima,
      @JsonKey(name: 'lat_velocidade_maxima') double? latVelocidadeMaxima,
      @JsonKey(name: 'long_velocidade_maxima') double? longVelocidadeMaxima,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'segments_summary')
      List<Map<String, dynamic>>? segmentsSummaryJson});
}

/// @nodoc
class _$JourneyModelCopyWithImpl<$Res, $Val extends JourneyModel>
    implements $JourneyModelCopyWith<$Res> {
  _$JourneyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = null,
    Object? vehicleId = null,
    Object? placa = null,
    Object? odometroInicial = null,
    Object? destino = freezed,
    Object? previsaoKm = freezed,
    Object? observacoes = freezed,
    Object? dataInicio = null,
    Object? dataFim = freezed,
    Object? status = null,
    Object? tempoDirecaoSegundos = null,
    Object? tempoDescansoSegundos = null,
    Object? kmPercorridos = null,
    Object? velocidadeMedia = freezed,
    Object? velocidadeMaxima = freezed,
    Object? latVelocidadeMaxima = freezed,
    Object? longVelocidadeMaxima = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? segmentsSummaryJson = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _value.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      odometroInicial: null == odometroInicial
          ? _value.odometroInicial
          : odometroInicial // ignore: cast_nullable_to_non_nullable
              as int,
      destino: freezed == destino
          ? _value.destino
          : destino // ignore: cast_nullable_to_non_nullable
              as String?,
      previsaoKm: freezed == previsaoKm
          ? _value.previsaoKm
          : previsaoKm // ignore: cast_nullable_to_non_nullable
              as int?,
      observacoes: freezed == observacoes
          ? _value.observacoes
          : observacoes // ignore: cast_nullable_to_non_nullable
              as String?,
      dataInicio: null == dataInicio
          ? _value.dataInicio
          : dataInicio // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dataFim: freezed == dataFim
          ? _value.dataFim
          : dataFim // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      tempoDirecaoSegundos: null == tempoDirecaoSegundos
          ? _value.tempoDirecaoSegundos
          : tempoDirecaoSegundos // ignore: cast_nullable_to_non_nullable
              as int,
      tempoDescansoSegundos: null == tempoDescansoSegundos
          ? _value.tempoDescansoSegundos
          : tempoDescansoSegundos // ignore: cast_nullable_to_non_nullable
              as int,
      kmPercorridos: null == kmPercorridos
          ? _value.kmPercorridos
          : kmPercorridos // ignore: cast_nullable_to_non_nullable
              as double,
      velocidadeMedia: freezed == velocidadeMedia
          ? _value.velocidadeMedia
          : velocidadeMedia // ignore: cast_nullable_to_non_nullable
              as double?,
      velocidadeMaxima: freezed == velocidadeMaxima
          ? _value.velocidadeMaxima
          : velocidadeMaxima // ignore: cast_nullable_to_non_nullable
              as double?,
      latVelocidadeMaxima: freezed == latVelocidadeMaxima
          ? _value.latVelocidadeMaxima
          : latVelocidadeMaxima // ignore: cast_nullable_to_non_nullable
              as double?,
      longVelocidadeMaxima: freezed == longVelocidadeMaxima
          ? _value.longVelocidadeMaxima
          : longVelocidadeMaxima // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      segmentsSummaryJson: freezed == segmentsSummaryJson
          ? _value.segmentsSummaryJson
          : segmentsSummaryJson // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JourneyModelImplCopyWith<$Res>
    implements $JourneyModelCopyWith<$Res> {
  factory _$$JourneyModelImplCopyWith(
          _$JourneyModelImpl value, $Res Function(_$JourneyModelImpl) then) =
      __$$JourneyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'driver_id') String driverId,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      String placa,
      @JsonKey(name: 'odometro_inicial') int odometroInicial,
      String? destino,
      @JsonKey(name: 'previsao_km') int? previsaoKm,
      String? observacoes,
      @JsonKey(name: 'data_inicio') DateTime dataInicio,
      @JsonKey(name: 'data_fim') DateTime? dataFim,
      String status,
      @JsonKey(name: 'tempo_direcao_segundos') int tempoDirecaoSegundos,
      @JsonKey(name: 'tempo_descanso_segundos') int tempoDescansoSegundos,
      @JsonKey(name: 'km_percorridos') double kmPercorridos,
      @JsonKey(name: 'velocidade_media') double? velocidadeMedia,
      @JsonKey(name: 'velocidade_maxima') double? velocidadeMaxima,
      @JsonKey(name: 'lat_velocidade_maxima') double? latVelocidadeMaxima,
      @JsonKey(name: 'long_velocidade_maxima') double? longVelocidadeMaxima,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'segments_summary')
      List<Map<String, dynamic>>? segmentsSummaryJson});
}

/// @nodoc
class __$$JourneyModelImplCopyWithImpl<$Res>
    extends _$JourneyModelCopyWithImpl<$Res, _$JourneyModelImpl>
    implements _$$JourneyModelImplCopyWith<$Res> {
  __$$JourneyModelImplCopyWithImpl(
      _$JourneyModelImpl _value, $Res Function(_$JourneyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = null,
    Object? vehicleId = null,
    Object? placa = null,
    Object? odometroInicial = null,
    Object? destino = freezed,
    Object? previsaoKm = freezed,
    Object? observacoes = freezed,
    Object? dataInicio = null,
    Object? dataFim = freezed,
    Object? status = null,
    Object? tempoDirecaoSegundos = null,
    Object? tempoDescansoSegundos = null,
    Object? kmPercorridos = null,
    Object? velocidadeMedia = freezed,
    Object? velocidadeMaxima = freezed,
    Object? latVelocidadeMaxima = freezed,
    Object? longVelocidadeMaxima = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? segmentsSummaryJson = freezed,
  }) {
    return _then(_$JourneyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _value.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      odometroInicial: null == odometroInicial
          ? _value.odometroInicial
          : odometroInicial // ignore: cast_nullable_to_non_nullable
              as int,
      destino: freezed == destino
          ? _value.destino
          : destino // ignore: cast_nullable_to_non_nullable
              as String?,
      previsaoKm: freezed == previsaoKm
          ? _value.previsaoKm
          : previsaoKm // ignore: cast_nullable_to_non_nullable
              as int?,
      observacoes: freezed == observacoes
          ? _value.observacoes
          : observacoes // ignore: cast_nullable_to_non_nullable
              as String?,
      dataInicio: null == dataInicio
          ? _value.dataInicio
          : dataInicio // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dataFim: freezed == dataFim
          ? _value.dataFim
          : dataFim // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      tempoDirecaoSegundos: null == tempoDirecaoSegundos
          ? _value.tempoDirecaoSegundos
          : tempoDirecaoSegundos // ignore: cast_nullable_to_non_nullable
              as int,
      tempoDescansoSegundos: null == tempoDescansoSegundos
          ? _value.tempoDescansoSegundos
          : tempoDescansoSegundos // ignore: cast_nullable_to_non_nullable
              as int,
      kmPercorridos: null == kmPercorridos
          ? _value.kmPercorridos
          : kmPercorridos // ignore: cast_nullable_to_non_nullable
              as double,
      velocidadeMedia: freezed == velocidadeMedia
          ? _value.velocidadeMedia
          : velocidadeMedia // ignore: cast_nullable_to_non_nullable
              as double?,
      velocidadeMaxima: freezed == velocidadeMaxima
          ? _value.velocidadeMaxima
          : velocidadeMaxima // ignore: cast_nullable_to_non_nullable
              as double?,
      latVelocidadeMaxima: freezed == latVelocidadeMaxima
          ? _value.latVelocidadeMaxima
          : latVelocidadeMaxima // ignore: cast_nullable_to_non_nullable
              as double?,
      longVelocidadeMaxima: freezed == longVelocidadeMaxima
          ? _value.longVelocidadeMaxima
          : longVelocidadeMaxima // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      segmentsSummaryJson: freezed == segmentsSummaryJson
          ? _value._segmentsSummaryJson
          : segmentsSummaryJson // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JourneyModelImpl extends _JourneyModel {
  const _$JourneyModelImpl(
      {required this.id,
      @JsonKey(name: 'driver_id') required this.driverId,
      @JsonKey(name: 'vehicle_id') required this.vehicleId,
      required this.placa,
      @JsonKey(name: 'odometro_inicial') required this.odometroInicial,
      this.destino,
      @JsonKey(name: 'previsao_km') this.previsaoKm,
      this.observacoes,
      @JsonKey(name: 'data_inicio') required this.dataInicio,
      @JsonKey(name: 'data_fim') this.dataFim,
      required this.status,
      @JsonKey(name: 'tempo_direcao_segundos') this.tempoDirecaoSegundos = 0,
      @JsonKey(name: 'tempo_descanso_segundos') this.tempoDescansoSegundos = 0,
      @JsonKey(name: 'km_percorridos') this.kmPercorridos = 0.0,
      @JsonKey(name: 'velocidade_media') this.velocidadeMedia,
      @JsonKey(name: 'velocidade_maxima') this.velocidadeMaxima,
      @JsonKey(name: 'lat_velocidade_maxima') this.latVelocidadeMaxima,
      @JsonKey(name: 'long_velocidade_maxima') this.longVelocidadeMaxima,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'segments_summary')
      final List<Map<String, dynamic>>? segmentsSummaryJson})
      : _segmentsSummaryJson = segmentsSummaryJson,
        super._();

  factory _$JourneyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JourneyModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'driver_id')
  final String driverId;
  @override
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @override
  final String placa;
  @override
  @JsonKey(name: 'odometro_inicial')
  final int odometroInicial;
  @override
  final String? destino;
  @override
  @JsonKey(name: 'previsao_km')
  final int? previsaoKm;
  @override
  final String? observacoes;
  @override
  @JsonKey(name: 'data_inicio')
  final DateTime dataInicio;
  @override
  @JsonKey(name: 'data_fim')
  final DateTime? dataFim;
  @override
  final String status;
  @override
  @JsonKey(name: 'tempo_direcao_segundos')
  final int tempoDirecaoSegundos;
  @override
  @JsonKey(name: 'tempo_descanso_segundos')
  final int tempoDescansoSegundos;
  @override
  @JsonKey(name: 'km_percorridos')
  final double kmPercorridos;
  @override
  @JsonKey(name: 'velocidade_media')
  final double? velocidadeMedia;
  @override
  @JsonKey(name: 'velocidade_maxima')
  final double? velocidadeMaxima;
  @override
  @JsonKey(name: 'lat_velocidade_maxima')
  final double? latVelocidadeMaxima;
  @override
  @JsonKey(name: 'long_velocidade_maxima')
  final double? longVelocidadeMaxima;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<Map<String, dynamic>>? _segmentsSummaryJson;
  @override
  @JsonKey(name: 'segments_summary')
  List<Map<String, dynamic>>? get segmentsSummaryJson {
    final value = _segmentsSummaryJson;
    if (value == null) return null;
    if (_segmentsSummaryJson is EqualUnmodifiableListView)
      return _segmentsSummaryJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'JourneyModel(id: $id, driverId: $driverId, vehicleId: $vehicleId, placa: $placa, odometroInicial: $odometroInicial, destino: $destino, previsaoKm: $previsaoKm, observacoes: $observacoes, dataInicio: $dataInicio, dataFim: $dataFim, status: $status, tempoDirecaoSegundos: $tempoDirecaoSegundos, tempoDescansoSegundos: $tempoDescansoSegundos, kmPercorridos: $kmPercorridos, velocidadeMedia: $velocidadeMedia, velocidadeMaxima: $velocidadeMaxima, latVelocidadeMaxima: $latVelocidadeMaxima, longVelocidadeMaxima: $longVelocidadeMaxima, createdAt: $createdAt, updatedAt: $updatedAt, segmentsSummaryJson: $segmentsSummaryJson)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JourneyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.odometroInicial, odometroInicial) ||
                other.odometroInicial == odometroInicial) &&
            (identical(other.destino, destino) || other.destino == destino) &&
            (identical(other.previsaoKm, previsaoKm) ||
                other.previsaoKm == previsaoKm) &&
            (identical(other.observacoes, observacoes) ||
                other.observacoes == observacoes) &&
            (identical(other.dataInicio, dataInicio) ||
                other.dataInicio == dataInicio) &&
            (identical(other.dataFim, dataFim) || other.dataFim == dataFim) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tempoDirecaoSegundos, tempoDirecaoSegundos) ||
                other.tempoDirecaoSegundos == tempoDirecaoSegundos) &&
            (identical(other.tempoDescansoSegundos, tempoDescansoSegundos) ||
                other.tempoDescansoSegundos == tempoDescansoSegundos) &&
            (identical(other.kmPercorridos, kmPercorridos) ||
                other.kmPercorridos == kmPercorridos) &&
            (identical(other.velocidadeMedia, velocidadeMedia) ||
                other.velocidadeMedia == velocidadeMedia) &&
            (identical(other.velocidadeMaxima, velocidadeMaxima) ||
                other.velocidadeMaxima == velocidadeMaxima) &&
            (identical(other.latVelocidadeMaxima, latVelocidadeMaxima) ||
                other.latVelocidadeMaxima == latVelocidadeMaxima) &&
            (identical(other.longVelocidadeMaxima, longVelocidadeMaxima) ||
                other.longVelocidadeMaxima == longVelocidadeMaxima) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._segmentsSummaryJson, _segmentsSummaryJson));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        driverId,
        vehicleId,
        placa,
        odometroInicial,
        destino,
        previsaoKm,
        observacoes,
        dataInicio,
        dataFim,
        status,
        tempoDirecaoSegundos,
        tempoDescansoSegundos,
        kmPercorridos,
        velocidadeMedia,
        velocidadeMaxima,
        latVelocidadeMaxima,
        longVelocidadeMaxima,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_segmentsSummaryJson)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JourneyModelImplCopyWith<_$JourneyModelImpl> get copyWith =>
      __$$JourneyModelImplCopyWithImpl<_$JourneyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JourneyModelImplToJson(
      this,
    );
  }
}

abstract class _JourneyModel extends JourneyModel {
  const factory _JourneyModel(
      {required final String id,
      @JsonKey(name: 'driver_id') required final String driverId,
      @JsonKey(name: 'vehicle_id') required final String vehicleId,
      required final String placa,
      @JsonKey(name: 'odometro_inicial') required final int odometroInicial,
      final String? destino,
      @JsonKey(name: 'previsao_km') final int? previsaoKm,
      final String? observacoes,
      @JsonKey(name: 'data_inicio') required final DateTime dataInicio,
      @JsonKey(name: 'data_fim') final DateTime? dataFim,
      required final String status,
      @JsonKey(name: 'tempo_direcao_segundos') final int tempoDirecaoSegundos,
      @JsonKey(name: 'tempo_descanso_segundos') final int tempoDescansoSegundos,
      @JsonKey(name: 'km_percorridos') final double kmPercorridos,
      @JsonKey(name: 'velocidade_media') final double? velocidadeMedia,
      @JsonKey(name: 'velocidade_maxima') final double? velocidadeMaxima,
      @JsonKey(name: 'lat_velocidade_maxima') final double? latVelocidadeMaxima,
      @JsonKey(name: 'long_velocidade_maxima')
      final double? longVelocidadeMaxima,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'segments_summary')
      final List<Map<String, dynamic>>?
          segmentsSummaryJson}) = _$JourneyModelImpl;
  const _JourneyModel._() : super._();

  factory _JourneyModel.fromJson(Map<String, dynamic> json) =
      _$JourneyModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'driver_id')
  String get driverId;
  @override
  @JsonKey(name: 'vehicle_id')
  String get vehicleId;
  @override
  String get placa;
  @override
  @JsonKey(name: 'odometro_inicial')
  int get odometroInicial;
  @override
  String? get destino;
  @override
  @JsonKey(name: 'previsao_km')
  int? get previsaoKm;
  @override
  String? get observacoes;
  @override
  @JsonKey(name: 'data_inicio')
  DateTime get dataInicio;
  @override
  @JsonKey(name: 'data_fim')
  DateTime? get dataFim;
  @override
  String get status;
  @override
  @JsonKey(name: 'tempo_direcao_segundos')
  int get tempoDirecaoSegundos;
  @override
  @JsonKey(name: 'tempo_descanso_segundos')
  int get tempoDescansoSegundos;
  @override
  @JsonKey(name: 'km_percorridos')
  double get kmPercorridos;
  @override
  @JsonKey(name: 'velocidade_media')
  double? get velocidadeMedia;
  @override
  @JsonKey(name: 'velocidade_maxima')
  double? get velocidadeMaxima;
  @override
  @JsonKey(name: 'lat_velocidade_maxima')
  double? get latVelocidadeMaxima;
  @override
  @JsonKey(name: 'long_velocidade_maxima')
  double? get longVelocidadeMaxima;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'segments_summary')
  List<Map<String, dynamic>>? get segmentsSummaryJson;
  @override
  @JsonKey(ignore: true)
  _$$JourneyModelImplCopyWith<_$JourneyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
