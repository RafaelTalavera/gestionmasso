class StatistcsTotal {
  StatistcsTotal({
    required this.organization,
    required this.year,
    required this.month,
    required this.totalHours,
  });

  factory StatistcsTotal.fromJson(Map<String, dynamic> json) {
    return StatistcsTotal(
      organization: json['organization'] ?? '',
      year: json['year'] ?? '',
      month: json['month'] ?? '',
      totalHours: json['totalHours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'year': year,
      'month': month,
      'totalHours': totalHours,
    };
  }

  StatistcsTotal copyWith({
    String? organization,
    int? year,
    int? month,
    int? totalHours,
  }) {
    return StatistcsTotal(
      organization: organization ?? this.organization,
      year: year ?? this.year,
      month: month ?? this.month,
      totalHours: totalHours ?? this.totalHours,
    );
  }

  final String organization;
  final int year;
  final int month;
  final int totalHours;
}
