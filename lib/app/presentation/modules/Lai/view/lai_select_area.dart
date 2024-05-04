import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/services/remote/token_manager.dart';
import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'lai_chart_meaningfulness_view.dart';

class LaiAreaSelectionScreen extends StatefulWidget {
  const LaiAreaSelectionScreen({super.key, required this.nameOrganization});
  final String nameOrganization;

  @override
  LaiAreaSelectionScreenState createState() => LaiAreaSelectionScreenState();
}

class LaiAreaSelectionScreenState extends State<LaiAreaSelectionScreen> {
  List<String> areas = [];

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
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    String? token = await TokenManager.getToken();

    try {
      final url = Uri.parse(
          'http://10.0.2.2:8080/api/lai/areas/${widget.nameOrganization}');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // Otros encabezados si es necesario
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<String> fetchedAreas = data.cast<String>();

        setState(() {
          areas = fetchedAreas;
        });
      } else {
        throw Exception(
            'Failed to load areas for organization: ${widget.nameOrganization}');
      }
      // ignore: empty_catches
    } catch (e) {}
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
          'Areas de ${widget.nameOrganization}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Seleccione un área:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: areas.isEmpty
                    ? const CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: areas.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navega a la pantalla de selección de puestos con la organización y el área seleccionados
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LaiCharts(
                                      selectedCompany: widget.nameOrganization,
                                      selectedArea: areas[index],
                                    ),
                                  ),
                                );
                                _showInterstitialAd();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.lightGreen.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13.0,
                                  vertical: 15.0,
                                ),
                              ),
                              child: Text(areas[index]),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
