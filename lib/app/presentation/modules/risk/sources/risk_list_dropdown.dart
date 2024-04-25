class ListDropdownRisk {
  static List<String> fuente = [
    'Protección inexistente',
    'Protección insuficiente',
    'Falta de capacitación',
    'Falta de manuales',
    'Falla en aislación',
    'Falta de protección',
    'Falta bloqueo',
    'Falta de advertencias',
    'Falta mantenimiento regular',
    'Iluminación insuficiente',
    'Bloqueo desconectado',
    'Espacio reducido',
    'Espacio confinado',
    'Equipos y herramientas inadecuados',
    'Superficies calientes',
    'Trabajo en Altura',
    'Técnica de levantamiento inadecuada',
    'Sobrecarga de peso',
  ];

  static List<String> incidentesPotenciales = [
    'Caída a diferente nivel',
    'Caída al mismo nivel',
    'Contacto con objetos calientes',
    'Contacto con fuego',
    'Contacto con electricidad',
    'Contacto con onjetos cortantes',
    'Contacto con objetos punzocortantes',
    'Contacto con sustancias químicas',
    'Contanto con partes en movimientos',
    'Contacto con particulas en suspención',
    'Golpeado con objeto',
    'Golpeado por objeto',
    'Golpeado contra objetos',
    'Choque entre vehículos',
    'Choque por vehículos',
    'Choque contra objetos',
    'Atrapamiento por parte móvil',
    'Inmersión',
    'Incendio',
    'Explosión',
    'Picadura o mordedura',
    'Atropello',
    'Intoxicación por alimentos',
  ];
  static List<String> consecuencia = [
    'Ahogamiento',
    'Amputaciones',
    'Asfixia',
    'Cortes',
    'Contusiones',
    'Efectos de la electricidad',
    'Fracturas',
    'Hipotermia',
    'Laceración',
    'Lesiones auditivas',
    'Lesiones en la columna vertebral',
    'Lesiones internas',
    'Lesiones oculares',
    'Lesiones superficiales',
    'Muerte',
    'Quemaduras',
  ];
  static List<String> areas = [
    'Producción',
    'Ventas',
    'Mantenimiento',
    'Logística',
    'Abastecimiento',
    'Administración',
    'Limpieza',
    'Seguridad Industrial',
    'Control de Calidad'
  ];

  static List<String> puesto = [
    'Ayudante',
    'Analista',
    'Operario',
    'Supervisor',
    'Jefe',
    'Mecánico',
    'Gerente'
  ];
  static List<String> tipo = [
    'Rutinaria',
    'No rutinaria',
  ];

  static List<Map<String, String>> probabilidad = [
    {'label': 'Raro', 'value': '1'},
    {'label': 'Poco probable', 'value': '2'},
    {'label': 'Moderado', 'value': '3'},
    {'label': 'Probable', 'value': '4'},
    {'label': 'Casi Seguro', 'value': '5'},
  ];

  static List<Map<String, String>> gravedad = [
    {'label': 'Insignificante', 'value': '1'},
    {'label': 'Menor', 'value': '2'},
    {'label': 'Significativo', 'value': '3'},
    {'label': 'Mayor', 'value': '4'},
    {'label': 'Severo', 'value': '5'},
  ];

  static List<String> clasificaMC = [
    'Eliminación',
    'Sustitución',
    'Confinamiento',
    'Procedimiento de trabajo',
    'Protección Personal',
  ];
}
