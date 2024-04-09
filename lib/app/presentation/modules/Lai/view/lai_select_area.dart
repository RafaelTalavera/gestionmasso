import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'lai_chart_meaningfulness_view.dart';

class LaiAreaSelectionScreen extends StatefulWidget {
  const LaiAreaSelectionScreen({super.key, required this.organization});
  final String organization;

  @override
  LaiAreaSelectionScreenState createState() => LaiAreaSelectionScreenState();
}

class LaiAreaSelectionScreenState extends State<LaiAreaSelectionScreen> {
  List<String> areas = [];

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/lai/areas/${widget.organization}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<String> fetchedAreas = data.cast<String>();

        setState(() {
          areas = fetchedAreas;
        });

        // Imprimir por consola las áreas recibidas del backend
        print('Áreas recibidas para la organización ${widget.organization}:');
        print(areas);
      } else {
        throw Exception(
            'Failed to load areas for organization: ${widget.organization}');
      }
    } catch (e) {
      print('Error fetching areas: $e');
    }
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
          const SizedBox(height: 10),
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
                              // Navega a la pantalla de selección de puestos con la organización y el área seleccionados
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LaiCharts(
                                    selectedCompany: widget.organization,
                                    selectedArea: areas[index],
                                  ),
                                ),
                              );
                            },
                            child: Text(areas[index]),
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
