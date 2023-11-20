import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/pages/adding_person_options.dart';
import 'package:pleyona_app/ui/screens/success_info_screen.dart';
import 'package:pleyona_app/ui/widgets/added_document_icon_widget.dart';
import 'package:pleyona_app/ui/widgets/person/adding_person_additional_info_block.dart';
import 'package:pleyona_app/ui/widgets/person/adding_person_contact_info_block.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/scan_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../models/person_model.dart';
import '../../services/database/db_provider.dart';
import '../widgets/person/adding_person_document_info_block.dart';
import '../widgets/person/adding_person_general_info_block.dart';
import '../widgets/person/adding_person_photo_scan_btns.dart';


enum PersonClass { regular, staff, vip }

class PersonAddNewScreen extends StatefulWidget {
  const PersonAddNewScreen({super.key});

  @override
  State<PersonAddNewScreen> createState() => _PersonAddNewScreenState();
}

class _PersonAddNewScreenState extends State<PersonAddNewScreen> {

  final DBProvider _db = DBProvider.db;

  final lastnameFieldKey = GlobalKey<FormFieldState>();
  final firstnameFieldKey = GlobalKey<FormFieldState>();
  final middlenameFieldKey = GlobalKey<FormFieldState>();
  final documentNameFieldKey = GlobalKey<FormFieldState>();
  final documentNumberFieldKey = GlobalKey<FormFieldState>();
  final _phoneFieldKey = GlobalKey<FormFieldState>();

  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController dayBirthFieldController = TextEditingController();
  final TextEditingController monthBirthFieldController = TextEditingController();
  final TextEditingController yearBirthFieldController = TextEditingController();
  final TextEditingController documentNameFieldController = TextEditingController();
  final TextEditingController documentNumberFieldController = TextEditingController();
  final TextEditingController citizenshipFieldController = TextEditingController();
  final TextEditingController phoneFieldController = TextEditingController();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController personClassDropdownController = TextEditingController();
  final TextEditingController commentTextController = TextEditingController();
  final FocusNode lastnameFocus = FocusNode();
  final FocusNode firstnameFocus = FocusNode();
  final FocusNode middlenameFocus = FocusNode();
  final FocusNode dayBirthFieldFocus = FocusNode();
  final FocusNode monthBirthFieldFocus = FocusNode();
  final FocusNode yearBirthFieldFocus = FocusNode();
  final FocusNode documentNameFieldFocus = FocusNode();
  final FocusNode documentNumberFieldFocus = FocusNode();
  final FocusNode citizenshipFieldFocus = FocusNode();
  final FocusNode phoneFieldFocus = FocusNode();
  final FocusNode emailFieldFocus = FocusNode();
  final FocusNode genderCheckboxFieldFocus = FocusNode();
  final FocusNode commentFieldFocus = FocusNode();
  final Color focusedBorderColor = AppColors.backgroundMain4;

  bool isLastnameFieldHasError = false;
  bool isFirstnameFieldHasError = false;
  bool isMiddlenameFieldHasError = false;
  bool isDayBirthFieldHasError = false;
  bool isMonthBirthFieldHasError = false;
  bool isYearBirthFieldHasError = false;
  bool isDateInputHasError = false;
  bool isGenderFieldHasError = false;
  bool isDocumentNumberFieldHasError = false;
  bool isDocumentNameFieldHasError = false;
  bool isDocumentNumberFieldsHasError = false;
  bool isPhoneFieldsHasError = false;
  bool isEmailFieldsHasError = false;

  bool isMaleChecked = false;
  bool isFemaleChecked = false;

  String? documentInputFieldsErrorMessage;

  late final List<DropdownMenuEntry<String>> personClassList;


  ValueNotifier<Barcode?> qrResult = ValueNotifier<Barcode?>(null);
  final List<BarcodeFormat> allowedScanFormat = [BarcodeFormat.qrcode];

  void setQRResult(Barcode value) {
      qrResult.value = value;
  }


