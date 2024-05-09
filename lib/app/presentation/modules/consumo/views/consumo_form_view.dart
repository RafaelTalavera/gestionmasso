// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../home/views/home_view.dart';
import '../sources/consumo_list_dropdown.dart';
import 'consumo_organization_select_table_view .dart';

class InventoryFormConsumoPage extends StatefulWidget {
  const InventoryFormConsumoPage({
    super.key,
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  @override
  State<InventoryFormConsumoPage> createState() =>
      _InventoryFormConsumoPageState();
}

class _InventoryFormConsumoPageState extends State<InventoryFormConsumoPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/consumo';

  int _currentIndexFuente = 0;
  int _currentIndexCombustible = -1;
  int _currentIndexTipoDeFuente = -1;
  int _currentIndexUnidad = 0;

  final TextEditingController _consumoController = TextEditingController();

  void _submitForm() async {
    String? token = await TokenManager.getToken();

    if (_formKey.currentState!.saveAndValidate()) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);

      formData['date'] = formData['date'].toIso8601String();
      formData['consumo'] = double.parse(_consumoController.text);
      formData['combustible'] =
          ListDropdownInventory.combustible[_currentIndexCombustible];
      formData['unidad'] = ListDropdownInventory.unidades[_currentIndexUnidad];
      formData['tipoFuente'] =
          ListDropdownInventory.fuenteMoviles[_currentIndexTipoDeFuente];
      formData['tipoDeFuente'] =
          ListDropdownInventory.fuentesFijas[_currentIndexTipoDeFuente];
      formData['fuente'] = ListDropdownInventory.fuente[_currentIndexFuente];

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
              title: const Text('Organización'),
              content: const Text('Exito.'),
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
                          builder: (context) =>
                              const ConsumoOrgaTableSelectionScreen()),
                    );
                  },
                  child: const Text('Ir a listado'),
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
          "${widget.name}",
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
                  const Text(
                    'Ingreso de consumo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                        labelText: 'Nombre de la organización',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: availableWidth * 0.9,
                      child: FormBuilderDateTimePicker(
                        name: 'date',
                        inputType: InputType.date,
                        firstDate: DateTime(2000),
                        format: DateFormat('dd, MMMM yyyy'),
                        lastDate: DateTime.now(),
                        decoration: const InputDecoration(
                          labelText: 'Fecha del consumo',
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'El tipo de fuente que eligió es: ${ListDropdownInventory.fuente[_currentIndexFuente]}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue),
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
                        children: ListDropdownInventory.fuente.map((item) {
                          String label = item;
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexFuente =
                                    ListDropdownInventory.fuente.indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexFuente ==
                                      ListDropdownInventory.fuente.indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexFuente ==
                                      ListDropdownInventory.fuente.indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexFuente ==
                                        ListDropdownInventory.fuente
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
                  Center(
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _currentIndexCombustible == -1
                              ? null
                              : ListDropdownInventory
                                  .combustible[_currentIndexCombustible],
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentIndexCombustible = ListDropdownInventory
                                  .combustible
                                  .indexOf(newValue!);
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Consumo',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Elija un tipo de consumo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ListDropdownInventory.combustible.map((value) {
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
                  if (_currentIndexFuente == 0) // Si se eligió 'Fija'
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _currentIndexTipoDeFuente == -1
                                ? null
                                : ListDropdownInventory
                                    .fuentesFijas[_currentIndexTipoDeFuente],
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentIndexTipoDeFuente =
                                    ListDropdownInventory.fuentesFijas
                                        .indexOf(newValue!);
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Tipos de fuentes fijas',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text(
                                  'Elija un tipo de fuente',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              ...ListDropdownInventory.fuentesFijas
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, elija un tipo de fuente';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  if (_currentIndexFuente == 1) // Si se eligió 'Móvil'
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _currentIndexTipoDeFuente == -1
                                ? null
                                : ListDropdownInventory
                                    .fuenteMoviles[_currentIndexTipoDeFuente],
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentIndexTipoDeFuente =
                                    ListDropdownInventory.fuenteMoviles
                                        .indexOf(newValue!);
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Tipos de fuentes móviles',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text(
                                  'Elija un tipo de fuente',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              ...ListDropdownInventory.fuenteMoviles
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, elija un tipo de fuente';
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
                      controller: _consumoController,
                      decoration: const InputDecoration(
                        labelText: 'Consumo',
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'La unidad de medida que eligió es: ${ListDropdownInventory.unidades[_currentIndexUnidad]}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const Center(
                        child: Text(
                          'Es muy importante siempre usar la misma unidad para los consumos',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownInventory.unidades.map((item) {
                          String label = item;
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentIndexUnidad = ListDropdownInventory
                                    .unidades
                                    .indexOf(item);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _currentIndexUnidad ==
                                      ListDropdownInventory.unidades
                                          .indexOf(item)
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              backgroundColor: _currentIndexUnidad ==
                                      ListDropdownInventory.unidades
                                          .indexOf(item)
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.white,
                              side: BorderSide(
                                color: _currentIndexUnidad ==
                                        ListDropdownInventory.unidades
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
