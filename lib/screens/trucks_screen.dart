import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../models/enums.dart';
import '../models/truck.dart';
import '../services/print_helpers.dart';
import 'truck_form_screen.dart';

class TrucksScreen extends StatefulWidget {
  const TrucksScreen({super.key});

  @override
  State<TrucksScreen> createState() => _TrucksScreenState();
}

class _TrucksScreenState extends State<TrucksScreen> {
  String _companyQ = '';
  String _plateQ = '';
  DateTime? _dateQ;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Truck> _filtered(List<Truck> trucks) {
    return trucks.where((t) {
      final okCompany = _companyQ.trim().isEmpty
          ? true
          : t.manufactureCompany.toLowerCase().contains(_companyQ.toLowerCase());

      final okPlate =
          _plateQ.trim().isEmpty ? true : t.plateNum.toString().contains(_plateQ.trim());

      final okDate = _dateQ == null ? true : _sameDay(t.manufactureDate, _dateQ!);

      return okCompany && okPlate && okDate;
    }).toList();
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
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

    if (picked != null) {
      setState(() => _dateQ = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading || state is VehicleInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is VehicleError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Trucks")),
            body: Center(child: Text(state.message)),
          );
        }

        final loaded = state as VehicleLoaded;
        final allTrucks = loaded.trucks;
        final list = _filtered(allTrucks);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Trucks"),
            actions: [
              IconButton(
                tooltip: "Print All Trucks",
                icon: const Icon(Icons.print),
                onPressed: () {
                  final text = allTrucks.map(printTruck).join("\n");
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Trucks Print"),
                      content: SizedBox(
                        width: 600,
                        child: SingleChildScrollView(child: Text(text)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
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

                  if (truck != null && mounted) {
                    context.read<VehicleBloc>().add(AddVehicleEvent(truck));
                    context.read<VehicleBloc>().add(SaveVehiclesEvent());
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

                  if (truck == null || !mounted) return;

                  final pos = await _askPosition();

                  if (pos == null || pos < 0 || pos > allTrucks.length) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid position")),
                    );
                    return;
                  }

                  context.read<VehicleBloc>().add(InsertVehicleAtEvent(pos, truck));
                  context.read<VehicleBloc>().add(SaveVehiclesEvent());
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
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text("Pick"),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _dateQ = null),
                      child: const Text("Clear"),
                    ),
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

                            return Card(
                              child: ListTile(
                                title: Text("Plate: ${t.plateNum} | ${t.model}"),
                                subtitle: Text(
                                  "${t.manufactureCompany} • Date: ${t.manufactureDate.toLocal().toString().split(' ')[0]}",
                                ),
                                onTap: () {
                                  final text = printTruck(t);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Truck Details"),
                                      content: SizedBox(
                                        width: 600,
                                        child: SingleChildScrollView(child: Text(text)),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Close"),
                                        ),
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
                                          MaterialPageRoute(
                                            builder: (_) => TruckFormScreen(editTruck: t),
                                          ),
                                        );

                                        if (edited != null && mounted) {
                                          context.read<VehicleBloc>().add(UpdateVehicleEvent(edited));
                                          context.read<VehicleBloc>().add(SaveVehiclesEvent());
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        context.read<VehicleBloc>().add(
                                              DeleteVehicleEvent(
                                                t.id,
                                                VehicleType.truck,
                                              ),
                                            );
                                        context.read<VehicleBloc>().add(SaveVehiclesEvent());
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
      },
    );
  }
}