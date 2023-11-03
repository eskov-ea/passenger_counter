import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class Suite extends StatefulWidget {
  const Suite({super.key});

  @override
  State<Suite> createState() => _SuiteState();
}

class _SuiteState extends State<Suite> {

  final List<Widget> beds = ["A", "B", "C", "D"].map((e) => Container(
      width: 30,
      height: 30,
      color: AppColors.errorFieldFillColor,
      child: Center(
        child: Text(
          e.toString(), style: TextStyle(fontSize: 20, color: AppColors.accent5),
        ),
      ),
    )
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.backgroundNeutral,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text("202",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2, fontWeight: FontWeight.w600),
          ),
          Divider(),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
              ),
              children: beds,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
