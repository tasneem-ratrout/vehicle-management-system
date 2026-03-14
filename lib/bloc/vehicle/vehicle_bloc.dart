import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/vehicle_repository.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;

  VehicleBloc(this.repository) : super(VehicleInitial()) {
    on<LoadVehiclesEvent>((event, emit) async {
      emit(VehicleLoading());
      try {
        await repository.loadVehicles();
        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<AddVehicleEvent>((event, emit) {
      try {
        repository.addVehicle(event.vehicle);
        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<InsertVehicleAtEvent>((event, emit) {
      try {
        repository.insertVehicleAt(event.index, event.vehicle);
        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<UpdateVehicleEvent>((event, emit) {
      try {
        repository.updateVehicle(event.updated);
        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<DeleteVehicleEvent>((event, emit) {
      try {
        repository.deleteVehicle(event.id, event.type);
        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<SaveVehiclesEvent>((event, emit) async {
      try {
        await repository.saveVehicles();
        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });
  }
}