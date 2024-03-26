class ListDropdown {
  static List<String> severidades = [
    'Casi',
    'Leve',
    'Moderado',
    'Incapacitante',
    'Fatal',
  ];

  static List<String> bodyPart = [
    'Cabeza',
    'Cara',
    'Brazo',
    'Mano',
    'Pierna',
    'Pie',
    'Rodillo',
    'Ojo',
    'Oído',
    'Esplada',
    'Columna',
    'Múltiples',
  ];

  static List<String> injury = [
    'Amputación',
    'Conmoción',
    'Contusión',
    'Corte',
    'Esguince',
    'Fisura',
    'Fractura',
    'Intoxicación',
    'Laceración',
    'Perforación',
    'Quemaduras',
    'Torceduras',
  ];

  static List<String> workOccasion = [
    'Rutinaria',
    'No Rutinaria',
  ];

  static List<Map<String, String>> hoursWorked = [
    {'label': 'menos de 8 horas', 'value': 'MENOS_8'},
    {'label': 'más de 8 horas', 'value': 'MAS_8'},
  ];

  static List<String> energy = [
    'Cinética',
    'Elástica',
    'Térmica',
    'Nuclear',
    'Mecánica',
    'Eléctrica',
    'Química',
  ];
}