  String? validateLastnameField(String? lastname) {
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

  String? validateFirstnameField(String? firstname) {
    if (firstname == null || firstname.trim().isEmpty) {
      setState(() {
        isFirstnameFieldHasError = true;
      });
      return "Поле не может быть пустым";
    } else {
      setState(() {
        isFirstnameFieldHasError = false;
      });
      return null;
    }
  }

  String? validateMiddlenameField(String? value) {
    print("_validateMiddlenameField");
    if (value == null || value.trim().isEmpty) {
      setState(() {
        isMiddlenameFieldHasError = true;
      });
      return "Поле не может быть пустым";
    } else {
      setState(() {
        isMiddlenameFieldHasError = false;
      });
      return null;
    }
  }

  void validateDayBirthField(String? value) {
    if (value == null || value.trim().isEmpty || int.parse(value) > 31) {
      setState(() {
        isDayBirthFieldHasError = true;
      });
    } else {
      setState(() {
        isDayBirthFieldHasError = false;
      });
    }
  }

  void validateMonthBirthField(String? value) {
    if (value == null || value.trim().isEmpty || int.parse(value) > 12) {
      setState(() {
        isMonthBirthFieldHasError = true;
      });
    } else {
      setState(() {
        isMonthBirthFieldHasError = false;
      });
    }
  }

  void validateYearBirthField(String? value) {
    if (value == null || value.trim().isEmpty || int.parse(value) > DateTime.now().year || int.parse(value) < 1920) {
      setState(() {
        isYearBirthFieldHasError = true;
      });
    } else {
      setState(() {
        isYearBirthFieldHasError = false;
      });
    }
  }

  void validateDateBirthInput() {
    validateDayBirthField(dayBirthFieldController.text);
    validateMonthBirthField(monthBirthFieldController.text);
    validateYearBirthField(yearBirthFieldController.text);
    if (isDayBirthFieldHasError || isMonthBirthFieldHasError || isYearBirthFieldHasError) {
      setState(() {
        isDateInputHasError = true;
      });
    } else {
      isDateInputHasError = false;
    }
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

  void validateDocumentNameField() {
    setState(() {
      isDocumentNameFieldHasError = documentNameFieldController.text.trim() == "" ? true : false;
    });
  }

  void validateDocumentFields() {
    if (documentNameFieldController.text.isEmpty || documentNumberFieldController.text.isEmpty) {
      setState(() {
        isDocumentNumberFieldHasError = documentNameFieldController.text.isEmpty ? true : false;
        isDocumentNameFieldHasError = documentNumberFieldController.text.isEmpty ? true : false;
        documentInputFieldsErrorMessage = "Название документа и его номер должны быть заполнены";
      });
    } else {
      setState(() {
        isDocumentNumberFieldHasError = false;
        isDocumentNameFieldHasError = false;
        documentInputFieldsErrorMessage = null;
      });
    }
  }

  void setFieldErrorValue(String fieldName, bool value) {
    switch (fieldName) {
      case "lastname":
        setState(() {
          isLastnameFieldHasError = value;
        });
        break;
      case "firstname":
        setState(() {
          isFirstnameFieldHasError = value;
        });
        break;
      case "middlename":
        setState(() {
          isMiddlenameFieldHasError = value;
        });
        break;
      case "day":
        setState(() {
          isDayBirthFieldHasError = value;
        });
        break;
      case "month":
        setState(() {
          isMonthBirthFieldHasError = value;
        });
        break;
      case "year":
        setState(() {
          isYearBirthFieldHasError = value;
        });
        break;
      default:
        break;
    }
    setState(() {
      isLastnameFieldHasError = value;
    });
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
    if (value)  onNextFieldFocus(context, genderCheckboxFieldFocus, documentNameFieldFocus);
  }

  void onCheckboxFemaleChecked(bool? value) {
    if (value == null) {
      validateGenderInput();
      return;
    }
    setState(() {
      isMaleChecked = false;
      isFemaleChecked = false;
      isGenderFieldHasError = false;

      isFemaleChecked = value;
    });
    if (value)  onNextFieldFocus(context, genderCheckboxFieldFocus, documentNameFieldFocus);
  }

  void _onSave() async {
    validateDateBirthInput();
    validateDocumentFields();
    validateGenderInput();
    firstnameFieldKey.currentState?.validate();
    lastnameFieldKey.currentState?.validate();
    middlenameFieldKey.currentState?.validate();
    if(!isLastnameFieldHasError && !isFirstnameFieldHasError && !isMiddlenameFieldHasError &&
        !isDayBirthFieldHasError && !isDateInputHasError && !isMonthBirthFieldHasError
      && !isDocumentNameFieldHasError && !isDocumentNumberFieldsHasError && !isYearBirthFieldHasError) {
      final newPerson = Person(
        id: "",
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        middlename: middlenameController.text,
        gender: isMaleChecked ? "МУЖ" : "ЖЕН" ,
        birthdate: "${yearBirthFieldController.text}-${monthBirthFieldController.text}-${dayBirthFieldController.text}",
        phone: phoneFieldController.text,
        email: emailFieldController.text,
        document: "${documentNameFieldController.text}/${documentNumberFieldController.text}",
        citizenship: citizenshipFieldController.text,
        personClass: "Regular",
        comment: null,
        createdAt: dateFormatter(DateTime.now()),
        updatedAt: dateFormatter(DateTime.now())
      );
      final persons = await _db.findPerson(lastname: newPerson.lastname);
      if (persons.isEmpty) {
        await _db.addPerson(newPerson);
        // TODO: handle error
        Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.successInfoScreen,
          arguments: InfoScreenArguments(message: "Контакт успешно сохранен в Базу Данных!", routeName: MainNavigationRouteNames.homeScreen,
          person: newPerson)
        );
      } else {
        Navigator.of(context).pushNamed(MainNavigationRouteNames.personOptionsScreen,
          arguments: AddingPersonOptionsArguments(newPerson: newPerson, persons: persons)
        );
      }
    }
  }

  Widget blockTitle(String message) => Container(
    width: MediaQuery.of(context).size.width ,
    padding: const EdgeInsets.only(bottom: 15),
    child: Text(message,
      textAlign: TextAlign.start,
      style: const TextStyle(fontSize: 24, color: Color(0xFF000000), fontWeight: FontWeight.w500),
    ),
  );


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


  void onNextFieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool _checkForUnsavedChanges() {
    if (
    lastnameController.text.isNotEmpty ||
    firstnameController.text.isNotEmpty ||
    middlenameController.text.isNotEmpty ||
    dayBirthFieldController.text.isNotEmpty ||
    monthBirthFieldController.text.isNotEmpty ||
    yearBirthFieldController.text.isNotEmpty ||
    documentNameFieldController.text.isNotEmpty ||
    documentNumberFieldController.text.isNotEmpty ||
    citizenshipFieldController.text.isNotEmpty
    ) {
      return true;
    } else {
      return false;
    }
  }

  
  @override
  void initState() {
    lastnameFocus.addListener(() {
      if(!lastnameFocus.hasFocus) {
        lastnameFieldKey.currentState?.validate();
      }
    });
    firstnameFocus.addListener(() {
      if(!firstnameFocus.hasFocus) {
        firstnameFieldKey.currentState?.validate();
      }
    });
    middlenameFocus.addListener(() {
      if(!middlenameFocus.hasFocus) {
        middlenameFieldKey.currentState?.validate();
      }
    });
    dayBirthFieldFocus.addListener(() {
      if(!dayBirthFieldFocus.hasFocus) {
        setState(() {
          isDayBirthFieldHasError = dayBirthFieldController.text.trim() == "" ? true : false;
        });
      }
    });
    monthBirthFieldFocus.addListener(() {
      if(!monthBirthFieldFocus.hasFocus) {
        setState(() {
          isMonthBirthFieldHasError = monthBirthFieldController.text.trim() == "" ? true : false;
        });
      }
    });
    yearBirthFieldFocus.addListener(() {
      if(!yearBirthFieldFocus.hasFocus) {
        validateDateBirthInput();
      }
    });
    documentNameFieldFocus.addListener(() {
      if(!documentNameFieldFocus.hasFocus) {
        validateDocumentNameField();
      }
    });
    documentNumberFieldFocus.addListener(() {
      if(!documentNumberFieldFocus.hasFocus) {
        validateDocumentFields();
      }
    });
    qrResult.addListener(() {
      if (qrResult.value?.code != null) {
        final qr = qrResult.value!.code!;
        final person = Person.fromQRCode(json.decode(qr));
        _fillInputsWithQRCodeData(person);
      }
    });
    personClassList = PersonClass.values.map((value) => DropdownMenuEntry<String>(value: value.name, label: value.name.toUpperCase())).toList();
    super.initState();
  }

  void _fillInputsWithQRCodeData(Person p) {
    final doc = p.document.split(" ");
    final bDate = p.birthdate.split("-");

    firstnameController.text = p.firstname;
    lastnameController.text = p.lastname;
    middlenameController.text = p.middlename;
    yearBirthFieldController.text = bDate[0];
    monthBirthFieldController.text = bDate[1];
    dayBirthFieldController.text = bDate[2];
    documentNameFieldController.text = doc[0];
    documentNumberFieldController.text = doc[1];
    citizenshipFieldController.text = p.citizenship;
    phoneFieldController.text = p.phone;
    emailFieldController.text = p.email;

    validateDateBirthInput();
    validateDocumentFields();
    firstnameFieldKey.currentState?.validate();
    lastnameFieldKey.currentState?.validate();
    middlenameFieldKey.currentState?.validate();
  }

  @override
  void dispose() {
    lastnameController.dispose();
    lastnameFocus.dispose();
    firstnameController.dispose();
    firstnameFocus.dispose();
    middlenameController.dispose();
    middlenameFocus.dispose();
    dayBirthFieldController.dispose();
    dayBirthFieldFocus.dispose();
    monthBirthFieldController.dispose();
    monthBirthFieldFocus.dispose();
    yearBirthFieldController.dispose();
    yearBirthFieldFocus.dispose();
    documentNameFieldController.dispose();
    documentNameFieldFocus.dispose();
    documentNumberFieldController.dispose();
    documentNumberFieldFocus.dispose();
    citizenshipFieldController.dispose();
    citizenshipFieldFocus.dispose();
    super.dispose();
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
          backgroundColor: AppColors.backgroundNeutral,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  PersonAddingPhotoScanOptionsWidget(onQRScanResultCallback: setQRResult, allowedFormat: allowedScanFormat),
                  const SizedBox(height: 5,),
                  blockTitle("Основная информация"),
                  PersonGeneralInfoBlock(
                    lastnameFieldKey: lastnameFieldKey,
                    firstnameFieldKey: firstnameFieldKey,
                    middlenameFieldKey: middlenameFieldKey,
                    lastnameController: lastnameController,
                    firstnameController: firstnameController,
                    middlenameController: middlenameController,
                    dayBirthFieldController: dayBirthFieldController,
                    monthBirthFieldController: monthBirthFieldController,
                    yearBirthFieldController: yearBirthFieldController,
                    personClassDropdownController: personClassDropdownController,
                    lastnameFocus: lastnameFocus,
                    firstnameFocus: firstnameFocus,
                    middlenameFocus: middlenameFocus,
                    dayBirthFieldFocus: dayBirthFieldFocus,
                    monthBirthFieldFocus: monthBirthFieldFocus,
                    yearBirthFieldFocus: yearBirthFieldFocus,
                    genderCheckboxFieldFocus: genderCheckboxFieldFocus,
                    validateLastnameField: validateLastnameField,
                    validateFirstnameField: validateFirstnameField,
                    validateMiddlenameField: validateMiddlenameField,
                    validateDayBirthField: validateDayBirthField,
                    validateMonthBirthField: validateMonthBirthField,
                    validateYearBirthField: validateYearBirthField,
                    isLastnameFieldHasError: isLastnameFieldHasError,
                    isFirstnameFieldHasError: isFirstnameFieldHasError,
                    isMiddlenameFieldHasError: isMiddlenameFieldHasError,
                    isDayBirthFieldHasError: isDayBirthFieldHasError,
                    isMonthBirthFieldHasError: isMonthBirthFieldHasError,
                    isYearBirthFieldHasError: isYearBirthFieldHasError,
                    isDateInputHasError: isDateInputHasError,
                    isGenderFieldHasError: isGenderFieldHasError,
                    isMaleChecked: isMaleChecked,
                    isFemaleChecked: isFemaleChecked,
                    personClassList: personClassList,
                    onNextFieldFocus: onNextFieldFocus, setFieldErrorValue: setFieldErrorValue,
                    focusedBorderColor: focusedBorderColor,
                    validateDateBirthInput: validateDateBirthInput,
                    onCheckboxMaleChecked: onCheckboxMaleChecked,
                    onCheckboxFemaleChecked: onCheckboxFemaleChecked
                  ),

                  const SizedBox(height: 20,),
                  blockTitle("Название и номер документа"),
                  PersonDocumentInfoBlock(
                    documentNameFieldKey: documentNameFieldKey,
                    documentNumberFieldKey: documentNumberFieldKey,
                    documentNameFieldController: documentNameFieldController,
                    documentNumberFieldController: documentNumberFieldController,
                    citizenshipFieldController: citizenshipFieldController,
                    documentNameFieldFocus: documentNameFieldFocus,
                    documentNumberFieldFocus: documentNumberFieldFocus,
                    citizenshipFieldFocus: citizenshipFieldFocus,
                    validateDocumentFields: validateDocumentFields,
                    validateDocumentNameField: validateDocumentNameField,
                    isDocumentNumberFieldHasError: isDocumentNumberFieldHasError,
                    isDocumentNameFieldHasError: isDocumentNameFieldHasError,
                    onNextFieldFocus: onNextFieldFocus,
                    setFieldErrorValue: setFieldErrorValue,
                    focusedBorderColor: focusedBorderColor,
                    documentInputFieldsErrorMessage: documentInputFieldsErrorMessage
                  ),
                  const SizedBox(height: 15,),
                  blockTitle("Контактные данные"),
                  PersonContactInfoBlock(
                    phoneFieldController: phoneFieldController,
                    emailFieldController: emailFieldController,
                    phoneFieldFocus: phoneFieldFocus,
                    emailFieldFocus: emailFieldFocus,
                    onNextFieldFocus: onNextFieldFocus,
                    focusedBorderColor: focusedBorderColor
                  ),


                  const SizedBox(height: 15,),
                  blockTitle("Дополнительно"),
                  PersonAdditionalInfoBlock(
                    commentTextController: commentTextController,
                    commentFieldFocus: commentFieldFocus,
                    focusedBorderColor: focusedBorderColor
                  ),
                  const SizedBox(height: 10,),
                  SaveButton(onTap: _onSave, label: "Сохранить"),
                  const SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
