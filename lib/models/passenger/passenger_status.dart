class PassengerStatus {
  final int id;
  final int passengerId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PassengerStatus({
    required this.id,
    required this.passengerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });
}