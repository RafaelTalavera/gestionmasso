class Extimguisher {
  Extimguisher(
      {required this.id,
      required this.date,
      required this.empresa,
      required this.sector,
      required this.extId,
      required this.tipo,
      required this.kg,
      required this.ubicacion,
      required this.vencimiento,
      required this.diferenciaEnDias,
      required this.access,
      required this.signaling,
      required this.presion,
      required this.observaciones,
      required this.vigente,
      required this.enabled,
      required this.userId});

  factory Extimguisher.fromJson(Map<String, dynamic> json) {
    return Extimguisher(
        id: json['id'] ?? '',
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        empresa: json['empresa'] ?? '',
        sector: json['sector'] ?? '',
        extId: json['extId'] ?? '',
        tipo: json['tipo'] ?? '',
        kg: json['kg'] != null ? double.parse(json['kg'].toString()) : 0.0,
        ubicacion: json['ubicacion'] ?? '',
        vencimiento: json['vencimiento'] != null
            ? DateTime.parse(json['vencimiento'])
            : DateTime.now(),
        diferenciaEnDias: json['diferenciaEnDias'] ?? '',
        access: json['access'] ?? false,
        signaling: json['signaling'] ?? false,
        presion: json['presion'] ?? false,
        vigente: json['vigente'] ?? false,
        observaciones: json['observaciones'] ?? '',
        enabled: json['enabled'] ?? false,
        userId: json['userId'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'empresa': empresa,
      'sector': sector,
      'extId': extId,
      'tipo': tipo,
      'kg': kg,
      'ubicacion': ubicacion,
      'vencimiento': vencimiento.toIso8601String(),
      'access': access,
      'signaling': signaling,
      'presion': presion,
      'observaciones': observaciones,
      'vigente': vigente,
      'enabled': enabled,
      'userId': userId,
    };
  }

  final String id;
  final DateTime date;
  final String empresa;
  final String sector;
  final String extId;
  final String tipo;
  final double kg;
  final String ubicacion;
  final DateTime vencimiento;
  final int diferenciaEnDias;
  final bool access;
  final bool signaling;
  final bool presion;
  final String observaciones;
  final bool vigente;
  late bool enabled;
  final String userId;
}
