import 'package:flutter/material.dart';

import '../../Lai/view/lai_form_view.dart';
import '../../extinguisher/extimguisher_Empresa_Selection_view.dart';

Widget buildEnviromentModule(BuildContext context, Color? selectedColor) {
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
            'Apectos ambientales',
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
                  builder: (context) => const LaiFormPage(),
                ),
              );
            },
            icon: const Icon(Icons.eco),
            label: const Text(
              'Listado de aspectos ambientales',
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
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventTable(),
                ),
              );
              */
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
            onPressed: () {},
            icon: const Icon(Icons.water),
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
            onPressed: () {},
            icon: const Icon(Icons.list),
            label: const Text(
              '-----------------------',
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
              /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiskSelectionScreen(),
                  ));
                  */
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
            '----------------------',
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
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExtinguerPage(),
                  ));
                  */
            },
            icon: const Icon(Icons.cloud),
            label: const Text(
              '---------------------',
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
            /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExtimguishersScreen()));
                    */
          },
          icon: const Icon(Icons.nature),
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
            '-------------------------------   ',
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
