import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as d;
import '../../../navigation/navigation.dart';
import '../../../services/database/db_provider.dart';
import '../../../theme.dart';
import '../../widgets/form_block_title.dart';

class TripEditInfo extends StatefulWidget {
  const TripEditInfo({
    required this.trip,
    super.key
  });

  final Trip trip;

  @override
  State<TripEditInfo> createState() => _TripEditInfoState();
}

class _TripEditInfoState extends State<TripEditInfo> {

  final DBProvider _db = DBProvider.db;
  final TextEditingController nameTextController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final Color focusedBorderColor = AppColors.backgroundMain4;

  bool isTripNameHasError = false;
  bool isEndTripDateFieldError = false;
  bool isStartTripDateFieldError = false;
  bool isStartTripDateHasChanges = false;
  bool isEndTripDateHasChanges = false;
  bool isTripNameHasChanges = false;
  bool hasChanges = false;

  DateTime? _startTripDateSelection;
  DateTime? _startTripTimeSelection;
  String? _startTripDateTimeString;

  DateTime? _endTripDateSelection;
  DateTime? _endTripTimeSelection;
  String? _endTripDateTimeString;

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
    _startTripDateHasChanges();
  }

  void _onConfirmEndTripDate(DateTime date) {
    setState(() {
      _endTripDateSelection = date;
    });
    setEndTripDateTimeString();
    _endTripDateHasChanges();
  }

  void _onConfirmStartTripTime(DateTime time) {
    setState(() {
      _startTripTimeSelection = time;
    });
    setStartTripDateTimeString();
    _startTripDateHasChanges();
  }

  void _onConfirmEndTripTime(DateTime time) {
    setState(() {
      _endTripTimeSelection = time;
    });
    setEndTripDateTimeString();
    _endTripDateHasChanges();
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

  DateTime _makeDateWithTime(DateTime date, DateTime time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _onUpdate() async {
    final DateTime start = _makeDateWithTime(_startTripDateSelection!, _startTripTimeSelection!);
    final DateTime end = _makeDateWithTime(_endTripDateSelection!, _endTripTimeSelection!);
    final res = await _db.updateTrip(
      id: widget.trip.id,
      tripName: nameTextController.text,
      tripStartDate: start,
      tripEndDate: end
    );
    context.goNamed(
        NavigationRoutes.allTripsScreen.name
    );
  }
  void _startTripDateHasChanges() {
    if(_startTripDateSelection == null) return;
    final int milliseconds = DateTime(_startTripDateSelection!.year, _startTripDateSelection!.month, _startTripDateSelection!.day, _startTripTimeSelection!.hour, _startTripTimeSelection!.minute).millisecondsSinceEpoch;
    setState(() {
      isStartTripDateHasChanges = widget.trip.tripStartDate.millisecondsSinceEpoch != milliseconds;
    });
    checkChanges();
  }
  void _endTripDateHasChanges() {
    if(_endTripDateSelection == null) return;
    final int milliseconds = DateTime(_endTripDateSelection!.year, _endTripDateSelection!.month, _endTripDateSelection!.day, _endTripTimeSelection!.hour, _endTripTimeSelection!.minute).millisecondsSinceEpoch;
    setState(() {
      isEndTripDateHasChanges = widget.trip.tripEndDate.millisecondsSinceEpoch != milliseconds;
    });
    checkChanges();
  }
  void _tripNameHasChanges(String value) {
    setState(() {
      isTripNameHasChanges = widget.trip.tripName == value;
    });
    checkChanges();
  }
  void checkChanges() {
    if(isStartTripDateHasChanges || isEndTripDateHasChanges || isTripNameHasChanges) {
      setState(() {
        hasChanges = true;
      });
    } else {
      setState(() {
        hasChanges = false;
      });
    }
  }
  void initTripDates(DateTime start, DateTime end) {
    setState(() {
      _startTripDateSelection = start;
      _startTripTimeSelection = start;
      _endTripDateSelection = end;
      _endTripTimeSelection = end;
    });
    setStartTripDateTimeString();
    setEndTripDateTimeString();

    _startTripDateHasChanges();
    _endTripDateHasChanges();
  }


  @override
  void initState() {
    super.initState();

    // _onConfirmStartTripDate(widget.trip.tripStartDate);
    // _onConfirmStartTripTime(widget.trip.tripStartDate);
    // _onConfirmEndTripDate(widget.trip.tripEndDate);
    // _onConfirmEndTripTime(widget.trip.tripEndDate);
    // setStartTripDateTimeString();
    // setEndTripDateTimeString();
    initTripDates(widget.trip.tripStartDate, widget.trip.tripEndDate);
    nameTextController.text = widget.trip.tripName;
  }

  @override
  void dispose() {
    nameTextController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.transparent,
      appBar: const CustomAppBar(scrollController: null, child: null),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              _editTripCard()
            ],
        ),
      ),
    ));
  }

  Widget _editTripCard() {
    return SingleChildScrollView(
      child: Column(
          children: [
            const SizedBox(height: 120,),
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
              onChanged: _tripNameHasChanges,
              cursorColor: Color(0xFF000000),
              style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                fillColor: isTripNameHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
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
                labelText: 'Название рейса',
                labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                focusColor: AppColors.accent5,
              ),
            ),
            isTripNameHasError
                ? Text(
              "Название рейся обязательно",
              style: TextStyle(fontSize: 16, color: AppColors.errorMain),
            )
                : const SizedBox.shrink(),
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
                    color: isEndTripDateFieldError
                        ? AppColors.errorMain
                        : AppColors.backgroundMain2,
                    width: 1),
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: isEndTripDateFieldError ? AppColors.errorFieldFillColor : Colors.transparent,
              ),
              child: Center(
                child: Text(_startTripDateTimeString ?? "",
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
                    width: MediaQuery.of(context).size.width * 0.5 - 15,
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
                        child: Text("Изменить  дату".toUpperCase(),
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
                      customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                      splashColor: AppColors.backgroundMain5,
                      child: Center(
                        child: Text("Изменить  время".toUpperCase(),
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
            isEndTripDateFieldError
                ? Text(
              "Некорректное время рейса",
              style: TextStyle(fontSize: 16, color: AppColors.errorMain),
            )
                : SizedBox.shrink(),

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
                child: Text(_endTripDateTimeString ?? "",
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
                      customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                      splashColor: AppColors.backgroundMain5,
                      child: Center(
                        child: Text("Изменить  дату".toUpperCase(),
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
                    width: MediaQuery.of(context).size.width * 0.5 - 15,
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
                        child: Text("Изменить  время".toUpperCase(),
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
            isStartTripDateFieldError
                ? Text(
              "Некорректное время рейса",
              style:
              TextStyle(fontSize: 16, color: AppColors.errorMain),
            )
                : SizedBox.shrink(),
            hasChanges ? SaveButton(onTap: _onUpdate, label: "Обновить") : SizedBox.shrink(),
            const SizedBox(height: 5)
          ]
      ),
    );
  }
}

class TripEditInfoScreenArguments {
  final Trip trip;
  const TripEditInfoScreenArguments({required this.trip});
}
