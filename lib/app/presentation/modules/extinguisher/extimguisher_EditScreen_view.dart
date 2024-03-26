import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../data/services/remote/token_manager.dart';
import '../../global/widgets/custom_AppBar.dart';

import 'sources/extimguisher_table.dart';

class ExtimguisherEditScreen extends StatefulWidget {
  const ExtimguisherEditScreen(
      {Key? key, required this.extinguisher, required String extinguisherId})
      : super(key: key);

  final Extimguisher extinguisher;

  @override
  _ExtimguisherEditScreenState createState() => _ExtimguisherEditScreenState();
}

class _ExtimguisherEditScreenState extends State<ExtimguisherEditScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _observacionesController =
      TextEditingController();

  final String apiUrl = 'http://10.0.2.2:8080/api/extinguishers';
  bool access = false;
  bool presion = false;
  bool signaling = false;

  void _submitForm() async {
    String observacionesValue =
        _formKey.currentState?.fields['observaciones']?.value ?? '';
    String newSector = _formKey.currentState?.fields['sector']?.value ?? '';

    print('Valor del campo sector: $newSector');

    String? token = await TokenManager.getToken();

    Extimguisher newExtimguisher = Extimguisher(
      id: widget.extinguisher.id,
      date: widget.extinguisher.date,
      empresa: widget.extinguisher.empresa,
      sector: widget.extinguisher.sector,
      extId: widget.extinguisher.extId,
      tipo: widget.extinguisher.tipo,
      kg: widget.extinguisher.kg,
      ubicacion: widget.extinguisher.ubicacion,
      vencimiento: widget.extinguisher.vencimiento,
      access: access,
      signaling: signaling,
      presion: presion,
      observaciones: observacionesValue,
      vigente: widget.extinguisher.vigente,
      diferenciaEnDias: widget.extinguisher.diferenciaEnDias,
      enabled: widget.extinguisher.enabled,
      userId: widget.extinguisher.userId,
    );

    print('JSON enviado a la API:');
    print(jsonEncode(newExtimguisher));

    final responsePost = await http.put(
      Uri.parse('$apiUrl/${widget.extinguisher.id}/edit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(newExtimguisher),
    );

    if (responsePost.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Extintor actualizado correctamente'),
            content: const Text(
                'La información del extintor se actualizó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print(
        'Error al enviar la información. Código de respuesta: ${responsePost.statusCode}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al enviar la información. Por favor, inténtelo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleWidget: Text(
          'Control de Extintores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 238, 183, 19),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: widget.extinguisher.empresa,
              decoration: const InputDecoration(
                labelText: 'Empresa',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),

            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.extinguisher.sector,
              decoration: const InputDecoration(
                labelText: 'Sector',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),

            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.extinguisher.extId,
              decoration: const InputDecoration(
                labelText: 'Identificación del extintor',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.extinguisher.tipo,
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Peso',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.extinguisher.kg.toString(),
              enabled: false,
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'date',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialValue: widget.extinguisher.date,
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Fecha del control',
                border: OutlineInputBorder(),
              ),
              enabled: true,
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'vencimiento',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              initialValue: widget.extinguisher.vencimiento,
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Nueva fecha de vencimiento',
                border: OutlineInputBorder(),
              ),
              enabled: true,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Acceso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 175),
                AdvancedSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      access = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  access ? ' Bueno' : ' Malo',
                  style: TextStyle(
                    color: access ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Señalización',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 130),
                AdvancedSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      signaling = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  signaling ? ' Buena' : ' Mala',
                  style: TextStyle(
                    color: signaling ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Presión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 170),
                AdvancedSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      presion = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  presion ? ' Buena' : ' Mala',
                  style: TextStyle(
                    color: presion ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FormBuilderTextField(
              name: 'observaciones',
              maxLines: 3,
              controller: _observacionesController,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
                suffixText: 'Observaciones',
              ),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enviar'),
            ),
            // Otros campos que se pueden editar...
          ],
        ),
      ),
    );
  }
}
