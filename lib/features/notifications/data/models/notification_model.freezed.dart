// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get mensagem => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  @JsonKey(name: 'prioridade')
  String get prioridade => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'criado_em')
  DateTime get criadoEm => throw _privateConstructorUsedError;
  @JsonKey(name: 'lido_em')
  DateTime? get lidoEm => throw _privateConstructorUsedError;
  @JsonKey(name: 'acao')
  NotificationActionModel? get acao => throw _privateConstructorUsedError;
  @JsonKey(name: 'dados_extras')
  Map<String, dynamic>? get dadosExtras => throw _privateConstructorUsedError;
  @JsonKey(name: 'imagem_url')
  String? get imagemUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'icone_url')
  String? get iconeUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueling_id')
  String? get refuelingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  String? get vehicleId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {String id,
      String titulo,
      String mensagem,
      String tipo,
      @JsonKey(name: 'prioridade') String prioridade,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'criado_em') DateTime criadoEm,
      @JsonKey(name: 'lido_em') DateTime? lidoEm,
      @JsonKey(name: 'acao') NotificationActionModel? acao,
      @JsonKey(name: 'dados_extras') Map<String, dynamic>? dadosExtras,
      @JsonKey(name: 'imagem_url') String? imagemUrl,
      @JsonKey(name: 'icone_url') String? iconeUrl,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'refueling_id') String? refuelingId,
      @JsonKey(name: 'vehicle_id') String? vehicleId});

  $NotificationActionModelCopyWith<$Res>? get acao;
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? mensagem = null,
    Object? tipo = null,
    Object? prioridade = null,
    Object? status = null,
    Object? criadoEm = null,
    Object? lidoEm = freezed,
    Object? acao = freezed,
    Object? dadosExtras = freezed,
    Object? imagemUrl = freezed,
    Object? iconeUrl = freezed,
    Object? userId = freezed,
    Object? refuelingId = freezed,
    Object? vehicleId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      mensagem: null == mensagem
          ? _value.mensagem
          : mensagem // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      prioridade: null == prioridade
          ? _value.prioridade
          : prioridade // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      criadoEm: null == criadoEm
          ? _value.criadoEm
          : criadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lidoEm: freezed == lidoEm
          ? _value.lidoEm
          : lidoEm // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acao: freezed == acao
          ? _value.acao
          : acao // ignore: cast_nullable_to_non_nullable
              as NotificationActionModel?,
      dadosExtras: freezed == dadosExtras
          ? _value.dadosExtras
          : dadosExtras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      imagemUrl: freezed == imagemUrl
          ? _value.imagemUrl
          : imagemUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      iconeUrl: freezed == iconeUrl
          ? _value.iconeUrl
          : iconeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      refuelingId: freezed == refuelingId
          ? _value.refuelingId
          : refuelingId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationActionModelCopyWith<$Res>? get acao {
    if (_value.acao == null) {
      return null;
    }

    return $NotificationActionModelCopyWith<$Res>(_value.acao!, (value) {
      return _then(_value.copyWith(acao: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String titulo,
      String mensagem,
      String tipo,
      @JsonKey(name: 'prioridade') String prioridade,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'criado_em') DateTime criadoEm,
      @JsonKey(name: 'lido_em') DateTime? lidoEm,
      @JsonKey(name: 'acao') NotificationActionModel? acao,
      @JsonKey(name: 'dados_extras') Map<String, dynamic>? dadosExtras,
      @JsonKey(name: 'imagem_url') String? imagemUrl,
      @JsonKey(name: 'icone_url') String? iconeUrl,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'refueling_id') String? refuelingId,
      @JsonKey(name: 'vehicle_id') String? vehicleId});

  @override
  $NotificationActionModelCopyWith<$Res>? get acao;
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? mensagem = null,
    Object? tipo = null,
    Object? prioridade = null,
    Object? status = null,
    Object? criadoEm = null,
    Object? lidoEm = freezed,
    Object? acao = freezed,
    Object? dadosExtras = freezed,
    Object? imagemUrl = freezed,
    Object? iconeUrl = freezed,
    Object? userId = freezed,
    Object? refuelingId = freezed,
    Object? vehicleId = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      mensagem: null == mensagem
          ? _value.mensagem
          : mensagem // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      prioridade: null == prioridade
          ? _value.prioridade
          : prioridade // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      criadoEm: null == criadoEm
          ? _value.criadoEm
          : criadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lidoEm: freezed == lidoEm
          ? _value.lidoEm
          : lidoEm // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acao: freezed == acao
          ? _value.acao
          : acao // ignore: cast_nullable_to_non_nullable
              as NotificationActionModel?,
      dadosExtras: freezed == dadosExtras
          ? _value._dadosExtras
          : dadosExtras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      imagemUrl: freezed == imagemUrl
          ? _value.imagemUrl
          : imagemUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      iconeUrl: freezed == iconeUrl
          ? _value.iconeUrl
          : iconeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      refuelingId: freezed == refuelingId
          ? _value.refuelingId
          : refuelingId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.titulo,
      required this.mensagem,
      required this.tipo,
      @JsonKey(name: 'prioridade') required this.prioridade,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'criado_em') required this.criadoEm,
      @JsonKey(name: 'lido_em') this.lidoEm,
      @JsonKey(name: 'acao') this.acao,
      @JsonKey(name: 'dados_extras') final Map<String, dynamic>? dadosExtras,
      @JsonKey(name: 'imagem_url') this.imagemUrl,
      @JsonKey(name: 'icone_url') this.iconeUrl,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'refueling_id') this.refuelingId,
      @JsonKey(name: 'vehicle_id') this.vehicleId})
      : _dadosExtras = dadosExtras,
        super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String titulo;
  @override
  final String mensagem;
  @override
  final String tipo;
  @override
  @JsonKey(name: 'prioridade')
  final String prioridade;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'criado_em')
  final DateTime criadoEm;
  @override
  @JsonKey(name: 'lido_em')
  final DateTime? lidoEm;
  @override
  @JsonKey(name: 'acao')
  final NotificationActionModel? acao;
  final Map<String, dynamic>? _dadosExtras;
  @override
  @JsonKey(name: 'dados_extras')
  Map<String, dynamic>? get dadosExtras {
    final value = _dadosExtras;
    if (value == null) return null;
    if (_dadosExtras is EqualUnmodifiableMapView) return _dadosExtras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'imagem_url')
  final String? imagemUrl;
  @override
  @JsonKey(name: 'icone_url')
  final String? iconeUrl;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'refueling_id')
  final String? refuelingId;
  @override
  @JsonKey(name: 'vehicle_id')
  final String? vehicleId;

  @override
  String toString() {
    return 'NotificationModel(id: $id, titulo: $titulo, mensagem: $mensagem, tipo: $tipo, prioridade: $prioridade, status: $status, criadoEm: $criadoEm, lidoEm: $lidoEm, acao: $acao, dadosExtras: $dadosExtras, imagemUrl: $imagemUrl, iconeUrl: $iconeUrl, userId: $userId, refuelingId: $refuelingId, vehicleId: $vehicleId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.mensagem, mensagem) ||
                other.mensagem == mensagem) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.prioridade, prioridade) ||
                other.prioridade == prioridade) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.criadoEm, criadoEm) ||
                other.criadoEm == criadoEm) &&
            (identical(other.lidoEm, lidoEm) || other.lidoEm == lidoEm) &&
            (identical(other.acao, acao) || other.acao == acao) &&
            const DeepCollectionEquality()
                .equals(other._dadosExtras, _dadosExtras) &&
            (identical(other.imagemUrl, imagemUrl) ||
                other.imagemUrl == imagemUrl) &&
            (identical(other.iconeUrl, iconeUrl) ||
                other.iconeUrl == iconeUrl) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.refuelingId, refuelingId) ||
                other.refuelingId == refuelingId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      titulo,
      mensagem,
      tipo,
      prioridade,
      status,
      criadoEm,
      lidoEm,
      acao,
      const DeepCollectionEquality().hash(_dadosExtras),
      imagemUrl,
      iconeUrl,
      userId,
      refuelingId,
      vehicleId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel(
      {required final String id,
      required final String titulo,
      required final String mensagem,
      required final String tipo,
      @JsonKey(name: 'prioridade') required final String prioridade,
      @JsonKey(name: 'status') required final String status,
      @JsonKey(name: 'criado_em') required final DateTime criadoEm,
      @JsonKey(name: 'lido_em') final DateTime? lidoEm,
      @JsonKey(name: 'acao') final NotificationActionModel? acao,
      @JsonKey(name: 'dados_extras') final Map<String, dynamic>? dadosExtras,
      @JsonKey(name: 'imagem_url') final String? imagemUrl,
      @JsonKey(name: 'icone_url') final String? iconeUrl,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'refueling_id') final String? refuelingId,
      @JsonKey(name: 'vehicle_id')
      final String? vehicleId}) = _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get titulo;
  @override
  String get mensagem;
  @override
  String get tipo;
  @override
  @JsonKey(name: 'prioridade')
  String get prioridade;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'criado_em')
  DateTime get criadoEm;
  @override
  @JsonKey(name: 'lido_em')
  DateTime? get lidoEm;
  @override
  @JsonKey(name: 'acao')
  NotificationActionModel? get acao;
  @override
  @JsonKey(name: 'dados_extras')
  Map<String, dynamic>? get dadosExtras;
  @override
  @JsonKey(name: 'imagem_url')
  String? get imagemUrl;
  @override
  @JsonKey(name: 'icone_url')
  String? get iconeUrl;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'refueling_id')
  String? get refuelingId;
  @override
  @JsonKey(name: 'vehicle_id')
  String? get vehicleId;
  @override
  @JsonKey(ignore: true)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationActionModel _$NotificationActionModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationActionModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationActionModel {
  String get tipo => throw _privateConstructorUsedError;
  String? get rota => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parametros => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'texto_botao')
  String? get textoBotao => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationActionModelCopyWith<NotificationActionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationActionModelCopyWith<$Res> {
  factory $NotificationActionModelCopyWith(NotificationActionModel value,
          $Res Function(NotificationActionModel) then) =
      _$NotificationActionModelCopyWithImpl<$Res, NotificationActionModel>;
  @useResult
  $Res call(
      {String tipo,
      String? rota,
      Map<String, dynamic>? parametros,
      String? url,
      @JsonKey(name: 'texto_botao') String? textoBotao});
}

