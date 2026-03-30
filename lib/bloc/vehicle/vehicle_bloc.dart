import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/vehicle_repository.dart';
import '../../services/vehicle_api_service.dart';
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
        final result = await repository.loadVehicles();

        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
            loadedFromCache: result.loadedFromCache,
          ),
        );
      } on ApiTimeoutException {
        emit(TimeoutState());
      } on ApiServerException {
        emit(ServerErrorState());
      } on NetworkUnavailableException {
        emit(NetworkUnavailableState());
      } catch (_) {
        emit(ServerErrorState());
      }
    });

    on<AddVehicleEvent>((event, emit) async {
      try {
        await repository.addVehicle(event.vehicle);

        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(ServerErrorState());
      }
    });

    on<InsertVehicleAtEvent>((event, emit) async {
      try {
        await repository.insertVehicleAt(event.index, event.vehicle);

        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(ServerErrorState());
      }
    });

    on<UpdateVehicleEvent>((event, emit) async {
      try {
        await repository.updateVehicle(event.updated);

        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(ServerErrorState());
      }
    });

    on<DeleteVehicleEvent>((event, emit) async {
      try {
        await repository.deleteVehicle(event.id, event.type);

        emit(
          VehicleLoaded(
            cars: repository.cars,
            trucks: repository.trucks,
            motorcycles: repository.motorcycles,
          ),
        );
      } catch (e) {
        emit(ServerErrorState());
      }
    });

    on<SaveVehiclesEvent>((event, emit) async {
      try {
        await repository.persistLocalSnapshot();
      } catch (_) {
        // Non-blocking cache persistence.
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
