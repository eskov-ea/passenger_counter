import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/pages/adding_person_options.dart';
import 'package:pleyona_app/ui/screens/success_info_screen.dart';
import 'package:pleyona_app/ui/widgets/added_document_icon_widget.dart';
import 'package:pleyona_app/ui/widgets/editable_text_field_widget.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/scan_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../models/person_model.dart';
import '../../services/database/db_provider.dart';

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
    document = widget.person.document;
    email = widget.person.email;
    birthdate = widget.person.birthdate;
    phone = widget.person.phone;
    citizenship = widget.person.citizenship;
    final List<String> birth = widget.person.birthdate.split('-');
    final String doc = widget.person.document.split(',').last;
    // lastname = widget.person.lastname;
    // middlename = widget.person.middlename;
    // _dayBirthFieldController.text = birth[2];
    // _monthBirthFieldController.text = birth[1];
    // _yearBirthFieldController.text = birth[2];
    // _documentNameFieldController.text = doc.split('/').first;
    // _documentNumberFieldController.text = doc.split('/').last;
    // _phoneFieldController.text = widget.person.phone;
    // _emailFieldController.text = widget.person.email;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late String firstname;
  late String lastname;
  late String middlename;
  late String document;
  late String email;
  late String birthdate;
  late String phone;
  late String citizenship;

  void firstnameSetter(String value) {
    setState(() {
      firstname = value;
    });
  }
  void emailSetter(String value) {
    setState(() {
      email = value;
    });
  }
  void birthdateSetter(String value) {
    setState(() {
      birthdate = value;
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
  }
  void middlenameSetter(String value) {
    setState(() {
      middlename = value;
    });
  }
  void documentSetter(String value) {
    setState(() {
      document = value;
    });
  }
  void citizenshipSetter(String value) {
    setState(() {
      citizenship = value;
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

  void validateFirstnameField() {
    if (firstname.trim().isEmpty) {
      setState(() {
        firstnameHasError = true;
        firstnameErrorMessage = "Поле не может быть пустым";
      });
    } else {
      setState(() {
        firstnameHasError = false;
        firstnameErrorMessage = null;
      });
    }
  }
  void validateEmailField() {
    setState(() {
      emailHasError = false;
      emailErrorMessage = null;
    });
  }
  void validateBirthdateField() {
    setState(() {
      birthdateHasError = false;
      birthdateErrorMessage = null;
    });
  }
  void validatePhoneField() {
    setState(() {
      phoneHasError = false;
      phoneErrorMessage = null;
    });
  }
  void validateLastnameField() {
    setState(() {
      lastnameHasError = false;
      lastnameErrorMessage = null;
    });
  }
  void validateMiddlenameField() {
    setState(() {
      middlenameHasError = false;
      middlenameErrorMessage = null;
    });
  }
  void validateDocumentField() {
    setState(() {
      documentHasError = false;
      documentErrorMessage = null;
    });
  }
  void validateCitizenshipField() {
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
                  SizedBox(height: 100,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: widget.person.phone != ""
                          ? SizedBox.shrink()
                          : Image.asset("assets/images/no_avatar.png"),
                      ),
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.7 - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EditableTextFieldWidget(
                              label: "Телефон", value: phone, valueSetter: phoneSetter, error: phoneHasError, small: true,
                              errorSetter: phoneErrorSetter, validator: validatePhoneField, errorMessage: phoneErrorMessage,
                              inputType: TextInputType.phone,
                            ),
                            SizedBox(height: 10,),
                            EditableTextFieldWidget(
                              label: "Email", value: email, valueSetter: emailSetter, error: emailHasError, small: true,
                              errorSetter: emailErrorSetter, validator: validateEmailField, errorMessage: emailErrorMessage,
                                inputType: TextInputType.emailAddress
                            )
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
                  EditableTextFieldWidget(
                    label: "Дата рождения", value: birthdate, valueSetter: birthdateSetter, error: birthdateHasError,
                    errorSetter: birthdateErrorSetter, validator: validateBirthdateField, errorMessage: birthdateErrorMessage,
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                      height: documentHasError ? 70 : 50,
                      width: MediaQuery.of(context).size.width - 20,
                      child: EditableTextFieldWidget(
                        label: "Документы", value: document, valueSetter: documentSetter, error: documentHasError,
                        errorSetter: documentErrorSetter, validator: validateDocumentField, errorMessage: documentErrorMessage,
                      )
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                      height: citizenshipHasError ? 70 : 50,
                      width: MediaQuery.of(context).size.width - 20,
                      child: EditableTextFieldWidget(
                        label: "Гражданство", value: citizenship, valueSetter: citizenshipSetter, error: citizenshipHasError,
                        errorSetter: citizenshipErrorSetter, validator: validateCitizenshipField, errorMessage: citizenshipErrorMessage,
                      )
                  ),
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
