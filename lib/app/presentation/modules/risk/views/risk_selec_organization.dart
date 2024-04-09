import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';
import 'risk_select_area.dart';

class OrganizationSelectionScreen extends StatefulWidget {
  const OrganizationSelectionScreen({super.key});

  @override
  OrganizationSelectionScreenState createState() =>
      OrganizationSelectionScreenState();
}

class OrganizationSelectionScreenState
    extends State<OrganizationSelectionScreen> {
  List<String> organizations = [];

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/risk/organizations'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> fetchedOrganizations = data.cast<String>();

        setState(() {
          organizations = fetchedOrganizations;
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      print('Error fetching organizations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          ' Organizaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: organizations.isEmpty
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: organizations.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AreaSelectionScreen(
                                      organization: organizations[index]),
                                ),
                              );
                            },
                            child: Text(organizations[index]),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
