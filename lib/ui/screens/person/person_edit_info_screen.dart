import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/bloc/camera_bloc/camera_state.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/person/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_search_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/editable_text_fields/editable_text_field_widget.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import '../../../bloc/camera_bloc/camera_bloc.dart';
import '../../../bloc/camera_bloc/camera_event.dart';
import '../../../models/person_model.dart';
import '../../../services/database/db_provider.dart';
import '../../widgets/editable_text_fields/editable_birthdate_field_widget.dart';
import '../../widgets/editable_text_fields/editable_comment_text_field.dart';
import '../../widgets/editable_text_fields/editable_document_field_widget.dart';
import '../../widgets/person/persons_children_widget.dart';
import '../camera_screen.dart';

class EditPersonInfoScreen extends StatefulWidget {

  final Person person;
  const EditPersonInfoScreen({
    required this.person,
    super.key
  });

  @override
  State<EditPersonInfoScreen> createState() => _EditPersonInfoScreenState();
}

class _EditPersonInfoScreenState extends State<EditPersonInfoScreen>{

  late String firstname;
  late String lastname;
  late String middlename;
  late String documentNumber;
  late String email;
  late String birthdateDay;
  late String birthdateMonth;
  late String birthdateYear;
  late String phone;
  late String citizenship;
  late String comment;
  late String personClass;
  bool isPersonDocumentsInited = false;
  bool isFemaleChecked = false;
  bool isMaleChecked = false;
  bool hasPersonChanges = false;

  bool firstnameHasError = false;
  bool lastnameHasError = false;
  bool middlenameHasError = false;
  bool emailHasError = false;
  bool birthdateHasError = false;
  bool phoneHasError = false;
  bool documentHasError = false;
  bool citizenshipHasError = false;
  bool isGenderFieldHasError = false;
  String? firstnameErrorMessage;
  String? lastnameErrorMessage;
  String? middlenameErrorMessage;
  String? emailErrorMessage;
  String? phoneErrorMessage;
  String? citizenshipErrorMessage;

  final TextEditingController personClassDropdownController = TextEditingController();
  late final List<DropdownMenuEntry<String>> personClassList;
  final FocusNode commentFieldFocus = FocusNode();
  final TextEditingController commentTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? documentInputFieldsErrorMessage;
  bool isEditingMode = false;
  bool isChildrenLoaded = false;

  late final List<PersonDocument> personDocuments;
  late final List<Widget> editableDocuments;
  late final CameraBloc _cameraBloc;
  bool isMenuOpen = false;
  List<Person>? children;
  List<String> documentNames = [];
  List<String> documentNumbers = [];
  List<bool> documentErrors = [];
  String? photo;



  void _onUpdate() async {
    if(
      firstnameHasError ||
      lastnameHasError ||
      middlenameHasError ||
      birthdateHasError ||
      documentErrors.contains(true)
    ) {
      print("THERE IS AN ERROR:::::");
    } else {
      final updatedPerson = Person(
        id: widget.person.id,
        firstname: firstname,
        lastname: lastname,
        middlename: middlename,
        gender: isMaleChecked ? "МУЖ" : "ЖЕН",
        birthdate: "$birthdateYear-$birthdateMonth-$birthdateDay",
        phone: phone,
        email: email,
        citizenship: citizenship,
        personClass: personClass,
        parentId: widget.person.parentId,
        comment: comment,
        photo: widget.person.photo,
        createdAt: widget.person.createdAt,
        updatedAt: DateTime.now().toString()
      );
      if (personDocuments.length < documentNames.length) {
        for (var i=personDocuments.length; i<documentNames.length; ++i) {
          final newDocument = PersonDocument(id: 0, name: documentNames[i], description: documentNumbers[i], personId: widget.person.id);
          await DBProvider.db.addDocument(document: newDocument);
        }
      }
      await DBProvider.db.updatePerson(p: updatedPerson, photo: photo);
      context.goNamed(NavigationRoutes.allPersonsScreen.name);
      //Todo: check dispose
      BlocProvider.of<CameraBloc>(context).add(DisposeCameraEvent());
    }
  }

  void onCheckboxMaleChecked(bool? value) {
    setState(() {
      isMaleChecked = false;
      isFemaleChecked = false;

      isMaleChecked = true;
    });
  }
  void onCheckboxFemaleChecked(bool? value) {
    setState(() {
      isMaleChecked = false;
      isFemaleChecked = false;

      isFemaleChecked = true;
    });
  }

