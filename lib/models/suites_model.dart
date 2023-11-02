class RoundSuites {
  final int id;
  final int roundId;
  final List<String> roundSeats;
  final int? passangerId;

  const RoundSuites({
    required this.id,
    required this.roundId,
    required this.roundSeats,
    required this.passangerId,
  });
}