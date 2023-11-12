import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/added_document_icon_widget.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/person_model.dart';
import '../../services/database/db_provider.dart';

class PersonAddNewScreen extends StatefulWidget {
  const PersonAddNewScreen({super.key});

  @override
  State<PersonAddNewScreen> createState() => _PersonAddNewScreenState();
}

class _PersonAddNewScreenState extends State<PersonAddNewScreen> {

  final _lastnameFieldKey = GlobalKey<FormFieldState>();
  final _firstnameFieldKey = GlobalKey<FormFieldState>();
  final _middlenameFieldKey = GlobalKey<FormFieldState>();

  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _dayBirthFieldController = TextEditingController();
  final TextEditingController _monthBirthFieldController = TextEditingController();
  final TextEditingController _yearBirthFieldController = TextEditingController();
  final TextEditingController _documentNameFieldController = TextEditingController();
  final TextEditingController _documentNumberFieldController = TextEditingController();
  final TextEditingController _citizenshipFieldController = TextEditingController();
  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _firstnameFocus = FocusNode();
  final FocusNode _middlenameFocus = FocusNode();
  final FocusNode _dayBirthFocus = FocusNode();
  final FocusNode _monthBirthFocus = FocusNode();
  final FocusNode _yearBirthFocus = FocusNode();
  final FocusNode _documentNameFocus = FocusNode();
  final FocusNode _documentNumberFocus = FocusNode();
  final FocusNode _citizenshipFieldFocus = FocusNode();
  final Color focusedBorderColor = AppColors.backgroundMain4;

  bool isLastnameFieldHasError = false;
  bool isFirstnameFieldHasError = false;
  bool isMiddlenameFieldHasError = false;
  bool isDayBirthFieldHasError = false;
  bool isMonthBirthFieldHasError = false;
  bool isYearBirthFieldHasError = false;
  bool isDateInputHasError = false;
  bool isPassportSerialNumberFieldHasError = false;
  bool isDocumentNameFieldHasError = false;
  bool isDocumentNumberFieldsHasError = false;

  String? documentInputFieldsErrorMessage;



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

