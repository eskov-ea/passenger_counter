import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class InputDateToSearchWidget extends StatefulWidget {
  const InputDateToSearchWidget({super.key});

  @override
  State<InputDateToSearchWidget> createState() => _InputDateToSearchWidgetState();
}

class _InputDateToSearchWidgetState extends State<InputDateToSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 60,
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
                label: Text("DD", style: TextStyle(fontSize: 20, color: AppColors.textSecondary),),

              ),
              cursorColor: AppColors.textMain,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: Text(".",
              style: TextStyle(fontSize: 50, color: AppColors.textMain)
            ),
          ),
          SizedBox(
            width: 60,
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
                label: Text("MM", style: TextStyle(fontSize: 20, color: AppColors.textSecondary),),

              ),
              cursorColor: AppColors.textMain,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: Text(".",
                style: TextStyle(fontSize: 50, color: AppColors.textMain)
            ),
          ),
          SizedBox(
            width: 120,
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
          SizedBox(width: 20,),
          Ink(
            width: 60,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.textMain,
                width: 1
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0x76FFFFFF)
            ),
            child: InkWell(
              highlightColor: AppColors.accent1,
              child: Center(
                child: Text("OK",
                  style: TextStyle(fontSize: 20, color: AppColors.textMain),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
