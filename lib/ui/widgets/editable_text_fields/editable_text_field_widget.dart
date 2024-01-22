import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class EditableTextFieldWidget extends StatefulWidget {

  final String label;
  final String value;
  final String? errorMessage;
  final bool error;
  final Function(String) valueSetter;
  final Function(bool)? errorSetter;
  final bool Function()? validator;
  final Color backgroundColor;
  final Color accentColor;
  final Color borderColor;
  final Color errorBackgroundColor;
  final bool small;
  final TextInputType inputType;

  const EditableTextFieldWidget({
    required this.label,
    required this.value,
    required this.valueSetter,
    required this.error,
    void Function(bool)? this.errorSetter,
    bool Function()? this.validator,
    String? this.errorMessage,
    Color this.backgroundColor = const Color(0xFFEFEFEF),
    Color this.errorBackgroundColor = const Color(0xFFFFEAEA),
    Color this.accentColor = const Color(0xFFDEDEDE),
    Color this.borderColor = const Color(0xFF707070),
    bool this.small = false,
    TextInputType this.inputType = TextInputType.text,
    Key? key
  }) : super(key: key);

  @override
  State<EditableTextFieldWidget> createState() => _EditableTextFieldWidgetState();
}

class _EditableTextFieldWidgetState extends State<EditableTextFieldWidget> {

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusController = FocusNode();

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
  bool isEditing = false;
  bool error = false;

  @override
  void initState() {
    _textController.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: widget.small ? 34 : 48,
                  child: isEditing
                  ? TextFormField(
                  controller: _textController,
                  focusNode: _focusController,
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: widget.inputType,
                  cursorHeight: widget.small ? 20 : 25,
                  onChanged: widget.valueSetter,
                  cursorColor: Color(0xFF000000),
                  style: TextStyle(fontSize: widget.small ? 18 : 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: widget.small ? 0.0 : 2.0, horizontal: 15),
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
                    labelText: widget.label,
                    labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                )
                : customTextField()
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (isEditing) {
                      if (widget.validator != null && widget.errorSetter != null) {
                        final err = widget.validator!();
                        setState(() {
                          error = err;
                        });
                        widget.errorSetter!(err);
                      }
                    }
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: SizedBox(
                    width: widget.small ? 34 : 48,
                    height: widget.small ? 34 : 48,
                    child: Container(
                      margin: EdgeInsets.only(top: 1, bottom: 1, right: 1),
                      padding: EdgeInsets.all(widget.small ? 4 : 8),
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
              ? Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(widget.errorMessage ?? "Неккоректное значение",
                      style: const TextStyle(fontSize: 14, color: Color(0xFF5B0A0A),),
                      textAlign: TextAlign.start,
                    )
                  ),
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
          height: widget.small ? 34 : 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: Color(0xFF000000)),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: widget.error ? widget.errorBackgroundColor : widget.backgroundColor
          ),
          child: Text(_textController.text,
            style: TextStyle(fontSize: widget.small ? 18 : 24, color: const Color(0xFF000000), decoration: TextDecoration.none, height: 1),
          ),
        ),
        Transform.translate(
          offset: Offset(9, 0),
          child: Container(
            width: _textSize(widget.label, TextStyle(fontSize: 17, color: AppColors.labelColor1)).width * 1.5,
            height: 5,
            color: widget.error ? widget.errorBackgroundColor : widget.backgroundColor,
          ),
        ),
        Transform.translate(
          offset: Offset(16, -11),
          child: Container(
            color: Colors.transparent,
            child: Text(widget.label,
              style: TextStyle(fontSize: 17, color: AppColors.labelColor1),
            ),
          ),
        )
      ],
    );
  }
}


