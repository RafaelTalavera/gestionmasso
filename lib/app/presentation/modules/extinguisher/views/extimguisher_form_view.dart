// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/List_extimguisher.dart';
import 'extimguisher_table_organization.dart';

class ExtinguerPage extends StatefulWidget {
  const ExtinguerPage({
    super.key,
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  State<ExtinguerPage> createState() => _ExtinguerPageState();
}

class _ExtinguerPageState extends State<ExtinguerPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/extinguishers';

  int _currentIndexTipo = 0;
  int _currentIndexArea = -1;
  bool access = false;
  bool presion = false;
  bool signaling = false;

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
      formData['vencimiento'] = formData['vencimiento'].toIso8601String();
      formData['tipo'] = ListDropdownExtimguisher.tipo[_currentIndexTipo];
      formData['sector'] = getWrappedButtonValue(
          ListDropdownExtimguisher.areas, _currentIndexArea);

      formData['access'] = access;
      formData['signaling'] = signaling;
      formData['presion'] = presion;
      formData['enabled'] = true;
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
        _showInterstitialAd();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Extintor agregado correctamente'),
              content: const Text('La identificación se creó correctamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OrganizationTableExtimguisherSelectionScreen(),
                      ),
                    );
                  },
                  child: const Text('Control de Extintores'),
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
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Carga de Extintores',
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilderDateTimePicker(
                  name: 'date',
                  inputType: InputType.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  decoration: const InputDecoration(
                    labelText: 'Fecha del control',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    suffixText: 'Fecha del control',
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'La fecha no puede estar vacía',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'El tipo de extintor que eligió es: ${ListDropdownExtimguisher.tipo[_currentIndexTipo]}',
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
                    children: ListDropdownExtimguisher.tipo.map((tipo) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentIndexTipo =
                                ListDropdownExtimguisher.tipo.indexOf(tipo);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: _currentIndexTipo ==
                                  ListDropdownExtimguisher.tipo.indexOf(tipo)
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          backgroundColor: _currentIndexTipo ==
                                  ListDropdownExtimguisher.tipo.indexOf(tipo)
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          side: BorderSide(
                            color: _currentIndexTipo ==
                                    ListDropdownExtimguisher.tipo.indexOf(tipo)
                                ? Colors.teal
                                : Colors.grey,
                          ),
                        ),
                        child: Text(tipo),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FormBuilderTextField(
                  name: 'nameOrganization',
                  initialValue: widget.name,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Empresa',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    suffixText: 'Nombre',
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'El campo no puede estar vacío',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: DropdownButtonFormField<String>(
                    value: _currentIndexArea == -1
                        ? null
                        : ListDropdownExtimguisher.areas[_currentIndexArea],
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentIndexArea =
                            ListDropdownExtimguisher.areas.indexOf(newValue!);
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
                      ...ListDropdownExtimguisher.areas.map((value) {
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
                FormBuilderTextField(
                  name: 'extId',
                  decoration: const InputDecoration(
                    labelText: 'Identificación del extintor',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    suffixText: 'Identificación',
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'El campo no puede estar vacío',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FormBuilderTextField(
                  name: 'kg',
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    suffixText: 'Kg',
                    suffixStyle: TextStyle(fontSize: 16),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'El campo no puede estar vacío',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Ingrese un número válido',
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                FormBuilderDateTimePicker(
                  name: 'vencimiento',
                  inputType: InputType.date,
                  firstDate: DateTime(2000),
                  decoration: const InputDecoration(
                    labelText: 'Fecha de vencimiento',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    suffixText: 'Vencimiento',
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'La fecha no puede estar vacía',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      'Acceso',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 165),
                    AdvancedSwitch(
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                      width: 60.0,
                      height: 30.0,
                      onChanged: (value) {
                        setState(() {
                          access = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      access ? ' Bueno' : ' Malo',
                      style: TextStyle(
                        color: access ? Colors.green : Colors.red,
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
                      'Señalización',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 120),
                    AdvancedSwitch(
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                      width: 60.0,
                      height: 30.0,
                      onChanged: (value) {
                        setState(() {
                          signaling = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      signaling ? ' Buena' : ' Mala',
                      style: TextStyle(
                        color: signaling ? Colors.green : Colors.red,
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
                      'Presión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 164),
                    AdvancedSwitch(
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                      width: 60.0,
                      height: 30.0,
                      onChanged: (value) {
                        setState(() {
                          presion = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      presion ? ' Buena' : ' Mala',
                      style: TextStyle(
                        color: presion ? Colors.green : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FormBuilderTextField(
                  name: 'observaciones',
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    suffixText: 'Observaciones',
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'El campo no puede estar vacío',
                  ),
                ),
                const SizedBox(
                  height: 20,
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
      ),
    );
  }
}
