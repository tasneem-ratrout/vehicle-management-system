import '../models/automobile.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';
import '../models/enums.dart';
import '../services/storage_service.dart';
import '../services/vehicle_api_service.dart';

class VehicleLoadResult {
  final bool loadedFromCache;

  const VehicleLoadResult({required this.loadedFromCache});
}

class VehicleRepository {
  VehicleRepository({VehicleApiService? apiService})
    : api = apiService ?? VehicleApiService();

  final VehicleApiService api;

  final List<Car> _cars = [];
  final List<Truck> _trucks = [];
  final List<Motorcycle> _motorcycles = [];

  List<Car> get cars => List.unmodifiable(_cars);
  List<Truck> get trucks => List.unmodifiable(_trucks);
  List<Motorcycle> get motorcycles => List.unmodifiable(_motorcycles);

  Future<VehicleLoadResult> loadVehicles() async {
    try {
      final data = await api.getAllVehiclesPaginated();
      _hydrateFromJson(data);
      await StorageService.saveRawVehicleCache(data);
      await persistLocalSnapshot();
      return const VehicleLoadResult(loadedFromCache: false);
    } on NetworkUnavailableException {
      final fallback = await StorageService.loadRawVehicleCache();
      if (fallback.isNotEmpty) {
        _hydrateFromJson(fallback);
        return const VehicleLoadResult(loadedFromCache: true);
      }
      rethrow;
    } on ApiTimeoutException {
      final fallback = await StorageService.loadRawVehicleCache();
      if (fallback.isNotEmpty) {
        _hydrateFromJson(fallback);
        return const VehicleLoadResult(loadedFromCache: true);
      }
      rethrow;
    }
  }

  Future<void> addVehicle(Automobile vehicle) async {
    final created = await api.addVehicle({
      ...vehicle.toJson(),
      "type": vehicle.runtimeType.toString().toLowerCase(),
    });

    if (created['id'] != null) {
      vehicle.id = created['id'].toString();
    }

    if (vehicle is Car) {
      _cars.add(vehicle);
    } else if (vehicle is Truck) {
      _trucks.add(vehicle);
    } else if (vehicle is Motorcycle) {
      _motorcycles.add(vehicle);
    }

    await persistLocalSnapshot();
  }

  Future<void> insertVehicleAt(int index, Automobile vehicle) async {
    final created = await api.addVehicle({
      ...vehicle.toJson(),
      "type": vehicle.runtimeType.toString().toLowerCase(),
    });

    if (created['id'] != null) {
      vehicle.id = created['id'].toString();
    }

    if (vehicle is Car) {
      _cars.insert(index, vehicle);
    } else if (vehicle is Truck) {
      _trucks.insert(index, vehicle);
    } else if (vehicle is Motorcycle) {
      _motorcycles.insert(index, vehicle);
    }

    await persistLocalSnapshot();
  }

  Future<void> updateVehicle(Automobile updated) async {
    await api.updateVehicle(updated.id, {
      ...updated.toJson(),
      'type': updated.runtimeType.toString().toLowerCase(),
    });

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

    await persistLocalSnapshot();
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

    await persistLocalSnapshot();
  }

  List<Automobile> getAllVehicles() {
    return [..._cars, ..._trucks, ..._motorcycles];
  }

  Future<void> persistLocalSnapshot() async {
    await StorageService.saveData(
      cars: _cars,
      trucks: _trucks,
      motorcycles: _motorcycles,
    );

    final allJson = [
      ..._cars.map((e) => {...e.toJson(), 'type': 'car'}),
      ..._trucks.map((e) => {...e.toJson(), 'type': 'truck'}),
      ..._motorcycles.map((e) => {...e.toJson(), 'type': 'motorcycle'}),
    ];

    await StorageService.saveRawVehicleCache(allJson);
  }

  void _hydrateFromJson(List<Map<String, dynamic>> data) {
    _cars.clear();
    _trucks.clear();
    _motorcycles.clear();

    for (final item in data) {
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
  }
}
