import 'package:intl/intl.dart';

class Trip {
  final int id;
  final String tripName;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final int status;
  final String comment;

  Trip({
    required this.id,
    required this.tripName,
    required this.tripStartDate,
    required this.tripEndDate,
    required this.status,
    required this.comment
  });

  static Trip fromJson(json) => Trip(
      id: json["id"],
      tripName: json["name"],
      tripStartDate: DateTime.parse(json["start_trip"]),
      tripEndDate: DateTime.parse(json["end_trip"]),
      status: json["status"],
      comment: json["comments"]
  );

  String getTripDate() => "${DateFormat.yMd().format(tripStartDate)} ${DateFormat.Hm().format(tripStartDate)} "
      "- ${DateFormat.yMd().format(tripEndDate)} ${DateFormat.Hm().format(tripEndDate)}";
}