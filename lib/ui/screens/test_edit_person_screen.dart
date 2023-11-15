import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class TestEditPersonScreen extends StatefulWidget {
  const TestEditPersonScreen({Key? key}) : super(key: key);

  @override
  State<TestEditPersonScreen> createState() => _TestEditPersonScreenState();
}

class _TestEditPersonScreenState extends State<TestEditPersonScreen> {

  final _lastnameFieldKey = GlobalKey<FormFieldState>();
  final _firstnameFieldKey = GlobalKey<FormFieldState>();

  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();

  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _firstnameFocus = FocusNode();

  bool isLastnameFieldHasError = false;
  bool isFirstnameFieldHasError = false;

  String? _validateLastnameField(String? lastname) {
    if (lastname == null || lastname.trim().isEmpty) {
      setState(() {
        isLastnameFieldHasError = true;
      });
      return "Поле не может быть пустым";
    } else {
      setState(() {
        isLastnameFieldHasError = false;
      });
      return null;
    }
  }

  String? _validateFirstnameField(String? firstname) {
    if (firstname == null || firstname.trim().isEmpty) {
      setState(() {
        isFirstnameFieldHasError = true;
      });
      return "Поле не может быть пустым";
    } else {
      setState(() {
        isFirstnameFieldHasError = false;
      });
      return null;
    }
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  final label = "Имя";
  final labelStyle = AppStyles.secondaryTextStyle;
  final fieldColor = const Color(0xFFC2C2C2);
  bool isEditing = false;

  @override
  void initState() {
    _firstnameController.text = "Иванова";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10),
          // color: AppColors.secondary1,
          child: Column(
            children: [
              SizedBox(height: 70,),
              Container(
                child: isEditing
                  ? TextFormField(
                      controller: _firstnameController,
                      focusNode: _firstnameFocus,
                      key: _firstnameFieldKey,
                      validator: _validateFirstnameField,
                      autovalidateMode: AutovalidateMode.disabled,
                      keyboardType: TextInputType.text,
                      cursorHeight: 25,
                      onEditingComplete: (){
                        // _onNextFieldFocus(context, _firstnameFocus, _middlenameFocus);
                        _firstnameFieldKey.currentState?.validate();
                      },
                      onTap: () {
                        if(isFirstnameFieldHasError) {
                          setState(() {
                            isFirstnameFieldHasError = false;
                          });
                        }
                      },
                      onTapOutside: (event) {
                        if(_firstnameFocus.hasFocus) {
                          _firstnameFocus.unfocus();
                        }
                      },
                      cursorColor: Color(0xFF000000),
                      style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        fillColor: isFirstnameFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: AppColors.backgroundMain4
                            )
                        ),
                        enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                        labelText: 'Имя',
                        labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                        focusColor: AppColors.accent5,
                      ),
                    )
                  : customTextField()
              ),
              SizedBox(height: 20,),

              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text("Edit"),
              )
            ],
          ),
        ),
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
            border: Border.all(width: 1, color: Color(0xFF000000)),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: fieldColor
          ),
          child: Text("Иванова",
            style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
          ),
        ),
        Transform.translate(
          offset: Offset(6, 0),
          child: Container(
            width: _textSize(label, labelStyle).width * 1.5,
            height: 5,
            color: fieldColor,
          ),
        ),
        Transform.translate(
          offset: Offset(15, -10),
          child: Container(
            color: Colors.transparent,
            child: Text("Имя",
              style: AppStyles.secondaryTextStyle,
            ),
          ),
        )
      ],
    );
  }
}
