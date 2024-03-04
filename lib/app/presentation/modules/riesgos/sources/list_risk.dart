class ListDropdownRisk {
  static List<Map<String, String>> fuente = [
    {'label': 'Protección inexistente', 'value': 'Protección inexistente'},
    {'label': 'Protección insuficiente', 'value': 'Protección insuficiente'},
    {'label': 'Falta de manuales', 'value': 'Falta de manualesS'},
    {'label': 'Falla en aislación', 'value': 'Falla en aislación'},
    {'label': 'Falta de protección', 'value': 'alta de protección'},
    {'label': 'Falta bloqueo', 'value': 'Falta bloqueo'},
    {'label': 'Falta de advertencias', 'value': 'Falta de advertencias'},
    {
      'label': 'Falta mantenimiento regular',
      'value': 'Falta mantenimiento regular'
    },
    {'label': 'Iluminación insuficiente', 'value': 'Iluminación insuficiente'},
    {'label': 'Bloqueo desconectado', 'value': 'Bloqueo desconectado'},
    {'label': 'Espacio reducido', 'value': 'Espacio reducido'},
    {'label': 'Espacio confinado', 'value': 'Espacio confinado'},
    {'label': 'Superficies calientes', 'value': 'Superficies calientes'},
    {'label': 'Trabajo en Altura', 'value': 'Trabajo en Altura'},
  ];

  static List<Map<String, String>> incidentesPotenciales = [
    {'label': 'Caída a diferente nivel', 'value': 'Caída a diferente nivel'},
    {'label': 'Caída al mismo nivel', 'value': 'Caída al mismo nivel'},
    {
      'label': 'Contacto con objetos calientes',
      'value': 'Contacto con objetos calientes'
    },
    {'label': 'Contacto con fuego', 'value': 'Contacto con fuego'},
    {
      'label': 'Contacto con electricidad',
      'value': 'Contacto con electricidad'
    },
    {
      'label': 'Contacto con objetos punzocortantes"',
      'value': 'Contacto con objetos punzocortantes'
    },
    {
      'label': 'Contacto con sustancias químicas',
      'value': 'Contacto con sustancias químicas'
    },
    {'label': 'Golpeado con objeto', 'value': 'Golpeado con objeto'},
    {'label': 'Golpeado por objeto', 'value': 'Golpeado por objeto'},
    {'label': 'Golpeado contra objetos', 'value': 'Golpeado contra objetos'},
    {'label': 'Choque entre vehículos', 'value': 'Choque entre vehículos'},
    {'label': 'Choque por vehículos', 'value': 'Choque por vehículos'},
    {'label': 'Choque contra objetos', 'value': 'Choque contra objetos'},
    {
      'label': 'Atrapamiento por parte móvil',
      'value': 'ATRAPAMIENTO_POR_PARTE_MOVIL'
    },
    {'label': 'Inmersión', 'value': 'Inmersión'},
    {'label': 'Incendio', 'value': 'Incendio'},
    {'label': 'Explosión', 'value': 'Explosión'},
    {'label': 'Picadura o mordedura', 'value': 'Picadura o mordedura'},
    {'label': 'Atropello', 'value': 'Atropello'},
    {
      'label': 'Intoxicación por alimentos',
      'value': 'ntoxicación por alimentos'
    }
  ];
  static List<Map<String, String>> consecuencia = [
    {'label': 'Ahogamiento', 'value': 'Ahogamiento'},
    {'label': 'Amputaciones', 'value': 'AMPUTACIONES'},
    {'label': 'Asfixia', 'value': 'AsfixiaA'},
    {'label': 'Cortes', 'value': 'Cortes'},
    {'label': 'Contusiones', 'value': 'Contusiones'},
    {
      'label': 'Efectos de la electricidad',
      'value': 'Efectos de la electricidad'
    },
    {'label': 'Fracturas', 'value': 'Fracturas'},
    {'label': 'Hipotermia', 'value': 'Hipotermia'},
    {'label': 'Laceración', 'value': 'Laceración'},
    {'label': 'Lesiones auditivas', 'value': 'Lesiones auditivas'},
    {
      'label': 'Lesiones en la columna vertebral',
      'value': 'Lesiones en la columna vertebral'
    },
    {'label': 'Lesiones internas', 'value': 'Lesiones internas'},
    {'label': 'Lesiones oculares', 'value': 'Lesiones oculares'},
    {'label': 'Lesiones superficiales', 'value': 'Lesiones superficiales'},
    {'label': 'Muerte', 'value': 'Muerte'},
    {'label': 'Quemaduras', 'value': 'Quemaduras'},
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
  ];

  static List<String> puesto = [
    'Ayudante',
    'Operario',
    'Supervisor',
    'Jefe',
    'Analista',
    'Mecánico',
    'Vendedor',
    'Calidad',
    'Comprador',
    'Gerente'
  ];
  static List<Map<String, String>> tipo = [
    {'label': 'Rutinaria', 'value': 'Rutinaria'},
    {'label': 'No rutinaria', 'value': 'No rutinaria'},
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

  static List<Map<String, String>> clasificaMC = [
    {'label': 'Eliminación', 'value': 'Eliminación'},
    {'label': 'Sustitución', 'value': 'Sustitución'},
    {'label': 'Confinamiento', 'value': 'Confinamiento'},
    {'label': 'Procedimientos', 'value': 'Procedimientos'},
    {'label': 'Protección Personal', 'value': 'Protección Personal'},
  ];
}
