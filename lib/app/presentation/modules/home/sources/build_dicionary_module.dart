import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/services/remote/token_manager.dart';

class TitleAndExplanation {
  TitleAndExplanation(this.title, this.explanation);
  final String title;
  final String explanation;
}

String _searchText = '';
String _textInput = '';

List<TitleAndExplanation> _titlesAndExplanations = [
  TitleAndExplanation('Aspecto:',
      'Los aspectos ambientales se refieren a cualquier elemento de las actividades, productos o servicios de una organización que pueda interactuar con el medio ambiente. Estos aspectos pueden incluir, por ejemplo, emisiones atmosféricas, vertidos de aguas residuales, generación de residuos, consumo de recursos naturales, entre otros.'),
  TitleAndExplanation('Aceptable :',
      'Puede que no sea necesaria ninguna otra acción y se recomienda mantener las medidas de control.'),
  TitleAndExplanation(
      'Adecuado:', 'Puede ser considerado para un análisis posterior.'),
  TitleAndExplanation('Casi Seguro :',
      'Es seguro que se produzca y/o tenga consecuencias importantes'),
  TitleAndExplanation('Ciclo de vida :',
      'Conjunto de etapas o fases que atraviesa un producto, proceso o servicio desde su concepción hasta su disposición final.'),
  TitleAndExplanation('Confinamiento :',
      'Se refiere a una estrategia o medida preventiva destinada a limitar la exposición humana o ambiental a peligros o riesgos específicos.'),
  TitleAndExplanation('Eliminación :',
      'Medida preventiva de eliminación de la fuente de riesgo ambiental o de riesgos para las personas.'),
  TitleAndExplanation('Extintor:',
      'Dispositivo portátil diseñado para apagar pequeños incendios al liberar un agente extintor que suprime el fuego.'),
  TitleAndExplanation('Impacto:',
      'Se refiere a las consecuencias, positivas o negativas, que las actividades humanas tienen sobre el medio ambiente.'),
  TitleAndExplanation('Inaceptable:',
      'Debe implementar el cese de actividades y aprobar para una acción inmediata.'),
  TitleAndExplanation('Índice de Frecuencia :',
      'El índice de frecuencia de accidentes es una medida que indica la frecuencia con la que ocurren accidentes en un lugar de trabajo durante un período específico, generalmente expresado como el número de accidentes por cada cierto número de horas trabajadas.'),
  TitleAndExplanation(
      'Insignificante :', 'No causará lesiones o enfermedades graves.'),
  TitleAndExplanation('Mayor:',
      'Puede causar lesiones o enfermedades irreversibles que requieren atención médica constante.'),
  TitleAndExplanation(
      'Menor:', 'Puede causar lesiones o enfermedades, pero de forma leve.'),
  TitleAndExplanation(
      'Moderado:', 'Es probable que ocurra y/o tenga consecuencias graves.'),
  TitleAndExplanation('Peligro:',
      'Cualquier situación, sustancia, objeto o actividad que tiene el potencial de causar daño, lesiones o pérdidas a las personas, el medio ambiente o los bienes materiales.'),
  TitleAndExplanation('Poco probable:',
      'Es posible que ocurra y/o que tenga consecuencias moderadas.'),
  TitleAndExplanation('Probable:',
      'Es casi seguro que ocurra y/o que tenga consecuencias importantes.'),
  TitleAndExplanation('Protección Personal:',
      ' Dispositivos diseñados para proteger a los trabajadores en el lugar de trabajo.'),
  TitleAndExplanation('Raro:',
      'Es poco probable que ocurra y/o tiene consecuencias menores o insignificantes.'),
  TitleAndExplanation('Riesgo:',
      'Es la posibilidad de que ocurra un evento adverso o una situación que pueda causar daño, pérdida o perjuicio a personas, bienes materiales, el medio ambiente o la reputación de una organización.'),
  TitleAndExplanation('Severidad:',
      'Nivel de gravedad o impacto que puede tener un riesgo o incidente en términos de sus consecuencias potenciales.'),
  TitleAndExplanation('Severo:', 'Puede ser mortal'),
  TitleAndExplanation('Significativo:',
      'Puede causar lesiones o enfermedades que pueden requerir atención médica pero un tratamiento limitado.'),
  TitleAndExplanation('State Holder:',
      'Una parte interesada es cualquier persona u organización afectada por las acciones de una empresa. La gestión de partes interesadas implica comprender sus necesidades y expectativas, e involucrarlas en decisiones relevantes.'),
  TitleAndExplanation('Sustitución:',
      'Sustituir una fuente de peligro por otra de menor gravedad.'),
  TitleAndExplanation('Tolerable:',
      'Debe ser revisado oportunamente para llevar a cabo estrategias de mejora.'),
];

List<TitleAndExplanation> _filteredTitlesAndExplanations(
    List<TitleAndExplanation> titlesAndExplanations) {
  if (_searchText.isEmpty) {
    return titlesAndExplanations;
  } else {
    List<TitleAndExplanation> filteredList = [];
    for (TitleAndExplanation item in titlesAndExplanations) {
      if (item.title.toLowerCase().contains(_searchText.toLowerCase())) {
        filteredList.add(item);
      }
    }
    return filteredList;
  }
}

class ConfigurationModule extends StatefulWidget {
  const ConfigurationModule({super.key, this.selectedColor});
  final Color? selectedColor;

  @override
  _ConfigurationModuleState createState() => _ConfigurationModuleState();
}

const String apiUrl = 'http://10.0.2.2:8080/api/coments';

Future<void> enviarTextoAlBackend(String texto) async {
  try {
    String? token = await TokenManager.getToken();
    if (token != null) {
      final Map<String, String> body = {
        'texto': texto,
      };
      final String jsonBody = jsonEncode(body);

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
      } else {}
    } else {}
    // ignore: empty_catches
  } catch (error) {}
}

class _ConfigurationModuleState extends State
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _textEditingController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textEditingController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TitleAndExplanation> filteredTitlesAndExplanations =
        _filteredTitlesAndExplanations(_titlesAndExplanations);

    return Material(
      // Envolver en Material
      color: Colors.teal.shade50, // Establecer el color de fondo
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Deja tu definición o comentario que lo tedremos en cuenta.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Ingresar texto',
                labelStyle: const TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  // Agregar el borde
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _textInput = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                enviarTextoAlBackend(_textInput);
                _textEditingController.clear();
              },
              child: const Text('Enviar'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                labelStyle: const TextStyle(color: Colors.blue),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchText = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTitlesAndExplanations.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                              text: filteredTitlesAndExplanations[index].title),
                        ],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          filteredTitlesAndExplanations[index].explanation,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
