import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class EditableDocumentTextFieldWidget extends StatefulWidget {

  final String label;
  final String valueName;
  final String valueNumber;
  final Function(String) valueNameSetter;
  final Function(String) valueNumberSetter;
  final Function(bool) errorSetter;
  final Color backgroundColor;
  final Color accentColor;
  final Color borderColor;
  final Color errorBackgroundColor;
  final TextInputType inputType;

  const EditableDocumentTextFieldWidget({
    required this.label,
    required this.valueName,
    required this.valueNumber,
    required this.valueNameSetter,
    required this.valueNumberSetter,
    required this.errorSetter,
    Color this.backgroundColor = const Color(0xFFEFEFEF),
    Color this.errorBackgroundColor = const Color(0xFFFFEAEA),
    Color this.accentColor = const Color(0xFFDEDEDE),
    Color this.borderColor = const Color(0xFF707070),
    TextInputType this.inputType = TextInputType.text,
    Key? key
  }) : super(key: key);

  @override
  State<EditableDocumentTextFieldWidget> createState() => _EditableDocumentTextFieldWidgetState();
}

class _EditableDocumentTextFieldWidgetState extends State<EditableDocumentTextFieldWidget> {

  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textNumberController = TextEditingController();
  final FocusNode _focusNameController = FocusNode();
  final FocusNode _focusNumberController = FocusNode();
  bool isEditing = false;
  bool error = false;

  void validate() {
    if(_textNameController.text.trim().isEmpty || _textNumberController.text.trim().isEmpty) {
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
    _textNameController.text = widget.valueName;
    _textNumberController.text = widget.valueNumber;
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
                        width: MediaQuery.of(context).size.width / 5 * 2 - 15,
                        child: TextFormField(
                          controller: _textNameController,
                          focusNode: _focusNameController,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: widget.inputType,
                          cursorHeight: 25,
                          onChanged: widget.valueNameSetter,
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
                            labelText: "Название",
                            labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                            focusColor: AppColors.accent5,
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width / 5 * 3 - 15,
                        child: TextFormField(
                          controller: _textNumberController,
                          focusNode: _focusNumberController,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: widget.inputType,
                          cursorHeight: 25,
                          onChanged: widget.valueNumberSetter,
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
                            labelText: "Номер",
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
                child: const Text("Название и документа номер должны быть заполнены",
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
          child: Text("${_textNameController.text} ${_textNumberController.text}",
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


