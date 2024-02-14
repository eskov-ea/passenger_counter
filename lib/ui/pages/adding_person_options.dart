import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_brief.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_fullsize.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import '../../models/person_model.dart';
import '../../navigation/navigation.dart';
import '../../services/database/db_provider.dart';
import '../screens/success_info_screen.dart';



class PersonCollisionOptions extends StatefulWidget {
  final Person newPerson;
  final String personDocumentName;
  final String personDocumentNumber;
  final List<Person> persons;

  const PersonCollisionOptions({
    required this.newPerson,
    required this.personDocumentName,
    required this.personDocumentNumber,
    required this.persons,
    super.key
  });

  @override
  State<PersonCollisionOptions> createState() => _PersonCollisionOptionsState();
}

class _PersonCollisionOptionsState extends State<PersonCollisionOptions> {

  Person? updatedPerson;
  List<PersonDocument>? updatedPersonDocuments;

  onUpdatePersonData(Person? person) async {
    if (person == null) throw Error();
    final docs = await DBProvider.db.getPersonDocuments(personId: person.id);
    setState(() {
      updatedPerson = person;
      updatedPersonDocuments = docs;
    });
  }

  Future<void> _saveNewPerson() async {
    try {
      final personId = await DBProvider.db.addPerson(widget.newPerson);
      final document = PersonDocument(
        id: null,
        name: widget.personDocumentName,
        description: widget.personDocumentNumber,
        personId: personId
      );
      await DBProvider.db.addDocument(document: document);
      PopupManager.showInfoPopup(context, dismissible: true, type: PopupType.success, message: 'Контакт успешно сохранен в Базу Данных!');
      context.goNamed(NavigationRoutes.homeScreen.name);
    } catch (err) {
      print("[ DATABASE ERROR]:::   $err");
    }
  }

  Future<void> _updatePerson() async {
    try {
      String phone = updatedPerson!.phone;
      String email = updatedPerson!.email;

      if (widget.newPerson.phone.trim() != updatedPerson!.phone.trim()) {
        phone = widget.newPerson.phone.trim();
      }
      if (widget.newPerson.email.trim() != updatedPerson!.email.trim()) {
        email = widget.newPerson.email.trim();
      }
      final List<PersonDocument> searchedDocs = await DBProvider.db.findPersonDocument(
        name: widget.personDocumentName, number: widget.personDocumentNumber
      );
      if (searchedDocs.isEmpty) {
        final PersonDocument newDoc = PersonDocument(
            id: null,
            name: widget.personDocumentName,
            description: widget.personDocumentNumber,
            personId: updatedPerson!.id
        );
        await DBProvider.db.addDocument(document: newDoc);
      }
      final res = await DBProvider.db.updatePersonsContactInformation(id: updatedPerson!.id, phone: phone, email: email);
      final List<PersonDocument> allPersonDocs = await DBProvider.db.getPersonDocuments(personId: updatedPerson!.id);
      PopupManager.showInfoPopup(context, dismissible: true, type: PopupType.success, message: 'Контакт успешно сохранен!');
      context.goNamed(NavigationRoutes.homeScreen.name);
    } catch(err) {
      print("[ DATABASE ERROR]:::   $err");
    }
  }

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
              PersonCardFullSize(person: widget.newPerson,
                personDocuments: [PersonDocument(id: null, name: widget.personDocumentName,
                description: widget.personDocumentNumber, personId: 0),]),
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
            PersonCardFullSize(person: updatedPerson!, personDocuments: updatedPersonDocuments!),
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
  final String personDocumentName;
  final String personDocumentNumber;

  const AddingPersonOptionsArguments({
    required this.newPerson,
    required this.personDocumentName,
    required this.personDocumentNumber,
    required this.persons
  });
}
