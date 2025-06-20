class Wishbook {
  final int id;
  final String date;
  final String employeeId;
  final String shift;

  Wishbook({
    required this.id,
    required this.date,
    required this.employeeId,
    required this.shift
  });

  factory Wishbook.fromJson(Map<String, dynamic> json) {
    return Wishbook(
        id: json["id"],
        date: json["date"],
        employeeId: json["employeeId"],
        shift: json["shift"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date,
      "employeeId": employeeId,
      "shift": shift
    };
  }
}