import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import 'consumo_selec_combustible.dart';

class ConsumoOrganizationSelectionScreen extends StatefulWidget {
  const ConsumoOrganizationSelectionScreen({super.key});

  @override
  OrganizationSelectionScreenState createState() =>
      OrganizationSelectionScreenState();
}

class OrganizationSelectionScreenState
    extends State<ConsumoOrganizationSelectionScreen> {
  List<String> organizations = [];
  bool loading = true; // Variable para controlar la carga de datos

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    String? token = await TokenManager.getToken();
    try {
      final url = Uri.parse('http://10.0.2.2:8080/api/consumo/organizations');
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
          loading = false; // Marcar la carga como completa
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      setState(() {
        loading =
            false; // Marcar la carga como completa incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          ' Consumo totales',
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
              'Seleccione una organización para ver la información',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: loading
                    ? const CircularProgressIndicator() // Muestra un indicador de carga mientras se obtienen los datos
                    : organizations.isEmpty
                        ? const Text(
                            'No hay registros asociados a organizaciones')
                        : ListView.builder(
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
                                        builder: (context) =>
                                            ConsumoCombutibleSelectionScreen(
                                          nameOrganization:
                                              organizations[index],
                                          organizationId: '',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.lightGreen.shade700,
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
          ],
        ),
      ),
    );
  }
}
