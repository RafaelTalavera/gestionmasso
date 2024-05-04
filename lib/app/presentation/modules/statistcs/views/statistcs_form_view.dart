// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class StatistcsFormPage extends StatefulWidget {
  const StatistcsFormPage({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  final String id;
  final String name;

  @override
  State<StatistcsFormPage> createState() => _StatistcsFormPagePageState();
}

class _StatistcsFormPagePageState extends State<StatistcsFormPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String apiUrl = 'http://10.0.2.2:8080/api/statistcs';

  final String interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

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

      formData['organizationId'] = widget.id;
      formData['year'] = formData['year'];
      formData['month'] = formData['month'];

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
              title: const Text('Datos'),
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
          'Datos del Mes',
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
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: FormBuilderTextField(
                      name: 'nameOrganization',
                      initialValue: widget.name,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Organización',
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
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        child: FormBuilderTextField(
                          name: 'hours',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Horas trabajadas',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'El campo no puede estar vacío',
                            ),
                            FormBuilderValidators.integer(
                              errorText: 'Por favor, ingrese un número entero',
                            ),
                          ]),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 400,
                        child: FormBuilderTextField(
                          name: 'people',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Número de Personas',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'El campo no puede estar vacío',
                            ),
                            FormBuilderValidators.integer(
                              errorText: 'Por favor, ingrese un número entero',
                            ),
                          ]),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 400,
                        child: Row(
                          children: [
                            Expanded(
                              child: FormBuilderDropdown<int>(
                                name: 'year',
                                decoration: const InputDecoration(
                                  labelText: 'Seleccione el año',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                validator: FormBuilderValidators.required(
                                  errorText: 'Por favor, seleccione un año',
                                ),
                                items: List.generate(5, (index) {
                                  final year = DateTime.now().year - 2 + index;
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text('$year'),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: FormBuilderDropdown<int>(
                                name: 'month',
                                decoration: const InputDecoration(
                                  labelText: 'Seleccione el mes',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                validator: FormBuilderValidators.required(
                                  errorText: 'Por favor, seleccione un mes',
                                ),
                                items: List.generate(12, (index) {
                                  final monthNumber = index + 1;
                                  final monthName = DateFormat('MMMM')
                                      .format(DateTime(2023, monthNumber));
                                  return DropdownMenuItem(
                                    value: monthNumber,
                                    child: Text(monthName),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Enviar formulario'),
                      ),
                    ],
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
