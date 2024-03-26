import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'dart:convert';

import '../../global/widgets/custom_AppBar.dart';

import 'extimguisher_EditScreen_view.dart';
import 'sources/extimguisher_table.dart';

class ExtimguishersScreen extends StatefulWidget {
  const ExtimguishersScreen({Key? key}) : super(key: key);

  @override
  _ExtimguishersScreenState createState() => _ExtimguishersScreenState();
}

class _ExtimguishersScreenState extends State<ExtimguishersScreen> {
  List<Extimguisher> extimguishers = [];
  String? selectedCompany;
  String? selectedSector;
  String? selectedType;
  String? selectedState;
  String? selectedEnabled;
  int? selectedRange;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/api/extinguishers'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));

        print('Datos JSON recibidos desde el backend: $jsonData');
        List<Extimguisher> fetchedExtimguishers =
            jsonData.map((json) => Extimguisher.fromJson(json)).toList();
        setState(() {
          extimguishers = fetchedExtimguishers;
        });
      } else {
        throw Exception('Error al cargar datos desde el backend');
      }
    } catch (error) {
      print('Error al cargar datos: $error');
    }
  }

  String getStateText(bool state) {
    return state ? 'Vigente' : 'Vencido';
  }

  String getStateText2(bool state) {
    return state ? 'Buena' : 'Mala';
  }

  Color getStateColor(bool state) {
    return state ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleWidget: Text(
          'Control de Extintores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 238, 183, 19),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownFilter(
                        'Empresa',
                        extimguishers.map((e) => e.empresa).toSet().toList(),
                        selectedCompany,
                        (String? value) {
                          setState(() {
                            selectedCompany = value;
                          });
                          fetchData();
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownFilter(
                              'Sector',
                              extimguishers
                                  .map((e) => e.sector)
                                  .toSet()
                                  .toList(),
                              selectedSector,
                              (String? value) {
                                setState(() {
                                  selectedSector = value;
                                });
                                fetchData();
                              },
                            ),
                          ),
                          _buildEnabledFilter(),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownFilter(
                              'Expiración',
                              ['Vigente', 'Vencido'],
                              selectedState,
                              (String? value) {
                                setState(() {
                                  selectedState = value;
                                });
                                fetchData();
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildDropdownFilter(
                              'Tipo',
                              extimguishers.map((e) => e.tipo).toSet().toList(),
                              selectedType,
                              (String? value) {
                                setState(() {
                                  selectedType = value;
                                });
                                fetchData();
                              },
                            ),
                          ),
                        ],
                      ),
                      _buildRangeFilter(),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCompany = null;
                                selectedSector = null;
                                selectedType = null;
                                selectedState = null;
                                selectedEnabled = null;
                                selectedRange = null;
                              });
                              fetchData();
                            },
                            child: const Text('Limpiar filtros'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: extimguishers
                    .where((extinguisher) =>
                        (selectedCompany == null ||
                            extinguisher.empresa == selectedCompany) &&
                        (selectedSector == null ||
                            extinguisher.sector == selectedSector) &&
                        (selectedType == null ||
                            extinguisher.tipo == selectedType) &&
                        (selectedState == null ||
                            (selectedState == 'Vigente'
                                ? extinguisher.vigente
                                : !extinguisher.vigente)) &&
                        (selectedEnabled == null ||
                            (selectedEnabled == 'Activo'
                                ? !extinguisher.enabled
                                : extinguisher.enabled)) &&
                        (selectedRange == null
                            ? true
                            : (selectedRange == 0
                                ? extinguisher.diferenciaEnDias <= 7
                                : selectedRange == 1
                                    ? extinguisher.diferenciaEnDias > 7 &&
                                        extinguisher.diferenciaEnDias <= 15
                                    : selectedRange == 2
                                        ? extinguisher.diferenciaEnDias > 15 &&
                                            extinguisher.diferenciaEnDias <= 30
                                        : extinguisher.diferenciaEnDias > 30)))
                    .map((extinguisher) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado: ${getStateText(extinguisher.vigente)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.vigente),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Fecha del control: ${DateFormat('dd-MM-yyyy').format(extinguisher.date)}',
                            ),
                            Text('Empresa: ${extinguisher.empresa}'),
                            Text('Sector: ${extinguisher.sector}'),
                            Text('Identificación: ${extinguisher.extId}'),
                            Text('Tipo: ${extinguisher.tipo}'),
                            Text('Capacidad: ${extinguisher.kg}'),
                            Text(
                              'Vencimiento: ${DateFormat('dd-MM-yyyy').format(extinguisher.vencimiento)}',
                            ),
                            Text(
                              'Accesibilidad: ${getStateText2(extinguisher.access)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.access),
                              ),
                            ),
                            Text(
                              'Señaliación: ${getStateText2(extinguisher.signaling)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.signaling),
                              ),
                            ),
                            Text(
                              'Presión: ${getStateText2(extinguisher.presion)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStateColor(extinguisher.presion),
                              ),
                            ),
                            Text(
                                'Observaciones: ${extinguisher.observaciones}'),
                            Text('Usuario: ${extinguisher.userId}'),
                            Text(
                              'Días para el vencimiento: ${extinguisher.diferenciaEnDias}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: extinguisher.diferenciaEnDias < 7
                                    ? Colors.red
                                    : extinguisher.diferenciaEnDias < 15
                                        ? Colors.orange
                                        : extinguisher.diferenciaEnDias < 30
                                            ? Colors.yellow
                                            : Colors.green,
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _updateEnabledStatus(
                                      extinguisher.id,
                                      !extinguisher.enabled,
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (extinguisher.enabled) {
                                          return Colors
                                              .orange; // Color naranja cuando está en reserva
                                        } else {
                                          return Colors
                                              .orange; // Color verde cuando se puede activar
                                        }
                                      },
                                    ),
                                  ),
                                  child: Text(
                                    extinguisher.enabled
                                        ? 'Activar'
                                        : 'Desactivar',
                                    style: const TextStyle(
                                        color: Colors.white), // Texto en blanco
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ExtimguisherEditScreen(
                                            extinguisherId: extinguisher.id,
                                            extinguisher:
                                                extinguisher, // Pasar el objeto Extimguisher
                                          ),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    child: const Text('Actualizar'),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _generateQRCode(
                                        extinguisher); // Pasar el objeto extinguisher completo
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.yellow),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: const Text('Generar QR'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnabledFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedEnabled,
          onChanged: (String? newValue) {
            setState(() {
              selectedEnabled = newValue;
            });
            fetchData(); // Actualizar datos al cambiar el estado
          },
          items: ['Activo', 'Fuera de servicio']
              .map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.blue,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: value,
            onChanged: (String? newValue) {
              print(
                  'Nuevo valor seleccionado en onChanged: $newValue'); // Agregar print aquí
              onChanged(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.blue, // Aplicar estilo rojo al texto
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rango de días para vencimiento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ToggleButtons(
          isSelected: List.generate(4, (index) => index == selectedRange),
          onPressed: (int newIndex) {
            setState(() {
              selectedRange = newIndex;
            });
            fetchData(); // Actualizar datos al cambiar el rango
          },
          children: const [
            Text('0-7'),
            Text('8-15'),
            Text('16-30'),
            Text('31+'),
          ],
        ),
      ],
    );
  }

  void _updateEnabledStatus(String extinguisherId, bool newStatus) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8080/api/extinguishers/$extinguisherId/changeEnabled'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enabled': newStatus}),
      );

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, actualiza el estado local del campo enabled
        setState(() {
          final index = extimguishers
              .indexWhere((extinguisher) => extinguisher.id == extinguisherId);
          if (index != -1) {
            extimguishers[index].enabled = newStatus;
          }
        });
        print('Estado de enabled actualizado exitosamente');
      } else {
        print(
            'Error al actualizar el estado de enabled en el backend. Código de respuesta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al enviar la solicitud al backend: $error');
    }
  }

  void _generateQRCode(Extimguisher extinguisher) {
    String fixedText = "Gestion Masso\n";
    // Concatenar toda la información del extintor en una sola cadena
    String qrData = '''
$fixedText
Estado: ${getStateText(extinguisher.vigente)}
Identificación: ${extinguisher.extId}

''';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Código QR'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: PrettyQr(
              data: qrData,
              typeNumber: 4,
              size: 200,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
