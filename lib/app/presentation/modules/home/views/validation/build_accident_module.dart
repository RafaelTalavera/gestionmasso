import 'package:flutter/material.dart';

import '../../../event_table/views/event_table.dart';
import '../../../formulario/views/formulario_view.dart';

Widget buildAccidentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.fromLTRB(5.0, 100.0, 5.0, 300.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Accidentes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
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
                  'Buscar causas',
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
            const SizedBox(width: 16),
            Expanded(
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
                  'Casos cargados',
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
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Analsis de riesgos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
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
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
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
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Analsis de riesgos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
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
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
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
            ),
          ],
        ),
      ],
    ),
  );
}
