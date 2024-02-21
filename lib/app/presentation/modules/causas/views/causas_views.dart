import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../home/views/home_view.dart';

class HypothesisScreen extends StatefulWidget {
  final String eventId;

  const HypothesisScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _HypothesisScreenState createState() => _HypothesisScreenState();
}

class _HypothesisScreenState extends State<HypothesisScreen> {
  Map<String, String> hypothesisData = {};
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Realiza la solicitud GET al cargar la pantalla
  }

  // Método para realizar la solicitud GET
  Future<void> fetchData() async {
    String apiUrl = 'http://10.0.2.2:8080/api/events/${widget.eventId}/causa';

    print('Solicitud GET a: $apiUrl');

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Convertir valores dinámicos a cadenas
        Map<String, String> convertedData = {};
        jsonResponse.forEach((key, value) {
          convertedData[key] = value.toString();
        });
        setState(() {
          hypothesisData = convertedData;
        });
      } else {
        // Maneja casos en los que la solicitud no sea exitosa
        print('Error en la solicitud GET: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud GET: $error');
    }
  }

  Future<void> sendComment(String token, String comment) async {
    try {
      String apiUrl =
          'http://10.0.2.2:8080/api/events/${widget.eventId}/comment';

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'comment': comment}),
      );

      if (response.statusCode == 200) {
        print('Comentario enviado correctamente');
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enviado correctamente'),
                content: const Text(
                    'Gracias por su comentario. Trabajaremos en incorporar las sugerencias.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeView()));
                    },
                    child: const Text('Ir a inicio'),
                  ),
                ],
              );
            });
      } else {
        print('Error al enviar el comentario: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al enviar el comentario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hypothesis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entradas JSON existentes
              Column(
                children: hypothesisData.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        // ignore: unnecessary_string_interpolations
                        '${entry.value}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: .0),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Escribe que te parecio el analisis:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu comentario aquí',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        String? token = await TokenManager.getToken();

                        if (token != null) {
                          String comment = commentController.text;
                          await sendComment(token, comment);
                        } else {
                          print('No se pudo obtener el token.');
                        }
                      },
                      child: const Text('Enviar Comentario'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
