// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../../home/views/home_view.dart';
import '../sources/accidents_list_dropdown.dart';
import 'accidents_table_screen_view.dart';

class AccidentsPage extends StatefulWidget {
  const AccidentsPage({
    super.key,
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  @override
  State<AccidentsPage> createState() => _AccidentsPageState();
}

class _AccidentsPageState extends State<AccidentsPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final String apiUrl = 'http://10.0.2.2:8080/api/accidents';

  int _currentIndexPuesto = -1;
  int _currentIndexArea = -1;
  int _currentIndexSeverity = -1;

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
      formData['dateEvent'] = formData['dateEvent'].toIso8601String();
      if (formData['dateAlta'] == null) {
        formData.remove('dateAlta');
      } else {
        formData['dateAlta'] = formData['dateAlta'].toIso8601String();
      }

      formData['puesto'] = getWrappedButtonValue(
          ListDropdownAccidents.puesto, _currentIndexPuesto);
      formData['area'] =
          getWrappedButtonValue(ListDropdownAccidents.areas, _currentIndexArea);

      formData['severity'] = getWrappedButtonValue(
          ListDropdownAccidents.severity, _currentIndexSeverity);

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
              title: const Text('Accidente agregado con exito'),
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
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccidentsTable()),
                    );
                  },
                  child: const Text('Ir al listado'),
                ),
              ],
            );
          },
        );
      } else {
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
    final double availableWidth = MediaQuery.of(context).size.width;
    double fontSize = Utils.calculateTitleFontSize(context);

    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Carga de accidentes',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: SizedBox(
                      width: availableWidth * 0.89,
                      child: FormBuilderDateTimePicker(
                        name: 'dateEvent',
                        inputType: InputType.date,
                        firstDate: DateTime(2000),
                        format: DateFormat('dd, MMMM yyyy'),
                        lastDate: DateTime.now(),
                        decoration: const InputDecoration(
                          labelText: 'Fecha del accidente',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'La fecha no puede estar vacía',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              SizedBox(
                width: availableWidth * 0.89,
                child: FormBuilderTextField(
                  name: 'nameOrganization',
                  initialValue: widget.name,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la organización',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: availableWidth * 0.89,
                    child: DropdownButtonFormField<String>(
                      value: _currentIndexArea == -1
                          ? null
                          : ListDropdownAccidents.areas[_currentIndexArea],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexArea =
                              ListDropdownAccidents.areas.indexOf(newValue!);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Área',
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
                        ...ListDropdownAccidents.areas.map((value) {
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: availableWidth * 0.89,
                    child: DropdownButtonFormField<String>(
                      value: _currentIndexPuesto == -1
                          ? null
                          : ListDropdownAccidents.puesto[_currentIndexPuesto],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexPuesto =
                              ListDropdownAccidents.puesto.indexOf(newValue!);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Puesto de trabajo',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Elija un puesto de trabajo',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ...ListDropdownAccidents.puesto.map((value) {
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
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: availableWidth * 0.89,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: 'El campo no puede estar vacío',
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: availableWidth * 0.89,
                    child: DropdownButtonFormField<String>(
                      value: _currentIndexSeverity == -1
                          ? null
                          : ListDropdownAccidents
                              .severity[_currentIndexSeverity],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexSeverity =
                              ListDropdownAccidents.severity.indexOf(newValue!);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Puesto de trabajo',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Elija la severidad',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ...ListDropdownAccidents.severity.map((value) {
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const Center(
                child: Text(
                  'Si el accidente aún no tiene fecha de alta, deje este campo vacío',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue, // Color azul
                    fontSize: 18, // Tamaño de letra 12
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: availableWidth * 0.89,
                  child: FormBuilderDateTimePicker(
                    name: 'dateAlta',
                    inputType: InputType.date,
                    firstDate: DateTime(2000),
                    format: DateFormat('dd, MMMM yyyy'),
                    lastDate: DateTime.now(),
                    decoration: const InputDecoration(
                      labelText: 'Fecha de alta',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
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
