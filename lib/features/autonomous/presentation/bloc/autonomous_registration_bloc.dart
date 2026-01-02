import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/autonomous_repository_impl.dart';
import '../../data/models/register_autonomous_model.dart';

part 'autonomous_registration_bloc.freezed.dart';

// Events
@freezed
class AutonomousRegistrationEvent with _$AutonomousRegistrationEvent {
  const factory AutonomousRegistrationEvent.loadTerms() = _LoadTerms;
  const factory AutonomousRegistrationEvent.checkCpf(String cpf) = _CheckCpf;
  const factory AutonomousRegistrationEvent.register({
    required String name,
    required String cpf,
    required String phone,
    String? birthDate,
    String? email,
    required String password,
    required bool termsAccepted,
    String? termsVersion,
  }) = _Register;
  const factory AutonomousRegistrationEvent.reset() = _Reset;
}

// State
@freezed
class AutonomousRegistrationState with _$AutonomousRegistrationState {
  const factory AutonomousRegistrationState.initial() = _Initial;
  const factory AutonomousRegistrationState.loading() = _Loading;
  const factory AutonomousRegistrationState.termsLoaded(TermsVersionModel? terms) = _TermsLoaded;
  const factory AutonomousRegistrationState.cpfChecked({required bool exists}) = _CpfChecked;
  const factory AutonomousRegistrationState.success(RegisterAutonomousResponse response) = _Success;
  const factory AutonomousRegistrationState.error(String message) = _Error;
}

// Bloc
@injectable
class AutonomousRegistrationBloc extends Bloc<AutonomousRegistrationEvent, AutonomousRegistrationState> {
  final AutonomousRepository _repository;

  AutonomousRegistrationBloc(this._repository) : super(const AutonomousRegistrationState.initial()) {
    on<_LoadTerms>(_onLoadTerms);
    on<_CheckCpf>(_onCheckCpf);
    on<_Register>(_onRegister);
    on<_Reset>(_onReset);
  }

  Future<void> _onLoadTerms(_LoadTerms event, Emitter<AutonomousRegistrationState> emit) async {
    emit(const AutonomousRegistrationState.loading());
    
    final result = await _repository.getTerms();
    result.fold(
      (failure) => emit(AutonomousRegistrationState.error(failure.message)),
      (terms) => emit(AutonomousRegistrationState.termsLoaded(terms)),
    );
  }

  Future<void> _onCheckCpf(_CheckCpf event, Emitter<AutonomousRegistrationState> emit) async {
    emit(const AutonomousRegistrationState.loading());
    
    final result = await _repository.checkCpfExists(event.cpf);
    result.fold(
      (failure) => emit(AutonomousRegistrationState.error(failure.message)),
      (exists) => emit(AutonomousRegistrationState.cpfChecked(exists: exists)),
    );
  }

  Future<void> _onRegister(_Register event, Emitter<AutonomousRegistrationState> emit) async {
    emit(const AutonomousRegistrationState.loading());
    
    final request = RegisterAutonomousRequest(
      name: event.name,
      cpf: event.cpf,
      phone: event.phone,
      birthDate: event.birthDate,
      email: event.email,
      password: event.password,
      termsAccepted: event.termsAccepted,
      termsVersion: event.termsVersion,
    );
    
    final result = await _repository.register(request);
    result.fold(
      (failure) => emit(AutonomousRegistrationState.error(failure.message)),
      (response) => emit(AutonomousRegistrationState.success(response)),
    );
  }

  void _onReset(_Reset event, Emitter<AutonomousRegistrationState> emit) {
    emit(const AutonomousRegistrationState.initial());
  }
}
