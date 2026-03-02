import '../models/car.dart';
import '../models/truck.dart';
import '../models/motorcycle.dart';

String printCar(Car c) {
  return """
--- CAR ---
Company: ${c.manufactureCompany}
Manufacture Date: ${_d(c.manufactureDate)}
Model: ${c.model}
Plate Number: ${c.plateNum}
Gear Type: ${c.gearType.name}
Body Serial Num: ${c.bodySerialNum}

Vehicle:
Length: ${c.length}
Width: ${c.width}
Color: ${c.color}

Car:
Chairs: ${c.chairNum}
Leather: ${c.isFurnitureLeather}

Engine:
Manufacture: ${c.engine.manufacture}
Date: ${_d(c.engine.manufactureDate)}
Model: ${c.engine.model}
Capacity: ${c.engine.capacity}
Cylinders: ${c.engine.cylinders}
Fuel Type: ${c.engine.fuelType.name}
""";
}

String printTruck(Truck t) {
  return """
--- TRUCK ---
Company: ${t.manufactureCompany}
Manufacture Date: ${_d(t.manufactureDate)}
Model: ${t.model}
Plate Number: ${t.plateNum}
Gear Type: ${t.gearType.name}
Body Serial Num: ${t.bodySerialNum}

Vehicle:
Length: ${t.length}
Width: ${t.width}
Color: ${t.color}

Truck:
Free Weight: ${t.freeWeight}
Full Weight: ${t.fullWeight}

Engine:
Manufacture: ${t.engine.manufacture}
Date: ${_d(t.engine.manufactureDate)}
Model: ${t.engine.model}
Capacity: ${t.engine.capacity}
Cylinders: ${t.engine.cylinders}
Fuel Type: ${t.engine.fuelType.name}
""";
}

String printMotorcycle(Motorcycle m) {
  return """
--- MOTORCYCLE ---
Company: ${m.manufactureCompany}
Manufacture Date: ${_d(m.manufactureDate)}
Model: ${m.model}
Plate Number: ${m.plateNum}
Gear Type: ${m.gearType.name}
Body Serial Num: ${m.bodySerialNum}

Motorcycle:
Tier Diameter: ${m.tierDiameter}
Length: ${m.length}

Engine:
Manufacture: ${m.engine.manufacture}
Date: ${_d(m.engine.manufactureDate)}
Model: ${m.engine.model}
Capacity: ${m.engine.capacity}
Cylinders: ${m.engine.cylinders}
Fuel Type: ${m.engine.fuelType.name}
""";
}

String printAll({
  required List<Car> cars,
  required List<Truck> trucks,
  required List<Motorcycle> motorcycles,
}) {
  final b = StringBuffer();

  b.writeln("===== ALL VEHICLES =====\n");

  b.writeln("===== CARS (${cars.length}) =====");
  for (final c in cars) {
    b.writeln(printCar(c));
  }

  b.writeln("\n===== TRUCKS (${trucks.length}) =====");
  for (final t in trucks) {
    b.writeln(printTruck(t));
  }

  b.writeln("\n===== MOTORCYCLES (${motorcycles.length}) =====");
  for (final m in motorcycles) {
    b.writeln(printMotorcycle(m));
  }

  return b.toString();
}

String _d(DateTime dt) => dt.toLocal().toString().split(' ')[0];