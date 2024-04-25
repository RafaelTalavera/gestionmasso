// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../accidents/sources/accidents_total_data.dart';
import '../sources/statistcs_total_data.dart';

class IFTableTotal extends StatefulWidget {
  const IFTableTotal({
    super.key,
    required this.organization,
  });

  final String organization;

  @override
  AccidentsTableTotalState createState() => AccidentsTableTotalState();
}

class AccidentsTableTotalState extends State<IFTableTotal> {
  late List<AccidentsTotal> accidents;
  late List<StatistcsTotal> statistics;

  @override
  void initState() {
    super.initState();
    accidents = <AccidentsTotal>[];
    statistics = <StatistcsTotal>[];
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final accidentsUrl = Uri.parse(
        'http://10.0.2.2:8080/api/accidents/summary?nameOrganization=${widget.organization}');
    final statisticsUrl = Uri.parse(
        'http://10.0.2.2:8080/api/statistcs/summary?nameOrganization=${widget.organization}');

    final accidentsResponse = await http.get(
      accidentsUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final statisticsResponse = await http.get(
      statisticsUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (accidentsResponse.statusCode == 200 &&
        statisticsResponse.statusCode == 200) {
      final List<dynamic> accidentsJsonData =
          json.decode(utf8.decode(accidentsResponse.bodyBytes));
      accidents = accidentsJsonData
          .map((json) => AccidentsTotal.fromJson(json))
          .toList();

      final List<dynamic> statisticsJsonData =
          json.decode(utf8.decode(statisticsResponse.bodyBytes));
      statistics = statisticsJsonData
          .map((json) => StatistcsTotal.fromJson(json))
          .toList();

      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  double calculateAccidentFrequencyIndex(int year, int month) {
    double index = 0.0;
    for (var accident in accidents) {
      for (var stat in statistics) {
        if (accident.year == stat.year &&
            accident.month == stat.month &&
            accident.year == year &&
            accident.month == month) {
          index = (accident.totalAccidents / stat.totalHours) * 1000000;
          return index; // Devuelve el índice calculado para este mes específico
        }
      }
    }
    return index; // Devuelve 0 si no se encuentran datos para este mes
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Indice de Frecuencia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: accidents == null || statistics == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: accidents.length,
                    itemBuilder: (context, index) {
                      AccidentsTotal accident = accidents[index];
                      for (var stat in statistics) {
                        if (accident.year == stat.year &&
                            accident.month == stat.month) {
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Organización: ${accident.organization}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'MES: ${accident.month}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'AÑO: ${accident.year}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'Total Accidentes: ${accident.totalAccidents}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'Total Horas: ${stat.totalHours}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'Índice de Frecuencia: ${calculateAccidentFrequencyIndex(accident.year, accident.month).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      // Si no hay coincidencias, retornamos un contenedor vacío
                      return Container();
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
