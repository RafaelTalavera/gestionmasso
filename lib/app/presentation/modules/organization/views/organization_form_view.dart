// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../home/views/home_view.dart';
import '../sources/list_organization_dropdown.dart';

class OrganizationFormPage extends StatefulWidget {
  const OrganizationFormPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrganizationFormPage> createState() => _LaiPageState();
}

class _LaiPageState extends State<OrganizationFormPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/organization';

  int _currentIndexTipoOrga = -1;
  int _currentIndexSector = -1;

  final TextEditingController _superficieController = TextEditingController();
  final TextEditingController _empleadosController = TextEditingController();

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
      formData['superficie'] = double.parse(_superficieController.text);
      formData['nEmpleados'] = int.parse(_empleadosController.text);
      formData['sector'] = getWrappedButtonValue(
          ListDropdownOrganization.sector, _currentIndexSector);
      formData['tipoOrga'] = getWrappedButtonValue(
          ListDropdownOrganization.tipoOrga, _currentIndexTipoOrga);

      final responsePost = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      if (responsePost.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Organización'),
              content: const Text('Éxito.'),
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
              ],
            );
          },
        );
      } else if (responsePost.statusCode == 500) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Error al enviar la información. La organización ya existe en la base de datos.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Alta de organización',
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: FormBuilderTextField(
                      name: 'name',
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
                          value: _currentIndexTipoOrga == -1
                              ? null
                              : ListDropdownOrganization
                                  .tipoOrga[_currentIndexTipoOrga],
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentIndexTipoOrga = ListDropdownOrganization
                                  .tipoOrga
                                  .indexOf(newValue!);
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Tipo de organización',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Elija un tipo para la organización',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ListDropdownOrganization.tipoOrga.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, elija un tipo para la organización';
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
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _currentIndexSector == -1
                              ? null
                              : ListDropdownOrganization
                                  .sector[_currentIndexSector],
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentIndexSector = ListDropdownOrganization
                                  .sector
                                  .indexOf(newValue!);
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Sector de la organización',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Elija un área',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ListDropdownOrganization.sector.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, elija un sector';
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
                    child: TextFormField(
                      controller: _empleadosController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de empleados',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: TextInputType
                          .number, // Opcional, solo para el tipo de teclado
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly // Acepta solo dígitos
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un valor';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: _superficieController,
                      decoration: const InputDecoration(
                        labelText: 'Superficie',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Teclado para números decimales
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}$'))
                      ], // Permite solo números decimales
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un valor';
                        }
                        return null;
                      },
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
