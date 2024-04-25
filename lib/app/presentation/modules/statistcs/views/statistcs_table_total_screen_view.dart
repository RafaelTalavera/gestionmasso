import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../sources/statistcs_total_data.dart';

class StatistcsTableTotal extends StatefulWidget {
  const StatistcsTableTotal({
    super.key,
    required this.organization,
  });

  final String organization;

  @override
  IperTableState createState() => IperTableState();
}

class IperTableState extends State<StatistcsTableTotal> {
  late List<StatistcsTotal> statistcs;

  @override
  void initState() {
    super.initState();
    statistcs = <StatistcsTotal>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/statistcs/summary?nameOrganization=${widget.organization}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      statistcs =
          jsonData.map((json) => StatistcsTotal.fromJson(json)).toList();
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
          'Datos Organización',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: statistcs == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: statistcs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            'Organización: ${statistcs[index].organization}',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Año: ${statistcs[index].year}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                'Mes: ${statistcs[index].month}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                'Horas trabajadas: ${statistcs[index].totalHours}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
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
}
