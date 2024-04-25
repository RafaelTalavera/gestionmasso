import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../organization/views/organization_form_view.dart';
import 'statistcs_table_total_screen_view.dart';

class StatistcsTotalOrgaSelectionScreen extends StatefulWidget {
  const StatistcsTotalOrgaSelectionScreen({Key? key});

  @override
  OrganizationSelectionScreenState createState() =>
      OrganizationSelectionScreenState();
}

class OrganizationSelectionScreenState
    extends State<StatistcsTotalOrgaSelectionScreen> {
  List<Map<String, String>> organizations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    String? token = await TokenManager.getToken();

    try {
      final url = Uri.parse('http://10.0.2.2:8080/api/organization');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // Otros encabezados si es necesario
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Map<String, String>> fetchedOrganizations = data.map((org) {
          return {
            'id': org['id'] as String,
            'name': org['name'] as String,
          };
        }).toList();

        setState(() {
          organizations = fetchedOrganizations;
          loading = false; // Indica que la carga ha terminado
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      print('Error fetching organizations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          ' Estadística',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Seleccione una organización para cargar el control de Accidentes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 80),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : organizations.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Primero debe dar de alta alguna organización',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrganizationFormPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.cyan.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13.0,
                                    vertical: 15.0,
                                  ),
                                ),
                                child: const Text('Agregar organización'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: organizations.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StatistcsTableTotal(
                                        organization: organizations[index]
                                            ['name']!,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.cyan.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13.0,
                                    vertical: 15.0,
                                  ),
                                ),
                                child: Text(organizations[index]['name']!),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
