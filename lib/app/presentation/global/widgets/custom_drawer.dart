import 'package:flutter/material.dart';

import '../../modules/Lai/view/lai_form_view.dart';
import '../../modules/Lai/view/lai_table_view.dart';

import '../../modules/extinguisher/views/extimguisher_Empresa_Selection_view.dart';
import '../../modules/extinguisher/views/extimguisher_form_view.dart';
import '../../modules/extinguisher/views/extimguisher_table_view.dart';
import '../../modules/risk/views/risk_screm_view.dart';

import '../../modules/risk/views/risk_selec_organization.dart';
import '../../modules/risk/views/risk_form_views.dart';

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
                      builder: (context) => const RiskPage(
                        initialCompany: '',
                      ),
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
                        builder: (context) => const IperTable(
                          initialCompany: '',
                        ),
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
                        builder: (context) => OrganizationSelectionScreen(),
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
                        builder: (context) => const ExtinguerPage(),
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
                        builder: (context) => const ExtimguishersScreen(),
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
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LaiFormPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Listado de A&I',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LaiScrem(
                        initialCompany: '',
                      ),
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
                  'Gestión de residuos',
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
                title: const Text('Carga de peligros y riesgos'),
                onTap: () {
                  // Aquí puedes definir la acción cuando se selecciona el segundo elemento del Drawer
                },
              ),
              ListTile(
                title: const Text('Carga de peligros y riesgos'),
                onTap: () {
                  // Aquí puedes definir la acción cuando se selecciona el segundo elemento del Drawer
                },
              ),
              ListTile(
                title: const Text('Huella de Carbono'),
                onTap: () {
                  // Aquí puedes definir la acción cuando se selecciona el segundo elemento del Drawer
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.nature_people, color: Colors.green), // Icono
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text(
                  'Huella de carbono',
                  style: TextStyle(
                    color: Colors.green, // Color del texto
                    fontWeight: FontWeight.normal, // Negrita
                    fontSize: 18, // Tamaño de letra
                  ),
                ),
              ],
            ),
            // Título del elemento desplegable
            children: [
              ListTile(
                title: const Text('Carga inicial de extintores'),
                onTap: () {
                  // Aquí puedes definir la acción cuando se selecciona el segundo elemento del Drawer
                },
              ),
              ListTile(
                title: const Text('Control de extintores'),
                onTap: () {
                  // Aquí puedes definir la acción cuando se selecciona el segundo elemento del Drawer
                },
              ),
              ListTile(
                title: const Text('Extadistica de extintores'),
                onTap: () {
                  // Aquí puedes definir la acción cuando se selecciona el segundo elemento del Drawer
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
