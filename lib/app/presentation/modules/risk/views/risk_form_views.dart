// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../home/views/home_view.dart';
import 'risk_table_organization.dart';

import '../sources/risk_list_dropdown.dart';

class RiskPage extends StatefulWidget {
  const RiskPage({
    super.key,
    required String initialCompany,
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  @override
  State<RiskPage> createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final String apiUrl = 'http://10.0.2.2:8080/api/risk';

  int _currentIndexPuesto = -1;
  int _currentIndexArea = -1;
  int _currentIndexConsecuencia = -1;
  int _currentIndexIncidentesPotenciales = -1;
  int _currentIndexTipo = 0;
  int _currentIndexProbabilidad = 0;
  int _currentIndexGravedad = 0;
  int _currentIndexClasificaMC = 0;

  final String interstitialAdUnitId =
      Platform.isAndroid ? '' : 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

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
      formData['tipo'] =
          getWrappedButtonValue(ListDropdownRisk.tipo, _currentIndexTipo);
      formData['consecuencia'] = getWrappedButtonValue(
          ListDropdownRisk.consecuencia, _currentIndexConsecuencia);

      formData['incidentesPotenciales'] = getWrappedButtonValue(
          ListDropdownRisk.incidentesPotenciales,
          _currentIndexIncidentesPotenciales);
      formData['probabilidad'] = getWrappedButtonValue(
          ListDropdownRisk.probabilidad.map((item) => item['value']).toList(),
          _currentIndexProbabilidad);
      formData['gravedad'] = getWrappedButtonValue(
          ListDropdownRisk.gravedad.map((item) => item['value']).toList(),
          _currentIndexGravedad);
      formData['clasificaMC'] = getWrappedButtonValue(
          ListDropdownRisk.clasificaMC, _currentIndexClasificaMC);
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
              title: const Text('Riesgo agregado a la matriz'),
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
                          builder: (context) =>
                              const OrganizationTableSelectionScreen()),
                    );
                  },
                  child: const Text('Ir al IPER'),
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

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final double availableWidth = MediaQuery.of(context).size.width;
    double fontSize = Utils.calculateTitleFontSize(context);

    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Relevamiento Riesgos',
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
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: availableWidth * 0.89,
                      child: FormBuilderDateTimePicker(
                        name: 'date',
                        inputType: InputType.date,
                        firstDate: DateTime(2000),
                        format: DateFormat('dd, MMMM yyyy'),
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
                  ),
                  const SizedBox(
                    height: 10,
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
                          : ListDropdownRisk.areas[_currentIndexArea],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexArea =
                              ListDropdownRisk.areas.indexOf(newValue!);
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
                        ...ListDropdownRisk.areas.map((value) {
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
                          : ListDropdownRisk.puesto[_currentIndexPuesto],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexPuesto =
                              ListDropdownRisk.puesto.indexOf(newValue!);
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
                        ...ListDropdownRisk.puesto.map((value) {
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
                    child: FormBuilderTextField(
                      name: 'tarea',
                      decoration: const InputDecoration(
                        labelText: 'Escriba aquí la actividad',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'El campo no puede estar vacío',
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: availableWidth * 0.89,
                    child: DropdownButtonFormField<String>(
                      value: _currentIndexConsecuencia == -1
                          ? null
                          : ListDropdownRisk
                              .consecuencia[_currentIndexConsecuencia],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexConsecuencia =
                              ListDropdownRisk.consecuencia.indexOf(newValue!);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Consecuencia',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Elija una consecuencia',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ...ListDropdownRisk.consecuencia.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, una consecuencia';
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
                      value: _currentIndexIncidentesPotenciales == -1
                          ? null
                          : ListDropdownRisk.incidentesPotenciales[
                              _currentIndexIncidentesPotenciales],
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentIndexIncidentesPotenciales = ListDropdownRisk
                              .incidentesPotenciales
                              .indexOf(newValue!);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Incidentes potenciales',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Elija un incidente potencial',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ...ListDropdownRisk.incidentesPotenciales.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, un incidente potencial';
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
                        'El tipo de tarea que eligió es: ${ListDropdownRisk.tipo[_currentIndexTipo]}',
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
                      width: availableWidth * 0.89,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownRisk.tipo.map((item) {
                          String label = item;
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
                      width: availableWidth * 0.89,
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
                      width: availableWidth * 0.89,
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
                        height: 20,
                      ),
                      Text(
                        'La clasificación es: ${ListDropdownRisk.clasificaMC[_currentIndexClasificaMC]}',
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
                      width: availableWidth * 0.89,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: ListDropdownRisk.clasificaMC.map((item) {
                          String label = item;
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: availableWidth * 0.89,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: FormBuilderTextField(
                        name: 'medidaControl',
                        decoration: const InputDecoration(
                          labelText: 'Describa la medida de Control',
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
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  _showInterstitialAd();
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
