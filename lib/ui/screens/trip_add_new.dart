import 'package:flutter/material.dart';

class TripAddNewScreen extends StatefulWidget {
  const TripAddNewScreen({super.key});

  @override
  State<TripAddNewScreen> createState() => _TripAddNewScreenState();
}

class _TripAddNewScreenState extends State<TripAddNewScreen> {

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController commentTextController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode commentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          constraints: BoxConstraints.loose(Size(100, 100)),
          child:  Container(
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
