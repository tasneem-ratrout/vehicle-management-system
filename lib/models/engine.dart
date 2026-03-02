import 'enums.dart';

class Engine {
  String _manufacture = '';
  DateTime _manufactureDate = DateTime.now();
  String _model = '';
  int _capacity = 0;
  int _cylinders = 0;
  FuelType _fuelType = FuelType.gasoline;

  Engine();

  Engine.full(
    this._manufacture,
    this._manufactureDate,
    this._model,
    this._capacity,
    this._cylinders,
    this._fuelType,
  );

  String get manufacture => _manufacture;
  DateTime get manufactureDate => _manufactureDate;
  String get model => _model;
  int get capacity => _capacity;
  int get cylinders => _cylinders;
  FuelType get fuelType => _fuelType;

  set manufacture(String v) => _manufacture = v;
  set manufactureDate(DateTime v) => _manufactureDate = v;
  set model(String v) => _model = v;
  set capacity(int v) => _capacity = v;
  set cylinders(int v) => _cylinders = v;
  set fuelType(FuelType v) => _fuelType = v;

  Map<String, dynamic> toJson() => {
        'manufacture': _manufacture,
        'manufactureDate': _manufactureDate.toIso8601String(),
        'model': _model,
        'capacity': _capacity,
        'cylinders': _cylinders,
        'fuelType': _fuelType.name,
      };

  factory Engine.fromJson(Map<String, dynamic> json) => Engine.full(
        json['manufacture'],
        DateTime.parse(json['manufactureDate']),
        json['model'],
        json['capacity'],
        json['cylinders'],
        FuelType.values.byName(json['fuelType']),
      );
}