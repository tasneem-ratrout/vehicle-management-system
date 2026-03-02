import 'automobile.dart';
import 'engine.dart';
import 'enums.dart';

class Motorcycle extends Automobile {
  int _tierDiameter = 0; // as in task wording
  int _length = 0;

  Motorcycle() : super();

  Motorcycle.full(
    String manufactureCompany,
    DateTime manufactureDate,
    String model,
    Engine engine,
    int plateNum,
    GearType gearType,
    int bodySerialNum,
    this._tierDiameter,
    this._length,
  ) : super.full(
          manufactureCompany,
          manufactureDate,
          model,
          engine,
          plateNum,
          gearType,
          bodySerialNum,
        );

  int get tierDiameter => _tierDiameter;
  int get length => _length;

  set tierDiameter(int v) => _tierDiameter = v;
  set length(int v) => _length = v;

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base.addAll({'tierDiameter': _tierDiameter, 'length': _length});
    return base;
  }

  factory Motorcycle.fromJson(Map<String, dynamic> json) => Motorcycle.full(
        json['manufactureCompany'],
        DateTime.parse(json['manufactureDate']),
        json['model'],
        Engine.fromJson(json['engine']),
        json['plateNum'],
        GearType.values.byName(json['gearType']),
        json['bodySerialNum'],
        json['tierDiameter'],
        json['length'],
      );
}