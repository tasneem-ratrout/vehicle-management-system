import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/vehicle_repository.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;
  Timer? _timer;

  VehicleBloc(this.repository) : super(VehicleInitial()) {
    
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      add(LoadVehiclesEvent());
    });

    on<LoadVehiclesEvent>((event, emit) async {
      emit(VehicleLoading());
      try {
        await repository.loadVehicles();

        emit(VehicleLoaded(
          cars: repository.cars,
          trucks: repository.trucks,
          motorcycles: repository.motorcycles,
        ));
      } on TimeoutException {
        emit(VehicleError("Timeout Error"));
      } on TimeoutException {
  emit(TimeoutErrorState());
} catch (e) {
  emit(NetworkErrorState());
}
    });

    on<AddVehicleEvent>((event, emit) async {
      try {
        await repository.addVehicle(event.vehicle);

        emit(VehicleLoaded(
          cars: repository.cars,
          trucks: repository.trucks,
          motorcycles: repository.motorcycles,
        ));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<InsertVehicleAtEvent>((event, emit) async {
      try {
        await repository.insertVehicleAt(event.index, event.vehicle);

        emit(VehicleLoaded(
          cars: repository.cars,
          trucks: repository.trucks,
          motorcycles: repository.motorcycles,
        ));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<UpdateVehicleEvent>((event, emit) async {
      try {
        await repository.updateVehicle(event.updated);

        emit(VehicleLoaded(
          cars: repository.cars,
          trucks: repository.trucks,
          motorcycles: repository.motorcycles,
        ));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<DeleteVehicleEvent>((event, emit) async {
      try {
        await repository.deleteVehicle(event.id, event.type);

        emit(VehicleLoaded(
          cars: repository.cars,
          trucks: repository.trucks,
          motorcycles: repository.motorcycles,
        ));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}