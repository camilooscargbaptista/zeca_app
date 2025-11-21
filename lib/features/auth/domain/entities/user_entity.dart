import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String nome;
  final String cpf;
  final String empresaId;
  final String empresaNome;
  final String? email;
  final String? telefone;
  final DateTime? ultimoLogin;
  
  const UserEntity({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.empresaId,
    required this.empresaNome,
    this.email,
    this.telefone,
    this.ultimoLogin,
  });
  
  @override
  List<Object?> get props => [
    id,
    nome,
    cpf,
    empresaId,
    empresaNome,
    email,
    telefone,
    ultimoLogin,
  ];
}
