import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pleyona_app/navigation/navigation.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  const CustomAppBar({
    required this.child,
    required this.scrollController,
    this.height = 40,
    this.leadingWidth = 50,
    Key? key
  }) : super(key: key);

  final Widget? child;
  final double height;
  final double leadingWidth;
  final ScrollController? scrollController;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {

  bool isBackArrowHidden = false;

  void setupScrollListener({
    required ScrollController scrollController, Function? onAtTop
  }) {
    scrollController.addListener(() {
      if(scrollController.offset > 250) {
        _hideBackArrow(true);
      } else {
        _hideBackArrow(false);
      }
    });
  }

  void _hideBackArrow(bool value) async{
    setState(() {
      isBackArrowHidden = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    if (widget.scrollController != null) {
      setupScrollListener(scrollController: widget.scrollController!);
    }
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: widget.leadingWidth,
      toolbarHeight: widget.height,
      backgroundColor: const Color(0x00FFFFFF),
      shadowColor: const Color(0x00FFFFFF),
      surfaceTintColor: const Color(0x00FFFFFF),
      foregroundColor: const Color(0x00FFFFFF),
      forceMaterialTransparency: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        // statusBarColor: isBackArrowHidden ? Colors.transparent : Colors.black,
      ),
      leading: GestureDetector(
        onTap: () {
          isBackArrowHidden ? () {} : Navigator.of(context).maybePop();
        },
        child: AnimatedOpacity(
          opacity: isBackArrowHidden ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Image.asset("assets/icons/back-arrow.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.homeScreen);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: Image.asset("assets/icons/homescreen_icon.png",
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
      title: widget.child
    );
  }
}
