import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'risk_select_puesto_chart.dart'; // Importa la pantalla de selección de puestos

class AreaSelectionScreen extends StatefulWidget {
  const AreaSelectionScreen({Key? key, required this.organization});
  final String organization;

  @override
  AreaSelectionScreenState createState() => AreaSelectionScreenState();
}

class AreaSelectionScreenState extends State<AreaSelectionScreen> {
  List<String> areas = [];

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/risk/areas/${widget.organization}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<String> fetchedAreas = data.cast<String>();

        setState(() {
          areas = fetchedAreas;
        });
      } else {
        throw Exception(
            'Failed to load areas for organization: ${widget.organization}');
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
          'Areas de ${widget.organization}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Elija un área para ver las estadística',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: areas.isEmpty
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: areas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PuestoSelectionScreen(
                                    organization: widget.organization,
                                    area: areas[index],
                                    puesto: '',
                                  ),
                                ),
                              );
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
                            child: Text(
                              areas[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
