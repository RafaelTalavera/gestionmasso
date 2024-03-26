// En RiskSelectionScreen.dart

import 'package:flutter/material.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'risk_chart_view.dart';
import '../sources/list_risk.dart';

class RiskSelectionScreen extends StatefulWidget {
  @override
  _RiskSelectionScreenState createState() => _RiskSelectionScreenState();
}

class _RiskSelectionScreenState extends State<RiskSelectionScreen> {
  String? _selectedArea;
  String? _selectedPosition;

  final List<String> areas = ListDropdownRisk.areas;
  final List<String> positions = ListDropdownRisk.puesto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleWidget: Text(
          'Seleccion de campos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 238, 183, 19),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Selecciona un área:'),
            DropdownButton<String>(
              value: _selectedArea,
              onChanged: (value) {
                setState(() {
                  _selectedArea = value;
                });
              },
              items: areas.map((String area) {
                return DropdownMenuItem<String>(
                  value: area,
                  child: Text(area),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Selecciona un puesto:'),
            DropdownButton<String>(
              value: _selectedPosition,
              onChanged: (value) {
                setState(() {
                  _selectedPosition = value;
                });
              },
              items: positions.map((String position) {
                return DropdownMenuItem<String>(
                  value: position,
                  child: Text(position),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedArea != null && _selectedPosition != null) {
                  String url =
                      'http://localhost:8080/api/risk/countEvaluacion?area=$_selectedArea&puesto=$_selectedPosition';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RiskCharts(
                        selectedCompany: '',
                        selectedUrl: url,
                        selectedArea: _selectedArea,
                        selectedPosition: _selectedPosition,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content:
                            Text('Por favor selecciona un área y un puesto.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Generar Gráficos'),
            ),
          ],
        ),
      ),
    );
  }
}
