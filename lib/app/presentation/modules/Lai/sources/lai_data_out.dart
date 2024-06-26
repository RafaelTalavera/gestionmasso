class Lai {
  Lai({
    required this.id,
    required this.date,
    required this.nameOrganization,
    required this.area,
    required this.tipo,
    required this.activity,
    required this.aspect,
    required this.impact,
    required this.temporality,
    required this.description,
    required this.cycle,
    required this.frequency,
    required this.damage,
    required this.stateHolder,
    required this.legislation,
    required this.meaningfulness,
    required this.typeOfControl,
    required this.descriptionOfControl,
    required this.dateOfRevision,
    required this.userId,
  });

  factory Lai.fromJson(Map<String, dynamic> json) {
    return Lai(
      id: json['id'],
      date: DateTime.parse(json['date']),
      nameOrganization: json['nameOrganization'],
      area: json['area'],
      tipo: json['tipo'],
      activity: json['activity'],
      aspect: json['aspect'],
      impact: json['impact'],
      temporality: json['temporality'],
      description: json['description'],
      cycle: json['cycle'],
      frequency: json['frequency'], // Asignar el campo 'frequency'
      damage: json['damage'], // Asignar el campo 'damage'
      stateHolder: json['stateHolder'] == 'true',
      legislation: json['legislation'] == 'true',
      meaningfulness: json['meaningfulness'],
      typeOfControl: json['typeOfControl'],
      descriptionOfControl: json['descriptionOfControl'],
      dateOfRevision: json['dateOfRevision'] != null
          ? DateTime.parse(json['dateOfRevision'])
          : null,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'nameOrganization': nameOrganization,
      'area': area,
      'tipo': tipo,
      'activity': activity,
      'aspect': aspect,
      'impact': impact,
      'temporality': temporality,
      'description': description,
      'cycle': cycle,
      'frequency': frequency,
      'damage': damage,
      'stateHolder': stateHolder,
      'legislation': legislation,
      'meaningfulness': meaningfulness,
      'typeOfControl': typeOfControl,
      'descriptionOfControl': descriptionOfControl,
      'dateOfRevision': dateOfRevision?.toIso8601String(),
      'userId': userId,
    };
  }

  Lai copyWith({
    String? id,
    DateTime? date,
    String? nameOrganization,
    String? area,
    String? tipo,
    String? activity,
    String? aspect,
    String? impact,
    String? temporality,
    String? description,
    String? cycle,
    int? frequency,
    int? damage,
    bool? stateHolder,
    bool? legislation,
    String? meaningfulness,
    String? typeOfControl,
    String? descriptionOfControl,
    DateTime? dateOfRevision,
    String? userId,
  }) {
    return Lai(
      id: id ?? this.id,
      date: date ?? this.date,
      nameOrganization: nameOrganization ?? this.nameOrganization,
      area: area ?? this.area,
      tipo: tipo ?? this.tipo,
      activity: activity ?? this.activity,
      aspect: aspect ?? this.aspect,
      impact: impact ?? this.impact,
      temporality: temporality ?? this.temporality,
      description: description ?? this.description,
      cycle: cycle ?? this.cycle,
      frequency: frequency ?? this.frequency,
      damage: damage ?? this.damage,
      stateHolder: stateHolder ?? this.stateHolder,
      legislation: legislation ?? this.legislation,
      meaningfulness: meaningfulness ?? this.meaningfulness,
      typeOfControl: typeOfControl ?? this.typeOfControl,
      descriptionOfControl: descriptionOfControl ?? this.descriptionOfControl,
      dateOfRevision: dateOfRevision ?? this.dateOfRevision,
      userId: userId ?? this.userId,
    );
  }

  final String id;
  final DateTime date;
  final String nameOrganization;
  final String area;
  final String tipo; //este
  final String activity;
  final String aspect; //este
  final String impact; //este
  final String temporality;
  final String description;
  final String cycle;
  final int frequency; 
  final int damage; 
  final bool stateHolder;
  final bool legislation;
  final String meaningfulness; //este
  final String? typeOfControl; 
  final String? descriptionOfControl; //este
  final DateTime? dateOfRevision; // este
  final String userId;
}
