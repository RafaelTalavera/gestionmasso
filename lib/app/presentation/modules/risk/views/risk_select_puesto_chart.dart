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
  PuestoSelectionScreenState createState() => PuestoSelectionScreenState();
}

class PuestoSelectionScreenState extends State<PuestoSelectionScreen> {
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
      } else {
        throw Exception(
            'Failed to load puestos for area ${widget.area} and organization ${widget.organization}');
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
          'En ${widget.area}',
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
          const Text('Seleccione un puesto:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              )),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
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
                              puestos[index],
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
