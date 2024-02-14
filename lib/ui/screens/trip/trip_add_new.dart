import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as d;
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import '../../../theme.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/form_block_title.dart';

class TripAddNewScreen extends StatefulWidget {
  const TripAddNewScreen({super.key});

  @override
  State<TripAddNewScreen> createState() => _TripAddNewScreenState();
}

class _TripAddNewScreenState extends State<TripAddNewScreen> {

  late final ScrollController _scrollController;
  final DBProvider _db = DBProvider.db;
  final Color focusedBorderColor = AppColors.backgroundMain4;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController commentTextController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode commentFocusNode = FocusNode();

  bool isStartTripDateFieldError = false;
  bool isEndTripDateFieldError = false;
  bool isTripNameHasError = false;
  DateTime? _startTripDateSelection;
  DateTime? _startTripTimeSelection;
  String? _startTripDateTimeString;

  DateTime? _endTripDateSelection;
  DateTime? _endTripTimeSelection;
  String? _endTripDateTimeString;


  checkIfDataFilledCorrect() {
    validateStartTripTime();
    validateEndTripTime();
    validateTripName();
  }

  validateStartTripTime() {
    if(_startTripDateSelection == null || _startTripTimeSelection == null) {
      setState(() {
        isStartTripDateFieldError = true;
      });
    } else {
      setState(() {
        isStartTripDateFieldError = false;
      });
    }
  }
  validateEndTripTime() {
    if(_endTripDateSelection == null || _endTripTimeSelection == null) {
      setState(() {
        isEndTripDateFieldError = true;
      });
    } else {
      setState(() {
        isEndTripDateFieldError = false;
      });
    }
  }
  validateTripName() {
    if(nameTextController.text.trim().isEmpty) {
      setState(() {
        isTripNameHasError = true;
      });
    } else {
      setState(() {
        isTripNameHasError = false;
      });
    }
  }

