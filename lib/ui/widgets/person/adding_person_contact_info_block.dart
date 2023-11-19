import 'package:flutter/material.dart';
import '../../../theme.dart';

class PersonContactInfoBlock extends StatelessWidget {
  const PersonContactInfoBlock({
    required this.phoneFieldController,
    required this.emailFieldController,
    required this.phoneFieldFocus,
    required this.emailFieldFocus,

    required this.onNextFieldFocus,
    required this.focusedBorderColor,
    Key? key
  }) : super(key: key);

  final TextEditingController phoneFieldController;
  final TextEditingController emailFieldController;
  final FocusNode phoneFieldFocus;
  final FocusNode emailFieldFocus;

  final Color focusedBorderColor;
  final Function(BuildContext, FocusNode, FocusNode) onNextFieldFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: phoneFieldController,
                  focusNode: phoneFieldFocus,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.phone,
                  cursorHeight: 25,
                  onEditingComplete: (){
                    onNextFieldFocus(context, phoneFieldFocus, emailFieldFocus);
                  },
                  onTapOutside: (event) {
                    if(phoneFieldFocus.hasFocus) {
                      phoneFieldFocus.unfocus();
                    }
                  },
                  cursorColor: Color(0xFF000000),
                  style: const TextStyle(fontSize: 18, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: AppColors.textMain,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            color: focusedBorderColor
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
                    labelText: 'Телефон',
                    labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: emailFieldController,
                  focusNode: emailFieldFocus,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.emailAddress,
                  cursorHeight: 25,
                  onTapOutside: (event) {
                    if(emailFieldFocus.hasFocus) {
                      emailFieldFocus.unfocus();
                    }
                  },
                  cursorColor: Color(0xFF000000),
                  style: const TextStyle(fontSize: 18, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: AppColors.textMain,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            color: focusedBorderColor
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
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
