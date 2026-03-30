import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../services/print_helpers.dart';
import 'cars_screen.dart';
import 'motorcycles_screen.dart';
import 'trucks_screen.dart';
import 'dashboard_screen.dart';

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

        if (state is NetworkUnavailableState) {
          return const Scaffold(
            body: Center(child: Text("No Internet Connection")),
          );
        }

        if (state is TimeoutState) {
          return const Scaffold(body: Center(child: Text("Request Timeout")));
        }

        if (state is ServerErrorState) {
          return const Scaffold(body: Center(child: Text("Server Error")));
        }

        final loaded = state as VehicleLoaded;
        final total =
            loaded.cars.length +
            loaded.trucks.length +
            loaded.motorcycles.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
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
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEAF6FF),
                  Color(0xFFF4F8FB),
                  Color(0xFFE9FFF7),
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0A7C8C), Color(0xFF2AA4A4)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x220A7C8C),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Management System',
                        style: GoogleFonts.fraunces(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Track, update, and explore your fleet from one place.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Total vehicles: $total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _HomeNavCard(
                  title: 'Cars',
                  subtitle: '${loaded.cars.length} vehicles',
                  icon: Icons.directions_car_filled_outlined,
                  color: const Color(0xFF0A7C8C),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CarsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _HomeNavCard(
                  title: 'Trucks',
                  subtitle: '${loaded.trucks.length} vehicles',
                  icon: Icons.local_shipping_outlined,
                  color: const Color(0xFF0F6A5F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TrucksScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _HomeNavCard(
                  title: 'Motorcycles',
                  subtitle: '${loaded.motorcycles.length} vehicles',
                  icon: Icons.two_wheeler_outlined,
                  color: const Color(0xFF1B5D9F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MotorcyclesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _HomeNavCard(
                  title: 'Dashboard',
                  subtitle: 'Overview, filters, and details',
                  icon: Icons.dashboard_outlined,
                  color: const Color(0xFF6A5A00),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeNavCard extends StatelessWidget {
  const _HomeNavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: color.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF52606D)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}
