import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/risk_table_data.dart';
import 'risk_edit_view.dart';

class IperTable extends StatefulWidget {
  const IperTable({super.key, required String initialCompany});

  @override
  // ignore: library_private_types_in_public_api
  _IperTableState createState() => _IperTableState();
}

class _IperTableState extends State<IperTable> {
  late List<Risk> risks;
  String? filtroEvaluacion;
  String? filtroPuesto;
  String? filtroArea;
  String? filtroOrganizacion;

  Color getColorForEvaluacion(String evaluacion) {
    switch (evaluacion.toLowerCase()) {
      case 'aceptable':
        return Colors.orange.shade50;
      case 'adecuado':
        return Colors.orange.shade50;
      case 'tolerable':
        return Colors.orange.shade100;
      case 'inaceptable':
        return Colors.orange.shade200;
      default:
        return Colors.white;
    }
  }

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
    risks = <Risk>[];
    _loadInterstitialAd();
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse('http://10.0.2.2:8080/api/risk/list');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _showInterstitialAd();
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      risks = jsonData.map((json) => Risk.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  List<Risk> get listaFiltrada {
    return risks.where((risk) {
      bool cumpleFiltroEvaluacion =
          filtroEvaluacion == null || risk.evaluacion == filtroEvaluacion;
      bool cumpleFiltroPuesto =
          filtroPuesto == null || risk.puesto == filtroPuesto;
      bool cumpleFiltroArea = filtroArea == null || risk.area == filtroArea;
      bool cumpleFiltroOrganizacion = filtroOrganizacion == null ||
          risk.nameOrganization == filtroOrganizacion;

      return cumpleFiltroEvaluacion &&
          cumpleFiltroPuesto &&
          cumpleFiltroArea &&
          cumpleFiltroOrganizacion;
    }).toList();
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
      appBar: CustomAppBar(
        titleWidget: Text(
          'Matriz IPER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: risks == null
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
                            DropdownButton<String>(
                              value: filtroOrganizacion,
                              hint: const Text('Organización'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroOrganizacion = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('organizacion'),
                            ),
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
                      filtroOrganizacion = null;
                    });
                    _showInterstitialAd();
                  },
                  child: const Text('Limpiar Filtros'),
                ),
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
                                      text: 'Organization: ',
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
                                      text: 'Incidente potencial: ',
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
                                      text: 'Jerarquía del control: ',
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
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Fecha de revalidación: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: DateFormat('yyyy-MM-dd').format(
                                          listaFiltrada[index].dateOfRevision),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RiskEditScreen(
                                              iperId: listaFiltrada[index]
                                                  .id
                                                  .toString(),
                                              risk: listaFiltrada[index],
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.green,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                      child: const Text('Actualizar'),
                                    ),
                                  ),
                                ],
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

    for (var risk in risks) {
      switch (tipoFiltro) {
        case 'area':
          valoresUnicos.add(risk.area);
          break;
        case 'puesto':
          valoresUnicos.add(risk.puesto);
          break;
        case 'evaluacion':
          valoresUnicos.add(risk.evaluacion);
          break;
        case 'organizacion':
          valoresUnicos.add(risk.nameOrganization);
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
