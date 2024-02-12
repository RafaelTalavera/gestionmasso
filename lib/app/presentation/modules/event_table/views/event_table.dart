import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../domain/repositories/event_repository.dart';

class EventTable extends StatefulWidget {
  @override
  _EventTableState createState() => _EventTableState();
}

class _EventTableState extends State<EventTable> {
  late List<Event> events;

  @override
  void initState() {
    super.initState();
    events = <Event>[];
    // Llamar a la función para cargar datos desde el backend
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/events'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      events = jsonData.map((json) => Event.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Error al cargar datos desde el backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Lesiones'),
      ),
      // ignore: unnecessary_null_comparison
      body: events == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('id')),
                    DataColumn(label: Text('Fecha del Evento')),
                    DataColumn(label: Text('Severidad')),
                    DataColumn(label: Text('Parte')),
                    DataColumn(label: Text('Lesión')),
                    DataColumn(label: Text('tipo')),
                    DataColumn(label: Text('Entrada')),
                    DataColumn(label: Text('Tarea')),
                    DataColumn(label: Text('H Trabajadas')),
                    DataColumn(label: Text('Capacitación')),
                    DataColumn(label: Text('Accidentes previos')),
                    DataColumn(label: Text('Requiere Autorización')),
                    DataColumn(label: Text('Tiene autorización')),
                    DataColumn(label: Text('pts')),
                    DataColumn(label: Text('Aplico PTS')),
                    DataColumn(label: Text('maquina')),
                    DataColumn(label: Text('Energia')),
                    DataColumn(label: Text('Tiene Bloqueo')),
                    DataColumn(label: Text('requerido')),
                    DataColumn(label: Text('uso')),
                    DataColumn(label: Text('Defensas')),
                    DataColumn(label: Text('Estado de defensas')),
                    DataColumn(label: Text('Tenia fallas el equipo?')),
                    DataColumn(label: Text('Uso correcto'))
                  ],
                  rows: events.map((event) {
                    return DataRow(
                      cells: [
                        DataCell(Text(event.id.toString())),
                        DataCell(Text(
                            DateFormat('yyyy-MM-dd').format(event.dateEvent))),
                        DataCell(Text(event.severity)),
                        DataCell(Text(event.bodyPart)),
                        DataCell(Text(event.injury)),
                        DataCell(Text(event.incidenType)),
                        DataCell(
                            Text(DateFormat('yyyy-MM-dd').format(event.entry))),
                        DataCell(Text(event.workOccasion)),
                        DataCell(Text(event.hoursWorked)),
                        DataCell(Text(DateFormat('yyyy-MM-dd')
                            .format(event.trainingDate))),
                        DataCell(Text(event.accidentHistory
                            .toString())), // Convert boolean to string
                        DataCell(Text(event.authorization.toString())),
                        DataCell(Text(event.authorizationWork.toString())),
                        DataCell(Text(event.pts.toString())),
                        DataCell(Text(event.ptsApplied.toString())),
                        DataCell(Text(event.machine.toString())),
                        DataCell(Text(event.energia)),
                        DataCell(Text(event.lockedIn.toString())),
                        DataCell(Text(event.lockedRequired.toString())),
                        DataCell(Text(event.lockedUsed.toString())),
                        DataCell(Text(event.defense.toString())),
                        DataCell(Text(event.defenserIntegrity.toString())),
                        DataCell(Text(event.workEquimentFails.toString())),
                        DataCell(Text(event.correctUseEquimat.toString())),

                        // Agrega más celdas según sea necesario
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
