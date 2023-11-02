class RoundPassenger {
  final int id;
  final int roundId;
  final int passengerId;
  final int suiteId;
  final String baggageStatus;
  final String? baggageWeight;
  final int children;
  final String passangerRoundStatus;
  final String passId;

  const RoundPassenger({
    required this.id,
    required this.roundId,
    required this.passengerId,
    required this.suiteId,
    required this.baggageStatus,
    required this.baggageWeight,
    required this.children,
    required this.passangerRoundStatus,
    required this.passId,
  });
}