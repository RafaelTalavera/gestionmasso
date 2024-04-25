// ignore_for_file: unnecessary_null_comparison, unused_element

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../../global/widgets/custom_drawer.dart';
import '../sources/lai_data_graphs.dart';
import '../sources/lai_data_out.dart';
import 'lai_select_area.dart';

class LaiCharts extends StatefulWidget {
  const LaiCharts({
    super.key,
    required this.nameOrganization,
    required this.selectedUrl,
    required this.selectedArea,
  });
  final String nameOrganization;
  final String selectedUrl;
  final String? selectedArea;

  @override
  LaiChartsState createState() => LaiChartsState();
}

class LaiChartsState extends State<LaiCharts> {
  late List<Lai> _laiList = [];
  late String _selectedArea;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.nameOrganization, widget.selectedArea ?? '');
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        titleWidget: Text(
          'Graficos de Aspectos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: _laiList.isEmpty
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
    final groupedData = _groupDataBySector(_laiList.cast<LaiData>());

    groupedData.forEach((area, areaData) {
      charts.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Estado - $area',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: _buildPieChart(areaData.cast<LaiData>()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildReferenceTable(areaData),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return charts;
  }

  Widget _buildPieChart(List<LaiData> sectorData) {
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

  Widget _buildReferenceTable(List<LaiData> sectorData) {
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

  int _calculateTotalAceptable(List<LaiData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.aceptable;
    }
    return total;
  }

  int _calculateTotalAdecuados(List<LaiData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.adecuado;
    }
    return total;
  }

  int _calculateTotalTorelable(List<LaiData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.tolerable;
    }
    return total;
  }

  int _calculateTotalInaceptable(List<LaiData> sectorData) {
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
        return Colors.grey; // o cualquier otro color por defecto
    }
  }

  Future<void> _fetchData(
      String selectedOrganization, String? selectedArea) async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8080/api/lai/countMeaningfulness?nameOrganization=$selectedOrganization&area=$selectedArea'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData.isEmpty) {
        // Mostrar el diálogo
        // ignore: use_build_context_synchronously
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

      List<LaiData> laiDataList = [];

      jsonData.forEach((key, value) {
        // Obtener los valores de cada estado
        int aceptable = value['Aceptable'] ?? 0;
        int adecuado = value['Adecuado'] ?? 0;
        int tolerable = value['Tolerable'] ?? 0;
        int inaceptable = value['Inaceptable'] ?? 0;

        // Calcular el total sumando los valores de cada estado
        int total = aceptable + adecuado + tolerable + inaceptable;

        // Crear instancias de RiskData y agregarlas a la lista
        laiDataList.add(LaiData(
          nameOrganization: key.split(" - ")[0],
          area: key.split(" - ")[1],
          aceptable: aceptable,
          adecuado: adecuado,
          tolerable: tolerable,
          inaceptable: inaceptable,
          count: total,
        ));
      });

      setState(() {
        _laiList = laiDataList.cast<Lai>();
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

  Map<String, List<LaiData>> _groupDataBySector(List<LaiData> laiDataList) {
    final Map<String, List<LaiData>> groupedData = {};

    for (final laiData in laiDataList) {
      if (!groupedData.containsKey(laiData.area)) {
        groupedData[laiData.area] = [];
      }
      groupedData[laiData.area]!.add(laiData);
    }

    return groupedData;
  }

  void _navigateToCompanySelection(BuildContext context) async {
    final selectedOrganization = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const LaiAreaSelectionScreen(
          nameOrganization: '',
        ),
      ),
    );
    if (selectedOrganization != null) {
      if (_selectedArea != null) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaiCharts(
              nameOrganization:
                  selectedOrganization, // Aquí proporciona un valor para initialCompany
              selectedUrl: '',
              selectedArea: _selectedArea,
            ),
          ),
        );
        _fetchData(selectedOrganization, _selectedArea);
      } else {}
    }
  }
}
