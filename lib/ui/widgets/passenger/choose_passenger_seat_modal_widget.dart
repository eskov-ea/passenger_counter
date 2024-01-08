import 'package:flutter/material.dart';

Future<void> ChoosePassengerSeatModalWidget(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Выберите место"),
        content: Container(),
      );
    }
  );
}