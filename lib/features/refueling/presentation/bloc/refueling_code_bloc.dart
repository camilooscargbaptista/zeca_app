import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/refueling_code_entity.dart';
import '../../domain/usecases/generate_refueling_code_usecase.dart';
import '../../domain/usecases/validate_refueling_code_usecase.dart';

part 'refueling_code_event.dart';
part 'refueling_code_state.dart';

@injectable
class RefuelingCodeBloc extends Bloc<RefuelingCodeEvent, RefuelingCodeState> {
  final GenerateRefuelingCodeUseCase _generateRefuelingCodeUseCase;
  final ValidateRefuelingCodeUseCase _validateRefuelingCodeUseCase;

  RefuelingCodeBloc({
    required GenerateRefuelingCodeUseCase generateRefuelingCodeUseCase,
    required ValidateRefuelingCodeUseCase validateRefuelingCodeUseCase,
  })  : _generateRefuelingCodeUseCase = generateRefuelingCodeUseCase,
        _validateRefuelingCodeUseCase = validateRefuelingCodeUseCase,
        super(const RefuelingCodeInitial()) {
    on<GenerateRefuelingCode>(_onGenerateRefuelingCode);
    on<ValidateRefuelingCode>(_onValidateRefuelingCode);
    on<ClearRefuelingCode>(_onClearRefuelingCode);
  }

  Future<void> _onGenerateRefuelingCode(
    GenerateRefuelingCode event,
    Emitter<RefuelingCodeState> emit,
  ) async {
    emit(const RefuelingCodeLoading());

    final result = await _generateRefuelingCodeUseCase(
      veiculoId: event.veiculoId,
      veiculoPlaca: event.veiculoPlaca,
      kmAtual: event.kmAtual,
      combustivel: event.combustivel,
      abastecerArla: event.abastecerArla,
      postoId: event.postoId,
      postoCnpj: event.postoCnpj,
      observacoes: event.observacoes,
    );

    result.fold(
      (failure) => emit(RefuelingCodeError(failure.message)),
      (refuelingCode) => emit(RefuelingCodeGenerated(refuelingCode)),
    );
  }

  Future<void> _onValidateRefuelingCode(
    ValidateRefuelingCode event,
    Emitter<RefuelingCodeState> emit,
  ) async {
    emit(const RefuelingCodeLoading());

    final result = await _validateRefuelingCodeUseCase(event.codigo);

    result.fold(
      (failure) => emit(RefuelingCodeError(failure.message)),
      (refuelingCode) => emit(RefuelingCodeValidated(refuelingCode)),
    );
  }

  void _onClearRefuelingCode(
    ClearRefuelingCode event,
    Emitter<RefuelingCodeState> emit,
  ) {
    emit(const RefuelingCodeInitial());
  }
}
