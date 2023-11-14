import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/theme.dart';


class PersonCardBrief extends StatelessWidget {
  final Person person;
  const PersonCardBrief({
    required this.person,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    final String personName = "${person.lastname} ${person.firstname} ${person.middlename}";

    return GestureDetector(
      onTap: () { print("[ PERSON CARD ]:::: $personName"); },
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.textMain,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 120,
              child: Image.asset("assets/images/no_avatar.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10,),
            Container(
              width: MediaQuery.of(context).size.width - 100 - 50,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(personName,
                      style: AppStyles.submainTitleTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(person.birthdate,
                      style: AppStyles.submainTitleTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(person.phone,
                      style: AppStyles.submainTitleTextStyle,
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
