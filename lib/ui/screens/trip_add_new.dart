import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as d;
import 'package:pleyona_app/ui/widgets/save_button.dart';
import '../../theme.dart';
import '../widgets/custom_appbar.dart';

class TripAddNewScreen extends StatefulWidget {
  const TripAddNewScreen({super.key});

  @override
  State<TripAddNewScreen> createState() => _TripAddNewScreenState();
}

class _TripAddNewScreenState extends State<TripAddNewScreen> {

  late final ScrollController _scrollController;
  final Color focusedBorderColor = AppColors.backgroundMain4;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController commentTextController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode commentFocusNode = FocusNode();

  String? tripName;
  bool isStartTripDateFieldError = false;
  bool isEndTripDateFieldError = false;
  DateTime? _startTripDateSelection;
  DateTime? _startTripTimeSelection;
  String? _startTripDateTimeString;
  bool isStartTripDateTimeFieldHasError = false;

  DateTime? _endTripDateSelection;
  DateTime? _endTripTimeSelection;
  String? _endTripDateTimeString;
  bool isEndTripDateTimeFieldHasError = false;

  checkIfDataFilledCorrect() {
    if(_startTripTimeSelection == null)
  }

  validateStartTripTime() {}
  validateEndTripTime() {}
  validateStartTripDate() {}
  validateEndTripDate() {}
  validateTripName() {}

  validate() {
    if(
      _startTripTimeSelection == null || _startTripDateSelection == null ||
      _endTripTimeSelection == null || _endTripDateSelection == null ||
      tripName == null
    ) {

    }
  }


  Future<DateTime?> _datePicker(Function(DateTime) callback) {
    return d.DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2023, 1, 1),
        maxTime: DateTime(2026, 12, 31),
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

