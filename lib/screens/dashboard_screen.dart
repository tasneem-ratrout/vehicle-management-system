import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../models/automobile.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';
import 'vehicle_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedFilter = 'company';
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final searchBloc = context.read<SearchBloc>();

    if (_selectedFilter == 'date') {
      if (_selectedDate == null) {
        searchBloc.add(ClearSearchEvent());
        return;
      }

      searchBloc.add(SearchByDateEvent(_selectedDate!));
      return;
    }

    final q = _textController.text.trim();
    if (q.isEmpty) {
      searchBloc.add(ClearSearchEvent());
      return;
    }

    if (_selectedFilter == 'company') {
      searchBloc.add(SearchByCompanyEvent(q));
    } else {
      searchBloc.add(SearchByPlateEvent(q));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
    _applyFilter();
  }

  List<Automobile> _allVehicles(VehicleLoaded state) {
    return [...state.cars, ...state.trucks, ...state.motorcycles];
  }

  String _typeLabel(Automobile vehicle) {
    if (vehicle is Car) return 'Car';
    if (vehicle is Truck) return 'Truck';
    if (vehicle is Motorcycle) return 'Motorcycle';
    return 'Vehicle';
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
          return Scaffold(
            appBar: AppBar(title: const Text('Dashboard')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Network unavailable. Check your connection.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VehicleBloc>().add(LoadVehiclesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TimeoutState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Dashboard')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Request timed out. Please try again.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VehicleBloc>().add(LoadVehiclesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ServerErrorState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Dashboard')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Server error. Please try again later.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VehicleBloc>().add(LoadVehiclesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! VehicleLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = state;

        final total =
            data.cars.length + data.trucks.length + data.motorcycles.length;
        final now = DateTime.now();
        final lastUpdate =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF16324F),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDCEEFF),
                  Color(0xFFF4F8FB),
                  Color(0xFFDDF7EC),
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF16324F), Color(0xFF266A8D)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 14,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fleet Overview',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Last refresh: $lastUpdate',
                            style: const TextStyle(
                              color: Color(0xFFD3E9F8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_car_filled_rounded,
                                color: Color(0xFFB8E1FF),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$total active vehicles',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 104,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _StatTile(
                            label: 'Total',
                            value: '$total',
                            icon: Icons.grid_view_rounded,
                            color: const Color(0xFF1D4E89),
                          ),
                          const SizedBox(width: 10),
                          _StatTile(
                            label: 'Cars',
                            value: '${data.cars.length}',
                            icon: Icons.directions_car_outlined,
                            color: const Color(0xFF0E7490),
                          ),
                          const SizedBox(width: 10),
                          _StatTile(
                            label: 'Trucks',
                            value: '${data.trucks.length}',
                            icon: Icons.local_shipping_outlined,
                            color: const Color(0xFF065F46),
                          ),
                          const SizedBox(width: 10),
                          _StatTile(
                            label: 'Motorcycles',
                            value: '${data.motorcycles.length}',
                            icon: Icons.two_wheeler_outlined,
                            color: const Color(0xFF7C2D12),
                          ),
                        ],
                      ),
                    ),
                    if (data.loadedFromCache)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Offline mode: showing last cached data.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0x22000000)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedFilter,
                              decoration: const InputDecoration(
                                labelText: 'Filter by',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'company',
                                  child: Text('Company'),
                                ),
                                DropdownMenuItem(
                                  value: 'plate',
                                  child: Text('Plate'),
                                ),
                                DropdownMenuItem(
                                  value: 'date',
                                  child: Text('Date'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _selectedFilter = value;
                                  _textController.clear();
                                  _selectedDate = null;
                                });
                                context.read<SearchBloc>().add(
                                  ClearSearchEvent(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_selectedFilter == 'date')
                            OutlinedButton(
                              onPressed: _pickDate,
                              child: Text(
                                _selectedDate == null
                                    ? 'Pick date'
                                    : _selectedDate!.toLocal().toString().split(
                                        ' ',
                                      )[0],
                              ),
                            )
                          else
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: const InputDecoration(
                                  labelText: 'Type to filter',
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (_) => _applyFilter(),
                              ),
                            ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            tooltip: 'Clear filter',
                            onPressed: () {
                              setState(() {
                                _textController.clear();
                                _selectedDate = null;
                              });
                              context.read<SearchBloc>().add(
                                ClearSearchEvent(),
                              );
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<VehicleBloc>().add(LoadVehiclesEvent());
                          context.read<SearchBloc>().add(ClearSearchEvent());
                        },
                        child: BlocBuilder<SearchBloc, SearchState>(
                          builder: (context, searchState) {
                            final list = switch (searchState) {
                              SearchResults() => searchState.results,
                              SearchEmpty() => <Automobile>[],
                              _ => _allVehicles(data),
                            };

                            if (list.isEmpty) {
                              return ListView(
                                children: const [
                                  SizedBox(height: 80),
                                  Center(child: Text('No vehicles found.')),
                                ],
                              );
                            }

                            return ListView.separated(
                              itemCount: list.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final vehicle = list[index];
                                return Card(
                                  elevation: 1.6,
                                  shadowColor: const Color(0x1A000000),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0x140A7C8C),
                                      child: Icon(
                                        _iconFor(vehicle),
                                        color: const Color(0xFF0A7C8C),
                                      ),
                                    ),
                                    title: Text(
                                      '${_typeLabel(vehicle)}: ${vehicle.model}',
                                    ),
                                    subtitle: Text(
                                      '${vehicle.manufactureCompany} • Plate: ${vehicle.plateNum}',
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => VehicleDetailPage(
                                            vehicle: vehicle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _iconFor(Automobile v) {
    if (v is Car) return Icons.directions_car_filled_outlined;
    if (v is Truck) return Icons.local_shipping_outlined;
    return Icons.two_wheeler_outlined;
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x18000000)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(label, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardPage();
  }
}
