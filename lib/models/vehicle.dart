import 'automobile.dart';
import 'engine.dart';
import 'enums.dart';

class Vehicle extends Automobile {
  int _length = 0;
  int _width = 0;
  String _color = '';

  Vehicle() : super();

  Vehicle.full(
    String id,
    String manufactureCompany,
    DateTime manufactureDate,
    String model,
    Engine engine,
    int plateNum,
    GearType gearType,
    int bodySerialNum,
    this._length,
    this._width,
    this._color,
  ) : super.full(
          id,
          manufactureCompany,
          manufactureDate,
          model,
          engine,
          plateNum,
          gearType,
          bodySerialNum,
        );

  int get length => _length;
  int get width => _width;
  String get color => _color;

  set length(int v) => _length = v;
  set width(int v) => _width = v;
  set color(String v) => _color = v;

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base.addAll({
      'length': _length,
      'width': _width,
      'color': _color,
    });
    return base;
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle.full(
        json['id'] ?? '',
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
      );
}