  String? _validateFirstnameField(String? firstname) {
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

  String? _validateMiddlenameField(String? value) {
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

  void _validateDayBirthField(String? value) {
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

  void _validateMonthBirthField(String? value) {
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

  void _validateYearBirthField(String? value) {
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

  void _validateDateBirthInput() {
    _validateDayBirthField(_dayBirthFieldController.text);
    _validateMonthBirthField(_monthBirthFieldController.text);
    _validateYearBirthField(_yearBirthFieldController.text);
    if (isDayBirthFieldHasError || isMonthBirthFieldHasError || isYearBirthFieldHasError) {
      setState(() {
        isDateInputHasError = true;
      });
    } else {
      isDateInputHasError = false;
    }
  }

  void _validatePassportFields() {
    if (_documentNameFieldController.text.isEmpty || _documentNumberFieldController.text.isEmpty) {
      setState(() {
        isPassportSerialNumberFieldHasError = _documentNameFieldController.text.isEmpty ? true : false;
        isDocumentNameFieldHasError = _documentNumberFieldController.text.isEmpty ? true : false;
        documentInputFieldsErrorMessage = "Серия и номер паспорта должны быть заполнены";
      });
    } else {
      setState(() {
        isPassportSerialNumberFieldHasError = false;
        isDocumentNameFieldHasError = false;
        documentInputFieldsErrorMessage = null;
      });
    }
  }

  void _onSave() async {
    _validateDateBirthInput();
    _validatePassportFields();
    _firstnameFieldKey.currentState?.validate();
    _lastnameFieldKey.currentState?.validate();
    _middlenameFieldKey.currentState?.validate();
    if(!isLastnameFieldHasError && !isFirstnameFieldHasError && !isMiddlenameFieldHasError &&
        !isDayBirthFieldHasError && !isDateInputHasError && !isMonthBirthFieldHasError
      && !isDocumentNameFieldHasError && !isDocumentNumberFieldsHasError && !isYearBirthFieldHasError) {
      final DBProvider db = DBProvider.db;
      final newPerson = Person(
        id: 1,
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        middlename: _middlenameController.text,
        birthdate: _dayBirthFieldController.text,
        phone: "+79132234418",
        email: "test@google.com",
        document: "${_documentNameFieldController.text}/${_documentNumberFieldController.text}",
        citizenship: _citizenshipFieldController.text,
        status: ""
      );
      final res = await db.addPerson(newPerson);
      print("RESULT IS:   $res");
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
              child: const Text('Сохранить'),
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

  void _onNextFieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool _checkForUnsavedChanges() {
    if (
    _lastnameController.text.isNotEmpty ||
    _firstnameController.text.isNotEmpty ||
    _middlenameController.text.isNotEmpty ||
    _dayBirthFieldController.text.isNotEmpty ||
    _monthBirthFieldController.text.isNotEmpty ||
    _yearBirthFieldController.text.isNotEmpty ||
    _documentNameFieldController.text.isNotEmpty ||
    _documentNumberFieldController.text.isNotEmpty ||
    _citizenshipFieldController.text.isNotEmpty
    ) {
      return true;
    } else {
      return false;
    }
  }

  
  @override
  void initState() {
    _lastnameFocus.addListener(() {
      if(!_lastnameFocus.hasFocus) {
        _lastnameFieldKey.currentState?.validate();
      }
    });
    _firstnameFocus.addListener(() {
      if(!_firstnameFocus.hasFocus) {
        _firstnameFieldKey.currentState?.validate();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _lastnameFocus.dispose();
    _firstnameController.dispose();
    _firstnameFocus.dispose();
    _middlenameController.dispose();
    _middlenameFocus.dispose();
    _dayBirthFieldController.dispose();
    _dayBirthFocus.dispose();
    _monthBirthFieldController.dispose();
    _monthBirthFocus.dispose();
    _yearBirthFieldController.dispose();
    _yearBirthFocus.dispose();
    _documentNameFieldController.dispose();
    _documentNameFocus.dispose();
    _documentNumberFieldController.dispose();
    _documentNumberFocus.dispose();
    _citizenshipFieldController.dispose();
    _citizenshipFieldFocus.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  TextFormField(
                    controller: _lastnameController,
                    focusNode: _lastnameFocus,
                    key: _lastnameFieldKey,
                    validator: _validateLastnameField,
                    autovalidateMode: AutovalidateMode.disabled,
                    keyboardType: TextInputType.text,
                    cursorHeight: 25,
                    onEditingComplete: (){
                      _onNextFieldFocus(context, _lastnameFocus, _firstnameFocus);
                      _lastnameFieldKey.currentState?.validate();
                    },
                    onTap: () {
                      if(isLastnameFieldHasError) {
                        setState(() {
                          isLastnameFieldHasError = false;
                        });
                      }
                    },
                    onTapOutside: (event) {
                      if(_lastnameFocus.hasFocus) {
                        _lastnameFocus.unfocus();
                      }
                    },
                    cursorColor: Color(0xFF000000),
                    style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: isLastnameFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            color: focusedBorderColor
                        )
                      ),
                      enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            color: AppColors.backgroundMain2
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.errorMain
                          )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.errorMain
                          )
                      ),
                      errorStyle: TextStyle(fontSize: 16, height: 0.3),
                      labelText: 'Фамилия',
                      labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                      focusColor: AppColors.accent5,
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: _firstnameController,
                    focusNode: _firstnameFocus,
                    key: _firstnameFieldKey,
                    validator: _validateFirstnameField,
                    autovalidateMode: AutovalidateMode.disabled,
                    keyboardType: TextInputType.text,
                    cursorHeight: 25,
                    onEditingComplete: (){
                      _onNextFieldFocus(context, _firstnameFocus, _middlenameFocus);
                      _firstnameFieldKey.currentState?.validate();
                    },
                    onTap: () {
                      if(isFirstnameFieldHasError) {
                        setState(() {
                          isFirstnameFieldHasError = false;
                        });
                      }
                    },
                    onTapOutside: (event) {
                      if(_firstnameFocus.hasFocus) {
                        _firstnameFocus.unfocus();
                      }
                    },
                    cursorColor: Color(0xFF000000),
                    style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: isFirstnameFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: focusedBorderColor
                          )
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.backgroundMain2
                          )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.errorMain
                          )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.errorMain
                          )
                      ),
                      errorStyle: TextStyle(fontSize: 16, height: 0.3),
                      labelText: 'Имя',
                      labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                      focusColor: AppColors.accent5,
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: _middlenameController,
                    focusNode: _middlenameFocus,
                    key: _middlenameFieldKey,
                    validator: _validateMiddlenameField,
                    autovalidateMode: AutovalidateMode.disabled,
                    keyboardType: TextInputType.text,
                    cursorHeight: 25,
                    onEditingComplete: (){
                      _onNextFieldFocus(context, _middlenameFocus, _dayBirthFocus);
                      _middlenameFieldKey.currentState?.validate();
                    },
                    onTap: () {
                      if(isMiddlenameFieldHasError) {
                        setState(() {
                          isMiddlenameFieldHasError = false;
                        });
                      }
                    },
                    onTapOutside: (event) {
                      if(_middlenameFocus.hasFocus) {
                        _middlenameFocus.unfocus();
                      }
                    },
                    cursorColor: Color(0xFF000000),
                    style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: isMiddlenameFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: focusedBorderColor
                          )
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.backgroundMain2
                          )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.errorMain
                          )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: AppColors.errorMain
                          )
                      ),
                      errorStyle: TextStyle(fontSize: 16, height: 0.3),
                      labelText: 'Отчество',
                      labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                      focusColor: AppColors.accent5,
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextFormField(
                          controller: _dayBirthFieldController,
                          focusNode: _dayBirthFocus,
                          validator: _validateMiddlenameField,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2)
                          ],
                          onEditingComplete: (){
                            _onNextFieldFocus(context, _dayBirthFocus, _monthBirthFocus);
                            _validateDayBirthField(_dayBirthFieldController.text);
                            // _validateDateBirthInput();
                          },
                          onTap: () {
                            if(isDayBirthFieldHasError) {
                              setState(() {
                                isDayBirthFieldHasError = false;
                              });
                            }
                          },
                          onTapOutside: (event) {
                            if(_dayBirthFocus.hasFocus) {
                              _dayBirthFocus.unfocus();
                            }
                          },
                          cursorColor: Color(0xFF000000),
                          style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: isDayBirthFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: focusedBorderColor
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: 'День',
                            labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: TextFormField(
                          controller: _monthBirthFieldController,
                          focusNode: _monthBirthFocus,
                          validator: _validateMiddlenameField,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.text,
                          cursorHeight: 25,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2)
                          ],
                          onEditingComplete: (){
                            _onNextFieldFocus(context, _monthBirthFocus, _yearBirthFocus);
                            _validateMonthBirthField(_monthBirthFieldController.text);
                            // _validateDateBirthInput();
                          },
                          onTap: () {
                            if(isMonthBirthFieldHasError) {
                              setState(() {
                                isMonthBirthFieldHasError = false;
                              });
                            }
                          },
                          onTapOutside: (event) {
                            if(_monthBirthFocus.hasFocus) {
                              _monthBirthFocus.unfocus();
                            }
                          },
                          cursorColor: Color(0xFF000000),
                          style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: isMonthBirthFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: focusedBorderColor
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: 'Месяц',
                            labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: TextFormField(
                          controller: _yearBirthFieldController,
                          focusNode: _yearBirthFocus,
                          validator: _validateMiddlenameField,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.text,
                          cursorHeight: 25,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4)
                          ],
                          onEditingComplete: (){
                            _onNextFieldFocus(context, _yearBirthFocus, _documentNameFocus);
                            _validateYearBirthField(_yearBirthFieldController.text);
                            _validateDateBirthInput();
                          },
                          onTap: () {
                            if(isYearBirthFieldHasError) {
                              setState(() {
                                isYearBirthFieldHasError = false;
                              });
                            }
                          },
                          onTapOutside: (event) {
                            if(_yearBirthFocus.hasFocus) {
                              _yearBirthFocus.unfocus();
                            }
                          },
                          cursorColor: Color(0xFF000000),
                          style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: isYearBirthFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: focusedBorderColor
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: 'Год',
                            labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    child: Text(isDateInputHasError ? "Некорректная дата рождения" : "",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: AppColors.errorMain),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("Серия и номер паспорта",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 24, color: Color(0xFF000000), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          controller: _documentNameFieldController,
                          focusNode: _documentNameFocus,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          onEditingComplete: (){
                            _onNextFieldFocus(context, _documentNameFocus, _documentNumberFocus);
                            _validatePassportFields();
                          },
                          onTap: () {
                            if(isPassportSerialNumberFieldHasError) {
                              setState(() {
                                isPassportSerialNumberFieldHasError = false;
                              });
                            }
                          },
                          onTapOutside: (event) {
                            if(_documentNameFocus.hasFocus) {
                              _documentNameFocus.unfocus();
                            }
                          },
                          cursorColor: Color(0xFF000000),
                          style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: isPassportSerialNumberFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: focusedBorderColor
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: 'Документ',
                            labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          controller: _documentNumberFieldController,
                          focusNode: _documentNumberFocus,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          onEditingComplete: (){
                            _onNextFieldFocus(context, _documentNumberFocus, _citizenshipFieldFocus);
                            _validatePassportFields();
                          },
                          onTap: () {
                            if(isDocumentNameFieldHasError) {
                              setState(() {
                                isDocumentNameFieldHasError = false;
                              });
                            }
                          },
                          onTapOutside: (event) {
                            if(_documentNumberFocus.hasFocus) {
                              _documentNumberFocus.unfocus();
                            }
                          },
                          cursorColor: Color(0xFF000000),
                          style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: isDocumentNameFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: focusedBorderColor
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: AppColors.errorMain
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: 'Номер',
                            labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: _citizenshipFieldController,
                        focusNode: _citizenshipFieldFocus,
                        autovalidateMode: AutovalidateMode.disabled,
                        keyboardType: TextInputType.text,
                        cursorHeight: 25,
                        onEditingComplete: (){
                          _citizenshipFieldFocus.unfocus();
                        },
                        onTapOutside: (event) {
                          if(_citizenshipFieldFocus.hasFocus) {
                            _citizenshipFieldFocus.unfocus();
                          }
                        },
                        cursorColor: Color(0xFF000000),
                        style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          fillColor: AppColors.textMain,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: focusedBorderColor
                              )
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: AppColors.backgroundMain2
                              )
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: AppColors.errorMain
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: AppColors.errorMain
                              )
                          ),
                          errorStyle: TextStyle(fontSize: 16, height: 0.3),
                          labelText: 'Гражданство',
                          labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                          focusColor: AppColors.accent5,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    child: Text(documentInputFieldsErrorMessage != null ? documentInputFieldsErrorMessage! : "",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: AppColors.errorMain),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: Text("Прикрепить фото паспорта",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 24, color: Color(0xFF000000), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75 - 20,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(width: 1, color: AppColors.backgroundMain2),
                          color: AppColors.textMain,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                AddedDocumentIconWidget(),
                                AddedDocumentIconWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05
                      ),
                      Ink(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(width: 1, color: AppColors.backgroundMain2),
                          color: AppColors.textMain,
                        ),
                        child: InkWell(
                          onTap: _openAddingDocOptionDialog,
                          splashColor: AppColors.backgroundMain5,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Icon(
                            Icons.add,
                            color: AppColors.backgroundMain2,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    child: Text("Не прикреплено ни одного документа",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: Color(0x99000000)),
                    ),
                  ),
                  SizedBox(height: 30,),
                  SaveButton(onTap: _onSave),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
