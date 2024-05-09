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
import '../../../global/widgets/pdf_view.dart';
import '../sources/consumo_table_data.dart';
import 'consumo_edit_view.dart';

class ConsumoTable extends StatefulWidget {
  const ConsumoTable({
    super.key,
    required this.nameOrganization,
  });

  final String nameOrganization;

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
    consumos = <Consumo>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/consumo/organization/${widget.nameOrganization}');

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
      bool cumpleFiltroMes = filtroMes == null || consumo.month == filtroMes;
      bool cumpleFiltroYear = filtroYear == null || consumo.year == filtroYear;
      bool cumpleFiltroCombustible =
          filtroCombustible == null || consumo.combustible == filtroCombustible;

      bool cumpleFiltroTipoFuente =
          filtroTipoFuente == null || consumo.tipoFuente == filtroTipoFuente;

      return cumpleFiltroTipoFuente &&
          cumpleFiltroMes &&
          cumpleFiltroYear &&
          cumpleFiltroCombustible;
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
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _createPDF(consumos);
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.picture_as_pdf,
                                          color: Colors.red), // Icono de PDF
                                      SizedBox(
                                          width:
                                              8), // Espacio entre el icono y el texto
                                      Text(
                                          'Crear informe en PDF'), // Texto del botón
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                      _showInterstitialAd();
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
                                      text: listaFiltrada[index].month,
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
          valoresUnicos.add(consumo.month);
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

  _createPDF(extimguishers) async {
    final pdfLib.Document pdf = pdfLib.Document();

    String fechaActual = DateFormat('dd-MM-yyyy').format(DateTime.now());

    var fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    var font = pdfLib.Font.ttf(fontData);

    final organizationName =
        extimguishers.isNotEmpty ? extimguishers.first.nameOrganization : '';

    final userName = extimguishers.isNotEmpty ? extimguishers.first.userId : '';

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
                      'Consumo de Hidrocarburos',
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
                      child: pdfLib.Text('Fecha',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Fuente',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Tipo',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Combustible',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Unidad',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Consumo',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                ],
              ),
              for (var data in extimguishers)
                pdfLib.TableRow(
                  children: <pdfLib.Widget>[
                    // date
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(
                          DateFormat('yyyy-MM-dd').format(data.date),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    //fuente
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.fuente,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Tipo
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.tipoFuente,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // combistible
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.combustible,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Unidad
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.unidad,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Consumo
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.consumo.toString(),
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
