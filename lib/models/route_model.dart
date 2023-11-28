class TripModel {
  final int id;
  final String tripName;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final int status;
  final String comment;

  TripModel({
    required this.id,
    required this.tripName,
    required this.tripStartDate,
    required this.tripEndDate,
    required this.status,
    required this.comment
  });

  static TripModel fromJson(json) => TripModel(
      id: json["id"],
      tripName: json["name"],
      tripStartDate: DateTime.parse(json["start_trip"]),
      tripEndDate: DateTime.parse(json["end_trip"]),
      status: json["status"],
      comment: json["comments"]
  );

}