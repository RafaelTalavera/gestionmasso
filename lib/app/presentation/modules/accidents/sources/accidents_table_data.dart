class Accidents {
  Accidents(
      {required this.id,
      required this.nameOrganization,
      required this.puesto,
      required this.area,
      required this.name,
      required this.severity,
      required this.dateEvent,
      required this.dateAlta,
      required this.monthEvent,
      required this.yearEvent,
      required this.alta,
      required this.lostDay,
      required this.userId});

  factory Accidents.fromJson(Map<String, dynamic> json) {
    return Accidents(
      id: json['id'] ?? '',
      nameOrganization: json['nameOrganization'] ?? '',
      puesto: json['puesto'] ?? '',
      area: json['area'] ?? '',
      name: json['name'] ?? '',
      severity: json['severity'] ?? '',
      dateEvent: DateTime.parse(json['dateEvent'] ?? ''),
      dateAlta:
          json['dateAlta'] != null ? DateTime.parse(json['dateAlta']) : null,
      monthEvent: json['monthEvent'] ?? '',
      yearEvent: json['yearEvent'] ?? '',
      alta: json['alta'] ?? '',
      lostDay: json['lostDay'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameOrganization': nameOrganization,
      'puesto': puesto,
      'area': area,
      'name': name,
      'severity': severity,
      'dateEvent': dateEvent.toIso8601String(),
      // ignore: prefer_null_aware_operators
      'dateAlta': dateAlta != null ? dateAlta?.toIso8601String() : null,
      'monthEvent': monthEvent,
      'yearEvent': yearEvent,
      'alta': alta,
      'lostDay': lostDay,
      'userId': userId,
    };
  }

  Accidents copyWith({
    String? id,
    String? nameOrganization,
    String? puesto,
    String? area,
    String? name,
    String? severity,
    DateTime? dateEvent,
    DateTime? dateAlta,
    int? monthEvent,
    int? yearEvent,
    bool? alta,
    int? lostDay,
    String? userId,
  }) {
    return Accidents(
      id: id ?? this.id,
      nameOrganization: nameOrganization ?? this.nameOrganization,
      puesto: puesto ?? this.puesto,
      area: area ?? this.area,
      name: name ?? this.name,
      severity: severity ?? this.severity,
      dateEvent: dateEvent ?? this.dateEvent,
      dateAlta: dateAlta ?? this.dateAlta,
      monthEvent: monthEvent ?? this.monthEvent,
      yearEvent: yearEvent ?? this.yearEvent,
      alta: alta ?? this.alta,
      lostDay: lostDay ?? this.lostDay,
      userId: userId ?? this.userId,
    );
  }

  final String id;
  final String nameOrganization;
  final String puesto;
  final String area;
  final String name;
  final String severity;
  final DateTime dateEvent;
  late DateTime? dateAlta;
  final int monthEvent;
  final int yearEvent;
  final bool alta;
  final int lostDay;
  final String userId;
}
