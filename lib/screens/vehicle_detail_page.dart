import 'package:flutter/material.dart';

import '../models/automobile.dart';
import '../models/car.dart';
import '../models/motorcycle.dart';
import '../models/truck.dart';

class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({super.key, required this.vehicle});

  final Automobile vehicle;

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections(vehicle);

    return Scaffold(
      appBar: AppBar(title: Text('${_type(vehicle)} Details')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF6FF), Color(0xFFF4F8FB), Color(0xFFE9FFF7)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.$1,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...section.$2.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 170,
                                child: Text(
                                  item.$1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                              Expanded(child: Text(item.$2)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<(String, List<(String, String)>)> _buildSections(Automobile v) {
    final general = <(String, String)>[
      ('Type', _type(v)),
      ('ID', v.id),
      ('Manufacture Company', v.manufactureCompany),
      (
        'Manufacture Date',
        v.manufactureDate.toLocal().toString().split(' ')[0],
      ),
      ('Model', v.model),
      ('Plate Number', v.plateNum.toString()),
      ('Gear Type', v.gearType.name),
      ('Body Serial Number', v.bodySerialNum.toString()),
    ];

    final engine = <(String, String)>[
      ('Engine Manufacture', v.engine.manufacture),
      (
        'Engine Manufacture Date',
        v.engine.manufactureDate.toLocal().toString().split(' ')[0],
      ),
      ('Engine Model', v.engine.model),
      ('Engine Capacity', v.engine.capacity.toString()),
      ('Engine Cylinders', v.engine.cylinders.toString()),
      ('Engine Fuel Type', v.engine.fuelType.name),
    ];

    final spec = <(String, String)>[];

    if (v is Car) {
      spec.addAll([
        ('Vehicle Length', v.length.toString()),
        ('Vehicle Width', v.width.toString()),
        ('Vehicle Color', v.color),
        ('Chairs Number', v.chairNum.toString()),
        ('Leather Interior', v.isFurnitureLeather.toString()),
      ]);
    } else if (v is Truck) {
      spec.addAll([
        ('Vehicle Length', v.length.toString()),
        ('Vehicle Width', v.width.toString()),
        ('Vehicle Color', v.color),
        ('Free Weight', v.freeWeight.toString()),
        ('Full Weight', v.fullWeight.toString()),
      ]);
    } else if (v is Motorcycle) {
      spec.addAll([
        ('Tier Diameter', v.tierDiameter.toString()),
        ('Motorcycle Length', v.length.toString()),
      ]);
    }

    return [('General', general), ('Engine', engine), ('Specifications', spec)];
  }

  String _type(Automobile v) {
    if (v is Car) return 'Car';
    if (v is Truck) return 'Truck';
    if (v is Motorcycle) return 'Motorcycle';
    return 'Automobile';
  }
}
