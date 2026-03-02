import 'vehicle.dart';
import 'engine.dart';
import 'enums.dart';

class Truck extends Vehicle {
  int _freeWeight = 0;
  int _fullWeight = 0;

  Truck() : super();

  Truck.full(
    String manufactureCompany,
    DateTime manufactureDate,
    String model,
    Engine engine,
    int plateNum,
    GearType gearType,
    int bodySerialNum,
    int length,
    int width,
    String color,
    this._freeWeight,
    this._fullWeight,
  ) : super.full(
          manufactureCompany,
          manufactureDate,
          model,
          engine,
          plateNum,
          gearType,
          bodySerialNum,
          length,
          width,
          color,
        );

  int get freeWeight => _freeWeight;
  int get fullWeight => _fullWeight;

  set freeWeight(int v) => _freeWeight = v;
  set fullWeight(int v) => _fullWeight = v;

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base.addAll({'freeWeight': _freeWeight, 'fullWeight': _fullWeight});
    return base;
  }

  factory Truck.fromJson(Map<String, dynamic> json) => Truck.full(
        json['manufactureCompany'],
        DateTime.parse(json['manufactureDate']),
        json['model'],
        Engine.fromJson(json['engine']),
        json['plateNum'],
        GearType.values.byName(json['gearType']),
        json['bodySerialNum'],
        json['length'],
        json['width'],
        json['color'],
        json['freeWeight'],
        json['fullWeight'],
      );
}