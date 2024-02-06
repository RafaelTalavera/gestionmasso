import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormularioAccid extends StatelessWidget {
  const FormularioAccid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario Accidentes'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: MyForm(),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final String apiUrl =
      'URL_DE_TU_SERVIDOR'; // Reemplaza esto con la URL de tu servidor

  List<String> severidades = [
    'CASI',
    'LEVE',
    'MODERADO',
    'INCAPACITANTE',
    'FATAL'
  ];

  List<String> bodyPart = [
    'CABEZA',
    'CUELLO',
    'CARA',
    'BRAZO',
    'MANO',
    'PIERNA',
    'PIE',
    'RODILLA',
    'DEDOS',
    'OJO',
    'OIDO',
    'ESPALDA',
    'COLUMNA',
    'MULTIPLES'
  ];

  List<String> injury = [
    'AMPUTACION',
    'CONMOCION',
    'CONTUSION',
    'CORTE',
    'ESGUINCE',
    'FISURA',
    'FRACTURA',
    'INTOXICACION',
    'LACERACION',
    'PERFORACION',
    'QUEMADURAS',
    'TORCEDURAS'
  ];

  List<String> incidenType = [
    'Atrapado por',
    'Caída a distinto nivel',
    'Caída al mismo nivel',
    'Contacto con calor',
    'Contacto con electricidad',
    'Contacto con químicos'
  ];

  void _submitForm() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      final formData = _fbKey.currentState!.value;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formData),
      );

      if (response.statusCode == 201) {
        print('Evento creado exitosamente');
        // Puedes manejar la respuesta del servidor aquí si es necesario
      } else {
        print(
            'Error al crear el evento. Código de estado: ${response.statusCode}');
        // Puedes manejar el error aquí si es necesario
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _fbKey,
        child: Column(
          children: [
            FormBuilderDateTimePicker(
              name: 'dateEvent',
              inputType: InputType.date,
              //format: DateFormat('yyyy-MM-dd'),
              decoration: const InputDecoration(labelText: 'Fecha'),
            ),

            FormBuilderDropdown(
              name: 'severity',
              decoration: const InputDecoration(
                labelText: 'Severidad',
                hintText: 'Selecciona una severidad',
              ),
              items: severidades
                  .map((severidad) => DropdownMenuItem(
                        value: severidad,
                        child: Text(severidad),
                      ))
                  .toList(),
            ),

            /*  FormBuilderDropdown(
              name: 'Pseverity',
              decoration: const InputDecoration(
                  labelText: 'Severidad Potencial',
                  hintText: 'Selecciona una severidad potencial'),
              items: severidades
                  .map((severidad) => DropdownMenuItem(
                        value: severidad,
                        child: Text(severidad),
                      ))
                  .toList(),
            ),
            */

            FormBuilderDropdown(
              name: 'BodyPart',
              decoration: const InputDecoration(
                  labelText: 'Parte del cuerpo lesionada',
                  hintText: 'Selecciona una parte del cuerpot lesionada'),
              items: bodyPart
                  .map((bodyPart) => DropdownMenuItem(
                        value: bodyPart,
                        child: Text(bodyPart),
                      ))
                  .toList(),
            ),

            /* FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            */

            FormBuilderDropdown(
              name: 'injury',
              decoration: const InputDecoration(
                  labelText: 'Tipo de lesión',
                  hintText: 'Selecciona un tipo de lesión'),
              items: injury
                  .map((injury) => DropdownMenuItem(
                        value: injury,
                        child: Text(injury),
                      ))
                  .toList(),
            ),

            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(labelText: 'Descripción'),
            ),

            // ... Agrega más campos según sea necesario ...

            // Botón de envío del formulario
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Enviar formulario'),
            ),
          ],
        ),
      ),
    );
  }
}
