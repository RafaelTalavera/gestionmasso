// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../sources/extimguisher_table.dart';
import 'extimguisher_table_organization.dart';

class ExtimguisherEditScreen extends StatefulWidget {
  const ExtimguisherEditScreen(
      {super.key, required this.extinguisher, required String extinguisherId});

  final Extimguisher extinguisher;

  @override
  ExtimguisherEditScreenState createState() => ExtimguisherEditScreenState();
}

class ExtimguisherEditScreenState extends State<ExtimguisherEditScreen> {
  late Extimguisher newExtinguisher;

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

  final String apiUrl = 'http://10.0.2.2:8080/api/extinguishers';

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    newExtinguisher = widget.extinguisher.copyWith();
  }

  void _submitForm() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String? token = await TokenManager.getToken();

    final responsePost = await http.put(
      Uri.parse('$apiUrl/${widget.extinguisher.id}/edit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(newExtinguisher.toJson()),
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
                            const OrganizationTableExtimguisherSelectionScreen(),
                      ));
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
          'Actualizar',
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
            TextFormField(
              initialValue: widget.extinguisher.nameOrganization,
              decoration: const InputDecoration(
                labelText: 'Empresa',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),

            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.extinguisher.sector,
              decoration: const InputDecoration(
                labelText: 'Sector',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),

            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.extinguisher.extId,
              decoration: const InputDecoration(
                labelText: 'Identificación del extintor',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),

            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.extinguisher.tipo,
              enabled: false,
            ),

            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Peso',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.extinguisher.kg.toString(),
              enabled: false,
            ),

            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'date',
              inputType: InputType.date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              format: DateFormat('dd-MM-yyyy'),
              decoration: const InputDecoration(
                labelText: 'Fecha del control',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.extinguisher.date,
              enabled: true,
              onChanged: (DateTime? selectedDate) {
                setState(() {
                  newExtinguisher = newExtinguisher.copyWith(
                      date: selectedDate ?? DateTime.now());
                });
              },
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
                name: 'vencimiento',
                inputType: InputType.date,
                firstDate: DateTime(2000),
                format: DateFormat('dd-MM-yyyy'),
                decoration: const InputDecoration(
                  labelText: 'Nueva fecha de vencimiento',
                  border: OutlineInputBorder(),
                ),
                initialValue: widget.extinguisher.vencimiento,
                enabled: true,
                onChanged: (DateTime? selectedDate) {
                  setState(() {
                    newExtinguisher = newExtinguisher.copyWith(
                        vencimiento: selectedDate ?? DateTime.now());
                  });
                }),
            const SizedBox(height: 10),
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
                const SizedBox(width: 175),
                AdvancedSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      newExtinguisher = newExtinguisher.copyWith(access: value);
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  newExtinguisher.access ? ' Bueno' : ' Malo',
                  style: TextStyle(
                    color: newExtinguisher.access ? Colors.green : Colors.red,
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
                const SizedBox(width: 130),
                AdvancedSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      newExtinguisher =
                          newExtinguisher.copyWith(signaling: value);
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  newExtinguisher.signaling ? ' Buena' : ' Mala',
                  style: TextStyle(
                    color:
                        newExtinguisher.signaling ? Colors.green : Colors.red,
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
                const SizedBox(width: 170),
                AdvancedSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  width: 60.0,
                  height: 30.0,
                  onChanged: (value) {
                    setState(() {
                      newExtinguisher =
                          newExtinguisher.copyWith(presion: value);
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  newExtinguisher.presion ? ' Buena' : ' Mala',
                  style: TextStyle(
                    color: newExtinguisher.presion ? Colors.green : Colors.red,
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
              initialValue: widget.extinguisher.observaciones,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
              ),
              enabled: true,
              onChanged: (newValue) {
                setState(() {
                  newExtinguisher =
                      newExtinguisher.copyWith(observaciones: newValue);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                _submitForm();
                _showInterstitialAd();
              },
              child: const Text('Enviar'),
            ),

            // Otros campos que se pueden editar...
          ],
        ),
      ),
    );
  }
}
