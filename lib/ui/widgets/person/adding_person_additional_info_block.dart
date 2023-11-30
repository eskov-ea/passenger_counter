import 'package:flutter/material.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/ui/screens/person/person_search_screen.dart';
import '../../../theme.dart';


class PersonAdditionalInfoBlock extends StatelessWidget {
  const PersonAdditionalInfoBlock({
    required this.commentTextController,
    required this.commentFieldFocus,
    required this.focusedBorderColor,
    Key? key
  }) : super(key: key);

  final TextEditingController commentTextController;
  final FocusNode commentFieldFocus;
  final Color focusedBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: commentTextController,
            focusNode: commentFieldFocus,
            onTapOutside: (event) {
              if(commentFieldFocus.hasFocus) {
                commentFieldFocus.unfocus();
              }
            },
            decoration: InputDecoration(
              label: Text("Добавить комментарий", style: AppStyles.submainTitleTextStyle,),
              contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0, right: 15.0),
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
            ),
            style: AppStyles.secondaryTextStyle,
            maxLines: null,
            minLines: 3,
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(MainNavigationRouteNames.searchPersonScreen,
              arguments: SearchPersonScreenArguments(callback: (){}));
            },
            child: Row(
              children: [
                Text("Привязать к родителю",
                  style: TextStyle(
                    fontSize: 20, color: AppColors.backgroundMain2,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline
                  ),
                ),
                SizedBox(width: 5,),
                Icon(Icons.person, size: 20,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
