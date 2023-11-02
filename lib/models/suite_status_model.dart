enum ESuiteStatus { available, notAvailable }

class SuiteStatus {
  final int id;
  final String status;

  const SuiteStatus({
    required this.id,
    required this.status
  });
}