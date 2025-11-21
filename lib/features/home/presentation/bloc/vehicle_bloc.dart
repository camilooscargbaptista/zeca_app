import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/usecases/search_vehicle_usecase.dart';
import '../../domain/usecases/get_nearby_stations_usecase.dart';
import '../../domain/usecases/validate_station_usecase.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

@injectable
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final SearchVehicleUseCase _searchVehicleUseCase;
  final GetNearbyStationsUseCase _getNearbyStationsUseCase;
  final ValidateStationUseCase _validateStationUseCase;

  VehicleBloc({
    required SearchVehicleUseCase searchVehicleUseCase,
    required GetNearbyStationsUseCase getNearbyStationsUseCase,
    required ValidateStationUseCase validateStationUseCase,
  })  : _searchVehicleUseCase = searchVehicleUseCase,
        _getNearbyStationsUseCase = getNearbyStationsUseCase,
        _validateStationUseCase = validateStationUseCase,
        super(const VehicleInitial()) {
    on<SearchVehicle>(_onSearchVehicle);
    on<LoadUserInfo>(_onLoadUserInfo);
    on<ClearVehicle>(_onClearVehicle);
  }

  Future<void> _onSearchVehicle(
    SearchVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    emit(const VehicleLoading());

    final result = await _searchVehicleUseCase(event.placa);

    result.fold(
      (failure) => emit(VehicleError(failure.message)),
      (vehicle) => emit(VehicleLoaded(vehicle)),
    );
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfo event,
    Emitter<VehicleState> emit,
  ) async {
    // TODO: Implementar carregamento de informações do usuário
    emit(const VehicleInitial());
  }

  Future<void> _onClearVehicle(
    ClearVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    emit(const VehicleInitial());
  }
}
