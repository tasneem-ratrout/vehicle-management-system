import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../services/print_helpers.dart';
import 'cars_screen.dart';
import 'motorcycles_screen.dart';
import 'trucks_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showPrintAllDialog(
    BuildContext context, {
    required List cars,
    required List trucks,
    required List motorcycles,
  }) {
    final text = printAll(
      cars: cars.cast(),
      trucks: trucks.cast(),
      motorcycles: motorcycles.cast(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Print All Vehicles"),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Text(text),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
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
            body: Center(child: Text(state.message)),
          );
        }

        final loaded = state as VehicleLoaded;

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: "Print All",
                icon: const Icon(Icons.print),
                onPressed: () => _showPrintAllDialog(
                  context,
                  cars: loaded.cars,
                  trucks: loaded.trucks,
                  motorcycles: loaded.motorcycles,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Vehicle Management System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CarsScreen()),
                        );
                      },
                      child: Text("Cars (${loaded.cars.length})"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TrucksScreen()),
                        );
                      },
                      child: Text("Trucks (${loaded.trucks.length})"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MotorcyclesScreen()),
                        );
                      },
                      child: Text("Motorcycles (${loaded.motorcycles.length})"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}