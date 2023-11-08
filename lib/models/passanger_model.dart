class Person {
  final int id;
  final String firstname;
  final String lastname;
  final String middlename;
  final DateTime birthdate;
  final String phone;
  final String email;
  final String passportSerialNumber;
  final String passportNumber;
  final String citizenship;
  final String status;
  final String passportScanPath;


  Person({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.birthdate,
    required this.phone,
    required this.email,
    required this.passportSerialNumber,
    required this.passportNumber,
    required this.citizenship,
    required this.status,
    required this.passportScanPath
  });

  static Person fromJson(json) =>
      Person(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        birthdate: json["birthdate"],
        phone: json["phone"],
        email: json["email"],
        passportSerialNumber: json["passportSerialNumber"],
        passportNumber: json["passportNumber"],
        citizenship: json["citizenship"],
        status: json["status"],
        passportScanPath: json["passportScanPath"]
      );


  }