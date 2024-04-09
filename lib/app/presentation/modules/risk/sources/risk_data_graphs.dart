class RiskData {
  RiskData({
    required this.organization,
    required this.area,
    required this.puesto,
    required this.aceptable,
    required this.adecuado,
    required this.tolerable,
    required this.inaceptable,
    required this.count,
  });

  final String organization;
  final String area;
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
    String organization = key.split(" - ")[0];
    String area = key.split(" - ")[1];
    String puesto = key.split(" - ")[2];

    int aceptable = value['Aceptable'] ?? 0;
    int adecuado = value['Adecuado'] ?? 0;
    int tolerable = value['Tolerable'] ?? 0;
    int inaceptable = value['Inaceptable'];
    int count = value['count'] ?? 0;

    RiskData riskData = RiskData(
      organization: organization,
      area: area,
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
