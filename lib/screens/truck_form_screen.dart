import 'package:flutter/material.dart';
import '../models/truck.dart';
import '../models/engine.dart';
import '../models/enums.dart';

class TruckFormScreen extends StatefulWidget {
  final Truck? editTruck;
  const TruckFormScreen({super.key, this.editTruck});

  @override
  State<TruckFormScreen> createState() => _TruckFormScreenState();
}

class _TruckFormScreenState extends State<TruckFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _bodySerialCtrl = TextEditingController();
  GearType _gearType = GearType.normal;

  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();

  final _freeWCtrl = TextEditingController();
  final _fullWCtrl = TextEditingController();

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
    final t = widget.editTruck;
    if (t != null) {
      _companyCtrl.text = t.manufactureCompany;
      _modelCtrl.text = t.model;
      _plateCtrl.text = t.plateNum.toString();
      _bodySerialCtrl.text = t.bodySerialNum.toString();
      _gearType = t.gearType;

      _lengthCtrl.text = t.length.toString();
      _widthCtrl.text = t.width.toString();
      _colorCtrl.text = t.color;

      _freeWCtrl.text = t.freeWeight.toString();
      _fullWCtrl.text = t.fullWeight.toString();

      _manufactureDate = t.manufactureDate;

      _engManufactureCtrl.text = t.engine.manufacture;
      _engModelCtrl.text = t.engine.model;
      _capacityCtrl.text = t.engine.capacity.toString();
      _cylindersCtrl.text = t.engine.cylinders.toString();
      _fuelType = t.engine.fuelType;
      _engineDate = t.engine.manufactureDate;
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
        if (isEngine) _engineDate = picked;
        else _manufactureDate = picked;
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
    _freeWCtrl.dispose();
    _fullWCtrl.dispose();
    _engManufactureCtrl.dispose();
    _engModelCtrl.dispose();
    _capacityCtrl.dispose();
    _cylindersCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editTruck != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Truck" : "Add Truck")),
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
                decoration: const InputDecoration(labelText: "Truck Model"),
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

              TextFormField(
                controller: _freeWCtrl,
                decoration: const InputDecoration(labelText: "Free Weight (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              TextFormField(
                controller: _fullWCtrl,
                decoration: const InputDecoration(labelText: "Full Weight (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              const Divider(height: 28),

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

                  final truck = Truck.full(
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
                    int.parse(_freeWCtrl.text),
                    int.parse(_fullWCtrl.text),
                  );

                  Navigator.pop(context, truck);
                },
                child: Text(isEdit ? "Save Changes" : "Save Truck"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}