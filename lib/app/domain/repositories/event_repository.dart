class Event {
  Event({
    required this.id,
    required this.dateEvent,
    required this.severity,
    required this.bodyPart,
    required this.injury,
    required this.incidenType,
    required this.entry,
    required this.workOccasion,
    required this.hoursWorked,
    required this.trainingDate,
    required this.accidentHistory,
    required this.authorization,
    required this.pts,
    required this.machine,
    required this.authorizationWork,
    required this.ptsApplied,
    required this.energia,
    required this.lockedIn,
    required this.lockedRequired,
    required this.lockedUsed,
    required this.defense,
    required this.defenserIntegrity,
    required this.workEquimentFails,
    required this.correctUseEquimat,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      dateEvent: DateTime.parse(json['dateEvent'] ?? ''),
      severity: json['severity'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      injury: json['injury'] ?? '',
      incidenType: json['incidenType'] ?? '',
      entry: DateTime.parse(json['entry'] ?? ''),
      workOccasion: json['workOccasion'] ?? '',
      hoursWorked: json['hoursWorked'] ?? '',
      trainingDate: DateTime.parse(json['trainingDate'] ?? ''),
      accidentHistory: json['accidentHistory'] ?? false,
      authorization: json['authorization'] ?? false,
      pts: json['pts'] ?? false,
      machine: json['machine'] ?? false,
      authorizationWork: json['authorizationWork'] ?? false,
      ptsApplied: json['ptsApplied'] ?? false,
      energia: json['energia'] ?? '',
      lockedIn: json['lockedIn'] ?? false,
      lockedRequired: json['lockedRequired'] ?? false,
      lockedUsed: json['lockedUsed'] ?? false,
      defense: json['defense'] ?? false,
      defenserIntegrity: json['defenserIntegrity'] ?? false,
      workEquimentFails: json['workEquimentFails'] ?? false,
      correctUseEquimat: json['correctUseEquimat'] ?? false,
    );
  }
  final String id;
  final DateTime dateEvent;
  final String severity;
  final String bodyPart;
  final String injury;
  final String incidenType;
  final DateTime entry;
  final String workOccasion;
  final String hoursWorked;
  final DateTime trainingDate;
  final bool accidentHistory;
  final bool authorization;
  final bool pts;
  final bool machine;
  final bool authorizationWork;
  final bool ptsApplied;
  final String energia;
  final bool lockedIn;
  final bool lockedRequired;
  final bool lockedUsed;
  final bool defense;
  final bool defenserIntegrity;
  final bool workEquimentFails;
  final bool correctUseEquimat;
}
