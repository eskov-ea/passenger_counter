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
      tripName: json["tripName"],
      tripStartDate: json["tripStartDate"],
      tripEndDate: json["tripEndDate"],
      status: json["status"],
      comment: json["comment"]
  );

}