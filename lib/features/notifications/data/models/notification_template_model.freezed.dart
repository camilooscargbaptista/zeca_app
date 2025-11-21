// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationTemplateModel _$NotificationTemplateModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationTemplateModel {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get mensagem => throw _privateConstructorUsedError;
  @JsonKey(name: 'prioridade')
  String get prioridade => throw _privateConstructorUsedError;
  @JsonKey(name: 'variaveis')
  Map<String, String> get variaveis => throw _privateConstructorUsedError;
  bool get ativo => throw _privateConstructorUsedError;
  @JsonKey(name: 'criado_em')
  DateTime get criadoEm => throw _privateConstructorUsedError;
  @JsonKey(name: 'atualizado_em')
  DateTime? get atualizadoEm => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationTemplateModelCopyWith<NotificationTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationTemplateModelCopyWith<$Res> {
  factory $NotificationTemplateModelCopyWith(NotificationTemplateModel value,
          $Res Function(NotificationTemplateModel) then) =
      _$NotificationTemplateModelCopyWithImpl<$Res, NotificationTemplateModel>;
  @useResult
  $Res call(
      {String id,
      String nome,
      String tipo,
      String titulo,
      String mensagem,
      @JsonKey(name: 'prioridade') String prioridade,
      @JsonKey(name: 'variaveis') Map<String, String> variaveis,
      bool ativo,
      @JsonKey(name: 'criado_em') DateTime criadoEm,
      @JsonKey(name: 'atualizado_em') DateTime? atualizadoEm});
}

/// @nodoc
class _$NotificationTemplateModelCopyWithImpl<$Res,
        $Val extends NotificationTemplateModel>
    implements $NotificationTemplateModelCopyWith<$Res> {
  _$NotificationTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? tipo = null,
    Object? titulo = null,
    Object? mensagem = null,
    Object? prioridade = null,
    Object? variaveis = null,
    Object? ativo = null,
    Object? criadoEm = null,
    Object? atualizadoEm = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      mensagem: null == mensagem
          ? _value.mensagem
          : mensagem // ignore: cast_nullable_to_non_nullable
              as String,
      prioridade: null == prioridade
          ? _value.prioridade
          : prioridade // ignore: cast_nullable_to_non_nullable
              as String,
      variaveis: null == variaveis
          ? _value.variaveis
          : variaveis // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      ativo: null == ativo
          ? _value.ativo
          : ativo // ignore: cast_nullable_to_non_nullable
              as bool,
      criadoEm: null == criadoEm
          ? _value.criadoEm
          : criadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      atualizadoEm: freezed == atualizadoEm
          ? _value.atualizadoEm
          : atualizadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationTemplateModelImplCopyWith<$Res>
    implements $NotificationTemplateModelCopyWith<$Res> {
  factory _$$NotificationTemplateModelImplCopyWith(
          _$NotificationTemplateModelImpl value,
          $Res Function(_$NotificationTemplateModelImpl) then) =
      __$$NotificationTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nome,
      String tipo,
      String titulo,
      String mensagem,
      @JsonKey(name: 'prioridade') String prioridade,
      @JsonKey(name: 'variaveis') Map<String, String> variaveis,
      bool ativo,
      @JsonKey(name: 'criado_em') DateTime criadoEm,
      @JsonKey(name: 'atualizado_em') DateTime? atualizadoEm});
}

