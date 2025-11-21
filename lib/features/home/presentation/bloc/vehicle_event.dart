part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class SearchVehicle extends VehicleEvent {
  final String placa;

  const SearchVehicle(this.placa);

  @override
  List<Object?> get props => [placa];
}

class LoadUserInfo extends VehicleEvent {
  const LoadUserInfo();
}

class ClearVehicle extends VehicleEvent {
  const ClearVehicle();
}
