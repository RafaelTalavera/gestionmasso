import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../global/widgets/custom_AppBar.dart';
import '../sources/iper_table.dart';

class IperTable extends StatefulWidget {
  const IperTable({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IperTableState createState() => _IperTableState();
}

class _IperTableState extends State<IperTable> {
  late List<Iper> ipers;
  String? filtroEvaluacion;
  String? filtroPuesto;
  String? filtroArea;

  Color getColorForEvaluacion(String evaluacion) {
    switch (evaluacion.toLowerCase()) {
      case 'aceptable':
        return Colors.orange.shade50;
      case 'adecuado':
        return Colors.orange.shade50;
      case 'tolerable':
        return Colors.orange.shade100;
      case 'inaceptable':
        return Colors.orange.shade600;
      default:
        return Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();
    ipers = <Iper>[];
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/risk'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      ipers = jsonData.map((json) => Iper.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  List<Iper> get listaFiltrada {
    return ipers.where((iper) {
      bool cumpleFiltroEvaluacion =
          filtroEvaluacion == null || iper.evaluacion == filtroEvaluacion;
      bool cumpleFiltroPuesto =
          filtroPuesto == null || iper.puesto == filtroPuesto;
      bool cumpleFiltroArea = filtroArea == null || iper.area == filtroArea;

      return cumpleFiltroEvaluacion && cumpleFiltroPuesto && cumpleFiltroArea;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleWidget: Text(
          'Matriz IPER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 238, 183, 19),
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: ipers == null
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
                // Agregar filtros según sea necesario
                // Filtros en una tarjeta horizontal

                SingleChildScrollView(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // Cambiado de Row a Column
                          children: [
                            Row(
                              // Fila para los dos primeros filtros
                              children: [
                                const SizedBox(width: 20.0),
                                // Filtro por Evaluación
                                Flexible(
                                  child: DropdownButton<String>(
                                    value: filtroEvaluacion,
                                    hint: const Text('Evaluación'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        filtroEvaluacion = newValue;
                                      });
                                    },
                                    items: obtenerItemsFiltro('evaluacion'),
                                  ),
                                ),

                                const SizedBox(width: 110.0),
                                // Filtro por Puesto
                                Flexible(
                                  child: DropdownButton<String>(
                                    value: filtroPuesto,
                                    hint: const Text('Puesto'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        filtroPuesto = newValue;
                                      });
                                    },
                                    items: obtenerItemsFiltro('puesto'),
                                  ),
                                ),
                              ],
                            ),
                            // Filtro por Área debajo
                            DropdownButton<String>(
                              value: filtroArea,
                              hint: const Text('Área'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroArea = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('area'),
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
                      filtroEvaluacion = null;
                      filtroPuesto = null;
                      filtroArea = null;
                    });
                  },
                  child: const Text('Limpiar Filtros'),
                ),
                // Lista filtrada
                Expanded(
                  child: ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        color: getColorForEvaluacion(
                          listaFiltrada[index].evaluacion,
                        ),
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                  text: 'Evaluacion de riesgos: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextSpan(
                                  text: listaFiltrada[index].evaluacion,
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
                                      text: 'Puesto: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].puesto,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Área: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].area,
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
                                      text: 'Potencial Incidente: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index]
                                          .incidentesPotenciales,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Consecuencia: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].consecuencia,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Jerarquíadel control: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].clasificaMC,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Medida de control: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].medidaControl,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Tipo: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].tipo,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Fecha del análisis: ',
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

                              // Agrega más información según sea necesario
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

    for (var iper in ipers) {
      switch (tipoFiltro) {
        case 'area':
          valoresUnicos.add(iper.area);
          break;
        case 'puesto':
          valoresUnicos.add(iper.puesto);
          break;
        case 'evaluacion':
          valoresUnicos.add(iper.evaluacion);
          break;

        // Puedes agregar más casos según los filtros que necesites
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
