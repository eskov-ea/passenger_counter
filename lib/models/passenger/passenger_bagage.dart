class PassengerBagage {
  final int id;
  final int passengerId;
  final int weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PassengerBagage({
    required this.id,
    required this.passengerId,
    required this.weight,
    required this.createdAt,
    required this.updatedAt
  });
}