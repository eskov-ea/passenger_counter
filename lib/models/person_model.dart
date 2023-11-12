class Person {
  final int id;
  final String firstname;
  final String lastname;
  final String middlename;
  final String birthdate;
  final String phone;
  final String email;
  final String document;
  final String citizenship;
  final String status;


  Person({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.birthdate,
    required this.phone,
    required this.email,
    required this.document,
    required this.citizenship,
    required this.status,
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
        document: json["document"],
        citizenship: json["citizenship"],
        status: json["status"],
      );


  }