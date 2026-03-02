import 'package:flutter/material.dart';

import '../models/car.dart';
import '../models/truck.dart';
import '../models/motorcycle.dart';
import '../services/storage_service.dart';
import '../services/print_helpers.dart';

import 'cars_screen.dart';
import 'trucks_screen.dart';
import 'motorcycles_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> cars = [];
  List<Truck> trucks = [];
  List<Motorcycle> motorcycles = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await StorageService.loadData();
    setState(() {
      cars = data['cars'] as List<Car>;
      trucks = data['trucks'] as List<Truck>;
      motorcycles = data['motorcycles'] as List<Motorcycle>;
    });
  }

  Future<void> saveAll() async {
    await StorageService.saveData(
      cars: cars,
      trucks: trucks,
      motorcycles: motorcycles,
    );
  }

  void _showPrintAllDialog() {
    final text = printAll(
      cars: cars,
      trucks: trucks,
      motorcycles: motorcycles,
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Print All",
            icon: const Icon(Icons.print),
            onPressed: _showPrintAllDialog,
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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CarsScreen(
                          cars: cars,
                          onCarsChanged: (newCars) async {
                            setState(() => cars = newCars);
                            await saveAll();
                          },
                        ),
                      ),
                    );
                    await loadData();
                  },
                  child: Text("Cars (${cars.length})"),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrucksScreen(
                          trucks: trucks,
                          onTrucksChanged: (newTrucks) async {
                            setState(() => trucks = newTrucks);
                            await saveAll();
                          },
                        ),
                      ),
                    );
                    await loadData();
                  },
                  child: Text("Trucks (${trucks.length})"),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MotorcyclesScreen(
                          motorcycles: motorcycles,
                          onMotorcyclesChanged: (newMotos) async {
                            setState(() => motorcycles = newMotos);
                            await saveAll();
                          },
                        ),
                      ),
                    );
                    await loadData();
                  },
                  child: Text("Motorcycles (${motorcycles.length})"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}