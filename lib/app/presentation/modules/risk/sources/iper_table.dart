class Iper {
  Iper(
      {required this.puesto,
      required this.area,
      required this.tarea,
      required this.fuente,
      required this.incidentesPotenciales,
      required this.consecuencia,
      required this.tipo,
      required this.evaluacion,
      required this.clasificaMC,
      required this.medidaControl,
      required this.date});

  factory Iper.fromJson(Map<String, dynamic> json) {
    return Iper(
        puesto: json['puesto'] ?? '',
        area: json['area'] ?? '',
        tarea: json['tarea'] ?? '',
        fuente: json['fuente'] ?? '',
        incidentesPotenciales: json['incidentesPotenciales'] ?? '',
        consecuencia: json['consecuencia'] ?? '',
        tipo: json['tipo'] ?? '',
        evaluacion: json['evaluacion'] ?? '',
        clasificaMC: json['clasificaMC'] ?? '',
        medidaControl: json['medidaControl'] ?? '',
        date: DateTime.parse(json['date'] ?? ''));
  }

  final String puesto;
  final String area;
  final String tarea;
  final String fuente;
  final String incidentesPotenciales;
  final String consecuencia;
  final String tipo;
  final String evaluacion;
  final String clasificaMC;
  final String medidaControl;
  final DateTime date;
}
