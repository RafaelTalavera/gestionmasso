class ListasDropdown {
  static List<Map<String, String>> severidades = [
    {'label': 'Casi', 'value': 'CASI'},
    {'label': 'Leve', 'value': 'LEVE'},
    {'label': 'Moderado', 'value': 'MODERADO'},
    {'label': 'Incapacitante', 'value': 'INCAPACITANTE'},
    {'label': 'Fatal', 'value': 'FATAL'},
  ];

  static List<Map<String, String>> bodyPart = [
    {'label': 'Cabeza', 'value': 'CABEZA'},
    {'label': 'Cuello', 'value': 'CUELLO'},
    {'label': 'Cara', 'value': 'CARA'},
    {'label': 'Brazo', 'value': 'BRAZO'},
    {'label': 'Mano', 'value': 'MANO'},
    {'label': 'Pierna', 'value': 'PIERNA'},
    {'label': 'Pie', 'value': 'PIE'},
    {'label': 'Rodillo', 'value': 'RODILLA'},
    {'label': 'Dedos', 'value': 'DEDOS'},
    {'label': 'Ojo', 'value': 'OJO'},
    {'label': 'Oído', 'value': 'OIDO'},
    {'label': 'Esplada', 'value': 'ESPALDA'},
    {'label': 'Columna', 'value': 'COLUMNA'},
    {'label': 'Múltiples', 'value': 'MULTIPLES'},
  ];

  static List<Map<String, String>> injury = [
    {'label': 'Amputación', 'value': 'AMPUTACION'},
    {'label': 'Conmoción', 'value': 'CONMOCION'},
    {'label': 'Contusión', 'value': 'CONTUSION'},
    {'label': 'Corte', 'value': 'CORTE'},
    {'label': 'Esguince', 'value': 'ESGUINCE'},
    {'label': 'Fisura', 'value': 'FISURA'},
    {'label': 'Fractura', 'value': 'FRACTURA'},
    {'label': 'Intoxicación', 'value': 'INTOXICACION'},
    {'label': 'Laceración', 'value': 'LACERACION'},
    {'label': 'Perforación', 'value': 'PERFORACION'},
    {'label': 'Quemaduras', 'value': 'QUEMADURAS'},
    {'label': 'Torceduras', 'value': 'TORCEDURAS'},
  ];

  static List<Map<String, String>> workOccasion = [
    {'label': 'Tareas rutinarias', 'value': 'TAREAS_RUTINARIAS'},
    {'label': 'Tareas no rutinas', 'value': 'TAREAS_FUERA_RUTINA'},
  ];

  static List<Map<String, String>> hoursWorked = [
    {'label': 'menos de 8 horas', 'value': 'MENOS_8'},
    {'label': 'más de 8 horas y menos de 12 horas', 'value': 'MAS_8'},
    {'label': 'más de 12 horas', 'value': 'MAS_12'},
  ];

  static List<Map<String, String>> energia = [
    {'label': 'cinética', 'value': 'CINETICA'},
    {'label': 'Elástica', 'value': 'ELASTICA'},
    {'label': 'Térmica', 'value': 'TERMICA'},
    {'label': 'Nuclear', 'value': 'NUCLEAR'},
    {'label': 'Mecánica', 'value': 'MECANICA'},
    {'label': 'Eléctrica', 'value': 'ELECTRICA'},
    {'label': 'Química', 'value': 'QUIMICA'},
  ];
}
