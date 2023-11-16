class Person {
  final String id;
  final String firstname;
  final String lastname;
  final String middlename;
  final String gender;
  final String birthdate;
  final String phone;
  final String email;
  final String document;
  final String citizenship;
  final String personClass;
  final String? status;
  final String createdAt;
  final String updatedAt;


  Person({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.gender,
    required this.birthdate,
    required this.phone,
    required this.email,
    required this.document,
    required this.citizenship,
    required this.personClass,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

  static Person fromJson(json) =>
      Person(
        id: json["id"].toString(),
        firstname: json["firstname"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        phone: json["phone"],
        email: json["email"],
        document: json["document"],
        citizenship: json["citizenship"],
        personClass: json["class_person"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  static Person fromQRCode(json) =>
      Person(
        id: "",
        firstname: json["firstname"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        gender: json["gender"],
        birthdate: json["birth_date"],
        phone: json["phone"],
        email: json["email"],
        document: json["document"],
        citizenship: json["citizenship"],
        personClass: json["class_person"],
        status: "",
        createdAt: "",
        updatedAt: ""
      );


  }