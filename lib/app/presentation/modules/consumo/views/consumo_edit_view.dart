// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/consumo_list_dropdown.dart';
import '../sources/consumo_table_data.dart';
import 'consumo_table_view.dart';

class ConsumoEditScreen extends StatefulWidget {
  const ConsumoEditScreen(
      {Key? key, required this.consumo, required this.consumoId});

  final Consumo consumo;
  final String consumoId;

  @override
  ConsumoEditScreenState createState() => ConsumoEditScreenState();
}

class ConsumoEditScreenState extends State<ConsumoEditScreen> {
  late Consumo newConsumo;
  TextEditingController consumoController = TextEditingController();

  String? unidadSeleccionada;

  final String apiUrl = 'http://10.0.2.2:8080/api/consumo';

  @override
  void initState() {
    super.initState();
    newConsumo = widget.consumo.copyWith();
    consumoController.text = widget.consumo.consumo.toString();
  }

  void _submitForm() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String? token = await TokenManager.getToken();

    final responsePost = await http.put(
      Uri.parse('$apiUrl/${widget.consumo.id}/edit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(newConsumo.toJson()),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsumoTable(),
                      ));
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

      scaffoldMessenger.showSnackBar(
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
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Editar consumo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: widget.consumo.nameOrganization,
              decoration: const InputDecoration(
                labelText: 'Organización',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'date',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Fecha del Registro',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.consumo.date,
              enabled: false,
              onChanged: (DateTime? selectedDate) {
                setState(() {
                  newConsumo =
                      newConsumo.copyWith(date: selectedDate ?? DateTime.now());
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.consumo.fuente,
              decoration: const InputDecoration(
                labelText: 'Fuente',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.consumo.tipoFuente,
              decoration: const InputDecoration(
                labelText: 'Tipo de fuente',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Combustible',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.consumo.combustible,
              enabled: false,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Unidad',
                border: OutlineInputBorder(),
              ),
              value: unidadSeleccionada,
              onChanged: (String? newValue) {
                setState(() {
                  unidadSeleccionada = newValue!;
                  newConsumo = newConsumo.copyWith(unidad: newValue);
                });
              },
              items: ListDropdownInventory.unidades
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Consumo',
                border: OutlineInputBorder(),
              ),
              controller: consumoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              onChanged: (value) {
                newConsumo = newConsumo.copyWith(consumo: double.parse(value));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
