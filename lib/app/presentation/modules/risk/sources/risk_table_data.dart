class Risk {
  Risk(
      {required this.id,
      required this.nameOrganization,
      required this.puesto,
      required this.area,
      required this.tarea,
      required this.fuente,
      required this.incidentesPotenciales,
      required this.consecuencia,
      required this.tipo,
      required this.probabilidad,
      required this.gravedad,
      required this.evaluacion,
      required this.clasificaMC,
      required this.medidaControl,
      required this.dateOfRevision,
      required this.date,
      required this.userId});

  factory Risk.fromJson(Map<String, dynamic> json) {
    return Risk(
      id: json['id'] ?? '',
      nameOrganization: json['nameOrganization'] ?? '',
      puesto: json['puesto'] ?? '',
      area: json['area'] ?? '',
      tarea: json['tarea'] ?? '',
      fuente: json['fuente'] ?? '',
      incidentesPotenciales: json['incidentesPotenciales'] ?? '',
      consecuencia: json['consecuencia'] ?? '',
      tipo: json['tipo'] ?? '',
      probabilidad: json['probabilidad'] ?? '',
      gravedad: json['gravedad'] ?? '',
      evaluacion: json['evaluacion'] ?? '',
      clasificaMC: json['clasificaMC'] ?? '',
      medidaControl: json['medidaControl'] ?? '',
      dateOfRevision: DateTime.parse(json['dateOfRevision'] ?? ''),
      date: DateTime.parse(json['date'] ?? ''),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameOrganization': nameOrganization,
      'puesto': puesto,
      'area': area,
      'tarea': tarea,
      'fuente': fuente,
      'incidentesPotenciales': incidentesPotenciales,
      'consecuencia': consecuencia,
      'tipo': tipo,
      'probabilidad': probabilidad,
      'gravedad': gravedad,
      'evaluacion': evaluacion,
      'clasificaMC': clasificaMC,
      'medidaControl': medidaControl,
      'date': date.toIso8601String(),
      'dateOfRevision': dateOfRevision.toIso8601String(),
      'userId': userId,
    };
  }

  Risk copyWith({
    String? id,
    String? nameOrganization,
    String? puesto,
    String? area,
    String? tarea,
    String? fuente,
    String? incidentesPotenciales,
    String? consecuencia,
    String? tipo,
    int? probabilidad,
    int? gravedad,
    String? evaluacion,
    String? clasificaMC,
    String? medidaControl,
    DateTime? dateOfRevision,
    DateTime? date,
    String? userId,
  }) {
    return Risk(
      id: id ?? this.id,
      nameOrganization: nameOrganization ?? this.nameOrganization,
      puesto: puesto ?? this.puesto,
      area: area ?? this.area,
      tarea: tarea ?? this.tarea,
      fuente: fuente ?? this.fuente,
      incidentesPotenciales:
          incidentesPotenciales ?? this.incidentesPotenciales,
      consecuencia: consecuencia ?? this.consecuencia,
      tipo: tipo ?? this.tipo,
      probabilidad: probabilidad ?? this.probabilidad,
      gravedad: gravedad ?? this.gravedad,
      evaluacion: evaluacion ?? this.evaluacion,
      clasificaMC: clasificaMC ?? this.clasificaMC,
      medidaControl: medidaControl ?? this.medidaControl,
      dateOfRevision: dateOfRevision ?? this.dateOfRevision,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  final String id;
  final String nameOrganization;
  final String puesto;
  final String area;
  final String tarea;
  final String fuente;
  final String incidentesPotenciales;
  final String consecuencia;
  final String tipo;
  final int probabilidad;
  final int gravedad;
  final String evaluacion;
  final String clasificaMC;
  final String medidaControl;
  final DateTime dateOfRevision;
  final DateTime date;
  final String userId;
}
