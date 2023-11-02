class Passenger {
  final int id;
  final String firstname;
  final String lastname;
  final String middlename;
  final DateTime dayBirth;
  final String passportSerialNumber;
  final String passportNumber;
  final String citizenship;
  final String passportScanPath;


  Passenger({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.dayBirth,
    required this.passportSerialNumber,
    required this.passportNumber,
    required this.citizenship,
    required this.passportScanPath
  });

  static Passenger fromJson(json) =>
      Passenger(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        dayBirth: json["dayBirth"],
        passportSerialNumber: json["passportSerialNumber"],
        passportNumber: json["passportNumber"],
        citizenship: json["citizenship"],
        passportScanPath: json["passportScanPath"]
      );


  }