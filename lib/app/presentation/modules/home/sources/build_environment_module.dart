import 'package:flutter/material.dart';

import '../../Lai/view/lai_form_view.dart';

import '../../Lai/view/lai_selec_organization.dart';
import '../../Lai/view/lai_table_view.dart';

Widget buildEnviromentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.all(30.0),
    child: ListView(
      children: [
        const SizedBox(
          height: 20,
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
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          width: double.infinity, // Ocupa el ancho de la pantalla
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LaiFormPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.blueGrey.shade300,
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
                      'Alta LAI  ',
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
                      builder: (context) => const LaiScrem(
                        initialCompany: '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade300,
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
                            const LaiSelectionOrganizationScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade300,
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
        )
      ],
    ),
  );
}
