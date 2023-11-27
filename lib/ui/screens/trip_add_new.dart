import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets/custom_appbar.dart';

class TripAddNewScreen extends StatefulWidget {
  const TripAddNewScreen({super.key});

  @override
  State<TripAddNewScreen> createState() => _TripAddNewScreenState();
}

class _TripAddNewScreenState extends State<TripAddNewScreen> {

  late final ScrollController _scrollController;
  final Color focusedBorderColor = AppColors.backgroundMain4;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController commentTextController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(scrollController: _scrollController, child: null,),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
          children: [
            SizedBox(height: 10,),
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
                labelText: 'Название рейса',
                labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                focusColor: AppColors.accent5,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
