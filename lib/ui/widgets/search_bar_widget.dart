import 'package:flutter/material.dart';

import '../../theme.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.callback,
    required this.label,
    Key? key
  }) : super(key: key);

  final Function(String) callback;
  final String label;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _controller,
        focusNode: focus,
        onChanged: widget.callback,
        onTapOutside: (event) {
          if (focus.hasFocus) {
            focus.unfocus();
          }
        },
        cursorHeight: 18,
        style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2, height: 20/18, fontWeight: FontWeight.w300),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          filled: true,
          fillColor: focus.hasFocus ? Color(0xfff3f3f3) : Color(0xFFF5F5F5),
          suffixIcon: _controller.text.isEmpty ? Icon(Icons.search,
            color: focus.hasFocus ? Colors.blue : Colors.grey,
          ) : GestureDetector(
              onTap: () {
                _controller.text = "";
                widget.callback("");
                setState(() {});
              },
              child: Icon(Icons.close)
          ),
          labelText: widget.label,
          labelStyle: TextStyle(fontSize: 20, color: AppColors.textFaded),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                  color: Colors.transparent
              )
          ),
          enabledBorder:  const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(
              color: Colors.transparent
            )
          ),
        ),
      ),
    );
  }
}
