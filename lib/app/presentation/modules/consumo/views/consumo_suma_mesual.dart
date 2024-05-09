import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/consumo_table_mes_data.dart';
import 'consumo_chart_view.dart';

class ConsumoMensualTable extends StatefulWidget {
  const ConsumoMensualTable({
    Key? key,
    required this.nameOrganization,
    required this.combustible,
    required this.unidad,
  }) : super(key: key);

  final String nameOrganization;
  final String combustible;
  final String unidad;

  @override
  ConsumoTableState createState() => ConsumoTableState();
}

class ConsumoTableState extends State<ConsumoMensualTable> {
  late List<ConsumoMes> consumos;

  @override
  void initState() {
    super.initState();
    consumos = <ConsumoMes>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/consumo/${widget.nameOrganization}/${widget.combustible}/${widget.unidad}');

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
      consumos = jsonData.map((json) => ConsumoMes.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Consumo mensual',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: consumos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LineAreaPointPage(
                                  nameOrganization: widget.nameOrganization,
                                  combustible: widget.combustible,
                                  unidad: widget.unidad,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightGreen.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: const Text('Ver gráfico'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: consumos.length,
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
                                      text: 'Combustible: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: consumos[index].combustible,
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
                                      text: consumos[index].unidad,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Año-Mes: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${consumos[index].yearMonth.year}-${consumos[index].yearMonth.month}',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    const TextSpan(
                                      text: 'Total consumo: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: consumos[index]
                                          .totalConsumo
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
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
}
