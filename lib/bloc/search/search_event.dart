abstract class SearchEvent {}

class SearchByCompanyEvent extends SearchEvent {
  final String company;
  SearchByCompanyEvent(this.company);
}

class SearchByDateEvent extends SearchEvent {
  final DateTime date;
  SearchByDateEvent(this.date);
}

class SearchByPlateEvent extends SearchEvent {
  final String plate;
  SearchByPlateEvent(this.plate);
}

class ClearSearchEvent extends SearchEvent {}