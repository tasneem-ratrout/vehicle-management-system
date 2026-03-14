import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../models/enums.dart';
import '../models/motorcycle.dart';
import '../services/print_helpers.dart';
import 'motorcycle_form_screen.dart';

class MotorcyclesScreen extends StatefulWidget {
  const MotorcyclesScreen({super.key});

  @override
  State<MotorcyclesScreen> createState() => _MotorcyclesScreenState();
}

class _MotorcyclesScreenState extends State<MotorcyclesScreen> {
  String _companyQ = '';
  String _plateQ = '';
  DateTime? _dateQ;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Motorcycle> _filtered(List<Motorcycle> motos) {
    return motos.where((m) {
      final okCompany = _companyQ.trim().isEmpty
          ? true
          : m.manufactureCompany.toLowerCase().contains(_companyQ.toLowerCase());

      final okPlate =
          _plateQ.trim().isEmpty ? true : m.plateNum.toString().contains(_plateQ.trim());

      final okDate = _dateQ == null ? true : _sameDay(m.manufactureDate, _dateQ!);

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
            appBar: AppBar(title: const Text("Motorcycles")),
            body: Center(child: Text(state.message)),
          );
        }

        final loaded = state as VehicleLoaded;
        final allMotos = loaded.motorcycles;
        final list = _filtered(allMotos);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Motorcycles"),
            actions: [
              IconButton(
                tooltip: "Print All Motorcycles",
                icon: const Icon(Icons.print),
                onPressed: () {
                  final text = allMotos.map(printMotorcycle).join("\n");
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Motorcycles Print"),
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
                  final moto = await Navigator.push<Motorcycle>(
                    context,
                    MaterialPageRoute(builder: (_) => const MotorcycleFormScreen()),
                  );

                  if (moto != null && mounted) {
                    context.read<VehicleBloc>().add(AddVehicleEvent(moto));
                    context.read<VehicleBloc>().add(SaveVehiclesEvent());
                  }
                },
              ),
              IconButton(
                tooltip: "Insert at position",
                icon: const Icon(Icons.playlist_add),
                onPressed: () async {
                  final moto = await Navigator.push<Motorcycle>(
                    context,
                    MaterialPageRoute(builder: (_) => const MotorcycleFormScreen()),
                  );

                  if (moto == null || !mounted) return;

                  final pos = await _askPosition();

                  if (pos == null || pos < 0 || pos > allMotos.length) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid position")),
                    );
                    return;
                  }

                  context.read<VehicleBloc>().add(InsertVehicleAtEvent(pos, moto));
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
                      ? const Center(child: Text("No results / No motorcycles yet."))
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final m = list[i];

                            return Card(
                              child: ListTile(
                                title: Text("Plate: ${m.plateNum} | ${m.model}"),
                                subtitle: Text(
                                  "${m.manufactureCompany} • Date: ${m.manufactureDate.toLocal().toString().split(' ')[0]}",
                                ),
                                onTap: () {
                                  final text = printMotorcycle(m);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Motorcycle Details"),
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
                                        final edited = await Navigator.push<Motorcycle>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MotorcycleFormScreen(
                                              editMotorcycle: m,
                                            ),
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
                                                m.id,
                                                VehicleType.motorcycle,
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