import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
// ignore: library_prefixes
import 'package:pdf/widgets.dart' as pdfLib;
//import 'package:share_extend/share_extend.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/risk_table_data.dart';

import '../../../global/widgets/pdf_view.dart';
import 'risk_edit_view.dart';

class IperTable extends StatefulWidget {
  const IperTable(
      {super.key, required this.organization, required String initialCompany});
  final String organization;

  @override
  IperTableState createState() => IperTableState();
}

class IperTableState extends State<IperTable> {
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

  @override
  void initState() {
    super.initState();
    risks = <Risk>[];
    _loadInterstitialAd();
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/risk/organization/${widget.organization}');

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

      return cumpleFiltroEvaluacion && cumpleFiltroPuesto && cumpleFiltroArea;
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _createPDF(listaFiltrada);
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
      }
    }

    return valoresUnicos
        .map((valor) => DropdownMenuItem<String>(
              value: valor,
              child: Text(valor),
            ))
        .toList();
  }

  _createPDF(listaFiltrada) async {
    final pdfLib.Document pdf = pdfLib.Document();

    String fechaActual = DateFormat('dd-MM-yyyy').format(DateTime.now());

    var fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    var font = pdfLib.Font.ttf(fontData);

    final organizationName =
        listaFiltrada.isNotEmpty ? listaFiltrada.first.nameOrganization : '';

    final userName = listaFiltrada.isNotEmpty ? listaFiltrada.first.userId : '';

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
                      'Informe de Riesgos',
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
                    child: pdfLib.Text('Evaluación',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Puesto',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Área',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    width: 100,
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Incidente potencial',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    width: 100,
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Consecuencia',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    width: 170,
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Medida de control',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Tipo',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                  pdfLib.Container(
                    margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: pdfLib.Text('Revalidación',
                        style: pdfLib.TextStyle(
                          font: font,
                          fontSize: 9.0,
                          fontWeight: pdfLib.FontWeight.bold,
                        )),
                  ),
                ],
              ),
              for (var risk in listaFiltrada)
                pdfLib.TableRow(
                  children: <pdfLib.Widget>[
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.evaluacion,
                          style: pdfLib.TextStyle(font: font, fontSize: 8.0)),
                    ),
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.puesto,
                          style: pdfLib.TextStyle(
                            font: font,
                            fontSize: 8.0,
                          )),
                    ),
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.area,
                          style: pdfLib.TextStyle(font: font, fontSize: 8.0)),
                    ),
                    pdfLib.Container(
                      width: 100,
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.incidentesPotenciales,
                          style: pdfLib.TextStyle(font: font, fontSize: 8.0)),
                    ),
                    pdfLib.Container(
                      width: 100,
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.consecuencia,
                          style: pdfLib.TextStyle(font: font, fontSize: 8.0)),
                    ),
                    pdfLib.Container(
                      width: 170,
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.medidaControl,
                          style: pdfLib.TextStyle(font: font, fontSize: 8.0)),
                    ),
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(risk.tipo,
                          style: pdfLib.TextStyle(font: font, fontSize: 8.0)),
                    ),
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(
                          DateFormat('dd-MM-yyyy').format(risk.dateOfRevision),
                          style: pdfLib.TextStyle(font: font, fontSize: 7.0)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );

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
