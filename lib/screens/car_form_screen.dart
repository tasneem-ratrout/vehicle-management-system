import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/engine.dart';
import '../models/enums.dart';

class CarFormScreen extends StatefulWidget {
  final Car? editCar;
  const CarFormScreen({super.key, this.editCar});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _bodySerialCtrl = TextEditingController();

  GearType _gearType = GearType.normal;

  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();

  final _chairNumCtrl = TextEditingController();
  bool _leather = false;

  final _engManufactureCtrl = TextEditingController();
  final _engModelCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _cylindersCtrl = TextEditingController();
  FuelType _fuelType = FuelType.gasoline;

  DateTime _manufactureDate = DateTime.now();
  DateTime _engineDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final c = widget.editCar;
    if (c != null) {
      _companyCtrl.text = c.manufactureCompany;
      _modelCtrl.text = c.model;
      _plateCtrl.text = c.plateNum.toString();
      _bodySerialCtrl.text = c.bodySerialNum.toString();
      _gearType = c.gearType;

      _lengthCtrl.text = c.length.toString();
      _widthCtrl.text = c.width.toString();
      _colorCtrl.text = c.color;

      _chairNumCtrl.text = c.chairNum.toString();
      _leather = c.isFurnitureLeather;

      _manufactureDate = c.manufactureDate;

      _engManufactureCtrl.text = c.engine.manufacture;
      _engModelCtrl.text = c.engine.model;
      _capacityCtrl.text = c.engine.capacity.toString();
      _cylindersCtrl.text = c.engine.cylinders.toString();
      _fuelType = c.engine.fuelType;
      _engineDate = c.engine.manufactureDate;
    }
  }

  Future<void> _pickDate(bool isEngine) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isEngine ? _engineDate : _manufactureDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isEngine) {
          _engineDate = picked;
        } else {
          _manufactureDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _modelCtrl.dispose();
    _plateCtrl.dispose();
    _bodySerialCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _colorCtrl.dispose();
    _chairNumCtrl.dispose();
    _engManufactureCtrl.dispose();
    _engModelCtrl.dispose();
    _capacityCtrl.dispose();
    _cylindersCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editCar != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Car" : "Add Car")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyCtrl,
                decoration:
                    const InputDecoration(labelText: "Manufacture Company"),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              TextFormField(
                controller: _modelCtrl,
                decoration: const InputDecoration(labelText: "Car Model"),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Manufacture Date: ${_manufactureDate.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(false),
                    child: const Text("Pick"),
                  ),
                ],
              ),
              TextFormField(
                controller: _plateCtrl,
                decoration: const InputDecoration(labelText: "Plate Number (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              TextFormField(
                controller: _bodySerialCtrl,
                decoration:
                    const InputDecoration(labelText: "Body Serial Number (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              DropdownButtonFormField<GearType>(
                value: _gearType,
                items: GearType.values
                    .map((g) => DropdownMenuItem(value: g, child: Text(g.name)))
                    .toList(),
                onChanged: (v) => setState(() => _gearType = v!),
                decoration: const InputDecoration(labelText: "Gear Type"),
              ),
              const Divider(height: 28),

              // Vehicle
              TextFormField(
                controller: _lengthCtrl,
                decoration: const InputDecoration(labelText: "Length (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              TextFormField(
                controller: _widthCtrl,
                decoration: const InputDecoration(labelText: "Width (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              TextFormField(
                controller: _colorCtrl,
                decoration: const InputDecoration(labelText: "Color"),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              const Divider(height: 28),

              // Car fields
              TextFormField(
                controller: _chairNumCtrl,
                decoration: const InputDecoration(labelText: "Chair Number (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              SwitchListTile(
                title: const Text("Is Furniture Leather?"),
                value: _leather,
                onChanged: (v) => setState(() => _leather = v),
              ),
              const Divider(height: 28),

              // Engine
              TextFormField(
                controller: _engManufactureCtrl,
                decoration: const InputDecoration(labelText: "Engine Manufacture"),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Engine Date: ${_engineDate.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(true),
                    child: const Text("Pick"),
                  ),
                ],
              ),
              TextFormField(
                controller: _engModelCtrl,
                decoration: const InputDecoration(labelText: "Engine Model"),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              TextFormField(
                controller: _capacityCtrl,
                decoration: const InputDecoration(labelText: "Capacity (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              TextFormField(
                controller: _cylindersCtrl,
                decoration: const InputDecoration(labelText: "Cylinders (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              DropdownButtonFormField<FuelType>(
                value: _fuelType,
                items: FuelType.values
                    .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                    .toList(),
                onChanged: (v) => setState(() => _fuelType = v!),
                decoration: const InputDecoration(labelText: "Fuel Type"),
              ),
              const SizedBox(height: 18),

              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  final car = Car.full(
                    _companyCtrl.text.trim(),
                    _manufactureDate,
                    _modelCtrl.text.trim(),
                    Engine.full(
                      _engManufactureCtrl.text.trim(),
                      _engineDate,
                      _engModelCtrl.text.trim(),
                      int.parse(_capacityCtrl.text),
                      int.parse(_cylindersCtrl.text),
                      _fuelType,
                    ),
                    int.parse(_plateCtrl.text),
                    _gearType,
                    int.parse(_bodySerialCtrl.text),
                    int.parse(_lengthCtrl.text),
                    int.parse(_widthCtrl.text),
                    _colorCtrl.text.trim(),
                    int.parse(_chairNumCtrl.text),
                    _leather,
                  );

                  Navigator.pop(context, car);
                },
                child: Text(isEdit ? "Save Changes" : "Save Car"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}