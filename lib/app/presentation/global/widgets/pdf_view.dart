import 'dart:io';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

import '../utils/caculate_font_sise.dart';

class ViewPdf extends StatefulWidget {
  const ViewPdf(this.path, {super.key});

  final String path;

  @override
  ViewPdfState createState() => ViewPdfState();
}

class ViewPdfState extends State<ViewPdf> {
  PDFDocument? _doc;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    if (_doc == null) {
      _initPdf();
    }
  }

  // Utiliza un método asincrónico para inicializar _doc
  Future<void> _initPdf() async {
    try {
      print('Iniciando inicialización del PDF...');
      print('Ruta del archivo PDF: ${widget.path}');

      final doc = await PDFDocument.fromFile(File(widget.path));
      setState(() {
        _doc = doc;
        _loading = false;
      });
      print('PDF inicializado exitosamente.');
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error al inicializar el PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/imagen/gmasso.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(
              'Reportes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 238, 183, 19),
                fontSize: fontSize,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.black,
              ),
              iconSize: 30,
              onPressed: () {
                ShareExtend.share(
                  widget.path,
                  "file",
                  sharePanelTitle: "Enviar PDF",
                  subject: "example-pdf",
                );
              },
            ),
          )
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _doc != null
              ? PDFViewer(document: _doc!)
              : const Center(
                  child: Text('Error al cargar el PDF'),
                ),
    );
  }
}
