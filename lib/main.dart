import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
        BlocProvider<SearchBloc>(create: (_) => SearchBloc(searchService)),
        BlocProvider<PersistenceBloc>(create: (_) => PersistenceBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vehicle Management System',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0A7C8C),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F8FB),
          textTheme: GoogleFonts.plusJakartaSansTextTheme(),
          appBarTheme: AppBarTheme(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF1C2A37),
            titleTextStyle: GoogleFonts.fraunces(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C2A37),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            margin: EdgeInsets.zero,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: const Size(0, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF0A7C8C),
                width: 1.6,
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
