import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'consumo_selec_unidad.dart';

class ConsumoCombutibleSelectionScreen extends StatefulWidget {
  const ConsumoCombutibleSelectionScreen({
    super.key,
    required this.nameOrganization,
    required this.organizationId,
  });

  final String nameOrganization;
  final String organizationId;

  @override
  CombustibleSelectionScreenState createState() =>
      CombustibleSelectionScreenState();
}

class CombustibleSelectionScreenState
    extends State<ConsumoCombutibleSelectionScreen> {
  List<String> consumos = [];
  bool loading = true; // Variable para controlar la carga de datos

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    String? token = await TokenManager.getToken();
    try {
      final url = Uri.parse(
          'http://10.0.2.2:8080/api/consumo/combustibles?nameOrganization=${widget.nameOrganization}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // Otros encabezados si es necesario
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> fetchedConsumos = data.cast<String>();

        setState(() {
          consumos = fetchedConsumos;
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
          'Combustibles',
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
              height: 60,
            ),
            Expanded(
              child: Center(
                child: loading
                    ? const CircularProgressIndicator() // Muestra un indicador de carga mientras se obtienen los datos
                    : consumos.isEmpty
                        ? const Text(
                            'No hay registros asociados a organizaciones')
                        : ListView.builder(
                            itemCount: consumos.length,
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
                                            ConsumoUnidadSelectionScreen(
                                          nameOrganization:
                                              widget.nameOrganization,
                                          combustible: consumos[
                                              index], // Aquí asumo que el combustible está en consumos[index]
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
                                  child: Text(consumos[index]),
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
