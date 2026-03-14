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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VehicleBloc', () {
    late VehicleRepository repository;
    late VehicleBloc bloc;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = VehicleRepository();
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