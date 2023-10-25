import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/side_menu_widget.dart';
import 'package:rive/rive.dart';


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {


  final pageName = SideMenuItemName.HOMESCREEN;
  bool isMenuOpen = false;

  void openMenu() {
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
                child: Center(
                  child: Text("Hello World!", style: TextStyle(fontSize: 60),),
                )
              ),
              isMenuOpen ? SideMenu(currentPageName: pageName, showMenu: openMenu) : SizedBox.shrink(),
              !isMenuOpen ? SideMenuBurger(showMenu: openMenu) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}



