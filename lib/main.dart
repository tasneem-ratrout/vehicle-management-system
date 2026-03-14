import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/persistence/persistence_bloc.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/vehicle/vehicle_bloc.dart';
import 'bloc/vehicle/vehicle_event.dart';
import 'repository/search_service.dart';
import 'repository/vehicle_repository.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final vehicleRepository = VehicleRepository();
  final searchService = SearchService(vehicleRepository);

  final vehicleBloc = VehicleBloc(vehicleRepository)..add(LoadVehiclesEvent());

  runApp(
    VehicleApp(
      vehicleRepository: vehicleRepository,
      searchService: searchService,
      vehicleBloc: vehicleBloc,
    ),
  );
}

class VehicleApp extends StatelessWidget {
  final VehicleRepository vehicleRepository;
  final SearchService searchService;
  final VehicleBloc vehicleBloc;

  const VehicleApp({
    super.key,
    required this.vehicleRepository,
    required this.searchService,
    required this.vehicleBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VehicleBloc>.value(value: vehicleBloc),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(searchService),
        ),
        BlocProvider<PersistenceBloc>(
          create: (_) => PersistenceBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vehicle Management System',
        theme: ThemeData(useMaterial3: true),
        home: const HomeScreen(),
      ),
    );
  }
}