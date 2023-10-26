import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {


  final TextEditingController _firstnameController = TextEditingController();
  final FocusNode _firstnameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundNeutral,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100,),
                TextFormField(
                  controller: _firstnameController,
                  focusNode: _firstnameFocus,
                  style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: AppColors.textMain,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: AppColors.accent1
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
                    labelText: 'Фамилия',
                    labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                    focusColor: AppColors.accent5,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
