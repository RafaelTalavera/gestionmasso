import 'package:flutter/material.dart';

import '../../modules/Lai/view/lai_form_organization_select_view.dart';
import '../../modules/Lai/view/lai_selec_organization_chart.dart';
import '../../modules/Lai/view/lai_table_organization_select_view .dart';

import '../../modules/accidents/views/accidentes_form_organization_select_view.dart';
import '../../modules/accidents/views/accidentes_organization_select_table_view .dart';
import '../../modules/consumo/views/consumo_organization_select_table_view .dart';
import '../../modules/consumo/views/consumo_organization_select_view.dart';
import '../../modules/consumo/views/consumo_selec_organization.dart';
import '../../modules/extinguisher/views/extimguisher_form_organization_select_view.dart';
import '../../modules/extinguisher/views/extimguisher_organization_selection_chart_view.dart';

import '../../modules/extinguisher/views/extimguisher_table_organization.dart';

import '../../modules/risk/views/risk_form_organization_select_view.dart';
import '../../modules/risk/views/risk_table_organization.dart';

import '../../modules/risk/views/risk_selec_organization_chart.dart';
import '../../modules/statistcs/views/statistcs_if_organization_select_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Colors.orange, // Color de fondo del encabezado
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
            child: const Padding(
              padding: EdgeInsets.only(
                  top: 16.0), // Margen superior adicional para el texto
              child: Text(
                'Gestión Masso',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(30),
          ),
          const Center(
            child: Text(
              'Seguridad laboral',
              style: TextStyle(
                color: Colors.red, // Letras rojas
                fontWeight: FontWeight.bold, // Negrita
                fontSize: 18, // Tamaño de letra 18
              ),
            ),
          ),
          /* ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.healing, color: Colors.red), // Icono
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text(
                  'Accidentes',
                  style: TextStyle(
                    color: Colors.red, // Color del texto
                    fontWeight: FontWeight.normal, // Negrita
                    fontSize: 18, // Tamaño de letra
                  ),
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text(
                  'Investigacion de accidentes',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FormularioAccid()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Historial de casos cargados',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EventTable()));
                },
              ),
            ],
          ),
          */
          ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red), // Icono
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text(
                  'Peligros y riesgos',
                  style: TextStyle(
                    color: Colors.red, // Color del texto
                    fontWeight: FontWeight.normal, // Negrita
                    fontSize: 18, // Tamaño de letra
                  ),
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text(
                  'Carga de peligros y riesgos',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RiskOrganizationSelectionScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Análisis de peligros y riesgos',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OrganizationTableSelectionScreen(),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Estadísticas de peligros y riesgos',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OrganizationSelectionScreen(),
                      ));
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.fire_extinguisher, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Extintores',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text(
                  'Carga inicial de extintores',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ExtimguisherOrganizationSelectionScreen(),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Control de extintores',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OrganizationTableExtimguisherSelectionScreen(),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Extadistica de extintores',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmpresaSelectionScreen(),
                      ));
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.fire_extinguisher, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Accientología',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text(
                  'Craga de accidentes',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AccidentesOrgaSelectionScreen(),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Listado de accidentes',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AccOrgaTableSelectionScreen(),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Indice de frecuencia',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const StatistcsIFOrgaSelectionScreen(),
                      ));
                },
              ),
            ],
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(30),
          ),
          const Center(
            child: Text(
              'MedioAmbiente',
              style: TextStyle(
                color: Colors.green, // Letras rojas
                fontWeight: FontWeight.bold, // Negrita
                fontSize: 18, // Tamaño de letra 18
              ),
            ),
          ),
          ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.eco, color: Colors.green), // Icono
                SizedBox(width: 8),
                Text(
                  'Aspectos e impactos',
                  style: TextStyle(
                    color: Colors.green, // Color del texto
                    fontWeight: FontWeight.normal, // Negrita
                    fontSize: 18, // Tamaño de letra
                  ),
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text(
                  'Carga de aspectos e impactos',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LaiOrganizationSelectionScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Listado de A&I',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LaiOrganizationSelectionTableScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Ver graficos',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LaiSelectionOrganizationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.green), // Icono
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text(
                  'Inventario de HC',
                  style: TextStyle(
                    color: Colors.green, // Color del texto
                    fontWeight: FontWeight.normal, // Negrita
                    fontSize: 18, // Tamaño de letra
                  ),
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text(
                  'Carga de consumos',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const OrganizationConSelectionScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Ver listas de consumos',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ConsumoOrgaTableSelectionScreen(),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Ver Estadística',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ConsumoOrganizationSelectionScreen(),
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
