import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class EditableDateTextFieldWidget extends StatefulWidget {

  final String label;
  final String valueDay;
  final String valueMonth;
  final String valueYear;
  final Function(String) valueDaySetter;
  final Function(String) valueMonthSetter;
  final Function(String) valueYearSetter;
  final Function(bool) errorSetter;
  final Color backgroundColor;
  final Color accentColor;
  final Color borderColor;
  final Color errorBackgroundColor;

  const EditableDateTextFieldWidget({
    required this.label,
    required this.valueDay,
    required this.valueMonth,
    required this.valueYear,
    required this.valueDaySetter,
    required this.valueMonthSetter,
    required this.valueYearSetter,
    required this.errorSetter,
    Color this.backgroundColor = const Color(0xFFEFEFEF),
    Color this.errorBackgroundColor = const Color(0xFFFFEAEA),
    Color this.accentColor = const Color(0xFFDEDEDE),
    Color this.borderColor = const Color(0xFF707070),
    Key? key
  }) : super(key: key);

  @override
  State<EditableDateTextFieldWidget> createState() => _EditableDateTextFieldWidgetState();
}

class _EditableDateTextFieldWidgetState extends State<EditableDateTextFieldWidget> {

  final TextEditingController _textDayController = TextEditingController();
  final TextEditingController _textMonthController = TextEditingController();
  final TextEditingController _textYearController = TextEditingController();
  final FocusNode _focusDayController = FocusNode();
  final FocusNode _focusMonthController = FocusNode();
  final FocusNode _focusYearController = FocusNode();
  bool isEditing = false;
  bool error = false;

  void validate() {
    if(_textDayController.text.isEmpty || int.parse(_textDayController.text) > 31 ||
        _textMonthController.text.isEmpty || int.parse(_textMonthController.text) > 12 ||
        _textYearController.text.isEmpty || int.parse(_textYearController.text) > DateTime.now().year || int.parse(_textYearController.text) < 1920
    ) {
      setState(() {
        error = true;
      });
      widget.errorSetter(true);
    } else {
      setState(() {
        error = false;
      });
      widget.errorSetter(false);
    }
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  void initState() {
    _textDayController.text = widget.valueDay;
    _textMonthController.text = widget.valueMonth;
    _textYearController.text = widget.valueYear;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                  height: 48,
                  child: isEditing
                  ? Row(
                    children: [
                      Container(
                        height: 48,
                        width: (MediaQuery.of(context).size.width - 48) * 0.25,
                        child: TextFormField(
                          controller: _textDayController,
                          focusNode: _focusDayController,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          onChanged: widget.valueDaySetter,
                          onEditingComplete: validate,
                          cursorColor: Color(0xFF000000),
                          style: TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: error ? widget.errorBackgroundColor : const Color(0xFFFFFFFF),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain4
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: "День",
                            labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                      SizedBox(width: (MediaQuery.of(context).size.width - 48) * 0.045,),
                      Container(
                        height: 48,
                        width: (MediaQuery.of(context).size.width - 48) * 0.25,
                        child: TextFormField(
                          controller: _textMonthController,
                          focusNode: _focusMonthController,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          onChanged: widget.valueMonthSetter,
                          onEditingComplete: validate,
                          cursorColor: Color(0xFF000000),
                          style: TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: error ? widget.errorBackgroundColor : const Color(0xFFFFFFFF),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain4
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: "Месяц",
                            labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                      SizedBox(width: (MediaQuery.of(context).size.width - 48) * 0.045,),
                      Container(
                        height: 48,
                        width: (MediaQuery.of(context).size.width - 48) * 0.33,
                        child: TextFormField(
                          controller: _textYearController,
                          focusNode: _focusYearController,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          onChanged: widget.valueYearSetter,
                          onEditingComplete: validate,
                          cursorColor: Color(0xFF000000),
                          style: TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: error ? widget.errorBackgroundColor : const Color(0xFFFFFFFF),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain4
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundMain2
                                )
                            ),
                            errorStyle: TextStyle(fontSize: 16, height: 0.3),
                            labelText: "год",
                            labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      )
                    ],
                  )
                : customTextField()
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (isEditing) {
                      validate();
                    }
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Container(
                      margin: EdgeInsets.only(top: 1, bottom: 1, right: 1),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6)
                        ),
                      ),
                      child: isEditing ? Image.asset("assets/icons/checkmark.png",) : Image.asset("assets/icons/edit.png"),
                    ),
                  ),
                ),
              )
            ],
          ),
          error
              ? SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Text("Некорректная дата рождения",
                  style: TextStyle(fontSize: 14, color: Color(0xFF5B0A0A),),
                  textAlign: TextAlign.start,
                )
              )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget customTextField() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: Color(0xFF000000)),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: error ? widget.errorBackgroundColor : widget.backgroundColor
          ),
          child: Text("${_textDayController.text}-${_textMonthController.text}-${_textYearController.text}",
            style: TextStyle(fontSize: 24, color: const Color(0xFF000000), decoration: TextDecoration.none, height: 1),
          ),
        ),
        Transform.translate(
          offset: Offset(9, 0),
          child: Container(
            width: _textSize(widget.label, const TextStyle(fontSize: 17, color: Color(0xFF242424))).width * 1.5,
            height: 5,
            color: error ? widget.errorBackgroundColor : widget.backgroundColor,
          ),
        ),
        Transform.translate(
          offset: Offset(16, -11),
          child: Container(
            color: Colors.transparent,
            child: Text(widget.label,
              style: const TextStyle(fontSize: 17, color: Color(0xFF242424)),
            ),
          ),
        )
      ],
    );
  }
}


