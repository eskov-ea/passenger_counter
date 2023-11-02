class RoundModel {
  final int id;
  final String shipName;
  final DateTime roundDepartureDate;
  final DateTime roundArrivalDate;
  final String departureCity;
  final String arrivalCity;

  RoundModel({
    required this.id,
    required this.shipName,
    required this.roundDepartureDate,
    required this.roundArrivalDate,
    required this.departureCity,
    required this.arrivalCity
  });
}