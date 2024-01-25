import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/test_animated.dart';
import 'package:pleyona_app/ui/screens/trip/all_trips_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_edit_info_screen.dart';
import 'package:pleyona_app/ui/screens/homescreen.dart';
import 'package:pleyona_app/ui/screens/passenger_add_new.dart';
import 'package:pleyona_app/ui/screens/person/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_search_screen.dart';
import 'package:pleyona_app/ui/screens/route_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/suites_manager_screen.dart';
import 'package:pleyona_app/ui/widgets/editable_text_fields/editable_text_field_widget.dart';
import 'package:pleyona_app/ui/widgets/side_menu_widget.dart';

import '../../models/mock_data/passenger_status_mock.dart';
import '../widgets/theme_background.dart';


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
  double _menuXPositionCoef = 0;
  double _dxStartScrollPosition = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    )..addListener(() {
      setState(() {
        _menuXPositionCoef = animation.value;
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
      backgroundColor: Color(0xFFD6E6FD),
      extendBody: true,
      body: SafeArea(
        child: ThemeBackgroundWidget(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: isMenuOpen ? 1 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0x40000000),
                  ),
                ),
                Transform.translate(
                    offset: Offset(_menuXPositionCoef * 288, 0),
                    child: Transform.scale(
                        scale: scaleAnimation.value,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(isMenuOpen ? 20 : 0)),
                            child: const ThemeBackgroundWidget(
                              child: HomeScreen(),
                            )
                        )
                    )
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  width: 288,
                  left: isMenuOpen ? 0 : -288,
                  height: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                    onHorizontalDragStart: (details) {
                      _dxStartScrollPosition = details.localPosition.dx;
                    },
                    onHorizontalDragUpdate: (details)  {
                      if (_dxStartScrollPosition - details.localPosition.dx > 40.0) {
                        toggleMenu();
                        _dxStartScrollPosition = 0.0;
                      }
                    },
                    child: SideMenu(currentPageName: pageName, showMenu: toggleMenu)
                  )
                ),
                SideMenuBurger(isMenuOpen: isMenuOpen, toggleMenu: toggleMenu),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