  Future<void> deleteChildFromParent(Person p) async {
    try {
      await DBProvider.db.removeChildFromPerson(childPersonId: p.id);
      children?.removeWhere((child) => p.id == child.id);
      setState(() {});
      Navigator.of(context).pop();
    } catch (err, stackTrace) {

    }
  }

  Future<void> _openOnPopGuardAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы хотите сохранить черновик?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('У вас есть несохраненные данные.'),
                Text('Чтобы не потерять их, вы можете завершить заполнение формы или сохранить черновик и вернуться к его редактированию позже.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Выйти'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить черновик'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Продолжить редактирование'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  bool _checkForUnsavedChanges() {
    // if (
    // _lastnameController.text.isNotEmpty ||
    // _firstnameController.text.isNotEmpty ||
    // _middlenameController.text.isNotEmpty ||
    // _dayBirthFieldController.text.isNotEmpty ||
    // _monthBirthFieldController.text.isNotEmpty ||
    // _yearBirthFieldController.text.isNotEmpty ||
    // _documentNameFieldController.text.isNotEmpty ||
    // _documentNumberFieldController.text.isNotEmpty ||
    // _citizenshipFieldController.text.isNotEmpty
    // ) {
    //   return true;
    // } else {
    //   return false;
    // }
    return false;
  }

  Widget _addEditableDocument() {
    final docIndex = editableDocuments.length;
    String documentNumber = "";
    String documentName = "";
    documentNames.add(documentName);
    documentNumbers.add(documentNumber);
    documentErrors.add(false);
    void setDocName(String value) {
      setState(() {
        documentName = value;
      });
      documentNames[docIndex] = value;
      checkIfPersonHasChanges();
    }
    void setDocNumber(String value) {
      setState(() {
        documentNumber = value;
      });
      documentNumbers[docIndex] = value;
      checkIfPersonHasChanges();
    }
    void errorSetter(bool value) {
      documentErrors[docIndex] = value;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width - 20,
      child: EditableDocumentTextFieldWidget(
        label: "Новый документ", valueName: documentName, valueNumber: documentNumber,
        valueNameSetter: setDocName, valueNumberSetter: setDocNumber, errorSetter: errorSetter,
      )
    );
  }

  Widget _initEditableDocument(PersonDocument doc, int docIndex) {
    String documentNumber = doc.description;
    String documentName = doc.name;
    documentNames.add(documentName);
    documentNumbers.add(documentNumber);
    documentErrors.add(false);
    void setDocName(String value) {
      setState(() {
        documentName = value;
      });
      documentNames[docIndex-1] = value;
      checkIfPersonHasChanges();
    }
    void setDocNumber(String value) {
      setState(() {
        documentNumber = value;
      });
      documentNumbers[docIndex-1] = value;
      checkIfPersonHasChanges();
    }
    void errorSetter(bool value) {
      documentErrors[docIndex-1] = value;
    }
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width - 20,
        child: EditableDocumentTextFieldWidget(
          label: "Документ $docIndex", valueName: documentName, valueNumber: documentNumber,
          valueNameSetter: setDocName, valueNumberSetter: setDocNumber, errorSetter: errorSetter
        )
    );
  }
  
  @override
  void initState() {
    _cameraBloc = BlocProvider.of<CameraBloc>(context);
    _cameraBloc.add(InitializeCameraEvent());
    firstname = widget.person.firstname;
    lastname = widget.person.lastname;
    middlename = widget.person.middlename;
    email = widget.person.email;
    birthdateDay = widget.person.birthdate.split("-")[2];
    birthdateMonth = widget.person.birthdate.split("-")[1];
    birthdateYear = widget.person.birthdate.split("-")[0];
    phone = widget.person.phone;
    citizenship = widget.person.citizenship;
    comment = widget.person.comment ?? "";
    personClass = widget.person.personClass;
    if(widget.person.gender == "МУЖ") {
      isMaleChecked = true;
    }
    if(widget.person.gender == "ЖЕН") {
      isFemaleChecked = true;
    }
    int docIndex =0;
    DBProvider.db.getPersonDocuments(personId: widget.person.id).then((documents) {
      personDocuments = documents;
      editableDocuments = documents.map((doc) {
        ++docIndex;
        return _initEditableDocument(doc, docIndex);
      }).toList();
      setState(() {
        isPersonDocumentsInited = true;
      });
    });
    personClassList = PersonClass.values.map((value) => DropdownMenuEntry<String>(value: value.name, label: value.name.toUpperCase())).toList();
    DBProvider.db.getPersonChildren(widget.person.id).then((value) {
      setState(() {
        children = value.isNotEmpty ? value : null;
        isChildrenLoaded = true;
      });
    });

    super.initState();
  }

