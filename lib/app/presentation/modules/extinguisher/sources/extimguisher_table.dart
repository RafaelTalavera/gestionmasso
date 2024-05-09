class Extimguisher {
  Extimguisher(
      {required this.id,
      required this.date,
      required this.nameOrganization,
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
        nameOrganization: json['nameOrganization'] ?? '',
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
      'nameOrganization': nameOrganization,
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

  Extimguisher copyWith({
    String? id,
    DateTime? date,
    String? nameOrganization,
    String? sector,
    String? extId,
    String? tipo,
    double? kg,
    String? ubicacion,
    DateTime? vencimiento,
    int? diferenciaEnDias,
    bool? access,
    bool? signaling,
    bool? presion,
    String? observaciones,
    bool? vigente,
    bool? enabled,
    String? userId,
  }) {
    return Extimguisher(
      id: id ?? this.id,
      date: date ?? this.date,
      nameOrganization: nameOrganization ?? this.nameOrganization,
      sector: sector ?? this.sector,
      extId: extId ?? this.extId,
      tipo: tipo ?? this.tipo,
      kg: kg ?? this.kg,
      ubicacion: ubicacion ?? this.ubicacion,
      vencimiento: vencimiento ?? this.vencimiento,
      diferenciaEnDias: diferenciaEnDias ?? this.diferenciaEnDias,
      access: access ?? this.access,
      signaling: signaling ?? this.signaling,
      presion: presion ?? this.presion,
      observaciones: observaciones ?? this.observaciones,
      vigente: vigente ?? this.vigente,
      enabled: enabled ?? this.enabled,
      userId: userId ?? this.userId,
    );
  }

  final String id;
  final DateTime date;
  final String nameOrganization;
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
