import 'package:flutter/material.dart';

import '../../../event_table/views/event_table.dart';
import '../../../formulario/views/formulario_view.dart';
import '../../../iper/views/iper_view.dart';
import '../../../riesgos/views/riesgos_views.dart';

Widget buildAccidentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.all(30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Accidentes laborales',
          style: TextStyle(
            color: Color.fromARGB(255, 21, 20, 20),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
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
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 235, 11, 86),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventTable(),
                ),
              );
            },
            icon: const Icon(Icons.grid_on),
            label: const Text(
              'Historial de Casos cargados',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 235, 11, 86),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Text(
          'Análisis de riesgos',
          style: TextStyle(
            color: Color.fromARGB(255, 21, 20, 20),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
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
                  builder: (context) => RiskPage(),
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
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(126, 238, 255, 0)),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity, // Ocupa el ancho de la pantalla
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IperTable(),
                  ));
            },
            icon: const Icon(Icons.grid_on),
            label: const Text(
              'Ver Analisis de peligros y riesgos',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(126, 238, 255, 0),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity, // Ocupa el ancho de la pantalla
          child: ElevatedButton.icon(
            onPressed: () {
              // Lógica para la nueva sección
            },
            icon: const Icon(Icons.star),
            label: const Text(
              'Opción 1',
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
            // Lógica para la nueva sección
          },
          icon: const Icon(Icons.favorite),
          label: const Text(
            'Opción 2',
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
