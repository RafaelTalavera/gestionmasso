import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../sources/consumo_table_mes_data.dart';

final _monthYearFormat = DateFormat('MM-yy');

class LineAreaPointPage extends StatefulWidget {
  const LineAreaPointPage({
    super.key,
    required this.nameOrganization,
    required this.combustible,
    required this.unidad,
  });
  final String nameOrganization;
  final String combustible;
  final String unidad;

  @override
  LineAreaPointPageState createState() => LineAreaPointPageState();
}

class LineAreaPointPageState extends State<LineAreaPointPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ConsumoMes> timeSeriesSales = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await TokenManager.getToken();

    final url = Uri.parse(
      'http://10.0.2.2:8080/api/consumo/${widget.nameOrganization}/${widget.combustible}/${widget.unidad}',
    );

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
      List<ConsumoMes> consumos =
          jsonData.map((json) => ConsumoMes.fromJson(json)).toList();
      consumos.sort((a, b) => a.yearMonth.compareTo(b.yearMonth));

      setState(() {
        timeSeriesSales = consumos;
      });
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      key: _scaffoldKey,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(8, 80, 20, 5),
                child: const Text(
                  'Consumo por mes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 124, 97, 221),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Card(
                margin: const EdgeInsets.all(
                    10), // Ajusta el margen según lo necesites
                child: Container(
                  padding: const EdgeInsets.all(
                      10), // Ajusta el relleno según lo necesites
                  width: 350,
                  height: 300,
                  child: Chart(
                    data: timeSeriesSales,
                    variables: {
                      'time': Variable(
                        accessor: (ConsumoMes datum) => datum.yearMonth,
                        scale: TimeScale(
                          formatter: (time) => _monthYearFormat.format(time),
                        ),
                      ),
                      'consumos': Variable(
                        accessor: (ConsumoMes datum) => datum.totalConsumo,
                      ),
                    },
                    marks: [
                      LineMark(
                        shape: ShapeEncode(value: BasicLineShape(dash: [5, 2])),
                        selected: {
                          'touchMove': {1}
                        },
                      )
                    ],
                    coord: RectCoord(
                      color: const Color.fromARGB(255, 196, 185, 153),
                    ),
                    axes: [
                      Defaults.horizontalAxis,
                      Defaults.verticalAxis,
                    ],
                    selections: {
                      'touchMove': PointSelection(
                        on: {
                          GestureType.scaleUpdate,
                          GestureType.tapDown,
                          GestureType.longPressMoveUpdate
                        },
                        dim: Dim.x,
                      )
                    },
                    tooltip: TooltipGuide(
                      followPointer: [false, true],
                      align: Alignment.topCenter,
                      offset: const Offset(-100, -20),
                    ),
                    crosshair: CrosshairGuide(followPointer: [false, true]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
