class Statistcs {
  Statistcs(
      {required this.id,
      required this.organizationId,
      required this.nameOrganization,
      required this.month,
      required this.year,
      required this.people,
      required this.hours,
      required this.userId});

  factory Statistcs.fromJson(Map<String, dynamic> json) {
    return Statistcs(
      id: json['id'] ?? '',
      organizationId: json['organizationId'],
      nameOrganization: json['nameOrganization'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      people: json['people'] ?? '',
      hours: json['hours'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'nameOrganization': nameOrganization,
      'month': month,
      'year': year,
      'people': people,
      'hours': hours,
      'userId': userId,
    };
  }

  Statistcs copyWith({
    String? id,
    String? organizationId,
    String? nameOrganization,
    int? month,
    int? year,
    int? people,
    int? hours,
    String? userId,
  }) {
    return Statistcs(
      id: id ?? this.id,
      nameOrganization: nameOrganization ?? this.nameOrganization,
      organizationId: organizationId ?? this.organizationId,
      month: month ?? this.month,
      year: year ?? this.year,
      people: people ?? this.people,
      hours: hours ?? this.hours,
      userId: userId ?? this.userId,
    );
  }

  final String id;
  final String nameOrganization;
  final String organizationId;
  final int month;
  final int year;
  final int people;
  final int hours;
  final String userId;
}
