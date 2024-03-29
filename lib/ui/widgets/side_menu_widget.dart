import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';


enum SideMenuItemName { HOMESCREEN, FAQ, PASSENGERS, SUITES, NONE }

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.currentPageName,
    required this.showMenu
  });

  final SideMenuItemName currentPageName;
  final Function() showMenu;


  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  SideMenuItemName _currentPage = SideMenuItemName.NONE;

  @override
  void initState() {
    SideMenuItemName _currentPage = widget.currentPageName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      height: double.infinity,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //   topRight: Radius.circular(20),
        //   bottomRight: Radius.circular(20)
        // ),
        color: AppColors.backgroundMain3,
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            padding: EdgeInsets.only(left: 10, top: 60, bottom: 20),
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
          const SizedBox(height: 50),
          SizedBox(
            height: 350,
            child: ListView(
              children: [
                AppDrawerTile(
                    pageName: SideMenuItemName.HOMESCREEN,
                    currentPageName: _currentPage,
                    onTap: (){
                      setState(() {
                        print("Clicked!");
                        _currentPage = SideMenuItemName.HOMESCREEN;
                      });
                    },
                    icon: Icon(Icons.settings, color: AppColors.textMain),
                    name: "Настройки"
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(height: 20, color: AppColors.textFaded, thickness: 1)
                ),
                AppDrawerTile(
                    pageName: SideMenuItemName.SUITES,
                    currentPageName: _currentPage,
                    onTap: () async {
                      setState(() {
                        _currentPage = SideMenuItemName.SUITES;
                      });
                      widget.showMenu();
                      await Future.delayed(const Duration(milliseconds: 100));
                      context.pushNamed(
                          NavigationRoutes.seatManagerScreen.name
                      );
                      _currentPage = SideMenuItemName.NONE;
                    },
                    icon: Icon(Icons.hotel_rounded, color: AppColors.textMain),
                    name: "Номерной фонд"
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(height: 20, color: AppColors.textFaded, thickness: 1)
                ),
                AppDrawerTile(
                    pageName: SideMenuItemName.FAQ,
                    currentPageName: _currentPage,
                    onTap: () async {
                      setState(() {
                        _currentPage = SideMenuItemName.FAQ;
                      });
                      widget.showMenu();
                      await Future.delayed(const Duration(milliseconds: 100));
                      context.pushNamed(
                          NavigationRoutes.faqScreen.name
                      );
                      _currentPage = SideMenuItemName.NONE;
                    },
                    icon: Icon(Icons.help, color: AppColors.textMain),
                    name: "FAQ"
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawerTile extends StatelessWidget {
  const AppDrawerTile({
    required this.pageName,
    required this.currentPageName,
    required this.onTap,
    required this.icon,
    required this.name,
    super.key
  });

  final SideMenuItemName pageName;
  final SideMenuItemName currentPageName;
  final void Function() onTap;
  final Icon icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 56,
              width: currentPageName == pageName ? 288 : 0,
              decoration: BoxDecoration(
                  color: AppColors.backgroundMain5,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
          ),
          ListTile(
            leading: icon,
            title: Text(name.toUpperCase(), style: TextStyle(fontSize: 20, color: AppColors.textMain)),
          ),
        ],
      ),
    );
  }
}

class SideMenuBurger extends StatefulWidget {
  const SideMenuBurger({
    required this.isMenuOpen,
    required this.toggleMenu,
    super.key
  });

  final bool isMenuOpen;
  final Function() toggleMenu;
  @override
  State<SideMenuBurger> createState() => _SideMenuBurgerState();
}

class _SideMenuBurgerState extends State<SideMenuBurger> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: widget.toggleMenu,
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 15),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.textMain,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 8
              )
            ]
          ),
          child: widget.isMenuOpen ? Icon(Icons.close) : Icon(Icons.menu),
        ),
      ),
    );
  }
}
