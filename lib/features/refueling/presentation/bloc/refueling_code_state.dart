part of 'refueling_code_bloc.dart';

abstract class RefuelingCodeState extends Equatable {
  const RefuelingCodeState();

  @override
  List<Object?> get props => [];
}

class RefuelingCodeInitial extends RefuelingCodeState {
  const RefuelingCodeInitial();
}

class RefuelingCodeLoading extends RefuelingCodeState {
  const RefuelingCodeLoading();
}

class RefuelingCodeGenerated extends RefuelingCodeState {
  final RefuelingCodeEntity refuelingCode;

  const RefuelingCodeGenerated(this.refuelingCode);

  @override
  List<Object?> get props => [refuelingCode];
}

class RefuelingCodeValidated extends RefuelingCodeState {
  final RefuelingCodeEntity refuelingCode;

  const RefuelingCodeValidated(this.refuelingCode);

  @override
  List<Object?> get props => [refuelingCode];
}

class RefuelingCodeError extends RefuelingCodeState {
  final String message;

  const RefuelingCodeError(this.message);

  @override
  List<Object?> get props => [message];
}
