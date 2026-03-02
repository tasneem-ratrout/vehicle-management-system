import 'package:flutter/material.dart';
import '../models/truck.dart';
import '../services/print_helpers.dart';
import 'truck_form_screen.dart';

class TrucksScreen extends StatefulWidget {
  final List<Truck> trucks;
  final Future<void> Function(List<Truck>) onTrucksChanged;

  const TrucksScreen({
    super.key,
    required this.trucks,
    required this.onTrucksChanged,
  });

  @override
  State<TrucksScreen> createState() => _TrucksScreenState();
}

class _TrucksScreenState extends State<TrucksScreen> {
  late List<Truck> _trucks;

  String _companyQ = '';
  String _plateQ = '';
  DateTime? _dateQ;

  @override
  void initState() {
    super.initState();
    _trucks = List<Truck>.from(widget.trucks);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Truck> get filtered {
    return _trucks.where((t) {
      final okCompany = _companyQ.trim().isEmpty
          ? true
          : t.manufactureCompany.toLowerCase().contains(_companyQ.toLowerCase());
      final okPlate =
          _plateQ.trim().isEmpty ? true : t.plateNum.toString().contains(_plateQ.trim());
      final okDate = _dateQ == null ? true : _sameDay(t.manufactureDate, _dateQ!);
      return okCompany && okPlate && okDate;
    }).toList();
  }

  Future<void> _save() async {
    await widget.onTrucksChanged(_trucks);
    setState(() {});
  }

  Future<int?> _askPosition() async {
    final ctrl = TextEditingController();
    return showDialog<int>(
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
        title: const Text("Trucks"),
        actions: [
          IconButton(
            tooltip: "Print All Trucks",
            icon: const Icon(Icons.print),
            onPressed: () {
              final text = _trucks.map(printTruck).join("\n");
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Trucks Print"),
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
              final truck = await Navigator.push<Truck>(
                context,
                MaterialPageRoute(builder: (_) => const TruckFormScreen()),
              );
              if (truck != null) {
                _trucks.add(truck);
                await _save();
              }
            },
          ),
          IconButton(
            tooltip: "Insert at position",
            icon: const Icon(Icons.playlist_add),
            onPressed: () async {
              final truck = await Navigator.push<Truck>(
                context,
                MaterialPageRoute(builder: (_) => const TruckFormScreen()),
              );
              if (truck == null) return;

              final pos = await _askPosition();
              if (pos == null || pos < 0 || pos > _trucks.length) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid position")),
                );
                return;
              }
              _trucks.insert(pos, truck);
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
                  ? const Center(child: Text("No results / No trucks yet."))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final t = list[i];
                        final realIndex = _trucks.indexOf(t);

                        return Card(
                          child: ListTile(
                            title: Text("Plate: ${t.plateNum} | ${t.model}"),
                            subtitle: Text("${t.manufactureCompany} • Date: ${t.manufactureDate.toLocal().toString().split(' ')[0]}"),
                            onTap: () {
                              final text = printTruck(t);
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Truck Details"),
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
                                    final edited = await Navigator.push<Truck>(
                                      context,
                                      MaterialPageRoute(builder: (_) => TruckFormScreen(editTruck: t)),
                                    );
                                    if (edited != null) {
                                      _trucks[realIndex] = edited;
                                      await _save();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    _trucks.removeAt(realIndex);
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