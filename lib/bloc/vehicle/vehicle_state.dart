import '../../models/car.dart';
import '../../models/motorcycle.dart';
import '../../models/truck.dart';

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Car> cars;
  final List<Truck> trucks;
  final List<Motorcycle> motorcycles;
  final bool loadedFromCache;

  VehicleLoaded({
    required this.cars,
    required this.trucks,
    required this.motorcycles,
    this.loadedFromCache = false,
  });
}

class NetworkUnavailableState extends VehicleState {}

class ServerErrorState extends VehicleState {}

class TimeoutState extends VehicleState {}

// Backward compatibility for existing UI checks.
class NetworkErrorState extends NetworkUnavailableState {}

class TimeoutErrorState extends TimeoutState {}
