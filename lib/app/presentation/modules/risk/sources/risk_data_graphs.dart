class RiskData {
  RiskData({
    required this.sector,
    required this.puesto,
    required this.aceptable,
    required this.adecuado,
    required this.tolerable,
    required this.inaceptable,
    required this.count,
  });
  final String sector;
  final String puesto;
  final int aceptable;
  final int adecuado;
  final int tolerable;
  final int inaceptable;
  final int count;
}

List<RiskData> parseRiskData(Map<String, dynamic> jsonData) {
  List<RiskData> riskDataList = [];

  jsonData.forEach((key, value) {
    String sector = key.split(" - ")[0];
    String puesto = key.split(" - ")[1];

    int aceptable = value['Aceptable'];
    int adecuado = value['Adecuado'];
    int tolerable = value['Tolerable'];
    int inaceptable = value['Inaceptable'];
    int count = value['count'];

    RiskData riskData = RiskData(
      sector: sector,
      puesto: puesto,
      aceptable: aceptable,
      adecuado: adecuado,
      tolerable: tolerable,
      inaceptable: inaceptable,
      count: count,
    );

    riskDataList.add(riskData);
  });

  return riskDataList;
}
