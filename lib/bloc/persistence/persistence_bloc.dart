import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';
import 'persistence_event.dart';
import 'persistence_state.dart';

class PersistenceBloc extends Bloc<PersistenceEvent, PersistenceState> {
  PersistenceBloc() : super(PersistenceIdle()) {
    on<PersistLoadEvent>((event, emit) async {
      try {
        final data = await StorageService.loadData();
        emit(PersistenceLoaded(data));
      } catch (e) {
        emit(PersistenceError(e.toString()));
      }
    });

    on<PersistSaveEvent>((event, emit) async {
      emit(PersistenceSaving());
      try {
        final data = await StorageService.loadData();
        emit(PersistenceLoaded(data));
      } catch (e) {
        emit(PersistenceError(e.toString()));
      }
    });
  }
}