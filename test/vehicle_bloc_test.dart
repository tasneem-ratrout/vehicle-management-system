import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vehicle_management/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_management/bloc/vehicle/vehicle_event.dart';
import 'package:vehicle_management/bloc/vehicle/vehicle_state.dart';
import 'package:vehicle_management/models/car.dart';
import 'package:vehicle_management/models/engine.dart';
import 'package:vehicle_management/models/enums.dart';
import 'package:vehicle_management/repository/vehicle_repository.dart';
import 'package:vehicle_management/services/vehicle_api_service.dart';

class FakeVehicleApiService extends VehicleApiService {
  FakeVehicleApiService();

  final List<Map<String, dynamic>> _store = [];
  int _id = 1;

  @override
  Future<List<Map<String, dynamic>>> getAllVehiclesPaginated({
    int pageSize = 20,
  }) async {
    return List<Map<String, dynamic>>.from(_store);
  }

  @override
  Future<Map<String, dynamic>> addVehicle(Map<String, dynamic> data) async {
    final copy = Map<String, dynamic>.from(data);
    copy['id'] = copy['id'].toString().isEmpty ? '${_id++}' : copy['id'];
    _store.add(copy);
    return copy;
  }

  @override
  Future<Map<String, dynamic>> updateVehicle(
    String id,
    Map<String, dynamic> data,
  ) async {
    final i = _store.indexWhere((e) => e['id'].toString() == id);
    final copy = Map<String, dynamic>.from(data)..['id'] = id;
    if (i != -1) {
      _store[i] = copy;
    }
    return copy;
  }

  @override
  Future<void> deleteVehicle(String id) async {
    _store.removeWhere((e) => e['id'].toString() == id);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VehicleBloc', () {
    late VehicleRepository repository;
    late VehicleBloc bloc;
    late FakeVehicleApiService api;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      api = FakeVehicleApiService();
      repository = VehicleRepository(apiService: api);
      bloc = VehicleBloc(repository);
    });

    Car buildCar() {
      return Car.full(
        '1',
        'Toyota',
        DateTime(2024, 1, 1),
        'Corolla',
        Engine.full(
          'Toyota',
          DateTime(2024, 1, 1),
          'E1',
          1600,
          4,
          FuelType.gasoline,
        ),
        123,
        GearType.automatic,
        999,
        10,
        5,
        'White',
        5,
        true,
      );
    }

    blocTest<VehicleBloc, VehicleState>(
      'emits loaded state with added car',
      build: () => bloc,
      act: (bloc) => bloc.add(AddVehicleEvent(buildCar())),
      expect: () => [
        isA<VehicleLoaded>().having((s) => s.cars.length, 'cars length', 1),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits loaded state with deleted car',
      build: () => bloc,
      act: (bloc) {
        bloc.add(AddVehicleEvent(buildCar()));
        bloc.add(DeleteVehicleEvent('1', VehicleType.car));
      },
      skip: 1,
      expect: () => [
        isA<VehicleLoaded>().having((s) => s.cars.length, 'cars length', 0),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'loaded state shape contains all three lists',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadVehiclesEvent()),
      expect: () => [
        isA<VehicleLoading>(),
        isA<VehicleLoaded>()
            .having((s) => s.cars, 'cars', isA<List>())
            .having((s) => s.trucks, 'trucks', isA<List>())
            .having((s) => s.motorcycles, 'motorcycles', isA<List>()),
      ],
    );
  });
}
