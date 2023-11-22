import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class EditableCommentFieldWidget extends StatefulWidget {

  final String value;
  final Function(String) valueSetter;
  final Color backgroundColor;
  final Color accentColor;
  final Color borderColor;

  const EditableCommentFieldWidget({
    required this.value,
    required this.valueSetter,
    Color this.backgroundColor = const Color(0xFFEFEFEF),
    Color this.accentColor = const Color(0xFFDEDEDE),
    Color this.borderColor = const Color(0xFF707070),
    Key? key
  }) : super(key: key);

  @override
  State<EditableCommentFieldWidget> createState() => _EditableCommentFieldWidgetState();
}

class _EditableCommentFieldWidgetState extends State<EditableCommentFieldWidget> {

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusController = FocusNode();

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
  bool isEditing = false;

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
                  height: 100,
                  child: isEditing
                      ? TextField(
                    controller: _textController,
                    focusNode: _focusController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    cursorHeight: 25,
                    onChanged: widget.valueSetter,
                    cursorColor: Color(0xFF000000),
                    style: TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15.0, left: 15, bottom: 10, right: 53),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: const Color(0xFFFFFFFF),
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
                      labelText: "Комментарий",
                      labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                      focusColor: AppColors.accent5,
                    ),
                    maxLines: null,
                    minLines: 3,
                  )
                      : customTextField()
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: SizedBox(
                    width: 48,
                    height: 100,
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
        ],
      ),
    );
  }

  Widget customTextField() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          padding: EdgeInsets.only(right: 53, left: 15, top: 15, bottom: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: Color(0xFF000000)),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: widget.backgroundColor
          ),
          child: SingleChildScrollView(
            child: Text(_textController.text,
              style: TextStyle(fontSize: 24, color: const Color(0xFF000000), decoration: TextDecoration.none, height: 1),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(9, 0),
          child: Container(
            width: _textSize("Комментарий", const TextStyle(fontSize: 17, color: Color(0xFF242424))).width * 1.5,
            height: 5,
            color: widget.backgroundColor,
          ),
        ),
        Transform.translate(
          offset: Offset(16, -11),
          child: Container(
            color: Colors.transparent,
            child: Text("Комментарий",
              style: const TextStyle(fontSize: 17, color: Color(0xFF242424)),
            ),
          ),
        )
      ],
    );
  }
}


