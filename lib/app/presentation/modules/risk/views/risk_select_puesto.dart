import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'risk_chart_evaluacion_view.dart';

class PuestoSelectionScreen extends StatefulWidget {
  const PuestoSelectionScreen({
    super.key,
    required this.organization,
    required this.area,
    required String puesto,
  });
  final String organization;
  final String area;

  @override
  _PuestoSelectionScreenState createState() => _PuestoSelectionScreenState();
}

class _PuestoSelectionScreenState extends State<PuestoSelectionScreen> {
  List<String> puestos = [];

  @override
  void initState() {
    super.initState();
    _fetchPuestos();
  }

  Future<void> _fetchPuestos() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/risk/puestos/${widget.organization}/${widget.area}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<String> fetchedPuestos = data.cast<String>();

        setState(() {
          puestos = fetchedPuestos;
        });

        // Imprimir por consola los puestos recibidos del backend
        print(
            'Puestos recibidos para el área ${widget.area} y la organización ${widget.organization}:');
        print(puestos);
      } else {
        throw Exception(
            'Failed to load puestos for area ${widget.area} and organization ${widget.organization}');
      }
    } catch (e) {
      print('Error fetching puestos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);

    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'En ${widget.area}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Center(
        child: puestos.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: puestos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RiskCharts(
                              selectedCompany: widget.organization,
                              selectedArea: widget.area,
                              selectedPosition: puestos[index],
                              selectedUrl: '',
                            ),
                          ),
                        );
                      },
                      child: Text(puestos[index]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
