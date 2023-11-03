import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/suite_widget.dart';


class SuitesManagerScreen extends StatefulWidget {
  const SuitesManagerScreen({super.key});

  @override
  State<SuitesManagerScreen> createState() => _SuitesManagerScreenState();
}

class _SuitesManagerScreenState extends State<SuitesManagerScreen> {

  List _suites = [202, 203];
  List _beds = ["202A"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Назначить каюты на рейс".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppStyles.mainTitleTextStyle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Выбрано на рейс: 43 места",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18, color: AppColors.backgroundMain2
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width - 20,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.backgroundMain2),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.textMain
                ),
                // child: Suite(),
              ),
              Suite()
            ],
          ),
        ),
      )
    );
  }
}