/// @nodoc
class _$NotificationActionModelCopyWithImpl<$Res,
        $Val extends NotificationActionModel>
    implements $NotificationActionModelCopyWith<$Res> {
  _$NotificationActionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tipo = null,
    Object? rota = freezed,
    Object? parametros = freezed,
    Object? url = freezed,
    Object? textoBotao = freezed,
  }) {
    return _then(_value.copyWith(
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      rota: freezed == rota
          ? _value.rota
          : rota // ignore: cast_nullable_to_non_nullable
              as String?,
      parametros: freezed == parametros
          ? _value.parametros
          : parametros // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      textoBotao: freezed == textoBotao
          ? _value.textoBotao
          : textoBotao // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationActionModelImplCopyWith<$Res>
    implements $NotificationActionModelCopyWith<$Res> {
  factory _$$NotificationActionModelImplCopyWith(
          _$NotificationActionModelImpl value,
          $Res Function(_$NotificationActionModelImpl) then) =
      __$$NotificationActionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tipo,
      String? rota,
      Map<String, dynamic>? parametros,
      String? url,
      @JsonKey(name: 'texto_botao') String? textoBotao});
}

/// @nodoc
class __$$NotificationActionModelImplCopyWithImpl<$Res>
    extends _$NotificationActionModelCopyWithImpl<$Res,
        _$NotificationActionModelImpl>
    implements _$$NotificationActionModelImplCopyWith<$Res> {
  __$$NotificationActionModelImplCopyWithImpl(
      _$NotificationActionModelImpl _value,
      $Res Function(_$NotificationActionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tipo = null,
    Object? rota = freezed,
    Object? parametros = freezed,
    Object? url = freezed,
    Object? textoBotao = freezed,
  }) {
    return _then(_$NotificationActionModelImpl(
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      rota: freezed == rota
          ? _value.rota
          : rota // ignore: cast_nullable_to_non_nullable
              as String?,
      parametros: freezed == parametros
          ? _value._parametros
          : parametros // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      textoBotao: freezed == textoBotao
          ? _value.textoBotao
          : textoBotao // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationActionModelImpl extends _NotificationActionModel {
  const _$NotificationActionModelImpl(
      {required this.tipo,
      this.rota,
      final Map<String, dynamic>? parametros,
      this.url,
      @JsonKey(name: 'texto_botao') this.textoBotao})
      : _parametros = parametros,
        super._();

  factory _$NotificationActionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationActionModelImplFromJson(json);

  @override
  final String tipo;
  @override
  final String? rota;
  final Map<String, dynamic>? _parametros;
  @override
  Map<String, dynamic>? get parametros {
    final value = _parametros;
    if (value == null) return null;
    if (_parametros is EqualUnmodifiableMapView) return _parametros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? url;
  @override
  @JsonKey(name: 'texto_botao')
  final String? textoBotao;

  @override
  String toString() {
    return 'NotificationActionModel(tipo: $tipo, rota: $rota, parametros: $parametros, url: $url, textoBotao: $textoBotao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationActionModelImpl &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.rota, rota) || other.rota == rota) &&
            const DeepCollectionEquality()
                .equals(other._parametros, _parametros) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.textoBotao, textoBotao) ||
                other.textoBotao == textoBotao));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tipo, rota,
      const DeepCollectionEquality().hash(_parametros), url, textoBotao);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationActionModelImplCopyWith<_$NotificationActionModelImpl>
      get copyWith => __$$NotificationActionModelImplCopyWithImpl<
          _$NotificationActionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationActionModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationActionModel extends NotificationActionModel {
  const factory _NotificationActionModel(
          {required final String tipo,
          final String? rota,
          final Map<String, dynamic>? parametros,
          final String? url,
          @JsonKey(name: 'texto_botao') final String? textoBotao}) =
      _$NotificationActionModelImpl;
  const _NotificationActionModel._() : super._();

  factory _NotificationActionModel.fromJson(Map<String, dynamic> json) =
      _$NotificationActionModelImpl.fromJson;

  @override
  String get tipo;
  @override
  String? get rota;
  @override
  Map<String, dynamic>? get parametros;
  @override
  String? get url;
  @override
  @JsonKey(name: 'texto_botao')
  String? get textoBotao;
  @override
  @JsonKey(ignore: true)
  _$$NotificationActionModelImplCopyWith<_$NotificationActionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
