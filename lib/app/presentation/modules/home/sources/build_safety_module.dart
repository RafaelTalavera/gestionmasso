import 'package:flutter/material.dart';

import '../../event/event_table.dart';
import '../../extinguisher/extimguisher_Empresa_Selection_view.dart';
import '../../extinguisher/extimguisher_form_view.dart';
import '../../event/form_view.dart';

import '../../extinguisher/extimguisher_table_view.dart';
import '../../risk/views/iper_view.dart';
import '../../risk/views/risk_selec_area_puesto.dart';
import '../../risk/views/risk_views.dart';

Widget buildAccidentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.all(30.0),
    child: ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Center(
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
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text(
            'Análisis de riesgos',
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
                  builder: (context) => const RiskPage(
                    initialCompany: '',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.warning),
            label: const Text(
              'Carga de Peligros y Riesgos',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 242),
                backgroundColor: Colors.deepPurple.shade200),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity, // Ocupa el ancho de la pantalla
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IperTable(),
                  ));
            },
            icon: const Icon(Icons.list),
            label: const Text(
              'Analisis de peligros y riesgos',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 242),
                backgroundColor: Colors.deepPurple.shade200),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity, // Ocupa el ancho de la pantalla
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiskSelectionScreen(),
                  ));
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text(
              'Estadistica de peligros y riesgos',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 242),
                backgroundColor: Colors.deepPurple.shade200),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Center(
          child: Text(
            'Control de Extintores',
            style: TextStyle(
              color: Color.fromARGB(255, 21, 20, 20),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExtinguerPage(),
                  ));
            },
            icon: const Icon(Icons.fire_extinguisher),
            label: const Text(
              'Carga inicial de extintor',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(0, 0, 255, 0.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExtimguishersScreen()));
          },
          icon: const Icon(Icons.list),
          label: const Text(
            'Control de extintores     ',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(0, 0, 255, 0.5),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EmpresaSelectionScreen()));
          },
          icon: const Icon(Icons.bar_chart),
          label: const Text(
            'Estadisticas de extintores     ',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(0, 0, 255, 0.5),
          ),
        ),
      ],
    ),
  );
}
