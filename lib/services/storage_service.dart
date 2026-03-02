import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/car.dart';
import '../models/truck.dart';
import '../models/motorcycle.dart';

class StorageService {
  static const String carKey = 'car_list';
  static const String truckKey = 'truck_list';
  static const String motorcycleKey = 'motorcycle_list';

  static Future<void> saveData({
    required List<Car> cars,
    required List<Truck> trucks,
    required List<Motorcycle> motorcycles,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final carJson = jsonEncode(cars.map((c) => c.toJson()).toList());
    final truckJson = jsonEncode(trucks.map((t) => t.toJson()).toList());
    final motorcycleJson =
        jsonEncode(motorcycles.map((m) => m.toJson()).toList());

    await prefs.setString(carKey, carJson);
    await prefs.setString(truckKey, truckJson);
    await prefs.setString(motorcycleKey, motorcycleJson);
  }

  static Future<Map<String, dynamic>> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final carJson = prefs.getString(carKey);
    final truckJson = prefs.getString(truckKey);
    final motorcycleJson = prefs.getString(motorcycleKey);

    final List<Car> cars = carJson != null
        ? (jsonDecode(carJson) as List)
            .map((e) => Car.fromJson(e as Map<String, dynamic>))
            .toList()
        : [];

    final List<Truck> trucks = truckJson != null
        ? (jsonDecode(truckJson) as List)
            .map((e) => Truck.fromJson(e as Map<String, dynamic>))
            .toList()
        : [];

    final List<Motorcycle> motorcycles = motorcycleJson != null
        ? (jsonDecode(motorcycleJson) as List)
            .map((e) => Motorcycle.fromJson(e as Map<String, dynamic>))
            .toList()
        : [];

    return {
      'cars': cars,
      'trucks': trucks,
      'motorcycles': motorcycles,
    };
  }
}