import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/theme.dart';


class PersonCardFullSize extends StatelessWidget {
  final Person person;
  const PersonCardFullSize({
    required this.person,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    final String personName = "${person.lastname} ${person.firstname} ${person.middlename}";

    return GestureDetector(
      onTap: () { print("[ PERSON CARD ]:::: $personName"); },
      child: Container(
        margin: const EdgeInsets.only(top: 10,),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.textMain,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              child: Column(
                children: [
                  Image.asset("assets/images/no_avatar.png",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Text(person.phone,
                      style: AppStyles.secondaryTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(person.email,
                      style: AppStyles.secondaryHalfTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Text(personName,
                        style: AppStyles.submainTitleTextStyle,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Text(person.birthdate,
                        style: AppStyles.submainTitleTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(person.document,
                          style: AppStyles.submainTitleTextStyle,
                          maxLines: 1,
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Text(person.citizenship,
                        style: AppStyles.secondaryTextStyle,
                      ),
                    ),
                    person.status != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Text(person.status!,
                        style: AppStyles.secondaryHalfTextStyle,
                        maxLines: 2,
                      ),
                    )
                    : SizedBox.shrink(),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
