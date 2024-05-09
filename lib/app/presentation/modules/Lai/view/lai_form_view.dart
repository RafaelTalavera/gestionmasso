// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../home/views/home_view.dart';
import '../sources/list_lai_dropdown.dart';
import 'lai_table_view.dart';

class LaiFormPage extends StatefulWidget {
  const LaiFormPage({
    super.key,
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  @override
  State<LaiFormPage> createState() => _LaiPageState();
}

class _LaiPageState extends State<LaiFormPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/lai';

  int _currentIndexArea = -1;
  int _currentIndexTipo = 0;
  int _currentIndexAspect = -1;
  int _currentIndexImpact = -1;
  int _currentIndexCycle = -1;
  int _currentTypeOfControl = 0;
  int _currentTemporality = 0;
  int _currentIndexfrequency = 0;
  int _currentIndexDamage = 0;
  bool stateHolder = false;
  bool legislation = false;

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
      formData['area'] =
          getWrappedButtonValue(ListDropdownLai.areas, _currentIndexArea);
      formData['tipo'] = ListDropdownLai.tipo[_currentIndexTipo]['value'];
      formData['aspect'] =
          getWrappedButtonValue(ListDropdownLai.aspect, _currentIndexArea);
      formData['impact'] =
          getWrappedButtonValue(ListDropdownLai.impact, _currentIndexImpact);
      formData['cycle'] =
          getWrappedButtonValue(ListDropdownLai.cycle, _currentIndexCycle);
      formData['frequency'] = getWrappedButtonValue(
          ListDropdownLai.frequency.map((item) => item['value']).toList(),
          _currentIndexfrequency);
      formData['damage'] = getWrappedButtonValue(
          ListDropdownLai.damage.map((item) => item['value']).toList(),
          _currentIndexDamage);
      formData['temporality'] =
          ListDropdownLai.temporality[_currentTemporality]['value'];
      formData['typeOfControl'] =
          ListDropdownLai.typeOfControl[_currentTypeOfControl]['value'];
      formData['stateHolder'] = stateHolder;
      formData['legislation'] = legislation;

      formData['organizationId'] = widget.id;

      final responsePost = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      if (responsePost.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Aspecto e Impacto'),
              content: const Text('Identificado correctamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                    );
                  },
                  child: const Text('Salir'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LaiScreen(
                                nameOrganization: '',
                              )),
                    );
                  },
                  child: const Text('Ir al LAI'),
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
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Aspectos e impactos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: FormBuilderDateTimePicker(
                      name: 'date',
                      inputType: InputType.date,
                      format: DateFormat('dd, MMMM yyyy'),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      decoration: const InputDecoration(
                        labelText: 'Fecha del analisis',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'La fecha no puede estar vacía',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: FormBuilderTextField(
                      name: 'nameOrganization',
                      initialValue: widget.name,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Escriba aquí rl nombre de la organización',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo no puede estar vacío',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _currentIndexArea == -1
                              ? null
                              : ListDropdownLai.areas[_currentIndexArea],
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentIndexArea =
                                  ListDropdownLai.areas.indexOf(newValue!);
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Área del Aspecto e Impacto ambiental',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Elija un área',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ListDropdownLai.areas.map((value) {
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
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: FormBuilderTextField(
                      name: 'activity',
                      decoration: const InputDecoration(
                        labelText: 'Escriba aquí la actividad relacionada',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo no puede estar vacío',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'El tipo de actividad es: ${ListDropdownLai.tipo[_currentIndexTipo]['label']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
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
                        children: ListDropdownLai.tipo.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexTipo =
                                    ListDropdownLai.tipo.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexTipo ==
                                      ListDropdownLai.tipo.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexTipo ==
                                      ListDropdownLai.tipo.indexOf(item)
                                  ? Theme.of(context).focusColor
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexTipo ==
                                        ListDropdownLai.tipo.indexOf(item)
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
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    value: _currentIndexAspect == -1
                        ? null
                        : ListDropdownLai.aspect[_currentIndexAspect],
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentIndexAspect =
                            ListDropdownLai.aspect.indexOf(newValue!);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Aspecto Ambiental',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Elija un Aspecto',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ...ListDropdownLai.aspect.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, elija un Aspecto Ambiental';
                      }
                      return null;
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'La temporalidad de impacto es: ${ListDropdownLai.temporality[_currentTemporality]['label']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
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
                        children: ListDropdownLai.temporality.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentTemporality =
                                    ListDropdownLai.temporality.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentTemporality ==
                                      ListDropdownLai.temporality.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentTemporality ==
                                      ListDropdownLai.temporality.indexOf(item)
                                  ? Theme.of(context).focusColor
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentTemporality ==
                                        ListDropdownLai.temporality
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
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 400,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _currentIndexImpact == -1
                              ? null
                              : ListDropdownLai.impact[_currentIndexImpact],
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentIndexImpact =
                                  ListDropdownLai.impact.indexOf(newValue!);
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Impacto ambiental',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Elija un impacto ambiental',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ListDropdownLai.impact.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, elija un impacto ambiental';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _currentIndexCycle == -1
                              ? null
                              : ListDropdownLai.cycle[_currentIndexCycle],
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentIndexCycle =
                                  ListDropdownLai.cycle.indexOf(newValue!);
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Ciclo de vida',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Elija una etapa del ciclo de vida',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ListDropdownLai.cycle.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, elija una etapa del ciclo de vida';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: FormBuilderTextField(
                      name: 'description',
                      decoration: const InputDecoration(
                        labelText: 'Escriba aquí la descripcion del impacto',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo no puede estar vacío',
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'La frecuencia del impacto es: ${ListDropdownLai.frequency[_currentIndexfrequency]['label']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
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
                        children: ListDropdownLai.frequency.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexfrequency =
                                    ListDropdownLai.frequency.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexfrequency ==
                                      ListDropdownLai.frequency.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexfrequency ==
                                      ListDropdownLai.frequency.indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexfrequency ==
                                        ListDropdownLai.frequency.indexOf(item)
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
                  const SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'El daño del impacto es: ${ListDropdownLai.damage[_currentIndexDamage]['label']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
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
                        children: ListDropdownLai.damage.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexDamage =
                                    ListDropdownLai.damage.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexDamage ==
                                      ListDropdownLai.damage.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexDamage ==
                                      ListDropdownLai.damage.indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexDamage ==
                                        ListDropdownLai.damage.indexOf(item)
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
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          '¿Existen State Holder relacionados?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AdvancedSwitch(
                              activeColor: Colors.red,
                              inactiveColor: Colors.green,
                              width: 60.0,
                              height: 30.0,
                              onChanged: (value) {
                                setState(() {
                                  stateHolder = value;
                                });
                              },
                            ),
                            //const SizedBox(width: 10),
                            Text(
                              stateHolder ? ' Si' : ' No',
                              style: TextStyle(
                                color: stateHolder ? Colors.red : Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          '¿Hay Legislación relacionado?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AdvancedSwitch(
                              activeColor: Colors.red,
                              inactiveColor: Colors.green,
                              width: 60.0,
                              height: 30.0,
                              onChanged: (value) {
                                setState(() {
                                  legislation = value;
                                });
                              },
                            ),
                            //const SizedBox(width: 10),
                            Text(
                              legislation ? ' Si' : ' No',
                              style: TextStyle(
                                color: legislation ? Colors.red : Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'El tipo de Medida de control es: ${ListDropdownLai.typeOfControl[_currentTypeOfControl]['label']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                          ),
                        ),
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
                        children: ListDropdownLai.typeOfControl.map((item) {
                          String label = item['label'] ?? '';
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentTypeOfControl =
                                    ListDropdownLai.typeOfControl.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentTypeOfControl ==
                                      ListDropdownLai.typeOfControl
                                          .indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentTypeOfControl ==
                                      ListDropdownLai.typeOfControl
                                          .indexOf(item)
                                  ? Theme.of(context).focusColor
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentTypeOfControl ==
                                        ListDropdownLai.typeOfControl
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: FormBuilderTextField(
                      name: 'descriptionOfControl',
                      decoration: const InputDecoration(
                        labelText: 'Escriba aquí la actividad relacionada',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo no puede estar vacío',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Enviar formulario'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
