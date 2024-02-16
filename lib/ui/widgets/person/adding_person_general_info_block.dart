import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme.dart';


class PersonGeneralInfoBlock extends StatelessWidget {
  const PersonGeneralInfoBlock({
    required this.lastnameFieldKey,
    required this.firstnameFieldKey,
    required this.middlenameFieldKey,
    required this.lastnameController,
    required this.firstnameController,
    required this.middlenameController,
    required this.dayBirthFieldController,
    required this.monthBirthFieldController,
    required this.yearBirthFieldController,
    required this.personClassDropdownController,
    required this.lastnameFocus,
    required this.firstnameFocus,
    required this.middlenameFocus,
    required this.dayBirthFieldFocus,
    required this.monthBirthFieldFocus,
    required this.yearBirthFieldFocus,
    required this.genderCheckboxFieldFocus,
    required this.validateLastnameField,
    required this.validateFirstnameField,
    required this.validateMiddlenameField,
    required this.validateDayBirthField,
    required this.validateMonthBirthField,
    required this.validateYearBirthField,
    required this.isLastnameFieldHasError,
    required this.isFirstnameFieldHasError,
    required this.isMiddlenameFieldHasError,
    required this.isDayBirthFieldHasError,
    required this.isMonthBirthFieldHasError,
    required this.isYearBirthFieldHasError,
    required this.isDateInputHasError,
    required this.isGenderFieldHasError,

    required this.isMaleChecked,
    required this.isFemaleChecked,

    required this.personClassList,
    required this.onNextFieldFocus,
    required this.setFieldErrorValue,
    required this.focusedBorderColor,
    required this.validateDateBirthInput,
    required this.onCheckboxMaleChecked,
    required this.onCheckboxFemaleChecked,
    Key? key
  }) : super(key: key);

  final GlobalKey<FormFieldState> lastnameFieldKey;
  final GlobalKey<FormFieldState> firstnameFieldKey;
  final GlobalKey<FormFieldState> middlenameFieldKey;

  final TextEditingController lastnameController;
  final TextEditingController firstnameController;
  final TextEditingController middlenameController;
  final TextEditingController dayBirthFieldController;
  final TextEditingController monthBirthFieldController;
  final TextEditingController yearBirthFieldController;
  final TextEditingController personClassDropdownController;

  final FocusNode lastnameFocus;
  final FocusNode firstnameFocus;
  final FocusNode middlenameFocus;
  final FocusNode dayBirthFieldFocus;
  final FocusNode monthBirthFieldFocus;
  final FocusNode yearBirthFieldFocus;
  final FocusNode genderCheckboxFieldFocus;

  final bool isLastnameFieldHasError;
  final bool isFirstnameFieldHasError;
  final bool isMiddlenameFieldHasError;
  final bool isDayBirthFieldHasError;
  final bool isMonthBirthFieldHasError;
  final bool isYearBirthFieldHasError;
  final bool isDateInputHasError;
  final bool isGenderFieldHasError;

  final bool isMaleChecked;
  final bool isFemaleChecked;

  final validateLastnameField;
  final validateFirstnameField;
  final validateMiddlenameField;
  final validateDayBirthField;
  final validateMonthBirthField;
  final validateYearBirthField;

