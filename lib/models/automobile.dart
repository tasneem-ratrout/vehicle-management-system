import 'engine.dart';
import 'enums.dart';

class Automobile {
  String _id = '';
  String _manufactureCompany = '';
  DateTime _manufactureDate = DateTime.now();
  String _model = '';
  Engine _engine = Engine();
  int _plateNum = 0;
  GearType _gearType = GearType.normal;
  int _bodySerialNum = 0;

  Automobile();

  Automobile.full(
    this._id,
    this._manufactureCompany,
    this._manufactureDate,
    this._model,
    this._engine,
    this._plateNum,
    this._gearType,
    this._bodySerialNum,
  );

  String get id => _id;
  String get manufactureCompany => _manufactureCompany;
  DateTime get manufactureDate => _manufactureDate;
  String get model => _model;
  Engine get engine => _engine;
  int get plateNum => _plateNum;
  GearType get gearType => _gearType;
  int get bodySerialNum => _bodySerialNum;

  set id(String v) => _id = v;
  set manufactureCompany(String v) => _manufactureCompany = v;
  set manufactureDate(DateTime v) => _manufactureDate = v;
  set model(String v) => _model = v;
  set engine(Engine v) => _engine = v;
  set plateNum(int v) => _plateNum = v;
  set gearType(GearType v) => _gearType = v;
  set bodySerialNum(int v) => _bodySerialNum = v;

  Map<String, dynamic> toJson() => {
        'id': _id,
        'manufactureCompany': _manufactureCompany,
        'manufactureDate': _manufactureDate.toIso8601String(),
        'model': _model,
        'engine': _engine.toJson(),
        'plateNum': _plateNum,
        'gearType': _gearType.name,
        'bodySerialNum': _bodySerialNum,
      };

  factory Automobile.fromJson(Map<String, dynamic> json) => Automobile.full(
        json['id'] ?? '',
        json['manufactureCompany'],
        DateTime.parse(json['manufactureDate']),
        json['model'],
        Engine.fromJson(json['engine']),
        json['plateNum'],
        GearType.values.byName(json['gearType']),
        json['bodySerialNum'],
      );
}