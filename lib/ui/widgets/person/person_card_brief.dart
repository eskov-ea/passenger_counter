import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/theme.dart';


class PersonCardBrief extends StatelessWidget {
  final Person person;
  final Function(Person) onTap;
  const PersonCardBrief({
    required this.person,
    required this.onTap,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    final String personName = "${person.lastname} ${person.firstname} ${person.middlename}";

    return GestureDetector(
      onTap: () { onTap(person); },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                person.photo != ""
                    ? Image.memory(base64Decode(person.photo),
                  fit: BoxFit.cover,
                  width: 60,
                  height: 100,
                )
                    : Image.asset("assets/images/no_avatar.png",
                  fit: BoxFit.cover,
                  width: 60,
                  height: 100,
                ),
                person.parentId != 0 ? Transform.translate(
                  offset: const Offset(20, 2),
                  child: Image.asset("assets/icons/baby-icon.png",
                    width: 50, height: 50, fit: BoxFit.contain,
                  ),
                ) : const SizedBox.shrink()
              ],
            ),
            const SizedBox(width: 10,),
            Container(
              width: MediaQuery.of(context).size.width - 100 - 50,
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(personName,
                      style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2, height: 1),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Text(person.birthdate,
                      style: TextStyle(fontSize: 14, color: AppColors.backgroundMain2, height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(person.phone,
                      style: TextStyle(fontSize: 14, color: AppColors.backgroundMain2, height: 1),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
