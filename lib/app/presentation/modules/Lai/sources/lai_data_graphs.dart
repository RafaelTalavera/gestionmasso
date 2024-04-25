class LaiData {
  LaiData({
    required this.area,
    required this.nameOrganization,
    required this.aceptable,
    required this.adecuado,
    required this.tolerable,
    required this.inaceptable,
    required this.count,
  });
  final String area;
  final String nameOrganization;
  final int aceptable;
  final int adecuado;
  final int tolerable;
  final int inaceptable;
  final int count;
}

List<LaiData> parseLaiData(Map<String, dynamic> jsonData) {
  List<LaiData> laiDataList = [];

  jsonData.forEach((key, value) {
    String nameOrganization = key.split(" - ")[-0];
    String area = key.split("-")[0];
    int aceptable = value['Aceptable'];
    int adecuado = value['Adecuado'];
    int tolerable = value['Tolerable'];
    int inaceptable = value['Inaceptable'];
    int count = value['count'];

    LaiData listData = LaiData(
      nameOrganization: nameOrganization,
      area: area,
      aceptable: aceptable,
      adecuado: adecuado,
      tolerable: tolerable,
      inaceptable: inaceptable,
      count: count,
    );

    laiDataList.add(listData);
  });

  return laiDataList;
}
