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

  VehicleLoaded({
    required this.cars,
    required this.trucks,
    required this.motorcycles,
  });
}

class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);
}