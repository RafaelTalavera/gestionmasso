// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:convert';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pdf/pdf.dart';
// ignore: library_prefixes
import 'package:pdf/widgets.dart' as pdfLib;
//import 'package:share_extend/share_extend.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../../global/widgets/pdf_view.dart';
import '../sources/extimguisher_table.dart';
import 'extimguisher_edit_view.dart';

class ExtimguishersScreen extends StatefulWidget {
  const ExtimguishersScreen({super.key, required this.organization});
  final String organization;

  @override
  ExtimguishersScreenState createState() => ExtimguishersScreenState();
}

class ExtimguishersScreenState extends State<ExtimguishersScreen> {
  List<Extimguisher> extimguishers = [];
  String? selectedSector;
  String? selectedType;
  String? selectedState;
  String? selectedEnabled;
  int? selectedRange;

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
    fetchData();
    _loadInterstitialAd();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    try {
      final url = Uri.parse(
          'http://10.0.2.2:8080/api/extinguishers/organization/${widget.organization}');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));

        List<Extimguisher> fetchedExtimguishers =
            jsonData.map((json) => Extimguisher.fromJson(json)).toList();

        setState(() {
          extimguishers = fetchedExtimguishers;
        });
        _showInterstitialAd();
      } else {
        throw Exception('Error al cargar datos desde el backend');
      }
      // ignore: empty_catches
    } catch (error) {}
  }

  String getStateText(bool state) {
    return state ? 'Vigente' : 'Vencido';
  }

  String getStateText2(bool state) {
    return state ? 'Buena' : 'Mala';
  }

  Color getStateColor(bool state) {
    return state ? Colors.green : Colors.red;
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
          'Control de Extintores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _createPDF(extimguishers);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf,
                            color: Colors.red), // Icono de PDF
                        SizedBox(width: 8), // Espacio entre el icono y el texto
                        Text('Crear informe en PDF'), // Texto del botón
                      ],
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownFilter(
                              'Sector',
                              extimguishers
                                  .map((e) => e.sector)
                                  .toSet()
                                  .toList(),
                              selectedSector,
                              (String? value) {
                                setState(() {
                                  selectedSector = value;
                                });
                                fetchData();
                              },
                            ),
                          ),
                          _buildEnabledFilter(),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownFilter(
                              'Expiración',
                              ['Vigente', 'Vencido'],
                              selectedState,
                              (String? value) {
                                setState(() {
                                  selectedState = value;
                                });
                                fetchData();
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildDropdownFilter(
                              'Tipo',
                              extimguishers.map((e) => e.tipo).toSet().toList(),
                              selectedType,
                              (String? value) {
                                setState(() {
                                  selectedType = value;
                                });
                                fetchData();
                              },
                            ),
                          ),
                        ],
                      ),
                      _buildRangeFilter(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedSector = null;
                                selectedType = null;
                                selectedState = null;
                                selectedEnabled = null;
                                selectedRange = null;
                              });
                              fetchData();
                            },
                            child: const Text('Limpiar filtros'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: extimguishers
                    .where((extinguisher) =>
                        (selectedSector == null ||
                            extinguisher.sector == selectedSector) &&
                        (selectedType == null ||
                            extinguisher.tipo == selectedType) &&
                        (selectedState == null ||
                            (selectedState == 'Vigente'
                                ? extinguisher.vigente
                                : !extinguisher.vigente)) &&
                        (selectedEnabled == null ||
                            (selectedEnabled == 'Activo'
                                ? !extinguisher.enabled
                                : extinguisher.enabled)) &&
                        (selectedRange == null
                            ? true
                            : (selectedRange == 0
                                ? extinguisher.diferenciaEnDias <= 7
                                : selectedRange == 1
                                    ? extinguisher.diferenciaEnDias > 7 &&
                                        extinguisher.diferenciaEnDias <= 15
                                    : selectedRange == 2
                                        ? extinguisher.diferenciaEnDias > 15 &&
                                            extinguisher.diferenciaEnDias <= 30
                                        : extinguisher.diferenciaEnDias > 30)))
                    .map((extinguisher) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado: ${getStateText(extinguisher.vigente)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.vigente),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Fecha del control: ${DateFormat('dd-MM-yyyy').format(extinguisher.date)}',
                            ),
                            Text('Empresa: ${extinguisher.nameOrganization}'),
                            Text('Área: ${extinguisher.sector}'),
                            Text('Identificación: ${extinguisher.extId}'),
                            Text('Tipo: ${extinguisher.tipo}'),
                            Text('Capacidad en kg: ${extinguisher.kg}'),
                            Text(
                              'Vencimiento: ${DateFormat('dd-MM-yyyy').format(extinguisher.vencimiento)}',
                            ),
                            Text(
                              'Accesibilidad: ${getStateText2(extinguisher.access)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.access),
                              ),
                            ),
                            Text(
                              'Señalización: ${getStateText2(extinguisher.signaling)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.signaling),
                              ),
                            ),
                            Text(
                              'Presión: ${getStateText2(extinguisher.presion)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.presion),
                              ),
                            ),
                            Text(
                                'Observaciones: ${extinguisher.observaciones}'),
                            Text(
                              'Días para el vencimiento: ${extinguisher.diferenciaEnDias}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: extinguisher.diferenciaEnDias < 7
                                    ? Colors.red
                                    : extinguisher.diferenciaEnDias < 15
                                        ? Colors.orange
                                        : extinguisher.diferenciaEnDias < 30
                                            ? Colors.black
                                            : Colors.green,
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _updateEnabledStatus(
                                      extinguisher.id,
                                      !extinguisher.enabled,
                                    );
                                    _showInterstitialAd();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (extinguisher.enabled) {
                                          return Colors.orange;
                                        } else {
                                          return Colors.orange;
                                        }
                                      },
                                    ),
                                  ),
                                  child: Text(
                                    extinguisher.enabled
                                        ? 'Activar'
                                        : 'Desactivar',
                                    style: const TextStyle(color: Colors.white),
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
                                          builder: (context) =>
                                              ExtimguisherEditScreen(
                                            extinguisherId: extinguisher.id,
                                            extinguisher: extinguisher,
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
                                ElevatedButton(
                                  onPressed: () {
                                    _generateQRCode(extinguisher);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.yellow),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: const Text('Generar QR'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnabledFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedEnabled,
          onChanged: (String? newValue) {
            setState(() {
              selectedEnabled = newValue;
            });
            fetchData();
          },
          items: ['Activo', 'Fuera de servicio']
              .map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.blue,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: value,
            onChanged: (String? newValue) {
              onChanged(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rango de días para vencimiento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ToggleButtons(
          isSelected: List.generate(4, (index) => index == selectedRange),
          onPressed: (int newIndex) {
            setState(() {
              selectedRange = newIndex;
            });
            fetchData(); // Actualizar datos al cambiar el rango
          },
          children: const [
            Text('0-7'),
            Text('8-15'),
            Text('16-30'),
            Text('31+'),
          ],
        ),
      ],
    );
  }

  void _updateEnabledStatus(String extinguisherId, bool newStatus) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8080/api/extinguishers/$extinguisherId/changeEnabled'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enabled': newStatus}),
      );

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, actualiza el estado local del campo enabled

        _showInterstitialAd();
        setState(() {
          final index = extimguishers
              .indexWhere((extinguisher) => extinguisher.id == extinguisherId);
          if (index != -1) {
            extimguishers[index].enabled = newStatus;
          }
        });
      } else {}
      // ignore: empty_catches
    } catch (error) {}
  }

  void _generateQRCode(Extimguisher extinguisher) {
    String fixedText = "Gestion Masso\n";
    // Concatenar toda la información del extintor en una sola cadena
    String qrData = '''
$fixedText
Estado: ${getStateText(extinguisher.vigente)}
Identificación: ${extinguisher.extId}

''';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Código QR'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: PrettyQr(
              data: qrData,
              typeNumber: 4,
              size: 200,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  _createPDF(extimguishers) async {
    final pdfLib.Document pdf = pdfLib.Document();

    String fechaActual = DateFormat('dd-MM-yyyy').format(DateTime.now());

    var fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    var font = pdfLib.Font.ttf(fontData);

    final organizationName =
        extimguishers.isNotEmpty ? extimguishers.first.nameOrganization : '';

    final userName = extimguishers.isNotEmpty ? extimguishers.first.userId : '';

    final area = extimguishers.isNotEmpty ? extimguishers.first.sector : '';

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
                      'Informe de Extintores',
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
                      'Área: $area',
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
                      child: pdfLib.Text('ID',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Tipo',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Kg',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Ubicación',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Vencimiento',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Acceso',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Señalización',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Presión',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                  pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: pdfLib.Text('Observación',
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0))),
                ],
              ),
              for (var data in extimguishers)
                pdfLib.TableRow(
                  children: <pdfLib.Widget>[
                    // ID
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.extId,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Tipo
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.tipo,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Kg
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.kg.toString(),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Ubicación
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(
                          5, 3, 5, 3), // Espacio a la izquierda
                      child: pdfLib.Text(data.ubicacion,
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Vencimiento
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(
                          DateFormat('yyyy-MM-dd').format(data.vencimiento),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Acceso
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.access.toString(),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Señalización
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.signaling.toString(),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Presión
                    pdfLib.Container(
                      margin: const pdfLib.EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: pdfLib.Text(data.presion.toString(),
                          style: pdfLib.TextStyle(font: font, fontSize: 10.0)),
                    ),
                    // Observaciones
                    pdfLib.Container(
                      margin: pdfLib.EdgeInsets.only(
                          left: 5), // Espacio a la izquierda
                      child: pdfLib.Text(data.observaciones,
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
