import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/api_service.dart';

// Events
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  
  @override
  List<Object?> get props => [];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final String cpf;
  
  const ForgotPasswordSubmitted(this.cpf);
  
  @override
  List<Object?> get props => [cpf];
}

class ForgotPasswordReset extends ForgotPasswordEvent {}

// States
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String cpf;
  final String message;
  
  const ForgotPasswordSuccess({required this.cpf, required this.message});
  
  @override
  List<Object?> get props => [cpf, message];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  
  const ForgotPasswordError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ApiService _apiService;
  
  ForgotPasswordBloc({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService(),
        super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
    on<ForgotPasswordReset>(_onReset);
  }
  
  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    
    final result = await _apiService.forgotPasswordByCpf(event.cpf);
    
    if (result['success'] == true) {
      emit(ForgotPasswordSuccess(
        cpf: event.cpf,
        message: result['message'] ?? 'Código enviado com sucesso',
      ));
    } else {
      emit(ForgotPasswordError(result['error'] ?? 'Erro ao enviar código'));
    }
  }
  
  void _onReset(
    ForgotPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(ForgotPasswordInitial());
  }
}
