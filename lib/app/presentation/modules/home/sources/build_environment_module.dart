import 'package:flutter/material.dart';

import '../../Lai/view/lai_form_organization_select_view.dart';
import '../../Lai/view/lai_selec_organization_chart.dart';
import '../../Lai/view/lai_table_organization_select_view .dart';

import '../../consumo/views/consumo_organization_select_table_view .dart';
import '../../consumo/views/consumo_organization_select_view.dart';
import '../../consumo/views/consumo_selec_organization.dart';

Widget buildEnviromentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.all(30.0),
    child: ListView(
      children: [
        const SizedBox(
          height: 60,
        ),
        const Center(
          child: Text(
            'Apectos ambientales',
            style: TextStyle(
              color: Color.fromARGB(255, 238, 183, 19),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LaiOrganizationSelectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.lightGreen.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                  foregroundColor: const Color.fromARGB(255, 244, 245, 242),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.eco,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '  Alta LAI  ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LaiOrganizationSelectionTableScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '   Ver LAI    ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LaiSelectionOrganizationScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estadistica',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text(
            'Inventario de Hidrocarburos',
            style: TextStyle(
              color: Color.fromARGB(255, 238, 183, 19),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrganizationConSelectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      ' Consumo ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ConsumoOrgaTableSelectionScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      ' Registros ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ConsumoOrganizationSelectionScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                     Icons.bar_chart,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estadística',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
