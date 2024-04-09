import 'package:flutter/material.dart';

import '../../extinguisher/views/extimguisher_Empresa_Selection_view.dart';
import '../../extinguisher/views/extimguisher_form_view.dart';
import '../../extinguisher/views/extimguisher_table_view.dart';
import '../../risk/views/risk_screm_view.dart';
import '../../risk/views/risk_selec_organization.dart';
import '../../risk/views/risk_form_views.dart';

Widget buildAccidentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.all(30.0),
    child: ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        /*    const Center(
          child: Text(
            'Accidentes laborales',
            style: TextStyle(
              color: Color.fromARGB(255, 21, 20, 20),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity, // Ocupa el ancho de la pantalla
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormularioAccid(),
                ),
              );
            },
            icon: const Icon(Icons.healing),
            label: const Text(
              'Investigación de accidentes',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 242),
                backgroundColor: Colors.blueGrey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventTable(),
                ),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text(
              'Historial de Casos cargados',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 242),
                backgroundColor: Colors.blueGrey.shade300),
          ),
        ),
        */
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text(
            'Análisis de Peligros y Riesgos',
            style: TextStyle(
              color: Color.fromARGB(255, 21, 20, 20),
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RiskPage(
                        initialCompany: '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                  backgroundColor: Colors.cyan.shade800,
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Alta IPER',
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
                        builder: (context) => const IperTable(
                          initialCompany: '',
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
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
                      'Ver IPER ',
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
                            const OrganizationSelectionScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
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
          height: 30,
        ),
        const Center(
          child: Text(
            'Control de extintores',
            style: TextStyle(
              color: Color.fromARGB(255, 21, 20, 20),
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExtinguerPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                  backgroundColor: Colors.cyan.shade800,
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fire_extinguisher,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Alta Extin',
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
                          builder: (context) => const ExtimguishersScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
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
                      'Ver IPER ',
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
                              const EmpresaSelectionScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
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
                    SizedBox(height: 8), // Espacio entre el icono y el texto
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
        const SizedBox(height: 10),
      ],
    ),
  );
}
