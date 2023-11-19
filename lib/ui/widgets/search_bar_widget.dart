import 'package:flutter/material.dart';

import '../../theme.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({
    required this.callback,
    required this.label,
    Key? key
  }) : super(key: key);

  final Function(String) callback;
  final String label;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _controller,
        onChanged: callback,
        style: AppStyles.submainTitleTextStyle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          filled: true,
          fillColor: Color(0xFFEAEAEA),
          suffixIcon: Icon(Icons.search),
          labelText: label,
          labelStyle: TextStyle(fontSize: 20, color: AppColors.textFaded),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                  color: AppColors.backgroundMain4
              )
          ),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: Colors.transparent
            )
          ),
        ),
      ),
    );
  }
}
