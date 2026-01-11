import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/fuel_station_entity.dart';
import '../../../domain/usecases/get_nearby_stations_usecase.dart';

part 'nearby_stations_event.dart';
part 'nearby_stations_state.dart';

@injectable
class NearbyStationsBloc extends Bloc<NearbyStationsEvent, NearbyStationsState> {
  final GetNearbyStationsUseCase _getNearbyStationsUseCase;

  NearbyStationsBloc(this._getNearbyStationsUseCase) : super(NearbyStationsInitial()) {
    on<LoadNearbyStations>(_onLoadNearbyStations);
  }

  Future<void> _onLoadNearbyStations(
    LoadNearbyStations event,
    Emitter<NearbyStationsState> emit,
  ) async {
    emit(NearbyStationsLoading());

    final result = await _getNearbyStationsUseCase(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      combustivel: event.combustivel,
      conveniado: event.conveniado,
    );

    result.fold(
      (failure) => emit(NearbyStationsError(failure.message)),
      (stations) {
        if (stations.isEmpty) {
          emit(NearbyStationsEmpty());
        } else {
          emit(NearbyStationsLoaded(
            stations: stations,
            total: stations.length,
            radiusKm: event.radius,
          ));
        }
      },
    );
  }
}
