// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../home/views/home_view.dart';
import '../sources/list_risk.dart';

class RiskPage extends StatefulWidget {
  RiskPage({Key? key}) : super(key: key);

  @override
  State<RiskPage> createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/risk';

  int _currentIndexPuesto = 0;
  int _currentIndexArea = 0;
  int _currentIndexTipo = 0;
  int _currentIndexProbabilidad = 0;
  int _currentIndexGravedad = 0;
  int _currentIndexClasificaMC = 0;

  String getWrappedButtonValue(List<String?> options, int currentIndex) {
    List<String> nonNullOptions =
        options.where((element) => element != null).cast<String>().toList();

    if (currentIndex >= 0 && currentIndex < nonNullOptions.length) {
      return nonNullOptions[currentIndex];
    }
    return '';
  }

  void _submitForm() async {
    String? token = await TokenManager.getToken();

    if (_formKey.currentState!.saveAndValidate()) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);
      formData['date'] = formData['date'].toIso8601String();

      formData['puesto'] =
          getWrappedButtonValue(ListDropdownRisk.puesto, _currentIndexPuesto);
      formData['area'] =
          getWrappedButtonValue(ListDropdownRisk.areas, _currentIndexArea);
      formData['tipo'] = getWrappedButtonValue(
          ListDropdownRisk.tipo.map((item) => item['value']).toList(),
          _currentIndexTipo);
      formData['probabilidad'] = getWrappedButtonValue(
          ListDropdownRisk.probabilidad.map((item) => item['value']).toList(),
          _currentIndexProbabilidad);
      formData['gravedad'] = getWrappedButtonValue(
          ListDropdownRisk.gravedad.map((item) => item['value']).toList(),
          _currentIndexGravedad);
      formData['clasificaMC'] = getWrappedButtonValue(
          ListDropdownRisk.clasificaMC.map((item) => item['value']).toList(),
          _currentIndexClasificaMC);

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
        print('Información enviada correctamente.');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Vamos'),
              content: const Text('La identificación se creó correctamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                    );
                  },
                  child: const Text('Volver a inicio'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de peligros y riesgos'),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      child: FormBuilderDateTimePicker(
                        name: 'date',
                        inputType: InputType.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        decoration: const InputDecoration(
                            labelText: 'Fecha del analisis'),
                        validator: FormBuilderValidators.required(
                          errorText: 'La fecha no puede estar vacía',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      'El puesto que eligió: ${ListDropdownRisk.puesto[_currentIndexPuesto]}'),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  width: 400,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: ListDropdownRisk.puesto.map((puesto) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentIndexPuesto =
                                ListDropdownRisk.puesto.indexOf(puesto);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: _currentIndexPuesto ==
                                  ListDropdownRisk.puesto.indexOf(puesto)
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          backgroundColor: _currentIndexPuesto ==
                                  ListDropdownRisk.puesto.indexOf(puesto)
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          side: BorderSide(
                            color: _currentIndexPuesto ==
                                    ListDropdownRisk.puesto.indexOf(puesto)
                                ? Colors.teal
                                : Colors.grey,
                          ),
                        ),
                        child: Text(puesto),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'El área que eligió es: ${ListDropdownRisk.areas[_currentIndexArea]}'),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: ListDropdownRisk.areas.map((area) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexArea =
                                    ListDropdownRisk.areas.indexOf(area);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexArea ==
                                      ListDropdownRisk.areas.indexOf(area)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexArea ==
                                      ListDropdownRisk.areas.indexOf(area)
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexArea ==
                                        ListDropdownRisk.areas.indexOf(area)
                                    ? const Color.fromARGB(255, 203, 125, 0)
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(area),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: FormBuilderTextField(
                      name: 'tarea',
                      decoration: const InputDecoration(
                          labelText:
                              'Escriba aquí la actividad, proceso o instalación relacionada'),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo no puede estar vacío',
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: FormBuilderDropdown(
                      name: 'fuente',
                      decoration: const InputDecoration(
                        labelText: 'Fuente o Situación ',
                        hintText: 'Selecciona una severidad',
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo severidad no puede estar vacío',
                      ),
                      items: ListDropdownRisk.fuente
                          .map((fuente) => DropdownMenuItem(
                                value: fuente['value'],
                                child: Text(fuente['label'] ?? ''),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: FormBuilderDropdown(
                      name: 'incidentesPotenciales',
                      decoration: const InputDecoration(
                        labelText: 'Incidente potencial',
                        hintText: 'Selecciona un incidente potencial',
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'Este campo no puede estar vacío',
                      ),
                      items: ListDropdownRisk.incidentesPotenciales
                          .map((incidentesPotenciales) => DropdownMenuItem(
                                value: incidentesPotenciales['value'],
                                child:
                                    Text(incidentesPotenciales['label'] ?? ''),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: FormBuilderDropdown(
                      name: 'consecuencia',
                      decoration: const InputDecoration(
                        labelText: 'Consecuencias ',
                        hintText: 'Selecciona una consecuencia',
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'Este campo no puede estar vacío',
                      ),
                      items: ListDropdownRisk.consecuencia
                          .map((consecuencia) => DropdownMenuItem(
                                value: consecuencia['value'],
                                child: Text(consecuencia['label'] ?? ''),
                              ))
                          .toList(),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'El tipo de tarea que eligió es: ${ListDropdownRisk.tipo[_currentIndexTipo]['label']}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownRisk.tipo.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexTipo =
                                    ListDropdownRisk.tipo.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexTipo ==
                                      ListDropdownRisk.tipo.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexTipo ==
                                      ListDropdownRisk.tipo.indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexTipo ==
                                        ListDropdownRisk.tipo.indexOf(item)
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(label),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'La probabilidad que eligió es: ${ListDropdownRisk.probabilidad[_currentIndexProbabilidad]['label']}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownRisk.probabilidad.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexProbabilidad =
                                    ListDropdownRisk.probabilidad.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexProbabilidad ==
                                      ListDropdownRisk.probabilidad
                                          .indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexProbabilidad ==
                                      ListDropdownRisk.probabilidad
                                          .indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexProbabilidad ==
                                        ListDropdownRisk.probabilidad
                                            .indexOf(item)
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(label),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'La gravedad que eligió es: ${ListDropdownRisk.gravedad[_currentIndexGravedad]['label']}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownRisk.gravedad.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexGravedad =
                                    ListDropdownRisk.gravedad.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexGravedad ==
                                      ListDropdownRisk.gravedad.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexGravedad ==
                                      ListDropdownRisk.gravedad.indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexGravedad ==
                                        ListDropdownRisk.gravedad.indexOf(item)
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(label),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Establecer medida de control',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Puesto: ${ListDropdownRisk.puesto[_currentIndexPuesto]}',
                      ),
                      Text(
                        'Área: ${ListDropdownRisk.areas[_currentIndexArea]}',
                      ),
                      Text(
                        'Fuente o Situación: ${ListDropdownRisk.fuente.firstWhere((item) => item['value'] == _formKey.currentState?.fields['fuente']?.value, orElse: () => {
                              'label': 'N/A'
                            })['label']}',
                      ),
                      Text(
                        'Incidente potencial: ${ListDropdownRisk.consecuencia.firstWhere((item) => item['value'] == _formKey.currentState?.fields['consecuencia']?.value, orElse: () => {
                              'label': 'N/A'
                            })['label']}',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'La clasificación es: ${ListDropdownRisk.clasificaMC[_currentIndexClasificaMC]['label']}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownRisk.clasificaMC.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexClasificaMC =
                                    ListDropdownRisk.clasificaMC.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexClasificaMC ==
                                      ListDropdownRisk.clasificaMC.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexClasificaMC ==
                                      ListDropdownRisk.clasificaMC.indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexClasificaMC ==
                                        ListDropdownRisk.clasificaMC
                                            .indexOf(item)
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(label),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: FormBuilderTextField(
                        name: 'medidaControl',
                        decoration: const InputDecoration(
                          labelText: 'Describa la medida de Control',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                        maxLines: 5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar formulario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
