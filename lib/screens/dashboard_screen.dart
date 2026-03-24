import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/vehicle/vehicle_bloc.dart';
import '../../bloc/vehicle/vehicle_state.dart';
import '../bloc/vehicle/vehicle_event.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading || state is VehicleInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is NetworkErrorState) {
          return const Scaffold(
            body: Center(child: Text("No Internet")),
          );
        }

        if (state is TimeoutErrorState) {
          return const Scaffold(
            body: Center(child: Text("Timeout")),
          );
        }

        if (state is ServerErrorState) {
          return const Scaffold(
            body: Center(child: Text("Server Error")),
          );
        }

        final data = state as VehicleLoaded;

        final total = data.cars.length +
            data.trucks.length +
            data.motorcycles.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 SUMMARY
                Text(
                  "Total Vehicles: $total",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Text("Cars: ${data.cars.length}"),
                Text("Trucks: ${data.trucks.length}"),
                Text("Motorcycles: ${data.motorcycles.length}"),

                const SizedBox(height: 30),

                /// 🔥 LIST (كل المركبات)
                const Text(
                  "All Vehicles",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<VehicleBloc>().add(LoadVehiclesEvent());
                    },
                    child: ListView(
                      children: [
                        ...data.cars.map((c) => ListTile(
                              title: Text("Car: ${c.model}"),
                              subtitle: Text(c.manufactureCompany),
                            )),
                        ...data.trucks.map((t) => ListTile(
                              title: Text("Truck: ${t.model}"),
                              subtitle: Text(t.manufactureCompany),
                            )),
                        ...data.motorcycles.map((m) => ListTile(
                              title: Text("Motorcycle: ${m.model}"),
                              subtitle: Text(m.manufactureCompany),
                            )),
                      ],
                    ),
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