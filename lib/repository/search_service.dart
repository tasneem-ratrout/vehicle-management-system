import '../models/automobile.dart';
import 'vehicle_repository.dart';

class SearchService {
  final VehicleRepository repository;

  SearchService(this.repository);

  List<Automobile> searchByCompany(String company) {
    return repository
        .getAllVehicles()
        .where(
          (v) => v.manufactureCompany.toLowerCase().contains(company.toLowerCase()),
        )
        .toList();
  }

  List<Automobile> searchByPlate(String plate) {
    return repository
        .getAllVehicles()
        .where((v) => v.plateNum.toString().contains(plate))
        .toList();
  }

  List<Automobile> searchByDate(DateTime date) {
    return repository.getAllVehicles().where((v) {
      final d = v.manufactureDate;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }
}