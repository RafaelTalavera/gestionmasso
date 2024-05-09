class Consumo {
  Consumo({
    required this.id,
    required this.nameOrganization,
    required this.date,
    required this.fuente,
    required this.tipoFuente,
    required this.combustible,
    required this.unidad,
    required this.consumo,
    required this.month,
    required this.year,
    required this.userId,
  });

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      id: json['id'] ?? '',
      nameOrganization: json['nameOrganization'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      fuente: json['fuente'] ?? '',
      tipoFuente: json['tipoFuente'] ?? '',
      combustible: json['combustible'] ?? '',
      unidad: json['unidad'] ?? '',
      consumo: json['consumo'] != null ? json['consumo'].toDouble() : 0.0,
      month: json['month'] ?? '',
      year: json['year']?.toString() ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameOrganization': nameOrganization,
      'date': date.toIso8601String(),
      'fuente': fuente,
      'tipoFuente': tipoFuente,
      'combustible': combustible,
      'unidad': unidad,
      'consumo': consumo,
      'month': month,
      'year': year,
      'userId': userId,
    };
  }

  Consumo copyWith({
    String? id,
    String? nameOrganization,
    DateTime? date, // este
    String? fuente, //este
    String? tipoFuente, //este
    String? combustible, //este
    String? unidad, //
    double? consumo, // 
    String? month,
    String? year,
    String? userId,
  }) {
    return Consumo(
      id: id ?? this.id,
      nameOrganization: nameOrganization ?? this.nameOrganization,
      date: date ?? this.date,
      fuente: fuente ?? this.fuente,
      tipoFuente: tipoFuente ?? this.tipoFuente,
      combustible: combustible ?? this.combustible,
      unidad: unidad ?? this.unidad,
      consumo: consumo ?? this.consumo,
      month: month ?? this.month,
      year: year ?? this.year,
      userId: userId ?? this.userId,
    );
  }

  final String id;
  final String nameOrganization;
  final DateTime date;
  final String fuente;
  final String tipoFuente;
  final String combustible;
  final String unidad;
  final double consumo;
  final String month;
  final String year;
  final String userId;
}
