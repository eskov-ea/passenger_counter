import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/person_card_brief.dart';
import 'package:pleyona_app/ui/widgets/person_card_fullsize.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import '../../models/person_model.dart';
import '../../navigation/navigation.dart';
import '../../services/database/db_provider.dart';
import '../screens/success_info_screen.dart';



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

  onUpdatePersonData(Person? person) {
    setState(() {
      updatedPerson = person;
    });
  }

  Future<void> _saveNewPerson() async {
    try {
      final res = await DBProvider.db.addPerson(widget.newPerson);
      print("[ DATABASE RESULT]:::   $res");
      Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.successInfoScreen,
          arguments: InfoScreenArguments(message: "Контакт успешно сохранен в Базу Данных!", routeName: MainNavigationRouteNames.homeScreen,
              person: widget.newPerson)
      );
    } catch (err) {
      print("[ DATABASE ERROR]:::   $err");
    }
  }

  Future<void> _updatePerson() async {
    try {
      String doc = updatedPerson!.document;
      String phone = updatedPerson!.phone;
      String email = updatedPerson!.email;
      if (widget.newPerson.document.trim() != updatedPerson!.document.trim()) {
        final List<String> docs = updatedPerson!.document.split(",");
        if (!docs.contains(widget.newPerson.document.trim())) {
          doc += ", ${widget.newPerson.document.trim()}";
        }
      }
      if (widget.newPerson.phone.trim() != updatedPerson!.phone.trim()) {
        phone = widget.newPerson.phone.trim();
      }
      if (widget.newPerson.email.trim() != updatedPerson!.email.trim()) {
        email = widget.newPerson.email.trim();
      }
      final res = await DBProvider.db.updatePerson(id: updatedPerson!.id, document: doc, phone: phone, email: email);
      print("[ DATABASE RESULT]:::   $res");
      Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.successInfoScreen,
          arguments: InfoScreenArguments(message: "Контакт успешно обновлен!", routeName: MainNavigationRouteNames.homeScreen,
              person: updatedPerson!)
      );
    } catch(err) {
      print("[ DATABASE ERROR]:::   $err");
    }
  }

  Person? updatedPerson;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: AppColors.cardColor4,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 40,),
              PersonCardFullSize(person: widget.newPerson),
              const SizedBox(height: 20,),
              updatedPerson == null
              ? const Text("Мы нашли контакты, ранее зарегистрированные с тикими данными. Вы можете обновить контакт или сохранить новый. Для обновления выберите контакт.",
                style: AppStyles.secondaryTextStyle
              )
              : const Text("Данные этого контакта будут расширены и обновлены новыми данными. Продолжить?",
                  style: AppStyles.secondaryTextStyle
              ),
              updatedPerson == null
              ? _onChoosingMode()
              : _onConfirmMode()
            ],
          ),
        )
      ),
    );
  }

  Widget _onChoosingMode() {
    return Container(
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: widget.persons.length,
                  itemBuilder: (context, index) {
                    return PersonCardBrief(person: widget.persons[index], onTap: onUpdatePersonData);
                  }
              ),
            ),
            SaveButton(onTap: _saveNewPerson, label: "Сохранить как новый"),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  Widget _onConfirmMode() {
    return Container(
      child: Expanded(
        child: Column(
          children: [
            PersonCardFullSize(person: updatedPerson!),
            const SizedBox(height: 10,),
            SaveButton(onTap: () {
              setState(() {
                updatedPerson = null;
              });
            }, label: "Отмена", color: AppColors.backgroundMain5),
            const SizedBox(height: 10,),
            SaveButton(onTap: _updatePerson, label: "Обновить контакт"),
            const SizedBox(height: 10,)
          ],
        ),
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
