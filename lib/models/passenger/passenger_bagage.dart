class PassengerBagage {
  final int id;
  final int passengerId;
  final int weight;
  final String createdAt;
  final String updatedAt;

  const PassengerBagage({
    required this.id,
    required this.passengerId,
    required this.weight,
    required this.createdAt,
    required this.updatedAt
  });

  static PassengerBagage fromJson(json) =>
      PassengerBagage(
        id: json["id"],
        passengerId: json["passenger_id"],
        weight: json["weight"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"]
      );
}