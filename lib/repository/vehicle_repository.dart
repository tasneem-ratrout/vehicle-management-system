import '../models/automobile.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';
import '../models/enums.dart';
import '../services/storage_service.dart';

class VehicleRepository {
  final List<Car> _cars = [];
  final List<Truck> _trucks = [];
  final List<Motorcycle> _motorcycles = [];

  List<Car> get cars => List.unmodifiable(_cars);
  List<Truck> get trucks => List.unmodifiable(_trucks);
  List<Motorcycle> get motorcycles => List.unmodifiable(_motorcycles);

  Future<void> loadVehicles() async {
    final data = await StorageService.loadData();

    _cars
      ..clear()
      ..addAll(data['cars'] as List<Car>);

    _trucks
      ..clear()
      ..addAll(data['trucks'] as List<Truck>);

    _motorcycles
      ..clear()
      ..addAll(data['motorcycles'] as List<Motorcycle>);
  }

  Future<void> saveVehicles() async {
    await StorageService.saveData(
      cars: _cars,
      trucks: _trucks,
      motorcycles: _motorcycles,
    );
  }

  void addVehicle(Automobile vehicle) {
    if (vehicle is Car) {
      _cars.add(vehicle);
    } else if (vehicle is Truck) {
      _trucks.add(vehicle);
    } else if (vehicle is Motorcycle) {
      _motorcycles.add(vehicle);
    }
  }

  void insertVehicleAt(int index, Automobile vehicle) {
    if (vehicle is Car) {
      _cars.insert(index, vehicle);
    } else if (vehicle is Truck) {
      _trucks.insert(index, vehicle);
    } else if (vehicle is Motorcycle) {
      _motorcycles.insert(index, vehicle);
    }
  }

  void updateVehicle(Automobile updated) {
    if (updated is Car) {
      final i = _cars.indexWhere((e) => e.id == updated.id);
      if (i != -1) _cars[i] = updated;
    } else if (updated is Truck) {
      final i = _trucks.indexWhere((e) => e.id == updated.id);
      if (i != -1) _trucks[i] = updated;
    } else if (updated is Motorcycle) {
      final i = _motorcycles.indexWhere((e) => e.id == updated.id);
      if (i != -1) _motorcycles[i] = updated;
    }
  }

  void deleteVehicle(String id, VehicleType type) {
    switch (type) {
      case VehicleType.car:
        _cars.removeWhere((e) => e.id == id);
        break;
      case VehicleType.truck:
        _trucks.removeWhere((e) => e.id == id);
        break;
      case VehicleType.motorcycle:
        _motorcycles.removeWhere((e) => e.id == id);
        break;
    }
  }

  List<Automobile> getAllVehicles() {
    return [
      ..._cars,
      ..._trucks,
      ..._motorcycles,
    ];
  }
}