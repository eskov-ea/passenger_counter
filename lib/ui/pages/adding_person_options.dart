import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/person_card_brief.dart';
import 'package:pleyona_app/ui/widgets/person_card_fullsize.dart';

import '../../models/person_model.dart';

class AddingPersonOptions extends StatefulWidget {
  final Person newPerson;
  final List<Person> persons;

  const AddingPersonOptions({
    required this.newPerson,
    required this.persons,
    super.key
  });

  @override
  State<AddingPersonOptions> createState() => _AddingPersonOptionsState();
}

class _AddingPersonOptionsState extends State<AddingPersonOptions> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.cardColor4,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return PersonCardFullSize(person: widget.newPerson);
            }
          ),
        )
      ),
    );
  }
}


class AddingPersonOptionsArguments {
  final Person newPerson;
  final List<Person> persons;

  const AddingPersonOptionsArguments({
    required this.newPerson,
    required this.persons
  });
}
