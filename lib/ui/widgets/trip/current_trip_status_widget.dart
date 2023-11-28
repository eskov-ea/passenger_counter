import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class CurrentTripStatusWidget extends StatefulWidget {
  const CurrentTripStatusWidget({super.key});

  @override
  State<CurrentTripStatusWidget> createState() => _CurrentTripStatusWidgetState();
}

class _CurrentTripStatusWidgetState extends State<CurrentTripStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.backgroundMainCard,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: InkWell(
          onTap: () {},
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          splashColor: AppColors.backgroundMain5,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 300,
            width: MediaQuery.of(context).size.width,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text.rich(
                  TextSpan(
                    text: "Направление: ",
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: "Владивосток - Нанао",
                        style: TextStyle(fontSize: 22, color: AppColors.textMain),
                      )
                    ]
                  )
                ),
                Text.rich(
                    TextSpan(
                        text: "Дата: ",
                        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: "27.11.2023",
                            style: TextStyle(fontSize: 22, color: AppColors.textMain),
                          )
                        ]
                    )
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: AppColors.textFaded,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5 -30,
                        child: Text(
                          "На борту:".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: AppColors.textMain)
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5 -30,
                        child: Text(
                            "Зарег-но:".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, color: AppColors.textMain)
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5 -30,
                        child: Text(
                            "33".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 72, color: AppColors.textMain)
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5 -30,
                        child: Text(
                            "41".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 48, color: AppColors.textMain)
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                    TextSpan(
                        text: "Сошли с судна: ",
                        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: "8",
                            style: TextStyle(fontSize: 22, color: AppColors.textMain),
                          )
                        ]
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
