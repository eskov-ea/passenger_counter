import 'package:flutter/material.dart';
import '../../../theme.dart';


class PersonDocumentInfoBlock extends StatelessWidget {
  const PersonDocumentInfoBlock({
    required this.documentNameFieldKey,
    required this.documentNumberFieldKey,
    required this.documentNameFieldController,
    required this.documentNumberFieldController,
    required this.citizenshipFieldController,
    required this.documentNameFieldFocus,
    required this.documentNumberFieldFocus,
    required this.citizenshipFieldFocus,
    required this.validateDocumentFields,
    required this.validateDocumentNameField,
    required this.isDocumentNumberFieldHasError,
    required this.isDocumentNameFieldHasError,

    required this.onNextFieldFocus,
    required this.setFieldErrorValue,
    required this.focusedBorderColor,
    required this.documentInputFieldsErrorMessage,
    Key? key
  }) : super(key: key);

  final GlobalKey<FormFieldState> documentNameFieldKey;
  final GlobalKey<FormFieldState> documentNumberFieldKey;

  final TextEditingController documentNameFieldController;
  final TextEditingController documentNumberFieldController;
  final TextEditingController citizenshipFieldController;

  final FocusNode documentNameFieldFocus;
  final FocusNode documentNumberFieldFocus;
  final FocusNode citizenshipFieldFocus;

  final bool isDocumentNameFieldHasError;
  final bool isDocumentNumberFieldHasError;

  final validateDocumentFields;
  final validateDocumentNameField;

  final Color focusedBorderColor;
  final String? documentInputFieldsErrorMessage;
  final Function(BuildContext, FocusNode, FocusNode) onNextFieldFocus;
  final Function(String, bool) setFieldErrorValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextFormField(
                  controller: documentNameFieldController,
                  focusNode: documentNameFieldFocus,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.text,
                  cursorHeight: 25,
                  onEditingComplete: (){
                    onNextFieldFocus(context, documentNameFieldFocus, documentNumberFieldFocus);
                    validateDocumentNameField();
                  },
                  onTap: () {
                    if(isDocumentNameFieldHasError) {
                      setFieldErrorValue("document_name", false);
                    }
                  },
                  onTapOutside: (event) {
                    if(documentNameFieldFocus.hasFocus) {
                      documentNameFieldFocus.unfocus();
                    }
                  },
                  cursorColor: Color(0xFF000000),
                  style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: isDocumentNameFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
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
                    labelText: 'Документ',
                    labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFormField(
                  controller: documentNumberFieldController,
                  focusNode: documentNumberFieldFocus,
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.number,
                  cursorHeight: 25,
                  onEditingComplete: (){
                    onNextFieldFocus(context, documentNumberFieldFocus, citizenshipFieldFocus);
                    validateDocumentFields();
                  },
                  onTap: () {
                    if(isDocumentNumberFieldHasError) {
                      setFieldErrorValue("document_number", false);
                    }
                  },
                  onTapOutside: (event) {
                    if(documentNumberFieldFocus.hasFocus) {
                      documentNumberFieldFocus.unfocus();
                    }
                  },
                  cursorColor: Color(0xFF000000),
                  style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: isDocumentNumberFieldHasError ? AppColors.errorFieldFillColor : AppColors.textMain,
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
                    labelText: 'Номер',
                    labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: citizenshipFieldController,
                focusNode: citizenshipFieldFocus,
                autovalidateMode: AutovalidateMode.disabled,
                keyboardType: TextInputType.text,
                cursorHeight: 25,
                onEditingComplete: (){
                  citizenshipFieldFocus.unfocus();
                },
                onTapOutside: (event) {
                  if(citizenshipFieldFocus.hasFocus) {
                    citizenshipFieldFocus.unfocus();
                  }
                },
                cursorColor: Color(0xFF000000),
                style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
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
                  labelText: 'Гражданство',
                  labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                  focusColor: AppColors.accent5,
                ),
              ),
            ),
          ),
          documentInputFieldsErrorMessage != null ? SizedBox(
            width: MediaQuery.of(context).size.width ,
            child: Text(documentInputFieldsErrorMessage!,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: AppColors.errorMain),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
