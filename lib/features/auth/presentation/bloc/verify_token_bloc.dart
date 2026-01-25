import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/api_service.dart';

// Events
abstract class VerifyTokenEvent extends Equatable {
  const VerifyTokenEvent();
  
  @override
  List<Object?> get props => [];
}

class VerifyTokenSubmitted extends VerifyTokenEvent {
  final String cpf;
  final String token;
  
  const VerifyTokenSubmitted({required this.cpf, required this.token});
  
  @override
  List<Object?> get props => [cpf, token];
}

class VerifyTokenResendRequested extends VerifyTokenEvent {
  final String cpf;
  
  const VerifyTokenResendRequested(this.cpf);
  
  @override
  List<Object?> get props => [cpf];
}

class VerifyTokenTimerTick extends VerifyTokenEvent {
  final int remainingSeconds;
  
  const VerifyTokenTimerTick(this.remainingSeconds);
  
  @override
  List<Object?> get props => [remainingSeconds];
}

class VerifyTokenReset extends VerifyTokenEvent {}

// States
abstract class VerifyTokenState extends Equatable {
  final int remainingSeconds;
  
  const VerifyTokenState({this.remainingSeconds = 60});
  
  @override
  List<Object?> get props => [remainingSeconds];
}

class VerifyTokenInitial extends VerifyTokenState {
  const VerifyTokenInitial({super.remainingSeconds = 60});
}

class VerifyTokenLoading extends VerifyTokenState {
  const VerifyTokenLoading({super.remainingSeconds});
}

class VerifyTokenSuccess extends VerifyTokenState {
  final String cpf;
  final String token;
  
  const VerifyTokenSuccess({
    required this.cpf,
    required this.token,
    super.remainingSeconds,
  });
  
  @override
  List<Object?> get props => [cpf, token, remainingSeconds];
}

class VerifyTokenError extends VerifyTokenState {
  final String message;
  
  const VerifyTokenError(this.message, {super.remainingSeconds});
  
  @override
  List<Object?> get props => [message, remainingSeconds];
}

class VerifyTokenResending extends VerifyTokenState {
  const VerifyTokenResending({super.remainingSeconds});
}

// BLoC
class VerifyTokenBloc extends Bloc<VerifyTokenEvent, VerifyTokenState> {
  final ApiService _apiService;
  Timer? _timer;
  
  VerifyTokenBloc({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const VerifyTokenInitial()) {
    on<VerifyTokenSubmitted>(_onSubmitted);
    on<VerifyTokenResendRequested>(_onResendRequested);
    on<VerifyTokenTimerTick>(_onTimerTick);
    on<VerifyTokenReset>(_onReset);
    
    // Iniciar timer
    _startTimer();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = 60 - timer.tick;
      if (remaining >= 0) {
        add(VerifyTokenTimerTick(remaining));
      } else {
        timer.cancel();
      }
    });
  }
  
  Future<void> _onSubmitted(
    VerifyTokenSubmitted event,
    Emitter<VerifyTokenState> emit,
  ) async {
    emit(VerifyTokenLoading(remainingSeconds: state.remainingSeconds));
    
    final result = await _apiService.verifyResetToken(
      cpf: event.cpf,
      token: event.token,
    );
    
    if (result['success'] == true && result['valid'] == true) {
      emit(VerifyTokenSuccess(
        cpf: event.cpf,
        token: event.token,
        remainingSeconds: state.remainingSeconds,
      ));
    } else {
      emit(VerifyTokenError(
        result['error'] ?? 'Código inválido ou expirado',
        remainingSeconds: state.remainingSeconds,
      ));
    }
  }
  
  Future<void> _onResendRequested(
    VerifyTokenResendRequested event,
    Emitter<VerifyTokenState> emit,
  ) async {
    emit(VerifyTokenResending(remainingSeconds: state.remainingSeconds));
    
    await _apiService.forgotPasswordByCpf(event.cpf);
    
    // Reiniciar timer
    _startTimer();
    emit(const VerifyTokenInitial(remainingSeconds: 60));
  }
  
  void _onTimerTick(
    VerifyTokenTimerTick event,
    Emitter<VerifyTokenState> emit,
  ) {
    if (state is VerifyTokenInitial) {
      emit(VerifyTokenInitial(remainingSeconds: event.remainingSeconds));
    } else if (state is VerifyTokenError) {
      final errorState = state as VerifyTokenError;
      emit(VerifyTokenError(errorState.message, remainingSeconds: event.remainingSeconds));
    }
  }
  
  void _onReset(
    VerifyTokenReset event,
    Emitter<VerifyTokenState> emit,
  ) {
    _timer?.cancel();
    emit(const VerifyTokenInitial());
  }
  
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
