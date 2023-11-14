import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/theme.dart';


class PersonCard extends StatelessWidget {
  final Person person;
  PersonCard({
    required this.person,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    final String personName = "${person.lastname} ${person.firstname} ${person.middlename}";

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.textMain
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 150,
            child: Image.asset("assets/images/no_avatar.png",
              fit: BoxFit.cover,
            ),
            color: AppColors.accent1,
          ),
          SizedBox(width: 10,),
          Container(
            width: MediaQuery.of(context).size.width - 100 -40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Text(personName,
                    style: AppStyles.submainTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Text(person.birthdate,
                    style: AppStyles.submainTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Text(person.phone,
                    style: AppStyles.submainTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Text(person.email,
                    style: AppStyles.submainTitleTextStyle,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
