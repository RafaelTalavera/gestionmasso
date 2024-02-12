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
    {'label': 'Rodillo', 'value': 'RODILLO'},
    {'label': 'Dedos', 'value': 'DEDOS'},
    {'label': 'Ojo', 'value': 'OJO'},
    {'label': 'Oido', 'value': 'OIDO'},
    {'label': 'Esplada', 'value': 'ESPALDA'},
    {'label': 'Columna', 'value': 'COLUMNA'},
    {'label': 'Multiples', 'value': 'MULTIPLES'},
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

  static List<Map<String, String>> incidenType = [
    {'label': 'Atrapado por', 'value': 'ATRAPADO_POR'},
    {'label': 'Caída a distinto nivel', 'value': 'CAIDA_DISTINTO_NIVEL'},
    {'label': 'Caída al mismo nivel', 'value': 'CAIDA_MISMO_NIVEL'},
    {'label': 'Contacto con calor', 'value': 'CONTACTO_CALOR'},
    {'label': 'Contacto con electricidad', 'value': 'CONTACTO_ELECTRICIDAD'},
    {'label': 'Contacto con químicos', 'value': 'CONTACTO_QUIMICOS'},
    {'label': 'Contacto con frío', 'value': 'CONTACTO_FRIO'},
    {'label': 'Contacto con elemento cortante', 'value': 'CONTACTO_CORTANTE'},
    {'label': 'Contacto con elemento punzante', 'value': 'CONTACTO_PUNZANTE'},
    {'label': 'Exposición a gases', 'value': 'EXPOSICION_GASES'},
    {'label': 'Exposición a radiación', 'value': 'EXPOSICION_RADIACTIVO'},
    {'label': 'Golpeado contra', 'value': 'GOLPEADO_CONTRA'},
    {'label': 'Golpeado por', 'value': 'GOLPEADO_POR'},
    {'label': 'Proyección de fluidos', 'value': 'PROYECCION_FLUIDOS'},
    {'label': 'Proyección de partículas', 'value': 'PROYECCION_PARTICULAS'},
  ];

  static List<Map<String, String>> workOccasion = [
    {'label': 'Tareas ajenas al puesto de trabajo', 'value': 'TAREAS_AJENAS'},
    {
      'label': 'Tareas del puesto de trabajo rutinarias',
      'value': 'TAREAS_RUTINARIAS'
    },
    {
      'label': 'Tareas del puesto de trabajo fuera de rutina',
      'value': 'TAREAS_FUERA_RUTINA'
    },
  ];

  static List<Map<String, String>> hoursWorked = [
    {'label': 'menos de 8 horas', 'value': 'MENOS_DE_8_HORAS'},
    {
      'label': 'más de 8 horas y menos de 12 horas',
      'value': 'MAS_DE_8_Y_MENOS_DE_12_HORAS'
    },
    {'label': 'más de 12 horas', 'value': 'MAS_DE_12_HORAS'},
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
