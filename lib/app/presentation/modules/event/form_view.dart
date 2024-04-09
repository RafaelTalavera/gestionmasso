import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../data/services/remote/token_manager.dart';
import '../../global/widgets/custom_AppBar.dart';
import 'causas_views.dart';
import 'event_table.dart';
import '../home/views/home_view.dart';
import 'list_dropdown.dart';

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
      appBar: const CustomAppBar(
        titleWidget: Text(
          'Carga de eventos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 238, 183, 19),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Color celeste claro
        ),
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: MyForm(),
          ),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final String apiUrl = 'http://10.0.2.2:8080/api/events';

  int _currentSeverityIndex = 0;
  int _currentbodyPartIndex = -1;
  int _currentInjuryIndex = -1;
  bool entry = false;
  bool accidentHistory = false;
  bool workOccasion = false;
  bool hoursWorked = false;
  bool authorization = false;
  bool authorizationWork = false;
  bool pts = false;
  bool ptsApplied = false;
  bool machine = false;
  int _currentEnergyIndex = 0;
  bool lockedIn = false;
  bool lockedRequired = false;
  bool lockedUsed = false;
  bool fails = false;

  void _submitForm() async {
    String? token = await TokenManager.getToken();

    if (_fbKey.currentState!.saveAndValidate()) {
      final formData = Map<String, dynamic>.from(_fbKey.currentState!.value);
      formData['dateEvent'] = formData['dateEvent'].toIso8601String();
      formData['severity'] = ListDropdown.severidades[_currentSeverityIndex];
      formData['bodyPart'] = ListDropdown.bodyPart[_currentbodyPartIndex];
      formData['injury'] = ListDropdown.injury[_currentInjuryIndex];
      formData['entry'] = entry;
      formData['accidentHistory'] = accidentHistory;
      formData['workOccasion'] = workOccasion;
      formData['hoursWorked '] = hoursWorked;
      formData['authorization'] = authorization;
      formData['authorizationWork'] = authorizationWork;
      formData['pts'] = pts;
      formData['ptsApplied'] = ptsApplied;
      formData['machine'] = machine;
      formData['energy'] = ListDropdown.energy[_currentEnergyIndex];
      formData['lockedIn'] = lockedIn;
      formData['lockedRequired'] = lockedRequired;
      formData['lockedUsed'] = lockedUsed;
      formData['fails'] = fails;

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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventTable()));
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
                      // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fbKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            FormBuilderTextField(
              name: 'title',
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Identificación del evento',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
                suffixText: 'Titulo',
              ),
              validator: FormBuilderValidators.required(
                errorText: 'El campo título no puede estar vacío',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FormBuilderDateTimePicker(
              name: 'dateEvent',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              decoration: const InputDecoration(
                labelText: 'Fecha del evento',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
                suffixText: 'Fecha',
              ),
              validator: FormBuilderValidators.required(
                errorText: 'La fecha del evento no puede estar vacía',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'La severidad que eligió es: ${ListDropdown.severidades[_currentSeverityIndex]}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5.0,
                runSpacing: 5.0,
                children: ListDropdown.severidades.map((severidad) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSeverityIndex =
                            ListDropdown.severidades.indexOf(severidad);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: _currentSeverityIndex ==
                              ListDropdown.severidades.indexOf(severidad)
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      backgroundColor: _currentSeverityIndex ==
                              ListDropdown.severidades.indexOf(severidad)
                          ? Colors
                              .red // Cambiado desde Theme.of(context).focusColor.red
                          : Colors.white,
                      side: BorderSide(
                        color: _currentSeverityIndex ==
                                ListDropdown.severidades.indexOf(severidad)
                            ? Colors.teal
                            : Colors.grey,
                      ),
                    ),
                    child: Text(severidad),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _currentbodyPartIndex == -1
                        ? null
                        : ListDropdown.bodyPart[_currentbodyPartIndex],
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentbodyPartIndex =
                            ListDropdown.bodyPart.indexOf(newValue!);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Parte del cuerpo',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Elija una parte del cuerpo',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ...ListDropdown.bodyPart.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, elija un área';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _currentInjuryIndex == -1
                        ? null
                        : ListDropdown.injury[_currentInjuryIndex],
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentInjuryIndex =
                            ListDropdown.injury.indexOf(newValue!);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Lesión',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Elija una lesión',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ...ListDropdown.injury.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, elija un lesión';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  '¿La antiguedad es: ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 30),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      entry = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  entry ? ' + 6 meses' : ' - 6 meses',
                  style: TextStyle(
                    color: entry ? Colors.green : Colors.red,
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
                  '¿Tuvo accidentes previos?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 40),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      accidentHistory = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  accidentHistory ? ' Si' : ' No',
                  style: TextStyle(
                    color: accidentHistory ? Colors.green : Colors.red,
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
                  '¿Tpo de tarea?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 50),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      workOccasion = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  workOccasion ? ' Rutinaria' : ' No Rutinaria',
                  style: TextStyle(
                    color: workOccasion ? Colors.green : Colors.red,
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
                  '¿Horas tratabajas?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 30),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      hoursWorked = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  hoursWorked ? ' + 8 hr' : ' - 8 hr',
                  style: TextStyle(
                    color: hoursWorked ? Colors.black : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  '¿Requería autorización?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 70),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      authorization = value;
                    });
                  },
                ),
                const SizedBox(height: 0),
                Text(
                  authorization ? ' Si' : ' No',
                  style: TextStyle(
                    color: authorization ? Colors.red : Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: authorization,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        '¿Tenía autorización?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 95),
                      AdvancedSwitch(
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey,
                        width: 60.0,
                        height: 30.0,
                        onChanged: (value) {
                          setState(() {
                            authorizationWork = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        authorizationWork ? ' Si' : ' No',
                        style: TextStyle(
                          color: authorizationWork ? Colors.green : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  '¿Procedimiento Trabajo?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .black, // Puedes ajustar el color según tus preferencias
                  ),
                ),
                const SizedBox(width: 65),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      pts = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  pts ? ' Si' : ' No',
                  style: TextStyle(
                    color: pts ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: pts,
              child: Row(
                children: [
                  const Text(
                    '¿Tenía autorización?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .black, // Puedes ajustar el color según tus preferencias
                    ),
                  ),
                  const SizedBox(width: 95),
                  AdvancedSwitch(
                    activeColor: Colors.grey,
                    inactiveColor: Colors.grey,
                    width: 60.0,
                    height: 30.0,
                    onChanged: (value) {
                      setState(() {
                        ptsApplied = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    ptsApplied ? ' Si' : ' No',
                    style: TextStyle(
                      color: ptsApplied ? Colors.green : Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  '¿Equipo energizado?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .black, // Puedes ajustar el color según tus preferencias
                  ),
                ),
                const SizedBox(width: 90),
                AdvancedSwitch(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      machine = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  machine ? ' Si' : ' No',
                  style: TextStyle(
                    color: machine ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: machine,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      'La energía elegida es: ${ListDropdown.energy[_currentEnergyIndex]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: ListDropdown.energy.map((energy) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentEnergyIndex =
                                  ListDropdown.energy.indexOf(energy);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: _currentEnergyIndex ==
                                    ListDropdown.energy.indexOf(energy)
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            backgroundColor: _currentEnergyIndex ==
                                    ListDropdown.energy.indexOf(energy)
                                ? Colors.red
                                : Colors.white,
                            side: BorderSide(
                              color: _currentEnergyIndex ==
                                      ListDropdown.energy.indexOf(energy)
                                  ? Colors.teal
                                  : Colors.grey,
                            ),
                          ),
                          child: Text(energy),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Es posible bloquear la energía ${ListDropdown.energy[_currentEnergyIndex]}?',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AdvancedSwitch(
                          activeColor: Colors.grey,
                          inactiveColor: Colors.grey,
                          width: 60.0,
                          height: 30.0,
                          onChanged: (value) {
                            setState(() {
                              lockedIn = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lockedIn ? ' Si' : ' No',
                          style: TextStyle(
                            color: lockedIn ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Se requeria bloquear la energía ${ListDropdown.energy[_currentEnergyIndex]}?',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AdvancedSwitch(
                          activeColor: Colors.grey,
                          inactiveColor: Colors.grey,
                          width: 60.0,
                          height: 30.0,
                          onChanged: (value) {
                            setState(() {
                              lockedRequired = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lockedRequired ? ' Si' : ' No',
                          style: TextStyle(
                            color: lockedRequired ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿La persona bloqueo la energía ${ListDropdown.energy[_currentEnergyIndex]}?',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AdvancedSwitch(
                          activeColor: Colors.grey,
                          inactiveColor: Colors.grey,
                          width: 60.0,
                          height: 30.0,
                          onChanged: (value) {
                            setState(() {
                              lockedUsed = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lockedUsed ? ' Si' : ' No',
                          style: TextStyle(
                            color: lockedUsed ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿El equipo falló antes del evento?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AdvancedSwitch(
                          activeColor: Colors.grey,
                          inactiveColor: Colors.grey,
                          width: 60.0,
                          height: 30.0,
                          onChanged: (value) {
                            setState(() {
                              fails = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          fails ? ' Si' : ' No',
                          style: TextStyle(
                            color: fails ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
      ),
    );
  }
}
