import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/navigation/navigation.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  const CustomAppBar({
    required this.child,
    required this.scrollController,
    this.height = 55,
    this.leadingWidth = 50,
    this.hideHomeButton = false,
    Key? key
  }) : super(key: key);

  final Widget? child;
  final double height;
  final double leadingWidth;
  final ScrollController? scrollController;
  final bool hideHomeButton;

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
      if(scrollController.offset > 50) {
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
      leading: Navigator.of(context).canPop() ? GestureDetector(
        onTap: () {
          isBackArrowHidden ? () {} : Navigator.of(context).maybePop();
        },
        child: AnimatedOpacity(
          opacity: isBackArrowHidden ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/icons/back-arrow.png",
              width: 30, height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ) : const SizedBox.shrink(),
      actions: [
        widget.hideHomeButton ? const SizedBox(width: 30, height: 30) : GestureDetector(
          onTap: () {
            context.goNamed(
                NavigationRoutes.homeScreen.name
            );
          },
          child: AnimatedOpacity(
            opacity: isBackArrowHidden ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
              child: Image.asset("assets/icons/homescreen_icon.png",
                width: 30, height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
      title: AnimatedOpacity(
        opacity: isBackArrowHidden ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: Center(
          child: Transform.translate(
            offset: Offset(0, 10),
            child: widget.child
          ),
        ),
      )
    );
  }
}
