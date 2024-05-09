// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
// ignore: library_prefixes
import 'package:pdf/widgets.dart' as pdfLib;
//import 'package:share_extend/share_extend.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../../global/widgets/pdf_view.dart';
import '../sources/lai_data_out.dart';
import 'package:http/http.dart' as http;

import 'lai_edit_view.dart';

class LaiScreen extends StatefulWidget {
  const LaiScreen({super.key, required this.nameOrganization});

  final String nameOrganization;

  @override
  LaiTableState createState() => LaiTableState();
}

class LaiTableState extends State<LaiScreen> {
  List<Lai> lais = [];
  String? filtroMeaningfulness;
  String? filtroCycle;
  String? filtroArea;

  final String interstitialAdUnitId =
      Platform.isAndroid ? '' : 'ca-app-pub-3940256099942544/1033173712';

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
    if (evaluacion != null) {
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
    return Colors
        .white; // Otra acción por defecto en caso de que evaluacion sea nulo
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
    final url = Uri.parse(
        'http://10.0.2.2:8080/api/lai/organization/${widget.nameOrganization}');

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
      bool cumpleFiltroEvaluacion = filtroMeaningfulness == null ||
          lai.meaningfulness == filtroMeaningfulness;
      bool cumpleFiltroCycle = filtroCycle == null || lai.cycle == filtroCycle;
      bool cumpleFiltroArea = filtroArea == null || lai.area == filtroArea;

      return cumpleFiltroEvaluacion && cumpleFiltroCycle && cumpleFiltroArea;
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
      body: lais.isEmpty // Agregar verificación para lista vacía
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _createPDF(lais);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf,
                              color: Colors.red), // Icono de PDF
                          SizedBox(
                              width: 8), // Espacio entre el icono y el texto
                          Text('Crear informe en PDF'), // Texto del botón
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        children: [
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
                            padding: const EdgeInsets.only(bottom: 5.0),
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
                const SizedBox(height: 10),
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
                                text: DateFormat('dd-MM-yyyy')
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

  _createPDF(lais) async {
    final pdfLib.Document pdf = pdfLib.Document();

    String fechaActual = DateFormat('dd-MM-yyyy').format(DateTime.now());

    var fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    var font = pdfLib.Font.ttf(fontData);

    final organizationName = lais.isNotEmpty ? lais.first.nameOrganization : '';

    final userName = lais.isNotEmpty ? lais.first.userId : '';

    final Uint8List imageData =
        (await rootBundle.load('assets/imagen/gmasso.png'))
            .buffer
            .asUint8List();

    ui.Codec codec = await ui.instantiateImageCodec(imageData);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    int imageWidth = frameInfo.image.width;
    int imageHeight = frameInfo.image.height;

    pdf.addPage(
      pdfLib.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginLeft: 10.0,
          marginRight: 10.0,
          marginTop: 40.0,
          marginBottom: 10.0,
        ),
        header: (context) {
          // Encabezado de la página
          return pdfLib.Container(
            alignment: pdfLib.Alignment.centerRight,
            margin: const pdfLib.EdgeInsets.only(top: 30.0, bottom: 20.0),
            padding: const pdfLib.EdgeInsets.only(bottom: 3.0),
            decoration: const pdfLib.BoxDecoration(
              border: pdfLib.Border(
                bottom: pdfLib.BorderSide(
                  color: PdfColors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                pdfLib.Column(
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                  children: [
                    pdfLib.Text(
                      'Listado de Aspecto e Impactos',
                      style: pdfLib.TextStyle(
                        font: font,
                        fontSize: 12.0,
                      ),
                    ),
                    pdfLib.Text(
                      'Organización: $organizationName',
                      style: pdfLib.TextStyle(
                        font: font,
                        fontSize: 10.0,
                      ),
                    ),
                    pdfLib.Text(
                      'Usuario: $userName',
                      style: pdfLib.TextStyle(
                        font: font,
                        fontSize: 10.0,
                      ),
                    ),
                    pdfLib.Text(
                      'Fecha del Informe: $fechaActual',
                      style: pdfLib.TextStyle(
                        font: font,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                pdfLib.Image(
                  pdfLib.MemoryImage(imageData),
                  width: imageWidth * 0.08,
                  height: imageHeight * 0.08,
                )
              ],
            ),
          );
        },
        footer: (context) {
          // Footer de la página
          return pdfLib.Container(
            alignment: pdfLib.Alignment.center,
            margin: const pdfLib.EdgeInsets.only(top: 20),
            child: pdfLib.Text(
              'Idea y desarrollo axiomasolucionesintegrales@gmail.com',
              style:
                  const pdfLib.TextStyle(fontSize: 8, color: PdfColors.black),
            ),
          );
        },
        build: (context) => [
          // Contenido de la página
          pdfLib.Table(
            border: pdfLib.TableBorder.all(),
            children: <pdfLib.TableRow>[
              pdfLib.TableRow(
                children: <pdfLib.Widget>[
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('tipo',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Aspecto',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Impacto',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Significancia',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Medida de control',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Revisión',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                ],
              ),
              for (var data in lais)
                pdfLib.TableRow(
                  children: <pdfLib.Widget>[
                    // Tipo
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.tipo,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // aspect
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.aspect,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Impact
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.impact,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // valoración
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.meaningfulness,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Medida de control
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.descriptionOfControl,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Vencimiento
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(
                          DateFormat('dd-MM-yyyy').format(data.dateOfRevision),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );

    print('PDF creado exitosamente.');

    // Generar un nombre de archivo único usando la fecha y la hora actual
    final String timestamp =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String fileName = 'pdf_$timestamp.pdf';
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$fileName';

    // Guardar el PDF con el nombre de archivo único
    final File file = File(path);
    final Uint8List pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes.toList());

    // Abrir la vista previa del PDF
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewPdf(path)),
    );
  }
}
