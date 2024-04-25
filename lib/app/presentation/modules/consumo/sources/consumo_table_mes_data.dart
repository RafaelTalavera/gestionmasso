class ConsumoMes {
  ConsumoMes({
    required this.nameOrganization,
    required this.combustible,
    required this.unidad,
    required this.yearMonth,
    required this.totalConsumo,
  });

  factory ConsumoMes.fromJson(Map<String, dynamic> json) {
    return ConsumoMes(
      nameOrganization: json['nameOrganization'] ?? '',
      combustible: json['combustible'] ?? '',
      unidad: json['unidad'] ?? '',
      yearMonth:
          DateTime.parse(json['yearMonth']), // Convertir la cadena a DateTime
      totalConsumo:
          json['totalConsumo'] != null ? json['totalConsumo'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameOrganization': nameOrganization,
      'combustible': combustible,
      'unidad': unidad,
      'yearMonth': yearMonth,
      'totalConsumo': totalConsumo, // Corregido de totaConsumo a totalConsumo
    };
  }

  ConsumoMes copyWith({
    String? nameOrganization,
    String? combustible,
    String? unidad,
    DateTime? yearMonth,
    double? totalConsumo,
  }) {
    return ConsumoMes(
      nameOrganization: nameOrganization ?? this.nameOrganization,
      combustible: combustible ?? this.combustible,
      unidad: unidad ?? this.unidad,
      yearMonth: yearMonth ?? this.yearMonth,
      totalConsumo: totalConsumo ?? this.totalConsumo,
    );
  }

  final String nameOrganization;
  final String combustible;
  final String unidad;
  final DateTime yearMonth;
  final double totalConsumo;
}
