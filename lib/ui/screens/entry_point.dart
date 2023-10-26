import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/homescreen.dart';
import 'package:pleyona_app/ui/screens/passenger_details_screen.dart';
import 'package:pleyona_app/ui/widgets/side_menu_widget.dart';


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> with SingleTickerProviderStateMixin {


  late AnimationController _animationController;
  late Animation animation;
  late Animation scaleAnimation;
  final pageName = SideMenuItemName.HOMESCREEN;
  bool isMenuOpen = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 180)
    )..addListener(() {
      setState(() {

      });
    });
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleMenu() {
    if(isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain3,
      extendBody: true,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 180),
                curve: Curves.fastOutSlowIn,
                width: 288,
                left: isMenuOpen ? 0 : -288,
                height: MediaQuery.of(context).size.height,
                child: SideMenu(currentPageName: pageName, showMenu: toggleMenu)
              ),
              Transform.translate(
                offset: Offset(animation.value * 288, 0),
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(isMenuOpen ? 20 : 0)),
                    child: HomeScreen()
                  )
                )
              ),
              // isMenuOpen ? SideMenu(currentPageName: pageName, showMenu: toggleMenu) : SizedBox.shrink(),
              SideMenuBurger(isMenuOpen: isMenuOpen, toggleMenu: toggleMenu),
            ],
          ),
        ),
      ),
    );
  }
}



