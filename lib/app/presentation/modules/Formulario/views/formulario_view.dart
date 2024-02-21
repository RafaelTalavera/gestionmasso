import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../causas/views/causas_views.dart';
import '../../event_table/views/event_table.dart';
import '../../home/views/home_view.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Color celeste claro
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MyForm(),
          ),
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
        final Map<String, dynamic> responseData = jsonDecode(responsePost.body);
        final String? id = responseData['id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('event_id', id ?? '');
        // Guardar el ID en una variable que puedas usar
        print('ID del evento creado: $id');

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Éxito'),
              content: const Text('El evento se creó correctamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => EventTable()));
                  },
                  child: const Text('Listado'),
                ),
                TextButton(
                  onPressed: () async {
                    // Recuperar el ID guardado de SharedPreferences
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? savedId = prefs.getString('event_id');

                    if (savedId != null && savedId.isNotEmpty) {
                      // Navegar a la pantalla de hipótesis pasando el ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HypothesisScreen(eventId: savedId),
                        ),
                      );
                    } else {
                      print('No hay ID guardado.');
                      // Manejar caso donde no hay ID guardado
                    }
                  },
                  child: const Text('Hipotesis'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()));
                  },
                  child: const Text('salir'),
                ),
              ],
            );
          },
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
            validator: FormBuilderValidators.required(
              errorText: 'La fecha del evento no puede estar vacía',
            ),
          ),
          FormBuilderDropdown(
            name: 'severity',
            decoration: const InputDecoration(
              labelText: 'Severidad',
              hintText: 'Selecciona una severidad',
            ),
            validator: FormBuilderValidators.required(
              errorText: 'El campo severidad no puede estar vacío',
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
            validator: FormBuilderValidators.required(
              errorText:
                  'El campo cuerpo parte del cuerpo lesionada no puede estar vacío',
            ),
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
            validator: FormBuilderValidators.required(
              errorText: 'El campo lesión no puede estar vacío',
            ),
            items: ListasDropdown.injury
                .map((injury) => DropdownMenuItem(
                      value: injury['value'],
                      child: Text(injury['label'] ?? ''),
                    ))
                .toList(),
          ),
          FormBuilderCheckbox(
            name: 'entry',
            title: const Text(
                'Tilda aquí si tiene más de 6 meses en el puesto de trabajo'),
            initialValue: false,
            onChanged: (value) {
              setState(() {
                showPtsApplied = value ?? false;
              });
            },
          ),
          FormBuilderCheckbox(
            name: 'accidentHistory',
            title:
                const Text('Tilda aquí si la persona tuvo accidentes previos'),
            initialValue: false,
            onChanged: (value) {
              setState(() {
                showPtsApplied = value ?? false;
              });
            },
          ),
          FormBuilderDropdown(
            name: 'hoursWorked',
            decoration: const InputDecoration(
                labelText: '¿Cuantas horas llevaba trabajadas?',
                hintText: 'Selecciona un rango de horario'),
            validator: FormBuilderValidators.required(
              errorText: 'El campo horas trabajadas no puede estar vacío',
            ),
            items: ListasDropdown.hoursWorked
                .map((hoursWorked) => DropdownMenuItem(
                      value: hoursWorked['value'],
                      child: Text(hoursWorked['label'] ?? ''),
                    ))
                .toList(),
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
                  name: 'energy',
                  decoration: const InputDecoration(
                    labelText: 'Energía utilizada',
                    hintText: 'Selecciona la energía utilizada',
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'El campo energía no puede estar vacío',
                  ),
                  items: ListasDropdown.energia
                      .map((energia) => DropdownMenuItem(
                            value: energia['value'],
                            child: Text(energia['label'] ?? ''),
                          ))
                      .toList(),
                  // Establecer el primer elemento como predeterminado
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
                  name: 'fails',
                  title: const Text(
                      'Tilda aquí si el equipo utilizado presentaba fallas previas'),
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
