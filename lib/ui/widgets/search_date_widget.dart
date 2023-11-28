import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pleyona_app/theme.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as d;


class InputDateToSearchWidget extends StatefulWidget {
  const InputDateToSearchWidget({
    required this.calendarCallback,
    super.key
  });

  final Function(DateTime date) calendarCallback;

  @override
  State<InputDateToSearchWidget> createState() => _InputDateToSearchWidgetState();
}

class _InputDateToSearchWidgetState extends State<InputDateToSearchWidget> {


  final TextEditingController _dayFieldController = TextEditingController();
  final TextEditingController _monthFieldController = TextEditingController();
  final TextEditingController _yearFieldController = TextEditingController();
  final FocusNode _dayFieldFocus = FocusNode();
  final FocusNode _monthFieldFocus = FocusNode();
  final FocusNode _yearFieldFocus = FocusNode();
  bool dayError = false;
  bool monthError = false;
  bool yearError = false;
  bool isError = false;
  String errorMessageString = "Введите корректную дату";

  void _onNextFieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  validateDay() {
    if(_dayFieldController.text.isEmpty) {
      setState(() {
        dayError = true;
      });
    } else {
      setState(() {
        dayError = false;
      });
    }
  }
  validateMonth() {
    if(_monthFieldController.text.isEmpty) {
      setState(() {
        monthError = true;
      });
    } else {
      setState(() {
        monthError = false;
      });
    }
  }
  validateYear() {
    if(_yearFieldController.text.isEmpty) {
      setState(() {
        yearError = true;
      });
    } else {
      setState(() {
        yearError = false;
      });
    }
  }
  validate() {
    validateDay();
    validateMonth();
    validateYear();
    setError();
  }

  void setError() {
    String message = "";
    if (dayError && monthError && yearError) {
      message = "Введите корректную дату 1";
    } else if (dayError && monthError && !yearError) {
      message = "Введите корректную дату 2";
    } else if (dayError && yearError && !monthError) {
        message = "Введите корректную дату 3";
    } else if (monthError && yearError && !dayError) {
        message = "Введите корректную дату 4";
    } else if (dayError && !monthError && !yearError) {
        message = "Введите корректную дату 5";
    } else if (monthError && !dayError && !yearError) {
        message = "Введите корректную дату 6";
    } else if (yearError && !dayError && !monthError) {
        message = "Введите корректную дату 7";
    }

    setState(() {
      errorMessageString = message;
      isError = message != "";
    });
  }
  Future<DateTime?> _datePicker(Function(DateTime) callback) {
    return d.DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2015, 1, 1),
        maxTime: DateTime(2030, 12, 31),
        onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          callback(date);
        },
        currentTime: DateTime.now(),
        locale: d.LocaleType.ru,
        theme: d.DatePickerTheme(
            containerHeight: MediaQuery.of(context).size.height * 0.4 - 100,
            titleHeight: 100,
            itemHeight: 60));
  }
  void _onConfirmStartTripDate(DateTime date) {
    
    widget.calendarCallback(DateTime(date.year, date.month, date.day));
  }

  void searchByDate() {
    validate();
    if(isError) {
      return;
    }
    final int day = int.parse(_dayFieldController.text);
    final int month = int.parse(_monthFieldController.text);
    final int year = int.parse(_yearFieldController.text);

    final DateTime searchingDate = DateTime(year, month, day);
    widget.calendarCallback(searchingDate);
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchedDateByChoosing(),

        isError
        ?  Container(
            width: MediaQuery.of(context).size.width,
            child: Text(errorMessageString,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, color: AppColors.errorMain),
            ),
          )
        : SizedBox(height: 26,)
      ],
    );
  }

  Widget searchedDateByChoosing() {
    return Material(
      color: AppColors.transparent,
      child: Ink(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.85 - 20,
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.backgroundMain2, width: 1),
            color: AppColors.backgroundMain2,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: InkWell(
          onTap: () {
            _datePicker(_onConfirmStartTripDate);
          },
          splashColor: AppColors.backgroundMain5,
          child: Center(
            child: Text("Выбрать  дату".toUpperCase(),
              style: TextStyle(fontSize: 18, color: AppColors.textMain),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchedDateByTyping() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: TextFormField(
              keyboardType: TextInputType.number,
              focusNode: _dayFieldFocus,
              controller: _dayFieldController,
              inputFormatters: [ LengthLimitingTextInputFormatter(2) ],
              style: TextStyle(fontSize: 20, color: dayError ? AppColors.errorMain : AppColors.backgroundMain2),
              cursorColor: AppColors.textMain,
              onEditingComplete: () {
                _onNextFieldFocus(context, _dayFieldFocus, _monthFieldFocus);
                setError();
              },
              onTapOutside: (event){
                if (_dayFieldFocus.hasFocus) {
                  _dayFieldFocus.unfocus();
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textMain,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textMain,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.backgroundMain5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.backgroundMain5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.errorMain,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                label: Text("DD", style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: TextFormField(
              keyboardType: TextInputType.number,
              focusNode: _monthFieldFocus,
              controller: _monthFieldController,
              inputFormatters: [ LengthLimitingTextInputFormatter(2) ],
              style: TextStyle(fontSize: 20, color: dayError ? AppColors.errorMain : AppColors.backgroundMain2),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textMain,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textMain,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.backgroundMain5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.backgroundMain5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.errorMain,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                label: Text("MM", style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),),

              ),
              cursorColor: AppColors.textMain,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [ LengthLimitingTextInputFormatter(4) ],
              controller: _yearFieldController,
              style: TextStyle(fontSize: 20, color: dayError ? AppColors.errorMain : AppColors.backgroundMain2),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textMain,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textMain,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.backgroundMain5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.backgroundMain5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.errorMain,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                label: Text("YYYY", style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),),

              ),
              cursorColor: AppColors.textMain,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
          Material(
            color: AppColors.transparent,
            child: Ink(
              width: MediaQuery.of(context).size.width * 0.17,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: isError
                      ? Color(0x22FFFFFF)
                      : AppColors.backgroundMain4
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: searchByDate,
                splashColor: AppColors.secondary1,
                child: Center(
                  child: Text("OK",
                    style: TextStyle(fontSize: 20, color: isError ? Color(0x76FFFFFF) : AppColors.textMain),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
