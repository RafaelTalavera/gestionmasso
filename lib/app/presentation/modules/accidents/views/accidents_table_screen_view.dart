import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../sources/accidents_table_data.dart';

class AccidentsTable extends StatefulWidget {
  const AccidentsTable({
    super.key,
    required this.organization,
  });

  final String organization;

  @override
  // ignore: library_private_types_in_public_api
  _IperTableState createState() => _IperTableState();
}

class _IperTableState extends State<AccidentsTable> {
  late List<Accidents> accidents;
  String? filtroAlta;
  String? filtroArea;
  String? filtroPuesto;
  String? filtroSeverity;
  String? filtroNameOrganization;

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
    accidents = <Accidents>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/accidents/organization/${widget.organization}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _loadInterstitialAd();
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      accidents = jsonData.map((json) => Accidents.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  Future<void> _showDatePickerDialog(Accidents accident) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: accident.dateAlta ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (selectedDate != null) {
      setState(() {
        accident.dateAlta = selectedDate;
      });
      await _updateAccidentDateAlta(accident.id, selectedDate);
      await fetchData();
    }
  }

  Future<void> _updateAccidentDateAlta(
      String accidentId, DateTime dateAlta) async {
    String? token = await TokenManager.getToken();
    final url =
        Uri.parse('http://10.0.2.2:8080/api/accidents/$accidentId/dateAlta');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'dateAlta': DateFormat('yyyy-MM-dd').format(dateAlta)}),
    );
    if (response.statusCode == 200) {
      _showInterstitialAd();
    } else {
      throw Exception('Error al actualizar la fecha de alta');
    }
  }

  List<Accidents> get listaFiltrada {
    return accidents.where((accidets) {
      // ignore: unrelated_type_equality_checks
      bool cumpleFiltroAlta = filtroAlta == null ||
          (filtroAlta == 'Si' && accidets.alta) ||
          (filtroAlta == 'No' && !accidets.alta);
      bool cumpleFiltroArea = filtroArea == null || accidets.area == filtroArea;
      bool cumpleFiltroPuesto =
          filtroPuesto == null || accidets.puesto == filtroPuesto;
      bool cumpleFiltroSeverity =
          filtroSeverity == null || accidets.severity == filtroSeverity;
      bool cumpleFiltroNameOrganization = filtroNameOrganization == null ||
          accidets.nameOrganization == filtroNameOrganization;

      return cumpleFiltroAlta &&
          cumpleFiltroArea &&
          cumpleFiltroPuesto &&
          cumpleFiltroSeverity &&
          cumpleFiltroNameOrganization;
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
          'Listado de accidentes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: accidents == null
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
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch, // Alinear los elementos al inicio
                          children: [
                            const SizedBox(
                                height: 5.0), // Espacio entre los filtros
                            DropdownButton<String>(
                              value: filtroAlta,
                              hint: const Text('¿Tiene el alta?'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroAlta = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('alta'),
                            ),
                            const SizedBox(
                                height: 5.0), // Espacio entre los filtros
                            DropdownButton<String>(
                              value: filtroPuesto,
                              hint: const Text('Puesto'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filtroPuesto = newValue;
                                });
                              },
                              items: obtenerItemsFiltro('puesto'),
                            ),
                            const SizedBox(
                                height: 5.0), // Espacio entre los filtros
                            DropdownButton<String>(
                              value: filtroArea,
                              hint: const Text('Area'),
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
                      filtroAlta = null;
                      filtroArea = null;
                      filtroPuesto = null;
                      filtroSeverity = null;
                      filtroNameOrganization = null;
                      _showInterstitialAd(); // Llamar a _showInterstitialAd() aquí
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
                                const TextSpan(
                                  text: 'Organización: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextSpan(
                                  text: listaFiltrada[index].nameOrganization,
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
                                      text: 'Nombre: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].name,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Clasificación: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].severity,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Dias Perdidos: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index]
                                          .lostDay
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
                                      text: 'Alta: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].alta
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
                                      text: 'Fecha del accidente: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: DateFormat('yyyy-MM-dd').format(
                                          listaFiltrada[index].dateEvent),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Fecha de alta: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: listaFiltrada[index].dateAlta !=
                                              null
                                          ? DateFormat('yyyy-MM-dd').format(
                                              listaFiltrada[index].dateAlta!)
                                          : 'Sin fecha de alta', // Puedes cambiar el texto para manejar el caso nulo
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
                                        _showDatePickerDialog(
                                            listaFiltrada[index]);
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
                                      child: const Text('Actualizar Alta'),
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

    for (var acc in accidents) {
      switch (tipoFiltro) {
        case 'alta':
          valoresUnicos.add(acc.alta ? 'Si' : 'No');
          break;
        case 'area':
          valoresUnicos.add(acc.area);
          break;
        case 'puesto':
          valoresUnicos.add(acc.puesto);
          break;
        case 'severity':
          valoresUnicos.add(acc.severity);
          break;
        case 'nameOrganization':
          valoresUnicos.add(acc.nameOrganization);
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
