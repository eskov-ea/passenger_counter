import 'package:equatable/equatable.dart';

class Person extends Equatable{
  final int id;
  final String firstname;
  final String lastname;
  final String middlename;
  final String gender;
  final String birthdate;
  final String phone;
  final String email;
  final String citizenship;
  final String personClass;
  final String? comment;
  final int? parentId;
  final String photo;
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
    required this.citizenship,
    required this.personClass,
    required this.comment,
    required this.parentId,
    required this.photo,
    required this.createdAt,
    required this.updatedAt
  });

  static Person fromJson(json) =>
      Person(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        phone: json["phone"],
        email: json["email"],
        citizenship: json["citizenship"],
        personClass: json["class_person"],
        comment: json["comment"],
        photo: json["photo"],
        parentId: json["parent_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  static Person fromQRCode(json) =>
      Person(
        id: 0,
        firstname: json["firstname"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        phone: json["phone"],
        email: json["email"],
        citizenship: json["citizenship"],
        personClass: json["class_person"] ?? "Regular",
        comment: "",
        photo: "",
        parentId: 0,
        createdAt: "",
        updatedAt: ""
      );

    @override
    String toString() {
      return "Instance Person [ firstname: $firstname, lastname: $lastname, middlename: $middlename,"
          " gender: $gender, birthdate: $birthdate, phone: $phone, "
          "email: $email, citizenship: $citizenship, "
          "person class: $personClass, comment: $comment, created at: $createdAt, updated at: $updatedAt";
    }

    @override
    List<Object?> get props => [id, createdAt, updatedAt];
  }

  class PersonDocument extends Equatable {
    final int? id;
    final String name;
    final String description;
    final int personId;

    const PersonDocument({
      required this.id,
      required this.name,
      required this.description,
      required this.personId,
    });

    static PersonDocument fromJson(json) => PersonDocument(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      personId: json["id_person"]
    );

    static PersonDocument fromQRCode(json) => PersonDocument(
        id: null,
        name: json["name"],
        description: json["description"],
        personId: 0
    );

    @override
    String toString() => "$name $description\n\r";

    @override
    List<Object?> get props => [id];
  }