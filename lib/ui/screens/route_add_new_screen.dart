import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as d;
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';

class RouteAddNewScreen extends StatefulWidget {
  const RouteAddNewScreen({super.key});

  @override
  State<RouteAddNewScreen> createState() => _RouteAddNewScreenState();
}

class _RouteAddNewScreenState extends State<RouteAddNewScreen> {


  final GlobalKey _globalMainContainerKey = GlobalKey();
  final FocusNode _departureFieldFocus = FocusNode();
  final FocusNode _arrivalFieldFocus = FocusNode();
  final FocusNode _shipsFieldFocus = FocusNode();
  List<DropdownMenuItem<String>> _departureMenuEntries = [];
  List<DropdownMenuItem<String>> _arrivalMenuEntries = [];
  List<DropdownMenuItem<String>> _shipsMenuEntries = [];

  String? _departureSelection;
  String? _arrivalSelection;
  String? _shipsSelection;
  bool isDropDownMenuHasError = false;
  bool isShipsMenuHasError = false;
  String? dropDownMenuErrorMessage;

  bool isDepartureSelectionDateFieldError = false;
  DateTime? _departureDateSelection;
  DateTime? _departureTimeSelection;
  String? _departureDateTimeString;
  bool isDepartureDateTimeFieldHasError = false;

  bool isArrivalSelectionDateFieldError = false;
  DateTime? _arrivalDateSelection;
  DateTime? _arrivalTimeSelection;
  String? _arrivalDateTimeString;
  bool isArrivalDateTimeFieldHasError = false;


  String? _validateDropDownMenu() {
    if (_departureSelection == null && _arrivalSelection == null) {
      setState(() {
        isDropDownMenuHasError = true;
        dropDownMenuErrorMessage =
            "Поля Отправление и Прибытие должны быть заполнены!";
      });
    } else if (_departureSelection != null && _arrivalSelection == null) {
      setState(() {
        isDropDownMenuHasError = true;
        dropDownMenuErrorMessage = "Поле Отправление должно быть заполнено!";
      });
    } else if (_departureSelection == null && _arrivalSelection != null) {
      setState(() {
        isDropDownMenuHasError = true;
        dropDownMenuErrorMessage = "Поле Прибытие должно быть заполнено!";
      });
    } else if (_departureSelection == _arrivalSelection) {
      setState(() {
        isDropDownMenuHasError = true;
        dropDownMenuErrorMessage =
            "Город отправления и прибытия не может быть одним и тем же!";
      });
    } else {
      setState(() {
        isDropDownMenuHasError = false;
        dropDownMenuErrorMessage = null;
      });
    }
  }

  void _onConfirmDepartureDate(DateTime date) {
    print("Date picked: $date");
    setState(() {
      _departureDateSelection = date;
    });
    print("Date picked set state: $_departureDateSelection");
    setDepartureDateTimeString();
  }

  void _onConfirmArrivalDate(DateTime date) {
    print("Date picked: $date");
    setState(() {
      _arrivalDateSelection = date;
    });
    setArrivalDateTimeString();
  }

  void _onConfirmDepartureTime(DateTime time) {
    print("Date picked: $time");
    setState(() {
      _departureTimeSelection = time;
    });
    setDepartureDateTimeString();
  }

  void _onConfirmArrivalTime(DateTime time) {
    print("Date picked: $time");
    setState(() {
      _arrivalTimeSelection = time;
    });
    setArrivalDateTimeString();
  }

  void setDepartureDateTimeString() {
    print("Set depart timedate   ^    ${_departureDateTimeString}");
    String hour = "";
    String minute = "";
    String day = "";
    String month = "";
    String year = "";

    if (_departureTimeSelection != null) {
      if (_departureTimeSelection!.hour < 10) {
        hour = "0${_departureTimeSelection!.hour}";
      } else {
        hour = "${_departureTimeSelection!.hour}";
      }

      if (_departureTimeSelection!.minute < 10) {
        minute = "0${_departureTimeSelection!.minute}";
      } else {
        minute = "${_departureTimeSelection!.minute}";
      }
    }

    if (_departureDateSelection != null) {
      if (_departureDateSelection!.day < 10) {
        day = "0${_departureDateSelection!.day}";
      } else {
        day = "${_departureDateSelection!.day}";
      }

      if (_departureDateSelection!.month < 10) {
        month = "0${_departureDateSelection!.month}";
      } else {
        month = "${_departureDateSelection!.month}";
      }
      year = "${_departureDateSelection!.year}";
    }

    final date = _departureDateSelection == null ? "" : "$day.$month.$year";
    final time = _departureTimeSelection == null ? "" : "$hour:$minute";

    setState(() {
      _departureDateTimeString = "$date   $time";
    });
  }

