import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import 'extimguisher_graphs_bar.dart';
import 'extimguisher_graphs_bar_enabled.dart';

class Empresa {
  Empresa(this.nombre);
  final String nombre;
}

class EmpresaSelectionScreen extends StatefulWidget {
  const EmpresaSelectionScreen({Key? key, this.initialCompany});
  final String? initialCompany;

  @override
  EmpresaSelectionScreenState createState() => EmpresaSelectionScreenState();
}

class EmpresaSelectionScreenState extends State<EmpresaSelectionScreen> {
  late List<Empresa> _empresas = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Selección',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: _empresas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text(
                          'Gráfico por vigencias',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListView(
                        shrinkWrap: true,
                        children: _empresas.map((empresa) {
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
                                    builder: (context) => ExtintorCharts(
                                      selectedCompany: empresa.nombre,
                                    ),
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
                              child: Text(empresa.nombre),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text(
                          'Gráficos de estado extintores',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListView(
                        shrinkWrap: true,
                        children: _empresas.map((empresa) {
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
                                    builder: (context) => ExtintorChartsEnabled(
                                      selectedCompany: empresa.nombre,
                                    ),
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
                              child: Text(empresa.nombre),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _fetchCompanies() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/extinguishers/companies'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final empresas =
          jsonData.map<Empresa>((empresa) => Empresa(empresa)).toList();
      setState(() {
        _empresas = empresas;
      });
    } else {
      throw Exception('Failed to load companies from backend');
    }
  }
}
