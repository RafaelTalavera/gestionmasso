// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../global/utils/caculate_font_sise.dart';

import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import '../sources/extintor_data_graphs.dart';
import 'extimguisher_organization_selection_chart_view.dart';

class ExtintorChartsEnabled extends StatefulWidget {
  const ExtintorChartsEnabled({super.key, required this.selectedCompany});
  final String selectedCompany;

  @override
  ExtintorChartsState createState() => ExtintorChartsState();
}

class ExtintorChartsState extends State<ExtintorChartsEnabled> {
  late List<ExtintorData> _extintorDataList = [];
  late String _selectedCompany;

  final String interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _selectedCompany = widget.selectedCompany;
    _fetchData(_selectedCompany);
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gráficos de Extintores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.business),
            onPressed: () {
              _navigateToCompanySelection(context);
            },
          ),
        ],
      ),
      body: _extintorDataList.isEmpty
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
    final groupedData = _groupDataBySector(_extintorDataList);

    groupedData.forEach((sector, sectorData) {
      charts.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Gráfico de Extintores - $sector',
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

  Widget _buildPieChart(List<ExtintorData> sectorData) {
    List<PieChartSectionData> sections = [];
    for (final data in sectorData) {
      sections.add(PieChartSectionData(
        value: verificarValor(data.habilitados.toDouble()),
        color: Colors.green,
        title: 'En servicio',
      ));
      sections.add(PieChartSectionData(
        value: verificarValor(data.deshabilitados.toDouble()),
        color: Colors.red,
        title: 'Fuera de servicio',
      ));
    }
    return PieChart(
      PieChartData(
        sections: sections,
      ),
    );
  }

  Widget _buildReferenceTable(List<ExtintorData> sectorData) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('Cantidad')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('En servicio')),
          DataCell(Text(_calculateTotalHabilitados(sectorData).toString())),
        ]),
        DataRow(cells: [
          const DataCell(Text('Fuera de servicio')),
          DataCell(Text(_calculateTotalDeshabilitados(sectorData).toString())),
        ]),
      ],
    );
  }

  int _calculateTotalHabilitados(List<ExtintorData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.habilitados;
    }
    return total;
  }

  int _calculateTotalDeshabilitados(List<ExtintorData> sectorData) {
    int total = 0;
    for (final data in sectorData) {
      total += data.deshabilitados;
    }
    return total;
  }

  Future<void> _fetchData(String company) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/extinguishers/$company'),
    );
    if (response.statusCode == 200) {
      _showInterstitialAd();
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _extintorDataList =
            jsonData.map((json) => ExtintorData.fromJson(json)).toList();
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

  Map<String, List<ExtintorData>> _groupDataBySector(
      List<ExtintorData> extintorDataList) {
    final Map<String, List<ExtintorData>> groupedData = {};
    for (var data in extintorDataList) {
      if (!groupedData.containsKey(data.sector)) {
        groupedData[data.sector] = [];
      }
      groupedData[data.sector]!.add(data);
    }
    return groupedData;
  }

  void _navigateToCompanySelection(BuildContext context) async {
    final selectedCompany = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const EmpresaSelectionScreen(),
      ),
    );
    if (selectedCompany != null) {
      setState(() {
        _selectedCompany = selectedCompany;
      });
      _fetchData(selectedCompany);
    }
  }
}
