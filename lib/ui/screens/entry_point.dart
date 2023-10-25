import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/homescreen.dart';
import 'package:pleyona_app/ui/widgets/side_menu_widget.dart';

import '../widgets/passenger_options_sliver.dart';


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {


  final pageName = SideMenuItemName.HOMESCREEN;
  bool isMenuOpen = true;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: AppColors.backgroundNeutral,
                child: HomeScreen()
              ),
              isMenuOpen ? SideMenu(currentPageName: pageName, showMenu: toggleMenu) : SizedBox.shrink(),
              SideMenuBurger(isMenuOpen: isMenuOpen, toggleMenu: toggleMenu),
            ],
          ),
        ),
      ),
    );
  }
}



