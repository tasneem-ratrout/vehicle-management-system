import 'package:flutter/material.dart';
import '../models/motorcycle.dart';
import '../models/engine.dart';
import '../models/enums.dart';

class MotorcycleFormScreen extends StatefulWidget {
  final Motorcycle? editMotorcycle;
  const MotorcycleFormScreen({super.key, this.editMotorcycle});

  @override
  State<MotorcycleFormScreen> createState() => _MotorcycleFormScreenState();
}

class _MotorcycleFormScreenState extends State<MotorcycleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _bodySerialCtrl = TextEditingController();
  GearType _gearType = GearType.normal;

  final _tierCtrl = TextEditingController();
  final _lenCtrl = TextEditingController();

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
    final m = widget.editMotorcycle;
    if (m != null) {
      _companyCtrl.text = m.manufactureCompany;
      _modelCtrl.text = m.model;
      _plateCtrl.text = m.plateNum.toString();
      _bodySerialCtrl.text = m.bodySerialNum.toString();
      _gearType = m.gearType;

      _tierCtrl.text = m.tierDiameter.toString();
      _lenCtrl.text = m.length.toString();

      _manufactureDate = m.manufactureDate;

      _engManufactureCtrl.text = m.engine.manufacture;
      _engModelCtrl.text = m.engine.model;
      _capacityCtrl.text = m.engine.capacity.toString();
      _cylindersCtrl.text = m.engine.cylinders.toString();
      _fuelType = m.engine.fuelType;
      _engineDate = m.engine.manufactureDate;
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
    _tierCtrl.dispose();
    _lenCtrl.dispose();
    _engManufactureCtrl.dispose();
    _engModelCtrl.dispose();
    _capacityCtrl.dispose();
    _cylindersCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editMotorcycle != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Motorcycle" : "Add Motorcycle")),
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
                decoration: const InputDecoration(labelText: "Motorcycle Model"),
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
                controller: _tierCtrl,
                decoration: const InputDecoration(labelText: "Tier Diameter (int)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? "Enter number" : null,
              ),
              TextFormField(
                controller: _lenCtrl,
                decoration: const InputDecoration(labelText: "Length (int)"),
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

                  final moto = Motorcycle.full(
                    widget.editMotorcycle?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
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
                    int.parse(_tierCtrl.text),
                    int.parse(_lenCtrl.text),
                  );

                  Navigator.pop(context, moto);
                },
                child: Text(isEdit ? "Save Changes" : "Save Motorcycle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}