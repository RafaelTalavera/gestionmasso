import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../util/listas_dropdown.dart';

class FormularioAccid extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const FormularioAccid({Key? key});

  @override
  State<FormularioAccid> createState() => _FormularioAccidState();
}

class _FormularioAccidState extends State<FormularioAccid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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

  final String apiUrl = 'http://10.0.2.2:8080/api/events';

  bool showMachineOptions = false;
  bool showAuthorization = false;
  bool showPtsApplied = false;

  void _submitForm() async {
    String? token = await TokenManager.getToken();

    if (_fbKey.currentState!.saveAndValidate()) {
      final formData = Map<String, dynamic>.from(_fbKey.currentState!.value);
      formData['dateEvent'] = formData['dateEvent'].toIso8601String();
      formData['entry'] = formData['entry'].toIso8601String();
      formData['trainingDate'] = formData['trainingDate'].toIso8601String();

      print('JSON enviado a la API:');
      print(jsonEncode(formData));

      final responsePost = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      if (responsePost.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 10),
            content: Text('Evento creado exitosamente'),
          ),
        );
        _fbKey.currentState?.reset();
        Navigator.of(context).pop();
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fbKey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              " Datos del accidente",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Antes de continuar es importante que la información que introduzca refleje la realidad del acontecimiento. En el caso de no tener certeza es mejor dejar la casilla en blanco.",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FormBuilderDateTimePicker(
            name: 'dateEvent',
            inputType: InputType.date,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            decoration: const InputDecoration(labelText: 'Fecha del evento'),
          ),
          FormBuilderDropdown(
            name: 'severity',
            decoration: const InputDecoration(
              labelText: 'Severidad',
              hintText: 'Selecciona una severidad',
            ),
            items: ListasDropdown.severidades
                .map((severidad) => DropdownMenuItem(
                      value: severidad['value'],
                      child: Text(severidad['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderDropdown(
            name: 'bodyPart',
            decoration: const InputDecoration(
                labelText: 'Parte del cuerpo lesionada',
                hintText: 'Selecciona una parte del cuerpot lesionada'),
            items: ListasDropdown.bodyPart
                .map((bodyPart) => DropdownMenuItem(
                      value: bodyPart['value'],
                      child: Text(bodyPart['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderDropdown(
            name: 'injury',
            decoration: const InputDecoration(
                labelText: 'Tipo de lesión',
                hintText: 'Selecciona un tipo de lesión'),
            items: ListasDropdown.injury
                .map((injury) => DropdownMenuItem(
                      value: injury['value'],
                      child: Text(injury['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderDropdown(
            name: 'incidenType',
            decoration: const InputDecoration(
                labelText: 'Tipo de accidente',
                hintText: 'Selecciona un tipo de accidente'),
            items: ListasDropdown.incidenType
                .map((incidenType) => DropdownMenuItem(
                      value: incidenType['value'],
                      child: Text(incidenType['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderDateTimePicker(
            name: 'entry',
            inputType: InputType.date,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            decoration: const InputDecoration(
                labelText: 'Fecha de ingreso del accidentado'),
          ),
          FormBuilderDropdown(
            name: 'workOccasion',
            decoration: const InputDecoration(
                labelText: '¿Que tipo de tarea estaba realizando?',
                hintText: 'Selecciona un tipo de accidente'),
            items: ListasDropdown.workOccasion
                .map((workOccasion) => DropdownMenuItem(
                      value: workOccasion['value'],
                      child: Text(workOccasion['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderDropdown(
            name: 'hoursWorked',
            decoration: const InputDecoration(
                labelText: '¿Cuantas horas llevaba trabajadas?',
                hintText: 'Selecciona un rango de horario'),
            items: ListasDropdown.hoursWorked
                .map((hoursWorked) => DropdownMenuItem(
                      value: hoursWorked['value'],
                      child: Text(hoursWorked['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderDateTimePicker(
            name: 'trainingDate',
            inputType: InputType.date,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            decoration: const InputDecoration(
                labelText: 'Fecha de la ultima capacitación recibida'),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Información del metodo",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          FormBuilderCheckbox(
            name: 'authorization',
            title: const Text(
                'Tilda aquí si la tarea requería de una autorización especial '),
            initialValue: false,
            onChanged: (value) {
              setState(() {
                showAuthorization = value ?? false;
              });
            },
          ),
          Visibility(
            visible: showAuthorization,
            child: Column(
              children: [
                FormBuilderCheckbox(
                  name: 'authorizationWork',
                  title: const Text(
                      'Tilda aquí si el accidentado tenia autorización para realizar la tarea'),
                  initialValue: false,
                ),
              ],
            ),
          ),
          FormBuilderCheckbox(
            name: 'pts',
            title: const Text(
                'Tilda aquí si la tarea tiene un procedimiento de trabajo seguro'),
            initialValue: false,
            onChanged: (value) {
              setState(() {
                showPtsApplied = value ?? false;
              });
            },
          ),
          Visibility(
            visible: showPtsApplied,
            child: Column(
              children: [
                FormBuilderCheckbox(
                  name: 'ptsApplied',
                  title: const Text(
                      'Tilda aquí si el accidentado aplico el procedimiento de trabajo seguro'),
                  initialValue: false,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Información del equipo",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          FormBuilderCheckbox(
            name: 'machine',
            title: const Text(
                'Tilda aquí si la tarea requeria el uso de un equipo energizado'),
            initialValue: false,
            onChanged: (value) {
              setState(() {
                showMachineOptions = value ?? false;
              });
            },
          ),
          Visibility(
            visible: showMachineOptions,
            child: Column(
              children: [
                FormBuilderDropdown(
                  name: 'energia',
                  decoration: const InputDecoration(
                      labelText: 'Energía utilizada',
                      hintText: 'Selecciona la energía utilizada'),
                  items: ListasDropdown.energia
                      .map((energia) => DropdownMenuItem(
                            value: energia['value'],
                            child: Text(energia['label'] ?? ''),
                          ))
                      .toList(),
                ),
                FormBuilderCheckbox(
                  name: 'lockedIn',
                  title: const Text(
                      'Tilda aquí si el equipo puede bloquear las energías que utiliza'),
                  initialValue: false,
                ),
                FormBuilderCheckbox(
                  name: 'lockedRequired',
                  title: const Text(
                      'Tilda aquí si la tarea requeria bloqueo de energías'),
                  initialValue: false,
                ),
                FormBuilderCheckbox(
                  name: 'lockedUsed',
                  title: const Text(
                      'Tilda aquí si el accidentado realizo el bloque de energías requerido'),
                  initialValue: false,
                ),
                FormBuilderCheckbox(
                  name: 'defense',
                  title: const Text(
                      'Tilda aquí si el equipo tenia las defensas para aislar las energías'),
                  initialValue: false,
                ),
                FormBuilderCheckbox(
                  name: 'defenserIntegrity',
                  title: const Text(
                      'Tilda aquí si las defensas estabán en forma integras y operativas'),
                  initialValue: false,
                ),
                FormBuilderCheckbox(
                  name: 'workEquimentFails',
                  title: const Text(
                      'Tilda aquí si el equipo utilizado presentaba fallas previas'),
                  initialValue: false,
                ),
                FormBuilderCheckbox(
                  name: 'correctUseEquimat',
                  title: const Text(
                      'Tilda aquí si el equipo estaba utilizado en forma correcta y para lo que diseño'),
                  initialValue: false,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Enviar formulario'),
          ),
        ],
      ),
    );
  }
}
