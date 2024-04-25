import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../accidents/views/accidents_datos_select_screen.dart';
import '../../accidents/views/accidents_lista_select_screen.dart';
import '../../extinguisher/views/extimguisher_organization_selection_chart_view.dart';
import '../../extinguisher/views/extimguisher_form_organization_select_view.dart';

import '../../extinguisher/views/extimguisher_table_view.dart';
import '../../risk/views/risk_form_organization_select_view.dart';
import '../../risk/views/risk_table_screm_view.dart';
import '../../risk/views/risk_selec_organization_chart.dart';
import '../../statistcs/views/statistcs_if_organization_select_view.dart';

Widget buildAccidentModule(BuildContext context, Color? selectedColor) {
  return Container(
    color: selectedColor,
    padding: const EdgeInsets.all(30.0),
    child: ListView(
      children: [
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text(
            'Peligros y Riesgos',
            style: TextStyle(
              color: Color.fromARGB(255, 238, 183, 19),
              fontSize: 26.0,
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
                          const RiskOrganizationSelectionScreen(),
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
                      ' Alta IPER ',
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
                      '  Ver P&R    ',
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
          height: 40,
        ),
        const Center(
          child: Text(
            'Control de extintores',
            style: TextStyle(
              color: Color.fromARGB(255, 238, 183, 19),
              fontSize: 26.0,
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
                            const ExtimguisherOrganizationSelectionScreen(),
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
                      ' Extintores',
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
                      '  Ver Lista  ',
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
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text(
            'Accidentología',
            style: TextStyle(
              color: Color.fromARGB(255, 238, 183, 19),
              fontSize: 26.0,
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
                        builder: (context) => SelectScreem(),
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
                      CupertinoIcons.create,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '    Datos     ',
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
                          builder: (context) => const SelectScreemLista()));
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
                      CupertinoIcons.bandage,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '  Ver Lista  ',
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
                              const StatistcsIFOrgaSelectionScreen()));
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