/// @nodoc
class __$$NotificationTemplateModelImplCopyWithImpl<$Res>
    extends _$NotificationTemplateModelCopyWithImpl<$Res,
        _$NotificationTemplateModelImpl>
    implements _$$NotificationTemplateModelImplCopyWith<$Res> {
  __$$NotificationTemplateModelImplCopyWithImpl(
      _$NotificationTemplateModelImpl _value,
      $Res Function(_$NotificationTemplateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? tipo = null,
    Object? titulo = null,
    Object? mensagem = null,
    Object? prioridade = null,
    Object? variaveis = null,
    Object? ativo = null,
    Object? criadoEm = null,
    Object? atualizadoEm = freezed,
  }) {
    return _then(_$NotificationTemplateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      mensagem: null == mensagem
          ? _value.mensagem
          : mensagem // ignore: cast_nullable_to_non_nullable
              as String,
      prioridade: null == prioridade
          ? _value.prioridade
          : prioridade // ignore: cast_nullable_to_non_nullable
              as String,
      variaveis: null == variaveis
          ? _value._variaveis
          : variaveis // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      ativo: null == ativo
          ? _value.ativo
          : ativo // ignore: cast_nullable_to_non_nullable
              as bool,
      criadoEm: null == criadoEm
          ? _value.criadoEm
          : criadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      atualizadoEm: freezed == atualizadoEm
          ? _value.atualizadoEm
          : atualizadoEm // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationTemplateModelImpl extends _NotificationTemplateModel {
  const _$NotificationTemplateModelImpl(
      {required this.id,
      required this.nome,
      required this.tipo,
      required this.titulo,
      required this.mensagem,
      @JsonKey(name: 'prioridade') required this.prioridade,
      @JsonKey(name: 'variaveis') required final Map<String, String> variaveis,
      required this.ativo,
      @JsonKey(name: 'criado_em') required this.criadoEm,
      @JsonKey(name: 'atualizado_em') this.atualizadoEm})
      : _variaveis = variaveis,
        super._();

  factory _$NotificationTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationTemplateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final String tipo;
  @override
  final String titulo;
  @override
  final String mensagem;
  @override
  @JsonKey(name: 'prioridade')
  final String prioridade;
  final Map<String, String> _variaveis;
  @override
  @JsonKey(name: 'variaveis')
  Map<String, String> get variaveis {
    if (_variaveis is EqualUnmodifiableMapView) return _variaveis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_variaveis);
  }

  @override
  final bool ativo;
  @override
  @JsonKey(name: 'criado_em')
  final DateTime criadoEm;
  @override
  @JsonKey(name: 'atualizado_em')
  final DateTime? atualizadoEm;

  @override
  String toString() {
    return 'NotificationTemplateModel(id: $id, nome: $nome, tipo: $tipo, titulo: $titulo, mensagem: $mensagem, prioridade: $prioridade, variaveis: $variaveis, ativo: $ativo, criadoEm: $criadoEm, atualizadoEm: $atualizadoEm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationTemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.mensagem, mensagem) ||
                other.mensagem == mensagem) &&
            (identical(other.prioridade, prioridade) ||
                other.prioridade == prioridade) &&
            const DeepCollectionEquality()
                .equals(other._variaveis, _variaveis) &&
            (identical(other.ativo, ativo) || other.ativo == ativo) &&
            (identical(other.criadoEm, criadoEm) ||
                other.criadoEm == criadoEm) &&
            (identical(other.atualizadoEm, atualizadoEm) ||
                other.atualizadoEm == atualizadoEm));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nome,
      tipo,
      titulo,
      mensagem,
      prioridade,
      const DeepCollectionEquality().hash(_variaveis),
      ativo,
      criadoEm,
      atualizadoEm);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationTemplateModelImplCopyWith<_$NotificationTemplateModelImpl>
      get copyWith => __$$NotificationTemplateModelImplCopyWithImpl<
          _$NotificationTemplateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationTemplateModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationTemplateModel extends NotificationTemplateModel {
  const factory _NotificationTemplateModel(
      {required final String id,
      required final String nome,
      required final String tipo,
      required final String titulo,
      required final String mensagem,
      @JsonKey(name: 'prioridade') required final String prioridade,
      @JsonKey(name: 'variaveis') required final Map<String, String> variaveis,
      required final bool ativo,
      @JsonKey(name: 'criado_em') required final DateTime criadoEm,
      @JsonKey(name: 'atualizado_em')
      final DateTime? atualizadoEm}) = _$NotificationTemplateModelImpl;
  const _NotificationTemplateModel._() : super._();

  factory _NotificationTemplateModel.fromJson(Map<String, dynamic> json) =
      _$NotificationTemplateModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  String get tipo;
  @override
  String get titulo;
  @override
  String get mensagem;
  @override
  @JsonKey(name: 'prioridade')
  String get prioridade;
  @override
  @JsonKey(name: 'variaveis')
  Map<String, String> get variaveis;
  @override
  bool get ativo;
  @override
  @JsonKey(name: 'criado_em')
  DateTime get criadoEm;
  @override
  @JsonKey(name: 'atualizado_em')
  DateTime? get atualizadoEm;
  @override
  @JsonKey(ignore: true)
  _$$NotificationTemplateModelImplCopyWith<_$NotificationTemplateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
