// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/risk_data_graphs.dart';
import 'risk_form_views.dart';

class RiskCharts extends StatefulWidget {
  const RiskCharts({
    super.key,
    required this.selectedCompany,
    required this.selectedUrl,
    required this.selectedArea,
    required this.selectedPosition,
  });
  final String selectedCompany;
  final String selectedUrl;
  final String? selectedArea;
  final String? selectedPosition;

  @override
  _RiskChartsState createState() => _RiskChartsState();
}

class _RiskChartsState extends State<RiskCharts> {
  late List<RiskData> _riskList = [];
  late String _selectedCompany;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.selectedCompany, widget.selectedArea ?? '',
        widget.selectedPosition ?? '');
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Graficos de Riesgos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: _riskList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: _buildCharts(),
              ),
            ),
    );
  }

  List<Widget> _buildCharts() {
    List<Widget> charts = [];
    final groupedData = _groupDataBySector(_riskList);

    groupedData.forEach((sector, sectorData) {
      charts.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Estado - $sector',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: _buildPieChart(sectorData),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildReferenceTable(sectorData),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return charts;
  }

  Widget _buildPieChart(List<RiskData> sectorData) {
    Map<String, double> categoryValues = {
      'Aceptable': 0.0,
      'Adecuado': 0.0,
      'Tolerable': 0.0,
      'Inaceptable': 0.0,
    };

    // Calcular valores para cada categoría
    for (final data in sectorData) {
      categoryValues['Aceptable'] ??= 0;
      categoryValues['Adecuado'] ??= 0;
      categoryValues['Tolerable'] ??= 0;
      categoryValues['Inaceptable'] ??= 0;

      categoryValues['Aceptable'] =
          (categoryValues['Aceptable'] ?? 0) + (data.aceptable);
      categoryValues['Adecuado'] =
          (categoryValues['Adecuado'] ?? 0) + (data.adecuado);
      categoryValues['Tolerable'] =
          (categoryValues['Tolerable'] ?? 0) + (data.tolerable);
      categoryValues['Inaceptable'] =
          (categoryValues['Inaceptable'] ?? 0) + (data.inaceptable);
    }

    List<PieChartSectionData> sections = [];
    categoryValues.forEach((category, value) {
      // Agregar secciones al gráfico de tortas
      if (value > 0) {
        sections.add(PieChartSectionData(
          value: value,
          color: _getColorForCategory(category),
          title: category,
        ));
      }
    });

    return PieChart(
      PieChartData(
        sections: sections,
      ),
    );
  }

  Widget _buildReferenceTable(List<RiskData> sectorData) {
    int totalAceptable = _calculateTotalAceptable(sectorData);
    int totalAdecuado = _calculateTotalAdecuados(sectorData);
    int totalTolerable = _calculateTotalTorelable(sectorData);
    int totalInaceptable = _calculateTotalInaceptable(sectorData);
    int total =
        totalAceptable + totalAdecuado + totalTolerable + totalInaceptable;

    return DataTable(
      columns: const [
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('Cantidad')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('Aceptable')),
          DataCell(Text(totalAceptable.toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text('Adecuado')),
          DataCell(Text(totalAdecuado.toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text('Tolerable')),
          DataCell(Text(totalTolerable.toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text('Inaceptable')),
          DataCell(Text(totalInaceptable.toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text('Total')),
          DataCell(Text(total.toString())),
        ]),
      ],
    );
  }

  int _calculateTotalAceptable(List<RiskData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.aceptable;
    }
    return total;
  }

  int _calculateTotalAdecuados(List<RiskData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.adecuado;
    }
    return total;
  }

  int _calculateTotalTorelable(List<RiskData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.tolerable;
    }
    return total;
  }

  int _calculateTotalInaceptable(List<RiskData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.inaceptable;
    }
    return total;
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Aceptable':
        return Colors.green;
      case 'Adecuado':
        return Colors.blue;
      case 'Tolerable':
        return Colors.yellow;
      case 'Inaceptable':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _fetchData(String? selectedCompany, String? selectedArea,
      String? selectedPosition) async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8080/api/risk/countEvaluacion?nameOrganization=$selectedCompany&area=$selectedArea&puesto=$selectedPosition'),
    );
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = json.decode(responseBody);

      if (jsonData.isEmpty) {
        // Mostrar el diálogo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No hay datos para esta selección'),
              content: const Text('Seleccione una selección diferente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                  },
                  child: const Text('Volver Atrás'),
                ),
              ],
            );
          },
        );
        return;
      }

      List<RiskData> riskDataList = [];

      jsonData.forEach((key, value) {
        // Obtener los valores de cada estado
        int aceptable = value['Aceptable'] ?? 0;
        int adecuado = value['Adecuado'] ?? 0;
        int tolerable = value['Tolerable'] ?? 0;
        int inaceptable = value['Inaceptable'] ?? 0;

        // Calcular el total sumando los valores de cada estado
        int total = aceptable + adecuado + tolerable + inaceptable;

        // Crear instancias de RiskData y agregarlas a la lista
        riskDataList.add(RiskData(
          organization: key.split(" - ")[0],
          area: key.split(" - ")[1],
          puesto: key.split(" - ")[2],
          aceptable: aceptable,
          adecuado: adecuado,
          tolerable: tolerable,
          inaceptable: inaceptable,
          count: total,
        ));
      });

      setState(() {
        _riskList = riskDataList;
      });
    } else {
      throw Exception('Failed to load data from backend');
    }
  }

  double verificarValor(double valor) {
    if (valor != null && valor.isFinite && !valor.isNaN) {
      return valor;
    } else {
      return 0.0;
    }
  }

  Map<String, List<RiskData>> _groupDataBySector(List<RiskData> riskDataList) {
    final Map<String, List<RiskData>> groupedData = {};

    for (final riskData in riskDataList) {
      if (!groupedData.containsKey(riskData.area)) {
        groupedData[riskData.area] = [];
      }
      groupedData[riskData.area]!.add(riskData);
    }

    return groupedData;
  }

  void _navigateToCompanySelection(BuildContext context) async {
    final selectedCompany = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => RiskPage(
          initialCompany: _selectedCompany,
          id: '',
          name: '',
        ),
      ),
    );
    if (selectedCompany != null) {
      setState(() {
        _selectedCompany = selectedCompany;
      });

      if (widget.selectedCompany != null &&
          widget.selectedArea != null &&
          widget.selectedPosition != null) {
        _fetchData(widget.selectedCompany, widget.selectedArea!,
            widget.selectedPosition!);
      } else {}
    }
  }
}
