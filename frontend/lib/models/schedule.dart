class Schedule {
  final String date;
  final List<int> shift_1;
  final List<int> shift_2;

  Schedule({
    required this.date,
    required this.shift_1,
    required this.shift_2,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      date: json['date'] ?? "",
      shift_1: List<int>.from(json['shift_1']),
      shift_2: List<int>.from(json['shift_2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'shift_1': shift_1,
      'shift_2': shift_2,
    };
  }
}
