import 'vehicle.dart';
import 'engine.dart';
import 'enums.dart';

class Car extends Vehicle {
  int _chairNum = 0;
  bool _isFurnitureLeather = false;

  Car() : super();

  Car.full(
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
    this._chairNum,
    this._isFurnitureLeather,
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

  int get chairNum => _chairNum;
  bool get isFurnitureLeather => _isFurnitureLeather;

  set chairNum(int v) => _chairNum = v;
  set isFurnitureLeather(bool v) => _isFurnitureLeather = v;

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base.addAll({
      'chairNum': _chairNum,
      'isFurnitureLeather': _isFurnitureLeather,
    });
    return base;
  }

  factory Car.fromJson(Map<String, dynamic> json) => Car.full(
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
        json['chairNum'],
        json['isFurnitureLeather'],
      );
}