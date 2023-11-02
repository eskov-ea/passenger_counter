class ShipSuites {
  final int id;
  final String shipId;
  final String name;
  final String seats;
  final String status;
  final String comment;

  const ShipSuites({
    required this.id,
    required this.shipId,
    required this.name,
    required this.seats,
    required this.status,
    required this.comment,
  });
}


class ShipSuiteSeats {
  final int id;
  final int suiteId;
  final String name;
  final String passId;
  final String status;
  final String comment;

  const ShipSuiteSeats({
    required this.id,
    required this.suiteId,
    required this.name,
    required this.passId,
    required this.status,
    required this.comment,
  });
}