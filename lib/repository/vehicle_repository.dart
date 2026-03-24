import '../models/automobile.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';
import '../models/enums.dart';
import '../services/storage_service.dart';
import '../services/vehicle_api_service.dart';

class VehicleRepository {
  final VehicleApiService api = VehicleApiService();

  final List<Car> _cars = [];
  final List<Truck> _trucks = [];
  final List<Motorcycle> _motorcycles = [];

  List<Car> get cars => List.unmodifiable(_cars);
  List<Truck> get trucks => List.unmodifiable(_trucks);
  List<Motorcycle> get motorcycles => List.unmodifiable(_motorcycles);

  Future<void> loadVehicles() async {
    try {
      final data = await api.getVehicles();

      _cars.clear();
      _trucks.clear();
      _motorcycles.clear();

      for (var item in data) {
        switch (item['type']) {
          case 'car':
            _cars.add(Car.fromJson(item));
            break;
          case 'truck':
            _trucks.add(Truck.fromJson(item));
            break;
          case 'motorcycle':
            _motorcycles.add(Motorcycle.fromJson(item));
            break;
        }
      }

      await StorageService.saveData(
        cars: _cars,
        trucks: _trucks,
        motorcycles: _motorcycles,
      );
    } catch (e) {
      // 🔥 OFFLINE FALLBACK
      final local = await StorageService.loadData();

      _cars
        ..clear()
        ..addAll(local['cars']);

      _trucks
        ..clear()
        ..addAll(local['trucks']);

      _motorcycles
        ..clear()
        ..addAll(local['motorcycles']);
    }
  }

  Future<void> addVehicle(Automobile vehicle) async {
    await api.addVehicle({
      ...vehicle.toJson(),
      "type": vehicle.runtimeType.toString().toLowerCase(),
    });

    if (vehicle is Car) {
      _cars.add(vehicle);
    } else if (vehicle is Truck) {
      _trucks.add(vehicle);
    } else if (vehicle is Motorcycle) {
      _motorcycles.add(vehicle);
    }
  }

  Future<void> insertVehicleAt(int index, Automobile vehicle) async {
    await addVehicle(vehicle);

    if (vehicle is Car) {
      _cars.insert(index, vehicle);
    } else if (vehicle is Truck) {
      _trucks.insert(index, vehicle);
    } else if (vehicle is Motorcycle) {
      _motorcycles.insert(index, vehicle);
    }
  }

  Future<void> updateVehicle(Automobile updated) async {
    await api.updateVehicle(updated.id, updated.toJson());

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

  Future<void> deleteVehicle(String id, VehicleType type) async {
    await api.deleteVehicle(id);

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