// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'extimguisher_graphs_bar.dart';
import 'extimguisher_graphs_bar_enabled.dart';

class Empresa {
  final String nombre;

  Empresa(this.nombre);
}

class EmpresaSelectionScreen extends StatefulWidget {
  final String? initialCompany;

  const EmpresaSelectionScreen({Key? key, this.initialCompany})
      : super(key: key);

  @override
  _EmpresaSelectionScreenState createState() => _EmpresaSelectionScreenState();
}

class _EmpresaSelectionScreenState extends State<EmpresaSelectionScreen> {
  late List<Empresa> _empresas = [];
  String? _selectedCompany;

  @override
  void initState() {
    super.initState();
    _selectedCompany = widget.initialCompany;
    _fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Empresa'),
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
                          return ListTile(
                            title: Text(empresa.nombre),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExtintorCharts(
                                    selectedCompany: empresa.nombre,
                                  ),
                                ),
                              );
                            },
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
                          return ListTile(
                            title: Text(empresa.nombre),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExtintorChartsEnabled(
                                    selectedCompany: empresa.nombre,
                                  ),
                                ),
                              );
                            },
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
