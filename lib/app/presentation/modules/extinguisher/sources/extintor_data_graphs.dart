class ExtintorData {
  ExtintorData({
    required this.empresa,
    required this.sector,
    required this.total,
    required this.vigentes,
    required this.vencidos,
    required this.habilitados,
    required this.deshabilitados,
  });

  // Método para convertir JSON en objeto ExtintorData
  factory ExtintorData.fromJson(Map<String, dynamic> json) {
    return ExtintorData(
      empresa: json['empresa'] ?? '',
      sector: json['sector'] ?? '',
      total: json['total'] ?? 0,
      vigentes: json['vigentes'] ?? 0,
      vencidos: json['vencidos'] ?? 0,
      habilitados: json['habilitados'] ?? 0,
      deshabilitados: json['deshabilitados'] ?? 0,
    );
  }

  final String empresa;
  final String sector;
  final int total;
  final int vigentes;
  final int vencidos;
  final int habilitados;
  final int deshabilitados;
}