  bool _checkDocsChanges() {
    for (int i=0; i < personDocuments.length; ++i) {
      if(personDocuments[i].name != documentNames[i] || personDocuments[i].description != documentNumbers[i]) {
        return true;
      }
    }
    return false;

  }

  bool _checkNewDocsChanges() {
    if (editableDocuments.isEmpty) return false;
    final k = personDocuments.length;
    for (int j = 0 + k; j < documentNames.length; ++j) {
      if (documentNames[j].trim().isNotEmpty && documentNumbers[j].trim().isNotEmpty) return true;
    }
    return false;
  }

  void checkIfPersonHasChanges() {
    if(
      firstname != widget.person.firstname ||
      lastname != widget.person.lastname ||
      middlename != widget.person.middlename ||
      "$birthdateYear-$birthdateMonth-$birthdateDay" != widget.person.birthdate ||
      citizenship != widget.person.citizenship ||
      personClass != widget.person.personClass ||
      comment != widget.person.comment ||
      _checkDocsChanges() ||
      _checkNewDocsChanges() ||
      photo != null
    ) {
      log("checkIfPersonHasChanges ${_checkNewDocsChanges()}");
      setState(() {
        hasPersonChanges = true;
      });
    } else {
      log("checkIfPersonHasChanges ${_checkNewDocsChanges()}");
      setState(() {
        hasPersonChanges = false;
      });
    }
  }

