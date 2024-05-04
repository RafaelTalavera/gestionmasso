// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import 'risk_select_area._chart.dart';

class OrganizationSelectionScreen extends StatefulWidget {
  const OrganizationSelectionScreen({Key? key});

  @override
  OrganizationSelectionScreenState createState() =>
      OrganizationSelectionScreenState();
}

class OrganizationSelectionScreenState
    extends State<OrganizationSelectionScreen> {
  List<String> organizations = [];

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    String? token = await TokenManager.getToken();

    try {
      final url =
          await Uri.parse('http://10.0.2.2:8080/api/risk/organizations');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // Otros encabezados si es necesario
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> fetchedOrganizations = data.cast<String>();

        setState(() {
          organizations = fetchedOrganizations;
        });
      } else {
        throw Exception('Failed to load organizations');
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          ' Peligros y Riesgos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Column(
        children: [
          if (organizations.isNotEmpty) ...[
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Seleccione una organización para ver la información',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
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
                              builder: (context) => AreaSelectionScreen(
                                  organization: organizations[index]),
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
                        child: Text(organizations[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'No hay organizaciones para mostrar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
