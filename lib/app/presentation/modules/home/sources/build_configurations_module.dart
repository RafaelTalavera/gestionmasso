import 'package:flutter/material.dart';

class TitleAndExplanation {
  final String title;
  final String explanation;

  TitleAndExplanation(this.title, this.explanation);
}

String _searchText = '';

List<TitleAndExplanation> _titlesAndExplanations = [
  TitleAndExplanation('Aspecto:',
      'Los aspectos ambientales se refieren a cualquier elemento de las actividades, productos o servicios de una organización que pueda interactuar con el medio ambiente. Estos aspectos pueden incluir, por ejemplo, emisiones atmosféricas, vertidos de aguas residuales, generación de residuos, consumo de recursos naturales, entre otros.'),
  TitleAndExplanation('Impacto Ambiental:',
      'Las consecuencias, positivas o negativas, que las actividades humanas tienen sobre el medio ambiente incluyen cambios en los ecosistemas, la calidad del aire, del agua y del suelo, así como en la biodiversidad. El impacto ambiental puede ser evaluado a través de estudios que analizan cómo las acciones humanas afectan los sistemas naturales y cómo estas afectaciones pueden ser mitigadas o compensadas para proteger el medio ambiente'),
  TitleAndExplanation('Medida de Control:',
      'Una medida de control se refiere a una acción planificada para prevenir o resolver problemas que puedan afectar los objetivos de la organización. Se implementa para garantizar el funcionamiento efectivo del sistema y el logro de resultados deseados mediante políticas, procedimientos o tecnologías.'),
  TitleAndExplanation('Ejemplo 4:', 'Texto aquí de la explicación 4'),
  TitleAndExplanation('Ejemplo 5:', 'Texto aquí de la explicación 5'),
  TitleAndExplanation('Ejemplo 6:', 'Texto aquí de la explicación 6'),
  TitleAndExplanation('Ejemplo 7:', 'Texto aquí de la explicación 7'),
  TitleAndExplanation('Ejemplo 8:', 'Texto aquí de la explicación 8'),
  TitleAndExplanation('Ejemplo 9:', 'Texto aquí de la explicación 9'),
  TitleAndExplanation('Ejemplo 10:', 'Texto aquí de la explicación 10'),
  TitleAndExplanation('Ejemplo 11:', 'Texto aquí de la explicación 11'),
  TitleAndExplanation('Ejemplo 12:', 'Texto aquí de la explicación 12'),
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
  final Color? selectedColor;

  const ConfigurationModule({Key? key, this.selectedColor}) : super(key: key);

  @override
  _ConfigurationModuleState createState() => _ConfigurationModuleState();
}

class _ConfigurationModuleState extends State
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TitleAndExplanation> filteredTitlesAndExplanations =
        _filteredTitlesAndExplanations(_titlesAndExplanations);

    return Container(
      // color: widget.selectedColor,
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
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
                  title: Text(filteredTitlesAndExplanations[index].title),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        filteredTitlesAndExplanations[index].explanation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