  DateTime _makeDateWithTime(DateTime date, DateTime time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _onSave() async {
    checkIfDataFilledCorrect();
    _checkTripTimeRange();
    if (!isStartTripDateFieldError && !isEndTripDateFieldError && !isTripNameHasError) {
      final DateTime start = _makeDateWithTime(_startTripDateSelection!, _startTripTimeSelection!);
      final DateTime end = _makeDateWithTime(_endTripDateSelection!, _endTripTimeSelection!);
      final newTrip = Trip(
        id: 0,
        tripName: nameTextController.text,
        tripStartDate: start,
        tripEndDate: end,
        status: 1,
        comment: ""
      );

      final res = await _db.addTrip(trip: newTrip);
      //Todo Implement navigation
      await PopupManager.showInfoPopup(context, dismissible: false, type: PopupType.success, message: "Рейс успешно добавлен",
          route: NavigationRoutes.allTripsScreen);
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

  void _onConfirmStartTripDate(DateTime date) {
    setState(() {
      _startTripDateSelection = date;
    });
    setStartTripDateTimeString();
  }

  void _onConfirmEndTripDate(DateTime date) {
    setState(() {
      _endTripDateSelection = date;
    });
    setEndTripDateTimeString();
  }

  void _onConfirmStartTripTime(DateTime time) {
    setState(() {
      _startTripTimeSelection = time;
    });
    setStartTripDateTimeString();
    validateStartTripTime();
  }

  void _onConfirmEndTripTime(DateTime time) {
    setState(() {
      _endTripTimeSelection = time;
    });
    setEndTripDateTimeString();
    validateEndTripTime();
  }

  void setStartTripDateTimeString() {
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

  void setEndTripDateTimeString() {
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
      _endTripDateTimeString = "$date   $time";
    });
  }

  void _checkTripTimeRange() {
    if (_startTripDateSelection != null && _startTripTimeSelection != null &&
      _endTripDateSelection != null && _endTripTimeSelection != null) {
      final start = DateTime(_startTripDateSelection!.year, _startTripDateSelection!.month, _startTripDateSelection!.day,
          _startTripTimeSelection!.hour, _startTripTimeSelection!.minute);
      final end = DateTime(_endTripDateSelection!.year, _endTripDateSelection!.month, _endTripDateSelection!.day,
          _endTripTimeSelection!.hour, _endTripTimeSelection!.minute);

      if (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch <= 0) {
        setState(() {
          isStartTripDateFieldError = true;
          isEndTripDateFieldError = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(scrollController: _scrollController, child: null,),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
            children: [
              const SizedBox(height: 80,),
              BlockTitle(message: "Новый рейс".toUpperCase(), alignment: Alignment.center,),
              const SizedBox(height: 10,),
              _nameTripBlock(),
              const SizedBox(height: 20),
              _departureTripBlock(),
              SizedBox(height: 20),
              _arrivalTripBlock(),
              SizedBox(height: 20),
              SaveButton(
                color: AppColors.secondary4,
                onTap: _onSave,
                label: "Сохранить",
                textStyle: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                splashColor: AppColors.secondary2,
              ),
              SizedBox(height: 5,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameTripBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: isTripNameHasError ? AppColors.errorFieldFillColor : const Color(0x99FFFFFF),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            'Название рейса',
            style: AppStyles.submainTitleTextStyle,
          ),
          TextFormField(
            controller: nameTextController,
            focusNode: nameFocusNode,
            autovalidateMode: AutovalidateMode.disabled,
            keyboardType: TextInputType.text,
            cursorHeight: 25,
            onEditingComplete: (){
              validateTripName();
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
              fillColor: isTripNameHasError ? AppColors.errorFieldFillColor : AppColors.transparent,
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
              // labelText: 'Название рейса',
              labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
              focusColor: AppColors.accent5,
            ),
          ),
          SizedBox(
            height: 20,
            child: Center(
              child: Text(isTripNameHasError ? "Название рейся обязательно" : "",
                style: TextStyle(fontSize: 16, color: AppColors.errorMain),
              )
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _arrivalTripBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: isEndTripDateFieldError ? AppColors.errorFieldFillColor : const Color(0x99FFFFFF),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
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
              color: isStartTripDateFieldError ? AppColors.errorFieldFillColor : Colors.transparent,
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
                color: AppColors.transparent,
                child: Ink(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.5 - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.backgroundMain2, width: 1),
                      color: AppColors.backgroundMain2,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: InkWell(
                    onTap: () {
                      _datePicker(_onConfirmEndTripDate);
                    },
                    customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    splashColor: AppColors.backgroundMain5,
                    child: Center(
                      child: Text(
                        _endTripDateSelection == null
                            ? "Выбрать  дату"
                            : "Изменить  дату",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, color: AppColors.textMain),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Material(
                color: AppColors.transparent,
                child: Ink(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.5 - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.backgroundMain2, width: 1),
                      color: AppColors.backgroundMain2,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: InkWell(
                    onTap: () {
                      _timePicker(_onConfirmEndTripTime);
                    },
                    customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    splashColor: AppColors.backgroundMain5,
                    child: Center(
                      child: Text(
                        _endTripTimeSelection == null
                            ? "Выбрать  время"
                            : "Изменить  время",
                        textAlign: TextAlign.center,
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
          SizedBox(
            height: 20,
            child: Center(
                child: Text(isEndTripDateFieldError ? "Некорректное время рейса" : "",
                  style: TextStyle(fontSize: 16, color: AppColors.errorMain),
                )
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _departureTripBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: isStartTripDateFieldError ? AppColors.errorFieldFillColor : const Color(0x99FFFFFF),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "Дата и время отправления",
            style: AppStyles.submainTitleTextStyle,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.backgroundMain2, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: isStartTripDateFieldError ? AppColors.errorFieldFillColor : Colors.transparent,
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
          const SizedBox(height: 5),
          Row(
            children: [
              Material(
                color: AppColors.transparent,
                child: Ink(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.5 - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.backgroundMain2, width: 1),
                      color: AppColors.backgroundMain2,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: InkWell(
                    onTap: () {
                      _datePicker(_onConfirmStartTripDate);
                    },
                    customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    splashColor: AppColors.backgroundMain5,
                    child: Center(
                      child: Text(
                        _startTripDateSelection == null
                            ? "Выбрать  дату"
                            : "Изменить  дату",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, color: AppColors.textMain),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: AppColors.transparent,
                child: Ink(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.5 - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.backgroundMain2, width: 1),
                      color: AppColors.backgroundMain2,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: InkWell(
                    onTap: () {
                      _timePicker(_onConfirmStartTripTime);
                    },
                    customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    splashColor: AppColors.backgroundMain5,
                    child: Center(
                      child: Text(
                        _startTripTimeSelection == null
                            ? "Выбрать  время"
                            : "Изменить  время",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, color: AppColors.textMain),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 20,
            child: Center(
                child: Text(isStartTripDateFieldError ? "Некорректное время рейса" : "",
                  style: TextStyle(fontSize: 16, color: AppColors.errorMain),
                )
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
