import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pleyona_app/globals.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/person_add_new_screen.dart';
import 'package:pleyona_app/ui/widgets/editable_text_fields/editable_text_field_widget.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import '../../models/person_model.dart';
import '../../services/database/db_provider.dart';
import '../widgets/editable_text_fields/editable_birthdate_field_widget.dart';
import '../widgets/editable_text_fields/editable_comment_text_field.dart';
import '../widgets/editable_text_fields/editable_document_field_widget.dart';

class EditPersonInfoScreen extends StatefulWidget {

  final Person person;
  const EditPersonInfoScreen({
    required this.person,
    super.key
  });

  @override
  State<EditPersonInfoScreen> createState() => _EditPersonInfoScreenState();
}

class _EditPersonInfoScreenState extends State<EditPersonInfoScreen> {

  final DBProvider _db = DBProvider.db;

  bool isLastnameFieldHasError = false;
  bool isFirstnameFieldHasError = false;
  bool isMiddlenameFieldHasError = false;
  bool isDayBirthFieldHasError = false;
  bool isMonthBirthFieldHasError = false;
  bool isYearBirthFieldHasError = false;
  bool isDateInputHasError = false;
  bool isDocumentNumberFieldHasError = false;
  bool isDocumentNameFieldHasError = false;
  bool isDocumentNumberFieldsHasError = false;
  bool isPhoneFieldsHasError = false;
  bool isEmailFieldsHasError = false;
  final TextEditingController personClassDropdownController = TextEditingController();
  late final List<DropdownMenuEntry<String>> personClassList;
  final FocusNode commentFieldFocus = FocusNode();
  final TextEditingController commentTextController = TextEditingController();

  String? documentInputFieldsErrorMessage;
  bool isEditingMode = false;



  String? _validateLastnameField(String? lastname) {
    if (lastname == null || lastname.trim().isEmpty) {
      setState(() {
        isLastnameFieldHasError = true;
      });
      return "Поле не может быть пустым";
    } else {
      setState(() {
        isLastnameFieldHasError = false;
      });
      return null;
    }
  }


  // String? _validateMiddlenameField(String? value) {
  //   print("_validateMiddlenameField");
  //   if (value == null || value.trim().isEmpty) {
  //     setState(() {
  //       isMiddlenameFieldHasError = true;
  //     });
  //     return "Поле не может быть пустым";
  //   } else {
  //     setState(() {
  //       isMiddlenameFieldHasError = false;
  //     });
  //     return null;
  //   }
  // }
  //
  // void _validateDayBirthField(String? value) {
  //   if (value == null || value.trim().isEmpty || int.parse(value) > 31) {
  //     setState(() {
  //       isDayBirthFieldHasError = true;
  //     });
  //   } else {
  //     setState(() {
  //       isDayBirthFieldHasError = false;
  //     });
  //   }
  // }
  //
  // void _validateMonthBirthField(String? value) {
  //   if (value == null || value.trim().isEmpty || int.parse(value) > 12) {
  //     setState(() {
  //       isMonthBirthFieldHasError = true;
  //     });
  //   } else {
  //     setState(() {
  //       isMonthBirthFieldHasError = false;
  //     });
  //   }
  // }
  //
  // void _validateYearBirthField(String? value) {
  //   if (value == null || value.trim().isEmpty || int.parse(value) > DateTime.now().year || int.parse(value) < 1920) {
  //     setState(() {
  //       isYearBirthFieldHasError = true;
  //     });
  //   } else {
  //     setState(() {
  //       isYearBirthFieldHasError = false;
  //     });
  //   }
  // }
  //
  // void _validateDateBirthInput() {
  //   _validateDayBirthField(_dayBirthFieldController.text);
  //   _validateMonthBirthField(_monthBirthFieldController.text);
  //   _validateYearBirthField(_yearBirthFieldController.text);
  //   if (isDayBirthFieldHasError || isMonthBirthFieldHasError || isYearBirthFieldHasError) {
  //     setState(() {
  //       isDateInputHasError = true;
  //     });
  //   } else {
  //     isDateInputHasError = false;
  //   }
  // }
  //
  // void _validatePassportFields() {
  //   if (_documentNameFieldController.text.isEmpty || _documentNumberFieldController.text.isEmpty) {
  //     setState(() {
  //       isDocumentNumberFieldHasError = _documentNameFieldController.text.isEmpty ? true : false;
  //       isDocumentNameFieldHasError = _documentNumberFieldController.text.isEmpty ? true : false;
  //       documentInputFieldsErrorMessage = "Название документа и его номер должны быть заполнены";
  //     });
  //   } else {
  //     setState(() {
  //       isDocumentNumberFieldHasError = false;
  //       isDocumentNameFieldHasError = false;
  //       documentInputFieldsErrorMessage = null;
  //     });
  //   }
  // }

