import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../home/views/home_view.dart';
import 'event_repository.dart';

class EventTable extends StatefulWidget {
  const EventTable({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventTableState createState() => _EventTableState();
}

class _EventTableState extends State<EventTable> {
  late List<Event> events;

  @override
  void initState() {
    super.initState();
    events = <Event>[];
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
        title: Row(
          children: [
            Image.asset(
              'assets/imagen/gmasso.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Lista de Eventos',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 238, 183, 19)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeView()));
            },
          ),
        ],
      ),
      // ignore: unnecessary_null_comparison
      body: events == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha del evento: ${DateFormat('yyyy-MM-dd').format(events[index].dateEvent)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text('Severidad: ${events[index].severity}'),
                          Text('Parte del cuerpo: ${events[index].bodyPart}'),
                          Text('Lesión: ${events[index].injury}'),
                          Text(
                              'Antiguedad >6 meses: ${events[index].entry ? 'Sí' : 'No'}'),
                          Text(
                              'Ocasión de trabajo: ${events[index].workOccasion}'),
                          Text(
                              'Horas trabajadas: ${events[index].hoursWorked}'),
                          Text(
                              'Historial de accidentes: ${events[index].accidentHistory ? 'Sí' : 'No'}'),
                          // Agrega más Text widgets según sea necesario para otros campos
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
