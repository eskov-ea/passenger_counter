import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/theme.dart';
import '../../../globals.dart';


class PersonCardFullSize extends StatelessWidget {
  final Person person;
  final List<PersonDocument> personDocuments;
  const PersonCardFullSize({
    required this.person,
    required this.personDocuments,
    super.key
  });

  double _getDocumentsContainerHeight() {
    if (personDocuments.length < 4) {
      return personDocuments.length * 45.0;
    } else {
      return 120.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String personName = "${person.lastname} ${person.firstname} ${person.middlename}";


    return GestureDetector(
      onTap: () { print("[ PERSON CARD ]:::: $personDocuments"); },
      child: Container(
        margin: const EdgeInsets.only(top: 10,),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // height: 400,
        decoration: BoxDecoration(
          color: AppColors.textMain,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      person.photo != ""
                          ? Image.memory(base64Decode(person.photo),
                        fit: BoxFit.cover,
                        width: 120,
                        height: 130,
                      )
                          : Image.asset("assets/images/no_avatar.png",
                        fit: BoxFit.cover,
                        width: 120,
                        height: 130,
                      ),
                    ],
                  ),
                ),
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
                          child: Text("${person.birthdate} , ${person.gender}",
                            style: AppStyles.submainTitleTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text(person.citizenship,
                            style: AppStyles.secondaryTextStyle,
                          ),
                        ),
                        person.comment != null
                            ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text(person.comment!,
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
            Container(
              height: _getDocumentsContainerHeight(),
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemCount: personDocuments.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Text("${personDocuments[index].name} ${personDocuments[index].description}",
                    style: AppStyles.submainTitleTextStyle,
                    // maxLines: 1,
                  )
                )
              ),
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 5 * 2 - 10 - 20,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Text(person.phone,
                    style: AppStyles.secondaryTextStyle,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5 * 3 - 10 - 20,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(person.email,
                      style: AppStyles.secondaryTextStyle,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}

