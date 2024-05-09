// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import '../../../global/widgets/custom_drawer.dart';
import '../sources/lai_data_out.dart';
import '../sources/list_lai_dropdown.dart';
import 'lai_table_organization_select_view .dart';

class LaiEditScreen extends StatefulWidget {
  const LaiEditScreen({super.key, required this.lai, required String laiId});

  final Lai lai;

  @override
  LaiEditScreenState createState() => LaiEditScreenState();
}

class LaiEditScreenState extends State<LaiEditScreen> {
  late Lai newLai;

  bool stateHolder = false;
  bool legislation = false;

  final String apiUrl = 'http://10.0.2.2:8080/api/lai';

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
    newLai = widget.lai.copyWith();
  }

  void _submitForm() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String? token = await TokenManager.getToken();

    print('JSON enviado a la API:');
    print(jsonEncode(newLai));

    final responsePost = await http.put(
      Uri.parse('$apiUrl/${widget.lai.id}/edit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(newLai.toJson()),
    );

    if (responsePost.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Extintor actualizado correctamente'),
            content: const Text(
                'La información del extintor se actualizó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LaiOrganizationSelectionTableScreen(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print(
        'Error al enviar la información. Código de respuesta: ${responsePost.statusCode}',
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
              'Error al enviar la información. Por favor, inténtelo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
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
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        titleWidget: Text(
          'Revision Lai',
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
              initialValue: widget.lai.date,
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Fecha del control',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.lai.area,
              decoration: const InputDecoration(
                labelText: 'Área',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.lai.tipo,
              decoration: const InputDecoration(
                labelText: 'tipo',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: widget.lai.activity,
              decoration: const InputDecoration(
                labelText: 'Actividad',
                border: OutlineInputBorder(),
              ),
              enabled: true,
              onChanged: (newValue) {
                setState(() {
                  newLai = newLai.copyWith(activity: newValue);
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Aspecto',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.lai.aspect,
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Impacto',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.lai.impact,
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'temporalidad',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.lai.temporality,
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.lai.description,
              enabled: true,
              onChanged: (newValue) {
                setState(() {
                  newLai = newLai.copyWith(description: newValue);
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Ciclo de vida',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.lai.cycle,
              enabled: false,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Map<String, String>>(
              decoration: const InputDecoration(
                labelText: 'frecuencia',
                border: OutlineInputBorder(),
              ),
              value: ListDropdownLai.frequency.firstWhere(
                  (element) =>
                      element['value'] == widget.lai.frequency.toString(),
                  orElse: () => {'label': '', 'value': ''}),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    final String? value = newValue['value'];
                    if (value != null) {
                      newLai = newLai.copyWith(frequency: int.tryParse(value));
                    }
                  }
                });
              },
              items: ListDropdownLai.frequency.map((Map<String, String> item) {
                return DropdownMenuItem<Map<String, String>>(
                  value: item,
                  child: Text(item['label']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Map<String, String>>(
              decoration: const InputDecoration(
                labelText: 'Daño',
                border: OutlineInputBorder(),
              ),
              value: ListDropdownLai.damage.firstWhere(
                  (element) => element['value'] == widget.lai.damage.toString(),
                  orElse: () => {'label': '', 'value': ''}),
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  if (newValue != null) {
                    final String? value = newValue['value'];
                    if (value != null) {
                      newLai = newLai.copyWith(damage: int.tryParse(value));
                    }
                  }
                });
              },
              items: ListDropdownLai.damage.map((Map<String, String> item) {
                return DropdownMenuItem<Map<String, String>>(
                  value: item,
                  child: Text(item['label']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
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
              initialValue: widget.lai.dateOfRevision,
              enabled: true,
              validator: FormBuilderValidators.required(
                errorText: 'La fecha de revisión no puede estar vacía',
              ),
              onChanged: (DateTime? selectedDate) {
                setState(() {
                  newLai = newLai.copyWith(
                    dateOfRevision: selectedDate ?? DateTime.now(),
                  );
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Parte interesada',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 100),
                AdvancedSwitch(
                  activeColor: Colors.red,
                  inactiveColor: Colors.green,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      newLai = newLai.copyWith(stateHolder: value);
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  newLai.stateHolder ? ' Si' : ' No',
                  style: TextStyle(
                    color: newLai.stateHolder ? Colors.red : Colors.green,
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
                  'Legislación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 140),
                AdvancedSwitch(
                  activeColor: Colors.red,
                  inactiveColor: Colors.green,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      newLai = newLai.copyWith(legislation: value);
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  newLai.legislation ? ' Si' : ' No',
                  style: TextStyle(
                    color: newLai.legislation ? Colors.red : Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: widget.lai.descriptionOfControl,
              decoration: const InputDecoration(
                labelText: 'Medida de control',
                border: OutlineInputBorder(),
              ),
              enabled: true,
              onChanged: (newValue) {
                setState(() {
                  newLai = newLai.copyWith(descriptionOfControl: newValue);
                });
              },
            ),
            const SizedBox(height: 20),
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
    );
  }
}
