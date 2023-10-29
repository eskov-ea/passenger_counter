import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {

  final lastnameFieldKey = GlobalKey<FormFieldState>();
  final firstnameFieldKey = GlobalKey<FormFieldState>();

  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _firstnameFocus = FocusNode();
  final Color focusedBorderColor = AppColors.backgroundMain4;

  bool isLastnameFieldHasError = false;
  bool isFirstnameFieldHasError = false;

  String? validateLastnameField(String? lastname) {
    print("validateLastnameField");
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
    print("validateFirstnameField");
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

  void _onNextFieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  
  @override
  void initState() {
    _lastnameFocus.addListener(() {
      if(!_lastnameFocus.hasFocus) {
        lastnameFieldKey.currentState?.validate();
      }
    });
    _firstnameFocus.addListener(() {
      if(!_firstnameFocus.hasFocus) {
        firstnameFieldKey.currentState?.validate();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  key: lastnameFieldKey,
                  validator: validateLastnameField,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.text,
                  onEditingComplete: (){
                    _onNextFieldFocus(context, _lastnameFocus, _firstnameFocus);
                    lastnameFieldKey.currentState?.validate();
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
                  style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                    errorStyle: TextStyle(fontSize: 16),
                    labelText: 'Фамилия',
                    labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _firstnameController,
                  focusNode: _firstnameFocus,
                  key: firstnameFieldKey,
                  validator: validateFirstnameField,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.text,
                  onEditingComplete: (){
                    // _onNextFieldFocus(context, _firstnameFocus, _);
                    firstnameFieldKey.currentState?.validate();
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
                  style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                    errorStyle: TextStyle(fontSize: 16),
                    labelText: 'Имя',
                    labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
