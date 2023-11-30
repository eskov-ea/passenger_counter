import 'package:flutter/material.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';



class PassengerAddNewScreen extends StatefulWidget {
  const PassengerAddNewScreen({super.key});

  @override
  State<PassengerAddNewScreen> createState() => _PassengerAddNewScreenState();
}

class _PassengerAddNewScreenState extends State<PassengerAddNewScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(child: null, scrollController: null),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [

              ],
            ),
          ),
        ),
      ),
    );
  }
}
