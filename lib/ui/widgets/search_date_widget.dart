import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class InputDateToSearchWidget extends StatefulWidget {
  const InputDateToSearchWidget({super.key});

  @override
  State<InputDateToSearchWidget> createState() => _InputDateToSearchWidgetState();
}

class _InputDateToSearchWidgetState extends State<InputDateToSearchWidget> {


  final _dayFieldKey = GlobalKey<FormFieldState>();
  final _monthFieldKey = GlobalKey<FormFieldState>();
  final _yearFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _dayFieldController = TextEditingController();
  final TextEditingController _monthFieldController = TextEditingController();
  final TextEditingController _yearFieldController = TextEditingController();
  final FocusNode _dayFieldFocus = FocusNode();
  final FocusNode _monthFieldFocus = FocusNode();
  final FocusNode _yearFieldFocus = FocusNode();
  String? dayErrorMessage;
  String? monthErrorMessage;
  String? yearErrorMessage;
  bool isError = false;

  void _onNextFieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String? dayValidator(String? day) {
    String? result;
    if(day == null || day.trim().isEmpty) {
      result = null;
    } else if (int.parse(day) >= 1 && int.parse(day) <= 31) {
      result = null;
    } else {
      result = "День должен быть в пределах от 1 до 31";
    }
    setState(() {
      dayErrorMessage = result;
    });
    return result;
  }

  void setError() {
    setState(() {
      isError = dayErrorMessage == null && monthErrorMessage == null && yearErrorMessage == null ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  focusNode: _dayFieldFocus,
                  controller: _dayFieldController,
                  key: _dayFieldKey,
                  style: TextStyle(fontSize: 20, color: dayErrorMessage != null ? AppColors.errorMain : AppColors.textMain),
                  cursorColor: AppColors.textMain,
                  onEditingComplete: () {
                    _onNextFieldFocus(context, _dayFieldFocus, _monthFieldFocus);
                    dayValidator(_dayFieldController.text);
                    setError();
                  },
                  onTapOutside: (event){
                    if (_dayFieldFocus.hasFocus) {
                      _dayFieldFocus.unfocus();
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFaded,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textMain,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textMain,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.errorMain,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    label: Text("DD", style: TextStyle(fontSize: 20, color: AppColors.textSecondary),),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  focusNode: _monthFieldFocus,
                  style: TextStyle(fontSize: 20, color: AppColors.textMain),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFaded,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textMain,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    label: Text("MM", style: TextStyle(fontSize: 20, color: AppColors.textSecondary),),

                  ),
                  cursorColor: AppColors.textMain,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  style: TextStyle(fontSize: 20, color: AppColors.textMain),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFaded,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textMain,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    label: Text("YYYY", style: TextStyle(fontSize: 20, color: AppColors.textSecondary),),

                  ),
                  cursorColor: AppColors.textMain,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
              Ink(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isError ? Color(0x76FFFFFF) : AppColors.textMain,
                        width: 1
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: isError
                        ? Color(0x22FFFFFF)
                        : Color(0x76FFFFFF)
                ),
                child: InkWell(
                  highlightColor: AppColors.accent1,
                  child: Center(
                    child: Text("OK",
                      style: TextStyle(fontSize: 20, color: isError ? Color(0x76FFFFFF) : AppColors.textMain),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text("Error message",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, color: AppColors.errorMain),
            ),
          )
        ],
      )
    );
  }
}
