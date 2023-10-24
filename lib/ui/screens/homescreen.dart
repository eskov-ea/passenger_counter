import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 288,
          height: double.infinity,
          color: AppColors.backgroundMain3,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                child: ListTile(
                  leading: Icon(Icons.person, color: AppColors.textSecondary,),
                  title: Text("USERNAME", style: TextStyle(
                    fontSize: 24, color: AppColors.textMain
                  ),),
                  subtitle: Text("pleyona@easttour.ru", style: TextStyle(
                    fontSize: 16, color: AppColors.textSecondary
                  ),),
                ),
              ),
              SideMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget SideMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Настройки"),
      ),
    );
  }
}
