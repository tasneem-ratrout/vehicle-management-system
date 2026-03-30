import '../../models/car.dart';
import '../../models/motorcycle.dart';
import '../../models/truck.dart';

abstract class PersistenceEvent {}

class PersistSaveEvent extends PersistenceEvent {
  final List<Car> cars;
  final List<Truck> trucks;
  final List<Motorcycle> motorcycles;

  PersistSaveEvent({
    required this.cars,
    required this.trucks,
    required this.motorcycles,
  });
}

class PersistLoadEvent extends PersistenceEvent {}
