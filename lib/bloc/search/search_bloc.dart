import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/search_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService searchService;

  SearchBloc(this.searchService) : super(SearchInitial()) {
    on<SearchByCompanyEvent>((event, emit) {
      final results = searchService.searchByCompany(event.company);
      emit(results.isEmpty ? SearchEmpty() : SearchResults(results));
    });

    on<SearchByDateEvent>((event, emit) {
      final results = searchService.searchByDate(event.date);
      emit(results.isEmpty ? SearchEmpty() : SearchResults(results));
    });

    on<SearchByPlateEvent>((event, emit) {
      final results = searchService.searchByPlate(event.plate);
      emit(results.isEmpty ? SearchEmpty() : SearchResults(results));
    });

    on<ClearSearchEvent>((event, emit) {
      emit(SearchInitial());
    });
  }
}