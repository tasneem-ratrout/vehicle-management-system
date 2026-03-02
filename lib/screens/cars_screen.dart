import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/print_helpers.dart';
import 'car_form_screen.dart';

class CarsScreen extends StatefulWidget {
  final List<Car> cars;
  final Future<void> Function(List<Car>) onCarsChanged;

  const CarsScreen({
    super.key,
    required this.cars,
    required this.onCarsChanged,
  });

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  late List<Car> _cars;

  String _companyQ = '';
  String _plateQ = '';
  DateTime? _dateQ;

  @override
  void initState() {
    super.initState();
    _cars = List<Car>.from(widget.cars);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Car> get filtered {
    return _cars.where((c) {
      final okCompany = _companyQ.trim().isEmpty
          ? true
          : c.manufactureCompany.toLowerCase().contains(_companyQ.toLowerCase());
      final okPlate =
          _plateQ.trim().isEmpty ? true : c.plateNum.toString().contains(_plateQ.trim());
      final okDate = _dateQ == null ? true : _sameDay(c.manufactureDate, _dateQ!);
      return okCompany && okPlate && okDate;
    }).toList();
  }

  Future<void> _save() async {
    await widget.onCarsChanged(_cars);
    setState(() {});
  }

  Future<int?> _askPosition() async {
    final ctrl = TextEditingController();
    final pos = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Insert at position"),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "0 .. length"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, int.tryParse(ctrl.text)),
            child: const Text("Insert"),
          ),
        ],
      ),
    );
    return pos;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateQ ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateQ = picked);
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cars"),
        actions: [
          IconButton(
            tooltip: "Print All Cars",
            icon: const Icon(Icons.print),
            onPressed: () {
              final text = _cars.map(printCar).join("\n");
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Cars Print"),
                  content: SizedBox(width: 600, child: SingleChildScrollView(child: Text(text))),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
                  ],
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Add",
            icon: const Icon(Icons.add),
            onPressed: () async {
              final car = await Navigator.push<Car>(
                context,
                MaterialPageRoute(builder: (_) => const CarFormScreen()),
              );
              if (car != null) {
                _cars.add(car);
                await _save();
              }
            },
          ),
          IconButton(
            tooltip: "Insert at position",
            icon: const Icon(Icons.playlist_add),
            onPressed: () async {
              final car = await Navigator.push<Car>(
                context,
                MaterialPageRoute(builder: (_) => const CarFormScreen()),
              );
              if (car == null) return;

              final pos = await _askPosition();
              if (pos == null || pos < 0 || pos > _cars.length) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid position")),
                );
                return;
              }
              _cars.insert(pos, car);
              await _save();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.business),
                hintText: "Search by company name",
              ),
              onChanged: (v) => setState(() => _companyQ = v),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.confirmation_number),
                hintText: "Search by plate number",
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => _plateQ = v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dateQ == null
                        ? "Search by manufacture date: (not selected)"
                        : "Search by manufacture date: ${_dateQ!.toLocal().toString().split(' ')[0]}",
                  ),
                ),
                TextButton(onPressed: _pickDate, child: const Text("Pick")),
                TextButton(onPressed: () => setState(() => _dateQ = null), child: const Text("Clear")),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text("No results / No cars yet."))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final c = list[i];
                        final realIndex = _cars.indexOf(c);

                        return Card(
                          child: ListTile(
                            title: Text("Plate: ${c.plateNum} | ${c.model}"),
                            subtitle: Text("${c.manufactureCompany} • Date: ${c.manufactureDate.toLocal().toString().split(' ')[0]}"),
                            onTap: () {
                              final text = printCar(c);
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Car Details"),
                                  content: SizedBox(width: 600, child: SingleChildScrollView(child: Text(text))),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
                                  ],
                                ),
                              );
                            },
                            trailing: Wrap(
                              spacing: 6,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final edited = await Navigator.push<Car>(
                                      context,
                                      MaterialPageRoute(builder: (_) => CarFormScreen(editCar: c)),
                                    );
                                    if (edited != null) {
                                      _cars[realIndex] = edited;
                                      await _save();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    _cars.removeAt(realIndex);
                                    await _save();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}