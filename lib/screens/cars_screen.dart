import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../models/car.dart';
import '../models/enums.dart';
import '../services/print_helpers.dart';
import 'car_form_screen.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  String _companyQ = '';
  String _plateQ = '';
  DateTime? _dateQ;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Car> _filtered(List<Car> cars) {
    return cars.where((c) {
      final okCompany = _companyQ.trim().isEmpty
          ? true
          : c.manufactureCompany.toLowerCase().contains(_companyQ.toLowerCase());

      final okPlate =
          _plateQ.trim().isEmpty ? true : c.plateNum.toString().contains(_plateQ.trim());

      final okDate = _dateQ == null ? true : _sameDay(c.manufactureDate, _dateQ!);

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
            appBar: AppBar(title: const Text("Cars")),
            body: Center(child: Text(state.message)),
          );
        }

        final loaded = state as VehicleLoaded;
        final allCars = loaded.cars;
        final list = _filtered(allCars);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Cars"),
            actions: [
              IconButton(
                tooltip: "Print All Cars",
                icon: const Icon(Icons.print),
                onPressed: () {
                  final text = allCars.map(printCar).join("\n");
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Cars Print"),
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
                  final car = await Navigator.push<Car>(
                    context,
                    MaterialPageRoute(builder: (_) => const CarFormScreen()),
                  );

                  if (car != null && mounted) {
                    context.read<VehicleBloc>().add(AddVehicleEvent(car));
                    context.read<VehicleBloc>().add(SaveVehiclesEvent());
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

                  if (car == null || !mounted) return;

                  final pos = await _askPosition();

                  if (pos == null || pos < 0 || pos > allCars.length) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid position")),
                    );
                    return;
                  }

                  context.read<VehicleBloc>().add(InsertVehicleAtEvent(pos, car));
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
                      ? const Center(child: Text("No results / No cars yet."))
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final c = list[i];

                            return Card(
                              child: ListTile(
                                title: Text("Plate: ${c.plateNum} | ${c.model}"),
                                subtitle: Text(
                                  "${c.manufactureCompany} • Date: ${c.manufactureDate.toLocal().toString().split(' ')[0]}",
                                ),
                                onTap: () {
                                  final text = printCar(c);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Car Details"),
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
                                        final edited = await Navigator.push<Car>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CarFormScreen(editCar: c),
                                          ),
                                        );

                                        if (edited != null && mounted) {
                                          context
                                              .read<VehicleBloc>()
                                              .add(UpdateVehicleEvent(edited));
                                          context
                                              .read<VehicleBloc>()
                                              .add(SaveVehiclesEvent());
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        context.read<VehicleBloc>().add(
                                              DeleteVehicleEvent(
                                                c.id,
                                                VehicleType.car,
                                              ),
                                            );
                                        context.read<VehicleBloc>().add(
                                              SaveVehiclesEvent(),
                                            );
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