  final Color focusedBorderColor;
  final Function(BuildContext, FocusNode, FocusNode) onNextFieldFocus;
  final Function(String, bool) setFieldErrorValue;
  final Function() validateDateBirthInput;
  final Function(bool? value) onCheckboxMaleChecked;
  final Function(bool? value) onCheckboxFemaleChecked;
  final List<DropdownMenuEntry<String>> personClassList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: lastnameController,
            focusNode: lastnameFocus,
            key: lastnameFieldKey,
            validator: validateLastnameField,
            autovalidateMode: AutovalidateMode.disabled,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            cursorHeight: 25,
            onEditingComplete: (){
              onNextFieldFocus(context, lastnameFocus, firstnameFocus);
              lastnameFieldKey.currentState?.validate();
            },
            onTap: () {
              if(isLastnameFieldHasError) {
                setFieldErrorValue("lastname", false);
              }
            },
            onTapOutside: (event) {
              if(lastnameFocus.hasFocus) {
                lastnameFocus.unfocus();
              }
            },
            cursorColor: Color(0xFF000000),
            style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
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
            controller: firstnameController,
            focusNode: firstnameFocus,
            key: firstnameFieldKey,
            validator: validateFirstnameField,
            autovalidateMode: AutovalidateMode.disabled,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            cursorHeight: 25,
            onEditingComplete: (){
              onNextFieldFocus(context, firstnameFocus, middlenameFocus);
              firstnameFieldKey.currentState?.validate();
            },
            onTap: () {
              if(isFirstnameFieldHasError) {
                setFieldErrorValue("firstname", false);
              }
            },
            onTapOutside: (event) {
              if(firstnameFocus.hasFocus) {
                firstnameFocus.unfocus();
              }
            },
            cursorColor: Color(0xFF000000),
            style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
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
            controller: middlenameController,
            focusNode: middlenameFocus,
            key: middlenameFieldKey,
            validator: validateMiddlenameField,
            autovalidateMode: AutovalidateMode.disabled,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            cursorHeight: 25,
            onEditingComplete: (){
              onNextFieldFocus(context, middlenameFocus, dayBirthFieldFocus);
              middlenameFieldKey.currentState?.validate();
            },
            onTap: () {
              if(isMiddlenameFieldHasError) {
                setFieldErrorValue("middlename", false);
              }
            },
            onTapOutside: (event) {
              if(middlenameFocus.hasFocus) {
                middlenameFieldKey.currentState?.validate();
                middlenameFocus.unfocus();
              }
            },
            cursorColor: Color(0xFF000000),
            style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
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
                  controller: dayBirthFieldController,
                  focusNode: dayBirthFieldFocus,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.number,
                  cursorHeight: 25,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2)
                  ],
                  onEditingComplete: (){
                    onNextFieldFocus(context, dayBirthFieldFocus, monthBirthFieldFocus);
                    validateDayBirthField(dayBirthFieldController.text);
                  },
                  onTap: () {
                    if(isDayBirthFieldHasError) {
                      setFieldErrorValue("day", false);
                    }
                  },
                  onTapOutside: (event) {
                    if(dayBirthFieldFocus.hasFocus) {
                      dayBirthFieldFocus.unfocus();
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
                  controller: monthBirthFieldController,
                  focusNode: monthBirthFieldFocus,
                  validator: validateMiddlenameField,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.number,
                  cursorHeight: 25,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2)
                  ],
                  onEditingComplete: (){
                    onNextFieldFocus(context, monthBirthFieldFocus, yearBirthFieldFocus);
                    validateMonthBirthField(monthBirthFieldController.text);
                    // _validateDateBirthInput();
                  },
                  onTap: () {
                    if(isMonthBirthFieldHasError) {
                      setFieldErrorValue("month", false);
                    }
                  },
                  onTapOutside: (event) {
                    if(monthBirthFieldFocus.hasFocus) {
                      monthBirthFieldFocus.unfocus();
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
                  controller: yearBirthFieldController,
                  focusNode: yearBirthFieldFocus,
                  validator: validateMiddlenameField,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.number,
                  cursorHeight: 25,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4)
                  ],
                  onEditingComplete: (){
                    onNextFieldFocus(context, yearBirthFieldFocus, genderCheckboxFieldFocus);
                    validateYearBirthField(yearBirthFieldController.text);
                    validateDateBirthInput();
                  },
                  onTap: () {
                    if(isYearBirthFieldHasError) {
                      setFieldErrorValue("year", false);
                    }
                  },
                  onTapOutside: (event) {
                    if(yearBirthFieldFocus.hasFocus) {
                      yearBirthFieldFocus.unfocus();
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
          SizedBox(height: 15,),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 48,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.backgroundMain2),
                  color: isGenderFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text("Пол:",
                  style: TextStyle(fontSize: 22, color: AppColors.backgroundMain2, decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4 -10,
                child: Row(
                  children: [
                    Checkbox(
                        value: isMaleChecked,
                        fillColor: MaterialStateProperty.all<Color>(const Color(0xFFB0B0B0)),
                        side: BorderSide.none,
                        focusNode: genderCheckboxFieldFocus,
                        splashRadius: 20.0,
                        onChanged: onCheckboxMaleChecked
                    ),
                    Text("Мужчина",
                      style: TextStyle(fontSize: 18, color: AppColors.backgroundMain2),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4 -10,
                child: Row(
                  children: [
                    Checkbox(
                        value: isFemaleChecked,
                        fillColor: MaterialStateProperty.all<Color>(const Color(0xFFB0B0B0)),
                        side: BorderSide.none,
                        onChanged: onCheckboxFemaleChecked
                    ),
                    Text("Женщина",
                      style: TextStyle(fontSize: 18, color: AppColors.backgroundMain2),
                    )
                  ],
                ),
              )
            ],
          ),
          isGenderFieldHasError ? Container(
            width: MediaQuery.of(context).size.width ,
            child: Text("Выберите пол персоны",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: AppColors.errorMain),
            ),
          ) : const SizedBox.shrink(),
          SizedBox(height: 15,),
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
                  fillColor: AppColors.textMain,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: AppColors.backgroundMain2, width: 1)
                  ),
                  constraints: BoxConstraints(
                      maxHeight: 50,
                      minHeight: 50
                  )
              ),
              textStyle: TextStyle(fontSize: 24, color: AppColors.backgroundMain2, decoration: TextDecoration.none, height: 1),
              width: MediaQuery.of(context).size.width * 0.74,
              controller: personClassDropdownController,
              label: Text("Класс пассажира", style: AppStyles.submainTitleTextStyle,),
              initialSelection: personClassList.first.value,
              dropdownMenuEntries: personClassList,
              onSelected: (String? value) {  },
            ),
          ),
        ],
      ),
    );
  }
}