  void setArrivalDateTimeString() {
    String hour = "";
    String minute = "";
    String day = "";
    String month = "";
    String year = "";

    if (_arrivalTimeSelection != null) {
      if (_arrivalTimeSelection!.hour < 10) {
        hour = "0${_arrivalTimeSelection!.hour}";
      } else {
        hour = "${_arrivalTimeSelection!.hour}";
      }

      if (_arrivalTimeSelection!.minute < 10) {
        minute = "0${_arrivalTimeSelection!.minute}";
      } else {
        minute = "${_arrivalTimeSelection!.minute}";
      }
    }

    if (_arrivalDateSelection != null) {
      if (_arrivalDateSelection!.day < 10) {
        day = "0${_arrivalDateSelection!.day}";
      } else {
        day = "${_arrivalDateSelection!.day}";
      }

      if (_arrivalDateSelection!.month < 10) {
        month = "0${_arrivalDateSelection!.month}";
      } else {
        month = "${_arrivalDateSelection!.month}";
      }
      year = "${_arrivalDateSelection!.year}";
    }

    final date = _arrivalDateSelection == null ? "" : "$day.$month.$year";
    final time = _arrivalTimeSelection == null ? "" : "$hour:$minute";

    setState(() {
      _arrivalDateTimeString = "$date   $hour:$time";
    });
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


  @override
  void initState() {
    setState(() {
      _departureMenuEntries = getDestinationCityOptions()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
      _arrivalMenuEntries = getDestinationCityOptions()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
      _shipsMenuEntries = getShipsOptions()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: AppColors.backgroundNeutral,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Добавить рейс".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppStyles.submainTitleTextStyle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Отправление",
                style:
                    TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
              ),
              Container(
                height: 60,
                child: DropdownButtonFormField(
                  focusNode: _departureFieldFocus,
                  dropdownColor: AppColors.secondary6,
                  isExpanded: true,
                  items: _arrivalMenuEntries,
                  itemHeight: 80,
                  style:
                      TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                  onChanged: (String? value) {
                    _departureFieldFocus.unfocus();
                    setState(() {
                      _departureSelection = value;
                    });
                    if (_arrivalSelection != null) {
                      _validateDropDownMenu();
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    fillColor: isDropDownMenuHasError
                        ? AppColors.errorFieldFillColor
                        : Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isDropDownMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1, color: AppColors.backgroundMain5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isDropDownMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Прибытие",
                style: AppStyles.submainTitleTextStyle,
              ),
              Container(
                height: 60,
                child: DropdownButtonFormField(
                  focusNode: _arrivalFieldFocus,
                  dropdownColor: AppColors.secondary6,
                  isExpanded: true,
                  items: _arrivalMenuEntries,
                  onChanged: (String? value) {
                    setState(() {
                      _arrivalSelection = value;
                    });
                    _arrivalFieldFocus.unfocus();
                    _validateDropDownMenu();
                  },
                  itemHeight: 80,
                  style:
                      TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    fillColor: isDropDownMenuHasError
                        ? AppColors.errorFieldFillColor
                        : Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isDropDownMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1, color: AppColors.backgroundMain5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isDropDownMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isDropDownMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                  ),
                ),
              ),
              isDropDownMenuHasError
                  ? Text(
                      dropDownMenuErrorMessage!,
                      style:
                          TextStyle(fontSize: 16, color: AppColors.errorMain),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 20,
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
                        color: isDepartureSelectionDateFieldError
                            ? AppColors.errorMain
                            : AppColors.backgroundMain2,
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: isDepartureSelectionDateFieldError ? AppColors.errorMain : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    _departureDateTimeString != null
                        ? _departureDateTimeString!
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
                            _departureDateSelection == null
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
                          _timePicker(_onConfirmDepartureTime);
                        },
                        splashColor: AppColors.backgroundMain5,
                        child: Center(
                          child: Text(
                            _departureDateSelection == null
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
              isDepartureSelectionDateFieldError
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
                      color: isArrivalSelectionDateFieldError
                          ? AppColors.errorMain
                          : AppColors.backgroundMain2,
                      width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: isArrivalSelectionDateFieldError ? AppColors.errorMain : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    _arrivalDateTimeString != null
                        ? _arrivalDateTimeString!
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
                          _datePicker(_onConfirmArrivalDate);
                        },
                        splashColor: AppColors.backgroundMain5,
                        child: Center(
                          child: Text(
                            _arrivalDateSelection == null
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
                            _arrivalDateSelection == null
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
              isArrivalSelectionDateFieldError
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
                "Выбор судна",
                style: AppStyles.submainTitleTextStyle,
              ),
              Container(
                height: 60,
                child: DropdownButtonFormField(
                  focusNode: _shipsFieldFocus,
                  dropdownColor: AppColors.secondary6,
                  isExpanded: true,
                  items: _shipsMenuEntries,
                  onChanged: (String? value) {
                    setState(() {
                      _shipsSelection = value;
                    });
                    _shipsFieldFocus.unfocus();
                  },
                  itemHeight: 80,
                  style:
                  TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    fillColor: isShipsMenuHasError
                        ? AppColors.errorFieldFillColor
                        : Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isShipsMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1, color: AppColors.backgroundMain5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isShipsMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(
                            width: 1,
                            color: isShipsMenuHasError
                                ? AppColors.errorMain
                                : AppColors.backgroundMain2)),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              SaveButton(onTap: ()=> {}, label: "Сохранить"),
              SizedBox(height: 10,)
            ],
          ),
        ),
      )
    );
  }
}
