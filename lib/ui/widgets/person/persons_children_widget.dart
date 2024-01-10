import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/ui/screens/person/person_edit_info_screen.dart';

class PersonsChildrenWidget extends StatelessWidget {
  final Person child;
  const PersonsChildrenWidget({
    required this.child,
    super.key
  });


  @override
  Widget build(BuildContext context) {
    Future<void> openEditPersonScreen() async {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.editPersonInfoScreen,
        arguments: EditPersonScreenArguments(person: child)
      );
    }
    return GestureDetector(
      onTap: openEditPersonScreen,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        height: 50,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Color(0xFFF6ECE6)
        ),
        child: Text('${child.lastname} ${child.firstname} ${child.middlename}'),
      ),
    );
  }
}
