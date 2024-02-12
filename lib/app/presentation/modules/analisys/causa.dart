import 'package:flutter/material.dart';

class Causa extends StatelessWidget {
  const Causa({super.key});

  final String apiUrl = 'http://tu_api_rest/analisis_hipotesis_causa';

  void _realizarAnalisisHipotesis() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evento Cargado Exitoso'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Navegar al menú de inicio
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Se cargó con éxito su evento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _realizarAnalisisHipotesis,
              child: Text('Realizar Análisis de Hipótesis de Causa'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Volver al paso anterior
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