  void _onSave() async {
    // _validateDateBirthInput();
    // _validatePassportFields();
    if(!isLastnameFieldHasError && !isFirstnameFieldHasError && !isMiddlenameFieldHasError &&
        !isDayBirthFieldHasError && !isDateInputHasError && !isMonthBirthFieldHasError
      && !isDocumentNameFieldHasError && !isDocumentNumberFieldsHasError && !isYearBirthFieldHasError) {

    }
  }

  void onCheckboxMaleChecked(bool? value) {
    if (value == null) {
      validateGenderInput();
      return;
    }
    setState(() {
      isMaleChecked = false;
      isFemaleChecked = false;

      isMaleChecked = value;
    });
    validateGenderInput();
  }
  void onCheckboxFemaleChecked(bool? value) {
    if (value == null) {
      validateGenderInput();
      return;
    }
    setState(() {
      isMaleChecked = false;
      isFemaleChecked = false;

      isFemaleChecked = value;
    });
    validateGenderInput();
  }
  void validateGenderInput() {
    if (!isMaleChecked && !isFemaleChecked) {
      setState(() {
        isGenderFieldHasError = true;
      });
    } else {
      setState(() {
        isGenderFieldHasError = false;
      });
    }
  }



  void _openAddingDocOptionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12)
            ),
            color: AppColors.textMain
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text("Добавьте страницы паспорта пассажира с основной информацией и пропиской",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.textFaded),
                  ),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: (){},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain4),
                    overlayColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain5),
                    shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))
                    )),
                  ),
                  child: Text("Открыть камеру",
                    style: TextStyle(fontSize: 24, color: AppColors.textMain),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: ElevatedButton(
                  onPressed: (){},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain4),
                    overlayColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain5),
                    shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    )),
                  ),
                  child: Text("Выбрать из галереи",
                    style: TextStyle(fontSize: 24, color: AppColors.textMain),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
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

  
  @override
  void initState() {
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
    final List<String> birth = widget.person.birthdate.split('-');
    int i =0;
    DBProvider.db.getPersonDocuments(personId: widget.person.id).then((documents) {
      EditableDocuments = documents.map((doc) {
        ++i;
        String documentNumber = doc.description;
        String documentName = doc.name;
        void setDocName(String value) {
          setState(() {
            documentName = value;
          });
        }
        void setDocNumber(String value) {
          setState(() {
            documentNumber = value;
          });
        }
        bool isDocHasError = true;
        return SizedBox(
            height: 68,
            width: MediaQuery.of(context).size.width - 20,
            child: EditableDocumentTextFieldWidget(
              label: "Документ $i", valueName: documentName, valueNumber: documentNumber,
              valueNameSetter: setDocName, valueNumberSetter: setDocNumber,
            )
        );
      }).toList();
      setState(() {
        isPersonDocumentsInited = true;
      });
    });
    personClassList = PersonClass.values.map((value) => DropdownMenuEntry<String>(value: value.name, label: value.name.toUpperCase())).toList();

    super.initState();
  }

  void checkIfPersonHasChanges() {
    if(
      firstname != widget.person.firstname ||
      lastname != widget.person.lastname ||
      middlename != widget.person.middlename
    ) {
      setState(() {
        hasPersonChanges = true;
      });
    } else {
      setState(() {
        hasPersonChanges = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

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
  late final List<PersonDocument> personDocuments;
  bool isPersonDocumentsInited = false;
  late final List<Widget> EditableDocuments;
  bool isFemaleChecked = false;
  bool isMaleChecked = true;
  bool hasPersonChanges = false;

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
  }
  void birthdateDaySetter(String value) {
    setState(() {
      birthdateDay = value;
    });
  }
  void birthdateMonthSetter(String value) {
    setState(() {
      birthdateMonth = value;
    });
  }
  void birthdateYearSetter(String value) {
    setState(() {
      birthdateYear = value;
    });
  }
  void phoneSetter(String value) {
    setState(() {
      phone = value;
    });
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
  }
  void citizenshipSetter(String value) {
    setState(() {
      citizenship = value;
    });
  }
  void commentSetter(String value) {
    setState(() {
      comment = value;
    });
  }

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
  String? birthdateErrorMessage;
  String? phoneErrorMessage;
  String? documentErrorMessage;
  String? citizenshipErrorMessage;

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
      documentHasError = value;
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

  bool validateBirthdateField() {
    return true;
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
      documentErrorMessage = null;
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
          backgroundColor: AppColors.textMain,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.3 - 10,
                        child: widget.person.photo != ""
                          ? Image.memory(base64Decode(widget.person.photo),
                          fit: BoxFit.cover
                        )
                          : Image.asset("assets/images/no_avatar.png"),
                      ),
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.7 - 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EditableTextFieldWidget(
                              label: "Телефон", value: phone, valueSetter: phoneSetter, error: phoneHasError, small: true,
                              errorSetter: phoneErrorSetter, errorMessage: phoneErrorMessage,
                              inputType: TextInputType.phone,
                            ),
                            SizedBox(height: 10,),
                            EditableTextFieldWidget(
                              label: "Email", value: email, valueSetter: emailSetter, error: emailHasError, small: true,
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
                                            fillColor: isMaleChecked ? MaterialStateProperty.all<Color>(AppColors.backgroundMain5) : MaterialStateProperty.all<Color>(const Color(0xFFEFEFEF)),
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
                                          fillColor: isFemaleChecked ? MaterialStateProperty.all<Color>(AppColors.suiteNotAvailableStatus) : MaterialStateProperty.all<Color>(const Color(0xFFEFEFEF)),
                                          checkColor: AppColors.errorMain,
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
                    // errorSetter: birthdateErrorSetter,
                    // validator: validateBirthdateField,
                    // errorMessage: birthdateErrorMessage,
                  ),
                  SizedBox(height: 10,),
                  if (isPersonDocumentsInited)
                    ...EditableDocuments
                  else SizedBox(height: 68,),
                  SizedBox(height: 10,),
                  SizedBox(
                      height: citizenshipHasError ? 70 : 50,
                      width: MediaQuery.of(context).size.width - 20,
                      child: EditableTextFieldWidget(
                        label: "Гражданство", value: citizenship, valueSetter: citizenshipSetter, error: citizenshipHasError,
                        errorSetter: citizenshipErrorSetter, errorMessage: citizenshipErrorMessage,
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
                      initialSelection: personClassList.first.value,
                      dropdownMenuEntries: personClassList,
                      onSelected: (String? value) {  },
                    ),
                  ),
                  const SizedBox(height: 10),
                  EditableCommentFieldWidget(
                    value: comment,
                    valueSetter: commentSetter
                  ),
                  const SizedBox(height: 20,),
                  hasPersonChanges
                    ? SaveButton(onTap: () {}, label: "Обновить")
                    : SizedBox.shrink(),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class EditPersonScreenArguments {
  final Person person;

  const EditPersonScreenArguments({
    required this.person
  });
}
