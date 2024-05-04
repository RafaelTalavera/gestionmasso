import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../sources/lai_data_out.dart';
import 'package:http/http.dart' as http;

import 'lai_edit_view.dart';

class LaiScreen extends StatefulWidget {
  const LaiScreen({super.key, required String initialCompany});

  @override
  LaiTableState createState() => LaiTableState();
}

class LaiTableState extends State<LaiScreen> {
  late List<Lai> lais;
  String? filtroMeaningfulness;
  String? filtroCycle;
  String? filtroArea;
  String? filtroOrganization;

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
    _loadInterstitialAd();
    lais = <Lai>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();
    final url = Uri.parse('http://10.0.2.2:8080/api/lai/list');

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

      lais = jsonData.map((json) => Lai.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  List<Lai> get listaFiltrada {
    return lais.where((lai) {
      bool cumpleFiltroOrganizacion = filtroOrganization == null ||
          lai.nameOrganization == filtroOrganization;
      bool cumpleFiltroEvaluacion = filtroMeaningfulness == null ||
          lai.meaningfulness == filtroMeaningfulness;
      bool cumpleFiltroCycle = filtroCycle == null || lai.cycle == filtroCycle;
      bool cumpleFiltroArea = filtroArea == null || lai.area == filtroArea;

      return cumpleFiltroOrganizacion &&
          cumpleFiltroEvaluacion &&
          cumpleFiltroCycle &&
          cumpleFiltroArea;
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
          'Matriz LAI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: lais == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5.0),
                                    Flexible(
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DropdownButton<String>(
                                              value: filtroOrganization,
                                              hint: const Text('Organización'),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  filtroOrganization = newValue;
                                                });
                                              },
                                              items: obtenerItemsFiltro(
                                                  'organization'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Dos filtros compartiendo un renglón
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButton<String>(
                                      value: filtroCycle,
                                      hint: const Text('Ciclo de vida'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          filtroCycle = newValue;
                                        });
                                      },
                                      items: obtenerItemsFiltro('cycle'),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: DropdownButton<String>(
                                  value: filtroMeaningfulness,
                                  hint: const Text('Evaluación'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      filtroMeaningfulness = newValue;
                                    });
                                  },
                                  items: obtenerItemsFiltro('evaluacion'),
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    filtroMeaningfulness = null;
                                    filtroCycle = null;
                                    filtroArea = null;
                                    _showInterstitialAd();
                                  });
                                },
                                child: const Text('Limpiar Filtros'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      List<Widget> subtitleWidgets = [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Fecha del control: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: DateFormat('dd-MM-yyyy').format(
                                  listaFiltrada[index].date,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Organización: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].nameOrganization,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Ciclo de vida: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].cycle,
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                text: 'Tipo: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                text: 'Temporalidad: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].temporality,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Requisitos legales: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].legislation
                                    ? 'Si'
                                    : 'No',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Partes interesadas: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].stateHolder
                                    ? 'Si'
                                    : 'No',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Actividad: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].activity,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Aspecto: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].aspect,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Impacto: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].impact,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Tipo de medida de control: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].typeOfControl,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Descripción: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].description,
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: listaFiltrada[index].userId,
                              ),
                            ],
                          ),
                        ),
                      ];

                      if (listaFiltrada[index].dateOfRevision != null) {
                        subtitleWidgets.add(
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                  text: 'Fecha del control (Revisión): ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: DateFormat('dd-MM-yyyy').format(
                                    listaFiltrada[index].dateOfRevision!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        color: getColorForEvaluacion(
                          listaFiltrada[index].meaningfulness,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Significancia del impactos: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].meaningfulness,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: subtitleWidgets,
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
                                          builder: (context) => LaiEditScreen(
                                            laiId: listaFiltrada[index].id,
                                            lai: listaFiltrada[index],
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

    for (var lai in lais) {
      switch (tipoFiltro) {
        case 'area':
          valoresUnicos.add(lai.area);
          break;
        case 'cycle':
          valoresUnicos.add(lai.cycle);
          break;
        case 'evaluacion':
          valoresUnicos.add(lai.meaningfulness);
          break;
        case 'organization':
          valoresUnicos.add(lai.nameOrganization);
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