  void _openCamera(BuildContext context ,List<CameraDescription> cameras, CameraController controller) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen(cameras: cameras, controller: controller, setPhotoResult: setPhotoResult)));
  }

  void setPersonChildToParent(Person child) async {
    final parentPersonId = widget.person.id;
    try {
      await DBProvider.db.addChildToPerson(childPersonId: child.id, parentPersonId: parentPersonId);
      context.goNamed(
          NavigationRoutes.homeScreen.name
      );
    } catch (err, stackTrace) {
      PopupManager.showInfoPopup(context, dismissible: false, type: PopupType.error, message: "Произошла ошибка при привязке ребенка к родителю. Пропробуйте снова.");
    }
  }

  void setPhotoResult(String result) {
    setState(() {
      photo = result;
    });
    checkIfPersonHasChanges();
  }

  @override
  void dispose() {
    _cameraBloc.add(DisposeCameraEvent());
    super.dispose();
  }

  void firstnameErrorSetter(bool value) {
    setState(() {
      firstnameHasError = value;
    });
  }
  void emailErrorSetter(bool value) {
    setState(() {
      emailHasError = value;
    });
  }
  void birthdateErrorSetter(bool value) {
    setState(() {
      birthdateHasError = value;
    });
  }
  void phoneErrorSetter(bool value) {
    setState(() {
      phoneHasError = value;
    });
  }
  void lastnameErrorSetter(bool value) {
    setState(() {
      lastnameHasError = value;
    });
  }
  void middlenameErrorSetter(bool value) {
    setState(() {
      middlenameHasError = value;
    });
  }
  void documentErrorSetter(bool value) {
    setState(() {
      documentHasError = value;
    });
  }
  void citizenshipErrorSetter(bool value) {
    setState(() {
      citizenshipHasError = value;
    });
  }

  bool validateFirstnameField() {
    print(":::: ${firstname.trim().isEmpty}");
    if (firstname.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validateLastnameField() {
    if (lastname.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }
  bool validateMiddlenameField() {
    if (middlename.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }
  void validateDocumentField() {
    setState(() {
      documentHasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_checkForUnsavedChanges()) {
          _openOnPopGuardAlert();
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(child: null, scrollController: _scrollController,),
          backgroundColor: AppColors.textMain,
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_cameraBloc.state.cameras == null || _cameraBloc.state.controller == null) {
                                PopupManager.showLoadingPopup(context);
                                BlocProvider.of<CameraBloc>(context).stream.listen((state) {
                                  if (state is InitializedCameraState) {
                                    _openCamera(context, state.cameras!, state.controller!);
                                    return;
                                  }
                                });
                                PopupManager.closePopup(context);
                              }
                              _openCamera(context, _cameraBloc.state.cameras!, _cameraBloc.state.controller!);
                            },
                            child: Container(
                              height: 130,
                              width: MediaQuery.of(context).size.width * 0.3 - 15,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 130,
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width * 0.3 - 10,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:  widget.person.photo != ""
                                                ? MemoryImage(base64Decode(photo ?? widget.person.photo))
                                                : const AssetImage("assets/images/no_avatar.png") as ImageProvider
                                        )
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(bottom: 20),
                                    color: Color(0x40000000),
                                    child: const Text("Изменить фото",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xFFFFFFFF)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.7 - 15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EditableTextFieldWidget(
                                  label: "Телефон", value: phone, valueSetter: phoneSetter, error: phoneHasError, small: false,
                                  errorSetter: phoneErrorSetter, errorMessage: phoneErrorMessage,
                                  inputType: TextInputType.phone,
                                ),
                                SizedBox(height: 10,),
                                EditableTextFieldWidget(
                                    label: "Email", value: email, valueSetter: emailSetter, error: emailHasError, small: false,
                                    errorSetter: emailErrorSetter, errorMessage: emailErrorMessage,
                                    inputType: TextInputType.emailAddress
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.35 -10,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                                value: isMaleChecked,
                                                fillColor: MaterialStateProperty.all<Color>(const Color(0xFFB0B0B0)),
                                                side: BorderSide.none,
                                                splashRadius: 20.0,
                                                onChanged: onCheckboxMaleChecked
                                            ),
                                          ),
                                          Text("Мужчина",
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.35 -10,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                              value: isFemaleChecked,
                                              fillColor: MaterialStateProperty.all<Color>(const Color(0xFFB0B0B0)),
                                              side: BorderSide.none,
                                              onChanged: onCheckboxFemaleChecked,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                          Text("Женщина",
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                          height: firstnameHasError ? 70 : 50,
                          width: MediaQuery.of(context).size.width - 20,
                          child: EditableTextFieldWidget(
                            label: "Имя", value: firstname, valueSetter: firstnameSetter, error: firstnameHasError,
                            errorSetter: firstnameErrorSetter, validator: validateFirstnameField, errorMessage: firstnameErrorMessage,
                          )
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                          height: lastnameHasError ? 70 : 50,
                          width: MediaQuery.of(context).size.width - 20,
                          child: EditableTextFieldWidget(
                            label: "Фамилия", value: lastname, valueSetter: lastnameSetter, error: lastnameHasError,
                            errorSetter: lastnameErrorSetter, validator: validateLastnameField, errorMessage: lastnameErrorMessage,
                          )
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                          height: middlenameHasError ? 70 : 50,
                          width: MediaQuery.of(context).size.width - 20,
                          child: EditableTextFieldWidget(
                            label: "Отчество", value: middlename, valueSetter: middlenameSetter, error: middlenameHasError,
                            errorSetter: middlenameErrorSetter, validator: validateMiddlenameField, errorMessage: middlenameErrorMessage,
                          )
                      ),
                      SizedBox(height: 10,),
                      EditableDateTextFieldWidget(
                        label: "Дата рождения",
                        valueDay: birthdateDay, valueDaySetter: birthdateDaySetter,
                        valueMonth: birthdateMonth, valueMonthSetter: birthdateMonthSetter,
                        valueYear: birthdateYear, valueYearSetter: birthdateYearSetter,
                        errorSetter: birthdateErrorSetter,
                        // errorMessage: birthdateErrorMessage,
                      ),
                      SizedBox(height: 10,),
                      if (isPersonDocumentsInited)
                        ...editableDocuments
                      else SizedBox(height: 68,),
                      Material(
                        child: Ink(
                          width: MediaQuery.of(context).size.width - 20,
                          decoration: const BoxDecoration(
                              color: Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              )
                          ),
                          child: InkWell(
                              splashColor: AppColors.cardColor5,
                              onTap: () {
                                editableDocuments.add(_addEditableDocument());
                                setState(() {});
                              },
                              child: Icon(Icons.add)
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                          height: citizenshipHasError ? 70 : 50,
                          width: MediaQuery.of(context).size.width - 20,
                          child: EditableTextFieldWidget(
                              label: "Гражданство", value: citizenship, valueSetter: citizenshipSetter, error: citizenshipHasError,
                              errorMessage: citizenshipErrorMessage
                          )
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownMenu(
                          menuStyle: MenuStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.cardColor5),
                            elevation: MaterialStateProperty.resolveWith((states) => 40),
                            shadowColor: MaterialStateColor.resolveWith((states) => AppColors.backgroundMain2),
                            surfaceTintColor: MaterialStateColor.resolveWith((states) => AppColors.cardColor1),
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                              fillColor: const Color(0xFFEFEFEF),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(color: AppColors.transparent, width: 1)
                              ),
                              constraints: BoxConstraints(
                                  maxHeight: 50,
                                  minHeight: 50
                              )
                          ),
                          textStyle: TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          width: MediaQuery.of(context).size.width - 20,
                          controller: personClassDropdownController,
                          label: Text("Класс пассажира", style: TextStyle(fontSize: 22, color: Color(0xFF000000))),
                          initialSelection: personClassList.first,
                          dropdownMenuEntries: personClassList,
                          onSelected: (Object? value) {  },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _childrenBlock(),
                      const SizedBox(height: 10),
                      EditableCommentFieldWidget(
                          value: comment,
                          valueSetter: commentSetter
                      ),
                      const SizedBox(height: 20,),
                      hasPersonChanges
                          ? SaveButton(onTap: _onUpdate, label: "Обновить")
                          : SizedBox.shrink(),
                      const SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
              isMenuOpen ? GestureDetector(
                onTap: _openAddingChildMenuOptions,
                child: Container(
                  color: Colors.black54,
                ),
              ) : const SizedBox.shrink(),
              AnimatedPositioned(
                bottom: isMenuOpen ? 0 : -200,
                left: 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)
                    ),
                    color: Colors.white
                  ),
                  child: Material(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Ink(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.grey.shade200
                          ),
                          child: InkWell(
                            onTap: () {
                              _openAddChildFromSearchPage();
                            },
                            splashColor: Colors.grey.shade100,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text("Выбрать из списка людей", style: TextStyle(fontSize: 16))),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Ink(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              color: Colors.grey.shade200
                          ),
                          child: InkWell(
                            onTap: () {
                              _openAddChildWithNewPerson();
                            },
                            splashColor: Colors.grey.shade100,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text("Добавить нового человека", style: TextStyle(fontSize: 16))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        )
      ),
    );
  }

  Widget _childrenBlock() {
    late Widget _widget;
    if ( !isChildrenLoaded) {
      _widget = Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 5),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Color(0xFFEFEFEF)
        ),
        child: const CircularProgressIndicator(),
      );
    } else {
      if (children == null) {
        _widget = Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 5),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Color(0xFFEFEFEF)
          ),
          child: const Text("Нет детей"),
        );
      } else {
        _widget = Container(
          height: children!.length * 56,
          child: Column(
            children: [
              ...children!.map((child) => PersonsChildrenWidget(
                child: child, parent: widget.person,
                deleteChildFromParent: deleteChildFromParent,)).toList()
            ],
          ),
        );
      }
    }
    return Container(
      child: Column(
        children: [
          const Text("Дети", style: TextStyle(fontSize: 24)),
          _widget,
          GestureDetector(
            onTap: _openAddingChildMenuOptions,
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xFFEFEFEF)
              ),
              child: Text('Добавить ребенка'),
            ),
          )
        ],
      ),
    );
  }
  Future<void> _openAddingChildMenuOptions() async {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }
  void _openAddChildFromSearchPage() {
    context.goNamed(
      NavigationRoutes.searchPersonScreen.name,
      extra: SearchPersonScreenArguments(callback: setPersonChildToParent)
    );
  }
  void _openAddChildWithNewPerson() {
    context.goNamed(
        NavigationRoutes.addPersonScreen.name,
        extra: AddNewPersonScreenArguments(parentId: widget.person.id, routeName: '')
    );
  }
  void firstnameSetter(String value) {
    setState(() {
      firstname = value;
    });
    checkIfPersonHasChanges();
  }
  void emailSetter(String value) {
    setState(() {
      email = value;
    });
    checkIfPersonHasChanges();
  }
  void birthdateDaySetter(String value) {
    setState(() {
      birthdateDay = value;
    });
    checkIfPersonHasChanges();
  }
  void birthdateMonthSetter(String value) {
    setState(() {
      birthdateMonth = value;
    });
    checkIfPersonHasChanges();
  }
  void birthdateYearSetter(String value) {
    setState(() {
      birthdateYear = value;
    });
    checkIfPersonHasChanges();
  }
  void phoneSetter(String value) {
    setState(() {
      phone = value;
    });
    checkIfPersonHasChanges();
  }
  void lastnameSetter(String value) {
    setState(() {
      lastname = value;
    });
    checkIfPersonHasChanges();
  }
  void middlenameSetter(String value) {
    setState(() {
      middlename = value;
    });
    checkIfPersonHasChanges();
  }
  void documentSetter(String value) {
    setState(() {
      documentNumber = value;
    });
    checkIfPersonHasChanges();
  }
  void citizenshipSetter(String value) {
    setState(() {
      citizenship = value;
    });
    checkIfPersonHasChanges();
  }
  void commentSetter(String value) {
    setState(() {
      comment = value;
    });
    checkIfPersonHasChanges();
  }

}

class EditPersonScreenArguments {
  final Person person;

  const EditPersonScreenArguments({
    required this.person
  });
}
