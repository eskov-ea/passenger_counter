class PassengerStatus {
  final int id;
  final int passengerId;
  final String status;
  final String createdAt;

  const PassengerStatus({
    required this.id,
    required this.passengerId,
    required this.status,
    required this.createdAt
  });

  static PassengerStatus fromJson(json) => PassengerStatus(
      id: json['id'],
      passengerId: json['passenger_id'],
      status: json['status'],
      createdAt: json['created_at']
  );
}

class PassengerStatusValue {
  final String statusName;
  final int seq;

  PassengerStatusValue(this.statusName, this.seq);

  static PassengerStatusValue fromJson(json) => PassengerStatusValue(
    json['status'],
    json['seq']
  );
}