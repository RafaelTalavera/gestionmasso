import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../global/utils/caculate_font_sise.dart';
import '../../../global/widgets/custom_AppBar.dart';

import '../../statistcs/views/statistcs_listaTotal_organization_select_view.dart';

import 'accidentes_ListaTotal_organization_select_view.dart';
import 'accidentes_organization_select_table_view .dart';

class SelectScreemLista extends StatelessWidget {
  const SelectScreemLista({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = Utils.calculateTitleFontSize(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Ver listas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 183, 19),
            fontSize: fontSize,
          ),
        ),
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccOrgaTableSelectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.bandage,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '  Listar Accidentes  ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AccidentesTotalOrgaSelectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.bandage,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Accidentes por mes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80), // Espacio entre los botones
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const StatistcsTotalOrgaSelectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                    vertical: 15.0,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.factory,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Listar datos por mes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Espacio entre los botones
            ],
          ),
        ),
      ),
    );
  }
}
