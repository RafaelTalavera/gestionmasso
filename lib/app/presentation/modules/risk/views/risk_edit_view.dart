// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../sources/risk_table_data.dart';
import '../sources/risk_list_dropdown.dart';
import 'risk_table_organization.dart';

class RiskEditScreen extends StatefulWidget {
  const RiskEditScreen({super.key, required this.risk, required String iperId});

  final Risk risk;

  @override
  RiskEditScreenState createState() => RiskEditScreenState();
}

class RiskEditScreenState extends State<RiskEditScreen> {
  late Risk newRisk;

  int _currentIndexClasificaMC = 0;

  final String apiUrl = 'http://10.0.2.2:8080/api/risk';

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

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    newRisk = widget.risk.copyWith();
    _loadInterstitialAd();
  }

  void _submitForm() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String? token = await TokenManager.getToken();

    final responsePost = await http.put(
      Uri.parse('$apiUrl/${widget.risk.id}/edit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(newRisk.toJson()),
    );

    if (responsePost.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('IPER actualizado correctamente'),
            content: const Text(
                'La información del IPER se actualizó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const OrganizationTableSelectionScreen(),
                    ),
                  );
                  _showInterstitialAd();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
              'Error al enviar la información. Por favor, inténtelo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Editar IPER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderDateTimePicker(
              name: 'date',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialValue: widget.risk.date,
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Fecha del control',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.nameOrganization,
              decoration: const InputDecoration(
                labelText: 'Nombre de la organización',
                border: OutlineInputBorder(),
              ),
              enabled:
                  false, // Este campo está deshabilitado y no se puede editar
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.area,
              decoration: const InputDecoration(
                labelText: 'Área',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.puesto,
              decoration: const InputDecoration(
                labelText: 'Puesto de trabajo',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.tarea,
              decoration: const InputDecoration(
                labelText: 'Descripción de la tarea',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.consecuencia,
              decoration: const InputDecoration(
                labelText: 'Consecuencia',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.incidentesPotenciales,
              decoration: const InputDecoration(
                labelText: 'Incidente potencial',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Map<String, String>>(
              decoration: const InputDecoration(
                labelText: 'probabilidad',
                border: OutlineInputBorder(),
              ),
              value: ListDropdownRisk.probabilidad.firstWhere(
                  (element) =>
                      element['value'] == widget.risk.probabilidad.toString(),
                  orElse: () => {'label': '', 'value': ''}),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    final String? value = newValue['value'];
                    if (value != null) {
                      newRisk =
                          newRisk.copyWith(probabilidad: int.tryParse(value));
                    }
                  }
                });
              },
              items:
                  ListDropdownRisk.probabilidad.map((Map<String, String> item) {
                return DropdownMenuItem<Map<String, String>>(
                  value: item,
                  child: Text(item['label']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Map<String, String>>(
              decoration: const InputDecoration(
                labelText: 'Gravedad',
                border: OutlineInputBorder(),
              ),
              value: ListDropdownRisk.gravedad.firstWhere(
                  (element) =>
                      element['value'] == widget.risk.gravedad.toString(),
                  orElse: () => {'label': '', 'value': ''}),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    final String? value = newValue['value'];
                    if (value != null) {
                      newRisk = newRisk.copyWith(gravedad: int.tryParse(value));
                    }
                  }
                });
              },
              items: ListDropdownRisk.gravedad.map((Map<String, String> item) {
                return DropdownMenuItem<Map<String, String>>(
                  value: item,
                  child: Text(item['label']!),
                );
              }).toList(),
            ),
            Center(
              child: Column(
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
            ),
            Center(
              child: SizedBox(
                width: 400,
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
                                  ListDropdownRisk.clasificaMC.indexOf(item)
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
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.risk.medidaControl,
              decoration: const InputDecoration(
                labelText: 'Medida de control',
                border: OutlineInputBorder(),
              ),
              enabled: true,
              onChanged: (newValue) {
                setState(() {
                  newRisk = newRisk.copyWith(medidaControl: newValue);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            FormBuilderDateTimePicker(
              name: 'dateOfRevision',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Fecha de Revisión',
                border: OutlineInputBorder(),
              ),
              initialValue: DateTime
                  .now(), // Establecer el valor inicial como la fecha de hoy
              enabled: true,
              validator: FormBuilderValidators.required(
                errorText: 'La fecha de revisión no puede estar vacía',
              ),
              onChanged: (DateTime? selectedDate) {
                setState(() {
                  newRisk = newRisk.copyWith(
                    dateOfRevision: selectedDate ?? DateTime.now(),
                  );
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