  Future<DateTime?> _timePicker(Function(DateTime) callback) {
    return d.DatePicker.showTimePicker(context,
        showTitleActions: true,
        showSecondsColumn: false,
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

  void _onConfirmDepartureDate(DateTime date) {
    print("Date picked: $date");
    setState(() {
      _startTripDateSelection = date;
    });
    print("Date picked set state: $_startTripDateSelection");
    setDepartureDateTimeString();
  }

  void _onConfirmEndTripDate(DateTime date) {
    print("Date picked: $date");
    setState(() {
      _endTripDateSelection = date;
    });
    setArrivalDateTimeString();
  }

  void _onConfirmStartTripTime(DateTime time) {
    print("Date picked: $time");
    setState(() {
      _startTripTimeSelection = time;
    });
    setDepartureDateTimeString();
  }

  void _onConfirmArrivalTime(DateTime time) {
    print("Date picked: $time");
    setState(() {
      _endTripTimeSelection = time;
    });
    setArrivalDateTimeString();
  }

  void setDepartureDateTimeString() {
    print("Set depart timedate   ^    ${_startTripDateTimeString}");
    String hour = "";
    String minute = "";
    String day = "";
    String month = "";
    String year = "";

    if (_startTripTimeSelection != null) {
      if (_startTripTimeSelection!.hour < 10) {
        hour = "0${_startTripTimeSelection!.hour}";
      } else {
        hour = "${_startTripTimeSelection!.hour}";
      }

      if (_startTripTimeSelection!.minute < 10) {
        minute = "0${_startTripTimeSelection!.minute}";
      } else {
        minute = "${_startTripTimeSelection!.minute}";
      }
    }

    if (_startTripDateSelection != null) {
      if (_startTripDateSelection!.day < 10) {
        day = "0${_startTripDateSelection!.day}";
      } else {
        day = "${_startTripDateSelection!.day}";
      }

      if (_startTripDateSelection!.month < 10) {
        month = "0${_startTripDateSelection!.month}";
      } else {
        month = "${_startTripDateSelection!.month}";
      }
      year = "${_startTripDateSelection!.year}";
    }

    final date = _startTripDateSelection == null ? "" : "$day.$month.$year";
    final time = _startTripTimeSelection == null ? "" : "$hour:$minute";

    setState(() {
      _startTripDateTimeString = "$date   $time";
    });
  }

  void setArrivalDateTimeString() {
    String hour = "";
    String minute = "";
    String day = "";
    String month = "";
    String year = "";

    if (_endTripTimeSelection != null) {
      if (_endTripTimeSelection!.hour < 10) {
        hour = "0${_endTripTimeSelection!.hour}";
      } else {
        hour = "${_endTripTimeSelection!.hour}";
      }

      if (_endTripTimeSelection!.minute < 10) {
        minute = "0${_endTripTimeSelection!.minute}";
      } else {
        minute = "${_endTripTimeSelection!.minute}";
      }
    }

    if (_endTripDateSelection != null) {
      if (_endTripDateSelection!.day < 10) {
        day = "0${_endTripDateSelection!.day}";
      } else {
        day = "${_endTripDateSelection!.day}";
      }

      if (_endTripDateSelection!.month < 10) {
        month = "0${_endTripDateSelection!.month}";
      } else {
        month = "${_endTripDateSelection!.month}";
      }
      year = "${_endTripDateSelection!.year}";
    }

    final date = _endTripDateSelection == null ? "" : "$day.$month.$year";
    final time = _endTripTimeSelection == null ? "" : "$hour:$minute";

    setState(() {
      _endTripDateTimeString = "$date   $hour:$time";
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(scrollController: _scrollController, child: null,),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        child: Column(
        children: [
          SizedBox(height: 10,),
          TextFormField(
            controller: nameTextController,
            focusNode: nameFocusNode,
            autovalidateMode: AutovalidateMode.disabled,
            keyboardType: TextInputType.text,
            cursorHeight: 25,
            onEditingComplete: (){
              // onNextFieldFocus(context, lastnameFocus, firstnameFocus);
            },
            onTapOutside: (event) {
              if(nameFocusNode.hasFocus) {
                nameFocusNode.unfocus();
              }
            },
            cursorColor: Color(0xFF000000),
            style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              fillColor: AppColors.textMain,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(
                      color: focusedBorderColor
                  )
              ),
              enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(
                      color: AppColors.backgroundMain2
                  )
              ),
              errorStyle: TextStyle(fontSize: 16, height: 0.3),
              labelText: 'Название рейса',
              labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
              focusColor: AppColors.accent5,
            ),
          ),
        Text(
        "Дата и время отправления",
        style: AppStyles.submainTitleTextStyle,
        ),
        Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(
              color: isEndTripDateFieldError
                  ? AppColors.errorMain
                  : AppColors.backgroundMain2,
              width: 1),
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: isEndTripDateFieldError ? AppColors.errorMain : Colors.transparent,
        ),
        child: Center(
          child: Text(
            _startTripDateTimeString != null
                ? _startTripDateTimeString!
                : "",
            style: TextStyle(
                fontSize: 20, color: AppColors.backgroundMain2, fontWeight: FontWeight.w600),
          ),
        ),
        ),
        SizedBox(
        height: 5,
        ),
        Row(
        children: [
          Material(
            child: Ink(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.5 - 15,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.backgroundMain2, width: 1),
                  color: AppColors.backgroundMain2,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: InkWell(
                onTap: () {
                  _datePicker(_onConfirmDepartureDate);
                },
                splashColor: AppColors.backgroundMain5,
                child: Center(
                  child: Text(
                    _startTripDateSelection == null
                        ? "Выбрать  дату".toUpperCase()
                        : "Изменить  дату".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18, color: AppColors.textMain),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Material(
            child: Ink(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.5 - 15,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.backgroundMain2, width: 1),
                  color: AppColors.backgroundMain2,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: InkWell(
                onTap: () {
                  _timePicker(_onConfirmStartTripTime);
                },
                splashColor: AppColors.backgroundMain5,
                child: Center(
                  child: Text(
                    _startTripDateSelection == null
                        ? "Выбрать  время".toUpperCase()
                        : "Изменить  время".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18, color: AppColors.textMain),
                  ),
                ),
              ),
            ),
          )
        ],
        ),
        SizedBox(
        height: 7,
        ),
        isEndTripDateFieldError
          ? Text(
        "Некорректное время рейса",
        style:
        TextStyle(fontSize: 16, color: AppColors.errorMain),
        )
          : SizedBox.shrink(),
        SizedBox(
        height: 20,
        ),


        Text(
        "Дата и время прибытия",
        style: AppStyles.submainTitleTextStyle,
        ),
        Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(
              color: isStartTripDateFieldError
                  ? AppColors.errorMain
                  : AppColors.backgroundMain2,
              width: 1),
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: isStartTripDateFieldError ? AppColors.errorMain : Colors.transparent,
        ),
        child: Center(
          child: Text(
            _endTripDateTimeString != null
                ? _endTripDateTimeString!
                : "",
            style: TextStyle(
                fontSize: 20, color: AppColors.backgroundMain2, fontWeight: FontWeight.w600),
          ),
        ),
        ),
        SizedBox(
        height: 5,
        ),
        Row(
        children: [
          Material(
            child: Ink(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.5 - 15,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.backgroundMain2, width: 1),
                  color: AppColors.backgroundMain2,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: InkWell(
                onTap: () {
                  _datePicker(_onConfirmEndTripDate);
                },
                splashColor: AppColors.backgroundMain5,
                child: Center(
                  child: Text(
                    _endTripDateSelection == null
                        ? "Выбрать  дату".toUpperCase()
                        : "Изменить  дату".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18, color: AppColors.textMain),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Material(
            child: Ink(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.5 - 15,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.backgroundMain2, width: 1),
                  color: AppColors.backgroundMain2,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: InkWell(
                onTap: () {
                  _timePicker(_onConfirmArrivalTime);
                },
                splashColor: AppColors.backgroundMain5,
                child: Center(
                  child: Text(
                    _endTripDateSelection == null
                        ? "Выбрать  время".toUpperCase()
                        : "Изменить  время".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18, color: AppColors.textMain),
                  ),
                ),
              ),
            ),
          )
        ],
        ),
        SizedBox(
          height: 7,
        ),
        isStartTripDateFieldError
            ? Text(
          "Некорректное время рейса",
          style:
          TextStyle(fontSize: 16, color: AppColors.errorMain),
        )
            : SizedBox.shrink(),
            SizedBox(height: 20),
          Expanded(child: SizedBox.expand(),),
          SaveButton(
            onTap: () {},
            label: "Сохранить"
          ),
          SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}
