class AccidentsTotal {
  AccidentsTotal({
    required this.organization,
    required this.year,
    required this.month,
    required this.totalAccidents,
  });

  factory AccidentsTotal.fromJson(Map<String, dynamic> json) {
    return AccidentsTotal(
      organization: json['organization'] ?? '',
      year: json['year'] ?? '',
      month: json['month'] ?? '',
      totalAccidents: json['totalAccidents'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'year': year,
      'month': month,
      'totalAccidents': totalAccidents,
    };
  }

  AccidentsTotal copyWith({
    String? organization,
    int? year,
    int? month,
    int? totalAccidents,
  }) {
    return AccidentsTotal(
      organization: organization ?? this.organization,
      year: year ?? this.year,
      month: month ?? this.month,
      totalAccidents: totalAccidents ?? this.totalAccidents,
    );
  }

  final String organization;
  final int year;
  final int month;
  final int totalAccidents;
}
