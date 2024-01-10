import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';



List<String> getDestinationCityOptions() {
  return ["Владивосток", "Нанао"];
}

List<String> getShipsOptions() {
  return ["Плейона", "Афина"];
}

String dateToFullDateString(DateTime date) {
  String hour = "";
  String minute = "";
  String day = "";
  String month = "";
  String year = "";

  if (date.hour < 10) {
    hour = "0${date.hour}";
  } else {
    hour = "${date.hour}";
  }

  if (date.minute < 10) {
    minute = "0${date.minute}";
  } else {
    minute = "${date.minute}";
  }

  if (date.day < 10) {
    day = "0${date.day}";
  } else {
    day = "${date.day}";
  }

  if (date.month < 10) {
    month = "0${date.month}";
  } else {
    month = "${date.month}";
  }

  year = "${date.year}";

  return "$day.$month.$year  $hour:$minute";
}

String dateToTimeString(DateTime date) {
  String hour = "";
  String minute = "";

  if (date.hour < 10) {
    hour = "0${date.hour}";
  } else {
    hour = "${date.hour}";
  }

  if (date.minute < 10) {
    minute = "0${date.minute}";
  } else {
    minute = "${date.minute}";
  }

  return "$hour:$minute";
}

String dateToDateString(DateTime date) {
  String day = "";
  String month = "";
  String year = "";

  if (date.day < 10) {
    day = "0${date.day}";
  } else {
    day = "${date.day}";
  }

  if (date.month < 10) {
    month = "0${date.month}";
  } else {
    month = "${date.month}";
  }

  year = "${date.year}";

  return "$day.$month.$year";
}

