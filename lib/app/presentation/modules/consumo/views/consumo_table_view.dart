import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../sources/consumo_table_data.dart';
import 'consumo_edit_view.dart';

class ConsumoTable extends StatefulWidget {
  const ConsumoTable({
    super.key,
  });

  @override
  IperTableState createState() => IperTableState();
}

class IperTableState extends State<ConsumoTable> {
  late List<Consumo> consumos;
  String? filtroMes;
  String? filtroYear;
  String? filtroCombustible;
  String? filtroNameOrganizacion;
  String? filtroTipoFuente;

  @override
  void initState() {
    super.initState();
    consumos = <Consumo>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse('http://10.0.2.2:8080/api/consumo/list');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        // Otros encabezados si es necesario
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      consumos = jsonData.map((json) => Consumo.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  List<Consumo> get listaFiltrada {
    return consumos.where((consumo) {
      bool cumpleFiltroMes = filtroMes == null || consumo.mes == filtroMes;
      bool cumpleFiltroYear = filtroYear == null || consumo.year == filtroYear;
      bool cumpleFiltroCombustible =
          filtroCombustible == null || consumo.combustible == filtroCombustible;
      bool cumpleFiltroNameOrganizacion = filtroNameOrganizacion == null ||
          consumo.nameOrganization == filtroNameOrganizacion;
      bool cumpleFiltroTipoFuente =
          filtroTipoFuente == null || consumo.tipoFuente == filtroTipoFuente;

      return cumpleFiltroTipoFuente &&
          cumpleFiltroMes &&
          cumpleFiltroYear &&
          cumpleFiltroCombustible &&
          cumpleFiltroNameOrganizacion;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Listado de consumos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: consumos == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Filtros',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 20.0),
                                Flexible(
                                  child: DropdownButton<String>(
                                    value: filtroMes,
                                    hint: const Text('Mes'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        filtroMes = newValue;
                                      });
                                    },
                                    items: obtenerItemsFiltro('mes'),
                                  ),
                                ),
                                const SizedBox(width: 110.0),
                                Flexible(
                                  child: DropdownButton<String>(
                                    value: filtroYear,
                                    hint: const Text('Año'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        filtroYear = newValue;
                                      });
                                    },
                                    items: obtenerItemsFiltro('year'),
                                  ),
                                ),
                              ],
                            ),
                            DropdownButton<String>(
                              value: filtroCombustible,
                              hint: const Text('Combustible'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroCombustible = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('combustible'),
                            ),
                            DropdownButton<String>(
                              value: filtroNameOrganizacion,
                              hint: const Text('Organización'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroNameOrganizacion = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('organization'),
                            ),
                            DropdownButton<String>(
                              value: filtroTipoFuente,
                              hint: const Text('Fuente'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroTipoFuente = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('tipoFuente'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filtroMes = null;
                      filtroYear = null;
                      filtroCombustible = null;
                      filtroNameOrganizacion = null;
                      filtroTipoFuente = null;
                    });
                  },
                  child: const Text('Limpiar Filtros'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: listaFiltrada[index].tipoFuente,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Organización: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          listaFiltrada[index].nameOrganization,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Fecha del registro: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: DateFormat('yyyy-MM-dd')
                                          .format(listaFiltrada[index].date),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Mes: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].mes,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Año: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          listaFiltrada[index].year.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Fuente: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].fuente,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Tipo de fuente: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].tipoFuente,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Combustible: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].combustible,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Unidad: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].unidad,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Consumo: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index]
                                          .consumo
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Usuario: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].userId,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConsumoEditScreen(
                                          consumoId: listaFiltrada[index].id,
                                          consumo: listaFiltrada[index],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  child: const Text('Actualizar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  List<DropdownMenuItem<String>> obtenerItemsFiltro(String tipoFiltro) {
    Set<String> valoresUnicos = {};

    for (var consumo in consumos) {
      switch (tipoFiltro) {
        case 'mes':
          valoresUnicos.add(consumo.mes);
          break;
        case 'year':
          valoresUnicos.add(consumo.year as String);
          break;
        case 'combustible':
          valoresUnicos.add(consumo.combustible);
          break;
        case 'organization':
          valoresUnicos.add(consumo.nameOrganization);
          break;
        case 'tipoFuente':
          valoresUnicos.add(consumo.tipoFuente);
          break;
      }
    }

    return valoresUnicos
        .map((valor) => DropdownMenuItem<String>(
              value: valor,
              child: Text(valor),
            ))
        .toList();
  }
}
