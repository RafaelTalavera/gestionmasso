import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'comsumo_suma_mesual.dart';

class ConsumoUnidadSelectionScreen extends StatefulWidget {
  const ConsumoUnidadSelectionScreen({
    super.key,
    required this.nameOrganization,
    required this.combustible,
  });

  final String nameOrganization;
  final String combustible;

  @override
  UnidadeSelectionScreenState createState() => UnidadeSelectionScreenState();
}

class UnidadeSelectionScreenState extends State<ConsumoUnidadSelectionScreen> {
  List<String> unidades = [];
  bool loading = true;

  get nameOrganizations => null; // Variable para controlar la carga de datos

  @override
  void initState() {
    super.initState();
    _fetchUnidades();
  }

  Future<void> _fetchUnidades() async {
    String? token = await TokenManager.getToken();
    try {
      final url = Uri.parse(
          'http://10.0.2.2:8080/api/consumo/unidad?nameOrganization=${widget.nameOrganization}&combustible=${widget.combustible}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // Otros encabezados si es necesario
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> fetchedUnidades = data.cast<String>();

        setState(() {
          unidades = fetchedUnidades;
          loading = false; // Marcar la carga como completa
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      setState(() {
        loading =
            false; // Marcar la carga como completa incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          ' Unidades',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Center(
                child: loading
                    ? const CircularProgressIndicator() // Muestra un indicador de carga mientras se obtienen los datos
                    : unidades.isEmpty
                        ? const Text(
                            'No hay registros asociados a organizaciones')
                        : ListView.builder(
                            itemCount: unidades.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConsumoMensualTable(
                                          nameOrganization:
                                              widget.nameOrganization,
                                          combustible: widget.combustible,
                                          unidad:
                                              unidades[index], // Corregido aquí
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.lightGreen.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13.0,
                                      vertical: 15.0,
                                    ),
                                  ),
                                  child: Text(unidades[index]),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
