class ListDropdownLai {
  static List<String> areas = [
    'Producción',
    'Ventas',
    'Mantenimiento',
    'Logística',
    'Abastecimiento',
    'Administración',
    'Limpieza',
    'Seguridad Industrial',
    'Control de Calidad',
    'Medioambiente',
    'Tratamiento de efluentes',
  ];

  static List<String> proccess = [
    'Producción',
    'Ventas',
    'Mantenimiento',
    'Logística',
    'Abastecimiento',
    'Administración',
    'Limpieza',
    'Seguridad Industrial',
    'Control de Calidad',
    'Medioambiente',
    'Tratamiento de efluentes',
  ];

  static List<String> aspect = [
    'Consumo de agua',
    'Consumo de energía eléctrica',
    'Consumo de recursos hídricos',
    'Consumo de Hidrocarburos',
    'Emisiones atmosféricas',
    'Emisiones de olores',
    'Generación de residuos',
    'Generación de ruido',
    'Uso de productos químicos',
    'Uso de recursos no renovables',
    'Uso del suelo',
    'Vertido de aguas efluentes líquidas',
  ];

  static List<String> impact = [
    'Contaminación del aire',
    'Contaminación del agua',
    'Contaminación de recurso hídrico',
    'Contaminación del suelo',
    'Contaminación sonora',
    'Contaminación lumínica',
    'Degradación del suelo',
    'Deforestación',
    'Impacto visual',
    'Pérdida de biodiversidad',
  ];

  static List<String> cycle = [
    'Adquisición de las materias primas',
    'Diseño del producto o servicio',
    'Producción',
    'Transporte para la entrega',
    'Uso del producto o servicio',
    'Fin de la vida útil y su tratamiento',
    'Disposición final y residuos'
  ];

  static List<Map<String, dynamic>> typeOfControl = [
    {'label': 'Eliminar', 'value': 'eliminar'},
    {'label': 'Reducir', 'value': 'reducir'},
    {'label': 'Reutilizar', 'value': 'reutilizar'},
    {'label': 'Reciclar', 'value': 'reciclar'},
    {'label': 'Confinar', 'value': 'confinar'},
    {'label': 'Procedimientos', 'value': 'procedimientos'}
  ];

  static List<Map<String, dynamic>> temporality = [
    {'label': 'Pasado', 'value': 'Pasado'},
    {'label': 'Presente', 'value': 'Presente'},
    {'label': 'Futuro', 'value': 'Futuro'}
  ];

  static List<Map<String, dynamic>> tipo = [
    {'label': 'Rutinario', 'value': 'Rutinario'},
    {'label': 'No rutinario', 'value': 'No rutinario'},
    {'label': 'Emergencia', 'value': 'Emergencia'}
  ];

  static List<Map<String, String>> frequency = [
    {'label': 'Raro', 'value': '1'},
    {'label': 'Poco probable', 'value': '2'},
    {'label': 'Moderado', 'value': '3'},
    {'label': 'Probable', 'value': '4'},
    {'label': 'Casi Seguro', 'value': '5'},
  ];

  static List<Map<String, String>> damage = [
    {'label': 'Insignificante', 'value': '1'},
    {'label': 'Menor', 'value': '2'},
    {'label': 'Significativo', 'value': '3'},
    {'label': 'Mayor', 'value': '4'},
    {'label': 'Severo', 'value': '5'},
  ];
}
